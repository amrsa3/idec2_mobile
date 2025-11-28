import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:idec_conference_app/services/platform_storage_service.dart';
import 'package:idec_conference_app/services/unified_token_manager.dart';
import 'package:idec_conference_app/services/enhanced_session_manager.dart';
import 'package:idec_conference_app/services/enhanced_dio_service_v2.dart';

void main() {
  group('System Integration Tests', () {
    setUpAll(() async {
      // Mock Flutter services for testing
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock MethodChannel for SharedPreferences
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{};
        }
        return null;
      });
      
      // Mock MethodChannel for FlutterSecureStorage
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'read') {
          return null;
        }
        if (methodCall.method == 'write') {
          return null;
        }
        if (methodCall.method == 'delete') {
          return null;
        }
        return null;
      });
    });

    test('PlatformStorageService instance creation', () async {
      debugPrint('🧪 [TEST] Testing PlatformStorageService instance...');
      
      try {
        final storage = PlatformStorageService.instance;
        expect(storage, isNotNull);
        debugPrint('✅ [TEST] PlatformStorageService: PASSED');
      } catch (e) {
        debugPrint('❌ [TEST] PlatformStorageService: FAILED - $e');
        rethrow;
      }
    });

    test('UnifiedTokenManager instance creation', () async {
      debugPrint('🧪 [TEST] Testing UnifiedTokenManager instance...');
      
      try {
        final tokenManager = UnifiedTokenManager.instance;
        expect(tokenManager, isNotNull);
        debugPrint('✅ [TEST] UnifiedTokenManager: PASSED');
      } catch (e) {
        debugPrint('❌ [TEST] UnifiedTokenManager: FAILED - $e');
        rethrow;
      }
    });

    test('EnhancedSessionManager instance creation', () async {
      debugPrint('🧪 [TEST] Testing EnhancedSessionManager instance...');
      
      try {
        final sessionManager = EnhancedSessionManager.instance;
        expect(sessionManager, isNotNull);
        debugPrint('✅ [TEST] EnhancedSessionManager: PASSED');
      } catch (e) {
        debugPrint('❌ [TEST] EnhancedSessionManager: FAILED - $e');
        rethrow;
      }
    });

    test('EnhancedDioServiceV2 instance creation', () async {
      debugPrint('🧪 [TEST] Testing EnhancedDioServiceV2 instance...');
      
      try {
        final dioService = EnhancedDioServiceV2.instance;
        expect(dioService, isNotNull);
        
        // Wait a bit for initialization
        await Future.delayed(const Duration(milliseconds: 100));
        
        final statistics = dioService.statistics;
        expect(statistics, isNotNull);
        expect(statistics['totalRequests'], equals(0));
        
        debugPrint('✅ [TEST] EnhancedDioServiceV2: PASSED');
        debugPrint('📊 [TEST] Initial Statistics: $statistics');
      } catch (e) {
        debugPrint('❌ [TEST] EnhancedDioServiceV2: FAILED - $e');
        rethrow;
      }
    });

    test('All services can be instantiated together', () async {
      debugPrint('🧪 [TEST] Testing all services instantiation...');
      
      try {
        final storage = PlatformStorageService.instance;
        final tokenManager = UnifiedTokenManager.instance;
        final sessionManager = EnhancedSessionManager.instance;
        final dioService = EnhancedDioServiceV2.instance;
        
        expect(storage, isNotNull);
        expect(tokenManager, isNotNull);
        expect(sessionManager, isNotNull);
        expect(dioService, isNotNull);
        
        debugPrint('✅ [TEST] All services instantiation: PASSED');
      } catch (e) {
        debugPrint('❌ [TEST] All services instantiation: FAILED - $e');
        rethrow;
      }
    });
  });
}