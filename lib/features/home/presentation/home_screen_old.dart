import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/user_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../providers/enhanced_auth_provider_v2.dart';
import '../../../providers/language_provider.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/lazy_loading_service.dart';
import '../../../services/navigation_service.dart';
import '../../../services/notification_center_api_service.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../main/providers/bottom_navigation_provider.dart';
import '../../notifications/widgets/smart_notification_banner.dart';
import '../widgets/conference_card_new.dart';

// Provider for notification unread count
final _notificationUnreadCountProvider = FutureProvider<int>((ref) async {
  try {
    final count = await NotificationCenterApiService.getUnreadCount();
    return count;
  } catch (e) {
    debugPrint('❌ [HOME_SCREEN] Error getting unread count: $e');
    return 0;
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(enhancedAuthProvider);
    final isRTL = ref.watch(isRTLProvider);

    // Extract user from auth state
    UserModel? user;
    final isAuthenticated = authState.when(
      initial: () => false,
      loading: (message) => false,
      authenticated: (u) {
        user = u;
        debugPrint('✅ [HOME_SCREEN] User authenticated: ${u.phone}');
        debugPrint(
            '📸 [HOME_SCREEN] Profile photo: ${u.profile?.profilePhotoUrl}');
        debugPrint('👤 [HOME_SCREEN] Full name AR: ${u.profile?.fullNameAr}');
        debugPrint('👤 [HOME_SCREEN] Full name EN: ${u.profile?.fullNameEn}');
        return true;
      },
      unauthenticated: () => false,
      registered: () => false,
      error: (message) => false,
    );

    String greetingText = l10n.welcome;

    // If authenticated, show user name
    if (isAuthenticated && user != null) {
      final userName = _getFormattedUserName(user!, isRTL);
      debugPrint('🎯 [HOME_SCREEN] Formatted user name: $userName');
      if (isRTL) {
        greetingText = 'مرحبا بك $userName';
      } else {
        greetingText = 'Welcome $userName';
      }
    }

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Menu Icon (Drawer)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  // Welcome Text in the center
                  Expanded(
                    child: Center(
                      child: Text(
                        greetingText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // Refresh button with icon + text
                  GestureDetector(
                    onTap: () async {
                      debugPrint('🔄 [HOME_SCREEN] Refresh button pressed');
                      try {
                        // Clear cache for fresh data
                        await LazyLoadingService.instance.clearAllCache();
                        debugPrint('✅ [HOME_SCREEN] Cache cleared');

                        // Refresh conference data
                        ref.invalidate(activeConferenceProvider);
                        debugPrint('✅ [HOME_SCREEN] Conference data refreshed');

                        // Refresh user authentication state
                        ref
                            .read(compatibleAuthProvider.notifier)
                            .refreshAuthState();
                        debugPrint('✅ [HOME_SCREEN] Auth state refreshed');
                      } catch (e) {
                        debugPrint('❌ [HOME_SCREEN] Refresh error: $e');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, color: Colors.white, size: 22),
                          SizedBox(width: 6),
                          Text(
                            'تحديث',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Notifications button with badge (بجوار زر التحديث)
                  const SizedBox(width: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      // Check authentication inside Consumer
                      final authState = ref.watch(enhancedAuthProvider);
                      final isAuth = authState.maybeWhen(
                        authenticated: (_) => true,
                        orElse: () => false,
                      );
                      
                      if (!isAuth) {
                        return const SizedBox.shrink();
                      }
                      
                      // Get unread count from NotificationCenter
                      final unreadCountFuture = ref.watch(_notificationUnreadCountProvider);
                      return unreadCountFuture.when(
                        data: (unreadCount) {
                          return GestureDetector(
                            onTap: () {
                              NavigationService.instance.goToNotifications();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.14),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Center(
                                        child: Text(
                                          unreadCount > 99 ? '99+' : '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        loading: () => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        error: (_, __) => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                  // Logo/User Photo on the right
                  GestureDetector(
                    onTap: () {
                      if (isAuthenticated) {
                        ref.read(bottomNavIndexProvider.notifier).state = 4;
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: user != null &&
                              user!.profile != null &&
                              user!.profile!.profilePhotoUrl != null &&
                              user!.profile!.profilePhotoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                user!.profile!.profilePhotoUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(AppImages.logo,
                                      fit: BoxFit.contain);
                                },
                              ),
                            )
                          : SvgPicture.asset(AppImages.logo,
                              fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            debugPrint('🔄 [HOME_SCREEN] Pull to refresh triggered');

            try {
              // Clear relevant cache for fresh data
              await LazyLoadingService.instance.clearAllCache();
              debugPrint('✅ [HOME_SCREEN] Cache cleared');

              // Refresh user authentication state to get latest user data
              ref.read(compatibleAuthProvider.notifier).refreshAuthState();
              debugPrint('✅ [HOME_SCREEN] Auth state refreshed');

              // Refresh conference data
              ref.invalidate(activeConferenceProvider);
              debugPrint('✅ [HOME_SCREEN] Conference data refreshed');

              // Small delay to show refresh animation
              await Future.delayed(const Duration(milliseconds: 500));
            } catch (e) {
              debugPrint('❌ [HOME_SCREEN] Refresh error: $e');
              // Continue anyway to dismiss refresh indicator
              await Future.delayed(const Duration(milliseconds: 500));
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Smart Notification Banner (للويب فقط)
                if (kIsWeb) const SmartNotificationBanner(),
                if (kIsWeb) const SizedBox(height: 12),
                
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
                        NavigationService.instance.goToNotifications();
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
      ),
    );
  }

  // Function to format user name based on language
  String _getFormattedUserName(UserModel user, bool isRTL) {
    debugPrint('🔍 [HOME_SCREEN] Formatting name for user: ${user.phone}');
    debugPrint('🔍 [HOME_SCREEN] Profile: ${user.profile}');
    debugPrint('🔍 [HOME_SCREEN] Is RTL: $isRTL');

    String? fullName;
    String title = '';

    // Get name based on language
    if (isRTL) {
      fullName = user.profile?.fullNameAr;
      title = 'د.';
      debugPrint('🔍 [HOME_SCREEN] Arabic name: $fullName');
    } else {
      fullName = user.profile?.fullNameEn ?? user.profile?.fullNameAr;
      title = 'Dr.';
      debugPrint('🔍 [HOME_SCREEN] English name: $fullName');
    }

    if (fullName == null || fullName.isEmpty) {
      debugPrint('⚠️ [HOME_SCREEN] No name found, returning empty');
      return '';
    }

    // Split name into parts
    final nameParts = fullName.trim().split(' ');
    debugPrint('🔍 [HOME_SCREEN] Name parts: $nameParts');

    // Get first and last name
    if (nameParts.length >= 2) {
      final result = '$title ${nameParts.first} ${nameParts.last}';
      debugPrint('✅ [HOME_SCREEN] Formatted name: $result');
      return result;
    } else if (nameParts.length == 1) {
      final result = '$title ${nameParts.first}';
      debugPrint('✅ [HOME_SCREEN] Formatted name: $result');
      return result;
    }

    debugPrint('✅ [HOME_SCREEN] Using full name: $fullName');
    return fullName;
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
