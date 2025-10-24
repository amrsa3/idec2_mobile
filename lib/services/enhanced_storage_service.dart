import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'platform_storage_service.dart';

/// خدمة تخزين محسنة تدعم جميع المنصات
class EnhancedStorageService {
  static EnhancedStorageService? _instance;
  static EnhancedStorageService get instance =>
      _instance ??= EnhancedStorageService._internal();

  late PlatformStorageService _platformStorage;
  late Box _userDataBox;
  late Box _settingsBox;
  late Box _cacheBox;
  late Completer<void> _initCompleter;
  bool _isInitialized = false;

  // Storage keys
  static const String _userDataKey = 'enhanced_user_data';
  static const String _authDataKey = 'enhanced_auth_data';
  static const String _settingsKey = 'enhanced_settings';
  static const String _cacheKey = 'enhanced_cache';
  static const String _lastSyncKey = 'enhanced_last_sync';

  // Configuration
  static const Duration _dataRetentionPeriod = Duration(days: 30);
  static const int _maxCacheSize = 100; // MB
  static const int _maxCacheItems = 1000;

  EnhancedStorageService._internal();

  /// تهيئة الخدمة
  Future<void> init() async {
    if (_isInitialized) return;

    _initCompleter = Completer<void>();

    try {
      _platformStorage = PlatformStorageService.instance;
      await _platformStorage.init();

      // تهيئة Hive
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserDataAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(AuthDataAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(SettingsAdapter());
      }

      // فتح الصناديق
      _userDataBox = await Hive.openBox('user_data');
      _settingsBox = await Hive.openBox('settings');
      _cacheBox = await Hive.openBox('cache');

      // تنظيف البيانات القديمة
      await _cleanupOldData();

      _isInitialized = true;
      _initCompleter.complete();

      debugPrint('✅ EnhancedStorageService initialized successfully');
    } catch (e) {
      debugPrint('❌ EnhancedStorageService initialization failed: $e');
      _initCompleter.completeError(e);
      rethrow;
    }
  }

  /// انتظار التهيئة
  Future<void> waitForInit() async {
    if (_isInitialized) return;
    await _initCompleter.future;
  }

  /// حفظ بيانات المستخدم
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await waitForInit();

    try {
      final userDataModel = UserDataModel(
        data: userData,
        timestamp: DateTime.now(),
        version: '1.0',
      );

      await _userDataBox.put(_userDataKey, userDataModel);
      await _platformStorage.setString(_userDataKey, jsonEncode(userData));

      debugPrint('✅ User data saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
      rethrow;
    }
  }

