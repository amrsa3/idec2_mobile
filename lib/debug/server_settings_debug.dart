import 'package:flutter/foundation.dart';
import '../core/services/server_settings_service.dart';
import '../core/constants/api_constants.dart';
import '../services/storage_service.dart';
import '../services/dio_service.dart';

/// Debug utility for testing server settings configuration
class ServerSettingsDebug {
  static Future<void> runDiagnostics() async {
    debugPrint('🔍 [DEBUG] Starting server settings diagnostics...');
    
    try {
      // Initialize storage service
      await StorageService.instance.init();
      debugPrint('✅ [DEBUG] StorageService initialized');
      
      // Create server settings service
      final serverSettingsService = ServerSettingsService(StorageService.instance);
      
      // Test 1: Check existing settings
      debugPrint('\n📋 [DEBUG] Test 1: Checking existing settings');
      final hasExisting = await serverSettingsService.hasExistingSettings();
      debugPrint('🔍 [DEBUG] Has existing settings: $hasExisting');
      
      // Test 2: Get current settings
      debugPrint('\n📋 [DEBUG] Test 2: Getting current settings');
      final currentSettings = await serverSettingsService.getCurrentSettings();
      debugPrint('🔍 [DEBUG] Current settings: host=${currentSettings.host}, port=${currentSettings.port}');
      debugPrint('🔍 [DEBUG] Generated baseUrl: ${currentSettings.baseUrl}');
      
      // Test 3: Validate and fix settings
      debugPrint('\n📋 [DEBUG] Test 3: Validating and fixing settings');
      await serverSettingsService.validateAndFixSettings();
      
      // Test 4: Get base URL
      debugPrint('\n📋 [DEBUG] Test 4: Getting base URL');
      final baseUrl = await serverSettingsService.getBaseUrl();
      debugPrint('🔍 [DEBUG] Retrieved base URL: $baseUrl');
      
      // Test 5: Update ApiConstants
      debugPrint('\n📋 [DEBUG] Test 5: Updating ApiConstants');
      ApiConstants.updateBaseUrl(baseUrl);
      debugPrint('🔍 [DEBUG] ApiConstants baseUrl: ${ApiConstants.baseUrl}');
      
      // Test 6: Validate ApiConstants
      debugPrint('\n📋 [DEBUG] Test 6: Validating ApiConstants');
      final isValid = ApiConstants.validateCurrentConfig();
      debugPrint('🔍 [DEBUG] ApiConstants validation: $isValid');
      
      // Test 7: Update DioService
      debugPrint('\n📋 [DEBUG] Test 7: Updating DioService');
      DioService.instance.refreshAfterServerChange();
      
      // Test 8: Check final URLs
      debugPrint('\n📋 [DEBUG] Test 8: Final URL check');
      debugPrint('🔍 [DEBUG] Login URL: ${ApiConstants.loginUrl}');
      debugPrint('🔍 [DEBUG] Register URL: ${ApiConstants.registerUrl}');
      
      // Test 9: Simulate production scenario
      debugPrint('\n📋 [DEBUG] Test 9: Simulating production scenario');
      await _simulateProductionScenario(serverSettingsService);
      
      debugPrint('\n✅ [DEBUG] All diagnostics completed successfully!');
      
    } catch (e, stackTrace) {
      debugPrint('❌ [DEBUG] Error during diagnostics: $e');
      debugPrint('❌ [DEBUG] Stack trace: $stackTrace');
    }
  }
  
  static Future<void> _simulateProductionScenario(ServerSettingsService service) async {
    debugPrint('🎭 [DEBUG] Simulating production scenario...');
    
    // Simulate corrupted settings (host without port)
    debugPrint('🔧 [DEBUG] Simulating corrupted settings');
    await StorageService.instance.setString('server_host', 'api.idec-ye.com');
    await StorageService.instance.setInt('server_port', 0); // Invalid port
    await StorageService.instance.setBool('server_settings_initialized', false);
    
    // Try to get settings (should trigger fix)
    debugPrint('🔧 [DEBUG] Getting settings with corrupted data');
    final settings = await service.getCurrentSettings();
    debugPrint('🔍 [DEBUG] Fixed settings: ${settings.baseUrl}');
    
    // Validate the fix
    if (settings.baseUrl.contains(':3000')) {
      debugPrint('✅ [DEBUG] Production scenario fix successful');
    } else {
      debugPrint('❌ [DEBUG] Production scenario fix failed');
    }
  }
  
  static Future<void> clearAllSettings() async {
    debugPrint('🧹 [DEBUG] Clearing all server settings...');
    
    await StorageService.instance.remove('server_host');
    await StorageService.instance.remove('server_port');
    await StorageService.instance.remove('server_settings_initialized');
    
    debugPrint('✅ [DEBUG] All settings cleared');
  }
  
  static Future<void> resetToDefaults() async {
    debugPrint('🔄 [DEBUG] Resetting to default settings...');
    
    final serverSettingsService = ServerSettingsService(StorageService.instance);
    await serverSettingsService.resetToDefault();
    
    debugPrint('✅ [DEBUG] Reset to defaults completed');
  }
  
  static void printCurrentConfiguration() {
    debugPrint('\n📊 [DEBUG] Current Configuration Summary:');
    debugPrint('🔗 [DEBUG] ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
    debugPrint('🔗 [DEBUG] ApiConstants.loginUrl: ${ApiConstants.loginUrl}');
    debugPrint('🔗 [DEBUG] DioService baseUrl: ${DioService.instance.dio.options.baseUrl}');
    
    // Validate configuration
    final hasPort = ApiConstants.baseUrl.contains(':3000');
    final hasHttp = ApiConstants.baseUrl.startsWith('http://');
    final isValid = hasPort && hasHttp;
    
    debugPrint('✅ [DEBUG] Has HTTP: $hasHttp');
    debugPrint('✅ [DEBUG] Has Port 3000: $hasPort');
    debugPrint('${isValid ? "✅" : "❌"} [DEBUG] Overall Valid: $isValid');
  }
}