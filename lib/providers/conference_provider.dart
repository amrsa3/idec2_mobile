import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/conference_model.dart';
import '../models/registration_status_model.dart';
import '../services/conference_service.dart';

final conferenceServiceProvider = Provider<ConferenceService>((ref) {
  return ConferenceService();
});

final activeConferenceProvider = FutureProvider<ConferenceModel?>((ref) async {
  final service = ref.read(conferenceServiceProvider);
  return await service.getActiveConference();
});

final conferenceRegistrationProvider =
    FutureProvider.family<RegistrationStatusModel?, String>(
        (ref, conferenceId) async {
  final service = ref.read(conferenceServiceProvider);
  return await service.getMyRegistration(conferenceId);
});
