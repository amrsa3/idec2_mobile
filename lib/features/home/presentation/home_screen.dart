import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/auth.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../exhibition/presentation/exhibition_screen.dart';
import '../../market/presentation/market_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/main/providers/bottom_navigation_provider.dart';
import '../../../features/profile/providers/profile_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/user_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../providers/events_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/lazy_loading_service.dart';
import '../../../services/navigation_service.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/notification_badge.dart';
import '../../../shared/widgets/verification_notification_banner.dart';
import '../widgets/conference_card_new.dart';
import '../../speakers/presentation/speaker_details_screen.dart';
import '../../schedule/presentation/event_details_screen.dart';
import '../../../providers/notification_provider.dart';

// Note: Using unreadCountProvider from notification_provider.dart
// It gets invalidated automatically when push notifications arrive

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isRTL = ref.watch(isRTLProvider);
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;

    // Greeting Text
    String greetingText = l10n.welcome;
    if (isAuthenticated && user != null) {
      final userName = _getFormattedUserName(user, isRTL);
      if (isRTL) {
        greetingText = 'مرحباً، $userName';
      } else {
        greetingText = 'Hello, $userName';
      }
    }

    final isDark = context.isDarkMode;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: context.colors.background,
      body: RefreshIndicator(
        onRefresh: () async => _handleRefresh(ref, context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar
            _buildSliverAppBar(context, ref, greetingText, user, isAuthenticated),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verification Banner
                    if (isAuthenticated) ...[
                      Builder(builder: (context) {
                          // Load profile if missing (handled in build via frame callback usually, 
                          // but here we just show the banner which checks profile itself)
                          return const VerificationNotificationBanner();
                      }),
                    ],

                    // Conference Card - HERO ELEMENT
                    const ConferenceCardNew(),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildSectionHeader(context, l10n.quickActions),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(context, ref, l10n),

                    const SizedBox(height: 24),

                    // Featured Courses
                    _buildSectionHeader(
                      context, 
                      'الدورات المميزة', // TODO: Add to l10n
                      onActionTap: () => ref.read(bottomNavIndexProvider.notifier).state = 4,
                      actionText: 'عرض الكل',
                    ),
                    const SizedBox(height: 12),
                    _buildFeaturedCoursesList(context),

                    const SizedBox(height: 24),

                    // Explore Conference
                    _buildSectionHeader(context, 'استكشف المؤتمر'),
                    const SizedBox(height: 12),
                    _buildExploreConferenceGrid(context, ref),

                    const SizedBox(height: 24),

                    // Featured Speakers
                    _buildSectionHeader(
                      context, 
                      'أبرز المتحدثين', 
                      onActionTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3, // Speakers tab usually 3 or 2
                      actionText: 'عرض الكل',
                    ),
                    const SizedBox(height: 12),
                    _buildFeaturedSpeakers(context),

                    const SizedBox(height: 24),

                    // Exhibition Banner
                     _buildSectionHeader(
                      context, 
                      'المعرض المصاحب', 
                      onActionTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2, // Exhibition tab usually 2 or 3
                      actionText: 'زيارة',
                    ),
                    const SizedBox(height: 12),
                    _buildExhibitionBanner(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic Helpers ---

  Future<void> _handleRefresh(WidgetRef ref, BuildContext context) async {
    try {
      await LazyLoadingService.instance.clearAllCache();
      ref.read(authProvider.notifier).refreshAuthState();
      ref.invalidate(activeConferenceProvider);
      ref.invalidate(profileProvider);
      ref.invalidate(unreadCountProvider);
    } catch (e) {
      debugPrint('Error refreshing home: $e');
    }
  }

  String _getFormattedUserName(UserModel user, bool isRTL) {
    String? fullName;
    String title = '';

    if (isRTL) {
      fullName = user.profile?.fullNameAr;
      title = 'د.';
    } else {
      fullName = user.profile?.fullNameEn ?? user.profile?.fullNameAr;
      title = 'Dr.';
    }

    if (fullName == null || fullName.isEmpty) return '';

    final nameParts = fullName.trim().split(' ');
    if (nameParts.length >= 2) {
      return '$title ${nameParts.first} ${nameParts.last}';
    } else if (nameParts.isNotEmpty) {
      return '$title ${nameParts.first}';
    }
    return fullName;
  }

  // --- Widget Builders ---

  Widget _buildSliverAppBar(
    BuildContext context, 
    WidgetRef ref, 
    String greeting, 
    UserModel? user,
    bool isAuthenticated,
  ) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: context.colors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (scaffoldContext) => IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.containerBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.menu, color: AppColors.primary, size: 20),
          ),
          onPressed: () {
            Scaffold.of(scaffoldContext).openDrawer();
          },
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isAuthenticated)
            Text(
              'أهلاً بك في آيدك',
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      actions: [
        // Theme Toggle Button
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: Consumer(
            builder: (context, ref, _) {
              final themeState = ref.watch(themeProvider);
              final isDark = themeState.themeMode == ThemeMode.dark ||
                  (themeState.themeMode == ThemeMode.system &&
                      MediaQuery.of(context).platformBrightness == Brightness.dark);
              
              return GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.colors.containerBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Notifications
        if (isAuthenticated)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: Consumer(
              builder: (context, ref, _) {
                final unreadCountAsync = ref.watch(unreadCountProvider);
                final count = unreadCountAsync.valueOrNull ?? 0;
                
                return GestureDetector(
                  onTap: () {
                    // Try different navigation methods to ensure it works
                    try {
                       context.push('/notifications');
                    } catch (e) {
                      debugPrint('Error navigating to notifications: $e');
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.colors.containerBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
                        if (count > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Profile Avatar
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: GestureDetector(
            onTap: () {
              if (isAuthenticated) {
                ref.read(bottomNavIndexProvider.notifier).state = 4; // Profile tab index (adjust if needed)
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: user != null && user.profile?.profilePhotoUrl != null
                    ? Image.network(
                        user.profile!.profilePhotoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(AppImages.logo),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(AppImages.logo),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onActionTap, String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        if (actionText != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: l10n.schedule,
            color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.shade50,
            iconColor: Colors.blue,
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2, // Sessions Tab
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionItem(
            context: context,
            icon: Icons.people_outline,
            label: l10n.speakers,
            color: isDark ? Colors.purple.withOpacity(0.1) : Colors.purple.shade50,
            iconColor: Colors.purple,
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3, // Speakers Tab
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionItem(
            context: context,
            icon: Icons.storefront_outlined,
            label: l10n.exhibition,
            color: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange.shade50,
            iconColor: Colors.orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExhibitionScreen())),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionItem(
            context: context,
            icon: Icons.shopping_bag_outlined,
            label: 'المتجر', // TODO localization
            color: isDark ? Colors.teal.withOpacity(0.1) : Colors.green.shade50,
            iconColor: Colors.teal,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen())),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colors.containerBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- Placeholder Widgets for Content ---
  
  // Note: These now use real data from the API

  Widget _buildFeaturedCoursesList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final eventsAsync = ref.watch(featuredEventsProvider);
        
        return eventsAsync.when(
          loading: () => SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (error, stack) => SizedBox(
            height: 220,
            child: Center(
              child: Text('حدث خطأ في تحميل الدورات', style: TextStyle(color: context.colors.textSecondary)),
            ),
          ),
          data: (events) {
            if (events.isEmpty) {
              return SizedBox(
                height: 220,
                child: Center(
                  child: Text('لا توجد دورات مميزة حالياً', style: TextStyle(color: context.colors.textSecondary)),
                ),
              );
            }
            
            return SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final dateFormat = DateFormat('dd MMMM', 'ar');
                  
                  return _buildCourseCard(
                    context,
                    event: event, // Pass the whole event object
                    title: event.title,
                    speaker: event.instructor?.name ?? 'غير محدد',
                    date: dateFormat.format(event.startTime),
                    imageUrl: event.firstImageUrl ?? 'https://via.placeholder.com/200x120?text=IDEC',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required EventModel event,
    required String title,
    required String speaker,
    required String date,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to event details using correct path
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(eventId: event.id),
          ),
        );
      },
      child: Container(
        width: 220, // Slightly wider
        margin: const EdgeInsetsDirectional.only(end: 16, bottom: 8), // Bottom margin for shadow
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Hero(
                      tag: 'event_image_${event.id}',
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: context.colors.surfaceVariant,
                          child: Center(
                            child: Icon(Icons.image_not_supported_outlined, color: context.colors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Date Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.colors.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                           BoxShadow(
                            color: context.colors.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tag & Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.type == 'WORKSHOP' ? 'ورشة عمل' : 'دورة تدريبية',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: context.colors.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreConferenceGrid(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
         Expanded(
          child: GestureDetector(
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDpaFShP6XdTJvMQxUPezXXDQwlJmwfwHLQuWJPbkJGctfDQC2Cw1kc5HO4ZS2fNOT0Sj15H79xs4KLhfCrb0hRwgMYeoh19p8okoabENDIqJ2diTSMxEiUsBt3_TOrNrJ4Hd2KR2gAtM09c2to3ew0FlnGS2Ux3vIIMMqOD3KyXzt3VuIXSTt4htkp9AgepzlDYHfsuG7N44S_8YCq6QxdHbGdyFMHop8b6L6yM6caHN4mAqxSSwNKp8BUFe_HpgUQ9ahtdf4eHEs7'
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('البرنامج العلمي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Navigate to venue details
            },
            child: Container(
              height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDf0ZCKk3qYMLFzYWe8a2gGuJHjWsA3iwjbqwqRKi56o866cvfc4m5PgHEwBuEvo5g-Qm79qonlNxXZDI3Tms8C3ms9Tc-Yu12lqjTms8_HfqdaERrZWMQQqWYFF-19sX6U86qsntBKEp3BzzdvPi3ui9VlskBBxS1NR962-k0oEG1QAqrI1DmZrri_TcMeD3XLg1mbEuxQ2ZSZTxFYGcIvzxM9hUIcpTS1lyYkwfQjUchlSsmAQEgCAEMcz9p39ethR-OZ-ogdzS7I'
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                 padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مقر المؤتمر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSpeakers(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final speakersAsync = ref.watch(featuredSpeakersProvider);
        
        return speakersAsync.when(
          loading: () => SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (error, stack) => SizedBox(
            height: 120,
            child: Center(
              child: Text('حدث خطأ في تحميل المتحدثين', style: TextStyle(color: context.colors.textSecondary)),
            ),
          ),
          data: (speakers) {
            if (speakers.isEmpty) {
              return SizedBox(
                height: 120,
                child: Center(
                  child: Text('لا يوجد متحدثين حالياً', style: TextStyle(color: context.colors.textSecondary)),
                ),
              );
            }
            
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: speakers.length,
                itemBuilder: (context, index) {
                  final speaker = speakers[index];
                  
                  return _buildSpeakerCircle(
                    context,
                    speaker, // Pass full object
                    speaker.name,
                    speaker.title ?? speaker.organization ?? '',
                    speaker.photoUrl ?? 'https://via.placeholder.com/65?text=👤',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSpeakerCircle(
    BuildContext context, 
    SpeakerModel speaker,
    String name, 
    String title, 
    String imageUrl
  ) {
    return GestureDetector(
      onTap: () {
         // Navigate to speaker details
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => SpeakerDetailsScreen(speakerId: speaker.id),
           ),
         );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: SizedBox(
          width: 70, // Fixed width to ensure consistent spacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                  boxShadow: [
                     BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExhibitionBanner(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExhibitionScreen())),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black87,
          image: const DecorationImage(
            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBvNNu_cMhGlKW8J3VVpz9o_GQJ0shv7AOnDogxwvNTQFTsmUfV3GOd4J7u3trVsU6Aqtz8hdqxQz5bTp08jx3POWTaF34O3RnSkuX1Nz2Qx93Fr7ZRLa1L10_6cTzIgHab5U2_x9bqYrRXcEBBU7fQ5pulqFQJVNQoPL0A1_FToW09dldQ4VyLYqhp3Hu3C90SndS2vJ8vzhImhTBuTUWjK30Y0Cf3nHfK8OfQmbE7FyAy4Q6g0CT-XgBotHRg2lySg7HBrWD8v0Cr'), 
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اكتشف أحدث التقنيات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
             Text(
              'أكثر من 50 عارض من كبرى الشركات العالمية',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'تصفح المعرض',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
