import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widgets.dart';
import '../../../../models/user_profile_extended.dart';
import '../../../../models/profile_rule_model.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/governorate_model.dart' hide QualificationModel;
import '../../../../models/profile_data_models.dart';
import '../../providers/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/verification_status_badge.dart';
import '../widgets/verification_notification_banner.dart';
import '../../../../shared/widgets/profile_picture_widget.dart';
import 'profile_edit_screen.dart';
import 'document_management_screen.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';

/// شاشة عرض الملف الشخصي الرئيسية
class ProfileMainScreen extends ConsumerStatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  ConsumerState<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends ConsumerState<ProfileMainScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل بيانات الملف الشخصي عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final currentProfile = profileState.currentProfile;
    final l10n = AppLocalizations.of(context)!;

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
  Widget _buildSideDrawer(BuildContext context, AppLocalizations l10n, ProfileModel? profile) {
    final authState = ref.watch(authProvider);
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
                ProfilePictureWidget(
                  imageUrl: profile?.profilePictureUrl,
                  size: 60,
                  fallbackText: user?.fullNameAr?.isNotEmpty == true 
                      ? user!.fullNameAr![0].toUpperCase()
                      : user?.fullNameEn?.isNotEmpty == true
                          ? user!.fullNameEn![0].toUpperCase()
                          : '?',
                  showEditIcon: false, // لا نريد إظهار أيقونة التعديل في القائمة الجانبية
                ),
                const SizedBox(height: 12),
                // اسم المستخدم
                Text(
                  user?.fullNameAr ?? user?.fullNameEn ?? 'المستخدم',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // البريد الإلكتروني
                if (user?.email != null)
                  Text(
                    user!.email!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
                    leading: Icon(Icons.edit_outlined, color: AppColors.primary),
                    title: const Text('تعديل البيانات'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToEditProfile(context, profile);
                    },
                  ),
                
                // إدارة الوثائق
                if (profile != null)
                  ListTile(
                    leading: Icon(Icons.folder_outlined, color: AppColors.primary),
                    title: const Text('إدارة الوثائق'),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToDocumentManagement(context, profile);
                    },
                  ),
                
                const Divider(),
                
                // الإعدادات
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة الإعدادات
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم إضافة صفحة الإعدادات قريباً')),
                    );
                  },
                ),
                
                // المساعدة
                ListTile(
                  leading: Icon(Icons.help_outline, color: AppColors.textSecondary),
                  title: const Text('المساعدة'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة المساعدة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم إضافة صفحة المساعدة قريباً')),
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
      await ref.read(authProvider.notifier).logout();

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
              ElevatedButton.icon(
                onPressed: () => ref.read(profileProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final profile = state.currentProfile;
    if (profile == null) {
      return const Center(
        child: Text(
          'لم يتم العثور على بيانات الملف الشخصي',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بانر الإشعارات
          if (profile.verificationStatus == VerificationStatus.rejected && profile.rejectionReason != null)
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
          
          if (profile.verificationStatus == VerificationStatus.verified)
            _buildNotificationBanner(
              'تم توثيق حسابك بنجاح! يمكنك الآن الاشتراك في المؤتمرات والفعاليات',
              AppColors.success,
              Icons.check_circle_outline,
            ),

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

          // الوثائق
          _buildDocumentsSection(profile),
          
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
              ProfilePictureWidget(
                imageUrl: profile.profilePictureUrl,
                size: 80,
                fallbackText: profile.fullNameAr?.isNotEmpty == true 
                    ? profile.fullNameAr![0].toUpperCase()
                    : profile.fullNameEn?.isNotEmpty == true
                        ? profile.fullNameEn![0].toUpperCase()
                        : '?',
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
                    
                    // البريد الإلكتروني
                    if (profile.email != null)
                      Text(
                        profile.email!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
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
        _buildDataRow('الاسم العربي', profile.fullNameAr),
        _buildDataRow('الاسم الإنجليزي', profile.fullNameEn),
        _buildDataRow('البريد الإلكتروني', profile.email),
        _buildDataRow(
          'تاريخ الميلاد',
          profile.birthDate != null
              ? DateFormat('yyyy/MM/dd').format(profile.birthDate!)
              : null,
        ),
        _buildDataRow('المحافظة', _getGovernorateDisplayName(profile.governorateId, ref)),
      ],
    );
  }

  Widget _buildAcademicDataSection(ProfileModel profile) {
    return _buildSection(
      title: 'البيانات الأكاديمية',
      icon: Icons.school_outlined,
      children: [
        _buildDataRow('المؤهل العلمي', _getQualificationDisplayName(profile.qualificationId, ref)),
        _buildDataRow('سنة التخرج', profile.graduationYear?.toString()),
        _buildDataRow('الجامعة', profile.university),
        _buildDataRow('مكان العمل', profile.workplace),
      ],
    );
  }

  Widget _buildDocumentsSection(ProfileModel profile) {
    final hasDocuments = profile.documents.isNotEmpty;
    final verificationRules = ref.read(profileProvider).verificationRules;
    
    // جمع الوثائق المطلوبة حسب القواعد الديناميكية
    final requiredDocuments = <String>[];
    // إضافة الوثائق الأساسية المطلوبة
    requiredDocuments.addAll(['identity', 'qualification']);
    
    return _buildSection(
      title: 'الوثائق المرفقة',
      icon: Icons.description_outlined,
      children: [
        // عرض الوثائق المطلوبة
        if (requiredDocuments.isNotEmpty) ...[
          Text(
            'الوثائق المطلوبة:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...requiredDocuments.map((fieldName) => _buildRequiredDocumentRow(
            fieldName, 
            _getDocumentUrl(profile, fieldName),
          )),
          const SizedBox(height: 16),
        ],
        
        // عرض الوثائق الموجودة
        if (!hasDocuments && requiredDocuments.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'لم يتم رفع أي وثائق بعد',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else if (hasDocuments && requiredDocuments.isEmpty)
          ...profile.documents.map(
            (doc) => _buildDocumentRow(doc.documentType.toString(), doc.fileUrl),
          ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _navigateToDocumentManagement(context, profile),
            icon: const Icon(Icons.upload_file),
            label: const Text('إدارة الوثائق'),
          ),
        ),
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
                color: value != null ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String fieldName, String documentUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getDocumentDisplayName(fieldName),
              style: AppTextStyles.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: () => _viewDocument(context, documentUrl),
            icon: const Icon(Icons.visibility_outlined),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocumentRow(String fieldName, String? documentUrl) {
    final hasDocument = documentUrl != null && documentUrl.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            hasDocument ? Icons.check_circle : Icons.warning,
            color: hasDocument ? AppColors.success : AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getDocumentDisplayName(fieldName),
              style: AppTextStyles.bodyMedium.copyWith(
                color: hasDocument ? AppColors.textPrimary : AppColors.warning,
              ),
            ),
          ),
          if (hasDocument)
            IconButton(
              onPressed: () => _viewDocument(context, documentUrl!),
              icon: const Icon(Icons.visibility_outlined),
              iconSize: 20,
            )
          else
            Text(
              'مطلوب',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProfileModel profile) {
    final verificationRules = ref.read(profileProvider).verificationRules;
    final canEdit = _canEditProfile(profile, verificationRules);
    final canSubmitForVerification = _canSubmitForVerification(profile, verificationRules);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canEdit ? () => _navigateToEditProfile(context, profile) : null,
            icon: const Icon(Icons.edit),
            label: const Text('تعديل البيانات'),
          ),
        ),
        
        const SizedBox(height: 12),
        
        if (profile.verificationStatus != VerificationStatus.verified && profile.verificationStatus != VerificationStatus.underReview)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canSubmitForVerification
                  ? () => _submitForVerification(context, ref, profile)
                  : null,
              icon: const Icon(Icons.verified_user),
              label: const Text('طلب توثيق الحساب'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
            ),
          ),
      ],
    );
  }

  // Helper methods
  bool _canEditProfile(ProfileModel profile, dynamic verificationRules) {
    // السماح بالتعديل دائماً للملفات غير الموثقة
    if (profile.verificationStatus == VerificationStatus.unverified) return true;
    
    // منع التعديل للملفات قيد المراجعة
    if (profile.verificationStatus == VerificationStatus.underReview) return false;
    
    // السماح بالتعديل المحدود للملفات الموثقة والمرفوضة
    return true;
  }
  
  bool _canSubmitForVerification(ProfileModel profile, dynamic verificationRules) {
    // التحقق من نسبة الاكتمال
    if (profile.completionPercentage < 80) return false;
    
    // التحقق من الوثائق المطلوبة
    final requiredDocuments = ['identity', 'qualification'];
    
    // التحقق من وجود جميع الوثائق المطلوبة
    for (final fieldName in requiredDocuments) {
      final hasDocument = profile.documents.any((doc) => doc.documentType.toString().contains(fieldName));
      if (!hasDocument) {
        return false;
      }
    }
    
    return true;
  }

  String _getGovernorateDisplayName(String? governorateId, WidgetRef ref) {
    final governorates = ref.read(profileProvider).governorates;
    if (governorates != null && governorateId != null) {
      final governorate = governorates.firstWhere(
        (g) => g.id == governorateId,
        orElse: () => GovernorateModel(id: '', name: 'غير محدد', nameAr: 'غير محدد'),
      );
      return governorate.nameAr;
    }
    return 'غير محدد';
  }

  String _getQualificationDisplayName(String? qualificationId, WidgetRef ref) {
    final qualifications = ref.read(profileProvider).qualifications;
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

  String _getDocumentDisplayName(String fieldName) {
    switch (fieldName) {
      case 'qualification':
      case 'qualificationId':
        return 'وثيقة المؤهل العلمي';
      case 'identity':
        return 'وثيقة الهوية';
      case 'certificate':
        return 'الشهادات';
      case 'graduationCertificate':
        return 'شهادة التخرج';
      case 'workCertificate':
        return 'شهادة العمل';
      default:
        return fieldName;
    }
  }

  // Navigation methods
  void _navigateToEditProfile(BuildContext context, ProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(profile: profile),
      ),
    );
  }

  void _navigateToDocumentManagement(BuildContext context, ProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentManagementScreen(profile: profile),
      ),
    );
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

  String? _getDocumentUrl(ProfileModel profile, String fieldName) {
    final docType = _getDocumentTypeFromString(fieldName);
    try {
      final doc = profile.documents.firstWhere(
        (doc) => doc.documentType == docType,
      );
      return doc.fileUrl;
    } catch (e) {
      return null;
    }
  }

  DocumentType _getDocumentTypeFromString(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'qualification':
        return DocumentType.qualification;
      case 'identity':
        return DocumentType.identity;
      case 'certificate':
        return DocumentType.certificate;
      case 'license':
        return DocumentType.license;
      default:
        return DocumentType.other;
    }
  }

  void _viewDocument(BuildContext context, String documentUrl) {
    // TODO: Implement document viewer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تنفيذ عارض الوثائق قريباً')),
    );
  }

  void _submitForVerification(BuildContext context, WidgetRef ref, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب توثيق الحساب'),
        content: const Text(
          'هل أنت متأكد من أنك تريد إرسال طلب توثيق الحساب؟\n\n'
          'سيتم مراجعة بياناتك والوثائق المرفقة من قبل الإدارة.',
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
            child: const Text('إرسال الطلب'),
          ),
        ],
      ),
    );
  }
}