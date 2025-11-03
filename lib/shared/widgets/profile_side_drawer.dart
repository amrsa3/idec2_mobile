import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/profile_model.dart';
import '../../services/compatible_auth_service.dart' show compatibleAuthProvider, CompatibleAuthState;
import '../widgets/profile_image_widget.dart';
import '../../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../../features/profile/presentation/screens/profile_main_screen.dart';
import '../../../features/profile/presentation/screens/user_documents_viewer_screen.dart';
import '../../../features/profile/providers/profile_provider.dart';
import '../../../features/registrations/presentation/my_registrations_screen.dart';

/// Widget مشترك للقائمة الجانبية في صفحات الملف الشخصي
class ProfileSideDrawer extends ConsumerWidget {
  final String? currentScreen; // 'profile', 'edit', 'documents', 'registrations'
  final ProfileModel? profile;

  const ProfileSideDrawer({
    super.key,
    this.currentScreen,
    this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(compatibleAuthProvider);
    final user = authState.user;
    
    // الحصول على profile من provider إذا لم يتم تمريره
    final currentProfile = profile ?? ref.watch(profileProvider).currentProfile;

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
                ProfileImageWidget(
                  imageUrl: user?.profile?.profilePhotoUrl,
                  size: 60,
                  fallbackText: user?.profile?.fullNameAr?.isNotEmpty == true
                      ? user!.profile!.fullNameAr![0].toUpperCase()
                      : (user?.profile?.fullNameEn?.isNotEmpty == true
                          ? user!.profile!.fullNameEn![0].toUpperCase()
                          : 'U'),
                  showEditIcon: false,
                  isEditable: false,
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
                  leading: Icon(
                    Icons.person_outline,
                    color: currentScreen == 'profile'
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  title: Text(
                    'الملف الشخصي',
                    style: TextStyle(
                      fontWeight: currentScreen == 'profile'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentScreen == 'profile'
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (currentScreen != 'profile') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileMainScreen(),
                        ),
                      );
                    }
                  },
                ),

                // تعديل الملف الشخصي
                if (currentProfile != null)
                  ListTile(
                    leading: Icon(
                      Icons.edit_outlined,
                      color: currentScreen == 'edit'
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      'تعديل البيانات',
                      style: TextStyle(
                        fontWeight: currentScreen == 'edit'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentScreen == 'edit'
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (currentScreen != 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileEditScreen(profile: currentProfile!),
                          ),
                        );
                      }
                    },
                  ),

                // عرض المستندات
                ListTile(
                  leading: Icon(
                    Icons.folder_outlined,
                    color: currentScreen == 'documents'
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  title: Text(
                    'مستنداتي',
                    style: TextStyle(
                      fontWeight: currentScreen == 'documents'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentScreen == 'documents'
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (currentScreen != 'documents') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserDocumentsViewerScreen(),
                        ),
                      );
                    }
                  },
                ),

                // اشتراكاتي
                ListTile(
                  leading: Icon(
                    Icons.event_note,
                    color: currentScreen == 'registrations'
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  title: Text(
                    'اشتراكاتي',
                    style: TextStyle(
                      fontWeight: currentScreen == 'registrations'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: currentScreen == 'registrations'
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (currentScreen != 'registrations') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyRegistrationsScreen(),
                        ),
                      );
                    }
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
                  onTap: () => _showLogoutDialog(context, ref, l10n),
                ),
              ],
            ),
          ),

          // معلومات التطبيق في أسفل القائمة
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'تطبيق IDEC\nالإصدار 2.0.1',
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
  void _showLogoutDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
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
                await _performLogout(context, ref);
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
  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
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

      // إغلاق مؤشر التحميل والانتقال إلى صفحة تسجيل الدخول
      if (context.mounted) {
        Navigator.of(context).pop(); // إغلاق dialog التحميل
        
        // الانتقال إلى صفحة تسجيل الدخول
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
      }
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة الخطأ
      if (context.mounted) {
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
}

