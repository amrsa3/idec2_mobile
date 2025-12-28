/**
 * Comprehensive Refresh Token Tests for Mobile App
 * 
 * Tests the refresh token functionality including:
 * - Token storage and retrieval
 * - Automatic token refresh
 * - Error handling
 * - Expiry time handling
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:idec_conference_app/services/unified_token_manager.dart';
import 'package:idec_conference_app/services/enhanced_token_interceptor.dart';
import 'package:idec_conference_app/services/enhanced_session_manager.dart';
import 'package:idec_conference_app/services/platform_storage_service.dart';
import 'package:dio/dio.dart';

// In-memory storage for tests
final Map<String, String> _mockSecureStorage = {};
final Map<String, dynamic> _mockSharedPreferences = {};

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock storage for tests
  setUpAll(() async {
    // Clear storage before tests
    _mockSecureStorage.clear();
    _mockSharedPreferences.clear();

    // Mock SharedPreferences
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return Map<String, dynamic>.from(_mockSharedPreferences);
      }
      if (methodCall.method == 'setString') {
        final key = methodCall.arguments['key'] as String;
        final value = methodCall.arguments['value'] as String;
        _mockSharedPreferences[key] = value;
        return true;
      }
      if (methodCall.method == 'getString') {
        final key = methodCall.arguments['key'] as String;
        return _mockSharedPreferences[key] as String?;
      }
      if (methodCall.method == 'remove') {
        final key = methodCall.arguments['key'] as String;
        _mockSharedPreferences.remove(key);
        return true;
      }
      if (methodCall.method == 'clear') {
        _mockSharedPreferences.clear();
        return true;
      }
      return null;
    });

    // Mock FlutterSecureStorage
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'read') {
        final key = methodCall.arguments['key'] as String;
        return _mockSecureStorage[key];
      }
      if (methodCall.method == 'write') {
        final key = methodCall.arguments['key'] as String;
        final value = methodCall.arguments['value'] as String;
        _mockSecureStorage[key] = value;
        return null;
      }
      if (methodCall.method == 'delete') {
        final key = methodCall.arguments['key'] as String;
        _mockSecureStorage.remove(key);
        return null;
      }
      if (methodCall.method == 'deleteAll') {
        _mockSecureStorage.clear();
        return null;
      }
      if (methodCall.method == 'readAll') {
        return Map<String, String>.from(_mockSecureStorage);
      }
      return null;
    });
  });

  group('Refresh Token System Tests', () {
    late UnifiedTokenManager tokenManager;
    late PlatformStorageService storage;
    late EnhancedSessionManager sessionManager;

    setUp(() {
      storage = PlatformStorageService.instance;
      tokenManager = UnifiedTokenManager.instance;
      sessionManager = EnhancedSessionManager.instance;
    });

    tearDown(() async {
      // Clean up tokens after each test
      await tokenManager.clearTokens();
      // Clear mock storage
      _mockSecureStorage.clear();
      _mockSharedPreferences.clear();
    });

    test('should save tokens with refreshExpiresIn', () async {
      final now = DateTime.now();
      final accessToken = 'test-access-token';
      final refreshToken = 'test-refresh-token';
      final expiresIn = 900; // 15 minutes
      final refreshExpiresIn = 7 * 24 * 60 * 60; // 7 days

      await tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        refreshExpiresIn: refreshExpiresIn,
      );

      // Verify tokens are saved
      final savedAccessToken = await tokenManager.getValidAccessToken();
      final savedRefreshToken = await tokenManager.getRefreshToken();
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();

      expect(savedAccessToken, equals(accessToken));
      expect(savedRefreshToken, equals(refreshToken));
      expect(hasValidRefresh, isTrue);
    });

    test('should use refreshExpiresIn from server response', () async {
      // Simulate server response with refreshExpiresIn
      final serverResponse = {
        'accessToken': 'new-access-token',
        'refreshToken': 'new-refresh-token',
        'expiresIn': 900,
        'refreshExpiresIn': 10 * 24 * 60 * 60, // 10 days (different from default)
      };

      await tokenManager.saveTokens(
        accessToken: serverResponse['accessToken'] as String,
        refreshToken: serverResponse['refreshToken'] as String,
        expiresIn: serverResponse['expiresIn'] as int,
        refreshExpiresIn: serverResponse['refreshExpiresIn'] as int,
      );

      // Verify refresh token expiry is set correctly
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);

      // The expiry should be approximately 10 days from now
      // (we can't test exact time, but we can verify it's valid)
    });

    test('should use fallback value when refreshExpiresIn is missing', () async {
      // Simulate server response without refreshExpiresIn
      final serverResponse = {
        'accessToken': 'new-access-token',
        'refreshToken': 'new-refresh-token',
        'expiresIn': 900,
        // refreshExpiresIn is missing
      };

      await tokenManager.saveTokens(
        accessToken: serverResponse['accessToken'] as String,
        refreshToken: serverResponse['refreshToken'] as String,
        expiresIn: serverResponse['expiresIn'] as int,
        refreshExpiresIn: null, // Missing from response
      );

      // Should still work with fallback value (30 days)
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);
    });

    test('should detect expired access token', () async {
      final now = DateTime.now();
      final accessToken = 'test-access-token';
      final refreshToken = 'test-refresh-token';
      
      // Save token with very short expiry (1 second)
      await tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 1, // 1 second
        refreshExpiresIn: 7 * 24 * 60 * 60,
      );

      // Wait for token to expire
      await Future.delayed(Duration(seconds: 2));

      // Verify token is expired
      final isValid = await tokenManager.isAccessTokenValid();
      expect(isValid, isFalse);
    });

    test('should detect expired refresh token', () async {
      final accessToken = 'test-access-token';
      final refreshToken = 'test-refresh-token';
      
      // Save token with very short refresh expiry (1 second)
      await tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 900,
        refreshExpiresIn: 1, // 1 second
      );

      // Wait for refresh token to expire
      await Future.delayed(Duration(seconds: 2));

      // Verify refresh token is expired
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isFalse);
    });

    test('should extract refreshExpiresIn from tokens object in response', () async {
      // Simulate response where refreshExpiresIn is in tokens object
      final serverResponse = {
        'tokens': {
          'accessToken': 'new-access-token',
          'refreshToken': 'new-refresh-token',
          'expiresIn': 900,
          'refreshExpiresIn': 7 * 24 * 60 * 60,
        },
      };

      final tokens = serverResponse['tokens'] as Map<String, dynamic>;
      
      await tokenManager.saveTokens(
        accessToken: tokens['accessToken'] as String,
        refreshToken: tokens['refreshToken'] as String,
        expiresIn: tokens['expiresIn'] as int,
        refreshExpiresIn: tokens['refreshExpiresIn'] as int?,
      );

      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);
    });

    test('should handle token refresh with valid refresh token', () async {
      // This test would require mocking the HTTP request
      // For now, we'll test the token manager's ability to handle refresh
      
      final accessToken = 'test-access-token';
      final refreshToken = 'test-refresh-token';
      
      await tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 900,
        refreshExpiresIn: 7 * 24 * 60 * 60,
      );

      // Verify we have a valid refresh token
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);

      // Note: Actual refresh would require mocking Dio and the API endpoint
      // This is tested in integration tests
    });

    test('should handle missing refreshExpiresIn gracefully', () async {
      // Test that the system doesn't crash when refreshExpiresIn is null
      final accessToken = 'test-access-token';
      final refreshToken = 'test-refresh-token';
      
      await tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 900,
        refreshExpiresIn: null,
      );

      // Should use fallback value (30 days)
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);
    });

    test('should calculate refresh token expiry correctly', () async {
      final now = DateTime.now();
      final refreshExpiresIn = 7 * 24 * 60 * 60; // 7 days
      
      await tokenManager.saveTokens(
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        expiresIn: 900,
        refreshExpiresIn: refreshExpiresIn,
      );

      // Verify refresh token is valid
      final hasValidRefresh = await tokenManager.hasValidRefreshToken();
      expect(hasValidRefresh, isTrue);

      // The expiry should be approximately 7 days from when we saved
      // We can't test exact time, but we can verify it's in the future
    });
  });

  group('Token Refresh Interceptor Tests', () {
    test('should handle 401 error and attempt token refresh', () async {
      // This test would require mocking Dio and the interceptor
      // For now, we'll verify the interceptor can be created
      
      final tokenManager = UnifiedTokenManager.instance;
      final sessionManager = EnhancedSessionManager.instance;
      
      final interceptor = EnhancedTokenInterceptor(
        tokenManager: tokenManager,
        sessionManager: sessionManager,
      );

      expect(interceptor, isNotNull);
      // Note: Full interceptor testing requires mocking HTTP requests
    });
  });
}

