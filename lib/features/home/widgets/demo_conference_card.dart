import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// كارد تجريبي للمؤتمر - يمكن استخدامه للعرض والتجربة
class DemoConferenceCard extends ConsumerWidget {
  const DemoConferenceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // بيانات تجريبية
    const demoConference = {
      'nameAr': 'مؤتمر التطوير التقني 2026',
      'nameEn': 'Tech Development Conference 2026',
      'startDate': '2026-02-01',
      'endDate': '2026-02-03',
      'daysRemaining': 25,
      'hoursRemaining': 8,
      'minutesRemaining': 30,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.deepPurple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isRTL ? 'عرض تجريبي' : 'DEMO',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isRTL
                      ? demoConference['nameAr'] as String
                      : demoConference['nameEn'] as String,
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
                      '${l10n.from} ${demoConference['startDate']} ${l10n.to} ${demoConference['endDate']}',
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

          // Content Section
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Countdown Timer - Demo
                _buildDemoCountdown(),
                const SizedBox(height: 16),

                // Registration Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isRTL
                            ? 'التسجيل مفتوح - سارع بالتسجيل'
                            : 'Registration Open - Register Now',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Register Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isRTL
                            ? 'هذا كارد تجريبي - الزر غير نشط حالياً'
                            : 'This is a demo card - Button is not active',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.send,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRTL ? 'سجل الآن' : 'Register Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Features Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureItem(Icons.event, isRTL ? '15+ حدث' : '15+ Events',
                    Colors.blue.shade200),
                _buildFeatureItem(
                    Icons.people,
                    isRTL ? '50+ متحدث' : '50+ Speakers',
                    Colors.green.shade200),
                _buildFeatureItem(
                    Icons.business,
                    isRTL ? '20+ شركة' : '20+ Companies',
                    Colors.purple.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCountdown() {
    // Create a target date 25 days from now
    final targetDate = DateTime.now().add(const Duration(
      days: 25,
      hours: 8,
      minutes: 30,
    ));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CountdownTimer(
        endTime: targetDate.millisecondsSinceEpoch,
        widgetBuilder: (_, time) {
          if (time == null) return const SizedBox.shrink();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Days
              _buildDemoTimeCard(
                time.days ?? 0,
                'يوم',
                'Days',
                Icons.calendar_today,
              ),
              const SizedBox(width: 8),
              // Hours
              _buildDemoTimeCard(
                time.hours ?? 0,
                'ساعة',
                'Hours',
                Icons.access_time,
              ),
              const SizedBox(width: 8),
              // Minutes
              _buildDemoTimeCard(
                time.min ?? 0,
                'دقيقة',
                'Min',
                Icons.timer,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDemoTimeCard(
      int value, String labelAr, String labelEn, IconData icon) {
    // Demo card always shows Arabic labels

    return Container(
      width: 80,
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
            labelAr, // Demo card always shows Arabic
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

  Widget _buildFeatureItem(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
