import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/push/push_models.dart';
import '../../../services/push_api_service.dart';

final pushTokenProvider = StateProvider<String?>((ref) => null);

class PushTopicsState {
  final bool loading;
  final bool saving;
  final String? error;
  final List<FcmTopicOption> availableTopics;
  final Set<String> subscribedTopics;
  final String? broadcastTopic;

  const PushTopicsState({
    this.loading = false,
    this.saving = false,
    this.error,
    this.availableTopics = const [],
    this.subscribedTopics = const {},
    this.broadcastTopic,
  });

  PushTopicsState copyWith({
    bool? loading,
    bool? saving,
    String? error,
    List<FcmTopicOption>? availableTopics,
    Set<String>? subscribedTopics,
    String? broadcastTopic,
  }) {
    return PushTopicsState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: error,
      availableTopics: availableTopics ?? this.availableTopics,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      broadcastTopic: broadcastTopic ?? this.broadcastTopic,
    );
  }
}

class PushTopicsNotifier extends StateNotifier<PushTopicsState> {
  PushTopicsNotifier(this._ref) : super(const PushTopicsState());

  final Ref _ref;
  final PushApiService _apiService = PushApiService.instance;

  Future<void> syncWithServer(String token) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final topicsResponse = await _apiService.getAvailableTopics();
      final device = await _apiService.getDeviceToken(token);
      final subscribed = device?.topics
              .where((topic) => topic.unsubscribedAt == null)
              .map((topic) => topic.topic)
              .toSet() ??
          <String>{};

      state = state.copyWith(
        loading: false,
        availableTopics: topicsResponse.optionalTopics,
        subscribedTopics: subscribed,
        broadcastTopic: topicsResponse.broadcast,
      );
    } catch (error) {
      debugPrint('❌ [FCM] Failed to sync topics: $error');
      state = state.copyWith(
        loading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> refreshFromServer() async {
    final token = _ref.read(pushTokenProvider);
    if (token == null || token.isEmpty) return;
    await syncWithServer(token);
  }

  Future<void> toggleTopic(String topicKey, bool enabled) async {
    final token = _ref.read(pushTokenProvider);
    if (token == null || token.isEmpty) return;

    state = state.copyWith(saving: true, error: null);
    try {
      if (enabled) {
        await _apiService.subscribeTopics(token: token, topics: [topicKey]);
        final updated = Set<String>.from(state.subscribedTopics)..add(topicKey);
        state = state.copyWith(saving: false, subscribedTopics: updated);
      } else {
        await _apiService.unsubscribeTopics(token: token, topics: [topicKey]);
        final updated = Set<String>.from(state.subscribedTopics)
          ..remove(topicKey);
        state = state.copyWith(saving: false, subscribedTopics: updated);
      }
    } catch (error) {
      debugPrint('❌ [FCM] Failed to toggle topic $topicKey: $error');
      state = state.copyWith(saving: false, error: error.toString());
    }
  }

  void clearLocal() {
    state = const PushTopicsState();
  }
}

final pushTopicsProvider =
    StateNotifierProvider<PushTopicsNotifier, PushTopicsState>((ref) {
  return PushTopicsNotifier(ref);
});
