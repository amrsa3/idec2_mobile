import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfessionalLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isLoading;
  final Widget child;

  const ProfessionalLoadingOverlay({
    super.key,
    this.message,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Loading Animation
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Loading Message
                    Text(
                      message ?? 'جاري المعالجة...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      'يرجى الانتظار',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Widget مساعد لإضافة Loading بسهولة
class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Widget child;

  const LoadingWrapper({
    super.key,
    required this.isLoading,
    this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ProfessionalLoadingOverlay(
      isLoading: isLoading,
      message: message,
      child: child,
    );
  }
}

// Widget للـ Loading في العمليات المختلفة
class OperationLoading extends StatelessWidget {
  final String operation;
  
  const OperationLoading({
    super.key,
    required this.operation,
  });

  @override
  Widget build(BuildContext context) {
    return ProfessionalLoadingOverlay(
      isLoading: true,
      message: _getOperationMessage(operation),
      child: const SizedBox.shrink(),
    );
  }

  String _getOperationMessage(String operation) {
    switch (operation) {
      case 'login':
        return 'جاري تسجيل الدخول...';
      case 'register':
        return 'جاري إنشاء الحساب...';
      case 'verify_otp':
        return 'جاري التحقق من الكود...';
      case 'resend_otp':
        return 'جاري إعادة إرسال الكود...';
      case 'forgot_password':
        return 'جاري إرسال رابط إعادة تعيين كلمة المرور...';
      case 'reset_password':
        return 'جاري إعادة تعيين كلمة المرور...';
      case 'update_profile':
        return 'جاري تحديث الملف الشخصي...';
      case 'upload_file':
        return 'جاري رفع الملف...';
      default:
        return 'جاري المعالجة...';
    }
  }
}
