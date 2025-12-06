import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/notification_service.dart';
import '../../../services/push_notification_service.dart';

/// بطاقة طلب أذونات الإشعارات على الويب
/// تحل مشكلة User Gesture المطلوبة للمتصفحات
class WebNotificationPermissionCard extends ConsumerStatefulWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const WebNotificationPermissionCard({
    Key? key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  }) : super(key: key);

  @override
  ConsumerState<WebNotificationPermissionCard> createState() =>
      _WebNotificationPermissionCardState();
}

class _WebNotificationPermissionCardState
    extends ConsumerState<WebNotificationPermissionCard>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isDismissed = false;
  NotificationSettings? _currentSettings;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
    _checkCurrentPermissionStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkCurrentPermissionStatus() async {
    if (!kIsWeb) return;

    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      setState(() {
        _currentSettings = settings;
      });
    } catch (error) {
      debugPrint('⚠️ [WEB_PERMISSION] Error checking permission: $error');
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // طلب الأذونات (User Gesture)
      final settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('📱 [WEB_PERMISSION] Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // تم القبول - نسجل التوكن
        debugPrint('✅ [WEB_PERMISSION] Permission granted');
        
        // تهيئة Push Notification Service
        await PushNotificationService.instance.initialize(ref);
        
        // عرض رسالة نجاح
        if (mounted) {
          NotificationService.showSuccess(
            title: 'تم تفعيل الإشعارات',
            message: 'سيتم إرسال الإشعارات المهمة إليك',
          );
        }

        widget.onPermissionGranted?.call();

        // إخفاء البطاقة
        await _animationController.reverse();
        if (mounted) {
          setState(() {
            _isDismissed = true;
          });
        }
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('❌ [WEB_PERMISSION] Permission denied');
        widget.onPermissionDenied?.call();
        
        if (mounted) {
          NotificationService.showWarning(
            title: 'تم رفض الإشعارات',
            message: 'يمكنك تفعيلها لاحقاً من إعدادات المتصفح',
          );
        }
      }
    } catch (error) {
      debugPrint('❌ [WEB_PERMISSION] Error requesting permission: $error');
      if (mounted) {
        NotificationService.showError(
          title: 'خطأ',
          message: 'حدث خطأ أثناء طلب الأذونات',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _dismissCard() async {
    await _animationController.reverse();
    if (mounted) {
      setState(() {
        _isDismissed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // لا تعرض على غير الويب
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }

    // إذا تم رفض أو منح الأذونات، لا تعرض
    if (_currentSettings?.authorizationStatus == AuthorizationStatus.authorized ||
        _currentSettings?.authorizationStatus == AuthorizationStatus.denied ||
        _isDismissed) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // محتوى البطاقة
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // الأيقونة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_active_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // العنوان
                      Text(
                        'تفعيل الإشعارات',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // الوصف
                      Text(
                        'احصل على تحديثات فورية حول تسجيلاتك والفعاليات والمدفوعات',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // المميزات
                      _buildFeatureRow(
                        icon: Icons.flash_on,
                        text: 'إشعارات فورية',
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureRow(
                        icon: Icons.update,
                        text: 'تحديثات مهمة',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureRow(
                        icon: Icons.payment,
                        text: 'تنبيهات الدفع',
                        color: Colors.green,
                      ),
                      const SizedBox(height: 24),

                      // الأزرار
                      Row(
                        children: [
                          // زر التفعيل
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _requestPermission,
                              icon: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.check_circle_outline),
                              label: Text(_isLoading ? 'جاري التفعيل...' : 'تفعيل الآن'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // زر لاحقاً
                          Expanded(
                            child: TextButton(
                              onPressed: _isLoading ? null : _dismissCard,
                              child: Text('لاحقاً'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // زر الإغلاق
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: _isLoading ? null : _dismissCard,
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Toast نسخة مبسطة لطلب الأذونات
class WebNotificationPermissionToast extends ConsumerStatefulWidget {
  const WebNotificationPermissionToast({Key? key}) : super(key: key);

  @override
  ConsumerState<WebNotificationPermissionToast> createState() =>
      _WebNotificationPermissionToastState();
}

class _WebNotificationPermissionToastState
    extends ConsumerState<WebNotificationPermissionToast> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !_isVisible) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_active, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              'تفعيل الإشعارات؟',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () async {
                await FirebaseMessaging.instance.requestPermission();
                setState(() {
                  _isVisible = false;
                });
              },
              child: Text('نعم'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isVisible = false;
                });
              },
              child: Text('لا'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



