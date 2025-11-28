import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../models/payment_gateway_model.dart';
import '../../../models/payment_instruction_model.dart';
import '../../../models/transaction_model.dart';
import '../../../providers/enhanced_auth_provider.dart';
import '../../../services/event_service.dart';
import '../../../services/payment_service.dart';
import '../../../services/registration_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import '../../../shared/widgets/image_carousel.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';
import '../../registrations/presentation/registration_detail_screen.dart';
import '../../registrations/widgets/payment_gateway_selector.dart';
import '../../registrations/widgets/payment_input_dialog.dart';
import '../../speakers/presentation/speaker_details_screen.dart';

// Provider for event details
final eventDetailsProvider = FutureProvider.family<EventModel, String>((ref, eventId) async {
  final eventService = EventService();
  return await eventService.getEventById(eventId);
});

// Provider for event speakers
final eventSpeakersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, eventId) async {
  final eventService = EventService();
  return await eventService.getEventSpeakers(eventId);
});

// Provider for event registration status
final eventRegistrationStatusProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, eventId) async {
  final registrationService = RegistrationService();
  return await registrationService.getEventRegistrationStatus(eventId);
});

class EventDetailsScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  bool _isProcessingRegistration = false;
  bool _isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailsProvider(widget.eventId));
    final speakersAsync = ref.watch(eventSpeakersProvider(widget.eventId));
    final registrationStatusAsync = ref.watch(eventRegistrationStatusProvider(widget.eventId));
    final authState = ref.watch(enhancedAuthProvider);

    return ProfessionalLoadingOverlay(
      isLoading: _isProcessingRegistration || _isProcessingPayment,
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: eventAsync.when(
          data: (event) {
            // Check if user is authenticated
            final isAuthenticated = authState.maybeWhen(
              authenticated: (_) => true,
              orElse: () => false,
            );
            
            // If not authenticated, show login prompt with price
            if (!isAuthenticated) {
              final price = event.price ?? 0;
              final currency = event.currency ?? 'ريال';
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        if (price > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$price $currency',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to login or show login dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى تسجيل الدخول للاشتراك في الدورة'),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text(
                            'سجل الدخول للاشتراك',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return registrationStatusAsync.when(
              data: (status) {
                // If user is already registered, show status
                if (status != null) {
                  final registrationId = status['registrationId'] as String?;
                  final regStatus = status['status'] as String?;
                  
                  if (regStatus == 'PAYMENT_PENDING' && registrationId != null) {
                    // Show payment button
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isProcessingPayment ? null : () => _handlePayment(context, registrationId),
                            icon: _isProcessingPayment
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.payment, color: Colors.white),
                            label: Text(
                              _isProcessingPayment ? 'جاري المعالجة...' : 'إتمام الدفع',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (regStatus == 'ACTIVE_PARTICIPANT') {
                    // Already registered and paid
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: AppColors.success, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'تم الاشتراك في الدورة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                }

                // User not registered - show registration button
                final price = event.price ?? 0;
                final currency = event.currency ?? 'ريال';
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (price > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$price $currency',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isProcessingRegistration ? null : () => _handleRegistration(context, event),
                            icon: _isProcessingRegistration
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.how_to_reg, color: Colors.white),
                            label: Text(
                              _isProcessingRegistration ? 'جاري التسجيل...' : 'اشترك في الدورة',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => null,
              error: (_, __) => null,
            );
          },
          loading: () => null,
          error: (_, __) => null,
        ),
        body: eventAsync.when(
          data: (event) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventDetailsProvider(widget.eventId));
              ref.invalidate(eventSpeakersProvider(widget.eventId));
              ref.invalidate(eventRegistrationStatusProvider(widget.eventId));
            },
            child: CustomScrollView(
              slivers: [
                // App bar with image carousel
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: event.promotionalImages != null && event.promotionalImages!.isNotEmpty
                        ? ImageCarousel(
                            images: event.promotionalImages!,
                            height: 300,
                            fit: BoxFit.cover,
                            showIndicators: true,
                            autoPlay: event.promotionalImages!.length > 1,
                          )
                        : Container(
                            color: AppColors.primary,
                            child: const Center(
                              child: Icon(
                                Icons.event,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getTypeColor(event.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.typeLabel,
                        style: TextStyle(
                          color: _getTypeColor(event.type),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Date and time
                    _buildInfoRow(
                      Icons.calendar_today,
                      DateFormat('EEEE، d MMMM yyyy', 'ar').format(event.localStartTime),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.access_time,
                      event.formattedTime,
                    ),
                    if (event.duration != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.timer,
                        '${event.duration!.toStringAsFixed(1)} ساعة تعليمية',
                      ),
                    ],
                    if (event.price != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: (event.price! > 0 ? AppColors.primary : AppColors.success).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: event.price! > 0 ? AppColors.primary : AppColors.success,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (event.price! <= 0)
                              Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 24,
                              ),
                            if (event.price! > 0) const SizedBox(width: 0),
                            Text(
                              event.price! > 0
                                  ? '${event.price!.toStringAsFixed(0)} ${event.currency ?? 'ريال'}'
                                  : 'مجاني',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: event.price! > 0 ? AppColors.primary : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (event.capacity != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.people,
                        'السعة: ${event.capacity} شخص',
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Description
                    if (event.description != null && event.description!.isNotEmpty) ...[
                      const Text(
                        'الوصف',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Course details
                    if (event.courseDetails != null && event.courseDetails!.isNotEmpty) ...[
                      const Text(
                        'تفاصيل الدورة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.courseDetails!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Requirements
                    if (event.requirements != null && event.requirements!.isNotEmpty) ...[
                      const Text(
                        'المتطلبات',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.requirements!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Speakers
                    speakersAsync.when(
                      data: (speakers) {
                        if (speakers.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'المتحدثون',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: speakers.length,
                                itemBuilder: (context, index) {
                                  final speakerData = speakers[index]['speaker'] as Map<String, dynamic>?;
                                  if (speakerData == null) return const SizedBox.shrink();
                                  
                                  return Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SpeakerDetailsScreen(
                                                  speakerId: speakerData['id'] as String,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: AppColors.surfaceVariant,
                                            backgroundImage: speakerData['photoUrl'] != null
                                                ? null
                                                : null,
                                            child: speakerData['photoUrl'] != null
                                                ? ClipOval(
                                                    child: AuthenticatedImageWidget(
                                                      imageUrl: speakerData['photoUrl'] as String,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: AppColors.textSecondary,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          speakerData['name'] as String? ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            ],
            ),
          ),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل الفعالية'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الفعالية',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.error,
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'COURSE':
        return AppColors.info;
      case 'WORKSHOP':
        return AppColors.warning;
      case 'SEMINAR':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _handleRegistration(BuildContext context, EventModel event) async {
    if (!mounted) return;

    setState(() {
      _isProcessingRegistration = true;
    });

    try {
      final registrationService = RegistrationService();
      
      // Register to event
      final registration = await registrationService.registerToEvent(
        eventId: event.id,
      );

      if (!mounted) return;

      // Invalidate registration status to refresh UI
      ref.invalidate(eventRegistrationStatusProvider(event.id));

      // Check if payment is required
      if (registration.status == 'PAYMENT_PENDING') {
        // Navigate to payment
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationDetailScreen(
              registrationId: registration.id,
            ),
          ),
        );
      } else {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('تم التسجيل في الدورة بنجاح'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'فشل في التسجيل';
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
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingRegistration = false;
        });
      }
    }
  }

  Future<void> _handlePayment(BuildContext context, String registrationId) async {
    if (!mounted) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final paymentService = PaymentService();

      // Step 1: Fetch invoice
      final invoice = await paymentService.getInvoiceByRegistrationId(registrationId);

      // Step 2: Fetch active gateways
      final gateways = await paymentService.getActiveGateways();

      if (gateways.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Text('لا توجد بوابات دفع نشطة حالياً'),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      // Step 3: Show gateway selector
      final selectedGateway = await PaymentGatewaySelector.show(context, gateways);

      if (selectedGateway == null) {
        return;
      }

      // Step 4: Initiate payment
      final initiateResult = await paymentService.initiatePayment(
        invoiceId: invoice.id,
        gatewayId: selectedGateway.id,
      );

      final transaction = initiateResult['transaction'] as TransactionModel;
      final instruction = initiateResult['paymentInstruction'] as PaymentInstructionModel;

      // Step 5: Show input dialog
      final inputResult = await PaymentInputDialog.show(
        context,
        instruction,
        selectedGateway.displayName, // Using extension from PaymentGatewayModelExtensions
        amount: invoice.amountDue,
        currency: invoice.currencyCode,
      );

      if (inputResult == null || inputResult.isCancelled) {
        await paymentService.cancelTransaction(
          transactionId: transaction.id,
          reason: 'User cancelled payment input',
        );
        return;
      }

      final inputData = inputResult.data ?? {};
      final mutableInputData = Map<String, dynamic>.from(inputData);

      // Handle Jawali gateway
      final gatewayNameLower = selectedGateway.displayName.toLowerCase();
      final isJawaliGateway = gatewayNameLower.contains('جوالي') ||
          gatewayNameLower.contains('jwali') ||
          gatewayNameLower.contains('jawali');

      if (isJawaliGateway) {
        final receiverMobileRaw = (mutableInputData['receiverMobile'] as String?)?.trim() ?? '';
        if (receiverMobileRaw.isEmpty) {
          if (mounted) {
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
      }

      // Step 6: Confirm payment
      final confirmedTransaction = await paymentService.confirmPayment(
        transactionId: transaction.id,
        inputData: mutableInputData,
      );

      if (!mounted) return;

      if (confirmedTransaction.isSuccessful) {
        // Refresh registration status
        ref.invalidate(eventRegistrationStatusProvider(widget.eventId));

        // Navigate to registration details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationDetailScreen(
              registrationId: registrationId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(confirmedTransaction.errorMessage ?? 'فشل عملية الدفع'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
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
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}

