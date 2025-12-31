import 'package:flutter/foundation.dart';

/// App Logger
/// Centralized logging service that can be easily disabled in production
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;
  AppLogger._internal();

  // Configuration
  bool _enabled = kDebugMode;
  bool _verboseEnabled = false;
  final List<LogEntry> _logHistory = [];
  static const int _maxHistorySize = 500;

  // Log levels
  static const String _info = 'ℹ️';
  static const String _success = '✅';
  static const String _warning = '⚠️';
  static const String _error = '❌';
  static const String _debug = '🔍';
  static const String _network = '🌐';
  static const String _storage = '💾';
  static const String _auth = '🔐';
  static const String _chat = '💬';

  /// Enable or disable logging
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Enable verbose logging
  void setVerbose(bool verbose) {
    _verboseEnabled = verbose;
  }

  /// Get log history
  List<LogEntry> get history => List.unmodifiable(_logHistory);

  /// Clear log history
  void clearHistory() {
    _logHistory.clear();
  }

  // ============== LOG METHODS ==============

  /// Log info message
  void info(String tag, String message) {
    _log(_info, tag, message, LogLevel.info);
  }

  /// Log success message
  void success(String tag, String message) {
    _log(_success, tag, message, LogLevel.info);
  }

  /// Log warning message
  void warning(String tag, String message) {
    _log(_warning, tag, message, LogLevel.warning);
  }

  /// Log error message
  void error(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    _log(_error, tag, message, LogLevel.error);
    if (error != null && _enabled) {
      debugPrint('$_error [$tag] Error details: $error');
    }
    if (stackTrace != null && _verboseEnabled && _enabled) {
      debugPrint('$_error [$tag] Stack trace: $stackTrace');
    }
  }

  /// Log debug message (only in verbose mode)
  void debug(String tag, String message) {
    if (_verboseEnabled) {
      _log(_debug, tag, message, LogLevel.debug);
    }
  }

  /// Log network related message
  void network(String tag, String message) {
    _log(_network, tag, message, LogLevel.info);
  }

  /// Log storage related message
  void storage(String tag, String message) {
    _log(_storage, tag, message, LogLevel.info);
  }

  /// Log auth related message
  void auth(String tag, String message) {
    _log(_auth, tag, message, LogLevel.info);
  }

  /// Log chat related message
  void chat(String tag, String message) {
    _log(_chat, tag, message, LogLevel.info);
  }

  // ============== PRIVATE METHODS ==============

  void _log(String icon, String tag, String message, LogLevel level) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
    );

    // Add to history
    _logHistory.add(entry);
    if (_logHistory.length > _maxHistorySize) {
      _logHistory.removeAt(0);
    }

    // Print if enabled
    if (_enabled) {
      final timestamp = _formatTimestamp(entry.timestamp);
      debugPrint('$icon [$tag] $message ($timestamp)');
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  // ============== CONVENIENCE METHODS ==============

  /// Log API request
  void apiRequest(String method, String endpoint) {
    network('API', '$method $endpoint');
  }

  /// Log API response
  void apiResponse(String endpoint, int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      success('API', '$endpoint → $statusCode');
    } else {
      warning('API', '$endpoint → $statusCode');
    }
  }

  /// Log API error
  void apiError(String endpoint, dynamic error) {
    this.error('API', 'Failed: $endpoint', error);
  }

  /// Log socket event
  void socketEvent(String event, [String? details]) {
    chat('Socket', details != null ? '$event: $details' : event);
  }

  /// Log navigation
  void navigation(String route) {
    info('NAV', 'Navigating to: $route');
  }
}

/// Log entry model
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
  });

  @override
  String toString() {
    return '[$level] [$tag] $message';
  }
}

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

// Convenience global instance
final logger = AppLogger.instance;
