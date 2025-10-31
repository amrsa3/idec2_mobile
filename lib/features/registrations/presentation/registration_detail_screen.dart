import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/registration_model.dart';
import '../../../services/registration_service.dart';

final registrationDetailProvider =
    FutureProvider.family<RegistrationModel, String>(
        (ref, registrationId) async {
  final service = RegistrationService();
  return await service.getRegistrationDetails(registrationId);
});

final registrationTimelineProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
        (ref, registrationId) async {
  final service = RegistrationService();
  return await service.getRegistrationTimeline(registrationId);
});

class RegistrationDetailScreen extends ConsumerWidget {
  final String registrationId;

  const RegistrationDetailScreen({
    super.key,
    required this.registrationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationAsync =
        ref.watch(registrationDetailProvider(registrationId));
    final timelineAsync =
        ref.watch(registrationTimelineProvider(registrationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التسجيل'),
        centerTitle: true,
      ),
      body: registrationAsync.when(
        data: (registration) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Registration Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.entityTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _StatusBadge(status: registration.status),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.attach_money,
                          label: 'السعر',
                          value:
                              '${registration.calculatedPrice.toStringAsFixed(2)} ${registration.currency ?? 'USD'}',
                        ),
                        if (registration.paymentDeadline != null)
                          _InfoRow(
                            icon: Icons.access_time,
                            label: 'مهلة الدفع',
                            value:
                                '${registration.paymentDeadline!.day}/${registration.paymentDeadline!.month}/${registration.paymentDeadline!.year}',
                          ),
                        _InfoRow(
                          icon: Icons.calendar_today,
                          label: 'تاريخ التسجيل',
                          value:
                              '${registration.createdAt.day}/${registration.createdAt.month}/${registration.createdAt.year}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                if (registration.isPaymentPending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Open payment gateway
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم فتح بوابة الدفع قريباً'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('إتمام الدفع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                if (registration.isOnHold) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          final service = RegistrationService();
                          await service.requestReactivation(
                            registrationId: registration.id,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إرسال طلب إعادة التفعيل'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'فشل في طلب إعادة التفعيل: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('طلب إعادة تفعيل'),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Timeline
                timelineAsync.when(
                  data: (timeline) {
                    if (timeline['timeline'] == null ||
                        (timeline['timeline'] as List).isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الجدول الزمني',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(timeline['timeline'] as List).map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(
                                          top: 6, right: 12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: item['type'] ==
                                                    'STATUS_CHANGED' &&
                                                item['newStatus'] == 'ACCEPTED'
                                            ? Colors.green
                                            : item['type'] ==
                                                        'STATUS_CHANGED' &&
                                                    item['newStatus'] ==
                                                        'REJECTED'
                                                ? Colors.red
                                                : Colors.blue,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['description'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateTime.parse(item['timestamp'])
                                                .toString()
                                                .substring(0, 16),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('خطأ: ${error.toString()}'),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get color {
    switch (status) {
      case 'UNDER_REVIEW':
        return Colors.blue;
      case 'ACCEPTED':
      case 'ACTIVE_PARTICIPANT':
        return Colors.green;
      case 'PAYMENT_PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      case 'ON_HOLD':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  String get text {
    switch (status) {
      case 'UNDER_REVIEW':
        return 'قيد المراجعة';
      case 'ACCEPTED':
        return 'مقبول';
      case 'PAYMENT_PENDING':
        return 'انتظار الدفع';
      case 'ACTIVE_PARTICIPANT':
        return 'مشارك نشط';
      case 'REJECTED':
        return 'مرفوض';
      case 'ON_HOLD':
        return 'معلق';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
