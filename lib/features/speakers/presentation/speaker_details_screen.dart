import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/speaker_model.dart';
import '../../../services/speaker_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import '../../main/widgets/app_bottom_navigation_bar.dart';
import '../../schedule/presentation/event_details_screen.dart';

// Provider for speaker details
final speakerDetailsProvider = FutureProvider.family<SpeakerModel, String>((ref, speakerId) async {
  final speakerService = SpeakerService();
  return await speakerService.getSpeakerById(speakerId);
});

// Provider for speaker events
final speakerEventsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, speakerId) async {
  final speakerService = SpeakerService();
  return await speakerService.getSpeakerEvents(speakerId);
});

class SpeakerDetailsScreen extends ConsumerStatefulWidget {
  final String speakerId;

  const SpeakerDetailsScreen({
    super.key,
    required this.speakerId,
  });

  @override
  ConsumerState<SpeakerDetailsScreen> createState() => _SpeakerDetailsScreenState();
}

class _SpeakerDetailsScreenState extends ConsumerState<SpeakerDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final speakerAsync = ref.watch(speakerDetailsProvider(widget.speakerId));
    final eventsAsync = ref.watch(speakerEventsProvider(widget.speakerId));

    return Scaffold(
      backgroundColor: context.colors.background,
      bottomNavigationBar: const AppBottomNavigationBar(),
      body: speakerAsync.when(
        data: (speaker) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(speakerDetailsProvider(widget.speakerId));
            ref.invalidate(speakerEventsProvider(widget.speakerId));
          },
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                // App bar with photo
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: speaker.hasPhoto
                        ? AuthenticatedImageWidget(
                            imageUrl: speaker.photoUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.primary,
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                // Header content (Name, Title, Organization)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name (Arabic only, without title)
                        Text(
                          speaker.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title (separate field below name)
                        if (speaker.title != null && speaker.title!.isNotEmpty)
                          Text(
                            speaker.title!,
                            style: TextStyle(
                              fontSize: 18,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        // Organization
                        if (speaker.organization != null && speaker.organization!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.business, size: 18, color: context.colors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                speaker.organization!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // TabBar
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'نبذة'),
                        Tab(text: 'الفعاليات'),
                      ],
                      labelColor: AppColors.primary,
                      unselectedLabelColor: context.colors.textSecondary,
                      indicatorColor: AppColors.primary,
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Bio Tab
                _buildBioTab(speaker),
                // Events Tab
                _buildEventsTab(context, eventsAsync),
              ],
            ),
          ),
        ),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(
            title: Text(l10n.speakerDetails),
          ),
          body: Center(
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
                  'حدث خطأ في تحميل المتحدث',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.colors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioTab(SpeakerModel speaker) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          if (speaker.bio != null && speaker.bio!.isNotEmpty) ...[
            Text(
              'نبذة عن المتحدث',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              speaker.bio!,
              style: TextStyle(
                fontSize: 16,
                color: context.colors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Contact info
          if (speaker.email != null || speaker.phone != null) ...[
            Text(
              'معلومات الاتصال',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (speaker.email != null && speaker.email!.isNotEmpty)
              _buildInfoRow(
                Icons.email,
                speaker.email!,
              ),
            if (speaker.phone != null && speaker.phone!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.phone,
                speaker.phone!,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildEventsTab(BuildContext context, AsyncValue<List<Map<String, dynamic>>> eventsAsync) {
    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: context.colors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد فعاليات',
                  style: TextStyle(
                    fontSize: 18,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final eventData = events[index];
            
            // Handle different response formats
            final type = eventData['type'] as String?;
            final event = eventData['event'] as Map<String, dynamic>?;
            final session = eventData['session'] as Map<String, dynamic>?;
            
            // Determine if it's an event or session
            final isEvent = type == 'event' || event != null;
            final item = isEvent ? event : session;
            
            if (item == null) return const SizedBox.shrink();
            
            final itemId = item['id'] as String?;
            final itemTitle = item['title'] as String? ?? '';
            final itemType = item['type'] as String?;
            
            if (itemId == null) return const SizedBox.shrink();
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  isEvent ? Icons.event : Icons.people,
                  color: AppColors.primary,
                ),
                title: Text(
                  itemTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isEvent 
                      ? (itemType != null ? _getEventTypeLabel(itemType) : 'فعالية')
                      : 'جلسة',
                  style: TextStyle(
                    color: context.colors.textSecondary,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (isEvent) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                          eventId: itemId,
                        ),
                      ),
                    );
                  } else {
                    // TODO: Navigate to session details when session details screen is available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('صفحة تفاصيل الجلسة غير متاحة حالياً'),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل الفعاليات',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEventTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'COURSE':
        return 'دورة';
      case 'SEMINAR':
        return 'ندوة';
      case 'WORKSHOP':
        return 'ورشة عمل';
      default:
        return type;
    }
  }
}

// Helper class for SliverPersistentHeader with TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.colors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
