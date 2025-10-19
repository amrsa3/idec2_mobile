import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for implementing lazy loading with offline support
class LazyLoadingService {
  static LazyLoadingService? _instance;
  static LazyLoadingService get instance => _instance ??= LazyLoadingService._();

  LazyLoadingService._();

  final Map<String, CachedData> _memoryCache = {};
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

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
      // Check memory cache first
      if (!forceRefresh && _memoryCache.containsKey(key)) {
        final cached = _memoryCache[key]!;
        if (!cached.isExpired) {
          return fromJson(cached.data);
        }
      }

      // Check persistent cache if offline or cache is valid
      if (!_isOnline || !forceRefresh) {
        final cachedData = await _loadFromCache(key);
        if (cachedData != null) {
          final cached = CachedData.fromJson(cachedData);
          if (!cached.isExpired || !_isOnline) {
            _memoryCache[key] = cached;
            return fromJson(cached.data);
          }
        }
      }

      // Load from network if online
      if (_isOnline) {
        try {
          final data = await onlineLoader();
          await _saveToCache(key, data, cacheExpiry);
          return data;
        } catch (e) {
          debugPrint('❌ [LAZY_LOADING] Network error for $key: $e');
          // Fallback to cache if network fails
          final cachedData = await _loadFromCache(key);
          if (cachedData != null) {
            final cached = CachedData.fromJson(cachedData);
            _memoryCache[key] = cached;
            return fromJson(cached.data);
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
      // Check memory cache first
      if (!forceRefresh && _memoryCache.containsKey(pageKey)) {
        final cached = _memoryCache[pageKey]!;
        if (!cached.isExpired) {
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
          if (!cached.isExpired || !_isOnline) {
            _memoryCache[pageKey] = cached;
            return (cached.data['items'] as List)
                .map((item) => fromJson(item))
                .toList();
          }
        }
      }

      // Load from network if online
      if (_isOnline) {
        try {
          final items = await onlineLoader(page, limit);
          final dataToCache = {
            'items': items.map((item) => (item as dynamic).toJson()).toList(),
            'page': page,
            'limit': limit,
            'total': items.length,
          };
          await _saveToCache(pageKey, dataToCache, cacheExpiry);
          return items;
        } catch (e) {
          debugPrint('❌ [LAZY_LOADING] Network error for $pageKey: $e');
          // Fallback to cache if network fails
          final cachedData = await _loadFromCache(pageKey);
          if (cachedData != null) {
            final cached = CachedData.fromJson(cachedData);
            _memoryCache[pageKey] = cached;
            return (cached.data['items'] as List)
                .map((item) => fromJson(item))
                .toList();
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
      final cachedData = CachedData(
        data: data is Map<String, dynamic> ? data : (data as dynamic).toJson(),
        timestamp: DateTime.now(),
        expiry: expiry,
      );
      
      _memoryCache[key] = cachedData;
      await prefs.setString('lazy_cache_$key', jsonEncode(cachedData.toJson()));
      
      debugPrint('✅ [LAZY_LOADING] Cached data for $key');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error saving cache for $key: $e');
    }
  }

  /// Load data from cache
  Future<Map<String, dynamic>?> _loadFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('lazy_cache_$key');
      
      if (cachedJson != null) {
        return jsonDecode(cachedJson);
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lazy_cache_$key');
      debugPrint('✅ [LAZY_LOADING] Cleared cache for $key');
    } catch (e) {
      debugPrint('❌ [LAZY_LOADING] Error clearing cache for $key: $e');
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      _memoryCache.clear();
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

  CachedData({
    required this.data,
    required this.timestamp,
    required this.expiry,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > expiry;

  Map<String, dynamic> toJson() => {
    'data': data,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'expiry_minutes': expiry.inMinutes,
  };

  factory CachedData.fromJson(Map<String, dynamic> json) => CachedData(
    data: json['data'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    expiry: Duration(minutes: json['expiry_minutes']),
  );
}