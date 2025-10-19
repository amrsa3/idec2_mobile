import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Unified storage service that handles secure storage across all platforms
/// Uses FlutterSecureStorage for mobile and WebCompatibleStorage for web
class PlatformStorageService {
  static PlatformStorageService? _instance;
  static PlatformStorageService get instance =>
      _instance ??= PlatformStorageService._internal();

  PlatformStorageService._internal();

  // In-memory cache to reduce storage operations
  final Map<String, String> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Initialize the storage service
  Future<void> init() async {
    // No initialization needed for current implementation
    if (kDebugMode) {
      debugPrint('🔐 [PLATFORM_STORAGE] Storage service initialized with caching');
    }
  }

  // Secure storage for mobile platforms
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // In-memory storage for web (temporary solution)
  final Map<String, String> _webStorage = {};

  /// Check if cache is valid for a key
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Write data to secure storage
  Future<void> writeSecure(String key, String value) async {
    try {
      // Update cache first
      _cache[key] = value;
      _cacheTimestamps[key] = DateTime.now();

      if (kIsWeb) {
        _webStorage[key] = value;
        if (kDebugMode) {
          debugPrint('🔐 [PLATFORM_STORAGE] Stored in web storage: $key');
        }
        return;
      }

      // For mobile, use FlutterSecureStorage
      await _secureStorage.write(key: key, value: value);
      if (kDebugMode) {
        debugPrint('🔐 [PLATFORM_STORAGE] Stored in secure storage: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔐 [PLATFORM_STORAGE] Error writing $key: $e');
      }
      // Fallback to SharedPreferences on mobile if secure storage fails
      if (!kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(key, value);
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Fallback to SharedPreferences: $key');
          }
        } catch (fallbackError) {
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Fallback also failed: $fallbackError');
          }
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }

  /// Read data from secure storage
  Future<String?> readSecure(String key) async {
    try {
      // Check cache first
      if (_isCacheValid(key)) {
        if (kDebugMode) {
          debugPrint('🔐 [PLATFORM_STORAGE] Retrieved from cache: $key');
        }
        return _cache[key];
      }

      String? value;
      if (kIsWeb) {
        value = _webStorage[key];
      } else {
        // For mobile, use FlutterSecureStorage
        value = await _secureStorage.read(key: key);
      }

      // Update cache if value found
      if (value != null) {
        _cache[key] = value;
        _cacheTimestamps[key] = DateTime.now();
      }

      if (kDebugMode) {
        debugPrint('🔐 [PLATFORM_STORAGE] Retrieved from storage: $key = ${value != null ? "found" : "null"}');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔐 [PLATFORM_STORAGE] Error reading $key: $e');
      }
      // Fallback to SharedPreferences on mobile if secure storage fails
      if (!kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final value = prefs.getString(key);
          if (value != null) {
            _cache[key] = value;
            _cacheTimestamps[key] = DateTime.now();
          }
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Fallback read from SharedPreferences: $key');
          }
          return value;
        } catch (fallbackError) {
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Fallback read also failed: $fallbackError');
          }
          return null;
        }
      }
      return null;
    }
  }

  /// Delete data from secure storage
  Future<void> deleteSecure(String key) async {
    try {
      // Remove from cache
      _cache.remove(key);
      _cacheTimestamps.remove(key);

      if (kIsWeb) {
        _webStorage.remove(key);
        if (kDebugMode) {
          debugPrint('🔐 [PLATFORM_STORAGE] Deleted from web storage: $key');
        }
        return;
      }

      // For mobile, use FlutterSecureStorage
      await _secureStorage.delete(key: key);
      if (kDebugMode) {
        debugPrint('🔐 [PLATFORM_STORAGE] Successfully deleted from secure storage: $key');
      }
    } catch (e) {
      debugPrint('🔐 [PLATFORM_STORAGE] Error deleting $key: $e');
      // Fallback to SharedPreferences on mobile if secure storage fails
      if (!kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(key);
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Fallback delete from SharedPreferences: $key');
          }
        } catch (fallbackError) {
          debugPrint('🔐 [PLATFORM_STORAGE] Fallback delete also failed: $fallbackError');
        }
      }
    }
  }

  /// Clear all secure storage
  Future<void> clearSecure() async {
    try {
      if (kIsWeb) {
        debugPrint('🔐 [PLATFORM_STORAGE] Clearing web storage');
        _webStorage.clear();
        debugPrint('🔐 [PLATFORM_STORAGE] Successfully cleared web storage');
        return;
      }

      // For mobile, use FlutterSecureStorage
      await _secureStorage.deleteAll();
      debugPrint('🔐 [PLATFORM_STORAGE] Successfully cleared secure storage');
    } catch (e) {
      debugPrint('🔐 [PLATFORM_STORAGE] Error clearing storage: $e');
      // Fallback to SharedPreferences on mobile if secure storage fails
      if (!kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          debugPrint('🔐 [PLATFORM_STORAGE] Fallback clear SharedPreferences');
        } catch (fallbackError) {
          debugPrint('🔐 [PLATFORM_STORAGE] Fallback clear also failed: $fallbackError');
        }
      }
    }
  }

  /// Write data to regular storage (non-secure)
  Future<void> write(String key, String value) async {
    try {
      if (kIsWeb) {
        debugPrint('📝 [PLATFORM_STORAGE] Writing to web storage: $key');
        _webStorage[key] = value;
        debugPrint('📝 [PLATFORM_STORAGE] Successfully stored: $key');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      debugPrint('📝 [PLATFORM_STORAGE] Successfully stored in SharedPreferences: $key');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error writing $key: $e');
      rethrow;
    }
  }

  /// Read data from regular storage (non-secure)
  Future<String?> read(String key) async {
    try {
      if (kIsWeb) {
        debugPrint('📝 [PLATFORM_STORAGE] Reading from web storage: $key');
        final value = _webStorage[key];
        debugPrint('📝 [PLATFORM_STORAGE] Retrieved: $key = ${value != null ? "found" : "null"}');
        return value;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      debugPrint('📝 [PLATFORM_STORAGE] Retrieved from SharedPreferences: $key = ${value != null ? "found" : "null"}');
      return value;
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error reading $key: $e');
      return null;
    }
  }

  /// Delete data from regular storage (non-secure)
  Future<void> delete(String key) async {
    try {
      if (kIsWeb) {
        debugPrint('📝 [PLATFORM_STORAGE] Deleting from web storage: $key');
        _webStorage.remove(key);
        debugPrint('📝 [PLATFORM_STORAGE] Successfully deleted: $key');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      debugPrint('📝 [PLATFORM_STORAGE] Successfully deleted from SharedPreferences: $key');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error deleting $key: $e');
    }
  }

  /// Clear all regular storage (non-secure)
  Future<void> clear() async {
    try {
      if (kIsWeb) {
        debugPrint('📝 [PLATFORM_STORAGE] Clearing web storage');
        _webStorage.clear();
        debugPrint('📝 [PLATFORM_STORAGE] Successfully cleared web storage');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint('📝 [PLATFORM_STORAGE] Successfully cleared SharedPreferences');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error clearing storage: $e');
    }
  }

  /// Get all keys from storage
  Future<Set<String>> getAllKeys() async {
    try {
      if (kIsWeb) {
        return _webStorage.keys.toSet();
      }

      // For mobile, try secure storage first, then SharedPreferences
      try {
        final secureKeys = await _secureStorage.readAll();
        final prefs = await SharedPreferences.getInstance();
        final prefKeys = prefs.getKeys();
        return {...secureKeys.keys, ...prefKeys};
      } catch (e) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getKeys();
      }
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error getting all keys: $e');
      return <String>{};
    }
  }

  /// Check if storage contains a key
  Future<bool> containsKey(String key) async {
    try {
      if (kIsWeb) {
        return _webStorage.containsKey(key);
      }

      // Check both secure storage and SharedPreferences
      try {
        final secureValue = await _secureStorage.read(key: key);
        if (secureValue != null) return true;
      } catch (e) {
        debugPrint('📝 [PLATFORM_STORAGE] Error checking secure storage: $e');
      }

      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error checking key existence: $e');
      return false;
    }
  }

  /// Get string value
  Future<String?> getString(String key) async {
    return await read(key);
  }

  /// Set string value
  Future<void> setString(String key, String value) async {
    await write(key, value);
  }

  /// Get boolean value
  Future<bool?> getBool(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  /// Set boolean value
  Future<void> setBool(String key, bool value) async {
    await write(key, value.toString());
  }

  /// Get integer value
  Future<int?> getInt(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Set integer value
  Future<void> setInt(String key, int value) async {
    await write(key, value.toString());
  }

  /// Get double value
  Future<double?> getDouble(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  /// Set double value
  Future<void> setDouble(String key, double value) async {
    await write(key, value.toString());
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await getString('access_token');
  }

  /// Set access token
  Future<void> setAccessToken(String token) async {
    await setString('access_token', token);
  }

  /// Read batch of keys
  Future<Map<String, String>> readBatch(List<String> keys) async {
    final Map<String, String> result = {};
    for (final key in keys) {
      final value = await getString(key);
      if (value != null) {
        result[key] = value;
      }
    }
    return result;
  }

  /// Write batch of key-value pairs
  Future<void> writeBatch(Map<String, String> data) async {
    for (final entry in data.entries) {
      await setString(entry.key, entry.value);
    }
  }
}
