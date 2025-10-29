import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/main/presentation/main_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/user_model.dart';
import '../../../providers/enhanced_auth_provider_v2.dart';
import '../../../providers/language_provider.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../widgets/conference_card_new.dart';

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
            // Refresh user authentication state to get latest user data
            ref.read(compatibleAuthProvider.notifier).refreshAuthState();
            // Small delay to show refresh animation
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Conference Card
                const ConferenceCardNew(),

                const SizedBox(height: 24),

                // Featured Courses Section
                _buildSectionHeader('الدورات المميزة', 'عرض الكل', context),
                const SizedBox(height: 12),
                _buildFeaturedCourses(context),

                const SizedBox(height: 24),

                // Explore Conference Section
                _buildSectionHeader('استكشف المؤتمر', null, context),
                const SizedBox(height: 12),
                _buildExploreConference(context, ref),

                const SizedBox(height: 24),

                // Featured Speakers Section
                _buildSectionHeader('أبرز المتحدثين', 'عرض الكل', context),
                const SizedBox(height: 12),
                _buildFeaturedSpeakers(context),

                const SizedBox(height: 24),

                // Exhibition Section
                _buildSectionHeader('المعرض', 'عرض الكل', context),
                const SizedBox(height: 12),
                _buildExhibition(context, ref),

                const SizedBox(height: 24),
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

  Widget _buildSectionHeader(
      String title, String? actionText, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedCourses(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCourseCard(
            context,
            title: 'تقنيات تبييض الأسنان الحديثة',
            speaker: 'د. سارة القحطاني',
            date: '26 أكتوبر، 10: Using صباحاً',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD5CplnuyL7aDCOUE6HoV8vP_RroTcRxQHcn2anh7aFZ5zLmGDQfOY_Tyzj3vuW7Z9gOjXYTV多INYuJeUCIoJ_EuP9py2LeEw3OkVsR_LHSYuJeJJXSeHJkSs8g3UL6hD-9uNskGt53qo3TzcsYxp7ATGE70GhGrXRdKyyt5xk04kJYlNzyJQtu91dmSlnV6kEV7GxBvsvbQE25ziuKZl6oTJVJdVmEKOF563y3ao_VVk5O_OTOq0ZAUJGZpLboQRsEyJ9egAo0SFF69',
          ),
          _buildCourseCard(
            context,
            title: 'التصوير الرقميアクセス في طب الأسنان',
            speaker: 'د. عمر الهاشمي',
            date: '25 أكتوبر، 2:00 ظهراً',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD0x2RGHpLIkJR8Z-sE3SXqWp-9pNJubKCL4L1geNR6wQ_HbTclzBZPCAW6PyyZsQAQTEjK9jLhltJdDDNZFDs-_CsQyqOyYjM5lioEctYQ7ARweDQZjTBqgpnuRDGY1PG6nBYbq2AvYFY-59NO3XwRhztCyqb9wkhSA9e61mHEoGWpAUArEIKvOK6JwaYWIeJ3hGVYHHHbuc8MKdKFH6UAqMHOnRGnMQltlEKQ6XSWs5Aptedvi_4WngRZTUkqkDErKtBBD3uClcDs6F',
          ),
          _buildCourseCard(
            context,
            title: 'إدارة عيادات الأسنان بنجاح',
            speaker: 'أ. خالد العمري',
            date: '27 أكتوبر، 4:00 عصراً',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD1NAD4laStA8OLQmJzIJL4x6o7qWe0xVgcRWhtHPzquiyZopywwotSukxYL4yS_JJGb6nIIczmSs6qP_mxeRKWaXzkXPkZTKHNYscP03fNpRo0X27jV-vIKZUUSEaX-1k1kgT0nCftT2UceKNRccZS6-k-mv_64v8wZQIuClMJ0fPbOiw1XDmParJhGemrMRjQRJasLV2i7N3jnrRiJbLL77tjT2uyPGHH5O0Hm6vn8fwHtLl1JKlXg8NpATLp0bjP3a3A6jHKkTcn',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required String title,
    required String speaker,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    speaker,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey[300]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreConference(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildExploreCard(
            context,
            title: 'برنامج المؤتمر',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDpaFShP6XdTJvMQxUPezXXDQwlJmwfwHLQuWJPbkJGctfDQC2Cw1kc5HO4ZS2fNOT0Sj15H79xs4KLhfCrb0hRwgMYeoh19p8okoabENDIqJ2diTSMxEiUsBt3_TOrNrJ4Hd2KR2gAtM09c2to3ew0FlnGS2Ux3vIIMMqOD3KyXzt3VuIXSTt4htkp9AgepzlDYHfsuG7N44S_8YCq6QxdHbGdyFMHop8b6L6yM6caHN4mAqxSSwNKp8BUFe_HpgUQ9ahtdf4eHEs7',
            onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildExploreCard(
            context,
            title: 'تفاصيل المكان',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDf0ZCKk3qYMLFzYWe8a2gGuJHjWsA3iwjbqwqRKi56o866cvfc4m5PgHEwBuEvo5g-Qm79qonlNxXZDI3Tms8C3ms9Tc-Yu12lqjTms8_HfqdaERrZWMQQqWYFF-19sX6U86qsntBKEp3BzzdvPi3ui9VlskBBxS1NR962-k0oEG1QAqrI1DmZrri_TcMeD3XLg1mbEuxQ2ZSZTxFYGcIvzxM9hUIcpTS1lyYkwfQjUchlSsmAQEgCAEMcz9p39ethR-OZ-ogdzS7I',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildExploreCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSpeakers(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSpeakerCard(
            context,
            name: 'د. جون أندرسون',
            title: 'خبير زراعة الأسنان',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD1aO9_-4QnzOS-rfAugI_NA_vSu-wvsPFHsWJd8yGCIp3W1Q23_PsrYDnsvmxC4GzHpTtbzuxxZGbAsdciRq_GsIX5VLCiXXjiGQOLmBZ9rPjwZ0Dq80wRgJWpRyKEvKnsReEov933D6L2ZvVETA38rMuSqTvPwrvxezW2ZysPAR-98bDxdWHHMOiaiRR60A4ExOLjvB4-TCOjZyMenWTu84mACSiLKgs8xCRzmylMmCF4ypCvqf2_2RnZMx2Ku9mRXPZg7q3SN-6S',
          ),
          _buildSpeakerCard(
            context,
            name: 'د. إيلينا بتروفا',
            title: 'طب الأسنان التجميلي',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD-J12u0xVEbXC36tU3kyiTTMLjaYpEfM0cUdBV9c2og1Lsocl6NmqWpUdXFHWp_jQm8ksdPgcKiaznwg5XDRAZ1a342duFLWoJGdC_bjsClNdi7bXU8t5iKT2m_gnISxm3a4NkkLDnCN9M7Ot_BhIG3VItklCcZCGY8HyCVwVVLTawXjJOphi6n4vuAaF1CFkdNhPr_DYozB4PR3t5rpSX0RY1V0VkdOi-sApJcvOMxZ7pPHw6Hpih1XwpJEVGttUco_niSuMXZlwo',
          ),
          _buildSpeakerCard(
            context,
            name: 'د. أحمد خان',
            title: 'تقويم الأسنان الرقمي',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA-bE6pTOfLb_DnZ6VwvNUk5vktBdedDyRIjFbyZaFKaVLjlwWIDichYWr8O2eIBmsVLQkgJEQJCWl89N0kwmwM7zih0SIkWH9gOhuXTns9waYMSvVmaGiwOleasedZSygB1NG7eIU-rhtLDWvRcPxQ3QITvblUHiKu36HNvO11L5LN_tXyfm-XP1A5ls_9HOVDROqg341GsGwgr_f6Ms0Yfrq46232Tp-tNt225JIvK7ax_B8IZKtlE6nQrmjRGoDbU3aknSYofrR-QtKa5',
          ),
          _buildSpeakerCard(
            context,
            name: 'د. فاطمة الزهراء',
            title: 'صحة أسنان الأطفال',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAsczs1NngRv_CBUXoszhXLiA1YD5_sTMGwV8jeP7sCDwupWxW8G9wM6wnLHmIZNBiLEa8yg0s8o_ebQ9uZZ0D8chQX1MQBKDTYLz0swAGv1ve9NyXp_ZpQxadrF6qLLoff4CWcNbzhVcevyC1-Hf0EoCRpWAkyggI-bd8e8HPwCg_pxE9FH2X-_XYPO78wJwjOfxfPe7tPtt7tMimUn_R2r4MoEAKeQTPKJLKg6JtzWDThex1FwIc2bSpjmKMgel8uuiJ8B1Y2BEe1',
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard(
    BuildContext context, {
    required String name,
    required String title,
    required String imageUrl,
  }) {
    return Container(
      width: 112,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExhibition(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBvNNu_cMhGlKW8J3VVpz9o_GQJ0shv7AOnDogxwvNTQFTsmUfV3GOd4J7u3trVsU6Aqtz8hdqxQz5bTp08jx3POWTaF34O3RnSkuX1Nz2Qx93Fr7ZRLa1L10_6cTzIgHab5U2_x9bqYrRXcEBBU7fQ5pulqFQJVNQoPL0A1_FToW09dldQ4VyLYqhp3Hu3C90SndS2vJ8vzhImhTBuTUWjK30Y0Cf3nHfK8OfQmbE7FyAy4Q6g0CT-XgBotHRg2lySg7HBrWD8v0Cr',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اكتشف أحدث التقنيات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'تعرف على العارضين والشركاء',
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
