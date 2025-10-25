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
import '../../../shared/widgets/loading_overlay.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _countryCode = '+967'; // Default to Yemen

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendResetOtp() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous errors
    ref.read(compatibleAuthProvider.notifier).clearError();

    try {
      final fullPhoneNumber = '$_countryCode${_phoneController.text.trim()}';

      debugPrint(
          'ForgotPasswordScreen: Sending reset OTP for $fullPhoneNumber');

      final success = await ref
          .read(compatibleAuthProvider.notifier)
          .requestPasswordReset(fullPhoneNumber);

      if (mounted) {
        if (success) {
          debugPrint('ForgotPasswordScreen: Reset OTP sent successfully');

          // Navigate to reset password screen
          context.go(
            '${AppRoutes.resetPasswordOtp}?phone=${Uri.encodeComponent(fullPhoneNumber)}',
          );

          await NotificationService.showSuccess(
            title: 'إعادة تعيين كلمة المرور',
            message: 'تم إرسال رمز التحقق إلى رقم $fullPhoneNumber',
          );
        } else {
          final authState = ref.read(compatibleAuthProvider);
          String errorMessage = 'فشل في إرسال رمز التحقق';

          if (authState.error != null && authState.error!.isNotEmpty) {
            errorMessage = authState.error!;
          }

          await NotificationService.showError(
            title: 'خطأ في إعادة تعيين كلمة المرور',
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('❌ [FORGOT_PASSWORD_SCREEN] Unexpected error: $e');

        await NotificationService.showError(
          title: 'خطأ في إعادة تعيين كلمة المرور',
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(compatibleAuthProvider);

    return FormLoadingOverlay(
      isLoading: authState.isLoading,
      loadingText: 'جاري الإرسال...',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
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
                    'نسيت كلمة المرور؟',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'أدخل رقم هاتفك وسنرسل لك رمز التحقق لإعادة تعيين كلمة المرور',
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
                            textInputAction: TextInputAction.done,
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
                            onFieldSubmitted: (_) => _sendResetOtp(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Send OTP button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _sendResetOtp,
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
                          ? Row(
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
                                const SizedBox(width: 12),
                                Text(
                                  'جاري الإرسال...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'إرسال رمز التحقق',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Back to login
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      child: Text(
                        'العودة لتسجيل الدخول',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
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
