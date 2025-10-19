import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'enhanced_session_manager.dart';
import 'platform_storage_service.dart';
import 'unified_token_manager.dart';

/// Configuration for silent token refresh
class SilentRefreshConfig {
  final Duration refreshInterval;
  final Duration tokenExpiryBuffer;
  final int maxRetryAttempts;
  final Duration initialRetryDelay;
  final double retryBackoffMultiplier;
  final Duration maxRetryDelay;
  final bool enableBackgroundRefresh;
  final bool enablePreemptiveRefresh;

  const SilentRefreshConfig({
    this.refreshInterval = const Duration(hours: 2), // تحسين الأداء: كل ساعتين بدلاً من ساعة
    this.tokenExpiryBuffer = const Duration(hours: 8), // زيادة إلى 8 ساعات لتقليل التحديثات غير الضرورية
    this.maxRetryAttempts = 3,
    this.initialRetryDelay = const Duration(seconds: 1),
    this.retryBackoffMultiplier = 2.0,
    this.maxRetryDelay = const Duration(minutes: 5),
    this.enableBackgroundRefresh = true,
    this.enablePreemptiveRefresh = true,
  });
}

/// Retry strategy for token refresh
enum RetryStrategy {
  exponentialBackoff,
  linearBackoff,
  fixedDelay,
  immediate,
}

/// Token refresh attempt result
class RefreshAttemptResult {
  final bool success;
  final String? error;
  final DateTime timestamp;
  final int attemptNumber;
  final Duration delay;

  const RefreshAttemptResult({
    required this.success,
    this.error,
    required this.timestamp,
    required this.attemptNumber,
    required this.delay,
  });
}

/// Silent token refresh statistics
class RefreshStatistics {
  final int totalAttempts;
  final int successfulAttempts;
  final int failedAttempts;
  final DateTime? lastSuccessfulRefresh;
  final DateTime? lastFailedRefresh;
  final List<RefreshAttemptResult> recentAttempts;
  final Duration averageRefreshTime;

  const RefreshStatistics({
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.failedAttempts,
    this.lastSuccessfulRefresh,
    this.lastFailedRefresh,
    required this.recentAttempts,
    required this.averageRefreshTime,
  });

  double get successRate {
    if (totalAttempts == 0) return 0.0;
    return successfulAttempts / totalAttempts;
  }
}

/// Silent Token Refresh Service
/// Handles automatic, silent token refresh with advanced retry logic
class SilentTokenRefreshService {
  static SilentTokenRefreshService? _instance;
  static SilentTokenRefreshService get instance => _instance ??= SilentTokenRefreshService._internal();

  final UnifiedTokenManager _tokenManager;
  final EnhancedSessionManager _sessionManager;
  final PlatformStorageService _storageService;
  final Connectivity _connectivity;

  SilentRefreshConfig _config;
  Timer? _refreshTimer;
  Timer? _preemptiveTimer;
  StreamSubscription? _connectivitySubscription;
  
  bool _isInitialized = false;
  bool _isRefreshing = false;
  bool _isOnline = true;
  
  final List<RefreshAttemptResult> _attemptHistory = [];
  final StreamController<RefreshAttemptResult> _attemptController = StreamController.broadcast();
  final StreamController<RefreshStatistics> _statisticsController = StreamController.broadcast();

  SilentTokenRefreshService._internal()
      : _tokenManager = UnifiedTokenManager.instance,
        _sessionManager = EnhancedSessionManager.instance,
        _storageService = PlatformStorageService.instance,
        _connectivity = Connectivity(),
        _config = const SilentRefreshConfig();

  /// Stream of refresh attempts
  Stream<RefreshAttemptResult> get attemptStream => _attemptController.stream;

  /// Stream of refresh statistics
  Stream<RefreshStatistics> get statisticsStream => _statisticsController.stream;

  /// Current refresh statistics
  RefreshStatistics get statistics => _calculateStatistics();

