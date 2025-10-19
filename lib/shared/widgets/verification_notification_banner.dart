import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/enhanced_auth_provider.dart';

class VerificationNotificationBanner extends ConsumerStatefulWidget {
  const VerificationNotificationBanner({super.key});

  @override
  ConsumerState<VerificationNotificationBanner> createState() =>
      _VerificationNotificationBannerState();
}

class _VerificationNotificationBannerState
    extends ConsumerState<VerificationNotificationBanner>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isVisible = false;

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

    // Show notification after a delay
    Future.delayed(const Duration(seconds: 1), () {
      _showNotification();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNotification() {
    final user = ref.read(authProvider).user;
    
    // Only show for unverified users
    if (user != null && !user.isVerified) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();

      // Auto hide after 60 seconds (1 minute)
      Future.delayed(const Duration(seconds: 60), () {
        _hideNotification();
      });
    }
  }

  void _hideNotification() {
    if (_isVisible) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  void _onTap() {
    _hideNotification();
    // Navigate to profile edit screen
    context.go(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    // Don't show if user is verified or not logged in
    if (user == null || user.isVerified || !_isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value * 100),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'تنبيه مهم',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'يرجى توثيق حسابك لتتمكن من الاشتراك في المؤتمر والفعاليات',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _hideNotification,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                color: Colors.white.withOpacity(0.8),
                                size: 18,
                              ),
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
        ),
      ),
    );
  }
}

// Provider for managing verification notification settings
final verificationNotificationProvider = StateNotifierProvider<
    VerificationNotificationNotifier, VerificationNotificationState>((ref) {
  return VerificationNotificationNotifier();
});

class VerificationNotificationState {
  final bool isEnabled;
  final int intervalMinutes;
  final String message;

  const VerificationNotificationState({
    this.isEnabled = true,
    this.intervalMinutes = 30, // Default: every 30 minutes
    this.message = 'يرجى توثيق حسابك',
  });

  VerificationNotificationState copyWith({
    bool? isEnabled,
    int? intervalMinutes,
    String? message,
  }) {
    return VerificationNotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      message: message ?? this.message,
    );
  }
}

class VerificationNotificationNotifier
    extends StateNotifier<VerificationNotificationState> {
  VerificationNotificationNotifier()
      : super(const VerificationNotificationState());

  void updateSettings({
    bool? isEnabled,
    int? intervalMinutes,
    String? message,
  }) {
    state = state.copyWith(
      isEnabled: isEnabled,
      intervalMinutes: intervalMinutes,
      message: message,
    );
  }
}