  /// جلب بيانات المستخدم
  Future<Map<String, dynamic>?> getUserData() async {
    await waitForInit();

    try {
      // محاولة جلب من Hive أولاً
      final userDataModel = _userDataBox.get(_userDataKey) as UserDataModel?;
      if (userDataModel != null) {
        return userDataModel.data;
      }

      // محاولة جلب من PlatformStorage
      final userDataString = await _platformStorage.getString(_userDataKey);
      if (userDataString != null) {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error getting user data: $e');
      return null;
    }
  }

  /// حفظ بيانات المصادقة
  Future<void> saveAuthData(Map<String, dynamic> authData) async {
    await waitForInit();

    try {
      final authDataModel = AuthDataModel(
        data: authData,
        timestamp: DateTime.now(),
        version: '1.0',
      );

      await _userDataBox.put(_authDataKey, authDataModel);
      await _platformStorage.setString(_authDataKey, jsonEncode(authData));

      debugPrint('✅ Auth data saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving auth data: $e');
      rethrow;
    }
  }

  /// جلب بيانات المصادقة
  Future<Map<String, dynamic>?> getAuthData() async {
    await waitForInit();

    try {
      // محاولة جلب من Hive أولاً
      final authDataModel = _userDataBox.get(_authDataKey) as AuthDataModel?;
      if (authDataModel != null) {
        return authDataModel.data;
      }

      // محاولة جلب من PlatformStorage
      final authDataString = await _platformStorage.getString(_authDataKey);
      if (authDataString != null) {
        return jsonDecode(authDataString) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error getting auth data: $e');
      return null;
    }
  }

  /// حفظ الإعدادات
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await waitForInit();

    try {
      final settingsModel = SettingsModel(
        data: settings,
        timestamp: DateTime.now(),
        version: '1.0',
      );

      await _settingsBox.put(_settingsKey, settingsModel);
      await _platformStorage.setString(_settingsKey, jsonEncode(settings));

      debugPrint('✅ Settings saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving settings: $e');
      rethrow;
    }
  }

  /// جلب الإعدادات
  Future<Map<String, dynamic>?> getSettings() async {
    await waitForInit();

    try {
      // محاولة جلب من Hive أولاً
      final settingsModel = _settingsBox.get(_settingsKey) as SettingsModel?;
      if (settingsModel != null) {
        return settingsModel.data;
      }

      // محاولة جلب من PlatformStorage
      final settingsString = await _platformStorage.getString(_settingsKey);
      if (settingsString != null) {
        return jsonDecode(settingsString) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error getting settings: $e');
      return null;
    }
  }

  /// حفظ في الذاكرة المؤقتة
  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    await waitForInit();

    try {
      final cacheModel = CacheModel(
        data: data,
        timestamp: DateTime.now(),
        version: '1.0',
      );

      await _cacheBox.put(key, cacheModel);

      // تنظيف الذاكرة المؤقتة إذا تجاوزت الحد المسموح
      await _cleanupCache();

      debugPrint('✅ Data cached successfully: $key');
    } catch (e) {
      debugPrint('❌ Error caching data: $e');
      rethrow;
    }
  }

  /// جلب من الذاكرة المؤقتة
  Future<Map<String, dynamic>?> getCachedData(String key) async {
    await waitForInit();

    try {
      final cacheModel = _cacheBox.get(key) as CacheModel?;
      if (cacheModel != null) {
        return cacheModel.data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting cached data: $e');
      return null;
    }
  }

  /// مسح البيانات
  Future<void> clearUserData() async {
    await waitForInit();

    try {
      await _userDataBox.delete(_userDataKey);
      await _userDataBox.delete(_authDataKey);
      await _platformStorage.delete(_userDataKey);
      await _platformStorage.delete(_authDataKey);

      debugPrint('✅ User data cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing user data: $e');
      rethrow;
    }
  }

  /// مسح جميع البيانات
  Future<void> clearAllData() async {
    await waitForInit();

    try {
      await _userDataBox.clear();
      await _settingsBox.clear();
      await _cacheBox.clear();
      await _platformStorage.clear();

      debugPrint('✅ All data cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing all data: $e');
      rethrow;
    }
  }

  /// تنظيف البيانات القديمة
  Future<void> _cleanupOldData() async {
    try {
      final cutoffDate = DateTime.now().subtract(_dataRetentionPeriod);

      // تنظيف بيانات المستخدم القديمة
      final userDataModel = _userDataBox.get(_userDataKey) as UserDataModel?;
      if (userDataModel != null &&
          userDataModel.timestamp.isBefore(cutoffDate)) {
        await _userDataBox.delete(_userDataKey);
      }

      // تنظيف بيانات المصادقة القديمة
      final authDataModel = _userDataBox.get(_authDataKey) as AuthDataModel?;
      if (authDataModel != null &&
          authDataModel.timestamp.isBefore(cutoffDate)) {
        await _userDataBox.delete(_authDataKey);
      }

      debugPrint('✅ Old data cleaned up successfully');
    } catch (e) {
      debugPrint('❌ Error cleaning up old data: $e');
    }
  }

  /// تنظيف الذاكرة المؤقتة
  Future<void> _cleanupCache() async {
    try {
      if (_cacheBox.length > _maxCacheItems) {
        // مسح العناصر الأقدم
        final keys = _cacheBox.keys.toList();
        keys.sort((a, b) {
          final aModel = _cacheBox.get(a) as CacheModel?;
          final bModel = _cacheBox.get(b) as CacheModel?;
          return aModel?.timestamp
                  .compareTo(bModel?.timestamp ?? DateTime.now()) ??
              0;
        });

        final itemsToRemove = keys.take(keys.length - _maxCacheItems);
        for (final key in itemsToRemove) {
          await _cacheBox.delete(key);
        }
      }

      debugPrint('✅ Cache cleaned up successfully');
    } catch (e) {
      debugPrint('❌ Error cleaning up cache: $e');
    }
  }

  /// الحصول على حجم البيانات
  Future<int> getDataSize() async {
    await waitForInit();

    try {
      int totalSize = 0;

      // حساب حجم بيانات المستخدم
      for (final key in _userDataBox.keys) {
        final value = _userDataBox.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }

      // حساب حجم الإعدادات
      for (final key in _settingsBox.keys) {
        final value = _settingsBox.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }

      // حساب حجم الذاكرة المؤقتة
      for (final key in _cacheBox.keys) {
        final value = _cacheBox.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('❌ Error calculating data size: $e');
      return 0;
    }
  }

  /// إغلاق الخدمة
  Future<void> close() async {
    try {
      await _userDataBox.close();
      await _settingsBox.close();
      await _cacheBox.close();
      debugPrint('✅ EnhancedStorageService closed successfully');
    } catch (e) {
      debugPrint('❌ Error closing EnhancedStorageService: $e');
    }
  }
}

// Hive Adapters
class UserDataAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 0;

  @override
  UserDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataModel(
      data: fields[0] as Map<String, dynamic>,
      timestamp: fields[1] as DateTime,
      version: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class AuthDataAdapter extends TypeAdapter<AuthDataModel> {
  @override
  final int typeId = 1;

  @override
  AuthDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthDataModel(
      data: fields[0] as Map<String, dynamic>,
      timestamp: fields[1] as DateTime,
      version: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthDataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class SettingsAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 2;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      data: fields[0] as Map<String, dynamic>,
      timestamp: fields[1] as DateTime,
      version: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class CacheAdapter extends TypeAdapter<CacheModel> {
  @override
  final int typeId = 3;

  @override
  CacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheModel(
      data: fields[0] as Map<String, dynamic>,
      timestamp: fields[1] as DateTime,
      version: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

// Data Models
class UserDataModel {
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String version;

  UserDataModel({
    required this.data,
    required this.timestamp,
    required this.version,
  });
}

class AuthDataModel {
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String version;

  AuthDataModel({
    required this.data,
    required this.timestamp,
    required this.version,
  });
}

class SettingsModel {
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String version;

  SettingsModel({
    required this.data,
    required this.timestamp,
    required this.version,
  });
}

class CacheModel {
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String version;

  CacheModel({
    required this.data,
    required this.timestamp,
    required this.version,
  });
}
