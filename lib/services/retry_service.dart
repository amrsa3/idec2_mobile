import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service for handling retry logic and offline operations
class RetryService {
  static RetryService? _instance;
  static RetryService get instance => _instance ??= RetryService._();

  RetryService._();

  final List<QueuedOperation> _offlineQueue = [];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = true;

  /// Initialize the retry service
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    
    // Check initial connectivity
    _checkConnectivity();
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Execute operation with retry logic
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool exponentialBackoff = true,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt <= maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempt++;
        
        if (attempt > maxRetries) {
          rethrow;
        }

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }

        // Default retry logic for common errors
        if (!_shouldRetryByDefault(error)) {
          rethrow;
        }

        if (kDebugMode) {
          debugPrint('Retry attempt $attempt/$maxRetries after ${delay.inMilliseconds}ms');
        }

        await Future.delayed(delay);

        if (exponentialBackoff) {
          delay = Duration(
            milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
          );
        }
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Queue operation for offline execution
  void queueOfflineOperation(QueuedOperation operation) {
    _offlineQueue.add(operation);
    
    if (kDebugMode) {
      debugPrint('Operation queued for offline execution: ${operation.id}');
    }
  }

  /// Execute all queued operations when online
  Future<void> executeQueuedOperations() async {
    if (!_isOnline || _offlineQueue.isEmpty) {
      return;
    }

    final operations = List<QueuedOperation>.from(_offlineQueue);
    _offlineQueue.clear();

    for (final operation in operations) {
      try {
        await executeWithRetry(
          operation.operation,
          maxRetries: operation.maxRetries,
          shouldRetry: operation.shouldRetry,
        );
        
        operation.onSuccess?.call();
        
        if (kDebugMode) {
          debugPrint('Queued operation executed successfully: ${operation.id}');
        }
      } catch (error) {
        operation.onError?.call(error);
        
        if (kDebugMode) {
          debugPrint('Queued operation failed: ${operation.id} - $error');
        }
        
        // Re-queue if it should be retried
        if (operation.retryWhenOnline && _shouldRetryByDefault(error)) {
          _offlineQueue.add(operation);
        }
      }
    }
  }

  /// Get queued operations count
  int get queuedOperationsCount => _offlineQueue.length;

  /// Clear all queued operations
  void clearQueue() {
    _offlineQueue.clear();
  }

  /// Check if device is online
  bool get isOnline => _isOnline;

  /// Handle connectivity changes
  void _onConnectivityChanged(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;

    if (!wasOnline && _isOnline) {
      // Device came back online, execute queued operations
      executeQueuedOperations();
    }
  }

  /// Check current connectivity
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
    } catch (e) {
      _isOnline = false;
    }
  }

  /// Default retry logic for common errors
  bool _shouldRetryByDefault(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Network-related errors that should be retried
    if (errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('socket')) {
      return true;
    }

    // HTTP status codes that should be retried
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }

    return false;
  }
}

/// Represents an operation that can be queued for offline execution
class QueuedOperation {
  final String id;
  final Future<dynamic> Function() operation;
  final int maxRetries;
  final bool retryWhenOnline;
  final bool Function(dynamic error)? shouldRetry;
  final VoidCallback? onSuccess;
  final void Function(dynamic error)? onError;
  final DateTime createdAt;

  QueuedOperation({
    required this.id,
    required this.operation,
    this.maxRetries = 3,
    this.retryWhenOnline = true,
    this.shouldRetry,
    this.onSuccess,
    this.onError,
  }) : createdAt = DateTime.now();

  /// Create a unique ID for the operation
  static String generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}

/// Retry configuration for different operation types
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final bool exponentialBackoff;
  final bool Function(dynamic error)? shouldRetry;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.exponentialBackoff = true,
    this.shouldRetry,
  });

  /// Configuration for API calls
  static const RetryConfig api = RetryConfig(
    maxRetries: 3,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 2.0,
    exponentialBackoff: true,
  );

  /// Configuration for file uploads
  static const RetryConfig fileUpload = RetryConfig(
    maxRetries: 5,
    initialDelay: Duration(seconds: 2),
    backoffMultiplier: 1.5,
    exponentialBackoff: true,
  );

  /// Configuration for critical operations
  static const RetryConfig critical = RetryConfig(
    maxRetries: 5,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 2.0,
    exponentialBackoff: true,
  );

  /// Configuration for non-critical operations
  static const RetryConfig nonCritical = RetryConfig(
    maxRetries: 2,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 1.5,
    exponentialBackoff: false,
  );
}

/// Extension for easy retry functionality
extension RetryExtension<T> on Future<T> {
  /// Add retry functionality to any Future
  Future<T> withRetry({
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool exponentialBackoff = true,
    bool Function(dynamic error)? shouldRetry,
  }) {
    return RetryService.instance.executeWithRetry(
      () => this,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
      backoffMultiplier: backoffMultiplier,
      exponentialBackoff: exponentialBackoff,
      shouldRetry: shouldRetry,
    );
  }

  /// Add retry with predefined configuration
  Future<T> withRetryConfig(RetryConfig config) {
    return RetryService.instance.executeWithRetry(
      () => this,
      maxRetries: config.maxRetries,
      initialDelay: config.initialDelay,
      backoffMultiplier: config.backoffMultiplier,
      exponentialBackoff: config.exponentialBackoff,
      shouldRetry: config.shouldRetry,
    );
  }
}
