import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'compatible_auth_service.dart';

/// Service for implementing lazy loading with offline support
class LazyLoadingService {
  static LazyLoadingService? _instance;
  static LazyLoadingService get instance => _instance ??= LazyLoadingService._();

  LazyLoadingService._();

  final Map<String, CachedData> _memoryCache = {};
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  
  // Request deduplication - track ongoing requests
  final Map<String, Completer<dynamic>> _ongoingRequests = {};
  
  /// Get current user ID for cache validation
  String? _getCurrentUserId() {
    try {
      final authService = CompatibleAuthService.instance;
      final user = authService.user;
      return user?.id;
    } catch (e) {
      debugPrint('⚠️ [LAZY_LOADING] Error getting current user ID: $e');
      return null;
    }
  }

  /// Initialize the service
  Future<void> initialize() async {
    await _checkConnectivity();
    _setupConnectivityListener();
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
  }

  /// Setup connectivity listener
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      if (_isOnline) {
        _syncPendingData();
      }
    });
  }

  /// Load data with lazy loading and offline support
  Future<T?> loadData<T>({
    required String key,
    required Future<T> Function() onlineLoader,
    required T Function(Map<String, dynamic>) fromJson,
    Duration cacheExpiry = const Duration(hours: 24),
    bool forceRefresh = false,
  }) async {
    try {
      // Check memory cache first with user ID validation
      if (!forceRefresh && _memoryCache.containsKey(key)) {
        final cached = _memoryCache[key]!;
        final currentUserId = _getCurrentUserId();
        
        // التحقق من userId قبل استخدام الكاش
        if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
          debugPrint('⚠️ [LAZY_LOADING] Memory cache userId mismatch for $key, clearing');
          _memoryCache.remove(key);
        } else if (!cached.isExpired) {
          return fromJson(cached.data);
        }
      }

      // Check persistent cache if offline or cache is valid
      if (!_isOnline || !forceRefresh) {
        final cachedData = await _loadFromCache(key);
        if (cachedData != null) {
          final cached = CachedData.fromJson(cachedData);
          final currentUserId = _getCurrentUserId();
          
          // التحقق من userId قبل استخدام الكاش
          if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
            debugPrint('⚠️ [LAZY_LOADING] Persistent cache userId mismatch for $key, clearing');
            await clearCache(key);
          } else if (!cached.isExpired || !_isOnline) {
            _memoryCache[key] = cached;
            return fromJson(cached.data);
          }
        }
      }

      // Load from network if online
      if (_isOnline) {
        // Check if there's an ongoing request for this key
        if (_ongoingRequests.containsKey(key)) {
          debugPrint('🔄 [LAZY_LOADING] Reusing ongoing request for $key');
          try {
            final result = await _ongoingRequests[key]!.future;
            return result as T;
          } catch (e) {
            // If the ongoing request failed, fall back to cache
            debugPrint('⚠️ [LAZY_LOADING] Ongoing request failed for $key, falling back to cache');
            final cachedData = await _loadFromCache(key);
            if (cachedData != null) {
              final cached = CachedData.fromJson(cachedData);
              final currentUserId = _getCurrentUserId();
              
              if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
                return null;
              } else if (!cached.isExpired || !_isOnline) {
                _memoryCache[key] = cached;
                return fromJson(cached.data);
              }
            }
            return null;
          }
        }
        
        // Create a new request
        final completer = Completer<T?>();
        _ongoingRequests[key] = completer;
        
        try {
          final data = await onlineLoader();
          await _saveToCache(key, data, cacheExpiry);
          
          // Complete the request and remove from ongoing requests
          completer.complete(data);
          _ongoingRequests.remove(key);
          
          return data;
        } catch (e) {
          debugPrint('❌ [LAZY_LOADING] Network error for $key: $e');
          
          // Complete with error
          completer.completeError(e);
          _ongoingRequests.remove(key);
          
          // Fallback to cache if network fails
          final cachedData = await _loadFromCache(key);
          if (cachedData != null) {
            final cached = CachedData.fromJson(cachedData);
            final currentUserId = _getCurrentUserId();
            
            if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
              return null;
            } else if (!cached.isExpired || !_isOnline) {
              _memoryCache[key] = cached;
              return fromJson(cached.data);
            }
          }
          rethrow;
        }
      }

      return null;
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error loading data for $key: $e');
      return null;
    }
  }

  /// Load list data with pagination support
  Future<List<T>> loadListData<T>({
    required String key,
    required Future<List<T>> Function(int page, int limit) onlineLoader,
    required T Function(Map<String, dynamic>) fromJson,
    int page = 1,
    int limit = 20,
    Duration cacheExpiry = const Duration(hours: 6),
    bool forceRefresh = false,
  }) async {
    final pageKey = '${key}_page_${page}_limit_$limit';
    
    try {
      // Check memory cache first with user ID validation
      if (!forceRefresh && _memoryCache.containsKey(pageKey)) {
        final cached = _memoryCache[pageKey]!;
        final currentUserId = _getCurrentUserId();
        
        // التحقق من userId قبل استخدام الكاش
        if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
          debugPrint('⚠️ [LAZY_LOADING] Memory cache userId mismatch for $pageKey, clearing');
          _memoryCache.remove(pageKey);
        } else if (!cached.isExpired) {
          return (cached.data['items'] as List)
              .map((item) => fromJson(item))
              .toList();
        }
      }

      // Check persistent cache if offline or cache is valid
      if (!_isOnline || !forceRefresh) {
        final cachedData = await _loadFromCache(pageKey);
        if (cachedData != null) {
          final cached = CachedData.fromJson(cachedData);
          final currentUserId = _getCurrentUserId();
          
          // التحقق من userId قبل استخدام الكاش
          if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
            debugPrint('⚠️ [LAZY_LOADING] Persistent cache userId mismatch for $pageKey, clearing');
            await clearCache(pageKey);
          } else if (!cached.isExpired || !_isOnline) {
            _memoryCache[pageKey] = cached;
            return (cached.data['items'] as List)
                .map((item) => fromJson(item))
                .toList();
          }
        }
      }

      // Load from network if online
      if (_isOnline) {
        // Check if there's an ongoing request for this page key
        if (_ongoingRequests.containsKey(pageKey)) {
          debugPrint('🔄 [LAZY_LOADING] Reusing ongoing request for $pageKey');
          try {
            final result = await _ongoingRequests[pageKey]!.future;
            return result as List<T>;
          } catch (e) {
            // If the ongoing request failed, fall back to cache
            debugPrint('⚠️ [LAZY_LOADING] Ongoing request failed for $pageKey, falling back to cache');
            final cachedData = await _loadFromCache(pageKey);
            if (cachedData != null) {
              final cached = CachedData.fromJson(cachedData);
              final currentUserId = _getCurrentUserId();
              
              if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
                return [];
              } else if (!cached.isExpired || !_isOnline) {
                _memoryCache[pageKey] = cached;
                return (cached.data['items'] as List)
                    .map((item) => fromJson(item))
                    .toList();
              }
            }
            return [];
          }
        }
        
        // Create a new request
        final completer = Completer<List<T>>();
        _ongoingRequests[pageKey] = completer;
        
        try {
          final items = await onlineLoader(page, limit);
          final dataToCache = {
            'items': items.map((item) => (item as dynamic).toJson()).toList(),
            'page': page,
            'limit': limit,
            'total': items.length,
          };
          await _saveToCache(pageKey, dataToCache, cacheExpiry);
          
          // Complete the request and remove from ongoing requests
          completer.complete(items);
          _ongoingRequests.remove(pageKey);
          
          return items;
        } catch (e) {
          debugPrint('❌ [LAZY_LOADING] Network error for $pageKey: $e');
          
          // Complete with error
          completer.completeError(e);
          _ongoingRequests.remove(pageKey);
          
          // Fallback to cache if network fails
          final cachedData = await _loadFromCache(pageKey);
          if (cachedData != null) {
            final cached = CachedData.fromJson(cachedData);
            final currentUserId = _getCurrentUserId();
            
            if (currentUserId != null && cached.userId != null && currentUserId != cached.userId) {
              return [];
            } else if (!cached.isExpired || !_isOnline) {
              _memoryCache[pageKey] = cached;
              return (cached.data['items'] as List)
                  .map((item) => fromJson(item))
                  .toList();
            }
          }
          return [];
        }
      }

      return [];
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error loading list data for $pageKey: $e');
      return [];
    }
  }

  /// Save data to cache
  Future<void> _saveToCache(String key, dynamic data, Duration expiry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = _getCurrentUserId();
      
      final cachedData = CachedData(
        data: data is Map<String, dynamic> ? data : (data as dynamic).toJson(),
        timestamp: DateTime.now(),
        expiry: expiry,
        userId: currentUserId, // حفظ userId مع الكاش
      );
      
      _memoryCache[key] = cachedData;
      await prefs.setString('lazy_cache_$key', jsonEncode(cachedData.toJson()));
      
      // حفظ userId بشكل منفصل للتحقق السريع
      if (currentUserId != null) {
        await prefs.setString('lazy_cache_${key}_user_id', currentUserId);
      }
      
      debugPrint('✅ [LAZY_LOADING] Cached data for $key (userId: ${currentUserId ?? "none"})');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error saving cache for $key: $e');
    }
  }

  /// Load data from cache with user ID validation
  Future<Map<String, dynamic>?> _loadFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = _getCurrentUserId();
      final cachedJson = prefs.getString('lazy_cache_$key');
      final cachedUserId = prefs.getString('lazy_cache_${key}_user_id');
      
      if (cachedJson != null) {
        // التحقق من userId قبل استخدام الكاش
        if (currentUserId != null && cachedUserId != null) {
          if (currentUserId != cachedUserId) {
            debugPrint('⚠️ [LAZY_LOADING] Cached data userId ($cachedUserId) does not match current userId ($currentUserId) for $key, clearing cache');
            await clearCache(key);
            return null;
          }
        }
        
        final cachedData = jsonDecode(cachedJson);
        
        // التحقق من userId في البيانات المحفوظة أيضاً
        if (cachedData is Map<String, dynamic> && cachedData.containsKey('userId')) {
          final dataUserId = cachedData['userId'] as String?;
          if (currentUserId != null && dataUserId != null && currentUserId != dataUserId) {
            debugPrint('⚠️ [LAZY_LOADING] Cached data userId ($dataUserId) does not match current userId ($currentUserId) for $key, clearing cache');
            await clearCache(key);
            return null;
          }
        }
        
        return cachedData;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error loading cache for $key: $e');
      return null;
    }
  }

  /// Clear cache for specific key
  Future<void> clearCache(String key) async {
    try {
      _memoryCache.remove(key);
      // Cancel any ongoing request for this key
      _ongoingRequests.remove(key)?.completeError(Exception('Cache cleared'));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lazy_cache_$key');
      await prefs.remove('lazy_cache_${key}_user_id'); // مسح userId أيضاً
      debugPrint('✅ [LAZY_LOADING] Cleared cache for $key');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error clearing cache for $key: $e');
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      _memoryCache.clear();
      // Cancel all ongoing requests
      for (final completer in _ongoingRequests.values) {
        completer.completeError(Exception('All cache cleared'));
      }
      _ongoingRequests.clear();
      
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('lazy_cache_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
      debugPrint('✅ [LAZY_LOADING] Cleared all cache');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error clearing all cache: $e');
    }
  }
  
  /// Clear cache for a specific user (when user logs out or changes)
  Future<void> clearCacheForUser(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keysToRemove = <String>[];
      
      // البحث عن جميع المفاتيح المرتبطة بهذا المستخدم
      for (final key in prefs.getKeys()) {
        if (key.startsWith('lazy_cache_')) {
          final userIdKey = '${key}_user_id';
          final cachedUserId = prefs.getString(userIdKey);
          if (cachedUserId == userId) {
            keysToRemove.add(key);
            keysToRemove.add(userIdKey);
          }
        }
      }
      
      // مسح المفاتيح من الذاكرة
      for (final key in keysToRemove) {
        final cleanKey = key.replaceFirst('lazy_cache_', '').replaceFirst('_user_id', '');
        _memoryCache.remove(cleanKey);
      }
      
      // مسح المفاتيح من التخزين
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }
      
      debugPrint('✅ [LAZY_LOADING] Cleared cache for user $userId (${keysToRemove.length} keys)');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error clearing cache for user: $e');
    }
  }

  /// Sync pending data when back online
  Future<void> _syncPendingData() async {
    debugPrint('🔄 [LAZY_LOADING] Syncing pending data...');
    // Implementation for syncing pending operations
    // This would be specific to your app's requirements
  }

  /// Check if device is online
  bool get isOnline => _isOnline;

  /// Get cache size
  Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('lazy_cache_'));
      int totalSize = 0;
      
      for (final key in keys) {
        final value = prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
        }
      }
      
      return totalSize;
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error calculating cache size: $e');
      return 0;
    }
  }
}

/// Cached data model
class CachedData {
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final Duration expiry;
  final String? userId; // User ID for cache validation

  CachedData({
    required this.data,
    required this.timestamp,
    required this.expiry,
    this.userId,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > expiry;

  Map<String, dynamic> toJson() => {
    'data': data,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'expiry_minutes': expiry.inMinutes,
    if (userId != null) 'userId': userId,
  };

  factory CachedData.fromJson(Map<String, dynamic> json) => CachedData(
    data: json['data'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    expiry: Duration(minutes: json['expiry_minutes']),
    userId: json['userId'] as String?,
  );
}