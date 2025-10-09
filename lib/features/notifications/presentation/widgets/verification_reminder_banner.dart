import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/navigation_service.dart';

/// Banner that reminds unverified users to complete their profile verification
class VerificationReminderBanner extends ConsumerStatefulWidget {
  const VerificationReminderBanner({super.key});

  @override
  ConsumerState<VerificationReminderBanner> createState() => _VerificationReminderBannerState();
}

class _VerificationReminderBannerState extends ConsumerState<VerificationReminderBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Show banner with animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissBanner() {
    setState(() {
      _isDismissed = true;
    });
    _animationController.reverse();
  }

  void _navigateToProfile() {
    NavigationService.instance.goToEditProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    // Don't show banner if user is verified, loading, or banner is dismissed
    if (user == null || 
        authState.isLoading ||
        _isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 60),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warning,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToProfile,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Warning icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Message
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getStatusMessage(l10n, null),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.tapToCompleteProfile,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Action buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Navigate button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: _navigateToProfile,
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Dismiss button
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: _dismissBanner,
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
      },
    );
  }

  String _getStatusMessage(AppLocalizations l10n, String? status) {
    switch (status) {
      case 'unverified':
        return l10n.pleaseVerifyAccount;
      case 'under_review':
        return l10n.accountUnderReview;
      case 'rejected':
        return l10n.accountRejectedPleaseUpdate;
      default:
        return l10n.pleaseCompleteProfile;
    }
  }
}

/// Persistent verification reminder that shows periodically
class PersistentVerificationReminder extends ConsumerStatefulWidget {
  const PersistentVerificationReminder({super.key});

  @override
  ConsumerState<PersistentVerificationReminder> createState() => _PersistentVerificationReminderState();
}

class _PersistentVerificationReminderState extends ConsumerState<PersistentVerificationReminder> {
  bool _isVisible = false;
  
  @override
  void initState() {
    super.initState();
    _startReminderTimer();
  }

  void _startReminderTimer() {
    // Show reminder every 5 minutes for unverified users
    Future.delayed(const Duration(minutes: 5), () {
      if (mounted) {
        final authState = ref.read(authProvider);
        final user = authState.user;
        
        if (user != null) {
          setState(() {
            _isVisible = true;
          });
          
          // Hide after 1 minute
          Future.delayed(const Duration(minutes: 1), () {
            if (mounted) {
              setState(() {
                _isVisible = false;
              });
              _startReminderTimer(); // Restart timer
            }
          });
        } else {
          _startReminderTimer(); // Restart timer
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();
    
    return const VerificationReminderBanner();
  }
}
