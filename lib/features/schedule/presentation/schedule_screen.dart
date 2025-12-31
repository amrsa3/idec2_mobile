import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../services/conference_service.dart';
import '../../../services/event_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import 'event_details_screen.dart';

// Provider for events
final eventsProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, filters) async {
  final eventService = EventService();
  return await eventService.getEvents(
    page: filters['page'] ?? 1,
    limit: filters['limit'] ?? 20,
    conferenceId: filters['conferenceId'],
    type: filters['type'],
    search: filters['search'],
  );
});

// Provider for active conference
final activeConferenceProvider = FutureProvider((ref) async {
  final conferenceService = ConferenceService();
  return await conferenceService.getActiveConference();
});

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedType;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conferenceAsync = ref.watch(activeConferenceProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text(
          'الجدول الزمني',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن فعالية...',
                    prefixIcon: const Icon(Icons.search,
                        color: context.colors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.isEmpty ? null : value;
                    });
                    ref.invalidate(eventsProvider);
                  },
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: context.colors.textSecondary,
                indicatorColor: AppColors.primary,
                onTap: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _selectedType = null;
                        break;
                      case 1:
                        _selectedType = 'COURSE';
                        break;
                      case 2:
                        _selectedType = 'WORKSHOP';
                        break;
                      case 3:
                        _selectedType = 'SEMINAR';
                        break;
                    }
                  });
                  ref.invalidate(eventsProvider);
                },
                tabs: const [
                  Tab(text: 'الكل'),
                  Tab(text: 'دورات'),
                  Tab(text: 'ورش عمل'),
                  Tab(text: 'ندوات'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: conferenceAsync.when(
        data: (conference) {
          if (conference == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد مؤتمر نشط',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final filters = <String, dynamic>{
            'page': 1,
            'limit': 50,
            'conferenceId': conference.id,
            if (_selectedType != null) 'type': _selectedType,
            if (_searchQuery != null) 'search': _searchQuery,
          };

          final eventsAsync = ref.watch(eventsProvider(filters));

          return eventsAsync.when(
            data: (data) {
              final events = (data['data'] as List<EventModel>);

              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note,
                        size: 80,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد فعاليات متاحة',
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group events by date
              final groupedEvents = <String, List<EventModel>>{};
              for (final event in events) {
                final dateKey =
                    DateFormat('yyyy-MM-dd').format(event.startTime);
                groupedEvents.putIfAbsent(dateKey, () => []).add(event);
              }

              final sortedDates = groupedEvents.keys.toList()..sort();

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(eventsProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final dayEvents = groupedEvents[date]!;
                    dayEvents
                        .sort((a, b) => a.startTime.compareTo(b.startTime));

                    return _buildDateSection(context, date, dayEvents);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الفعاليات',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(eventsProvider);
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ في تحميل المؤتمر',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(
      BuildContext context, String dateKey, List<EventModel> events) {
    final date = DateTime.parse(dateKey);
    final dayName = DateFormat('EEEE', 'ar').format(date);
    final dayNumber = date.day;
    final monthName = DateFormat('MMMM', 'ar').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dayNumber.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    monthName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Events list
        ...events.map((event) => _buildEventCard(context, event)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(eventId: event.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (event.firstPromotionalImage != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AuthenticatedImageWidget(
                    imageUrl: event.firstPromotionalImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor(event.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.typeLabel,
                      style: TextStyle(
                        color: _getTypeColor(event.type),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      event.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: context.colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Time and info
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 18, color: context.colors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        event.formattedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (event.duration != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.timer,
                            size: 18, color: context.colors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '${event.duration!.toStringAsFixed(1)} ساعة',
                          style: const TextStyle(
                            fontSize: 14,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (event.price != null && event.price! > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_money,
                            size: 18, color: context.colors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '${event.price!.toStringAsFixed(0)} ${event.currency ?? 'ريال'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (event.speakersCount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 18, color: context.colors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '${event.speakersCount} متحدث',
                          style: const TextStyle(
                            fontSize: 14,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
