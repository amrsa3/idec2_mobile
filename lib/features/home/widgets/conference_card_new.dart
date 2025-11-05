import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/conference_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../services/conference_service.dart';
import '../../../services/registration_service.dart';
import '../../registrations/presentation/my_registrations_screen.dart';

/// New Conference Card matching HTML design exactly with real data
class ConferenceCardNew extends ConsumerWidget {
  const ConferenceCardNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conferenceAsync = ref.watch(activeConferenceProvider);
    final isRTL = ref.watch(isRTLProvider);
    final l10n = AppLocalizations.of(context);

    return conferenceAsync.when(
      data: (conference) {
        if (conference == null) {
          // Show empty state when no conference is found
          return const SizedBox.shrink();
        }

        // Show card only for statuses: SETUP, REGISTRATION_OPEN, ONGOING
        // Also show for DRAFT status for testing/development
        final validStatuses = ['SETUP', 'REGISTRATION_OPEN', 'ONGOING', 'DRAFT'];
        if (!validStatuses.contains(conference.status)) {
          // Debug: Print why card is hidden
          debugPrint('⚠️ Conference card hidden - Status: ${conference.status}');
          return const SizedBox.shrink();
        }

        return _buildConferenceCard(context, conference, isRTL, l10n);
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) {
        // Show error message for debugging
        debugPrint('❌ Conference card error: $error');
        debugPrint('❌ Stack trace: $stackTrace');
        // Return empty for now, but you can show an error widget if needed
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildConferenceCard(BuildContext context, ConferenceModel conference,
      bool isRTL, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEC1313), Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Conference Title, Date and Location
            _buildHeader(conference, isRTL),

            const SizedBox(height: 24),

            // Registration Countdown
            _buildRegistrationCountdown(conference),

            const SizedBox(height: 16),

            // Register/Subscribe Button
            if (_shouldShowButton(conference))
              _buildSubscribeButton(conference.status),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ConferenceModel conference, bool isRTL) {
    // Get conference name based on language
    final conferenceName =
        (isRTL ? conference.nameAr : conference.nameEn) ?? conference.nameAr;

    // Format dates: (26 الى 29) يناير 2026
    final startDay = conference.startDate.day;
    final endDay = conference.endDate.day;
    final monthName = _getArabicMonthName(conference.startDate.month);
    final year = conference.startDate.year;

    final dateText = '($startDay الى $endDay) $monthName $year';

    // Location
    final locationText = conference.location ?? '';

    return Column(
      children: [
        // Conference Title
        Text(
          conferenceName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Conference Date and Location
        Text(
          locationText.isNotEmpty ? '$dateText | $locationText' : dateText,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.normal,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationCountdown(ConferenceModel conference) {
    final now = DateTime.now();

    // Show countdown conditions:
    // 1. watchModeEnabled == true
    // 2. registrationStartDate != null
    // 3. now < registrationStartDate (registration hasn't started yet)
    // Hide countdown if:
    // 1. registrationStartDate has passed
    // 2. registrationEndDate has passed
    // 3. conference.status == 'ONGOING'

    final shouldShowCountdown = conference.watchModeEnabled == true &&
        conference.registrationStartDate != null &&
        now.isBefore(conference.registrationStartDate!) &&
        (conference.registrationEndDate == null ||
            now.isBefore(conference.registrationEndDate!)) &&
        conference.status != 'ONGOING';

    if (!shouldShowCountdown) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          'يبدأ التسجيل بعد...',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Countdown Boxes
        CountdownTimer(
          endTime: conference.registrationStartDate!.millisecondsSinceEpoch,
          widgetBuilder: (_, time) {
            if (time == null) return const SizedBox.shrink();

            return Row(
              children: [
                Expanded(
                  child: _buildCountdownBox(
                    value: time.days ?? 0,
                    label: 'يوم',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCountdownBox(
                    value: time.hours ?? 0,
                    label: 'ساعة',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCountdownBox(
                    value: time.min ?? 0,
                    label: 'دقيقة',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCountdownBox(
                    value: time.sec ?? 0,
                    label: 'ثانية',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCountdownBox({required int value, required String label}) {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  bool _shouldShowButton(ConferenceModel conference) {
    // Show button only if status is REGISTRATION_OPEN or ONGOING
    return conference.status == 'REGISTRATION_OPEN' ||
        conference.status == 'ONGOING';
  }

  Widget _buildSubscribeButton(String status) {
    return _SubscribeButtonBuilder(status: status);
  }

  String _getArabicMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEC1313), Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SubscribeButtonBuilder extends ConsumerStatefulWidget {
  final String status;

  const _SubscribeButtonBuilder({required this.status});

  @override
  ConsumerState<_SubscribeButtonBuilder> createState() =>
      _SubscribeButtonBuilderState();
}

class _SubscribeButtonBuilderState
    extends ConsumerState<_SubscribeButtonBuilder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final conferenceAsync = ref.watch(activeConferenceProvider);

    return conferenceAsync.when(
      data: (conference) {
        if (conference == null) {
          return const SizedBox.shrink();
        }

        // Check if user already registered
        final registrationAsync = ref.watch(
          conferenceRegistrationProvider(conference.id),
        );

        return registrationAsync.when(
          data: (registration) {
            if (registration != null) {
              // User is already registered - show status
              final statusInfo = _getRegistrationStatusInfo(registration.status);
              
              // Handle ON_HOLD status specially - show reactivation dialog
              if (registration.status == 'ON_HOLD') {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _showReactivationDialog(context, conference, registration.id),
                    icon: Icon(statusInfo.icon, size: 20),
                    label: Text(
                      statusInfo.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusInfo.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                );
              }
              
              // For other statuses, navigate to registrations screen
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyRegistrationsScreen(),
                      ),
                    );
                  },
                  icon: Icon(statusInfo.icon, size: 20),
                  label: Text(
                    statusInfo.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusInfo.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            }

            // User not registered - show subscribe button
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        try {
                          final service = ConferenceService();
                          await service.registerToConference(
                            conferenceId: conference.id,
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إرسال طلب التسجيل بنجاح'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Refresh registration status
                            ref.invalidate(
                              conferenceRegistrationProvider(conference.id),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            // Extract error message from exception
                            String errorMessage = 'فشل في التسجيل';
                            if (e is Exception) {
                              final errorStr = e.toString();
                              // Remove "Exception: " prefix if present
                              if (errorStr.startsWith('Exception: ')) {
                                errorMessage = errorStr.substring(11);
                              } else {
                                errorMessage = errorStr;
                              }
                            } else {
                              errorMessage = e.toString();
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC1313),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'اشترك الآن',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
          loading: () => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1313),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
          error: (_, __) => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);
                try {
                  final conferenceData = await ref.read(
                    activeConferenceProvider.future,
                  );
                  if (conferenceData != null) {
                    final service = ConferenceService();
                    await service.registerToConference(
                      conferenceId: conferenceData.id,
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال طلب التسجيل بنجاح'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      ref.invalidate(
                        conferenceRegistrationProvider(conferenceData.id),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    // Extract error message from exception
                    String errorMessage = 'فشل في التسجيل';
                    if (e is Exception) {
                      final errorStr = e.toString();
                      // Remove "Exception: " prefix if present
                      if (errorStr.startsWith('Exception: ')) {
                        errorMessage = errorStr.substring(11);
                      } else {
                        errorMessage = errorStr;
                      }
                    } else {
                      errorMessage = e.toString();
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1313),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'اشترك الآن',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Show reactivation dialog when user clicks on ON_HOLD button
  Future<void> _showReactivationDialog(
    BuildContext context,
    ConferenceModel conference,
    String registrationId,
  ) async {
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'طلب معلق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'لقد انتهت مهلة الدفع وتم تعليق طلب اشتراكك في المؤتمر.\n\nهل تريد إعادة تفعيل طلبك؟',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC1313),
                foregroundColor: Colors.white,
              ),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );

    if (shouldRequest == true && mounted) {
      setState(() => isLoading = true);
      
      try {
        final registrationService = RegistrationService();
        await registrationService.requestReactivation(
          registrationId: registrationId,
          reason: 'طلب إعادة تفعيل من المستخدم',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال طلب إعادة التفعيل بنجاح. سيتم مراجعته من قبل الإدارة.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );
          
          // Refresh registration status
          ref.invalidate(conferenceRegistrationProvider(conference.id));
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'فشل في إرسال طلب إعادة التفعيل';
          if (e is Exception) {
            final errorStr = e.toString();
            if (errorStr.startsWith('Exception: ')) {
              errorMessage = errorStr.substring(11);
            } else {
              errorMessage = errorStr;
            }
          } else {
            errorMessage = e.toString();
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  /// Get registration status information (text, color, icon)
  _RegistrationStatusInfo _getRegistrationStatusInfo(String status) {
    switch (status) {
      case 'UNDER_REVIEW':
        return _RegistrationStatusInfo(
          text: 'قيد المراجعة',
          color: Colors.blue,
          icon: Icons.hourglass_empty,
        );
      case 'PAYMENT_PENDING':
        return _RegistrationStatusInfo(
          text: 'في انتظار الدفع',
          color: Colors.orange,
          icon: Icons.payment,
        );
      case 'ACTIVE_PARTICIPANT':
        return _RegistrationStatusInfo(
          text: 'مشترك',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case 'REJECTED':
        return _RegistrationStatusInfo(
          text: 'مرفوض',
          color: Colors.red,
          icon: Icons.cancel,
        );
      case 'WAITING_LIST':
        return _RegistrationStatusInfo(
          text: 'بقائمة الانتظار',
          color: Colors.purple,
          icon: Icons.queue,
        );
      case 'ON_HOLD':
        return _RegistrationStatusInfo(
          text: 'معلق',
          color: Colors.red[700]!,
          icon: Icons.pause_circle,
        );
      case 'CANCELLED':
        return _RegistrationStatusInfo(
          text: 'ملغي',
          color: Colors.grey[600]!,
          icon: Icons.cancel_outlined,
        );
      case 'ACCEPTED':
        return _RegistrationStatusInfo(
          text: 'مقبول',
          color: Colors.green[600]!,
          icon: Icons.check_circle_outline,
        );
      default:
        return _RegistrationStatusInfo(
          text: 'مسجل',
          color: Colors.green,
          icon: Icons.info,
        );
    }
  }
}

/// Helper class for registration status information
class _RegistrationStatusInfo {
  final String text;
  final Color color;
  final IconData icon;

  _RegistrationStatusInfo({
    required this.text,
    required this.color,
    required this.icon,
  });
}
