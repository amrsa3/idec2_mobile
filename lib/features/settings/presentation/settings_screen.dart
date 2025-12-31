import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/biometric_service.dart';
import '../../main/providers/bottom_navigation_provider.dart';
import '../../auth/presentation/change_password_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(currentThemeModeProvider);
    final isRTL = ref.watch(isRTLProvider);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            if (isAuthenticated) ...[
              _buildSectionHeader(context, isRTL ? 'الحساب' : 'Account'),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context,
                isDark: isDark,
                children: [
                   _buildSettingsTile(
                    context,
                    icon: Icons.lock_outline,
                    title: isRTL ? 'تغيير كلمة المرور' : 'Change Password',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  _buildDivider(isDark),
                  _buildSettingsTile(
                    context,
                    icon: Icons.person_outline,
                    title: isRTL ? 'تعديل الملف الشخصي' : 'Edit Profile',
                    isDark: isDark,
                    onTap: () {
                      ref.read(bottomNavIndexProvider.notifier).state = 5; // Profile tab
                      context.pop();
                    },
                  ),
                  _buildDivider(isDark),
                  // Biometric login setting
                  Consumer(
                    builder: (context, ref, child) {
                      final biometricState = ref.watch(biometricProvider);
                      
                      if (!biometricState.isAvailable || biometricState.isLoading) {
                        return const SizedBox.shrink();
                      }
                      
                      final biometricService = BiometricService.instance;
                      final biometricName = biometricService.getBiometricTypeName(
                        biometricState.availableTypes,
                        isArabic: isRTL,
                      );
                      final biometricIcon = biometricService.getBiometricIcon(
                        biometricState.availableTypes,
                      );
                      
                      return _buildSettingsTile(
                        context,
                        icon: biometricIcon,
                        title: isRTL 
                            ? 'تسجيل الدخول بـ$biometricName'
                            : 'Login with $biometricName',
                        isDark: isDark,
                        trailing: Switch(
                          value: biometricState.isEnabled,
                          activeColor: AppColors.primary,
                          onChanged: (value) async {
                            if (value) {
                              // Show dialog to confirm enabling
                              final result = await _showBiometricEnableDialog(context, ref, isRTL);
                              if (result != true) return;
                            } else {
                              await ref.read(biometricProvider.notifier).setEnabled(false);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // App Settings
            _buildSectionHeader(context, isRTL ? 'التطبيق' : 'App'),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.palette_outlined,
                  title: isRTL ? 'مظهر التطبيق' : 'App Theme',
                  isDark: isDark,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<ThemeMode>(
                      value: themeMode,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.brightness_auto, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                isRTL ? 'تلقائي' : 'Auto',
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                style: TextStyle(
                                  fontFamily: isRTL ? 'Cairo' : null,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.light_mode, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                isRTL ? 'فاتح' : 'Light',
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                style: TextStyle(
                                  fontFamily: isRTL ? 'Cairo' : null,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.dark_mode, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                isRTL ? 'داكن' : 'Dark',
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                style: TextStyle(
                                  fontFamily: isRTL ? 'Cairo' : null,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          ref.read(themeProvider.notifier).setThemeMode(mode);
                        }
                      },
                    ),
                  ),
                ),
                _buildDivider(isDark),
                _buildSettingsTile(
                  context,
                  icon: Icons.language,
                  title: isRTL ? 'اللغة' : 'Language',
                  isDark: isDark,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<Locale>(
                      value: ref.watch(currentLocaleProvider),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: const Locale('ar'),
                          child: Text(
                            'العربية',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (locale) {
                        if (locale != null) {
                          ref.read(languageProvider.notifier).changeLanguage(locale);
                        }
                      },
                    ),
                  ),
                ),
                _buildDivider(isDark),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: isRTL ? 'الإشعارات' : 'Notifications',
                  isDark: isDark,
                  onTap: () {
                    context.push(AppRoutes.notifications);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // About & Support
            _buildSectionHeader(context, isRTL ? 'حول التطبيق' : 'About'),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: isRTL ? 'عن التطبيق' : 'About App',
                  isDark: isDark,
                  onTap: () => _showAboutDialog(context, isRTL),
                ),
                _buildDivider(isDark),
                _buildSettingsTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: isRTL ? 'سياسة الخصوصية' : 'Privacy Policy',
                  isDark: isDark,
                  onTap: () {},
                ),
                _buildDivider(isDark),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: isRTL ? 'المساعدة والدعم' : 'Help & Support',
                  isDark: isDark,
                  onTap: () {},
                ),
              ],
            ),

            if (isAuthenticated) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.confirmLogout),
                        content: Text(l10n.logoutConfirmation),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(l10n.logoutButton),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      ref.read(authProvider.notifier).logout();
                      context.go(AppRoutes.login);
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(l10n.logout, style: const TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children, bool isDark = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDark ? Colors.grey[400] : Colors.grey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: isDark ? const Color(0xFF424242) : Colors.grey[200],
    );
  }

  void _showAboutDialog(BuildContext context, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isRTL ? 'عن التطبيق' : 'About IDEC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medical_services_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'IDEC Conference App',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isRTL ? 'الإصدار 2.0.11' : 'Version 2.0.11',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              isRTL
                  ? 'تطبيق مؤتمر ومعرض آيدك الدولي لطب الأسنان'
                  : 'IDEC International Dental Conference & Exhibition',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRTL ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }
  
  Future<bool?> _showBiometricEnableDialog(BuildContext context, WidgetRef ref, bool isRTL) async {
    final passwordController = TextEditingController();
    bool obscurePassword = true;
    
    return showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.fingerprint, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isRTL ? 'تفعيل تسجيل الدخول بالبصمة' : 'Enable Biometric Login',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRTL 
                    ? 'لتفعيل تسجيل الدخول بالبصمة، يرجى إدخال كلمة المرور الحالية للتأكيد:'
                    : 'To enable biometric login, please enter your current password to confirm:',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: isRTL ? 'كلمة المرور' : 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(isRTL ? 'إلغاء' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRTL ? 'يرجى إدخال كلمة المرور' : 'Please enter password'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // Get stored phone from auth state
                final authState = ref.read(authProvider);
                final phone = authState.user?.phone ?? '';
                
                if (phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRTL ? 'خطأ في الحصول على معلومات المستخدم' : 'Error getting user info'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context, false);
                  return;
                }
                
                // Enable biometric with credentials
                await ref.read(biometricProvider.notifier).setEnabled(
                  true,
                  phone: phone,
                  password: passwordController.text,
                );
                
                final biometricState = ref.read(biometricProvider);
                if (biometricState.isEnabled) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isRTL ? 'تم تفعيل تسجيل الدخول بالبصمة' : 'Biometric login enabled'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true);
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(biometricState.error ?? (isRTL ? 'فشل التفعيل' : 'Failed to enable')),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context, false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isRTL ? 'تفعيل' : 'Enable'),
            ),
          ],
        ),
      ),
    );
  }
}
