import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../core/theme/app_colors.dart';

/// خدمة التعامل مع زر الرجوع
/// تدير سلوك زر الرجوع في التطبيق ومنع الإغلاق المباشر
class BackButtonService {
  static DateTime? _lastBackPressed;
  static const Duration _backPressThreshold = Duration(seconds: 2);
  
  /// التعامل مع ضغطة زر الرجوع
  /// يعرض حوار تأكيد الخروج أو رسالة تنبيه
  static Future<bool> handleBackPress(BuildContext context) async {
    final now = DateTime.now();
    
    // إذا كان المستخدم في الصفحة الرئيسية، اعرض حوار تأكيد الخروج
    if (_isOnMainScreen(context)) {
      return await _showExitConfirmationDialog(context);
    }
    
    // إذا كان في صفحة أخرى، ارجع للصفحة السابقة
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return false;
    }
    
    // إذا لم يكن هناك صفحات للرجوع إليها، اعرض حوار الخروج
    return await _showExitConfirmationDialog(context);
  }
  
  /// عرض حوار تأكيد الخروج
  static Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.exitAppTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            l10n.exitAppMessage,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            // Exit button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.exit),
            ),
          ],
        );
      },
    );
    
    // إذا اختار المستخدم الخروج، أغلق التطبيق
    if (result == true) {
      await _exitApp();
      return true;
    }
    
    return false;
  }
  
  /// عرض رسالة "اضغط مرة أخرى للخروج"
  static void _showBackPressMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.pressBackAgainToExit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        backgroundColor: AppColors.textPrimary,
        duration: _backPressThreshold,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: l10n.exit,
          textColor: AppColors.error,
          onPressed: () => _exitApp(),
        ),
      ),
    );
  }
  
  /// التحقق من كون المستخدم في الصفحة الرئيسية
  static bool _isOnMainScreen(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) return false;
    
    final routeName = route.settings.name;
    return routeName == '/main' || routeName == '/';
  }
  
  /// إغلاق التطبيق
  static Future<void> _exitApp() async {
    try {
      // محاولة إغلاق التطبيق بطريقة نظيفة
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (e) {
      // إذا فشلت الطريقة الأولى، استخدم SystemNavigator
      SystemNavigator.pop();
    }
  }
  
  /// إنشاء WillPopScope للصفحات
  static Widget wrapWithBackButtonHandler({
    required Widget child,
    required BuildContext context,
    bool showExitDialog = true,
  }) {
    return WillPopScope(
      onWillPop: () async {
        if (showExitDialog) {
          return await handleBackPress(context);
        } else {
          return true; // السماح بالرجوع العادي
        }
      },
      child: child,
    );
  }
  
  /// إنشاء PopScope للصفحات (Flutter 3.12+)
  static Widget wrapWithPopScope({
    required Widget child,
    required BuildContext context,
    bool showExitDialog = true,
    bool canPop = false,
  }) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (bool didPop) async {
        if (!didPop && showExitDialog) {
          final shouldExit = await handleBackPress(context);
          if (shouldExit && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}

/// ويدجت مخصص للتعامل مع زر الرجوع
class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final bool showExitDialog;
  final VoidCallback? onBackPressed;
  
  const BackButtonHandler({
    super.key,
    required this.child,
    this.showExitDialog = true,
    this.onBackPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          if (onBackPressed != null) {
            onBackPressed!();
          } else if (showExitDialog) {
            final shouldExit = await BackButtonService.handleBackPress(context);
            if (shouldExit && context.mounted) {
              Navigator.of(context).pop();
            }
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}
