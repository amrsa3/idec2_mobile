import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'platform_storage_service.dart';

/// خدمة التخزين في وضع عدم الاتصال
/// تدعم تخزين البيانات محلياً ومزامنتها عند العودة للاتصال
class OfflineStorageService {
  static OfflineStorageService? _instance;
  static OfflineStorageService get instance => _instance ??= OfflineStorageService._internal();

  late PlatformStorageService _storage;
  late Box _offlineBox;
  late Box _pendingOperationsBox;
  late Completer<void> _initCompleter;
  bool _isInitialized = false;

  // Storage keys
  static const String _userDataKey = 'offline_user_data';
  static const String _authDataKey = 'offline_auth_data';
  static const String _lastSyncKey = 'offline_last_sync';
  // static const String _pendingOpsKey = 'offline_pending_operations';

  // Configuration
  static const Duration _dataRetentionPeriod = Duration(days: 7);
  static const int _maxPendingOperations = 100;

  OfflineStorageService._internal() {
    _initCompleter = Completer<void>();
  }

  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Initializing offline storage...');

      _storage = PlatformStorageService.instance;
      await _storage.init();

      // Skip Hive initialization on web platform
      if (kIsWeb) {
        debugPrint('🌐 [OFFLINE_STORAGE] Web platform detected - skipping Hive initialization');
        _isInitialized = true;
        if (!_initCompleter.isCompleted) {
          _initCompleter.complete();
        }
        debugPrint('✅ [OFFLINE_STORAGE] Web-compatible offline storage initialized');
        return;
      }

      // Initialize Hive for offline storage on mobile platforms
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(OfflineDataAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(PendingOperationAdapter());
      }

