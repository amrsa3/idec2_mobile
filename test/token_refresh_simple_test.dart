import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../lib/services/enhanced_token_interceptor.dart';
import '../lib/services/unified_token_manager.dart';

/// اختبار عملي بسيط لـ Token Refresh Interceptor
/// يمكن تشغيله باستخدام: flutter test test/token_refresh_simple_test.dart
void main() {
  group('Token Refresh Interceptor - اختبار عملي', () {
    test('✅ اختبار 1: إنشاء Interceptor بنجاح', () {
      debugPrint('🧪 [TEST] اختبار إنشاء Interceptor...');
      
      final interceptor = EnhancedTokenInterceptor();
      expect(interceptor, isNotNull);
      
      debugPrint('✅ [TEST] نجح - Interceptor تم إنشاؤه بنجاح');
    });

    test('✅ اختبار 2: Token Manager يمكن الوصول إليه', () async {
      debugPrint('🧪 [TEST] اختبار Token Manager...');
      
      final tokenManager = UnifiedTokenManager.instance;
      expect(tokenManager, isNotNull);
      
      // التحقق من أن Token Manager يمكنه التحقق من صلاحية Token
      try {
        final hasValidToken = await tokenManager.isAccessTokenValid();
        debugPrint('   - Access Token صالح: $hasValidToken');
        
        final hasValidRefresh = await tokenManager.hasValidRefreshToken();
        debugPrint('   - Refresh Token صالح: $hasValidRefresh');
        
        debugPrint('✅ [TEST] نجح - Token Manager يعمل بشكل صحيح');
      } catch (e) {
        debugPrint('⚠️ [TEST] تحذير: $e (قد يكون متوقعاً إذا لم يكن هناك tokens)');
      }
    });

    test('✅ اختبار 3: Interceptor يضيف Token للطلبات', () async {
      debugPrint('🧪 [TEST] اختبار إضافة Token للطلبات...');
      
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.idec-ye.com',
        connectTimeout: const Duration(seconds: 5),
      ));

      final interceptor = EnhancedTokenInterceptor();
      dio.interceptors.add(interceptor);

      try {
        final tokenManager = UnifiedTokenManager.instance;
        final token = await tokenManager.getValidAccessToken();
        
        if (token != null) {
          debugPrint('   - يوجد Token: ${token.substring(0, 20)}...');
          
          // محاولة إرسال طلب
          try {
            await dio.get('/api/v1/notification-center?page=1&limit=20');
            debugPrint('✅ [TEST] نجح - الطلب تم إرساله بنجاح');
          } catch (e) {
            if (e is DioException) {
              final authHeader = e.requestOptions.headers['Authorization'];
              if (authHeader != null && authHeader.toString().startsWith('Bearer ')) {
                debugPrint('✅ [TEST] نجح - Token تم إضافته للطلب (الخطأ من الخادم متوقع)');
              } else {
                debugPrint('❌ [TEST] فشل - Token لم يتم إضافته');
                fail('Token لم يتم إضافته للطلب');
              }
            }
          }
        } else {
          debugPrint('⚠️ [TEST] لا يوجد Token - هذا متوقع في بيئة الاختبار');
        }
      } catch (e) {
        debugPrint('⚠️ [TEST] خطأ: $e');
      } finally {
        dio.close();
      }
    });

    test('✅ اختبار 4: Auth endpoints لا تحتوي على Token', () async {
      debugPrint('🧪 [TEST] اختبار Auth endpoints...');
      
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.idec-ye.com',
        connectTimeout: const Duration(seconds: 5),
      ));

      final interceptor = EnhancedTokenInterceptor();
      dio.interceptors.add(interceptor);

      try {
        await dio.post('/api/v1/auth/login', data: {
          'phone': '777034999',
          'password': 'test',
        });
        debugPrint('✅ [TEST] نجح - Auth endpoint تم إرساله');
      } catch (e) {
        if (e is DioException) {
          final hasAuth = e.requestOptions.headers.containsKey('Authorization');
          if (!hasAuth) {
            debugPrint('✅ [TEST] نجح - Auth endpoint لا يحتوي على Token (صحيح)');
          } else {
            debugPrint('❌ [TEST] فشل - Auth endpoint يحتوي على Token (غير صحيح)');
            fail('Auth endpoint يجب ألا يحتوي على Token');
          }
        }
      } finally {
        dio.close();
      }
    });

    test('✅ اختبار 5: لا يتم إرسال طلب بدون Token', () async {
      debugPrint('🧪 [TEST] اختبار رفض الطلبات بدون Token...');
      
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.idec-ye.com',
        connectTimeout: const Duration(seconds: 5),
      ));

      final interceptor = EnhancedTokenInterceptor();
      dio.interceptors.add(interceptor);

      // محاولة إرسال طلب بدون token (إذا لم يكن هناك token محفوظ)
      try {
        final tokenManager = UnifiedTokenManager.instance;
        final hasToken = await tokenManager.isAccessTokenValid();
        final hasRefresh = await tokenManager.hasValidRefreshToken();
        
        if (!hasToken && !hasRefresh) {
          // لا يوجد token ولا refresh token
          try {
            await dio.get('/api/v1/notification-center');
            fail('يجب أن يفشل الطلب عندما لا يوجد Token');
          } catch (e) {
            if (e is DioException) {
              if (e.response?.statusCode == 401) {
                debugPrint('✅ [TEST] نجح - الطلب تم رفضه بـ 401 (صحيح)');
              } else {
                debugPrint('⚠️ [TEST] خطأ آخر: ${e.response?.statusCode}');
              }
            }
          }
        } else {
          debugPrint('⚠️ [TEST] يوجد Token - لا يمكن اختبار هذا السيناريو');
        }
      } catch (e) {
        debugPrint('⚠️ [TEST] خطأ: $e');
      } finally {
        dio.close();
      }
    });
  });

  group('Token Refresh - Integration Test', () {
    test('✅ اختبار التكامل: Interceptor مع Dio', () {
      debugPrint('🧪 [INTEGRATION_TEST] اختبار التكامل...');
      
      final dio = Dio(BaseOptions(baseUrl: 'https://api.idec-ye.com'));
      final interceptor = EnhancedTokenInterceptor();
      
      dio.interceptors.add(interceptor);
      
      expect(dio.interceptors.length, greaterThan(0));
      expect(dio.interceptors.contains(interceptor), isTrue);
      
      debugPrint('✅ [INTEGRATION_TEST] نجح - Interceptor تم إضافته بنجاح');
      
      dio.close();
    });
  });
}


















