import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_otp_input.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;
  final bool isLogin;
  
  const OtpVerificationScreen({
    super.key,
    required this.phone,
    this.isLogin = false,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;
  String _otpValue = '';
  String? _otpError;

  @override
  void initState() {
    super.initState();
    print('OtpVerificationScreen initialized with phone: ${widget.phone}');
    _startTimer();
    
    // Request OTP automatically when screen loads (for registration flow)
    if (!widget.isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestInitialOtp();
      });
    }
  }

  Future<void> _requestInitialOtp() async {
    try {
      print('Requesting initial OTP for registration: ${widget.phone}');
      final success = await ref.read(authProvider.notifier).resendOtp(widget.phone);
      
      if (success) {
        print('Initial OTP sent successfully');
      } else {
        print('Failed to send initial OTP');
      }
    } catch (e) {
      print('Error sending initial OTP: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  bool get _isOtpComplete {
    return _otpValue.length == 4;
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;

    final success = await ref.read(authProvider.notifier).verifyOtp(
      widget.phone,
      _otpValue,
    );

    if (success && mounted) {
      context.go(AppRoutes.main);
    } else {
      setState(() {
        _otpError = 'رمز التحقق غير صحيح';
      });
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final success = await ref.read(authProvider.notifier).resendOtp(widget.phone);
    
    if (success) {
      _startTimer();
      _clearOtp();
      
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.otpSentSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _clearOtp() {
    setState(() {
      _otpValue = '';
      _otpError = null;
    });
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isRTL = ref.watch(isRTLProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Logo section
              Center(
                child: Container(
                  width: 80,
                  height: 80,
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
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    AppImages.logo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                l10n.verifyPhone,
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
                  ? 'يجب التحقق من رقم الهاتف لتسجيل الدخول'
                  : l10n.verificationCodeSent,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              // Phone
              Text(
                widget.phone,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // OTP Input Fields
              CustomOtpInput(
                length: 4,
                autoFocus: true,
                errorText: _otpError,
                onChanged: (value) {
                  setState(() {
                    _otpValue = value;
                    _otpError = null; // Clear error when user types
                  });
                },
                onCompleted: (value) {
                  _verifyOtp();
                },
              ),
              
              const SizedBox(height: 32),
              
              // Error message
              if (authState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authState.error!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Verify button
              CustomButton(
                text: l10n.verify,
                onPressed: (_isOtpComplete && !authState.isLoading) ? _verifyOtp : null,
                isLoading: authState.isLoading,
              ),
              
              const SizedBox(height: 32),
              
              // Resend section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${l10n.didntReceiveCode} ',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (_canResend)
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        l10n.resend,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Text(
                      '${l10n.resendIn} ${_remainingTime}s',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Clear button
              Center(
                child: TextButton.icon(
                  onPressed: _clearOtp,
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  label: Text(
                    l10n.clearCode,
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
    );
  }
}
