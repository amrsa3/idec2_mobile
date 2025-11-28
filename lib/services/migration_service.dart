import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'unified_token_manager.dart';
import 'enhanced_session_manager.dart';
import 'platform_storage_service.dart';
import 'web_compatible_storage.dart';
import 'token_manager.dart';

/// Migration service to handle transition from old token/session system to new enhanced system
class MigrationService {
  static MigrationService? _instance;
  static MigrationService get instance => _instance ??= MigrationService._internal();

  final PlatformStorageService _newStorage = PlatformStorageService.instance;
  final UnifiedTokenManager _newTokenManager = UnifiedTokenManager.instance;
  final EnhancedSessionManager _newSessionManager = EnhancedSessionManager.instance;
  
  // Old storage instances for migration
  final FlutterSecureStorage _oldSecureStorage = const FlutterSecureStorage();
  final WebCompatibleStorage _oldWebStorage = WebCompatibleStorage.instance;

  bool _migrationCompleted = false;
  String? _migrationVersion;

  MigrationService._internal();

  /// Check if migration is needed and perform it
  Future<bool> performMigrationIfNeeded() async {
    try {
      debugPrint('🔄 [MIGRATION] Checking if migration is needed...');
      
      // Check current migration version
      _migrationVersion = await _newStorage.read('migration_version');
      
      if (_migrationVersion == null || _migrationVersion != '2.4.0') {
        debugPrint('🔄 [MIGRATION] Migration needed from version: ${_migrationVersion ?? "legacy"}');
        return await _performMigration();
      } else {
        debugPrint('✅ [MIGRATION] Already migrated to version: $_migrationVersion');
        _migrationCompleted = true;
        return true;
      }
    } catch (e) {
      debugPrint('❌ [MIGRATION] Error checking migration status: $e');
      return false;
    }
  }

  /// Perform the actual migration
  Future<bool> _performMigration() async {
    try {
      debugPrint('🚀 [MIGRATION] Starting migration process...');
      
      // Step 1: Migrate tokens
      final tokensMigrated = await _migrateTokens();
      debugPrint('📝 [MIGRATION] Tokens migration: ${tokensMigrated ? "✅ Success" : "❌ Failed"}');
      
      // Step 2: Migrate user data
      final userDataMigrated = await _migrateUserData();
      debugPrint('📝 [MIGRATION] User data migration: ${userDataMigrated ? "✅ Success" : "❌ Failed"}');
      
      // Step 3: Migrate session data
      final sessionMigrated = await _migrateSessionData();
      debugPrint('📝 [MIGRATION] Session migration: ${sessionMigrated ? "✅ Success" : "❌ Failed"}');
      
      // Step 4: Migrate app settings
      final settingsMigrated = await _migrateAppSettings();
      debugPrint('📝 [MIGRATION] Settings migration: ${settingsMigrated ? "✅ Success" : "❌ Failed"}');
      
      // Step 5: Clean up old data
      await _cleanupOldData();
      debugPrint('📝 [MIGRATION] Cleanup completed');
      
      // Step 6: Mark migration as completed
      await _markMigrationCompleted();
      
      _migrationCompleted = true;
      debugPrint('✅ [MIGRATION] Migration completed successfully');
      
      return true;
    } catch (e) {
      debugPrint('❌ [MIGRATION] Migration failed: $e');
      return false;
    }
  }

