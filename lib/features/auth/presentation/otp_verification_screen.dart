import 'dart:async';

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

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;
  final bool isLogin;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
    required this.isLogin,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  // 4 Text controllers for 4 OTP digits
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // 4 Focus nodes for 4 OTP fields
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  bool _isResendingOtp = false;
  Timer? _resendTimer;
  int _resendCountdown = 0;

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
    _resendTimer?.cancel();
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCode;

    if (otp.length != 4) {
      await NotificationService.showError(
        title: 'خطأ في التحقق',
        message: 'يرجى إدخال رمز التحقق المكون من 4 أرقام',
      );
      return;
    }

    // Clear any previous errors
    ref.read(authProvider.notifier).clearError();

    try {
      debugPrint('OtpVerificationScreen: Verifying OTP for ${widget.phone}');

      final result = await ref.read(authProvider.notifier).verifyOtp(
            widget.phone,
            otp,
            isLogin: widget.isLogin,
          );

      if (mounted) {
        if (result.isSuccess) {
          debugPrint('OtpVerificationScreen: OTP verification successful');

          // استخدام الرسالة من الخادم إذا كانت متوفرة
          String successTitle = 'التحقق';
          final locale = Localizations.localeOf(context);
          String successMessage = result.getLocalizedMessage(locale.languageCode) ?? 'تم التحقق بنجاح';

          await NotificationService.showSuccess(
            title: successTitle,
            message: successMessage,
          );

          // Navigate to main screen automatically
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            context.go(AppRoutes.main);
          }
        } else {
          String errorTitle = 'خطأ في التحقق';
          final locale = Localizations.localeOf(context);
          String errorMessage = result.getLocalizedMessage(locale.languageCode) ?? 'رمز التحقق غير صحيح';

          await NotificationService.showError(
            title: errorTitle,
            message: errorMessage,
          );

          // Clear OTP fields on error
          for (var controller in _otpControllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('❌ [OTP_VERIFICATION_SCREEN] Unexpected error: $e');

        await NotificationService.showError(
          title: 'خطأ في التحقق',
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResendingOtp || _resendCountdown > 0) return;

    setState(() {
      _isResendingOtp = true;
    });

    try {
      final result = await ref.read(authProvider.notifier).resendOtp(widget.phone);

      if (mounted) {
        // استخدام الرسالة من الخادم إذا كانت متوفرة
        String successTitle = 'إعادة الإرسال';
        final locale = Localizations.localeOf(context);
        String successMessage = result.getLocalizedMessage(locale.languageCode) ?? 'تم إرسال رمز التحقق مرة أخرى';

        await NotificationService.showSuccess(
          title: successTitle,
          message: successMessage,
        );

        // Start countdown timer
        setState(() {
          _resendCountdown = 60;
        });

        _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_resendCountdown > 0) {
            setState(() {
              _resendCountdown--;
            });
          } else {
            timer.cancel();
          }
        });
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
              _verifyOtp();
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return ProfessionalLoadingOverlay(
      isLoading: authState.isLoading || _isResendingOtp,
      message: authState.isLoading
          ? 'جاري التحقق من الكود...'
          : 'جاري إعادة إرسال الكود...',
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
                  widget.isLogin ? 'التحقق من حسابك' : 'التحقق من رقم الهاتف',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  widget.isLogin
                      ? 'حسابك غير مؤكد. يرجى إدخال رمز التحقق المكون من 4 أرقام\nالمرسل إلى ${widget.phone} للتحقق من حسابك'
                      : 'أدخل رمز التحقق المكون من 4 أرقام\nالمرسل إلى ${widget.phone}',
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

                const SizedBox(height: 32),

                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (authState.isLoading || _isResendingOtp)
                        ? null
                        : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (authState.isLoading || _isResendingOtp)
                          ? AppColors.primary.withOpacity(0.6)
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation:
                          (authState.isLoading || _isResendingOtp) ? 0 : 2,
                    ),
                    child: const Text(
                      'تحقق',
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
                    onPressed: (_isResendingOtp ||
                            _resendCountdown > 0 ||
                            authState.isLoading)
                        ? null
                        : _resendOtp,
                    child: Text(
                      _resendCountdown > 0
                          ? 'إعادة الإرسال بعد $_resendCountdown ثانية'
                          : 'إعادة إرسال رمز التحقق',
                      style: TextStyle(
                        color: (_resendCountdown > 0 ||
                                _isResendingOtp ||
                                authState.isLoading)
                            ? AppColors.textSecondary
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Back to login/register
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (widget.isLogin) {
                        context.go(AppRoutes.login);
                      } else {
                        context.go(AppRoutes.register);
                      }
                    },
                    child: Text(
                      widget.isLogin
                          ? 'العودة لتسجيل الدخول'
                          : 'العودة للتسجيل',
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
}
