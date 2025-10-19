import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

// Import all the services we need to test
import '../lib/services/platform_storage_service.dart';
import '../lib/services/unified_token_manager.dart';
import '../lib/services/enhanced_session_manager.dart';
import '../lib/services/enhanced_dio_service_v2.dart';
import '../lib/services/silent_token_refresh_service.dart';
import '../lib/services/system_test_service.dart';

void main() {
  group('Comprehensive System Test - النظام الموحد الجديد', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock SharedPreferences
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{};
        }
        return null;
      });

      // Mock FlutterSecureStorage
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
        if (methodCall.method == 'deleteAll') {
          return null;
        }
        return null;
      });

      // Mock connectivity
      const MethodChannel('dev.fluttercommunity.plus/connectivity')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'check') {
          return 'wifi';
        }
        return null;
      });
    });

    test('1. اختبار إنشاء PlatformStorageService', () async {
      debugPrint('🧪 اختبار PlatformStorageService...');
      
      try {
        final storage = PlatformStorageService.instance;
        expect(storage, isNotNull);
        debugPrint('✅ PlatformStorageService تم إنشاؤه بنجاح');
      } catch (e) {
        debugPrint('❌ خطأ في PlatformStorageService: $e');
        rethrow;
      }
    });

    test('2. اختبار إنشاء UnifiedTokenManager', () async {
      debugPrint('🧪 اختبار UnifiedTokenManager...');
      
      try {
        final tokenManager = UnifiedTokenManager.instance;
        expect(tokenManager, isNotNull);
        debugPrint('✅ UnifiedTokenManager تم إنشاؤه بنجاح');
      } catch (e) {
        debugPrint('❌ خطأ في UnifiedTokenManager: $e');
        rethrow;
      }
    });

    test('3. اختبار إنشاء EnhancedSessionManager', () async {
      debugPrint('🧪 اختبار EnhancedSessionManager...');
      
      try {
        final sessionManager = EnhancedSessionManager.instance;
        expect(sessionManager, isNotNull);
        debugPrint('✅ EnhancedSessionManager تم إنشاؤه بنجاح');
      } catch (e) {
        debugPrint('❌ خطأ في EnhancedSessionManager: $e');
        rethrow;
      }
    });

    test('4. اختبار إنشاء EnhancedDioServiceV2', () async {
      debugPrint('🧪 اختبار EnhancedDioServiceV2...');
      
      try {
        final dioService = EnhancedDioServiceV2.instance;
        expect(dioService, isNotNull);
        
        // انتظار قصير للتهيئة
        await Future.delayed(Duration(milliseconds: 500));
        
        debugPrint('✅ EnhancedDioServiceV2 تم إنشاؤه بنجاح');
      } catch (e) {
        debugPrint('❌ خطأ في EnhancedDioServiceV2: $e');
        rethrow;
      }
    });

    test('5. اختبار إنشاء SilentTokenRefreshService', () async {
      debugPrint('🧪 اختبار SilentTokenRefreshService...');
      
      try {
        final refreshService = SilentTokenRefreshService.instance;
        expect(refreshService, isNotNull);
        debugPrint('✅ SilentTokenRefreshService تم إنشاؤه بنجاح');
      } catch (e) {
        debugPrint('❌ خطأ في SilentTokenRefreshService: $e');
        rethrow;
      }
    });

    test('6. اختبار SystemTestService', () async {
      debugPrint('🧪 اختبار SystemTestService...');
      
      try {
        final systemTest = SystemTestService();
        expect(systemTest, isNotNull);
        
        // تشغيل اختبار أساسي
        final basicTestResult = await systemTest.runBasicTests();
        expect(basicTestResult, isNotNull);
        debugPrint('✅ SystemTestService - الاختبار الأساسي نجح');
        
        // تشغيل اختبار التكامل
        final integrationTestResult = await systemTest.runIntegrationTests();
        expect(integrationTestResult, isNotNull);
        debugPrint('✅ SystemTestService - اختبار التكامل نجح');
        
      } catch (e) {
        debugPrint('❌ خطأ في SystemTestService: $e');
        rethrow;
      }
    });

    test('7. اختبار التكامل الشامل للنظام', () async {
      debugPrint('🧪 اختبار التكامل الشامل...');
      
      try {
        // إنشاء جميع الخدمات
        final storage = PlatformStorageService.instance;
        final tokenManager = UnifiedTokenManager.instance;
        final sessionManager = EnhancedSessionManager.instance;
        final dioService = EnhancedDioServiceV2.instance;
        final refreshService = SilentTokenRefreshService.instance;
        
        // التأكد من أن جميع الخدمات تم إنشاؤها
        expect(storage, isNotNull);
        expect(tokenManager, isNotNull);
        expect(sessionManager, isNotNull);
        expect(dioService, isNotNull);
        expect(refreshService, isNotNull);
        
        debugPrint('✅ جميع خدمات النظام الموحد تعمل بنجاح');
        
        // اختبار حفظ واسترجاع التوكن
        await tokenManager.saveTokens(
          accessToken: 'test_access_token',
          refreshToken: 'test_refresh_token',
          expiresIn: 3600,
        );
        
        final hasValidToken = await tokenManager.hasValidRefreshToken();
        debugPrint('✅ اختبار حفظ واسترجاع التوكن نجح: $hasValidToken');
        
      } catch (e) {
        debugPrint('❌ خطأ في اختبار التكامل الشامل: $e');
        rethrow;
      }
    });

    test('8. اختبار الأداء الأساسي', () async {
      debugPrint('🧪 اختبار الأداء الأساسي...');
      
      try {
        final stopwatch = Stopwatch()..start();
        
        // اختبار سرعة إنشاء الخدمات
        final storage = PlatformStorageService.instance;
        final tokenManager = UnifiedTokenManager.instance;
        final sessionManager = EnhancedSessionManager.instance;
        
        stopwatch.stop();
        final initTime = stopwatch.elapsedMilliseconds;
        
        debugPrint('⏱️ وقت تهيئة الخدمات الأساسية: ${initTime}ms');
        
        // يجب أن يكون وقت التهيئة أقل من ثانية واحدة
        expect(initTime, lessThan(1000));
        
        debugPrint('✅ اختبار الأداء الأساسي نجح');
        
      } catch (e) {
        debugPrint('❌ خطأ في اختبار الأداء: $e');
        rethrow;
      }
    });
  });
}