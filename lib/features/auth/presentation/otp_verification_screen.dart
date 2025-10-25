import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/notification_service.dart';
import '../../../shared/widgets/loading_overlay.dart';

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
  final _otpController = TextEditingController();
  bool _isResendingOtp = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      await NotificationService.showError(
        title: 'خطأ في التحقق',
        message: 'يرجى إدخال رمز التحقق المكون من 6 أرقام',
      );
      return;
    }

    // Clear any previous errors
    ref.read(compatibleAuthProvider.notifier).clearError();

    try {
      debugPrint('OtpVerificationScreen: Verifying OTP for ${widget.phone}');

      final success = await ref.read(compatibleAuthProvider.notifier).verifyOtp(
            widget.phone,
            _otpController.text,
          );

      if (mounted) {
        if (success) {
          debugPrint('OtpVerificationScreen: OTP verification successful');

          await NotificationService.showSuccess(
            title: 'التحقق',
            message: 'تم التحقق بنجاح',
          );

          // Navigate based on whether this is login or registration
          if (widget.isLogin) {
            context.go(AppRoutes.main);
          } else {
            context.go(AppRoutes.main);
          }
        } else {
          final authState = ref.read(compatibleAuthProvider);
          String errorMessage = 'رمز التحقق غير صحيح';

          if (authState.error != null && authState.error!.isNotEmpty) {
            errorMessage = authState.error!;
          }

          await NotificationService.showError(
            title: 'خطأ في التحقق',
            message: errorMessage,
          );
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(compatibleAuthProvider);

    return FormLoadingOverlay(
      isLoading: authState.isLoading,
      loadingText: 'جاري التحقق...',
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
                  'التحقق من رقم الهاتف',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'أدخل رمز التحقق المرسل إلى\n${widget.phone}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // OTP Input Field
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.border,
                    selectedColor: AppColors.primary,
                  ),
                  onCompleted: (value) => _verifyOtp(),
                  onChanged: (value) {},
                ),

                const SizedBox(height: 32),

                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _verifyOtp,
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
                                'جاري التحقق...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
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
