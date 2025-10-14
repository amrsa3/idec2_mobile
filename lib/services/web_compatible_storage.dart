import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Web-compatible storage service that handles both web and mobile storage
class WebCompatibleStorage {
  static WebCompatibleStorage? _instance;
  static WebCompatibleStorage get instance =>
      _instance ??= WebCompatibleStorage._internal();

  WebCompatibleStorage._internal();

  // In-memory storage for web (temporary solution)
  final Map<String, String> _webStorage = {};

  Future<void> write(String key, String value) async {
    try {
      if (kIsWeb) {
        debugPrint('🔍 [WEB_STORAGE] Writing to web storage: $key');
        _webStorage[key] = value;
        debugPrint('🔍 [WEB_STORAGE] Successfully stored: $key');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      debugPrint(
          '🔍 [WEB_STORAGE] Successfully stored in SharedPreferences: $key');
    } catch (e) {
      debugPrint('🔍 [WEB_STORAGE] Error writing $key: $e');
      // Don't rethrow to avoid breaking the flow
    }
  }

  Future<String?> read(String key) async {
    try {
      if (kIsWeb) {
        debugPrint('🔍 [WEB_STORAGE] Reading from web storage: $key');
        final value = _webStorage[key];
        debugPrint(
            '🔍 [WEB_STORAGE] Retrieved: $key = ${value != null ? "found" : "null"}');
        return value;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      debugPrint(
          '🔍 [WEB_STORAGE] Retrieved from SharedPreferences: $key = ${value != null ? "found" : "null"}');
      return value;
    } catch (e) {
      debugPrint('🔍 [WEB_STORAGE] Error reading $key: $e');
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      if (kIsWeb) {
        debugPrint('🔍 [WEB_STORAGE] Deleting from web storage: $key');
        _webStorage.remove(key);
        debugPrint('🔍 [WEB_STORAGE] Successfully deleted: $key');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      debugPrint(
          '🔍 [WEB_STORAGE] Successfully deleted from SharedPreferences: $key');
    } catch (e) {
      debugPrint('🔍 [WEB_STORAGE] Error deleting $key: $e');
      // Don't rethrow to avoid breaking the flow
    }
  }

  Future<void> clear() async {
    try {
      if (kIsWeb) {
        debugPrint('🔍 [WEB_STORAGE] Clearing web storage');
        _webStorage.clear();
        debugPrint('🔍 [WEB_STORAGE] Successfully cleared web storage');
        return;
      }

      // For mobile, use SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint('🔍 [WEB_STORAGE] Successfully cleared SharedPreferences');
    } catch (e) {
      debugPrint('🔍 [WEB_STORAGE] Error clearing storage: $e');
      // Don't rethrow to avoid breaking the flow
    }
  }
}
