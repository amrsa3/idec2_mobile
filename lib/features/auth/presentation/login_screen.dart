import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../services/notification_service.dart';
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
    ref.read(authProvider.notifier).clearError();

    try {
      final fullPhoneNumber = '$_countryCode${_phoneController.text.trim()}';
      
      debugPrint('LoginScreen: Attempting login for $fullPhoneNumber');
      
      final success = await ref.read(authProvider.notifier).loginWithPhone(
        fullPhoneNumber,
        _passwordController.text.trim(),
      );

      if (mounted) {
        if (success) {
          debugPrint('LoginScreen: Login successful, letting GoRouter handle navigation');
          
          // إرسال إشعار نجاح عبر النظام المركزي
          await NotificationService.showSuccess(
            title: 'تسجيل الدخول',
            message: 'تم تسجيل الدخول بنجاح',
          );
          
          // GoRouter will handle navigation automatically
        } else {
          // Show error message using central notification system
          final authState = ref.read(authProvider);
          String errorMessage = 'فشل في تسجيل الدخول';
          
          if (authState.error != null) {
            // تحسين رسائل الخطأ لتكون أكثر وضوحاً
            if (authState.error!.contains('Invalid credentials') || 
                authState.error!.contains('401') ||
                authState.error!.contains('Unauthorized')) {
              errorMessage = 'رقم الهاتف أو كلمة المرور غير صحيحة';
            } else if (authState.error!.contains('inactive account') ||
                       authState.error!.contains('account is disabled')) {
              errorMessage = 'الحساب غير مفعل، يرجى التواصل مع الإدارة';
            } else if (authState.error!.contains('Network error') ||
                       authState.error!.contains('connection')) {
              errorMessage = 'خطأ في الاتصال، يرجى التحقق من الإنترنت';
            } else if (authState.error!.contains('timeout')) {
              errorMessage = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
            } else {
              errorMessage = authState.error!;
            }
          }
          
          await NotificationService.showError(
            title: 'خطأ في تسجيل الدخول',
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // تحسين رسائل الخطأ العامة
        String errorMessage = 'حدث خطأ غير متوقع';
        if (e.toString().contains('SocketException') || 
            e.toString().contains('connection')) {
          errorMessage = 'لا يمكن الاتصال بالخادم، يرجى التحقق من الإنترنت';
        } else if (e.toString().contains('timeout')) {
          errorMessage = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
        } else if (e.toString().contains('format')) {
          errorMessage = 'خطأ في تنسيق البيانات، يرجى المحاولة مرة أخرى';
        }
        
        // إرسال إشعار خطأ عبر النظام المركزي
        await NotificationService.showError(
          title: 'خطأ في تسجيل الدخول',
          message: errorMessage,
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
  final authState = ref.watch(authProvider);
  final isRTL = ref.watch(isRTLProvider);

  
  return Scaffold(
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
              
              const SizedBox(height: 16),
              
              // Password field
              CustomTextField(
                controller: _passwordController,
                label: l10n.password,
                hint: l10n.password,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: _validatePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                onSubmitted: (_) => _login(),
              ),
              
              const SizedBox(height: 16),
              
              // Connection buttons row
              Row(
                children: [
                  // Connection test button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _checkConnection,
                      icon: const Icon(Icons.wifi_find, color: AppColors.primary),
                      label: const Text(
                        'فحص الاتصال',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Advanced monitoring button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.connectionStatus),
                      icon: const Icon(Icons.analytics, color: AppColors.secondary),
                      label: const Text(
                        'مراقبة متقدمة',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Login button with enhanced loading state
              Container(
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
                          style: TextStyle(
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
                    // TODO: Implement forgot password
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
    );
  }
}
