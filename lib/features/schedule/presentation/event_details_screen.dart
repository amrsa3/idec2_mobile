import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/auth/auth.dart';
import '../../../models/event_model.dart';
import '../../../models/payment_gateway_model.dart';
import '../../../models/payment_instruction_model.dart';
import '../../../models/transaction_model.dart';

import '../../../providers/registration_provider.dart';
import '../../../services/event_service.dart';
import '../../../services/payment_service.dart';
import '../../../services/registration_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import '../../../shared/widgets/image_carousel.dart';
import '../../../shared/widgets/professional_loading_overlay.dart';
import '../../registrations/presentation/registration_detail_screen.dart';
import '../../registrations/presentation/my_registrations_screen.dart';
import '../../registrations/widgets/payment_gateway_selector.dart';
import '../../registrations/widgets/payment_input_dialog.dart';
import '../../speakers/presentation/speaker_details_screen.dart';
import '../../gamification/presentation/screens/live_interaction_screen.dart';

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

class EventDetailsScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> with WidgetsBindingObserver {
  bool _isProcessingRegistration = false;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Optional: Refresh only if needed, or leave it to manual refresh
       // ref.invalidate(eventRegistrationStatusProvider(widget.eventId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final eventAsync = ref.watch(eventDetailsProvider(widget.eventId));
    final speakersAsync = ref.watch(eventSpeakersProvider(widget.eventId));
    final registrationStatusAsync = ref.watch(eventRegistrationStatusProvider(widget.eventId));
    final authState = ref.watch(authProvider);