  /// Check if service is currently refreshing
  bool get isRefreshing => _isRefreshing;

  /// Check if device is online
  bool get isOnline => _isOnline;

  /// Initialize the silent refresh service
  Future<void> initialize({SilentRefreshConfig? config}) async {
    if (_isInitialized) {
      debugPrint('⚠️ [SILENT_REFRESH] Service already initialized');
      return;
    }

    debugPrint('🔄 [SILENT_REFRESH] Initializing Silent Token Refresh Service');

    try {
      // Update configuration if provided
      if (config != null) {
        _config = config;
      }

      // Initialize dependencies
      await _tokenManager.initialize();
      await _sessionManager.initialize();

      // Setup connectivity monitoring
      await _setupConnectivityMonitoring();

      // Start refresh timers if enabled
      if (_config.enableBackgroundRefresh) {
        _startBackgroundRefresh();
      }

      if (_config.enablePreemptiveRefresh) {
        _startPreemptiveRefresh();
      }

      _isInitialized = true;
      debugPrint('✅ [SILENT_REFRESH] Silent Token Refresh Service initialized successfully');
    } catch (e) {
      debugPrint('❌ [SILENT_REFRESH] Initialization failed: $e');
      rethrow;
    }
  }

  /// Setup connectivity monitoring
  Future<void> _setupConnectivityMonitoring() async {
    try {
      // Check initial connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      _isOnline = connectivityResult != ConnectivityResult.none;

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;

        debugPrint('🌐 [SILENT_REFRESH] Connectivity changed: ${_isOnline ? 'Online' : 'Offline'}');

        // If we just came back online, attempt immediate refresh
        if (!wasOnline && _isOnline) {
          _handleBackOnline();
        }
      });

