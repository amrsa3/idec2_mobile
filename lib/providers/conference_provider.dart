import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conference_model.dart';
import '../models/registration_status_model.dart';
import '../services/conference_service.dart';

final conferenceServiceProvider = Provider<ConferenceService>((ref) {
  return ConferenceService();
});

/// Provider for active conference with refresh capability
final activeConferenceProvider = FutureProvider.autoDispose<ConferenceModel?>((ref) async {
  final service = ref.read(conferenceServiceProvider);
  
  // Force refresh on first load to ensure fresh data
  // This helps prevent showing cached data from previous user
  try {
    return await service.getActiveConference();
  } catch (e) {
    // Log error but don't throw to prevent UI crashes
    debugPrint('❌ [CONFERENCE_PROVIDER] Error loading active conference: $e');
    return null;
  }
});

/// Provider for conference registration status with refresh capability
final conferenceRegistrationProvider =
    FutureProvider.autoDispose.family<RegistrationStatusModel?, String>(
        (ref, conferenceId) async {
  final service = ref.read(conferenceServiceProvider);
  
  // Force refresh on first load to ensure fresh data
  try {
    return await service.getMyRegistration(conferenceId);
  } catch (e) {
    // Log error but don't throw to prevent UI crashes
    debugPrint('❌ [CONFERENCE_PROVIDER] Error loading registration for $conferenceId: $e');
    return null;
  }
});

/// Helper function to refresh active conference
Future<void> refreshActiveConference(WidgetRef ref) async {
  ref.invalidate(activeConferenceProvider);
}

/// Helper function to refresh conference registration
Future<void> refreshConferenceRegistration(WidgetRef ref, String conferenceId) async {
  ref.invalidate(conferenceRegistrationProvider(conferenceId));
}
