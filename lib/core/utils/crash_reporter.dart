import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Simple crash reporter for logging errors
/// In production, this could be integrated with services like Firebase Crashlytics
class CrashReporter {
  static final List<CrashReport> _reports = [];
  static const int _maxReports = 100;

  /// Record an error for reporting
  static void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, dynamic>? customData,
  }) {
    final report = CrashReport(
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      fatal: fatal,
      customData: customData,
    );

    _reports.add(report);
    
    // Keep only the most recent reports
    if (_reports.length > _maxReports) {
      _reports.removeAt(0);
    }

    // Log in debug mode
    if (kDebugMode) {
      developer.log(
        'Crash recorded: ${fatal ? 'FATAL' : 'NON-FATAL'} - $error',
        name: 'CrashReporter',
        error: error,
        stackTrace: stackTrace,
      );
    }

    // In production, send to crash reporting service
    if (kReleaseMode) {
      _sendToService(report);
    }
  }

  /// Record a custom log message
  static void log(String message, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      developer.log(message, name: 'CrashReporter');
    }
    
    // In production, send to logging service
    if (kReleaseMode) {
      _sendLogToService(message, data);
    }
  }

  /// Get all recorded crash reports
  static List<CrashReport> getReports() {
    return List.unmodifiable(_reports);
  }

  /// Clear all reports
  static void clearReports() {
    _reports.clear();
  }

  /// Send crash report to external service (placeholder)
  static Future<void> _sendToService(CrashReport report) async {
    // TODO: Implement actual crash reporting service integration
    // For example: Firebase Crashlytics, Sentry, etc.
    
    try {
      // Simulate sending to service
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (kDebugMode) {
        developer.log(
          'Crash report sent to service',
          name: 'CrashReporter',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to send crash report: $e',
          name: 'CrashReporter',
        );
      }
    }
  }

  /// Send log message to external service (placeholder)
  static Future<void> _sendLogToService(
    String message,
    Map<String, dynamic>? data,
  ) async {
    // TODO: Implement actual logging service integration
    
    try {
      // Simulate sending to service
      await Future.delayed(const Duration(milliseconds: 50));
      
      if (kDebugMode) {
        developer.log(
          'Log sent to service: $message',
          name: 'CrashReporter',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to send log: $e',
          name: 'CrashReporter',
        );
      }
    }
  }

  /// Set user identifier for crash reports
  static void setUserId(String userId) {
    // TODO: Set user ID in crash reporting service
    if (kDebugMode) {
      developer.log('User ID set: $userId', name: 'CrashReporter');
    }
  }

  /// Set custom key-value data for crash reports
  static void setCustomKey(String key, dynamic value) {
    // TODO: Set custom key in crash reporting service
    if (kDebugMode) {
      developer.log('Custom key set: $key = $value', name: 'CrashReporter');
    }
  }
}

/// Represents a crash report
class CrashReport {
  final dynamic error;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final bool fatal;
  final Map<String, dynamic>? customData;

  CrashReport({
    required this.error,
    this.stackTrace,
    required this.timestamp,
    this.fatal = false,
    this.customData,
  });

  Map<String, dynamic> toJson() {
    return {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': timestamp.toIso8601String(),
      'fatal': fatal,
      'customData': customData,
    };
  }

  @override
  String toString() {
    return 'CrashReport(error: $error, fatal: $fatal, timestamp: $timestamp)';
  }
}
