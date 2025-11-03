import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/notification_service.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String phone;

  const ResetPasswordScreen({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isResendingOtp = false;

  @override
  void initState() {
    super.initState();
    // Auto focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous errors
    ref.read(compatibleAuthProvider.notifier).clearError();

    try {
      debugPrint('ResetPasswordScreen: Resetting password for ${widget.phone}');

      final success =
          await ref.read(compatibleAuthProvider.notifier).resetPassword(
                widget.phone,
                _otpCode,
                _passwordController.text,
              );

      if (mounted) {
        if (success) {
          debugPrint('ResetPasswordScreen: Password reset successful');

          // استخدام الرسالة من الخادم إذا كانت متوفرة
          final authState = ref.read(compatibleAuthProvider);
          String successTitle = 'إعادة تعيين كلمة المرور';
          String successMessage = 'تم إعادة تعيين كلمة المرور بنجاح';

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
            } else if (response.containsKey('message')) {
              successMessage = response['message'] as String? ?? successMessage;
            }
          }

          await NotificationService.showSuccess(
            title: successTitle,
            message: successMessage,
          );

          // Navigate to login screen
          context.go(AppRoutes.login);
        } else {
          final authState = ref.read(compatibleAuthProvider);
          String errorTitle = 'خطأ في إعادة تعيين كلمة المرور';
          String errorMessage = 'فشل في إعادة تعيين كلمة المرور';

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
            } else if (response.containsKey('message')) {
              errorMessage = response['message'] as String? ?? errorMessage;
            }
          }

          if (authState.error != null && authState.error!.isNotEmpty) {
            errorMessage = authState.error!;
          }

          await NotificationService.showError(
            title: errorTitle,
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('❌ [RESET_PASSWORD_SCREEN] Unexpected error: $e');

        await NotificationService.showError(
          title: 'خطأ في إعادة تعيين كلمة المرور',
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResendingOtp) return;

    setState(() {
      _isResendingOtp = true;
    });

    try {
      await ref.read(compatibleAuthProvider.notifier).resendOtp(widget.phone);

      if (mounted) {
        await NotificationService.showSuccess(
          title: 'إعادة الإرسال',
          message: 'تم إرسال رمز التحقق مرة أخرى',
        );
      }
    } catch (e) {
      if (mounted) {
        await NotificationService.showError(
          title: 'خطأ في الإرسال',
          message: 'فشل في إرسال رمز التحقق مرة أخرى',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResendingOtp = false;
        });
      }
    }
  }

  String? _validateOtp() {
    if (_otpCode.length != 4) {
      return 'رمز التحقق يجب أن يكون 4 أرقام';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور الجديدة';
    }

    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : AppColors.border,
          width: _focusNodes[index].hasFocus ? 2.5 : 1.5,
        ),
        boxShadow: _focusNodes[index].hasFocus
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Center(
        child: TextFormField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isNotEmpty && index == 3) {
              _focusNodes[index].unfocus();
            }
          },
          onTap: () {
            _otpControllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _otpControllers[index].text.length,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(dynamic authState, bool isLoading) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
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
                  'إعادة تعيين كلمة المرور',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'أدخل رمز التحقق المرسل إلى\n${widget.phone} وكلمة المرور الجديدة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // OTP Input Fields (4 boxes, LTR)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++) ...[
                        _buildOtpField(i),
                        if (i < 3) const SizedBox(width: 20),
                      ],
                    ],
                  ),
                ),

                // Validate OTP display
                if (_otpCode.isNotEmpty && _otpCode.length != 4)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _validateOtp() ?? '',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                // Password field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      hintText: 'كلمة المرور الجديدة',
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
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm Password field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'تأكيد كلمة المرور الجديدة',
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
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    onFieldSubmitted: (_) => _resetPassword(),
                  ),
                ),

                const SizedBox(height: 32),

                // Reset Password button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _resetPassword,
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
                                'جاري إعادة التعيين...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'إعادة تعيين كلمة المرور',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Resend OTP button
                Center(
                  child: TextButton(
                    onPressed: _isResendingOtp ? null : _resendOtp,
                    child: _isResendingOtp
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'جاري الإرسال...',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'إعادة إرسال رمز التحقق',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(compatibleAuthProvider);
    final isLoading = authState.isLoading;

    return ProfessionalLoadingOverlay(
      isLoading: isLoading,
      message: isLoading ? 'جاري إعادة تعيين كلمة المرور...' : null,
      child: _buildMainContent(authState, isLoading),
    );
  }
}
