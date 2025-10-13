import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../services/notification_service.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
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

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final fullPhoneNumber = '$_countryCode${_phoneController.text.trim()}';
      
      // Call the forgot password API
      final response = await ref.read(authProvider.notifier).requestPasswordReset(fullPhoneNumber);
      
      // Check if there was an error
      final authState = ref.read(authProvider);
      if (authState.error != null) {
        await NotificationService.showError(
          title: 'خطأ',
          message: authState.error!,
        );
        return;
      }

      if (response == null) {
        await NotificationService.showError(
          title: 'خطأ',
          message: 'فشل في معالجة طلب إعادة تعيين كلمة المرور',
        );
        return;
      }

      if (response.requiresChannelSelection && response.availableChannels != null) {
        // Show channel selection dialog
        await _showChannelSelectionDialog(fullPhoneNumber, response.availableChannels!);
      } else if (response.success) {
        await NotificationService.showSuccess(
          title: 'إرسال رمز إعادة التعيين',
          message: response.message ?? 'تم إرسال رمز إعادة تعيين كلمة المرور إلى رقم هاتفك',
        );

        if (mounted) {
          // Navigate to reset password OTP screen
          context.push('${AppRoutes.resetPasswordOtp}?phone=${Uri.encodeComponent(fullPhoneNumber)}');
        }
      } else {
        await NotificationService.showError(
          title: 'خطأ',
          message: response.message ?? 'فشل في إرسال رمز إعادة التعيين',
        );
      }
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ',
        message: 'فشل في إرسال رمز إعادة التعيين. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  Future<void> _showChannelSelectionDialog(String phoneNumber, List<String> availableChannels) async {
    String? selectedChannel = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر قناة الإرسال'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يرجى اختيار القناة المفضلة لإرسال كود إعادة تعيين كلمة المرور:'),
              const SizedBox(height: 16),
              ...availableChannels.map((channel) {
                String displayName = channel == 'SMS' ? 'رسالة نصية' : 'واتساب';
                IconData icon = channel == 'SMS' ? Icons.sms : Icons.chat;
                
                return ListTile(
                  leading: Icon(icon),
                  title: Text(displayName),
                  onTap: () {
                    Navigator.of(context).pop(channel);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );

    if (selectedChannel != null) {
      await _confirmPasswordResetOtp(phoneNumber, selectedChannel);
    }
  }

  Future<void> _confirmPasswordResetOtp(String phoneNumber, String selectedChannel) async {
    try {
      final response = await ref.read(authProvider.notifier).confirmPasswordResetOtp(
        phoneNumber: phoneNumber,
        selectedChannel: selectedChannel,
        purpose: 'password_reset',
      );

      final authState = ref.read(authProvider);
      if (authState.error != null) {
        await NotificationService.showError(
          title: 'خطأ',
          message: authState.error!,
        );
        return;
      }

      if (response != null && response.success) {
        await NotificationService.showSuccess(
          title: 'إرسال رمز إعادة التعيين',
          message: response.message ?? 'تم إرسال رمز إعادة تعيين كلمة المرور بنجاح',
        );

        if (mounted) {
          // Navigate to reset password OTP screen
          context.push('${AppRoutes.resetPasswordOtp}?phone=${Uri.encodeComponent(phoneNumber)}');
        }
      } else {
        await NotificationService.showError(
          title: 'خطأ',
          message: response?.message ?? 'فشل في إرسال رمز إعادة التعيين',
        );
      }
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ',
        message: 'فشل في إرسال رمز إعادة التعيين. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
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
        title: Text(
          'نسيت كلمة المرور',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                  'أدخل رقم هاتفك وسنرسل لك رمز إعادة تعيين كلمة المرور',
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
                          onFieldSubmitted: (_) => _sendResetCode(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Send reset code button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _sendResetCode,
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
                            'إرسال رمز إعادة التعيين',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Back to login
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'العودة إلى تسجيل الدخول',
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
    );
  }
}