import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance Monitor
/// Tracks app performance metrics
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  static PerformanceMonitor get instance => _instance;
  PerformanceMonitor._internal();

  // Metrics storage
  final Map<String, List<Duration>> _operationDurations = {};
  final Map<String, int> _operationCounts = {};
  final Map<String, DateTime> _lastOperationTime = {};
  
  // Configuration
  static const int maxStoredDurations = 100;
  bool _enabled = kDebugMode;

  /// Enable/disable monitoring
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Start timing an operation
  Stopwatch startOperation(String operationName) {
    if (!_enabled) return Stopwatch();
    
    final stopwatch = Stopwatch()..start();
    return stopwatch;
  }

  /// End timing and record the duration
  void endOperation(String operationName, Stopwatch stopwatch) {
    if (!_enabled) return;
    
    stopwatch.stop();
    final duration = stopwatch.elapsed;
    
    // Store duration
    _operationDurations.putIfAbsent(operationName, () => []);
    _operationDurations[operationName]!.add(duration);
    
    // Limit stored durations
    if (_operationDurations[operationName]!.length > maxStoredDurations) {
      _operationDurations[operationName]!.removeAt(0);
    }
    
    // Update counts
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    _lastOperationTime[operationName] = DateTime.now();
    
    // Log slow operations
    if (duration.inMilliseconds > 500) {
      debugPrint('⚠️ [Performance] Slow operation: $operationName took ${duration.inMilliseconds}ms');
    }
  }

  /// Measure an async operation
  Future<T> measureAsync<T>(String operationName, Future<T> Function() operation) async {
    if (!_enabled) return operation();
    
    final stopwatch = startOperation(operationName);
    try {
      return await operation();
    } finally {
      endOperation(operationName, stopwatch);
    }
  }

  /// Measure a sync operation
  T measure<T>(String operationName, T Function() operation) {
    if (!_enabled) return operation();
    
    final stopwatch = startOperation(operationName);
    try {
      return operation();
    } finally {
      endOperation(operationName, stopwatch);
    }
  }

  /// Get average duration for an operation
  Duration? getAverageDuration(String operationName) {
    final durations = _operationDurations[operationName];
    if (durations == null || durations.isEmpty) return null;
    
    final totalMs = durations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
    return Duration(milliseconds: totalMs ~/ durations.length);
  }

  /// Get operation count
  int getOperationCount(String operationName) {
    return _operationCounts[operationName] ?? 0;
  }

  /// Get all metrics
  Map<String, dynamic> getAllMetrics() {
    final metrics = <String, dynamic>{};
    
    for (final operation in _operationDurations.keys) {
      final avg = getAverageDuration(operation);
      final count = getOperationCount(operation);
      final last = _lastOperationTime[operation];
      
      metrics[operation] = {
        'averageMs': avg?.inMilliseconds,
        'count': count,
        'lastRun': last?.toIso8601String(),
      };
    }
    
    return metrics;
  }

  /// Print metrics summary
  void printSummary() {
    if (!_enabled) return;
    
    debugPrint('📊 [Performance] Metrics Summary:');
    for (final operation in _operationDurations.keys) {
      final avg = getAverageDuration(operation);
      final count = getOperationCount(operation);
      debugPrint('  $operation: avg=${avg?.inMilliseconds}ms, count=$count');
    }
  }

  /// Clear all metrics
  void clear() {
    _operationDurations.clear();
    _operationCounts.clear();
    _lastOperationTime.clear();
  }
}

// Global instance
final perfMonitor = PerformanceMonitor.instance;

/// Extension for easy measurement
extension PerformanceExtension<T> on Future<T> {
  /// Measure this future's execution time
  Future<T> measured(String operationName) {
    return perfMonitor.measureAsync(operationName, () => this);
  }
}
