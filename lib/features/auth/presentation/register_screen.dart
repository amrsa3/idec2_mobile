import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/language_provider.dart';
import '../../../core/auth/auth.dart';
import '../../../services/notification_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String _countryCode = '+967'; // Default to Yemen
  bool _isCheckingRegistrationSettings = false;
  bool _registrationEnabled = true;
  String? _selectedGender; // 'MALE' or 'FEMALE'

  @override
  void initState() {
    super.initState();
    _checkRegistrationSettings();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkRegistrationSettings() async {
    setState(() {
      _isCheckingRegistrationSettings = true;
    });

    try {
      // TODO: Implement API call to check registration settings
      // For now, assume registration is enabled
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _registrationEnabled = true; // This should come from API
          _isCheckingRegistrationSettings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _registrationEnabled = false;
          _isCheckingRegistrationSettings = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في فحص إعدادات التسجيل: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Additional validation before sending
    if (_fullNameController.text.trim().isEmpty) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'يرجى إدخال الاسم الكامل',
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'يرجى إدخال رقم الهاتف',
      );
      return;
    }

    // Validate phone number format
    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (phoneDigits.length < 7 || phoneDigits.length > 15) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'رقم الهاتف غير صحيح، يرجى إدخال رقم صحيح',
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'يرجى إدخال كلمة المرور',
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
      );
      return;
    }

    if (!_acceptTerms) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'يجب الموافقة على الشروط والأحكام',
      );
      return;
    }

    if (!_registrationEnabled) {
      await NotificationService.showError(
        title: 'التسجيل مغلق',
        message: 'التسجيل مغلق حالياً، يرجى المحاولة لاحقاً',
      );
      return;
    }

    // Build normalized international phone number
    String normalizedDigits =
        _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    final countryDigits = _countryCode.replaceAll('+', '');

    // If user already entered the country code manually, strip it to avoid duplication
    if (normalizedDigits.startsWith(countryDigits)) {
      normalizedDigits = normalizedDigits.substring(countryDigits.length);
    }

    // Remove leading zeros from the local part
    normalizedDigits = normalizedDigits.replaceFirst(RegExp(r'^0+'), '');

    if (normalizedDigits.isEmpty) {
      await NotificationService.showError(
        title: 'خطأ في البيانات',
        message: 'يرجى إدخال رقم هاتف صحيح',
      );
      return;
    }

    final fullPhoneNumber = '$_countryCode$normalizedDigits';

    // Clear any previous errors
    ref.read(authProvider.notifier).clearError();

    final result =
        await ref.read(authProvider.notifier).registerWithPhone(
              fullPhoneNumber,
              _passwordController.text,
              _fullNameController.text.trim(),
              _emailController.text.trim().isEmpty
                  ? ''
                  : _emailController.text.trim(),
              gender: _selectedGender,
            );

    if (!mounted) return;

    if (result.isSuccess || result.type == AuthResultType.otpSent) {
      // Registration successful - show success message and navigate to OTP verification
      // استخدام الرسالة من الخادم إذا كانت متوفرة
      String successTitle = 'تم التسجيل بنجاح';
      final locale = Localizations.localeOf(context);
      String successMessage = result.getLocalizedMessage(locale.languageCode) ??
          'تم إنشاء الحساب بنجاح، يرجى التحقق من رمز التأكيد';

      await NotificationService.showSuccess(
        title: successTitle,
        message: successMessage,
      );

      print(
          'Registration successful, navigating to OTP verification with phone: $fullPhoneNumber');
      // Use push instead of go to avoid GoRouter redirects
      if (mounted) {
        context.push(
            '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(fullPhoneNumber)}');
      }
    } else {
      // Registration failed - show enhanced error message
      String errorTitle = 'خطأ في التسجيل';
      final locale = Localizations.localeOf(context);
      String errorMessage = result.getLocalizedMessage(locale.languageCode) ??
          'فشل في التسجيل. يرجى المحاولة مرة أخرى.';

      // تطبيق رسائل احتياطية لأخطاء محددة
      if (errorMessage.contains('already exists') ||
          errorMessage.contains('duplicate') ||
          errorMessage.contains('phone already registered')) {
        errorMessage =
            'رقم الهاتف مسجل مسبقاً، يرجى استخدام رقم آخر أو تسجيل الدخول';
      } else if (errorMessage.contains('invalid phone') ||
          errorMessage.contains('phone format')) {
        errorMessage = 'رقم الهاتف غير صحيح، يرجى التحقق من الرقم';
      } else if (errorMessage.contains('weak password') ||
          errorMessage.contains('password too short')) {
        errorMessage = 'كلمة المرور ضعيفة، يرجى استخدام كلمة مرور أقوى';
      } else if (errorMessage.contains('Network error') ||
          errorMessage.contains('connection')) {
        errorMessage = 'خطأ في الاتصال، يرجى التحقق من الإنترنت';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
      } else if (errorMessage.contains('server error') ||
          errorMessage.contains('500')) {
        errorMessage = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      }

      await NotificationService.showError(
        title: errorTitle,
        message: errorMessage,
      );

      // Also trigger a rebuild to show the error in the UI
      setState(() {});
    }
  }

  String? _validateFullName(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }

    if (value.trim().length < 2) {
      return 'الاسم قصير جداً';
    }

    if (value.trim().length > 50) {
      return 'الاسم طويل جداً';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    // Email is optional now
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
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

    if (value.length < 8) {
      return l10n.passwordTooShort;
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }

    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatch;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isRTL = ref.watch(isRTLProvider);

    return ProfessionalLoadingOverlay(
      isLoading: authState.isLoading,
      message: 'جاري إنشاء الحساب...',
      child: Scaffold(
        backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: context.colors.textPrimary,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
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
                const SizedBox(height: 20),

                // Logo section
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
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
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppImages.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  l10n.register,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  l10n.createAccount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Registration status check
                if (_isCheckingRegistrationSettings)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('جاري فحص إعدادات التسجيل...'),
                      ],
                    ),
                  ),

                // Registration disabled warning
                if (!_registrationEnabled && !_isCheckingRegistrationSettings)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: AppColors.error,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'التسجيل مغلق حالياً. يرجى المحاولة لاحقاً.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Full Name field (single field instead of first/last name)
                CustomTextField(
                  controller: _fullNameController,
                  label: 'الاسم الكامل',
                  hint: 'أدخل الاسم الكامل',
                  textInputAction: TextInputAction.next,
                  validator: _validateFullName,
                  prefixIcon: const Icon(Icons.person_outline),
                  enabled:
                      _registrationEnabled && !_isCheckingRegistrationSettings,
                ),

                const SizedBox(height: 16),

                // Email field (optional)
                CustomTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني (اختياري)',
                  hint: 'أدخل البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled:
                      _registrationEnabled && !_isCheckingRegistrationSettings,
                ),

                const SizedBox(height: 16),

                // Gender selection field
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'الجنس',
                      hintText: 'اختر الجنس',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      prefixIcon: Icon(Icons.person_outline),
                      labelStyle: TextStyle(
                        fontFamily: 'Cairo',
                        fontFamilyFallback: ['Cairo', 'NotoSansArabic', 'Tahoma'],
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Cairo',
                        fontFamilyFallback: ['Cairo', 'NotoSansArabic', 'Tahoma'],
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'MALE',
                        child: Text(
                          'ذكر',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontFamilyFallback: ['Cairo', 'NotoSansArabic', 'Tahoma'],
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'FEMALE',
                        child: Text(
                          'أنثى',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontFamilyFallback: ['Cairo', 'NotoSansArabic', 'Tahoma'],
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (_registrationEnabled && !_isCheckingRegistrationSettings)
                        ? (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار الجنس';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontFamilyFallback: ['Cairo', 'NotoSansArabic', 'Tahoma'],
                    ),
                    dropdownColor: context.colors.card,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Phone number field with country code
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
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
                        favorite: ['+967', 'YE'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 16,
                        ),
                        dialogTextStyle: TextStyle(
                          color: context.colors.textPrimary,
                        ),
                        searchStyle: TextStyle(
                          color: context.colors.textPrimary,
                        ),
                        flagWidth: 25,
                        dialogBackgroundColor: context.colors.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        enabled: _registrationEnabled &&
                            !_isCheckingRegistrationSettings,
                      ),

                      // Divider
                      Container(
                        height: 30,
                        width: 1,
                        color: context.colors.border,
                      ),

                      // Phone number input
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: _validatePhone,
                          enabled: _registrationEnabled &&
                              !_isCheckingRegistrationSettings,
                          decoration: InputDecoration(
                            hintText: 'رقم الهاتف',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            hintStyle: TextStyle(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  label: l10n.password,
                  hint: l10n.password,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled:
                      _registrationEnabled && !_isCheckingRegistrationSettings,
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

                const SizedBox(height: 16),

                // Confirm Password field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: l10n.confirmPassword,
                  hint: l10n.confirmYourPassword,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled:
                      _registrationEnabled && !_isCheckingRegistrationSettings,
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
                  onSubmitted: (_) => _register(),
                ),

                const SizedBox(height: 24),

                // Terms and conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (_registrationEnabled &&
                              !_isCheckingRegistrationSettings)
                          ? (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            }
                          : null,
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (_registrationEnabled &&
                                !_isCheckingRegistrationSettings)
                            ? () {
                                setState(() {
                                  _acceptTerms = !_acceptTerms;
                                });
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 14,
                                fontFamily: 'NotoSansArabic',
                                fontFamilyFallback: ['NotoSansArabic', 'Cairo', 'Tahoma'],
                              ),
                              children: [
                                const TextSpan(text: 'أوافق على '),
                                TextSpan(
                                  text: l10n.termsAndConditions,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSansArabic',
                                    fontFamilyFallback: ['NotoSansArabic', 'Cairo', 'Tahoma'],
                                  ),
                                ),
                                TextSpan(text: ' ${l10n.and} '),
                                TextSpan(
                                  text: l10n.privacyPolicy,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSansArabic',
                                    fontFamilyFallback: ['NotoSansArabic', 'Cairo', 'Tahoma'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Error message
                if (authState.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.error.withOpacity(0.3)),
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
                            authState.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Register button
                CustomButton(
                  text: l10n.register,
                  onPressed: (authState.isLoading ||
                          !_registrationEnabled ||
                          _isCheckingRegistrationSettings)
                      ? null
                      : _register,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${l10n.alreadyHaveAccount} ',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      child: Text(
                        l10n.login,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
