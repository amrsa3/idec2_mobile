import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/main/presentation/main_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/conference_card_new.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // User Profile Picture
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150?text=User',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Welcome Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مرحباً .. د. نعمان',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notifications Icon
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Conference Card
              const ConferenceCardNew(),

              const SizedBox(height: 24),

              // Quick Actions
              Text(
                l10n.quickActions,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildQuickActionCard(
                    context,
                    icon: Icons.event,
                    title: l10n.schedule,
                    subtitle: l10n.viewSchedule,
                    color: Colors.blue,
                    onTap: () {
                      // التنقل إلى تبويب الجدول الزمني (الفهرس 1)
                      ref.read(bottomNavIndexProvider.notifier).state = 1;
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.people,
                    title: l10n.speakers,
                    subtitle: l10n.viewSpeakers,
                    color: Colors.green,
                    onTap: () {
                      // التنقل إلى تبويب المتحدثون (الفهرس 2)
                      ref.read(bottomNavIndexProvider.notifier).state = 2;
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.store,
                    title: l10n.exhibition,
                    subtitle: l10n.viewExhibition,
                    color: Colors.orange,
                    onTap: () {
                      // التنقل إلى تبويب المعرض (الفهرس 3)
                      ref.read(bottomNavIndexProvider.notifier).state = 3;
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.notifications,
                    title: l10n.notifications,
                    subtitle: l10n.viewNotifications,
                    color: Colors.purple,
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Updates
              Text(
                l10n.recentUpdates,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),

              const SizedBox(height: 16),

              // Update cards
              _buildUpdateCard(
                context,
                title: l10n.conferenceUpdate,
                subtitle: l10n.conferenceUpdateDesc,
                time: '2 ${l10n.hoursAgo}',
                icon: Icons.update,
              ),

              const SizedBox(height: 12),

              _buildUpdateCard(
                context,
                title: l10n.newSpeaker,
                subtitle: l10n.newSpeakerDesc,
                time: '5 ${l10n.hoursAgo}',
                icon: Icons.person_add,
              ),

              const SizedBox(height: 12),

              _buildUpdateCard(
                context,
                title: l10n.scheduleChange,
                subtitle: l10n.scheduleChangeDesc,
                time: '1 ${l10n.dayAgo}',
                icon: Icons.schedule,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
