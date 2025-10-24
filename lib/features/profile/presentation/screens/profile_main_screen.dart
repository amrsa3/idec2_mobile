import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/governorate_model.dart' hide QualificationModel;
import '../../../../models/profile_data_models.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/profile_rule_model.dart';
import '../../../../providers/profile_rules_provider.dart';
import '../../../../services/compatible_auth_service.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/profile_image_widget.dart';
import '../../providers/profile_provider.dart';
import '../widgets/verification_status_badge.dart';
import 'profile_edit_screen.dart';

/// شاشة عرض الملف الشخصي الرئيسية
class ProfileMainScreen extends ConsumerStatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  ConsumerState<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends ConsumerState<ProfileMainScreen> {
  // متغير لتتبع حالة ظهور إشعار التوثيق
  bool _showVerificationNotification = true;
  Timer? _verificationNotificationTimer;

  @override
  void initState() {
    super.initState();
    // تحميل بيانات الملف الشخصي وقواعد التعديل عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  /// Load profile data with retry mechanism
  Future<void> _loadProfileData({int retryCount = 0}) async {
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 1000);

    try {
      // تحديث حالة المصادقة أولاً
      ref.read(compatibleAuthProvider.notifier).refreshAuthState();
      
      // Check if user is authenticated before loading profile
      final authState = ref.read(compatibleAuthProvider);
      debugPrint(
          'ProfileMainScreen: Auth state - isAuthenticated: ${authState.isAuthenticated}, sessionExpired: ${authState.sessionExpired}, isLoading: ${authState.isLoading}');

      if (authState.isAuthenticated &&
          !authState.sessionExpired &&
          !authState.isLoading) {
        debugPrint(
            'ProfileMainScreen: Loading profile data (attempt ${retryCount + 1})');
        // تحميل بيانات الملف الشخصي مع البيانات المرجعية (المحافظات والمؤهلات)
        ref.read(profileProvider.notifier).loadProfile(forceRefresh: true);
        // تحميل قواعد الملف الشخصي
        ref.read(profileRulesProvider.notifier).loadRulesForCurrentUser();
      } else if (authState.isLoading && retryCount < maxRetries) {
        // Auth is still loading, wait and retry
        debugPrint(
            'ProfileMainScreen: Auth still loading, waiting and retrying...');
        await Future.delayed(retryDelay);
        return _loadProfileData(retryCount: retryCount + 1);
      } else if (!authState.isAuthenticated && retryCount < maxRetries) {
        // Not authenticated yet, wait and retry
        debugPrint(
            'ProfileMainScreen: Not authenticated yet, waiting and retrying...');
        await Future.delayed(retryDelay);
        return _loadProfileData(retryCount: retryCount + 1);
      } else {
        // User is not authenticated or session expired
        debugPrint(
            'ProfileMainScreen: User not authenticated or session expired');
        debugPrint(
            'ProfileMainScreen: Auth details - isAuthenticated: ${authState.isAuthenticated}, sessionExpired: ${authState.sessionExpired}, user: ${authState.user?.phone}');
        debugPrint(
            'ProfileMainScreen: Error: ${authState.error}');
        
        debugPrint(
            'ProfileMainScreen: Failed to load profile after $maxRetries attempts');
        // Show error message or redirect to login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'انتهاء صلاحية جلسة العمل. يرجى تسجيل الدخول مرة أخرى.'),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: 'تسجيل الدخول',
                textColor: Colors.white,
                onPressed: () => context.go(AppRoutes.login),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('ProfileMainScreen: Error loading profile data: $e');
      if (retryCount < maxRetries) {
        debugPrint(
            'ProfileMainScreen: Retrying due to error (attempt ${retryCount + 1})');
        await Future.delayed(retryDelay);
        return _loadProfileData(retryCount: retryCount + 1);
      }
    }
  }

  @override
  void dispose() {
    _verificationNotificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final currentProfile = profileState.currentProfile;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'الملف الشخصي',
        actions: [
          if (currentProfile != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _navigateToEditProfile(context, currentProfile),
            ),
          // زر القائمة الجانبية
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      // القائمة الجانبية
      endDrawer: _buildSideDrawer(context, l10n, currentProfile),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileProvider.notifier).refresh(),
        child: _buildBody(profileState),
      ),
    );
  }

  // إنشاء القائمة الجانبية
  Widget _buildSideDrawer(
      BuildContext context, AppLocalizations l10n, ProfileModel? profile) {
    final authState = ref.watch(compatibleAuthProvider);
    final user = authState.user;

    return Drawer(
      child: Column(
        children: [
          // رأس القائمة الجانبية
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المستخدم
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (profile != null) {
                      _showProfileImageOptions(context, profile);
                    }
                  },
                  child: ProfileImageWidget(
                    imageUrl: user?.profile
                        ?.profilePhotoUrl, // Use profile.profilePhotoUrl
                    size: 60,
                    fallbackText: user?.profile?.fullNameAr?.isNotEmpty == true
                        ? user!.profile!.fullNameAr![0].toUpperCase()
                        : (user?.profile?.fullNameEn?.isNotEmpty == true
                            ? user!.profile!.fullNameEn![0].toUpperCase()
                            : 'U'),
                    showEditIcon: false,
                    isEditable: false,
                  ),
                ),
                const SizedBox(height: 12),
                // اسم المستخدم
                Text(
                  user?.profile?.fullNameAr ??
                      user?.profile?.fullNameEn ??
                      'المستخدم',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // عناصر القائمة
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // الملف الشخصي
                ListTile(
                  leading: Icon(Icons.person_outline, color: AppColors.primary),
                  title: const Text('الملف الشخصي'),
                  onTap: () {
                    Navigator.pop(context);
                    // نحن بالفعل في صفحة الملف الشخصي
                  },
                ),

                // تعديل الملف الشخصي
                if (profile != null)
                  ListTile(
                    leading:
                        Icon(Icons.edit_outlined, color: AppColors.primary),
                    title: const Text('تعديل البيانات'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToEditProfile(context, profile);
                    },
                  ),

                const Divider(),

                // الإعدادات
                ListTile(
                  leading: Icon(Icons.settings_outlined,
                      color: AppColors.textSecondary),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة الإعدادات
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('سيتم إضافة صفحة الإعدادات قريباً')),
                    );
                  },
                ),

                // المساعدة
                ListTile(
                  leading:
                      Icon(Icons.help_outline, color: AppColors.textSecondary),
                  title: const Text('المساعدة'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة المساعدة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('سيتم إضافة صفحة المساعدة قريباً')),
                    );
                  },
                ),

                const Divider(),

                // تسجيل الخروج
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    l10n.logout,
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () => _showLogoutDialog(context, l10n),
                ),
              ],
            ),
          ),

          // معلومات التطبيق في أسفل القائمة
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'تطبيق IDEC\nالإصدار 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض dialog تأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.confirmLogout),
          content: Text(l10n.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // إغلاق الـ dialog
                Navigator.of(context).pop(); // إغلاق القائمة الجانبية
                await _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.logoutButton),
            ),
          ],
        );
      },
    );
  }

  // تنفيذ عملية تسجيل الخروج
  Future<void> _performLogout() async {
    try {
      // عرض مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // تسجيل الخروج
      await ref.read(compatibleAuthProvider.notifier).logout();

      // إغلاق مؤشر التحميل
      if (mounted) {
        Navigator.of(context).pop();

        // الانتقال إلى صفحة تسجيل الدخول
        context.go(AppRoutes.login);
      }
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة الخطأ
      if (mounted) {
        Navigator.of(context).pop();

        // عرض رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تسجيل الخروج: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                state.error!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _loadProfileData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => ref
                        .read(profileProvider.notifier)
                        .loadCurrentProfile(forceRefresh: true),
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('إعادة تحميل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final profile = state.currentProfile;
    if (profile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'لم يتم العثور على بيانات الملف الشخصي',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _loadProfileData(),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة تحميل البيانات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بانر الإشعارات
          if (profile.verificationStatus == VerificationStatus.rejected &&
              profile.rejectionReason != null)
            _buildNotificationBanner(
              'رُفض طلب التوثيق: ${profile.rejectionReason!}',
              AppColors.error,
              Icons.error_outline,
            ),

          if (profile.verificationStatus == VerificationStatus.underReview)
            _buildNotificationBanner(
              'طلب التوثيق قيد المراجعة من قبل الإدارة',
              AppColors.warning,
              Icons.pending_outlined,
            ),

          if (profile.verificationStatus == VerificationStatus.verified &&
              _showVerificationNotification)
            _buildVerificationSuccessNotification(),

          const SizedBox(height: 16),

          // معلومات الملف الشخصي الأساسية
          _buildProfileHeader(profile),

          const SizedBox(height: 24),

          // البيانات الشخصية
          _buildPersonalDataSection(profile),

          const SizedBox(height: 24),

          // البيانات الأكاديمية
          _buildAcademicDataSection(profile),

          const SizedBox(height: 24),

          // أزرار الإجراءات
          _buildActionButtons(profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // صورة الملف الشخصي
              ProfileImageWidget(
                imageUrl: profile.profilePictureUrl,
                size: 80,
                fallbackText: profile.fullNameAr.isNotEmpty
                    ? profile.fullNameAr[0].toUpperCase()
                    : (profile.fullNameEn.isNotEmpty
                        ? profile.fullNameEn[0].toUpperCase()
                        : 'U'),
                showEditIcon: true,
                isEditable: true,
                onImageChanged: () {
                  // إعادة تحميل البيانات بعد تغيير الصورة
                  ref.refresh(profileProvider);
                },
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم
                    Text(
                      profile.fullNameAr ?? profile.fullNameEn ?? 'غير محدد',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // المؤهل العلمي (يظهر فقط للحسابات الموثقة)
                    if (profile.verificationStatus == VerificationStatus.verified && 
                        profile.qualificationId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getQualificationDisplayName(profile.qualificationId, ref),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // حالة التوثيق
                    VerificationStatusBadge(status: profile.verificationStatus),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // شريط التقدم
          _buildCompletionProgress(profile),
        ],
      ),
    );
  }

  Widget _buildCompletionProgress(ProfileModel profile) {
    final percentage = profile.completionPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اكتمال الملف الشخصي',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toInt()}%',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage >= 80 ? AppColors.success : AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildPersonalDataSection(ProfileModel profile) {
    return _buildSection(
      title: 'البيانات الشخصية',
      icon: Icons.person_outline,
      children: [
        _buildDataRowWithRules(
            'الاسم العربي', profile.fullNameAr, 'fullNameAr', profile),
        _buildDataRowWithRules(
            'الاسم الإنجليزي', profile.fullNameEn, 'fullNameEn', profile),
        _buildDataRowWithRules(
            'البريد الإلكتروني', profile.email, 'email', profile),
        _buildDataRowWithRules(
          'تاريخ الميلاد',
          profile.birthDate != null
              ? DateFormat('yyyy/MM/dd').format(profile.birthDate!)
              : null,
          'birthDate',
          profile,
        ),
        _buildDataRowWithRules(
            'المحافظة',
            _getGovernorateDisplayName(profile.governorateId, ref),
            'governorateId',
            profile),
      ],
    );
  }

  Widget _buildAcademicDataSection(ProfileModel profile) {
    return _buildSection(
      title: 'البيانات الأكاديمية',
      icon: Icons.school_outlined,
      children: [
        _buildDataRowWithRules(
            'المؤهل العلمي',
            _getQualificationDisplayName(profile.qualificationId, ref),
            'qualificationId',
            profile),
        _buildDataRowWithRules('سنة التخرج', profile.graduationYear?.toString(),
            'graduationYear', profile),
        _buildDataRowWithRules(
            'الجامعة', profile.university, 'university', profile),
        _buildDataRowWithRules(
            'مكان العمل', profile.workplace, 'workplace', profile),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'غير محدد',
              style: AppTextStyles.bodyMedium.copyWith(
                color: value != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة محسنة لعرض الحقول مع المؤشرات البصرية حسب القواعد
  Widget _buildDataRowWithRules(
      String label, String? value, String fieldName, ProfileModel profile) {
    final rulesNotifier = ref.read(profileRulesProvider.notifier);
    final profileStatus =
        _convertVerificationStatusToProfileStatus(profile.verificationStatus);
    final isEditable = rulesNotifier.canEditField(fieldName, profileStatus);
    final requiresDocument =
        rulesNotifier.fieldRequiresDocument(fieldName, profileStatus);
    final isRequired =
        rulesNotifier.getRequiredFieldsForVerification().contains(fieldName);

    // تحديد لون الخلفية حسب حالة الحقل
    Color? backgroundColor;
    IconData? statusIcon;
    Color? iconColor;
    String? tooltip;

    if (!isEditable) {
      backgroundColor = AppColors.textSecondary.withOpacity(0.1);
      statusIcon = Icons.lock_outline;
      iconColor = AppColors.textSecondary;
      tooltip = 'هذا الحقل مقفل ولا يمكن تعديله';
    } else if (isRequired && (value == null || value.trim().isEmpty)) {
      backgroundColor = AppColors.error.withOpacity(0.1);
      statusIcon = Icons.error_outline;
      iconColor = AppColors.error;
      tooltip = 'هذا الحقل مطلوب للتوثيق';
    } else if (requiresDocument) {
      final hasDocument = profile.documents.any((doc) => doc.documentType
          .toString()
          .toLowerCase()
          .contains(fieldName.toLowerCase()));
      if (hasDocument) {
        backgroundColor = AppColors.success.withOpacity(0.1);
        statusIcon = Icons.check_circle_outline;
        iconColor = AppColors.success;
        tooltip = 'تم رفع الوثيقة المطلوبة';
      } else {
        backgroundColor = AppColors.warning.withOpacity(0.1);
        statusIcon = Icons.upload_file_outlined;
        iconColor = AppColors.warning;
        tooltip = 'يتطلب رفع وثيقة';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: backgroundColor != null
            ? Border.all(
                color: iconColor?.withOpacity(0.3) ?? Colors.transparent)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (statusIcon != null)
                  Tooltip(
                    message: tooltip ?? '',
                    child: Icon(
                      statusIcon,
                      size: 16,
                      color: iconColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'غير محدد',
              style: AppTextStyles.bodyMedium.copyWith(
                color: value != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProfileModel profile) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToEditProfile(context, profile),
            icon: const Icon(Icons.edit),
            label: const Text('تعديل البيانات'),
          ),
        ),
      ],
    );
  }

  // Helper methods

  // تحويل VerificationStatus إلى ProfileStatus
  ProfileStatus _convertVerificationStatusToProfileStatus(
      VerificationStatus status) {
    switch (status) {
      case VerificationStatus.unverified:
        return ProfileStatus.unverified;
      case VerificationStatus.underReview:
        return ProfileStatus.pendingVerification;
      case VerificationStatus.verified:
        return ProfileStatus.verified;
      case VerificationStatus.rejected:
        return ProfileStatus.rejected;
    }
  }

  bool _canSubmitForVerification(
      ProfileModel profile, dynamic verificationRules) {
    // استخدام ProfileRulesProvider للتحقق من متطلبات التوثيق
    final rulesNotifier = ref.read(profileRulesProvider.notifier);

    // التحقق من حالة التوثيق الحالية
    if (profile.verificationStatus == VerificationStatus.verified) {
      return false; // الملف موثق بالفعل
    }

    if (profile.verificationStatus == VerificationStatus.underReview) {
      return false; // الملف قيد المراجعة
    }

    // التحقق من نسبة الاكتمال المطلوبة حسب القواعد
    final requiredCompletionPercentage =
        rulesNotifier.getRequiredCompletionPercentage();
    if (profile.completionPercentage < requiredCompletionPercentage) {
      return false;
    }

    // التحقق من الحقول المطلوبة حسب القواعد
    final requiredFields = rulesNotifier.getRequiredFieldsForVerification();
    for (final fieldName in requiredFields) {
      final fieldValue = _getFieldValue(profile, fieldName);
      if (fieldValue == null || fieldValue.toString().trim().isEmpty) {
        return false;
      }
    }

    // التحقق من الوثائق المطلوبة حسب القواعد
    final requiredDocuments =
        rulesNotifier.getRequiredDocumentsForVerification();
    for (final documentType in requiredDocuments) {
      final hasDocument = profile.documents.any((doc) => doc.documentType
          .toString()
          .toLowerCase()
          .contains(documentType.toLowerCase()));
      if (!hasDocument) {
        return false;
      }
    }

    return true;
  }

  // دالة مساعدة للحصول على قيمة الحقل
  dynamic _getFieldValue(ProfileModel profile, String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'fullnamear':
      case 'full_name_ar':
      case 'arabicname':
      case 'arabic_name':
        return profile.fullNameAr;
      case 'fullnameen':
      case 'full_name_en':
      case 'englishname':
      case 'english_name':
        return profile.fullNameEn;
      case 'email':
        return profile.email;
      case 'birthdate':
      case 'birth_date':
        return profile.birthDate;
      case 'governorate':
      case 'governorateid':
      case 'governorate_id':
        return profile.governorateId;
      case 'qualification':
      case 'qualificationid':
      case 'qualification_id':
        return profile.qualificationId;
      case 'graduationyear':
      case 'graduation_year':
        return profile.graduationYear;
      case 'university':
        return profile.university;
      case 'workplace':
        return profile.workplace;
      default:
        return null;
    }
  }

  String _getGovernorateDisplayName(String? governorateId, WidgetRef ref) {
    final governorates = ref.watch(profileProvider).governorates;
    if (governorates != null && governorateId != null) {
      final governorate = governorates.firstWhere(
        (g) => g.id == governorateId,
        orElse: () =>
            GovernorateModel(id: '', name: 'غير محدد', nameAr: 'غير محدد'),
      );
      return governorate.nameAr;
    }
    return 'غير محدد';
  }

  String _getQualificationDisplayName(String? qualificationId, WidgetRef ref) {
    final qualifications = ref.watch(profileProvider).qualifications;
    if (qualifications != null && qualificationId != null) {
      final qualification = qualifications.firstWhere(
        (q) => q.id == qualificationId,
        orElse: () => QualificationModel(
          id: '',
          nameAr: 'غير محدد',
          nameEn: '',
          requiresDocument: false,
          isActive: true,
          description: '',
          sortOrder: 0,
        ),
      );
      return qualification.nameAr;
    }
    return 'غير محدد';
  }

  // Navigation methods
  void _navigateToEditProfile(BuildContext context, ProfileModel profile) {
    // الانتقال إلى شاشة التعديل مع callback لتحديث البيانات عند العودة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(profile: profile),
      ),
    ).then((result) {
      // تحديث البيانات فقط إذا كان هناك تحديث فعلي
      if (result == true) {
        debugPrint(
            'ProfileMainScreen: Profile was updated, refreshing data...');
        _loadProfileData();
        // تحديث قواعد التعديل أيضاً
        ref.read(profileRulesProvider.notifier).loadRules();
      } else {
        debugPrint(
            'ProfileMainScreen: No profile update, skipping refresh...');
        // فقط تحديث خفيف للحالة دون إعادة تحميل من الخادم
         ref.read(profileProvider.notifier).lightRefresh();
      }
    });
  }

  // Action methods
  void _showProfileImageOptions(BuildContext context, ProfileModel profile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                _updateProfilePicture(context, isCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _updateProfilePicture(context, isCamera: false);
              },
            ),
            if (profile.profilePictureUrl != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('حذف الصورة'),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePicture(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _updateProfilePicture(BuildContext context, {required bool isCamera}) {
    // TODO: Implement profile picture update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تنفيذ هذه الميزة قريباً')),
    );
  }

  void _removeProfilePicture(BuildContext context) {
    // TODO: Implement profile picture removal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تنفيذ هذه الميزة قريباً')),
    );
  }

  // دالة لبدء Timer إخفاء إشعار التوثيق
  void _startVerificationNotificationTimer() {
    _verificationNotificationTimer?.cancel();
    _verificationNotificationTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showVerificationNotification = false;
        });
      }
    });
  }

  // دالة لإخفاء إشعار التوثيق يدوياً
  void _hideVerificationNotification() {
    _verificationNotificationTimer?.cancel();
    setState(() {
      _showVerificationNotification = false;
    });
  }

  // دالة لبناء إشعار نجاح التوثيق مع بدء Timer
  Widget _buildVerificationSuccessNotification() {
    // بدء Timer عند عرض الإشعار
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVerificationNotificationTimer();
    });

    return _buildNotificationBanner(
      'تم توثيق حسابك بنجاح! يمكنك الآن الاشتراك في المؤتمر والفعاليات',
      AppColors.success,
      Icons.check_circle_outline,
    );
  }

  Widget _buildNotificationBanner(String message, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForVerification(
      BuildContext context, WidgetRef ref, ProfileModel profile) {
    final rulesNotifier = ref.read(profileRulesProvider.notifier);

    // التحقق من المتطلبات قبل عرض الحوار
    final missingRequirements =
        _getMissingVerificationRequirements(profile, rulesNotifier);

    if (missingRequirements.isNotEmpty) {
      // عرض رسالة بالمتطلبات المفقودة
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('متطلبات التوثيق غير مكتملة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('يرجى إكمال المتطلبات التالية قبل طلب التوثيق:'),
              const SizedBox(height: 12),
              ...missingRequirements.map((requirement) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(requirement)),
                      ],
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToEditProfile(context, profile);
              },
              child: const Text('تعديل الملف الشخصي'),
            ),
          ],
        ),
      );
      return;
    }

    // عرض حوار التأكيد مع تفاصيل المراجعة
    final requiredDocuments =
        rulesNotifier.getRequiredDocumentsForVerification();
    final requiredFields = rulesNotifier.getRequiredFieldsForVerification();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب توثيق الحساب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هل أنت متأكد من أنك تريد إرسال طلب توثيق الحساب؟'),
            const SizedBox(height: 16),
            const Text('سيتم مراجعة:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (requiredFields.isNotEmpty) ...[
              Text('• ${requiredFields.length} حقل مطلوب'),
            ],
            if (requiredDocuments.isNotEmpty) ...[
              Text('• ${requiredDocuments.length} وثيقة مطلوبة'),
            ],
            const SizedBox(height: 8),
            const Text(
              'ملاحظة: قد تستغرق عملية المراجعة من 1-3 أيام عمل.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(profileProvider.notifier).submitForVerification();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('إرسال الطلب'),
          ),
        ],
      ),
    );
  }

  // دالة للحصول على المتطلبات المفقودة للتوثيق
  List<String> _getMissingVerificationRequirements(
      ProfileModel profile, dynamic rulesNotifier) {
    final missingRequirements = <String>[];

    // التحقق من نسبة الاكتمال
    final requiredCompletionPercentage =
        rulesNotifier.getRequiredCompletionPercentage();
    if (profile.completionPercentage < requiredCompletionPercentage) {
      missingRequirements
          .add('إكمال الملف الشخصي ($requiredCompletionPercentage% مطلوب)');
    }

    // التحقق من الحقول المطلوبة
    final requiredFields = rulesNotifier.getRequiredFieldsForVerification();
    for (final fieldName in requiredFields) {
      final fieldValue = _getFieldValue(profile, fieldName);
      if (fieldValue == null || fieldValue.toString().trim().isEmpty) {
        missingRequirements
            .add('إكمال حقل: ${_getFieldDisplayName(fieldName)}');
      }
    }

    // التحقق من الوثائق المطلوبة
    final requiredDocuments =
        rulesNotifier.getRequiredDocumentsForVerification();
    for (final documentType in requiredDocuments) {
      final hasDocument = profile.documents.any((doc) => doc.documentType
          .toString()
          .toLowerCase()
          .contains(documentType.toLowerCase()));
      if (!hasDocument) {
        missingRequirements
            .add('رفع وثيقة: ${_getDocumentDisplayName(documentType)}');
      }
    }

    return missingRequirements;
  }

  // دالة للحصول على اسم الحقل للعرض
  String _getFieldDisplayName(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'arabicname':
      case 'arabic_name':
        return 'الاسم العربي';
      case 'englishname':
      case 'english_name':
        return 'الاسم الإنجليزي';
      case 'email':
        return 'البريد الإلكتروني';
      case 'birthdate':
      case 'birth_date':
        return 'تاريخ الميلاد';
      case 'governorate':
      case 'governorateid':
        return 'المحافظة';
      case 'qualification':
      case 'qualificationid':
        return 'المؤهل العلمي';
      case 'graduationyear':
      case 'graduation_year':
        return 'سنة التخرج';
      case 'university':
        return 'الجامعة';
      case 'workplace':
        return 'مكان العمل';
      case 'phonenumber':
      case 'phone_number':
        return 'رقم الهاتف';
      default:
        return fieldName;
    }
  }

  // دالة للحصول على اسم الوثيقة للعرض
  String _getDocumentDisplayName(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'identity':
        return 'وثيقة الهوية';
      case 'qualification':
        return 'وثيقة المؤهل العلمي';
      case 'passport':
        return 'جواز السفر';
      case 'certificate':
        return 'الشهادة';
      default:
        return documentType;
    }
  }
}
