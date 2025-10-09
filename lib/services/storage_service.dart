import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._internal();
  
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  
  StorageService._internal();
  
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('🔧 StorageService: SharedPreferences initialized successfully');
    } catch (e) {
      debugPrint('❌ StorageService: Failed to initialize SharedPreferences: $e');
      rethrow;
    }
  }
  
  void _checkInitialization() {
    if (!_isInitialized) {
      throw StateError('StorageService not initialized. Call StorageService.instance.init() first.');
    }
  }
  
  // String operations
  Future<void> setString(String key, String value) async {
    _checkInitialization();
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    _checkInitialization();
    return _prefs.getString(key);
  }
  
  // Bool operations
  Future<void> setBool(String key, bool value) async {
    _checkInitialization();
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    _checkInitialization();
    return _prefs.getBool(key);
  }
  
  // Int operations
  Future<void> setInt(String key, int value) async {
    _checkInitialization();
    await _prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    _checkInitialization();
    return _prefs.getInt(key);
  }
  
  // Remove operations
  Future<void> remove(String key) async {
    _checkInitialization();
    await _prefs.remove(key);
  }
  
  Future<void> clear() async {
    _checkInitialization();
    await _prefs.clear();
  }
  
  // Check if key exists
  bool containsKey(String key) {
    _checkInitialization();
    return _prefs.containsKey(key);
  }
  
  // Token operations
  Future<void> setToken(String token) async {
    await setString('auth_token', token);
  }
  
  Future<String?> getToken() async {
    return getString('auth_token');
  }
  
  Future<void> removeToken() async {
    await remove('auth_token');
  }
}
