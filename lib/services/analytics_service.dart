import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/auth_models.dart';
import '../models/user_model.dart';

/// Centralizes Google Analytics (Firebase Analytics) interactions.
class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService instance = AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;

  /// Ensures Firebase Analytics is ready before use.
  Future<void> ensureInitialized() async {
    try {
      _analytics ??= FirebaseAnalytics.instance;
      _observer ??= FirebaseAnalyticsObserver(analytics: _analytics!);

      // Disable analytics in debug builds to keep production metrics clean.
      const shouldCollect = !kDebugMode;
      await _analytics?.setAnalyticsCollectionEnabled(shouldCollect);

      debugPrint(
        '📊 [Analytics] Initialized. Collection enabled: $shouldCollect',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [Analytics] Initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Navigator observers for automatic screen tracking.
  List<NavigatorObserver> get navigatorObservers {
    if (_observer == null && _analytics != null) {
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
    }
    return _observer != null ? [_observer!] : const [];
  }

  /// Logs a generic analytics event.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
      debugPrint('📊 [Analytics] Event logged: $name => $parameters');
    } catch (e, stackTrace) {
      debugPrint('❌ [Analytics] Failed to log event $name: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Logs application start.
  Future<void> logAppStart() async {
    await logEvent('app_start', parameters: {
      'timestamp': DateTime.now().toIso8601String(),
      'platform': defaultTargetPlatform.name,
    });
  }

  /// Logs user sign-in or sign-out transitions.
  Future<void> handleAuthStateChange(
    AuthState? previous,
    AuthState next,
  ) async {
    await next.maybeWhen(
      authenticated: (user) async {
        await _setUserIdentity(user);
        await logEvent('login_success', parameters: {
          'user_id': user.id,
          'phone_verified': user.phoneVerified,
          'roles': user.roles.join(','),
        });
      },
      unauthenticated: () async {
        await _clearUserIdentity();
        await logEvent('logout', parameters: {
          'reason': previous?.maybeWhen(
                error: (message) => message,
                orElse: () => 'user_action',
              ) ??
              'user_action',
        });
      },
      error: (message) async {
        await logEvent('auth_error', parameters: {'message': message});
      },
      orElse: () async {},
    );
  }

  Future<void> _setUserIdentity(UserModel user) async {
    try {
      await _analytics?.setUserId(id: user.id);
      await _analytics?.setUserProperty(
        name: 'phone_verified',
        value: user.phoneVerified ? 'true' : 'false',
      );
      if (user.roles.isNotEmpty) {
        await _analytics?.setUserProperty(
          name: 'roles',
          value: user.roles.join(','),
        );
      }
      if (user.phone.isNotEmpty) {
        await _analytics?.setUserProperty(
          name: 'phone',
          value: user.phone,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [Analytics] Failed to set user identity: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _clearUserIdentity() async {
    try {
      await _analytics?.setUserId(id: null);
      await _analytics?.setUserProperty(name: 'phone', value: null);
      await _analytics?.setUserProperty(name: 'roles', value: null);
      await _analytics?.setUserProperty(name: 'phone_verified', value: null);
    } catch (e, stackTrace) {
      debugPrint('❌ [Analytics] Failed to clear user identity: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}

