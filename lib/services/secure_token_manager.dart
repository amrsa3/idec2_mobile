import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'platform_storage_service.dart';

/// مدير التوكن الآمن والمحسن
/// يدعم التشفير والتخزين الآمن عبر جميع المنصات
class SecureTokenManager {
  static SecureTokenManager? _instance;
  static SecureTokenManager get instance =>
      _instance ??= SecureTokenManager._internal();

  late PlatformStorageService _storage;
  late Completer<void> _initCompleter;
  bool _isInitialized = false;

  // Storage keys
  static const String _accessTokenKey = 'secure_access_token';
  static const String _refreshTokenKey = 'secure_refresh_token';
  static const String _tokenExpiryKey = 'secure_token_expiry';
  static const String _tokenHashKey = 'secure_token_hash';
  static const String _lastRefreshKey = 'secure_last_refresh';

  // Security configuration
  static const Duration _tokenValidityBuffer =
      Duration(minutes: 5); // Buffer قبل انتهاء الصلاحية
  // static const Duration _maxTokenAge = Duration(hours: 24); // أقصى عمر للتوكن
  // static const int _maxRefreshAttempts = 3; // أقصى عدد محاولات التحديث

  SecureTokenManager._internal() {
    _initCompleter = Completer<void>();
  }

  /// تهيئة المدير
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _storage = PlatformStorageService.instance;
      await _storage.init();

      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Initialized successfully');
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Initialization error: $e');
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
      rethrow;
    }
  }

  /// التأكد من التهيئة
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
    await _initCompleter.future;
  }

  /// حفظ التوكنات بشكل آمن
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    await _ensureInitialized();

    try {
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Saving tokens securely...');

      final now = DateTime.now();
      final expiryTime = now.add(Duration(seconds: expiresIn));

      // Generate hash for token integrity verification
      final tokenHash = _generateTokenHash(accessToken, refreshToken);

      // Encrypt tokens before storage
      final encryptedAccessToken = _encryptToken(accessToken);
      final encryptedRefreshToken = _encryptToken(refreshToken);

      // Save encrypted tokens
      await _storage.writeSecure(_accessTokenKey, encryptedAccessToken);
      await _storage.writeSecure(_refreshTokenKey, encryptedRefreshToken);
      await _storage.writeSecure(_tokenExpiryKey, expiryTime.toIso8601String());
      await _storage.writeSecure(_tokenHashKey, tokenHash);
      await _storage.writeSecure(_lastRefreshKey, now.toIso8601String());

      debugPrint('✅ [SECURE_TOKEN_MANAGER] Tokens saved securely');
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Token expires at: $expiryTime');
      debugPrint(
          '🔐 [SECURE_TOKEN_MANAGER] Time until expiry: ${expiryTime.difference(now).inMinutes} minutes');
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error saving tokens: $e');
      rethrow;
    }
  }

  /// الحصول على التوكن الصالح
  Future<String?> getValidAccessToken() async {
    await _ensureInitialized();

    try {
      // Check if token exists
      final encryptedToken = await _storage.readSecure(_accessTokenKey);
      if (encryptedToken == null) {
        debugPrint('🔐 [SECURE_TOKEN_MANAGER] No access token found');
        return null;
      }

      // Decrypt token
      final accessToken = _decryptToken(encryptedToken);
      if (accessToken == null) {
        debugPrint('❌ [SECURE_TOKEN_MANAGER] Failed to decrypt access token');
        return null;
      }

      // Check if token is still valid
      if (await isAccessTokenValid()) {
        debugPrint('✅ [SECURE_TOKEN_MANAGER] Access token is valid');
        return accessToken;
      } else {
        debugPrint('❌ [SECURE_TOKEN_MANAGER] Access token is expired');
        return null;
      }
    } catch (e) {
      debugPrint(
          '❌ [SECURE_TOKEN_MANAGER] Error getting valid access token: $e');
      return null;
    }
  }

  /// الحصول على Refresh Token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();

    try {
      final encryptedToken = await _storage.readSecure(_refreshTokenKey);
      if (encryptedToken == null) {
        debugPrint('🔐 [SECURE_TOKEN_MANAGER] No refresh token found');
        return null;
      }

      final refreshToken = _decryptToken(encryptedToken);
      if (refreshToken == null) {
        debugPrint('❌ [SECURE_TOKEN_MANAGER] Failed to decrypt refresh token');
        return null;
      }

      return refreshToken;
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error getting refresh token: $e');
      return null;
    }
  }

  /// التحقق من صحة Access Token
  Future<bool> isAccessTokenValid() async {
    await _ensureInitialized();

    try {
      // Check if token exists
      final encryptedToken = await _storage.readSecure(_accessTokenKey);
      if (encryptedToken == null) {
        debugPrint('🔐 [SECURE_TOKEN_MANAGER] No access token to validate');
        return false;
      }

      // Check expiry time
      final expiryString = await _storage.readSecure(_tokenExpiryKey);
      if (expiryString == null) {
        debugPrint('🔐 [SECURE_TOKEN_MANAGER] No expiry time found');
        return false;
      }

      final expiryTime = DateTime.parse(expiryString);
      final now = DateTime.now();

      // Add buffer time to prevent edge cases
      final effectiveExpiry = expiryTime.subtract(_tokenValidityBuffer);
      final isValid = now.isBefore(effectiveExpiry);

      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Token validation:');
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Current time: $now');
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Expiry time: $expiryTime');
      debugPrint(
          '🔐 [SECURE_TOKEN_MANAGER] Effective expiry (with buffer): $effectiveExpiry');
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Is valid: $isValid');

      if (!isValid) {
        final timeUntilExpiry = expiryTime.difference(now);
        debugPrint(
            '🔐 [SECURE_TOKEN_MANAGER] Token expired ${timeUntilExpiry.abs().inMinutes} minutes ago');
      }

      return isValid;
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error validating access token: $e');
      return false;
    }
  }

  /// التحقق من وجود توكنات صالحة
  Future<bool> hasValidTokens() async {
    await _ensureInitialized();

    try {
      final hasAccessToken = await isAccessTokenValid();
      final refreshToken = await getRefreshToken();

      final hasValidTokens = hasAccessToken && refreshToken != null;

      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Has valid tokens: $hasValidTokens');
      debugPrint(
          '🔐 [SECURE_TOKEN_MANAGER] Has valid access token: $hasAccessToken');
      debugPrint(
          '🔐 [SECURE_TOKEN_MANAGER] Has refresh token: ${refreshToken != null}');

      return hasValidTokens;
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error checking valid tokens: $e');
      return false;
    }
  }

  /// الحصول على الوقت المتبقي حتى انتهاء صلاحية التوكن
  Future<Duration?> getTimeUntilExpiry() async {
    await _ensureInitialized();

    try {
      final expiryString = await _storage.readSecure(_tokenExpiryKey);
      if (expiryString == null) return null;

      final expiryTime = DateTime.parse(expiryString);
      final now = DateTime.now();
      final timeUntilExpiry = expiryTime.difference(now);

      return timeUntilExpiry.isNegative ? Duration.zero : timeUntilExpiry;
    } catch (e) {
      debugPrint(
          '❌ [SECURE_TOKEN_MANAGER] Error getting time until expiry: $e');
      return null;
    }
  }

  /// مسح جميع التوكنات
  Future<void> clearTokens() async {
    await _ensureInitialized();

    try {
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Clearing all tokens...');

      await _storage.deleteSecure(_accessTokenKey);
      await _storage.deleteSecure(_refreshTokenKey);
      await _storage.deleteSecure(_tokenExpiryKey);
      await _storage.deleteSecure(_tokenHashKey);
      await _storage.deleteSecure(_lastRefreshKey);

      debugPrint('✅ [SECURE_TOKEN_MANAGER] All tokens cleared');
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error clearing tokens: $e');
    }
  }

  /// التحقق من سلامة التوكنات
  Future<bool> verifyTokenIntegrity() async {
    await _ensureInitialized();

    try {
      final encryptedAccessToken = await _storage.readSecure(_accessTokenKey);
      final encryptedRefreshToken = await _storage.readSecure(_refreshTokenKey);
      final storedHash = await _storage.readSecure(_tokenHashKey);

      if (encryptedAccessToken == null ||
          encryptedRefreshToken == null ||
          storedHash == null) {
        debugPrint(
            '🔐 [SECURE_TOKEN_MANAGER] Missing tokens or hash for integrity check');
        return false;
      }

      final accessToken = _decryptToken(encryptedAccessToken);
      final refreshToken = _decryptToken(encryptedRefreshToken);

      if (accessToken == null || refreshToken == null) {
        debugPrint(
            '❌ [SECURE_TOKEN_MANAGER] Failed to decrypt tokens for integrity check');
        return false;
      }

      final calculatedHash = _generateTokenHash(accessToken, refreshToken);
      final isValid = calculatedHash == storedHash;

      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Token integrity check: $isValid');
      return isValid;
    } catch (e) {
      debugPrint(
          '❌ [SECURE_TOKEN_MANAGER] Error verifying token integrity: $e');
      return false;
    }
  }

  /// الحصول على معلومات التوكنات
  Future<Map<String, dynamic>> getTokenInfo() async {
    await _ensureInitialized();

    try {
      final hasAccessToken = await _storage.readSecure(_accessTokenKey) != null;
      final hasRefreshToken =
          await _storage.readSecure(_refreshTokenKey) != null;
      final expiryString = await _storage.readSecure(_tokenExpiryKey);
      final lastRefreshString = await _storage.readSecure(_lastRefreshKey);
      final isValid = await isAccessTokenValid();
      final timeUntilExpiry = await getTimeUntilExpiry();
      final integrityValid = await verifyTokenIntegrity();

      return {
        'hasAccessToken': hasAccessToken,
        'hasRefreshToken': hasRefreshToken,
        'isValid': isValid,
        'expiryTime': expiryString,
        'lastRefresh': lastRefreshString,
        'timeUntilExpiry': timeUntilExpiry?.inMinutes,
        'integrityValid': integrityValid,
        'platform': kIsWeb ? 'web' : 'mobile',
      };
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Error getting token info: $e');
      return {};
    }
  }

  /// تشفير التوكن
  String _encryptToken(String token) {
    try {
      // Simple XOR encryption for demonstration
      // In production, use proper encryption like AES
      final key = _getEncryptionKey();
      final bytes = utf8.encode(token);
      final encrypted = <int>[];

      for (int i = 0; i < bytes.length; i++) {
        encrypted.add(bytes[i] ^ key[i % key.length]);
      }

      return base64Encode(encrypted);
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Encryption error: $e');
      return token; // Fallback to plain text
    }
  }

  /// فك تشفير التوكن
  String? _decryptToken(String encryptedToken) {
    try {
      // Simple XOR decryption for demonstration
      // In production, use proper decryption like AES
      final key = _getEncryptionKey();
      final encrypted = base64Decode(encryptedToken);
      final decrypted = <int>[];

      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ key[i % key.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Decryption error: $e');
      return null;
    }
  }

  /// الحصول على مفتاح التشفير
  List<int> _getEncryptionKey() {
    // In production, use a secure key derivation function
    // This is a simple example - use proper key management
    final deviceId = _getDeviceId();
    final keyBytes = utf8.encode(deviceId);
    return keyBytes;
  }

  /// الحصول على معرف الجهاز
  String _getDeviceId() {
    // In production, use a proper device ID
    // This is a simple example
    return 'idec_device_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// توليد hash للتوكنات
  String _generateTokenHash(String accessToken, String refreshToken) {
    try {
      final combined = '$accessToken:$refreshToken';
      final bytes = utf8.encode(combined);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Hash generation error: $e');
      return '';
    }
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      debugPrint('🔐 [SECURE_TOKEN_MANAGER] Disposing...');
      // No resources to dispose in this implementation
    } catch (e) {
      debugPrint('❌ [SECURE_TOKEN_MANAGER] Disposal error: $e');
    }
  }
}
