import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/push_notification_service.dart';
import 'web_notification_permission_card.dart';

/// كارد ذكي لتفعيل الإشعارات يظهر في الشاشة الرئيسية
/// يظهر بشكل غير مزعج مع إمكانية الإغلاق
class SmartNotificationBanner extends ConsumerStatefulWidget {
  const SmartNotificationBanner({super.key});

  @override
  ConsumerState<SmartNotificationBanner> createState() => _SmartNotificationBannerState();
}

class _SmartNotificationBannerState extends ConsumerState<SmartNotificationBanner>
    with SingleTickerProviderStateMixin {
  bool _isDismissed = false;
  bool _isExpanded = false;
  NotificationSettings? _currentSettings;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _checkPermissionStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionStatus() async {
    if (!kIsWeb) return;

    try {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      setState(() {
        _currentSettings = settings;
      });
    } catch (error) {
      debugPrint('⚠️ [SMART_BANNER] Error checking permission: $error');
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await PushNotificationService.instance.initialize(ref);
        
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          await PushNotificationService.instance.syncTokenWithServer(token);
        }

        setState(() {
          _currentSettings = settings;
          _isDismissed = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ تم تفعيل الإشعارات بنجاح'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error) {
      debugPrint('❌ [SMART_BANNER] Error requesting permission: $error');
    }
  }

  void _dismiss() {
    setState(() {
      _isDismissed = true;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || _isDismissed) {
      return const SizedBox.shrink();
    }

    if (_currentSettings?.authorizationStatus == AuthorizationStatus.authorized ||
        _currentSettings?.authorizationStatus == AuthorizationStatus.denied) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تفعيل الإشعارات',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          if (!_isExpanded)
                            Text(
                              'لتصلك التحديثات الفورية',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (_isExpanded) ...[
                            const SizedBox(height: 8),
                            Text(
                              'يرجى تفعيل والسماح بالإشعارات لتصلك التحديثات والتنبيهات الفورية حول اشتراكاتك والفعاليات',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _requestPermission,
                                    icon: const Icon(Icons.check_circle_outline, size: 18),
                                    label: const Text('تفعيل الآن'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: _dismiss,
                                  child: const Text('لاحقاً'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.textSecondary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Expand/Collapse Icon
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    // Close Icon
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _dismiss,
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





