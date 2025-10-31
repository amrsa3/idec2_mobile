import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/registration_model.dart';
import '../../../services/registration_service.dart';
import 'registration_detail_screen.dart';

final myRegistrationsProvider =
    FutureProvider<List<RegistrationModel>>((ref) async {
  final service = RegistrationService();
  return await service.getMyRegistrations();
});

class MyRegistrationsScreen extends ConsumerWidget {
  const MyRegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationsAsync = ref.watch(myRegistrationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيلاتي'),
        centerTitle: true,
      ),
      body: registrationsAsync.when(
        data: (registrations) {
          if (registrations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد تسجيلات',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'لم تقم بالتسجيل في أي مؤتمر أو فعالية بعد',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myRegistrationsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: registrations.length,
              itemBuilder: (context, index) {
                final registration = registrations[index];
                return _RegistrationCard(
                  registration: registration,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationDetailScreen(
                          registrationId: registration.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ في جلب التسجيلات',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(myRegistrationsProvider);
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  final RegistrationModel registration;
  final VoidCallback onTap;

  const _RegistrationCard({
    required this.registration,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
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

  String _getStatusText(String status) {
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.entityTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(registration.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(registration.status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getStatusText(registration.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(registration.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    registration.isConference ? Icons.event : Icons.event_note,
                    color: _getStatusColor(registration.status),
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${registration.calculatedPrice.toStringAsFixed(2)} ${registration.currency ?? 'USD'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${registration.createdAt.day}/${registration.createdAt.month}/${registration.createdAt.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              if (registration.paymentDeadline != null &&
                  registration.isPaymentPending) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'مهلة الدفع: ${registration.paymentDeadline!.day}/${registration.paymentDeadline!.month}/${registration.paymentDeadline!.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
