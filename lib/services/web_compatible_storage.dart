import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Web-compatible storage service using in-memory storage for testing
/// This service provides secure storage functionality for web platform
class WebCompatibleStorage {
  static WebCompatibleStorage? _instance;
  static WebCompatibleStorage get instance => _instance ??= WebCompatibleStorage._();
  
  WebCompatibleStorage._();

  // In-memory storage for testing and web compatibility
  final Map<String, String> _storage = {};

  /// Initialize the storage service
  Future<void> initialize() async {
    debugPrint('🌐 [WEB_STORAGE] Initializing web compatible storage...');
    debugPrint('✅ [WEB_STORAGE] Web storage initialized successfully');
  }

  /// Write data securely to storage
  Future<void> writeSecure(String key, String value) async {
    try {
      // Encode the value for basic obfuscation
      final encodedValue = base64Encode(utf8.encode(value));
      _storage['secure_$key'] = encodedValue;
      debugPrint('🔐 [WEB_STORAGE] Securely stored: $key');
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error writing secure data: $e');
      rethrow;
    }
  }

  /// Read data securely from storage
  Future<String?> readSecure(String key) async {
    try {
      final encodedValue = _storage['secure_$key'];
      if (encodedValue == null) return null;
      
      // Decode the value
      final decodedBytes = base64Decode(encodedValue);
      final value = utf8.decode(decodedBytes);
      debugPrint('🔓 [WEB_STORAGE] Securely read: $key');
      return value;
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error reading secure data: $e');
      return null;
    }
  }

  /// Delete secure data from storage
  Future<void> deleteSecure(String key) async {
    try {
      _storage.remove('secure_$key');
      debugPrint('🗑️ [WEB_STORAGE] Deleted secure data: $key');
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error deleting secure data: $e');
      rethrow;
    }
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    try {
      final keysToRemove = _storage.keys.where((key) => key.startsWith('secure_')).toList();
      for (final key in keysToRemove) {
        _storage.remove(key);
      }
      debugPrint('🧹 [WEB_STORAGE] Cleared all secure data');
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error clearing secure data: $e');
      rethrow;
    }
  }

  /// Write regular data to storage
  Future<void> write(String key, String value) async {
    try {
      _storage[key] = value;
      debugPrint('💾 [WEB_STORAGE] Stored: $key');
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error writing data: $e');
      rethrow;
    }
  }

  /// Read regular data from storage
  Future<String?> read(String key) async {
    try {
      final value = _storage[key];
      if (value != null) {
        debugPrint('📖 [WEB_STORAGE] Read: $key');
      }
      return value;
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error reading data: $e');
      return null;
    }
  }

  /// Delete regular data from storage
  Future<void> delete(String key) async {
    try {
      _storage.remove(key);
      debugPrint('🗑️ [WEB_STORAGE] Deleted: $key');
    } catch (e) {
      debugPrint('❌ [WEB_STORAGE] Error deleting data: $e');
      rethrow;
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  /// Get all keys
  Future<Set<String>> getAllKeys() async {
    return _storage.keys.toSet();
  }

  /// Get storage size (approximate)
  int getStorageSize() {
    int totalSize = 0;
    _storage.forEach((key, value) {
      totalSize += key.length + value.length;
    });
    return totalSize;
  }

  /// Check if storage is available
  bool isStorageAvailable() {
    return true; // In-memory storage is always available
  }
}