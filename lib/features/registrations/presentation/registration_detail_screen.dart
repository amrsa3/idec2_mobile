import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/invoice_model.dart';
import '../../../models/payment_gateway_model.dart';
import '../../../models/payment_instruction_model.dart';
import '../../../models/registration_model.dart';
import '../../../models/transaction_model.dart';
import '../../../providers/conference_provider.dart';
import '../../../services/payment_service.dart';
import '../../../services/registration_service.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';
import '../widgets/payment_gateway_selector.dart';
import '../widgets/payment_input_dialog.dart';
import 'invoice_receipt_screen.dart';
import 'my_registrations_screen.dart';

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

class RegistrationDetailScreen extends ConsumerStatefulWidget {
  final String registrationId;

  const RegistrationDetailScreen({
    super.key,
    required this.registrationId,
  });

  @override
  ConsumerState<RegistrationDetailScreen> createState() =>
      _RegistrationDetailScreenState();
}

class _RegistrationDetailScreenState
    extends ConsumerState<RegistrationDetailScreen> {
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final registrationAsync =
        ref.watch(registrationDetailProvider(widget.registrationId));
    final timelineAsync =
        ref.watch(registrationTimelineProvider(widget.registrationId));

    return ProfessionalLoadingOverlay(
      isLoading: _isProcessingPayment,
      message: 'جاري معالجة الدفع...',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('تفاصيل الاشتراك'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: registrationAsync.when(
          data: (registration) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                    registrationDetailProvider(widget.registrationId));
                ref.invalidate(
                    registrationTimelineProvider(widget.registrationId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card with Entity Info
                    _buildHeaderCard(registration),
                    const SizedBox(height: 16),

                    // Status Card
                    _buildStatusCard(registration),
                    const SizedBox(height: 16),

                    // Payment Information Card
                    _buildPaymentInfoCard(registration),
                    const SizedBox(height: 16),

                    // Action Buttons
                    _buildActionButtons(registration),
                    const SizedBox(height: 24),

                    // Timeline Section
                    _buildTimelineSection(timelineAsync),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                    'خطأ في تحميل البيانات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(
                          registrationDetailProvider(widget.registrationId));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
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
  }

  Widget _buildHeaderCard(RegistrationModel registration) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    registration.isConference
                        ? Icons.business_center
                        : Icons.event,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        registration.isConference ? 'مؤتمر' : 'فعالية',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        registration.entityTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(RegistrationModel registration) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'حالة الاشتراك',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _StatusBadge(status: registration.status),
            if (registration.isOnHold && registration.onHoldReason != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سبب التعليق',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            registration.onHoldReason!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard(RegistrationModel registration) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');
    final timeFormat = DateFormat('hh:mm a', 'ar');
    final amountFormat = NumberFormat('#,##0.##', 'ar');

    final formattedAmount = amountFormat.format(registration.calculatedPrice);
    final currencyLabel = registration.currency?.toUpperCase() ?? 'USD';

    final updatedAt = registration.updatedAt;
    final updatedValue = updatedAt != null
        ? '${dateFormat.format(updatedAt)}\n${timeFormat.format(updatedAt)}'
        : 'لم يتم التحديث بعد';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.payment,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'معلومات الدفع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _AmountHighlightBox(
              label: 'المبلغ المطلوب',
              amount: formattedAmount,
              currency: currencyLabel,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CompactInfoItem(
                    icon: Icons.calendar_today,
                    iconColor: Colors.grey,
                    label: 'تاريخ الاشتراك',
                    value:
                        '${dateFormat.format(registration.createdAt)}\n${timeFormat.format(registration.createdAt)}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CompactInfoItem(
                    icon: Icons.update,
                    iconColor: Colors.grey,
                    label: 'آخر تحديث',
                    value: updatedValue,
                    valueColor:
                        updatedAt != null ? Colors.grey[800] : Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (registration.paymentDeadline != null) ...[
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.access_time,
                iconColor:
                    registration.paymentDeadline!.isBefore(DateTime.now())
                        ? Colors.red
                        : Colors.orange,
                label: 'مهلة الدفع',
                value:
                    '${dateFormat.format(registration.paymentDeadline!)} ${timeFormat.format(registration.paymentDeadline!)}',
                valueColor:
                    registration.paymentDeadline!.isBefore(DateTime.now())
                        ? Colors.red[700]
                        : Colors.orange[700],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(RegistrationModel registration) {
    return Column(
      children: [
        if (registration.isPaymentPending)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // ✅ تعطيل الزر إذا كان في حالة معالجة
              onPressed: _isProcessingPayment 
                  ? null 
                  : () => _handlePayment(context),
              icon: _isProcessingPayment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.payment, size: 24),
              label: Text(
                _isProcessingPayment ? 'جاري المعالجة...' : 'إتمام الدفع',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isProcessingPayment 
                    ? Colors.grey 
                    : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isProcessingPayment ? 0 : 2,
              ),
            ),
          ),
        if (registration.isOnHold) ...[
          if (registration.isPaymentPending) const SizedBox(height: 12),
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
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('تم إرسال طلب إعادة التفعيل بنجاح'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                    // Refresh data
                    ref.invalidate(
                        registrationDetailProvider(widget.registrationId));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'فشل في طلب إعادة التفعيل: ${e.toString()}',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('طلب إعادة تفعيل'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimelineSection(AsyncValue<Map<String, dynamic>> timelineAsync) {
    return timelineAsync.when(
      data: (timeline) {
        if (timeline['timeline'] == null ||
            (timeline['timeline'] as List).isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'السجل الزمني',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...List.generate((timeline['timeline'] as List).length,
                    (index) {
                  final item = (timeline['timeline'] as List)[index];
                  final isLast =
                      index == (timeline['timeline'] as List).length - 1;
                  return _TimelineItem(
                    item: item,
                    isLast: isLast,
                  );
                }),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _handlePayment(BuildContext context) async {
    // ✅ فحص مسبق لمنع التكرار
    if (_isProcessingPayment) {
      debugPrint('💳 [PAYMENT] Payment already in progress, ignoring duplicate request');
      return;
    }

    // ✅ الآن آمن للبدء
    setState(() {
      _isProcessingPayment = true;
    });

    try {
      debugPrint(
          '💳 [PAYMENT] Starting payment process for registration: ${widget.registrationId}');
      final paymentService = PaymentService();

      // Step 1: Fetch invoice
      debugPrint('💳 [PAYMENT] Step 1: Fetching invoice...');
      InvoiceModel? invoice;
      try {
        invoice = await paymentService
            .getInvoiceByRegistrationId(widget.registrationId);
        debugPrint(
            '💳 [PAYMENT] Step 1: Invoice fetched successfully - Amount: ${invoice.amountDue}, Status: ${invoice.status}');
      } catch (e) {
        debugPrint('💳 [PAYMENT] Step 1: Failed to fetch invoice: $e');
        // ✅ إصلاح: إذا لم توجد فاتورة، حاول إنشاء واحدة
        if (context.mounted) {
          final shouldCreate = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('فاتورة غير موجودة'),
              content: const Text(
                'لم يتم العثور على فاتورة لهذا التسجيل. هل تريد إنشاء فاتورة جديدة؟',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('إنشاء فاتورة'),
                ),
              ],
            ),
          );
          
          if (shouldCreate == true) {
            // محاولة إنشاء فاتورة من خلال API
            try {
              // TODO: إضافة endpoint لإنشاء فاتورة إذا لم تكن موجودة
              // في الوقت الحالي، نعرض رسالة للمستخدم
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى المحاولة مرة أخرى بعد قليل. إذا استمرت المشكلة، يرجى التواصل مع الدعم الفني.'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            } catch (createError) {
              debugPrint('💳 [PAYMENT] Failed to create invoice: $createError');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل إنشاء الفاتورة: ${createError.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            }
          }
        }
        return; // إيقاف العملية إذا لم توجد فاتورة
      }
      
      if (invoice == null) {
        debugPrint('💳 [PAYMENT] ERROR: Invoice is null after fetch attempt');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم العثور على فاتورة لهذا التسجيل. يرجى التواصل مع الدعم الفني.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Step 2: Fetch active gateways
      debugPrint('💳 [PAYMENT] Step 2: Fetching active gateways...');
      final gateways = await paymentService.getActiveGateways();
      debugPrint(
          '💳 [PAYMENT] Step 2: Found ${gateways.length} active gateway(s)');

      if (gateways.isEmpty) {
        debugPrint('💳 [PAYMENT] ERROR: No active gateways available');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Text('لا توجد بوابات دفع نشطة حالياً'),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        return;
      }

      // Step 3: Show gateway selector
      debugPrint('💳 [PAYMENT] Step 3: Showing gateway selector...');
      final selectedGateway =
          await PaymentGatewaySelector.show(context, gateways);

      if (selectedGateway == null) {
        debugPrint('💳 [PAYMENT] Step 3: User cancelled gateway selection');
        return;
      }
      debugPrint(
          '💳 [PAYMENT] Step 3: Gateway selected: ${selectedGateway.displayName} (${selectedGateway.id})');

      // Step 4: Initiate payment
      // ✅ إصلاح: التأكد من أن invoice ليس null قبل الاستخدام
      if (invoice == null) {
        debugPrint('💳 [PAYMENT] ERROR: Invoice is null, cannot proceed');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('خطأ: لم يتم العثور على الفاتورة'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      debugPrint('💳 [PAYMENT] Step 4: Initiating payment with gateway...');
      final initiateResult = await paymentService.initiatePayment(
        invoiceId: invoice.id,
        gatewayId: selectedGateway.id,
      );

      final transaction = initiateResult['transaction'] as TransactionModel;
      final instruction =
          initiateResult['paymentInstruction'] as PaymentInstructionModel;
      debugPrint(
          '💳 [PAYMENT] Step 4: Payment initiated - Transaction ID: ${transaction.id}, Instruction type: ${instruction.type}');

      // Step 5: Show input dialog
      // ✅ إصلاح: التأكد من أن invoice ليس null قبل الاستخدام
      if (invoice == null) {
        debugPrint('💳 [PAYMENT] ERROR: Invoice is null, cannot proceed');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('خطأ: لم يتم العثور على الفاتورة'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      debugPrint('💳 [PAYMENT] Step 5: Showing payment input dialog...');
      final inputResult = await PaymentInputDialog.show(
        context,
        instruction,
        selectedGateway.displayName,
        amount: invoice.amountDue,
        currency: invoice.currencyCode,
      );

      if (inputResult == null || inputResult.isCancelled) {
        debugPrint('💳 [PAYMENT] Step 5: User cancelled payment input');
        await paymentService.cancelTransaction(
          transactionId: transaction.id,
          reason: 'User cancelled payment input',
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('تم إلغاء عملية الدفع'),
                  ),
                ],
              ),
              backgroundColor: Colors.blueGrey,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        return;
      }

      final inputData = inputResult.data ?? {};

      debugPrint(
          '💳 [PAYMENT] Step 5: Payment input received - Fields: ${inputData.keys.join(", ")}');

      final mutableInputData = Map<String, dynamic>.from(inputData);
      final gatewayNameLower =
          selectedGateway.displayName.toLowerCase();
      final isJawaliGateway = gatewayNameLower.contains('جوالي') ||
          gatewayNameLower.contains('jwali') ||
          gatewayNameLower.contains('jawali');

      if (isJawaliGateway) {
        final receiverMobileRaw =
            (mutableInputData['receiverMobile'] as String?)?.trim() ?? '';
        debugPrint(
            '💳 [PAYMENT] Jawali detected. Entered receiverMobile: "$receiverMobileRaw"');
        if (receiverMobileRaw.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يرجى إدخال رقم المحفظة قبل المتابعة'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        mutableInputData['receiverMobile'] = receiverMobileRaw;
        mutableInputData['receiver_mobile'] = receiverMobileRaw;
        debugPrint(
            '💳 [PAYMENT] Using receiverMobile in payload: "$receiverMobileRaw"');
      }

      // Step 6: Confirm payment
      debugPrint('💳 [PAYMENT] Step 6: Confirming payment with gateway...');
      final confirmedTransaction = await paymentService.confirmPayment(
        transactionId: transaction.id,
        inputData: mutableInputData,
      );
      debugPrint(
          '💳 [PAYMENT] Step 6: Payment confirmation completed - Status: ${confirmedTransaction.status}, Gateway TXN ID: ${confirmedTransaction.gatewayTransactionId}');

      // Step 7: Handle result
      debugPrint('💳 [PAYMENT] Step 7: Processing payment result...');
      if (context.mounted) {
        if (confirmedTransaction.isSuccessful) {
          debugPrint('💳 [PAYMENT] ✅ SUCCESS: Payment completed successfully!');

          // Get registration details to find conference ID
          final registration = await ref
              .read(registrationDetailProvider(widget.registrationId).future);
          final conferenceId = registration.conferenceId;

          // Refresh registration details
          ref.invalidate(registrationDetailProvider(widget.registrationId));
          ref.invalidate(registrationTimelineProvider(widget.registrationId));

          // Refresh my registrations list to show updated status
          ref.invalidate(myRegistrationsProvider);

          // 🔥 IMPORTANT: Invalidate conference registration provider to update card on home screen
          if (conferenceId != null && conferenceId.isNotEmpty) {
            debugPrint(
                '💳 [PAYMENT] Invalidating conference registration provider for conference: $conferenceId');
            ref.invalidate(conferenceRegistrationProvider(conferenceId));
            // Also invalidate active conference to ensure fresh data
            ref.invalidate(activeConferenceProvider);
          }

          // Navigate to receipt
          // ✅ إصلاح: التأكد من أن invoice ليس null قبل الاستخدام
          if (invoice == null) {
            debugPrint('💳 [PAYMENT] ERROR: Invoice is null, cannot navigate to receipt');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('خطأ: لم يتم العثور على الفاتورة'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceReceiptScreen(
                invoice: invoice!,
                transaction: confirmedTransaction,
              ),
            ),
          );
        } else {
          debugPrint(
              '💳 [PAYMENT] ❌ FAILED: Payment confirmation failed - Status: ${confirmedTransaction.status}, Error: ${confirmedTransaction.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        confirmedTransaction.errorMessage ?? 'فشل عملية الدفع'),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💳 [PAYMENT] ❌ ERROR: Payment process failed with exception');
      debugPrint('💳 [PAYMENT] Error message: $e');
      debugPrint('💳 [PAYMENT] Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('فشل عملية الدفع: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      debugPrint('💳 [PAYMENT] Payment process ended');
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
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

  IconData get icon {
    switch (status) {
      case 'UNDER_REVIEW':
        return Icons.hourglass_empty;
      case 'ACCEPTED':
      case 'ACTIVE_PARTICIPANT':
        return Icons.check_circle;
      case 'PAYMENT_PENDING':
        return Icons.payment;
      case 'REJECTED':
        return Icons.cancel;
      case 'ON_HOLD':
        return Icons.pause_circle;
      default:
        return Icons.info;
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.grey[600])!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor ?? Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact info item for horizontal layout
class _CompactInfoItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _CompactInfoItem({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor ?? Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.grey[800],
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AmountHighlightBox extends StatelessWidget {
  final String label;
  final String amount;
  final String currency;

  const _AmountHighlightBox({
    required this.label,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[50]!,
            Colors.grey[100]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 8),
              Text(
                currency,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isLast;

  const _TimelineItem({
    required this.item,
    required this.isLast,
  });

  Map<String, dynamic>? get _metadata =>
      item['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(item['metadata'] as Map)
          : null;

  bool get _isPaymentEvent {
    final description =
        (item['description'] ?? '').toString().toLowerCase().trim();
    if (_metadata != null &&
        (_metadata!.containsKey('invoiceNumber') ||
            _metadata!.containsKey('invoiceId') ||
            _metadata!.containsKey('paymentMethod'))) {
      return true;
    }
    return description.contains('payment completed') ||
        description.contains('تم إتمام الدفع') ||
        description.contains('تم الدفع');
  }

  String? get _invoiceReference {
    if (_metadata != null) {
      final invoiceNumber = _metadata!['invoiceNumber'];
      if (invoiceNumber is String && invoiceNumber.isNotEmpty) {
        return invoiceNumber;
      }
      final invoiceId = _metadata!['invoiceId'];
      if (invoiceId is String && invoiceId.isNotEmpty) {
        return invoiceId;
      }
    }

    final description = item['description']?.toString() ?? '';
    final invoiceRegex = RegExp(r'(INV-\d{4}-\d{6})', caseSensitive: false);
    final match = invoiceRegex.firstMatch(description);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  String? get _paymentMethodLabel {
    if (_metadata == null) return null;
    final rawMethod = _metadata!['paymentMethod'];
    if (rawMethod is! String) return null;

    switch (rawMethod.toUpperCase()) {
      case 'ELECTRONIC':
        return 'دفع إلكتروني';
      case 'CASH':
        return 'دفع نقدي';
      default:
        return rawMethod;
    }
  }

  Color get _getStatusColor {
    if (_isPaymentEvent) {
      return Colors.green;
    }
    if (item['type'] == 'STATUS_CHANGED') {
      switch (item['newStatus']) {
        case 'ACCEPTED':
        case 'ACTIVE_PARTICIPANT':
          return Colors.green;
        case 'REJECTED':
          return Colors.red;
        default:
          return Colors.blue;
      }
    }
    return Colors.blue;
  }

  IconData get _getIcon {
    if (_isPaymentEvent) {
      return Icons.receipt_long;
    }
    if (item['type'] == 'STATUS_CHANGED') {
      switch (item['newStatus']) {
        case 'ACCEPTED':
        case 'ACTIVE_PARTICIPANT':
          return Icons.check_circle;
        case 'REJECTED':
          return Icons.cancel;
        default:
          return Icons.info;
      }
    }
    return Icons.event;
  }

  /// Translate timeline description to Arabic
  String _translateTimelineDescription(String description) {
    if (_isPaymentEvent) {
      return 'تم الدفع';
    }

    // Translate common English phrases to Arabic
    final translations = {
      'Registration created': 'تم إنشاء طلب الاشتراك',
      'Status changed to': 'تم تغيير الحالة إلى',
      'Payment pending': 'في انتظار الدفع',
      'Under review': 'قيد المراجعة',
      'Accepted': 'مقبول',
      'Rejected': 'مرفوض',
      'Active participant': 'مشترك نشط',
      'On hold': 'معلق',
      'Cancelled': 'ملغي',
      'Waiting list': 'بقائمة الانتظار',
      'Payment completed': 'تم إتمام الدفع',
      'Payment deadline': 'مهلة الدفع',
    };

    // Check if description contains any English phrases
    for (var entry in translations.entries) {
      if (description.contains(entry.key)) {
        return description.replaceAll(entry.key, entry.value);
      }
    }

    // If status is STATUS_CHANGED, translate the status name
    if (item['type'] == 'STATUS_CHANGED' && item['newStatus'] != null) {
      final status = item['newStatus'] as String;
      final statusTranslations = {
        'UNDER_REVIEW': 'قيد المراجعة',
        'PAYMENT_PENDING': 'في انتظار الدفع',
        'ACCEPTED': 'مقبول',
        'ACTIVE_PARTICIPANT': 'مشترك نشط',
        'REJECTED': 'مرفوض',
        'ON_HOLD': 'معلق',
        'CANCELLED': 'ملغي',
        'WAITING_LIST': 'بقائمة الانتظار',
      };

      if (statusTranslations.containsKey(status)) {
        return 'تم تغيير الحالة إلى: ${statusTranslations[status]}';
      }
    }

    // Return original description if no translation found
    return description;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');
    final timeFormat = DateFormat('hh:mm a', 'ar');
    final timestamp = DateTime.parse(item['timestamp']);
    final invoiceReference = _invoiceReference;
    final paymentMethodLabel = _paymentMethodLabel;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor,
                  width: 2,
                ),
              ),
              child: Icon(
                _getIcon,
                color: _getStatusColor,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translateTimelineDescription(item['description'] ?? ''),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                if (_isPaymentEvent && invoiceReference != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 14,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'رقم الفاتورة: $invoiceReference',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (_isPaymentEvent && paymentMethodLabel != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        paymentMethodLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${dateFormat.format(timestamp)} ${timeFormat.format(timestamp)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
