import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/auth/auth.dart';
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
    ref.read(authProvider.notifier).clearError();

    try {
      debugPrint('ResetPasswordScreen: Resetting password for ${widget.phone}');

      final result =
          await ref.read(authProvider.notifier).resetPassword(
                phone: widget.phone,
                otp: _otpCode,
                newPassword: _passwordController.text,
              );

      if (mounted) {
        if (result.isSuccess) {
          debugPrint('ResetPasswordScreen: Password reset successful');

          // استخدام الرسالة من الخادم إذا كانت متوفرة
          String successTitle = 'إعادة تعيين كلمة المرور';
          final locale = Localizations.localeOf(context);
          String successMessage = result.getLocalizedMessage(locale.languageCode) ??
              'تم إعادة تعيين كلمة المرور بنجاح';

          await NotificationService.showSuccess(
            title: successTitle,
            message: successMessage,
          );

          // Navigate to login screen
          context.go(AppRoutes.login);
        } else {
          String errorTitle = 'خطأ في إعادة تعيين كلمة المرور';
          final locale = Localizations.localeOf(context);
          String errorMessage = result.getLocalizedMessage(locale.languageCode) ??
              'فشل في إعادة تعيين كلمة المرور';

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
      await ref.read(authProvider.notifier).resendOtp(widget.phone);

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
        color: context.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : context.colors.border,
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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
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

  Widget _buildMainContent(AuthState authState, bool isLoading) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
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
                      color: context.colors.card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.shadow,
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
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'أدخل رمز التحقق المرسل إلى\n${widget.phone} وكلمة المرور الجديدة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.textSecondary,
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
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
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
                      hintStyle: TextStyle(
                        color: context.colors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: context.colors.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context.colors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm Password field
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
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
                      hintStyle: TextStyle(
                        color: context.colors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: context.colors.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context.colors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: context.colors.textPrimary,
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
                                'جاري إعادة التعيين...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const Text(
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
                        ? const Row(
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
                              SizedBox(width: 8),
                              Text(
                                'جاري الإرسال...',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Text(
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
                      style: TextStyle(
                        color: context.colors.textSecondary,
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
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return ProfessionalLoadingOverlay(
      isLoading: isLoading,
      message: isLoading ? 'جاري إعادة تعيين كلمة المرور...' : null,
      child: _buildMainContent(authState, isLoading),
    );
  }
}
