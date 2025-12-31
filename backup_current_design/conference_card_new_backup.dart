import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/conference_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../providers/language_provider.dart';

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
          return const SizedBox.shrink();
        }

        // Show card only for statuses: SETUP, REGISTRATION_OPEN, ONGOING
        final validStatuses = ['SETUP', 'REGISTRATION_OPEN', 'ONGOING'];
        if (!validStatuses.contains(conference.status)) {
          return const SizedBox.shrink();
        }

        return _buildConferenceCard(context, conference, isRTL, l10n);
      },
      loading: () => _buildLoadingState(),
      error: (_, __) => const SizedBox.shrink(),
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
    // Hide countdown if:
    // 1. registrationEndDate has passed
    // 2. conference.status == 'ONGOING'

    final shouldShowCountdown = conference.watchModeEnabled == true &&
        conference.registrationStartDate != null &&
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
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Handle subscription
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
    );
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
