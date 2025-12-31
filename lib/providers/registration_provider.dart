import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/registration_service.dart';

// RegistrationNotifier and related providers are commented out
// because they depend on services that are not available.
// Only eventRegistrationStatusProvider is kept as it's needed for event registration.

/// Provider for event registration status
final eventRegistrationStatusProvider = FutureProvider.autoDispose.family<Map<String, dynamic>?, String>(
  (ref, eventId) async {
    final registrationService = RegistrationService();
    try {
      debugPrint('🔵 [EVENT_REGISTRATION_PROVIDER] Loading registration for event: $eventId');
      final result = await registrationService.getEventRegistrationStatus(eventId);
      debugPrint('🔵 [EVENT_REGISTRATION_PROVIDER] Registration result: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ [EVENT_REGISTRATION_PROVIDER] Error loading registration for event $eventId: $e');
      debugPrint('❌ [EVENT_REGISTRATION_PROVIDER] Stack trace: $stackTrace');
      // Don't return null on error - let the error propagate so UI can handle it
      rethrow;
    }
  },
);

/// Helper function to refresh event registration
Future<void> refreshEventRegistration(WidgetRef ref, String eventId) async {
  ref.invalidate(eventRegistrationStatusProvider(eventId));
}