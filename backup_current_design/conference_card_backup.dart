import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/conference_model.dart';
import '../../../models/registration_status_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../providers/language_provider.dart';

class ConferenceCard extends ConsumerWidget {
  const ConferenceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isRTL = ref.watch(isRTLProvider);
    final conferenceAsync = ref.watch(activeConferenceProvider);

    return conferenceAsync.when(
      data: (conference) {
        print('📋 Conference data received: ${conference?.nameAr ?? "null"}');
        if (conference == null) {
          print('⚠️ Conference is null, hiding card');
          return const SizedBox.shrink();
        }

        final registrationAsync = ref.watch(
          conferenceRegistrationProvider(conference.id),
        );

        return _buildCard(context, l10n, isRTL, conference, registrationAsync);
      },
      loading: () {
        print('⏳ Loading conference...');
        return _buildLoadingCard();
      },
      error: (error, stack) {
        print('❌ Error loading conference: $error');
        print('Stack trace: $stack');
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isRTL,
    ConferenceModel conference,
    AsyncValue<RegistrationStatusModel?> registrationAsync,
  ) {
    final now = DateTime.now();
    final isOngoing = conference.status == 'ONGOING';
    final isRegistrationOpen = conference.status == 'REGISTRATION_OPEN';

    final conferenceName =
        (isRTL ? conference.nameAr : conference.nameEn) ?? conference.nameAr;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Dark background like in the image
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conferenceName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white.withOpacity(0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n.from} ${_formatDate(conference.startDate)} ${l10n.to} ${_formatDate(conference.endDate)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // عداد الوقت المتبقي: يظهر فقط عندما showTimeRemaining == true
                if (conference.showTimeRemaining == true)
                  _buildTimeRemainingSection(context, l10n, conference.endDate),

                // عداد بداية التسجيل: يظهر عند تفعيل وضع الترقب وتحديد تاريخ بداية التسجيل
                // يختفي في حالة انتهاء تاريخ نهاية التسجيل أو إذا صارت حالة المؤتمر: جارية
                if (conference.watchModeEnabled == true &&
                    conference.registrationStartDate != null &&
                    (conference.registrationEndDate == null ||
                        now.isBefore(conference.registrationEndDate!)) &&
                    conference.status != 'ONGOING')
                  _buildRegistrationStartCountdown(
                      context, l10n, conference.registrationStartDate!),

                registrationAsync.when(
                  data: (registration) {
                    if (registration != null) {
                      return _buildRegistrationStatus(l10n, registration);
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          if (isRegistrationOpen || isOngoing)
            _buildRegisterButton(context, l10n),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimeRemainingSection(
      BuildContext context, AppLocalizations l10n, DateTime endDate) {
    final now = DateTime.now();
    final duration = endDate.difference(now);

    if (duration.isNegative) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CountdownTimer(
        endTime: endDate.millisecondsSinceEpoch,
        widgetBuilder: (_, time) {
          if (time == null) return const SizedBox.shrink();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // الأيام
              _buildTimeCard(
                  time.days ?? 0, l10n.daysRemaining, Icons.calendar_today),
              const SizedBox(width: 8),
              // الساعات
              _buildTimeCard(
                  time.hours ?? 0, l10n.hoursRemaining, Icons.access_time),
              const SizedBox(width: 8),
              // الدقائق
              _buildTimeCard(time.min ?? 0, l10n.minutesRemaining, Icons.timer),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeCard(int value, String label, IconData icon) {
    return Container(
      width: 80, // عرض ثابت للكارد
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getShortLabel(label),
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getShortLabel(String label) {
    // يأخذ أول كلمة فقط كاسم مختصر
    return label.split(' ').first;
  }

  Widget _buildRegistrationStartCountdown(BuildContext context,
      AppLocalizations l10n, DateTime registrationStartDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'يبدأ التسجيل بعد ....',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CountdownTimer(
              endTime: registrationStartDate.millisecondsSinceEpoch,
              widgetBuilder: (_, time) {
                if (time == null) return const SizedBox.shrink();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Seconds
                    _buildCountdownBox(
                        time.sec ?? 0, 'ثانية', Icons.timer_outlined),
                    const SizedBox(width: 6),
                    // Minutes
                    _buildCountdownBox(time.min ?? 0, 'دقيقة', Icons.timer),
                    const SizedBox(width: 6),
                    // Hours
                    _buildCountdownBox(
                        time.hours ?? 0, 'ساعة', Icons.access_time),
                    const SizedBox(width: 6),
                    // Days
                    _buildCountdownBox(
                        time.days ?? 0, 'يوم', Icons.calendar_today),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdownBox(int value, String label, IconData icon) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Dark gray background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationStatus(
      AppLocalizations l10n, RegistrationStatusModel registration) {
    String statusText;
    IconData statusIcon;

    switch (registration.status) {
      case 'UNDER_REVIEW':
        statusText = l10n.underReview;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'ACCEPTED':
      case 'PAYMENT_PENDING':
        statusText = l10n.paymentPending;
        statusIcon = Icons.payment;
        break;
      case 'ACTIVE_PARTICIPANT':
        statusText = l10n.activeParticipant;
        statusIcon = Icons.check_circle;
        break;
      case 'ON_HOLD':
        statusText = l10n.onHold;
        statusIcon = Icons.pause_circle;
        break;
      case 'REJECTED':
        statusText = l10n.rejected;
        statusIcon = Icons.cancel;
        break;
      default:
        statusText = registration.status;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            '${l10n.registrationStatus}: $statusText',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registration functionality coming soon')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red button like in the image
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: const Text(
            'سجل الآن', // Arabic text like in the image
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
