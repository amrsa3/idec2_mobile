import 'package:flutter/foundation.dart';
import 'app_logger.dart';

/// Logger Configuration
/// Configures logging based on build mode
class LoggerConfig {
  static final LoggerConfig _instance = LoggerConfig._internal();
  static LoggerConfig get instance => _instance;
  LoggerConfig._internal();

  bool _initialized = false;

  /// Initialize logger with appropriate settings for current build mode
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    if (kReleaseMode) {
      // Production: Disable most logging
      logger.setEnabled(false);
      logger.setVerbose(false);
      debugPrint('🔇 [LoggerConfig] Production mode - logging disabled');
    } else if (kProfileMode) {
      // Profile: Enable minimal logging
      logger.setEnabled(true);
      logger.setVerbose(false);
      debugPrint('📊 [LoggerConfig] Profile mode - minimal logging enabled');
    } else {
      // Debug: Enable full logging
      logger.setEnabled(true);
      logger.setVerbose(true);
      debugPrint('🔍 [LoggerConfig] Debug mode - full logging enabled');
    }
  }

  /// Enable logging temporarily (for debugging in production)
  void enableTemporarily({Duration duration = const Duration(minutes: 5)}) {
    logger.setEnabled(true);
    logger.info('LoggerConfig', 'Logging enabled temporarily for ${duration.inMinutes} minutes');
    
    Future.delayed(duration, () {
      if (kReleaseMode) {
        logger.setEnabled(false);
        debugPrint('🔇 [LoggerConfig] Temporary logging disabled');
      }
    });
  }

  /// Get current logging status
  Map<String, dynamic> getStatus() {
    return {
      'enabled': logger.history.isNotEmpty,
      'buildMode': kReleaseMode ? 'release' : (kProfileMode ? 'profile' : 'debug'),
      'historyCount': logger.history.length,
    };
  }
}

/// Initialize logger at app startup
void initializeLogger() {
  LoggerConfig.instance.initialize();
}