      // Get application documents directory (mobile only)
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);

      // Open boxes
      _offlineBox = await Hive.openBox('offline_data');
      _pendingOperationsBox = await Hive.openBox('pending_operations');

      // Clean old data
      await _cleanOldData();

      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      debugPrint('✅ [OFFLINE_STORAGE] Offline storage initialized successfully');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Initialization error: $e');
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

  /// حفظ بيانات المستخدم محلياً
  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Caching user data...');

      // On web, use platform storage only
      if (kIsWeb) {
        await _storage.writeSecure(_userDataKey, jsonEncode(userData));
        await _storage.writeSecure(_lastSyncKey, DateTime.now().toIso8601String());
        debugPrint('✅ [OFFLINE_STORAGE] User data cached successfully (web)');
        return;
      }

      final offlineData = OfflineData(
        key: _userDataKey,
        data: userData,
        timestamp: DateTime.now(),
        type: OfflineDataType.userData,
      );

      await _offlineBox.put(_userDataKey, offlineData);
      await _storage.writeSecure(_lastSyncKey, DateTime.now().toIso8601String());

      debugPrint('✅ [OFFLINE_STORAGE] User data cached successfully');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error caching user data: $e');
    }
  }

  /// الحصول على بيانات المستخدم المحفوظة محلياً
  Future<Map<String, dynamic>?> getCachedUserData() async {
    await _ensureInitialized();
    
    try {
      // On web, use platform storage only
      if (kIsWeb) {
        final userDataString = await _storage.readSecure(_userDataKey);
        if (userDataString == null) {
          debugPrint('💾 [OFFLINE_STORAGE] No cached user data found (web)');
          return null;
        }
        
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        debugPrint('✅ [OFFLINE_STORAGE] Retrieved cached user data (web)');
        return userData;
      }

      final offlineData = _offlineBox.get(_userDataKey) as OfflineData?;
      
      if (offlineData == null) {
        debugPrint('💾 [OFFLINE_STORAGE] No cached user data found');
        return null;
      }

      // Check if data is still valid
      if (_isDataExpired(offlineData.timestamp)) {
        debugPrint('💾 [OFFLINE_STORAGE] Cached user data is expired');
        await _offlineBox.delete(_userDataKey);
        return null;
      }

      debugPrint('✅ [OFFLINE_STORAGE] Retrieved cached user data');
      return offlineData.data;
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting cached user data: $e');
      return null;
    }
  }

  /// حفظ بيانات المصادقة محلياً
  Future<void> cacheAuthData(Map<String, dynamic> authData) async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Caching auth data...');

      final offlineData = OfflineData(
        key: _authDataKey,
        data: authData,
        timestamp: DateTime.now(),
        type: OfflineDataType.authData,
      );

      await _offlineBox.put(_authDataKey, offlineData);

      debugPrint('✅ [OFFLINE_STORAGE] Auth data cached successfully');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error caching auth data: $e');
    }
  }

  /// الحصول على بيانات المصادقة المحفوظة محلياً
  Future<Map<String, dynamic>?> getCachedAuthData() async {
    await _ensureInitialized();
    
    try {
      final offlineData = _offlineBox.get(_authDataKey) as OfflineData?;
      
      if (offlineData == null) {
        debugPrint('💾 [OFFLINE_STORAGE] No cached auth data found');
        return null;
      }

      // Check if data is still valid
      if (_isDataExpired(offlineData.timestamp)) {
        debugPrint('💾 [OFFLINE_STORAGE] Cached auth data is expired');
        await _offlineBox.delete(_authDataKey);
        return null;
      }

      debugPrint('✅ [OFFLINE_STORAGE] Retrieved cached auth data');
      return offlineData.data;
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting cached auth data: $e');
      return null;
    }
  }

  /// حفظ عملية معلقة للمزامنة لاحقاً
  Future<void> addPendingOperation({
    required String operation,
    required Map<String, dynamic> data,
    String? endpoint,
  }) async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Adding pending operation: $operation');

      // Check if we have too many pending operations
      final pendingCount = _pendingOperationsBox.length;
      if (pendingCount >= _maxPendingOperations) {
        debugPrint('⚠️ [OFFLINE_STORAGE] Too many pending operations, removing oldest');
        await _removeOldestPendingOperation();
      }

      final pendingOp = PendingOperation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        operation: operation,
        data: data,
        endpoint: endpoint,
        timestamp: DateTime.now(),
        retryCount: 0,
      );

      await _pendingOperationsBox.put(pendingOp.id, pendingOp);

      debugPrint('✅ [OFFLINE_STORAGE] Pending operation added: ${pendingOp.id}');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error adding pending operation: $e');
    }
  }

  /// مزامنة العمليات المعلقة
  Future<void> syncPendingOperations() async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Syncing pending operations...');

      final pendingOps = _pendingOperationsBox.values.cast<PendingOperation>();
      final successfulOps = <String>[];

      for (final op in pendingOps) {
        try {
          final success = await _executePendingOperation(op);
          if (success) {
            successfulOps.add(op.id);
            debugPrint('✅ [OFFLINE_STORAGE] Synced operation: ${op.id}');
          } else {
            // Increment retry count
            op.retryCount++;
            if (op.retryCount >= 3) {
              // Remove after 3 failed attempts
              successfulOps.add(op.id);
              debugPrint('❌ [OFFLINE_STORAGE] Removing failed operation after 3 retries: ${op.id}');
            } else {
              await _pendingOperationsBox.put(op.id, op);
              debugPrint('⚠️ [OFFLINE_STORAGE] Operation failed, retry count: ${op.retryCount}');
            }
          }
        } catch (e) {
          debugPrint('❌ [OFFLINE_STORAGE] Error syncing operation ${op.id}: $e');
          op.retryCount++;
          if (op.retryCount >= 3) {
            successfulOps.add(op.id);
          } else {
            await _pendingOperationsBox.put(op.id, op);
          }
        }
      }

      // Remove successful operations
      for (final opId in successfulOps) {
        await _pendingOperationsBox.delete(opId);
      }

      debugPrint('✅ [OFFLINE_STORAGE] Sync completed. Processed: ${pendingOps.length}, Successful: ${successfulOps.length}');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error syncing pending operations: $e');
    }
  }

  /// تنفيذ عملية معلقة
  Future<bool> _executePendingOperation(PendingOperation op) async {
    try {
      // This is a placeholder - implement actual API calls based on operation type
      switch (op.operation) {
        case 'update_profile':
          // Implement profile update API call
          return true;
        case 'upload_file':
          // Implement file upload API call
          return true;
        case 'send_message':
          // Implement message sending API call
          return true;
        default:
          debugPrint('⚠️ [OFFLINE_STORAGE] Unknown operation type: ${op.operation}');
          return false;
      }
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error executing operation ${op.id}: $e');
      return false;
    }
  }

  /// مسح بيانات المصادقة المحفوظة محلياً
  Future<void> clearAuthData() async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Clearing cached auth data...');

      await _offlineBox.delete(_authDataKey);
      await _storage.deleteSecure(_lastSyncKey);

      debugPrint('✅ [OFFLINE_STORAGE] Auth data cleared');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error clearing auth data: $e');
    }
  }

  /// مسح جميع البيانات المحفوظة محلياً
  Future<void> clearAllData() async {
    await _ensureInitialized();
    
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Clearing all offline data...');

      await _offlineBox.clear();
      await _pendingOperationsBox.clear();
      await _storage.deleteSecure(_lastSyncKey);

      debugPrint('✅ [OFFLINE_STORAGE] All offline data cleared');
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error clearing all data: $e');
    }
  }

  /// الحصول على آخر وقت مزامنة
  Future<DateTime?> getLastSyncTime() async {
    await _ensureInitialized();
    
    try {
      final lastSyncString = await _storage.readSecure(_lastSyncKey);
      if (lastSyncString == null) return null;
      
      return DateTime.parse(lastSyncString);
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting last sync time: $e');
      return null;
    }
  }

  /// الحصول على عدد العمليات المعلقة
  Future<int> getPendingOperationsCount() async {
    await _ensureInitialized();
    
    try {
      return _pendingOperationsBox.length;
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting pending operations count: $e');
      return 0;
    }
  }

  /// الحصول على معلومات التخزين المحلي
  Future<Map<String, dynamic>> getStorageInfo() async {
    await _ensureInitialized();
    
    try {
      final lastSync = await getLastSyncTime();
      final pendingCount = await getPendingOperationsCount();
      final hasUserData = _offlineBox.get(_userDataKey) != null;
      final hasAuthData = _offlineBox.get(_authDataKey) != null;

      return {
        'lastSyncTime': lastSync?.toIso8601String(),
        'pendingOperationsCount': pendingCount,
        'hasUserData': hasUserData,
        'hasAuthData': hasAuthData,
        'totalOfflineData': _offlineBox.length,
        'dataRetentionPeriod': _dataRetentionPeriod.inDays,
      };
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting storage info: $e');
      return {};
    }
  }

  /// التحقق من انتهاء صلاحية البيانات
  bool _isDataExpired(DateTime timestamp) {
    final now = DateTime.now();
    final age = now.difference(timestamp);
    return age > _dataRetentionPeriod;
  }

  /// إزالة أقدم عملية معلقة
  Future<void> _removeOldestPendingOperation() async {
    try {
      final pendingOps = _pendingOperationsBox.values.cast<PendingOperation>();
      if (pendingOps.isEmpty) return;

      // Find oldest operation
      PendingOperation? oldest;
      for (final op in pendingOps) {
        if (oldest == null || op.timestamp.isBefore(oldest.timestamp)) {
          oldest = op;
        }
      }

      if (oldest != null) {
        await _pendingOperationsBox.delete(oldest.id);
        debugPrint('💾 [OFFLINE_STORAGE] Removed oldest pending operation: ${oldest.id}');
      }
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error removing oldest pending operation: $e');
    }
  }

  /// تنظيف البيانات القديمة
  Future<void> _cleanOldData() async {
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Cleaning old data...');

      final offlineData = _offlineBox.values.cast<OfflineData>();
      final expiredKeys = <String>[];

      for (final data in offlineData) {
        if (_isDataExpired(data.timestamp)) {
          expiredKeys.add(data.key);
        }
      }

      for (final key in expiredKeys) {
        await _offlineBox.delete(key);
      }

      if (expiredKeys.isNotEmpty) {
        debugPrint('✅ [OFFLINE_STORAGE] Cleaned ${expiredKeys.length} expired data entries');
      }
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error cleaning old data: $e');
    }
  }

  /// حفظ بيانات عامة (generic storage)
  Future<void> set(String key, String value) async {
    await _ensureInitialized();
    
    if (kIsWeb) {
      // Use PlatformStorageService for web
      await _storage.writeSecure(key, value);
      return;
    }
    
    try {
      final offlineData = OfflineData(
        key: key,
        data: {'value': value},
        timestamp: DateTime.now(),
        type: OfflineDataType.fileData,
      );
      await _offlineBox.put(key, offlineData);
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error setting data: $e');
    }
  }

  /// جلب بيانات عامة (generic storage)
  Future<String?> get(String key) async {
    await _ensureInitialized();
    
    if (kIsWeb) {
      // Use PlatformStorageService for web
      return await _storage.readSecure(key);
    }
    
    try {
      final offlineData = _offlineBox.get(key) as OfflineData?;
      if (offlineData == null) return null;
      
      // Check if data is expired
      if (_isDataExpired(offlineData.timestamp)) {
        await _offlineBox.delete(key);
        return null;
      }
      
      return offlineData.data['value'] as String?;
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Error getting data: $e');
      return null;
    }
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      debugPrint('💾 [OFFLINE_STORAGE] Disposing...');
      await _offlineBox.close();
      await _pendingOperationsBox.close();
    } catch (e) {
      debugPrint('❌ [OFFLINE_STORAGE] Disposal error: $e');
    }
  }
}

