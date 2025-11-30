import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../providers/registration_provider.dart';
import '../../../services/course_category_service.dart';
import '../../../services/event_service.dart';
import '../../../services/registration_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import '../../registrations/presentation/my_registrations_screen.dart';
import '../../schedule/presentation/event_details_screen.dart';

// Provider for all events
final coursesProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, key) async {
  final eventService = EventService();
  // Parse filters from key: "page|limit|search|type"
  final parts = key.split('|');
  final page = int.tryParse(parts[0]) ?? 1;
  final limit = int.tryParse(parts[1]) ?? 100;
  final search = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;
  final type = parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null;

  return await eventService.getEvents(
    page: page,
    limit: limit,
    conferenceId: null,
    type: type,
    search: search,
  );
});

// Provider for course categories
final courseCategoriesProvider = FutureProvider<List<CourseCategoryModel>>((ref) async {
  final categoryService = CourseCategoryService();
  return await categoryService.getCategories(activeOnly: true);
});

// View Mode Enum
enum ViewMode {
  grid,
  list,
  compact,
}

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> with SingleTickerProviderStateMixin {
  String? _searchQuery;
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  int _currentTabIndex = 0;
  List<String> _availableTypes = [];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  ViewMode _viewMode = ViewMode.grid;
  final Map<String, bool> _processingRegistrations = {};

  final Map<String, String> _eventTypeLabels = {
    'COURSE': 'دورات',
    'SEMINAR': 'ندوات',
    'WORKSHOP': 'ورش عمل',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.hasClients && _scrollController.offset > 10;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTabController(List<String> availableTypes) {
    final needsUpdate = _availableTypes.toString() != availableTypes.toString() || 
        (availableTypes.length > 1 && _tabController == null) ||
        (availableTypes.length <= 1 && _tabController != null);
    
    if (needsUpdate && mounted) {
      final oldIndex = _currentTabIndex;
      _tabController?.dispose();
      if (availableTypes.length > 1) {
        _tabController = TabController(length: availableTypes.length, vsync: this);
        _tabController!.addListener(() {
          if (!_tabController!.indexIsChanging && mounted) {
            setState(() {
              _currentTabIndex = _tabController!.index;
              _selectedCategoryId = null;
            });
          }
        });
        _availableTypes = availableTypes;
        if (oldIndex >= availableTypes.length) {
          _currentTabIndex = 0;
        } else {
          _currentTabIndex = oldIndex;
        }
      } else {
        _tabController = null;
        _availableTypes = availableTypes;
        _currentTabIndex = 0;
      }
      setState(() {});
    }
  }

  List<EventModel> _filterEventsByStatus(List<EventModel> events) {
    return events.where((event) {
      final status = event.status?.toUpperCase();
      return status != null &&
          (status == 'SETUP' ||
              status == 'REGISTRATION_OPEN' ||
              status == 'ONGOING');
    }).toList();
  }

  List<EventModel> _filterEventsByCategory(List<EventModel> events, String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return events;
    return events.where((event) => event.categoryId == categoryId).toList();
  }

  List<String> _getAvailableEventTypes(List<EventModel> allEvents) {
    final types = <String>{};
    for (var event in allEvents) {
      if (event.type != null && _eventTypeLabels.containsKey(event.type)) {
        types.add(event.type!);
      }
    }
    final order = ['COURSE', 'SEMINAR', 'WORKSHOP'];
    return order.where((type) => types.contains(type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final providerKey = '1|100|${_searchQuery ?? ''}|';
    final coursesAsync = ref.watch(coursesProvider(providerKey));
    final categoriesAsync = ref.watch(courseCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: coursesAsync.when(
        data: (data) {
          final allEvents = (data['data'] as List<EventModel>);
          final filteredByStatus = _filterEventsByStatus(allEvents);
          final availableTypes = _getAvailableEventTypes(filteredByStatus);

          _updateTabController(availableTypes);

          if (filteredByStatus.isEmpty) {
            return Scaffold(
              appBar: _buildCompactAppBar(),
              body: _buildEmptyState(),
            );
          }

          if (_tabController != null && availableTypes.length > 1) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  _buildSliverAppBar(availableTypes),
                  _buildSliverTabs(availableTypes),
                  if (availableTypes.isNotEmpty &&
                      _currentTabIndex < availableTypes.length &&
                      availableTypes[_currentTabIndex] == 'COURSE')
                    _buildSliverCategoryFilter(categoriesAsync),
                  _buildSliverViewModeSelector(),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: availableTypes.map((type) {
                  var filteredEvents = filteredByStatus.where((e) => e.type == type).toList();
                  if (type == 'COURSE') {
                    filteredEvents = _filterEventsByCategory(filteredEvents, _selectedCategoryId);
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      // Invalidate providers to force refresh
                      ref.invalidate(coursesProvider(providerKey));
                      ref.invalidate(courseCategoriesProvider);
                      
                      // Wait for providers to refresh
                      final refreshedData = await ref.read(coursesProvider(providerKey).future);
                      await ref.read(courseCategoriesProvider.future);
                      
                      // Refresh registration status for all displayed events
                      final refreshedEvents = (refreshedData['data'] as List<EventModel>);
                      final eventsToRefresh = refreshedEvents.where((e) => e.type == type).toList();
                      if (type == 'COURSE') {
                        final categoryFiltered = _filterEventsByCategory(eventsToRefresh, _selectedCategoryId);
                        for (final event in categoryFiltered) {
                          ref.invalidate(eventRegistrationStatusProvider(event.id));
                        }
                      } else {
                        for (final event in eventsToRefresh) {
                          ref.invalidate(eventRegistrationStatusProvider(event.id));
                        }
                      }
                    },
                    child: _buildEventsView(context, filteredEvents),
                  );
                }).toList(),
              ),
            );
          } else {
            var filteredEvents = availableTypes.length <= 1
                ? (availableTypes.isNotEmpty && availableTypes.first == 'COURSE'
                    ? _filterEventsByCategory(filteredByStatus, _selectedCategoryId)
                    : filteredByStatus)
                : filteredByStatus;
            
            return RefreshIndicator(
              onRefresh: () async {
                // Invalidate providers to force refresh
                ref.invalidate(coursesProvider(providerKey));
                ref.invalidate(courseCategoriesProvider);
                
                // Wait for providers to refresh
                final refreshedData = await ref.read(coursesProvider(providerKey).future);
                await ref.read(courseCategoriesProvider.future);
                
                // Refresh registration status for all displayed events
                final refreshedEvents = (refreshedData['data'] as List<EventModel>);
                final refreshedFiltered = _filterEventsByStatus(refreshedEvents);
                final eventsToRefresh = availableTypes.length <= 1
                    ? (availableTypes.isNotEmpty && availableTypes.first == 'COURSE'
                        ? _filterEventsByCategory(refreshedFiltered, _selectedCategoryId)
                        : refreshedFiltered)
                    : refreshedFiltered;
                
                for (final event in eventsToRefresh) {
                  ref.invalidate(eventRegistrationStatusProvider(event.id));
                }
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(availableTypes),
                  if (availableTypes.isNotEmpty && availableTypes.first == 'COURSE')
                    _buildSliverCategoryFilter(categoriesAsync),
                  _buildSliverViewModeSelector(),
                  if (filteredEvents.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else
                    _buildSliverEventsList(filteredEvents),
                ],
              ),
            );
          }
        },
        loading: () => Scaffold(
          appBar: _buildCompactAppBar(),
          body: _buildLoadingState(),
        ),
        error: (error, stack) => Scaffold(
          appBar: _buildCompactAppBar(),
          body: _buildErrorState(error, providerKey),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCompactAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ).createShader(bounds),
        child: const Text(
          'الفعاليات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 50,
    );
  }

  Widget _buildSliverAppBar(List<String> availableTypes) {
    return SliverAppBar(
      expandedHeight: 80,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      floating: false,
        elevation: 0,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        title: Container(
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
            child: TextField(
              controller: _searchController,
            style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
              hintText: 'ابحث في الفعاليات...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.primary,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.isEmpty ? null : value;
                });
              },
            ),
          ),
        centerTitle: false,
      ),
    );
  }

  Widget _buildSliverTabs(List<String> availableTypes) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          tabs: availableTypes.map((type) {
            final index = availableTypes.indexOf(type);
            final isSelected = _currentTabIndex == index;
            return Tab(
              height: 36,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? null
                      : Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                  _eventTypeLabels[type] ?? type,
                          style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: availableTypes.length > 2,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
                    ),
                  );
                }

  Widget _buildSliverCategoryFilter(AsyncValue<List<CourseCategoryModel>> categoriesAsync) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverCategoryFilterDelegate(
        categoriesAsync: categoriesAsync,
        selectedCategoryId: _selectedCategoryId,
        onCategorySelected: (categoryId) {
          setState(() {
            _selectedCategoryId = categoryId;
          });
        },
      ),
    );
  }

  Widget _buildSliverViewModeSelector() {
    return SliverPersistentHeader(
      pinned: false,
      delegate: _SliverViewModeSelectorDelegate(
        currentMode: _viewMode,
        onModeChanged: (mode) {
          setState(() {
            _viewMode = mode;
          });
        },
      ),
    );
  }

  Widget _buildEventsView(BuildContext context, List<EventModel> events) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }

    switch (_viewMode) {
      case ViewMode.grid:
        return _buildGridView(events);
      case ViewMode.list:
        return _buildListView(events);
      case ViewMode.compact:
        return _buildCompactView(events);
    }
  }

  Widget _buildGridView(List<EventModel> events) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: events.length,
                    itemBuilder: (context, index) {
        return _buildGridCard(context, events[index], index);
      },
    );
  }

  Widget _buildListView(List<EventModel> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildListCard(context, events[index], index),
        );
      },
    );
  }

  Widget _buildCompactView(List<EventModel> events) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildCompactCard(context, events[index], index);
      },
    );
  }

  Widget _buildSliverEventsList(List<EventModel> events) {
    switch (_viewMode) {
      case ViewMode.grid:
        return SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildGridCard(context, events[index], index),
              childCount: events.length,
            ),
          ),
        );
      case ViewMode.list:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: _buildListCard(context, events[index], index),
            ),
            childCount: events.length,
          ),
        );
      case ViewMode.compact:
        return SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCompactCard(context, events[index], index),
              childCount: events.length,
            ),
          ),
        );
    }
  }

  // Helper method to check if event should show registration button
  bool _shouldShowRegistrationButton(EventModel event) {
    final status = event.status?.toUpperCase();
    return status == 'REGISTRATION_OPEN' || status == 'ONGOING';
  }

  // Helper method to get registration button info
  Map<String, dynamic> _getRegistrationButtonInfo(
    Map<String, dynamic>? registrationStatus,
    EventModel event,
  ) {
    // Check if event status allows registration
    if (!_shouldShowRegistrationButton(event)) {
      return {'show': false};
    }

    if (registrationStatus == null) {
      // Not registered - show register button
      return {
        'text': 'اشترك',
        'color': AppColors.primary,
        'icon': Icons.how_to_reg,
        'action': 'register',
      };
    }

    final status = registrationStatus['status'] as String?;
    switch (status?.toUpperCase()) {
      case 'PAYMENT_PENDING':
        return {
          'text': 'بإنتظار الدفع',
          'color': Colors.blue,
          'icon': Icons.payment,
          'action': 'payment',
          'registrationId': registrationStatus['registrationId'] ?? registrationStatus['id'],
        };
      case 'UNDER_REVIEW':
        return {
          'text': 'قيد المراجعة',
          'color': Colors.orange,
          'icon': Icons.hourglass_empty,
          'action': 'none',
        };
      case 'ACTIVE_PARTICIPANT':
        return {
          'text': 'مشترك',
          'color': AppColors.success,
          'icon': Icons.check_circle,
          'action': 'none',
        };
      default:
        return {'show': false};
    }
  }

  // Handle registration button tap
  Future<void> _handleRegistrationButtonTap(
    BuildContext context,
    EventModel event,
    Map<String, dynamic> buttonInfo,
  ) async {
    final action = buttonInfo['action'] as String?;
    
    if (action == 'register') {
      // Register to event
      setState(() {
        _processingRegistrations[event.id] = true;
      });

      try {
        final registrationService = RegistrationService();
        final registration = await registrationService.registerToEvent(
          eventId: event.id,
        );

        // Refresh registration status
        ref.invalidate(eventRegistrationStatusProvider(event.id));

        // Check if payment is required
        if (registration.status == 'PAYMENT_PENDING') {
          // Navigate to my registrations screen
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyRegistrationsScreen(),
              ),
            );
          }
        } else {
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('تم التسجيل في الفعالية بنجاح'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          String errorMessage = 'فشل في التسجيل';
          if (e is Exception) {
            final errorStr = e.toString();
            if (errorStr.startsWith('Exception: ')) {
              errorMessage = errorStr.substring(11);
            } else {
              errorMessage = errorStr;
            }
          } else {
            errorMessage = e.toString();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _processingRegistrations[event.id] = false;
          });
        }
      }
    } else if (action == 'payment') {
      // Navigate to my registrations screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyRegistrationsScreen(),
          ),
        );
      }
    }
  }

  Widget _buildGridCard(BuildContext context, EventModel course, int index) {
    final speakerName = _getSpeakerName(course);
    final description = course.description;
    final typeColor = _getTypeColor(course.type ?? '');
    final isFree = course.price == null || course.price! <= 0;
    
    // Get registration status
    final registrationStatusAsync = ref.watch(eventRegistrationStatusProvider(course.id));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetails(context, course.id),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: typeColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Container(
                        width: double.infinity,
                        height: 82,
                        child: course.firstPromotionalImage != null
                            ? AuthenticatedImageWidget(
                                imageUrl: course.firstPromotionalImage!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      typeColor.withOpacity(0.3),
                                      typeColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.event,
                                  size: 36,
                                  color: typeColor.withOpacity(0.5),
                                ),
                              ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [typeColor, typeColor.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                              _getTypeIcon(course.type ?? ''),
                              color: Colors.white,
                              size: 9,
                            ),
                            const SizedBox(width: 2),
                      Text(
                              course.typeLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isFree
                                ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                                : [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isFree ? 'مجاناً' : '${course.price!.toStringAsFixed(0)} ${course.currency ?? 'ريال'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_getCourseLevelLabel(course.courseLevel) != null)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.info, AppColors.info.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.white,
                                size: 8,
                              ),
                              const SizedBox(width: 3),
                      Text(
                                _getCourseLevelLabel(course.courseLevel)!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Content section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                          fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (speakerName != null && speakerName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 10,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  speakerName,
                                  style: TextStyle(
                                    fontSize: 9,
                          color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                      ),
                    ],
                  ),
                        ],
                        if (description != null && description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary.withOpacity(0.8),
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                icon: Icons.calendar_today_outlined,
                                text: DateFormat('d MMM', 'ar').format(course.localStartTime),
                                color: AppColors.primary,
                                size: 'small',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _buildInfoChip(
                                icon: Icons.access_time,
                                text: DateFormat('HH:mm', 'ar').format(course.localStartTime),
                                color: AppColors.warning,
                                size: 'small',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Only show registration button if event status is REGISTRATION_OPEN or ONGOING
                        if (_shouldShowRegistrationButton(course))
                          registrationStatusAsync.when(
                            data: (status) {
                              final buttonInfo = _getRegistrationButtonInfo(status, course);
                              if (buttonInfo['show'] == false) {
                                return const SizedBox.shrink();
                              }

                              final isProcessing = _processingRegistrations[course.id] ?? false;
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [buttonInfo['color'] as Color, (buttonInfo['color'] as Color).withOpacity(0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
      child: InkWell(
                                    onTap: isProcessing ? null : () => _handleRegistrationButtonTap(context, course, buttonInfo),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (isProcessing)
                                            const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          else
                                            Icon(buttonInfo['icon'] as IconData, color: Colors.white, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            buttonInfo['text'] as String,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
            ),
          );
        },
                            loading: () => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryLight],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: const Center(
                                  child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context, EventModel course, int index) {
    final speakerName = _getSpeakerName(course);
    final description = course.description;
    final typeColor = _getTypeColor(course.type ?? '');
    final isFree = course.price == null || course.price! <= 0;
    
    // Get registration status
    final registrationStatusAsync = ref.watch(eventRegistrationStatusProvider(course.id));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (index * 30)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetails(context, course.id),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
        child: Row(
          children: [
            // Image
              ClipRRect(
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                child: SizedBox(
                  width: 120,
                    height: 140,
                    child: course.firstPromotionalImage != null
                        ? AuthenticatedImageWidget(
                    imageUrl: course.firstPromotionalImage!,
                    fit: BoxFit.cover,
                            width: 120,
                            height: 140,
              )
                        : Container(
                width: 120,
                            height: 140,
                decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  typeColor.withOpacity(0.3),
                                  typeColor.withOpacity(0.1),
                                ],
                  ),
                ),
                child: Icon(
                              Icons.event,
                              size: 40,
                              color: typeColor.withOpacity(0.5),
                            ),
                          ),
                ),
              ),
            // Content
            Expanded(
              child: Padding(
                    padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Row(
                          children: [
                    Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [typeColor, typeColor.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getTypeIcon(course.type ?? ''),
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    course.typeLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isFree
                                      ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                                      : [AppColors.primary, AppColors.primaryLight],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isFree ? 'مجاناً' : '${course.price!.toStringAsFixed(0)} ${course.currency ?? 'ريال'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                    Text(
                      course.title,
                      style: const TextStyle(
                            fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                            height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                        if (speakerName != null && speakerName.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  speakerName,
                                  style: TextStyle(
                                    fontSize: 11,
                          color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (description != null && description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary.withOpacity(0.8),
                              height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                        if (_getCourseLevelLabel(course.courseLevel) != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.info.withOpacity(0.3), width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.trending_up, size: 10, color: AppColors.info),
                                const SizedBox(width: 4),
                                Text(
                                  _getCourseLevelLabel(course.courseLevel)!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                    Row(
                      children: [
                            _buildInfoChip(
                              icon: Icons.calendar_today_outlined,
                              text: DateFormat('d MMM yyyy', 'ar').format(course.localStartTime),
                              color: AppColors.primary,
                              size: 'medium',
                            ),
                        const SizedBox(width: 6),
                            _buildInfoChip(
                              icon: Icons.access_time,
                              text: DateFormat('HH:mm', 'ar').format(course.localStartTime),
                              color: AppColors.warning,
                              size: 'medium',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        registrationStatusAsync.when(
                          data: (status) {
                            final buttonInfo = _getRegistrationButtonInfo(status, course);
                            if (buttonInfo['show'] == false) {
                              return const SizedBox.shrink();
                            }

                            final isProcessing = _processingRegistrations[course.id] ?? false;
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: isProcessing ? null : () => _handleRegistrationButtonTap(context, course, buttonInfo),
                                icon: isProcessing
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Icon(buttonInfo['icon'] as IconData, size: 14),
                                label: Text(
                                  buttonInfo['text'] as String,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonInfo['color'] as Color,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () => const SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, EventModel course, int index) {
    final typeColor = _getTypeColor(course.type ?? '');
    final isFree = course.price == null || course.price! <= 0;
    
    // Get registration status
    final registrationStatusAsync = ref.watch(eventRegistrationStatusProvider(course.id));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 150 + (index * 30)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetails(context, course.id),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        child: course.firstPromotionalImage != null
                            ? AuthenticatedImageWidget(
                                imageUrl: course.firstPromotionalImage!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      typeColor.withOpacity(0.3),
                                      typeColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.event,
                                  size: 28,
                                  color: typeColor.withOpacity(0.5),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [typeColor, typeColor.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          _getTypeIcon(course.type ?? ''),
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isFree
                                ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                                : [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                          child: Text(
                          isFree ? 'مجاناً' : '${course.price!.toStringAsFixed(0)}',
                            style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          Text(
                        course.title,
                            style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 8,
                              color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              DateFormat('d MMM', 'ar').format(course.localStartTime),
                              style: TextStyle(
                                fontSize: 7,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      registrationStatusAsync.when(
                        data: (status) {
                          final buttonInfo = _getRegistrationButtonInfo(status, course);
                          if (buttonInfo['show'] == false) {
                            return const SizedBox.shrink();
                          }

                          final isProcessing = _processingRegistrations[course.id] ?? false;
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [buttonInfo['color'] as Color, (buttonInfo['color'] as Color).withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isProcessing ? null : () => _handleRegistrationButtonTap(context, course, buttonInfo),
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                      if (isProcessing)
                                        const SizedBox(
                                          width: 8,
                                          height: 8,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      else
                                        Icon(buttonInfo['icon'] as IconData, color: Colors.white, size: 8),
                                      const SizedBox(width: 2),
                          Text(
                                        buttonInfo['text'] as String,
                            style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        loading: () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 8,
                              height: 8,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _getSpeakerName(EventModel course) {
    // Try to get from speakers list first
    if (course.speakers != null && course.speakers!.isNotEmpty) {
      final firstSpeaker = course.speakers!.first;
      // Check different possible structures
      if (firstSpeaker['speaker'] != null && firstSpeaker['speaker'] is Map) {
        final speaker = firstSpeaker['speaker'] as Map<String, dynamic>;
        final name = speaker['name'] as String?;
        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
      // Direct access to name field
      if (firstSpeaker['name'] != null) {
        final name = firstSpeaker['name'] as String?;
        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    }
    // Try instructor if available
    if (course.instructor != null) {
      final instructor = course.instructor as Map<String, dynamic>;
      final name = instructor['name'] as String?;
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    return null;
  }

  String? _getCourseLevelLabel(String? courseLevel) {
    if (courseLevel == null || courseLevel.isEmpty) return null;
    switch (courseLevel.toUpperCase()) {
      case 'BEGINNER':
      case 'BASIC':
        return 'مبتدئ';
      case 'INTERMEDIATE':
      case 'MEDIUM':
        return 'متوسط';
      case 'ADVANCED':
      case 'EXPERT':
        return 'متقدم';
      case 'NOT_SPECIFIED':
        return null;
      default:
        return courseLevel;
    }
  }

  void _navigateToDetails(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    String size = 'small',
  }) {
    final iconSize = size == 'small' ? 8.0 : 10.0;
    final fontSize = size == 'small' ? 7.0 : 9.0;
    final padding = size == 'small' 
        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 6, vertical: 3);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'COURSE':
        return Icons.school;
      case 'WORKSHOP':
        return Icons.build;
      case 'SEMINAR':
        return Icons.chat_bubble_outline;
      default:
        return Icons.event;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'COURSE':
        return AppColors.info;
      case 'WORKSHOP':
        return AppColors.warning;
      case 'SEMINAR':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primaryLight.withOpacity(0.1),
                ],
              ),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد فعاليات متاحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تحقق مرة أخرى لاحقاً',
            style: TextStyle(
              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, String providerKey) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.1),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ في تحميل الفعاليات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(coursesProvider(providerKey));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
                  ],
                ),
              ),
    );
  }
}

// Sliver Delegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => 40;
  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

// Sliver Delegate for Category Filter
class _SliverCategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final AsyncValue<List<CourseCategoryModel>> categoriesAsync;
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  _SliverCategoryFilterDelegate({
    required this.categoriesAsync,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) return const SizedBox.shrink();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = selectedCategoryId == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(
                    label: 'الكل',
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(null),
                  ),
                );
              }
              final category = categories[index - 1];
              final isSelected = selectedCategoryId == category.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(
                  label: category.nameAr,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(isSelected ? null : category.id),
                ),
              );
            },
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? null
              : Border.all(color: AppColors.border, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverCategoryFilterDelegate oldDelegate) {
    return selectedCategoryId != oldDelegate.selectedCategoryId ||
        categoriesAsync != oldDelegate.categoriesAsync;
  }
}

// Sliver Delegate for View Mode Selector
class _SliverViewModeSelectorDelegate extends SliverPersistentHeaderDelegate {
  final ViewMode currentMode;
  final Function(ViewMode) onModeChanged;

  _SliverViewModeSelectorDelegate({
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  double get minExtent => 44;
  @override
  double get maxExtent => 44;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            'طريقة العرض:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          _buildModeButton(
            icon: Icons.grid_view,
            mode: ViewMode.grid,
            label: 'شبكة',
          ),
          const SizedBox(width: 8),
          _buildModeButton(
            icon: Icons.view_list,
            mode: ViewMode.list,
            label: 'قائمة',
          ),
          const SizedBox(width: 8),
          _buildModeButton(
            icon: Icons.view_module,
            mode: ViewMode.compact,
            label: 'مدمج',
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required ViewMode mode,
    required String label,
  }) {
    final isSelected = currentMode == mode;
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? null
              : Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverViewModeSelectorDelegate oldDelegate) {
    return currentMode != oldDelegate.currentMode;
  }
}
