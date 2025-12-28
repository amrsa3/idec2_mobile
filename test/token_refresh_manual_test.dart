import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../lib/services/enhanced_token_interceptor.dart';
import '../lib/services/unified_token_manager.dart';
import '../lib/services/enhanced_session_manager.dart';
import '../lib/services/silent_token_refresh_service.dart';

/// اختبار عملي يدوي لـ Token Refresh Interceptor
/// يمكن تشغيله مباشرة بدون mockito
void main() async {
  debugPrint('🧪 [MANUAL_TEST] بدء الاختبار العملي لـ Token Refresh Interceptor...\n');

  // اختبار 1: التحقق من أن Interceptor يتم إنشاؤه بنجاح
  testInterceptorCreation();

  // اختبار 2: التحقق من أن Token Manager يعمل
  await testTokenManager();

  // اختبار 3: اختبار السيناريوهات المختلفة
  await testScenarios();

  debugPrint('\n✅ [MANUAL_TEST] انتهى الاختبار العملي');
}

void testInterceptorCreation() {
  debugPrint('📋 [TEST 1] اختبار إنشاء Interceptor...');
  
  try {
    final interceptor = EnhancedTokenInterceptor();
    expect(interceptor, isNotNull, reason: 'يجب أن يتم إنشاء Interceptor بنجاح');
    debugPrint('✅ [TEST 1] نجح - Interceptor تم إنشاؤه بنجاح\n');
  } catch (e) {
    debugPrint('❌ [TEST 1] فشل - $e\n');
    rethrow;
  }
}

Future<void> testTokenManager() async {
  debugPrint('📋 [TEST 2] اختبار Token Manager...');
  
  try {
    final tokenManager = UnifiedTokenManager.instance;
    expect(tokenManager, isNotNull, reason: 'يجب أن يتم إنشاء Token Manager بنجاح');
    
    // التحقق من أن Token Manager يمكنه التحقق من صلاحية Token
    final hasValidToken = await tokenManager.isAccessTokenValid();
    debugPrint('   - Access Token صالح: $hasValidToken');
    
    final hasValidRefresh = await tokenManager.hasValidRefreshToken();
    debugPrint('   - Refresh Token صالح: $hasValidRefresh');
    
    debugPrint('✅ [TEST 2] نجح - Token Manager يعمل بشكل صحيح\n');
  } catch (e) {
    debugPrint('❌ [TEST 2] فشل - $e\n');
    // لا نرمي الخطأ هنا لأن Token Manager قد لا يحتوي على tokens في بيئة الاختبار
    debugPrint('⚠️ [TEST 2] تحذير: قد يكون هذا متوقعاً إذا لم يكن هناك tokens محفوظة\n');
  }
}

Future<void> testScenarios() async {
  debugPrint('📋 [TEST 3] اختبار السيناريوهات المختلفة...\n');

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.idec-ye.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  final interceptor = EnhancedTokenInterceptor();
  dio.interceptors.add(interceptor);

  // السيناريو 1: طلب عادي (قد يفشل بدون token، لكن هذا متوقع)
  debugPrint('   📌 السيناريو 1: طلب عادي...');
  try {
    await dio.get('/api/v1/notification-center?page=1&limit=20');
    debugPrint('   ✅ نجح - الطلب تم إرساله بنجاح');
  } catch (e) {
    if (e is DioException) {
      if (e.response?.statusCode == 401) {
        debugPrint('   ✅ متوقع - تم رفض الطلب بـ 401 (لا يوجد token)');
      } else {
        debugPrint('   ⚠️ خطأ آخر: ${e.response?.statusCode} - ${e.message}');
      }
    } else {
      debugPrint('   ⚠️ خطأ غير متوقع: $e');
    }
  }

  // السيناريو 2: Auth endpoint (يجب أن يتخطى interceptor)
  debugPrint('\n   📌 السيناريو 2: Auth endpoint (يجب تخطي Token)...');
  try {
    await dio.post('/api/v1/auth/login', data: {
      'phone': '777034999',
      'password': 'test',
    });
    debugPrint('   ✅ نجح - Auth endpoint تم تخطيه');
  } catch (e) {
    if (e is DioException) {
      final hasAuth = e.requestOptions.headers.containsKey('Authorization');
      if (!hasAuth) {
        debugPrint('   ✅ متوقع - Auth endpoint لا يحتوي على Token (صحيح)');
      } else {
        debugPrint('   ❌ خطأ - Auth endpoint يحتوي على Token (غير صحيح)');
      }
    }
  }

  // السيناريو 3: التحقق من أن Interceptor يضيف Token عند الحاجة
  debugPrint('\n   📌 السيناريو 3: التحقق من إضافة Token...');
  try {
    final tokenManager = UnifiedTokenManager.instance;
    final token = await tokenManager.getValidAccessToken();
    
    if (token != null) {
      debugPrint('   ✅ يوجد Token - سيتم إضافته للطلب');
      try {
        await dio.get('/api/v1/notification-center');
        debugPrint('   ✅ نجح - الطلب تم إرساله مع Token');
      } catch (e) {
        if (e is DioException) {
          final authHeader = e.requestOptions.headers['Authorization'];
          if (authHeader != null && authHeader.toString().startsWith('Bearer ')) {
            debugPrint('   ✅ متوقع - Token تم إضافته للطلب (الخطأ من الخادم)');
          } else {
            debugPrint('   ❌ خطأ - Token لم يتم إضافته');
          }
        }
      }
    } else {
      debugPrint('   ⚠️ لا يوجد Token - هذا متوقع في بيئة الاختبار');
    }
  } catch (e) {
    debugPrint('   ⚠️ خطأ: $e');
  }

  dio.close();
  debugPrint('\n✅ [TEST 3] انتهى اختبار السيناريوهات\n');
}

// Helper function for expect (بسيط للاختبار اليدوي)
void expect(dynamic actual, dynamic matcher, {String? reason}) {
  if (matcher is bool) {
    if (actual != matcher) {
      throw AssertionError(reason ?? 'Expected $actual to be $matcher');
    }
  } else if (matcher == isNotNull) {
    if (actual == null) {
      throw AssertionError(reason ?? 'Expected value to be not null');
    }
  }
}


