    return ProfessionalLoadingOverlay(
      isLoading: _isProcessingRegistration || _isProcessingPayment,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: eventAsync.when(
          data: (event) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventDetailsProvider(widget.eventId));
              ref.invalidate(eventSpeakersProvider(widget.eventId));
              ref.invalidate(eventRegistrationStatusProvider(widget.eventId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Hero Image Section
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image carousel or placeholder
                        event.promotionalImages != null && event.promotionalImages!.isNotEmpty
                            ? ImageCarousel(
                                images: event.promotionalImages!,
                                height: 320,
                                fit: BoxFit.cover,
                                showIndicators: true,
                                autoPlay: event.promotionalImages!.length > 1,
                                autoPlayInterval: const Duration(seconds: 4),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.event_rounded,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content Section
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type Badge
                          if (event.type.isNotEmpty) ...[
                            _buildTypeBadge(event),
                            const SizedBox(height: 16),
                          ],
                          // Title
                          if (event.title.isNotEmpty) ...[
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Quick Info Section
                          _buildQuickInfoSection(event),
                          const SizedBox(height: 24),
                          
                          // Live Interaction
                          if (event.isOngoing && _hasValidRegistration(registrationStatusAsync.value)) ...[
                             _buildLiveInteractionCard(context, event),
                             const SizedBox(height: 24),
                          ],
                          // Description
                          if (_hasContent(event.description)) ...[
                            _buildSection(
                              title: l10n.courseDescription,
                              icon: Icons.description_outlined,
                              content: event.description!,
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Course Details
                          if (_hasContent(event.courseDetails)) ...[
                            _buildSection(
                              title: l10n.courseDetails,
                              icon: Icons.info_outline_rounded,
                              content: event.courseDetails!,
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Requirements
                          if (_hasContent(event.requirements)) ...[
                            _buildSection(
                              title: l10n.requirements,
                              icon: Icons.checklist_rtl_outlined,
                              content: event.requirements!,
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Category
                          if (event.category != null && event.category!.isNotEmpty) ...[
                            _buildInfoRow(
                              icon: Icons.category_outlined,
                              label: 'الفئة',
                              value: event.category!,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Certificate Badge
                          if (event.certificate == true) ...[
                            _buildCertificateBadge(),
                            const SizedBox(height: 24),
                          ],
                          // Speakers/Instructors Section
                          speakersAsync.when(
                            data: (speakers) {
                              if (speakers.isEmpty) return const SizedBox.shrink();
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: _buildSectionHeader(
                                      title: 'المتحدثون والمدربون',
                                      icon: Icons.people_outline_rounded,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (speakers.length == 1)
                                    _buildInstructorCard(speakers[0])
                                  else
                                    _buildSpeakersList(speakers),
                                  const SizedBox(height: 24),
                                ],
                              );
                            },
                            loading: () => const Center(child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            )),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          // Bottom padding for fixed bottom bar
                          const SizedBox(height: 100),
                        ],
                      ),
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
              title: Text(l10n.courseDetails),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الدورة',
                    style: TextStyle(fontSize: 18, color: AppColors.error),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(eventDetailsProvider(widget.eventId)),
                    icon: Icon(Icons.refresh),
                    label: Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Fixed Bottom Bar with Registration Button
        bottomNavigationBar: eventAsync.when(
          data: (event) => _buildBottomActionBar(event, registrationStatusAsync, authState),
          loading: () => _buildLoadingBottomBar(authState),
          error: (_, __) => _buildErrorBottomBar(authState),
        ),
      ),
    );
  }

  // Check if user is authenticated
  bool _isUserAuthenticated(AuthState authState) {
    return authState.isAuthenticated;
  }

  // Loading Bottom Bar
  Widget? _buildLoadingBottomBar(AuthState authState) {
    // Show loading bar only if event status allows
    final eventAsync = ref.watch(eventDetailsProvider(widget.eventId));
    return eventAsync.when(
      data: (event) {
        final canShowBar = event.status == 'REGISTRATION_OPEN' || event.status == 'ONGOING';
        if (!canShowBar) return null;
        return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'جاري التحميل...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  // Error Bottom Bar
  Widget? _buildErrorBottomBar(AuthState authState) {
    // Show error bar only if event status allows
    final eventAsync = ref.watch(eventDetailsProvider(widget.eventId));
    return eventAsync.when(
      data: (event) {
        final canShowBar = event.status == 'REGISTRATION_OPEN' || event.status == 'ONGOING';
        if (!canShowBar) return null;
        return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'حدث خطأ في تحميل البيانات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
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
      loading: () => null,
      error: (_, __) => null,
    );
  }

  // Bottom Action Bar - Fixed at bottom
  Widget? _buildBottomActionBar(
    EventModel event,
    AsyncValue<Map<String, dynamic>?> registrationStatusAsync,
    AuthState authState,
  ) {
    // Show bottom bar only if event status is REGISTRATION_OPEN or ONGOING
    final canShowBar = event.status == 'REGISTRATION_OPEN' || event.status == 'ONGOING';
    if (!canShowBar) {
      return null;
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        child: registrationStatusAsync.when(
          data: (registrationStatus) {
            // If already registered, show status
            if (registrationStatus != null && registrationStatus['id'] != null) {
              final status = (registrationStatus['status'] as String? ?? 'UNDER_REVIEW').toUpperCase().trim();
              final statusInfo = _getRegistrationStatusInfo(status);
              
              return SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (status == 'PAYMENT_PENDING') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyRegistrationsScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationDetailScreen(
                            registrationId: registrationStatus['id'] as String,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(statusInfo['icon'] as IconData, size: 24),
                  label: Text(
                    statusInfo['text'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusInfo['color'] as Color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            }

            // Show price and register button (always shown if bar is visible)
            return Row(
              children: [
                // Price Display
                if (event.price != null) ...[
                  _buildBottomPriceDisplay(event),
                  const SizedBox(width: 12),
                ],
                // Registration Button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessingRegistration
                          ? null
                          : () => _handleRegistration(context, event),
                      icon: _isProcessingRegistration
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(Icons.add_circle_outline, size: 24),
                      label: Text(
                        _isProcessingRegistration ? 'جاري التسجيل...' : 'اشترك الآن',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () {
            return Row(
              children: [
                if (event.price != null) ...[
                  _buildBottomPriceDisplay(event),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'جاري التحميل...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            // On error, still try to show button
            return Row(
              children: [
                if (event.price != null) ...[
                  _buildBottomPriceDisplay(event),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleRegistration(context, event),
                      icon: Icon(Icons.add_circle_outline, size: 24),
                      label: Text(
                        'اشترك الآن',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Bottom Price Display Widget
  Widget _buildBottomPriceDisplay(EventModel event) {
    final isFree = event.price == null || event.price! <= 0;
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFree
              ? [
                  AppColors.success.withOpacity(0.15),
                  AppColors.success.withOpacity(0.08),
                ]
              : [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFree ? AppColors.success.withOpacity(0.3) : AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFree ? Icons.check_circle_rounded : Icons.payments_rounded,
            color: isFree ? AppColors.success : AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isFree
                  ? 'مجاناً'
                  : '${event.price!.toStringAsFixed(0)} ${event.currency ?? 'ريال'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isFree ? AppColors.success : AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasContent(String? content) {
    return content != null && content.trim().isNotEmpty;
  }

  Widget _buildTypeBadge(EventModel event) {
    final color = _getTypeColor(event.type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(event.type), size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            event.typeLabel,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasValidRegistration(Map<String, dynamic>? status) {
      if (status == null) return false;
      final s = (status['status'] as String? ?? '').toUpperCase();
      return ['APPROVED', 'CONFIRMED', 'COMPLETED', 'PAID'].contains(s);
  }

  Widget _buildLiveInteractionCard(BuildContext context, EventModel event) {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.deepPurple]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                  BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))
              ]
          ),
          child: Column(
              children: [
                   const Icon(Icons.live_tv, color: Colors.white, size: 32),
                   const SizedBox(height: 8),
                   const Text(
                       'Live Interaction Active',
                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                   ),
                   const Text(
                       'Join Q&A and Polls now!',
                       style: TextStyle(color: Colors.white70),
                   ),
                   const SizedBox(height: 16),
                   ElevatedButton(
                       onPressed: () {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                   builder: (context) => LiveInteractionScreen(
                                       sessionId: event.id,
                                       sessionTitle: event.title,
                                   )
                               )
                           );
                       },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.white,
                           foregroundColor: Colors.purple,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                       ),
                       child: const Text('Join Session'),
                   )
              ],
          ),
      );
  }

  Widget _buildQuickInfoSection(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'التاريخ',
            value: DateFormat('EEEE، d MMMM yyyy', 'ar').format(event.localStartTime),
            color: AppColors.info,
          ),
          Divider(height: 24),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'الوقت',
            value: event.formattedTime,
            color: AppColors.primary,
          ),
          if (_hasContent(event.location)) ...[
            Divider(height: 24),
            _buildInfoRow(
              icon: Icons.location_on_rounded,
              label: 'المكان',
              value: event.location!,
              color: AppColors.error,
            ),
          ],
          if (event.duration != null && event.duration! > 0) ...[
            Divider(height: 24),
            _buildInfoRow(
              icon: Icons.timer_outlined,
              label: 'المدة',
              value: '${event.duration!.toStringAsFixed(1)} ساعة تعليمية',
              color: AppColors.warning,
            ),
          ],
          if (event.courseLevel != null &&
              event.courseLevel!.isNotEmpty &&
              event.courseLevel != 'NOT_SPECIFIED') ...[
            Divider(height: 24),
            _buildInfoRow(
              icon: Icons.school_outlined,
              label: 'المستوى',
              value: _getCourseLevelLabel(event.courseLevel!),
              color: AppColors.success,
            ),
          ],
          if (event.capacity != null && event.capacity! > 0) ...[
            Divider(height: 24),
            _buildInfoRow(
              icon: Icons.people_outline,
              label: 'السعة',
              value: '${event.capacity} شخص',
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: title, icon: icon),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: context.colors.textSecondary,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.15),
            AppColors.success.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, color: AppColors.success, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'شهادة معتمدة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Instructor Card Widget
  Widget _buildInstructorCard(Map<String, dynamic> speakerData) {
    final speaker = speakerData['speaker'] as Map<String, dynamic>?;
    if (speaker == null) return const SizedBox.shrink();
    
    final name = speaker['name'] as String? ?? '';
    final title = speaker['title'] as String? ?? '';
    final photoUrl = speaker['photoUrl'] as String?;
    final speakerId = speaker['id'] as String?;
    
    return GestureDetector(
      onTap: speakerId != null ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakerDetailsScreen(speakerId: speakerId),
          ),
        );
      } : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Instructor Photo
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? AuthenticatedImageWidget(
                        imageUrl: photoUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.2),
                              AppColors.primary.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 45,
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 20),
            // Instructor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Label
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'المدرب',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Instructor Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Instructor Title/Position
                  if (title.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: context.colors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakersList(List<Map<String, dynamic>> speakers) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: speakers.length,
        itemBuilder: (context, index) {
          final speakerData = speakers[index]['speaker'] as Map<String, dynamic>?;
          if (speakerData == null) return const SizedBox.shrink();
          
          return Container(
            width: 100,
            margin: const EdgeInsets.only(left: 12),
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
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: speakerData['photoUrl'] != null
                          ? AuthenticatedImageWidget(
                              imageUrl: speakerData['photoUrl'] as String,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: context.colors.surfaceVariant,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: context.colors.textSecondary,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  speakerData['name'] as String? ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
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

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'COURSE':
        return Icons.school_outlined;
      case 'WORKSHOP':
        return Icons.build_outlined;
      case 'SEMINAR':
        return Icons.forum_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  String _getCourseLevelLabel(String level) {
    switch (level) {
      case 'BEGINNER':
        return 'مبتدئ';
      case 'INTERMEDIATE':
        return 'متوسط';
      case 'ADVANCED':
        return 'متقدم';
      default:
        return level;
    }
  }

  Map<String, dynamic> _getRegistrationStatusInfo(String status) {
    switch (status) {
      case 'UNDER_REVIEW':
        return {
          'text': 'قيد المراجعة',
          'icon': Icons.hourglass_empty_rounded,
          'color': Colors.orange,
        };
      case 'ACCEPTED':
        return {
          'text': 'تم القبول',
          'icon': Icons.check_circle_rounded,
          'color': AppColors.success,
        };
      case 'PAYMENT_PENDING':
        return {
          'text': 'بإنتظار الدفع',
          'icon': Icons.payment_rounded,
          'color': Colors.blue,
        };
      case 'ACTIVE_PARTICIPANT':
        return {
          'text': 'مشترك',
          'icon': Icons.check_circle_rounded,
          'color': AppColors.success,
        };
      case 'REJECTED':
        return {
          'text': 'تم الرفض',
          'icon': Icons.cancel_rounded,
          'color': AppColors.error,
        };
      case 'ON_HOLD':
        return {
          'text': 'معلق',
          'icon': Icons.pause_circle_rounded,
          'color': AppColors.warning,
        };
      default:
        return {
          'text': 'حالة غير معروفة',
          'icon': Icons.help_outline_rounded,
          'color': AppColors.textSecondary,
        };
    }
  }

  Future<void> _handleRegistration(BuildContext context, EventModel event) async {
    if (!mounted) return;

    setState(() {
      _isProcessingRegistration = true;
    });

    try {
      final registrationService = RegistrationService();
      final registration = await registrationService.registerToEvent(eventId: event.id);

      if (!mounted) return;

      // Refresh registration status
      ref.invalidate(eventRegistrationStatusProvider(event.id));

      // Check if payment is required
      if (registration.status == 'PAYMENT_PENDING') {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyRegistrationsScreen(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تم التسجيل في الدورة بنجاح',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'فشل في التسجيل';
      if (e is Exception) {
        final errorStr = e.toString();
        errorMessage = errorStr.startsWith('Exception: ') 
            ? errorStr.substring(11) 
            : errorStr;
      } else {
        errorMessage = e.toString();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
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
      final invoice = await paymentService.getInvoiceByRegistrationId(registrationId);
      final gateways = await paymentService.getActiveGateways();

      if (gateways.isEmpty) {
        if (mounted && context.mounted) {
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

      final selectedGateway = await PaymentGatewaySelector.show(context, gateways);
      if (selectedGateway == null) return;

      final initiateResult = await paymentService.initiatePayment(
        invoiceId: invoice.id,
        gatewayId: selectedGateway.id,
      );

      final transaction = initiateResult['transaction'] as TransactionModel;
      final instruction = initiateResult['paymentInstruction'] as PaymentInstructionModel;

      final inputResult = await PaymentInputDialog.show(
        context,
        instruction,
        selectedGateway.displayName,
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
          if (mounted && context.mounted) {
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

      final confirmedTransaction = await paymentService.confirmPayment(
        transactionId: transaction.id,
        inputData: mutableInputData,
      );

      if (!mounted) return;

      if (confirmedTransaction.isSuccessful) {
        ref.invalidate(eventRegistrationStatusProvider(widget.eventId));
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationDetailScreen(
                registrationId: registrationId,
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
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
      }
    } catch (e) {
      if (!mounted) return;
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
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
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}