      debugPrint('🌐 [SILENT_REFRESH] Connectivity monitoring setup complete');
    } catch (e) {
      debugPrint('❌ [SILENT_REFRESH] Failed to setup connectivity monitoring: $e');
    }
  }

  /// Handle coming back online
  void _handleBackOnline() {
    debugPrint('🔄 [SILENT_REFRESH] Device back online, checking tokens');
    
    // Schedule immediate token check
    Timer(const Duration(seconds: 2), () {
      if (_isOnline) {
        _performSilentRefresh(reason: 'Back online');
      }
    });
  }

  /// Start background refresh timer
  void _startBackgroundRefresh() {
    _refreshTimer?.cancel();
    
    _refreshTimer = Timer.periodic(_config.refreshInterval, (timer) {
      if (_isOnline && !_isRefreshing) {
        _performSilentRefresh(reason: 'Scheduled refresh');
      }
    });

    debugPrint('🔄 [SILENT_REFRESH] Background refresh started (interval: ${_config.refreshInterval})');
  }

  /// Start preemptive refresh timer
  void _startPreemptiveRefresh() {
    _preemptiveTimer?.cancel();
    
    // Check every 15 minutes for tokens that are about to expire (تحسين الأداء)
    _preemptiveTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      if (_isOnline && !_isRefreshing) {
        _checkPreemptiveRefresh();
      }
    });

    debugPrint('🔄 [SILENT_REFRESH] Preemptive refresh started (every 15 minutes)');
  }

  /// Check if preemptive refresh is needed
  Future<void> _checkPreemptiveRefresh() async {
    try {
      final tokenInfo = await _tokenManager.getTokenInfo();
      
      if (tokenInfo['accessExpiry'] != null) {
        final expiryString = tokenInfo['accessExpiry'] as String;
        final expiry = DateTime.parse(expiryString);
        final timeUntilExpiry = expiry.difference(DateTime.now());
        
        if (timeUntilExpiry <= _config.tokenExpiryBuffer) {
          debugPrint('🔄 [SILENT_REFRESH] Token expires in $timeUntilExpiry, performing preemptive refresh');
          await _performSilentRefresh(reason: 'Preemptive refresh');
        }
      }
    } catch (e) {
      debugPrint('⚠️ [SILENT_REFRESH] Preemptive refresh check failed: $e');
    }
  }

  /// Perform silent token refresh
  Future<bool> _performSilentRefresh({String reason = 'Manual'}) async {
    if (_isRefreshing) {
      debugPrint('⚠️ [SILENT_REFRESH] Refresh already in progress, skipping');
      return false;
    }

    if (!_isOnline) {
      debugPrint('⚠️ [SILENT_REFRESH] Device offline, skipping refresh');
      return false;
    }

    _isRefreshing = true;
    final startTime = DateTime.now();

    debugPrint('🔄 [SILENT_REFRESH] Starting silent refresh (reason: $reason)');

    try {
      // Check if we have tokens to refresh
      final hasTokens = await _tokenManager.hasValidRefreshToken();
      if (!hasTokens) {
        debugPrint('ℹ️ [SILENT_REFRESH] No tokens to refresh');
        return false;
      }

      // Perform refresh with retry logic
      final success = await _refreshWithRetry();
      
      final duration = DateTime.now().difference(startTime);
      
      if (success) {
        debugPrint('✅ [SILENT_REFRESH] Silent refresh completed successfully in ${duration.inMilliseconds}ms');
        await _sessionManager.updateActivity();
      } else {
        debugPrint('❌ [SILENT_REFRESH] Silent refresh failed after all retries');
      }

      return success;
    } catch (e) {
      debugPrint('❌ [SILENT_REFRESH] Silent refresh error: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refresh tokens with retry logic
  Future<bool> _refreshWithRetry() async {
    for (int attempt = 1; attempt <= _config.maxRetryAttempts; attempt++) {
      final attemptStartTime = DateTime.now();
      
      try {
        debugPrint('🔄 [SILENT_REFRESH] Refresh attempt $attempt/${_config.maxRetryAttempts}');
        
        final success = await _tokenManager.refreshAccessToken();
        
        final result = RefreshAttemptResult(
          success: success,
          timestamp: attemptStartTime,
          attemptNumber: attempt,
          delay: Duration.zero,
        );
        
        _recordAttempt(result);
        
        if (success) {
          debugPrint('✅ [SILENT_REFRESH] Refresh successful on attempt $attempt');
          return true;
        } else {
          debugPrint('❌ [SILENT_REFRESH] Refresh failed on attempt $attempt');
        }
      } catch (e) {
        debugPrint('❌ [SILENT_REFRESH] Refresh attempt $attempt failed: $e');
        
        final result = RefreshAttemptResult(
          success: false,
          error: e.toString(),
          timestamp: attemptStartTime,
          attemptNumber: attempt,
          delay: Duration.zero,
        );
        
        _recordAttempt(result);
      }

      // If not the last attempt, wait before retrying
      if (attempt < _config.maxRetryAttempts) {
        final delay = _calculateRetryDelay(attempt);
        debugPrint('⏳ [SILENT_REFRESH] Waiting ${delay.inSeconds}s before retry');
        await Future.delayed(delay);
      }
    }

    return false;
  }

  /// Calculate retry delay based on strategy
  Duration _calculateRetryDelay(int attemptNumber) {
    switch (RetryStrategy.exponentialBackoff) {
      case RetryStrategy.exponentialBackoff:
        final delay = Duration(
          milliseconds: (_config.initialRetryDelay.inMilliseconds * 
                        pow(_config.retryBackoffMultiplier, attemptNumber - 1)).round(),
        );
        return delay > _config.maxRetryDelay ? _config.maxRetryDelay : delay;
        
      case RetryStrategy.linearBackoff:
        final delay = Duration(
          milliseconds: _config.initialRetryDelay.inMilliseconds * attemptNumber,
        );
        return delay > _config.maxRetryDelay ? _config.maxRetryDelay : delay;
        
      case RetryStrategy.fixedDelay:
        return _config.initialRetryDelay;
        
      case RetryStrategy.immediate:
        return Duration.zero;
    }
  }

  /// Record refresh attempt
  void _recordAttempt(RefreshAttemptResult result) {
    _attemptHistory.add(result);
    
    // Keep only recent attempts (last 100)
    if (_attemptHistory.length > 100) {
      _attemptHistory.removeAt(0);
    }

    // Broadcast attempt
    _attemptController.add(result);
    
    // Update statistics
    _statisticsController.add(_calculateStatistics());
  }

  /// Calculate refresh statistics
  RefreshStatistics _calculateStatistics() {
    if (_attemptHistory.isEmpty) {
      return const RefreshStatistics(
        totalAttempts: 0,
        successfulAttempts: 0,
        failedAttempts: 0,
        recentAttempts: [],
        averageRefreshTime: Duration.zero,
      );
    }

    final successful = _attemptHistory.where((a) => a.success).toList();
    final failed = _attemptHistory.where((a) => !a.success).toList();
    
    final lastSuccessful = successful.isNotEmpty ? successful.last.timestamp : null;
    final lastFailed = failed.isNotEmpty ? failed.last.timestamp : null;
    
    // Calculate average refresh time (for successful attempts)
    Duration averageTime = Duration.zero;
    if (successful.isNotEmpty) {
      final totalTime = successful.fold<int>(0, (sum, attempt) => sum + attempt.delay.inMilliseconds);
      averageTime = Duration(milliseconds: totalTime ~/ successful.length);
    }

    return RefreshStatistics(
      totalAttempts: _attemptHistory.length,
      successfulAttempts: successful.length,
      failedAttempts: failed.length,
      lastSuccessfulRefresh: lastSuccessful,
      lastFailedRefresh: lastFailed,
      recentAttempts: _attemptHistory.take(10).toList(),
      averageRefreshTime: averageTime,
    );
  }

  /// Manually trigger silent refresh
  Future<bool> triggerRefresh({String reason = 'Manual trigger'}) async {
    debugPrint('🔄 [SILENT_REFRESH] Manual refresh triggered');
    return await _performSilentRefresh(reason: reason);
  }

  /// Update configuration
  void updateConfig(SilentRefreshConfig newConfig) {
    debugPrint('⚙️ [SILENT_REFRESH] Updating configuration');
    
    _config = newConfig;
    
    // Restart timers with new configuration
    if (_config.enableBackgroundRefresh) {
      _startBackgroundRefresh();
    } else {
      _refreshTimer?.cancel();
    }
    
    if (_config.enablePreemptiveRefresh) {
      _startPreemptiveRefresh();
    } else {
      _preemptiveTimer?.cancel();
    }
  }

  /// Pause silent refresh
  void pause() {
    debugPrint('⏸️ [SILENT_REFRESH] Pausing silent refresh');
    _refreshTimer?.cancel();
    _preemptiveTimer?.cancel();
  }

  /// Resume silent refresh
  void resume() {
    debugPrint('▶️ [SILENT_REFRESH] Resuming silent refresh');
    
    if (_config.enableBackgroundRefresh) {
      _startBackgroundRefresh();
    }
    
    if (_config.enablePreemptiveRefresh) {
      _startPreemptiveRefresh();
    }
  }

  /// Dispose the service
  void dispose() {
    debugPrint('🗑️ [SILENT_REFRESH] Disposing Silent Token Refresh Service');
    
    _refreshTimer?.cancel();
    _preemptiveTimer?.cancel();
    _connectivitySubscription?.cancel();
    _attemptController.close();
    _statisticsController.close();
    
    _isInitialized = false;
  }
}

/// Extension for easy access to silent refresh service
extension SilentRefreshExtension on UnifiedTokenManager {
  /// Get the silent refresh service instance
  SilentTokenRefreshService get silentRefresh => SilentTokenRefreshService.instance;
}
