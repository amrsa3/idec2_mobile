import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for web
import 'platform_storage_service_stub.dart'
    if (dart.library.html) 'platform_storage_service_web.dart' as web_storage;

/// Unified storage service that handles secure storage across all platforms
/// Uses FlutterSecureStorage for mobile and localStorage/sessionStorage for web
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
      debugPrint(
          '🔐 [PLATFORM_STORAGE] Storage service initialized with caching');
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
        // Use localStorage for secure storage on web
        try {
          web_storage.window.localStorage['secure_$key'] = value;
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Stored in localStorage (secure): $key');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Error storing in localStorage: $e');
          }
          // Fallback: try sessionStorage
          try {
            web_storage.window.sessionStorage['secure_$key'] = value;
            if (kDebugMode) {
              debugPrint('🔐 [PLATFORM_STORAGE] Stored in sessionStorage (secure): $key');
            }
          } catch (e2) {
            if (kDebugMode) {
              debugPrint('🔐 [PLATFORM_STORAGE] Error storing in sessionStorage: $e2');
            }
          }
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
            debugPrint(
                '🔐 [PLATFORM_STORAGE] Fallback to SharedPreferences: $key');
          }
        } catch (fallbackError) {
          if (kDebugMode) {
            debugPrint(
                '🔐 [PLATFORM_STORAGE] Fallback also failed: $fallbackError');
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
        // Read from localStorage first (secure storage)
        try {
          value = web_storage.window.localStorage['secure_$key'];
          value ??= web_storage.window.sessionStorage['secure_$key'];
        } catch (e) {
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Error reading from web storage: $e');
          }
        }
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
        debugPrint(
            '🔐 [PLATFORM_STORAGE] Retrieved from storage: $key = ${value != null ? "found" : "null"}');
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
            debugPrint(
                '🔐 [PLATFORM_STORAGE] Fallback read from SharedPreferences: $key');
          }
          return value;
        } catch (fallbackError) {
          if (kDebugMode) {
            debugPrint(
                '🔐 [PLATFORM_STORAGE] Fallback read also failed: $fallbackError');
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
        // Delete from both localStorage and sessionStorage
        try {
          web_storage.window.localStorage.remove('secure_$key');
          web_storage.window.sessionStorage.remove('secure_$key');
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Deleted from web storage (secure): $key');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('🔐 [PLATFORM_STORAGE] Error deleting from web storage: $e');
          }
        }
        return;
      }

      // For mobile, use FlutterSecureStorage
      await _secureStorage.delete(key: key);
      if (kDebugMode) {
        debugPrint(
            '🔐 [PLATFORM_STORAGE] Successfully deleted from secure storage: $key');
      }
    } catch (e) {
      debugPrint('🔐 [PLATFORM_STORAGE] Error deleting $key: $e');
      // Fallback to SharedPreferences on mobile if secure storage fails
      if (!kIsWeb) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(key);
          if (kDebugMode) {
            debugPrint(
                '🔐 [PLATFORM_STORAGE] Fallback delete from SharedPreferences: $key');
          }
        } catch (fallbackError) {
          debugPrint(
              '🔐 [PLATFORM_STORAGE] Fallback delete also failed: $fallbackError');
        }
      }
    }
  }

  /// Clear all secure storage
  Future<void> clearSecure() async {
    try {
      if (kIsWeb) {
        debugPrint('🔐 [PLATFORM_STORAGE] Clearing web secure storage');
        // Clear all keys starting with 'secure_' from localStorage
        try {
          final keysToRemove = <String>[];
          web_storage.window.localStorage.forEach((key, value) {
            if (key.startsWith('secure_')) {
              keysToRemove.add(key);
            }
          });
          for (final key in keysToRemove) {
            web_storage.window.localStorage.remove(key);
          }
          
          // Also clear from sessionStorage
          final sessionKeysToRemove = <String>[];
          web_storage.window.sessionStorage.forEach((key, value) {
            if (key.startsWith('secure_')) {
              sessionKeysToRemove.add(key);
            }
          });
          for (final key in sessionKeysToRemove) {
            web_storage.window.sessionStorage.remove(key);
          }
          
          // Clear in-memory cache
          _cache.clear();
          _cacheTimestamps.clear();
          
          debugPrint('🔐 [PLATFORM_STORAGE] Successfully cleared web secure storage (${keysToRemove.length + sessionKeysToRemove.length} keys)');
        } catch (e) {
          debugPrint('🔐 [PLATFORM_STORAGE] Error clearing web secure storage: $e');
        }
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
          debugPrint(
              '🔐 [PLATFORM_STORAGE] Fallback clear also failed: $fallbackError');
        }
      }
    }
  }

  /// Write data to regular storage (non-secure)
  Future<void> write(String key, String value) async {
    try {
      if (kIsWeb) {
        // Use localStorage for regular storage on web
        try {
          web_storage.window.localStorage[key] = value;
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Stored in localStorage: $key');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Error storing in localStorage: $e');
          }
          // Fallback: try sessionStorage
          try {
            web_storage.window.sessionStorage[key] = value;
            if (kDebugMode) {
              debugPrint('📝 [PLATFORM_STORAGE] Stored in sessionStorage: $key');
            }
          } catch (e2) {
            if (kDebugMode) {
              debugPrint('📝 [PLATFORM_STORAGE] Error storing in sessionStorage: $e2');
            }
          }
        }
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      debugPrint(
          '📝 [PLATFORM_STORAGE] Successfully stored in SharedPreferences: $key');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error writing $key: $e');
      rethrow;
    }
  }

  /// Read data from regular storage (non-secure)
  Future<String?> read(String key) async {
    try {
      if (kIsWeb) {
        // Read from localStorage first
        String? value;
        try {
          value = web_storage.window.localStorage[key];
          value ??= web_storage.window.sessionStorage[key];
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Retrieved from web storage: $key = ${value != null ? "found" : "null"}');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Error reading from web storage: $e');
          }
        }
        return value;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      debugPrint(
          '📝 [PLATFORM_STORAGE] Retrieved from SharedPreferences: $key = ${value != null ? "found" : "null"}');
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
        // Delete from both localStorage and sessionStorage
        try {
          web_storage.window.localStorage.remove(key);
          web_storage.window.sessionStorage.remove(key);
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Deleted from web storage: $key');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('📝 [PLATFORM_STORAGE] Error deleting from web storage: $e');
          }
        }
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      debugPrint(
          '📝 [PLATFORM_STORAGE] Successfully deleted from SharedPreferences: $key');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error deleting $key: $e');
    }
  }

  /// Clear all regular storage (non-secure)
  Future<void> clear() async {
    try {
      if (kIsWeb) {
        debugPrint('📝 [PLATFORM_STORAGE] Clearing web storage');
        try {
          // Clear all non-secure keys from localStorage
          final keysToRemove = <String>[];
          web_storage.window.localStorage.forEach((key, value) {
            if (!key.startsWith('secure_')) {
              keysToRemove.add(key);
            }
          });
          for (final key in keysToRemove) {
            web_storage.window.localStorage.remove(key);
          }
          
          // Clear all non-secure keys from sessionStorage
          final sessionKeysToRemove = <String>[];
          web_storage.window.sessionStorage.forEach((key, value) {
            if (!key.startsWith('secure_')) {
              sessionKeysToRemove.add(key);
            }
          });
          for (final key in sessionKeysToRemove) {
            web_storage.window.sessionStorage.remove(key);
          }
          
          // Clear in-memory cache
          _cache.clear();
          _cacheTimestamps.clear();
          
          debugPrint('📝 [PLATFORM_STORAGE] Successfully cleared web storage (${keysToRemove.length + sessionKeysToRemove.length} keys)');
        } catch (e) {
          debugPrint('📝 [PLATFORM_STORAGE] Error clearing web storage: $e');
        }
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint(
          '📝 [PLATFORM_STORAGE] Successfully cleared SharedPreferences');
    } catch (e) {
      debugPrint('📝 [PLATFORM_STORAGE] Error clearing storage: $e');
    }
  }

  /// Get all keys from storage
  Future<Set<String>> getAllKeys() async {
    try {
      if (kIsWeb) {
        final keys = <String>{};
        try {
          web_storage.window.localStorage.forEach((key, value) {
            // Remove 'secure_' prefix for secure keys
            if (key.startsWith('secure_')) {
              keys.add(key.substring(7)); // Remove 'secure_' prefix
            } else {
              keys.add(key);
            }
          });
          web_storage.window.sessionStorage.forEach((key, value) {
            if (key.startsWith('secure_')) {
              keys.add(key.substring(7));
            } else {
              keys.add(key);
            }
          });
        } catch (e) {
          debugPrint('📝 [PLATFORM_STORAGE] Error getting keys from web storage: $e');
        }
        return keys;
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
        try {
          // Check localStorage first
          if (web_storage.window.localStorage.containsKey(key) || 
              web_storage.window.localStorage.containsKey('secure_$key')) {
            return true;
          }
          // Check sessionStorage
          if (web_storage.window.sessionStorage.containsKey(key) || 
              web_storage.window.sessionStorage.containsKey('secure_$key')) {
            return true;
          }
        } catch (e) {
          debugPrint('📝 [PLATFORM_STORAGE] Error checking key in web storage: $e');
        }
        return false;
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

  /// Get current locale from storage
  Locale? getCurrentLocale() {
    try {
      final languageCode = _cache['selected_language'];
      if (languageCode != null && languageCode.isNotEmpty) {
        return Locale(languageCode);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [PLATFORM_STORAGE] Error getting current locale: $e');
      return null;
    }
  }
}