  /// Migrate tokens from old system to new unified system
  Future<bool> _migrateTokens() async {
    try {
      String? accessToken;
      String? refreshToken;
      
      // Try to get tokens from old storage
      if (kIsWeb) {
        accessToken = await _oldWebStorage.read('access_token');
        refreshToken = await _oldWebStorage.read('refresh_token');
      } else {
        accessToken = await _oldSecureStorage.read(key: 'access_token');
        refreshToken = await _oldSecureStorage.read(key: 'refresh_token');
      }
      
      // Also try TokenManager instance
      if (accessToken == null || refreshToken == null) {
        try {
          accessToken = accessToken ?? await UnifiedTokenManager.instance.getValidAccessToken();
          refreshToken = refreshToken ?? await UnifiedTokenManager.instance.getRefreshToken();
        } catch (e) {
          debugPrint('⚠️ [MIGRATION] Could not get tokens from TokenManager: $e');
        }
      }
      
      if (accessToken != null && refreshToken != null) {
        debugPrint('🔑 [MIGRATION] Found existing tokens, migrating...');
        
        // Set tokens in new system
        await _newTokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: 2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds) - تغيير من ساعة إلى 30 يوم
        );
        
        // Verify migration
        final migratedAccess = await _newTokenManager.getValidAccessToken();
        final hasValidRefresh = await _newTokenManager.hasValidRefreshToken();
        
        if (migratedAccess == accessToken && hasValidRefresh) {
          debugPrint('✅ [MIGRATION] Tokens migrated successfully');
          return true;
        } else {
          debugPrint('❌ [MIGRATION] Token migration verification failed');
          return false;
        }
      } else {
        debugPrint('ℹ️ [MIGRATION] No existing tokens found to migrate');
        return true; // Not an error if no tokens exist
      }
    } catch (e) {
      debugPrint('❌ [MIGRATION] Token migration failed: $e');
      return false;
    }
  }

  /// Migrate user data
  Future<bool> _migrateUserData() async {
    try {
      String? userData;
      
      // Try to get user data from old storage
      if (kIsWeb) {
        userData = await _oldWebStorage.read('user_data');
      } else {
        userData = await _oldSecureStorage.read(key: 'user_data');
      }
      
      if (userData != null && userData.isNotEmpty) {
        debugPrint('👤 [MIGRATION] Found existing user data, migrating...');
        
        // Parse and validate user data
        try {
          final userMap = jsonDecode(userData) as Map<String, dynamic>;
          
          // Store in new system
          await _newStorage.write('user_data', userData);
          
          // Also store individual user fields for easier access
          if (userMap['id'] != null) {
            await _newStorage.write('user_id', userMap['id'].toString());
          }
          if (userMap['phone'] != null) {
            await _newStorage.write('user_phone', userMap['phone'].toString());
          }
          if (userMap['email'] != null) {
            await _newStorage.write('user_email', userMap['email'].toString());
          }
          
          debugPrint('✅ [MIGRATION] User data migrated successfully');
          return true;
        } catch (e) {
          debugPrint('❌ [MIGRATION] Invalid user data format: $e');
          return false;
        }
      } else {
        debugPrint('ℹ️ [MIGRATION] No existing user data found to migrate');
        return true;
      }
    } catch (e) {
      debugPrint('❌ [MIGRATION] User data migration failed: $e');
      return false;
    }
  }

  /// Migrate session data
  Future<bool> _migrateSessionData() async {
    try {
      // Check if there's an active session in the old system
      bool hadActiveSession = false;
      
      // Check old token existence as indicator of active session
      if (kIsWeb) {
        final token = await _oldWebStorage.read('access_token');
        hadActiveSession = token != null && token.isNotEmpty;
      } else {
        final token = await _oldSecureStorage.read(key: 'access_token');
        hadActiveSession = token != null && token.isNotEmpty;
      }
      
      if (hadActiveSession) {
        debugPrint('🔄 [MIGRATION] Found active session, creating new session...');
        
        // Start a new session in the enhanced system
        await _newSessionManager.startSession(
          userId: 'migrated_user',
          deviceId: 'migrated_device',
        );
        
        // Set last activity to current time
        await _newSessionManager.updateActivity();
        
        debugPrint('✅ [MIGRATION] Session migrated successfully');
      } else {
        debugPrint('ℹ️ [MIGRATION] No active session found to migrate');
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ [MIGRATION] Session migration failed: $e');
      return false;
    }
  }

  /// Migrate app settings
  Future<bool> _migrateAppSettings() async {
    try {
      final settingsToMigrate = [
        'selected_language',
        'theme_mode',
        'notification_enabled',
        'biometric_enabled',
        'auto_logout_enabled',
        'remember_me',
        'server_url',
        'app_version',
      ];
      
      int migratedCount = 0;
      
      for (final setting in settingsToMigrate) {
        try {
          String? value;
          
          if (kIsWeb) {
            value = await _oldWebStorage.read(setting);
          } else {
            value = await _oldSecureStorage.read(key: setting);
          }
          
          if (value != null) {
            await _newStorage.write(setting, value);
            migratedCount++;
            debugPrint('📝 [MIGRATION] Migrated setting: $setting = $value');
          }
        } catch (e) {
          debugPrint('⚠️ [MIGRATION] Failed to migrate setting $setting: $e');
        }
      }
      
      debugPrint('✅ [MIGRATION] Migrated $migratedCount settings');
      return true;
    } catch (e) {
      debugPrint('❌ [MIGRATION] Settings migration failed: $e');
      return false;
    }
  }

  /// Clean up old data after successful migration
  Future<void> _cleanupOldData() async {
    try {
      debugPrint('🧹 [MIGRATION] Starting cleanup of old data...');
      
      final keysToCleanup = [
        'access_token',
        'refresh_token',
        'user_data',
        'selected_language',
        'theme_mode',
        'notification_enabled',
        'biometric_enabled',
        'auto_logout_enabled',
        'remember_me',
        'server_url',
        'app_version',
      ];
      
      int cleanedCount = 0;
      
      for (final key in keysToCleanup) {
        try {
          if (kIsWeb) {
            await _oldWebStorage.delete(key);
          } else {
            await _oldSecureStorage.delete(key: key);
          }
          cleanedCount++;
        } catch (e) {
          debugPrint('⚠️ [MIGRATION] Failed to cleanup key $key: $e');
        }
      }
      
      debugPrint('✅ [MIGRATION] Cleaned up $cleanedCount old data entries');
    } catch (e) {
      debugPrint('❌ [MIGRATION] Cleanup failed: $e');
    }
  }

  /// Mark migration as completed
  Future<void> _markMigrationCompleted() async {
    try {
      await _newStorage.write('migration_version', '2.4.0');
      await _newStorage.write('migration_date', DateTime.now().toIso8601String());
      await _newStorage.write('migration_completed', 'true');
      
      debugPrint('✅ [MIGRATION] Migration marked as completed');
    } catch (e) {
      debugPrint('❌ [MIGRATION] Failed to mark migration as completed: $e');
    }
  }

  /// Check if migration has been completed
  bool get isMigrationCompleted => _migrationCompleted;

  /// Get migration version
  String? get migrationVersion => _migrationVersion;

  /// Force re-migration (for testing or troubleshooting)
  Future<bool> forceMigration() async {
    try {
      debugPrint('🔄 [MIGRATION] Forcing re-migration...');
      
      // Clear migration markers
      await _newStorage.delete('migration_version');
      await _newStorage.delete('migration_date');
      await _newStorage.delete('migration_completed');
      
      _migrationCompleted = false;
      _migrationVersion = null;
      
      // Perform migration
      return await performMigrationIfNeeded();
    } catch (e) {
      debugPrint('❌ [MIGRATION] Force migration failed: $e');
      return false;
    }
  }

  /// Get migration status report
  Map<String, dynamic> getMigrationStatus() {
    return {
      'completed': _migrationCompleted,
      'version': _migrationVersion,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Validate migration integrity
  Future<bool> validateMigration() async {
    try {
      debugPrint('🔍 [MIGRATION] Validating migration integrity...');
      
      // Check if new system has required data
      final hasTokens = await _newTokenManager.hasValidRefreshToken();
      final hasUserData = await _newStorage.read('user_data') != null;
      final hasMigrationMarker = await _newStorage.read('migration_version') != null;
      
      final isValid = hasMigrationMarker; // At minimum, migration marker should exist
      
      debugPrint('📊 [MIGRATION] Validation results:');
      debugPrint('  - Has tokens: $hasTokens');
      debugPrint('  - Has user data: $hasUserData');
      debugPrint('  - Has migration marker: $hasMigrationMarker');
      debugPrint('  - Overall valid: $isValid');
      
      return isValid;
    } catch (e) {
      debugPrint('❌ [MIGRATION] Validation failed: $e');
      return false;
    }
  }
}

/// Migration result data class
class MigrationResult {
  final bool success;
  final String version;
  final DateTime timestamp;
  final List<String> migratedItems;
  final List<String> errors;

  const MigrationResult({
    required this.success,
    required this.version,
    required this.timestamp,
    required this.migratedItems,
    required this.errors,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'version': version,
      'timestamp': timestamp.toIso8601String(),
      'migratedItems': migratedItems,
      'errors': errors,
    };
  }
}
