import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


/// شريط إشعار التوثيق
class VerificationNotificationBanner extends ConsumerStatefulWidget {
  const VerificationNotificationBanner({super.key});

  @override
  ConsumerState<VerificationNotificationBanner> createState() =>
      _VerificationNotificationBannerState();
}

class _VerificationNotificationBannerState
    extends ConsumerState<VerificationNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // بدء الرسوم المتحركة
    _animationController.forward();

    // إخفاء الإشعار تلقائياً بعد 60 ثانية
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        _hideNotification();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _hideNotification() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  void _onTap() {
    // الانتقال إلى صفحة تعديل الملف الشخصي
    context.push('/profile');
    _hideNotification();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Material(
            elevation: 4,
            child: InkWell(
              onTap: _onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'يرجى توثيق حسابك للاستفادة من جميع الخدمات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _hideNotification,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Provider لإعدادات إشعار التوثيق
final verificationNotificationProvider =
    StateNotifierProvider<VerificationNotificationNotifier, bool>((ref) {
  return VerificationNotificationNotifier();
});

class VerificationNotificationNotifier extends StateNotifier<bool> {
  VerificationNotificationNotifier() : super(true);

  void hide() {
    state = false;
  }

  void show() {
    state = true;
  }

  void toggle() {
    state = !state;
  }
}
