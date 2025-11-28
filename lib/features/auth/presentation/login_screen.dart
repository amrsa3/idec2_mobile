import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/notification_service.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';
import '../../connectivity/presentation/connection_test_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _countryCode = '+967'; // Default to Yemen

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous errors
    ref.read(compatibleAuthProvider.notifier).clearError();

    try {
      final fullPhoneNumber = '$_countryCode${_phoneController.text.trim()}';

      debugPrint('LoginScreen: Attempting login for $fullPhoneNumber');

      final success =
          await ref.read(compatibleAuthProvider.notifier).loginWithPhone(
                fullPhoneNumber,
                _passwordController.text.trim(),
              );

      if (mounted) {
        if (success) {
          debugPrint('LoginScreen: Login successful, checking auth state...');

          // Check auth state after successful login
          final authState = ref.read(compatibleAuthProvider);
          debugPrint(
              'LoginScreen: Auth state - isAuthenticated: ${authState.isAuthenticated}');
          debugPrint(
              'LoginScreen: Auth state - user: ${authState.user?.phone}');
          debugPrint(
              'LoginScreen: Auth state - isLoading: ${authState.isLoading}');

          // إرسال إشعار نجاح عبر النظام المركزي
          // استخدام الرسالة من الخادم إذا كانت متوفرة
          String successTitle = 'تسجيل الدخول';
          String successMessage = 'تم تسجيل الدخول بنجاح';

          // محاولة استخراج الرسالة من استجابة الخادم
          if (authState.lastResponse != null) {
            final response = authState.lastResponse!;
            if (response.containsKey('messageAr') &&
                response.containsKey('messageEn')) {
              final messageAr = response['messageAr'] as String?;
              final messageEn = response['messageEn'] as String?;

              // اختيار الرسالة حسب لغة التطبيق
              final locale = Localizations.localeOf(context);
              if (locale.languageCode == 'ar' &&
                  messageAr != null &&
                  messageAr.isNotEmpty) {
                successMessage = messageAr;
              } else if (messageEn != null && messageEn.isNotEmpty) {
                successMessage = messageEn;
              }
            }
          }

          await NotificationService.showSuccess(
            title: successTitle,
            message: successMessage,
          );

          // Wait a moment for auth state to fully update, then navigate
          await Future.delayed(const Duration(milliseconds: 500));

          // Double check auth state before navigation
          final finalAuthState = ref.read(compatibleAuthProvider);
          debugPrint(
              'LoginScreen: Final auth state - isAuthenticated: ${finalAuthState.isAuthenticated}');

          // Navigate to main screen
          if (mounted) {
            debugPrint(
                'LoginScreen: Attempting navigation to ${AppRoutes.main}');
            context.go(AppRoutes.main);
            debugPrint('LoginScreen: Successfully navigated to main screen');

            // Force a rebuild to ensure the router picks up the auth state change
            await Future.delayed(const Duration(milliseconds: 100));
            if (mounted) {
              debugPrint('LoginScreen: Final navigation check completed');
            }
          }
        } else {
          // Check if the error is related to unverified phone number
          final authState = ref.read(compatibleAuthProvider);

          if (authState.error == 'phone_not_verified' &&
              authState.unverifiedPhoneNumber != null) {
            // Redirect to phone verification screen
            if (mounted) {
              // Show informative message first
              await NotificationService.showInfo(
                title: 'حسابك غير مؤكد',
                message:
                    'يرجى التحقق من رقم هاتفك لإكمال تسجيل الدخول. سيتم إرسال رمز التحقق الآن.',
              );

              // Wait a moment for user to read the message
              await Future.delayed(const Duration(milliseconds: 500));

              // First send OTP automatically
              try {
                final otpSent = await ref.read(compatibleAuthProvider.notifier).resendOtp(
                      authState.unverifiedPhoneNumber!,
                    );

                if (otpSent && mounted) {
                  // Navigate to OTP verification screen
                  context.go(
                    '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(authState.unverifiedPhoneNumber!)}&isLogin=true',
                  );

                  await NotificationService.showSuccess(
                    title: 'تم إرسال رمز التحقق',
                    message:
                        'تم إرسال رمز التحقق إلى رقم ${authState.unverifiedPhoneNumber}. يرجى إدخال الرمز للتحقق من حسابك.',
                  );
                } else {
                  // If OTP sending failed, still navigate to OTP screen so user can resend
                  if (mounted) {
                    context.go(
                      '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(authState.unverifiedPhoneNumber!)}&isLogin=true',
                    );
                    
                    await NotificationService.showInfo(
                      title: 'التحقق من رقم الهاتف',
                      message:
                          'يمكنك إعادة إرسال رمز التحقق من صفحة التحقق.',
                    );
                  }
                }
              } catch (otpError) {
                debugPrint('❌ [LOGIN_SCREEN] Failed to send OTP: $otpError');
                
                // Still navigate to OTP screen so user can manually resend
                if (mounted) {
                  context.go(
                    '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(authState.unverifiedPhoneNumber!)}&isLogin=true',
                  );
                  
                  await NotificationService.showInfo(
                    title: 'التحقق من رقم الهاتف',
                    message:
                        'يرجى إعادة إرسال رمز التحقق من صفحة التحقق.',
                  );
                }
              }
            }
            return;
          }

          // Show error message using central notification system
          String errorTitle = 'خطأ في تسجيل الدخول';
          String errorMessage = 'فشل في تسجيل الدخول';

          // محاولة استخراج الرسالة من استجابة الخادم
          if (authState.lastResponse != null) {
            final response = authState.lastResponse!;
            if (response.containsKey('messageAr') &&
                response.containsKey('messageEn')) {
              final messageAr = response['messageAr'] as String?;
              final messageEn = response['messageEn'] as String?;

              // اختيار الرسالة حسب لغة التطبيق
              final locale = Localizations.localeOf(context);
              if (locale.languageCode == 'ar' &&
                  messageAr != null &&
                  messageAr.isNotEmpty) {
                errorMessage = messageAr;
              } else if (messageEn != null && messageEn.isNotEmpty) {
                errorMessage = messageEn;
              }
            }
          } else if (authState.error != null && authState.error!.isNotEmpty) {
            // استخدام رسالة الخطأ من الحالة إذا لم تكن هناك استجابة من الخادم
            errorMessage = authState.error!;

            // تطبيق رسائل احتياطية لأخطاء الشبكة
            if (authState.error!.contains('Network error') ||
                authState.error!.contains('SocketException') ||
                authState.error!.contains('connection refused') ||
                authState.error!.contains('No route to host')) {
              errorMessage = 'خطأ في الاتصال، يرجى التحقق من الإنترنت';
            } else if (authState.error!.contains('timeout') ||
                authState.error!.contains('TimeoutException')) {
              errorMessage = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
            }
          }

          debugPrint(
              '🔍 [LOGIN_SCREEN] Displaying error message: $errorMessage');

          await NotificationService.showError(
            title: errorTitle,
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('❌ [LOGIN_SCREEN] Unexpected error: $e');

        // إرسال إشعار خطأ مبسط
        await NotificationService.showError(
          title: 'خطأ في تسجيل الدخول',
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
        );
      }
    }
  }

  void _checkConnection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConnectionTestScreen(),
      ),
    );
  }

  String? _validatePhone(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }

    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 7) {
      return 'رقم الهاتف قصير جداً';
    }

    if (digitsOnly.length > 15) {
      return 'رقم الهاتف طويل جداً';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(compatibleAuthProvider);

    return ProfessionalLoadingOverlay(
      isLoading: authState.isLoading,
      message: 'جاري تسجيل الدخول...',
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo section
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        AppImages.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    l10n.login,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    l10n.welcome,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Phone number field with country code
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        // Country code picker
                        CountryCodePicker(
                          onChanged: (country) {
                            setState(() {
                              _countryCode = country.dialCode!;
                            });
                          },
                          initialSelection: 'YE', // Yemen
                          favorite: const ['+967', 'YE'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          textStyle: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                          dialogTextStyle: const TextStyle(
                            color: AppColors.textPrimary,
                          ),
                          searchStyle: const TextStyle(
                            color: AppColors.textPrimary,
                          ),
                          flagWidth: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),

                        // Divider
                        Container(
                          height: 30,
                          width: 1,
                          color: AppColors.border,
                        ),

                        // Phone number input
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: _validatePhone,
                            decoration: const InputDecoration(
                              hintText: 'رقم الهاتف',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Password field without label
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'أدخل كلمة المرور',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                      onFieldSubmitted: (_) => _login(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login button with enhanced loading state
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: authState.isLoading
                            ? AppColors.primary.withOpacity(0.6)
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: authState.isLoading ? 0 : 2,
                      ),
                      child: authState.isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'جاري تسجيل الدخول...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              l10n.login,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Forgot password
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.push(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.border),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.or,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.border),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Register button
                  OutlinedButton(
                    onPressed: () {
                      context.go(AppRoutes.register);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.register,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Check Connection button
                  OutlinedButton.icon(
                    onPressed: _checkConnection,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.secondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.wifi_find,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    label: const Text(
                      'فحص الاتصال',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Language selection
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        context.go(AppRoutes.languageSelection);
                      },
                      icon: const Icon(
                        Icons.language,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      label: Text(
                        l10n.selectLanguage,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