/// أنواع البيانات المحفوظة محلياً
enum OfflineDataType {
  userData,
  authData,
  profileData,
  fileData,
  messageData,
}

/// نموذج البيانات المحفوظة محلياً
class OfflineData {
  final String key;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final OfflineDataType type;

  OfflineData({
    required this.key,
    required this.data,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
  };

  factory OfflineData.fromJson(Map<String, dynamic> json) => OfflineData(
    key: json['key'],
    data: json['data'],
    timestamp: DateTime.parse(json['timestamp']),
    type: OfflineDataType.values.firstWhere((e) => e.name == json['type']),
  );
}

/// نموذج العملية المعلقة
class PendingOperation {
  final String id;
  final String operation;
  final Map<String, dynamic> data;
  final String? endpoint;
  final DateTime timestamp;
  int retryCount;

  PendingOperation({
    required this.id,
    required this.operation,
    required this.data,
    this.endpoint,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'operation': operation,
    'data': data,
    'endpoint': endpoint,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };

  factory PendingOperation.fromJson(Map<String, dynamic> json) => PendingOperation(
    id: json['id'],
    operation: json['operation'],
    data: json['data'],
    endpoint: json['endpoint'],
    timestamp: DateTime.parse(json['timestamp']),
    retryCount: json['retryCount'] ?? 0,
  );
}

/// Hive Adapter للبيانات المحفوظة محلياً
class OfflineDataAdapter extends TypeAdapter<OfflineData> {
  @override
  final int typeId = 0;

  @override
  OfflineData read(BinaryReader reader) {
    final json = reader.readString();
    return OfflineData.fromJson(jsonDecode(json));
  }

  @override
  void write(BinaryWriter writer, OfflineData obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}

/// Hive Adapter للعمليات المعلقة
class PendingOperationAdapter extends TypeAdapter<PendingOperation> {
  @override
  final int typeId = 1;

  @override
  PendingOperation read(BinaryReader reader) {
    final json = reader.readString();
    return PendingOperation.fromJson(jsonDecode(json));
  }

  @override
  void write(BinaryWriter writer, PendingOperation obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
