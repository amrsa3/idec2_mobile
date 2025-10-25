import 'package:flutter/foundation.dart';

/// معالج الرسائل الذكية للنظام الجديد
class SmartMessageHandler {
  static SmartMessageHandler? _instance;
  static SmartMessageHandler get instance => _instance ??= SmartMessageHandler._internal();

  SmartMessageHandler._internal();

  /// معالجة استجابة API من النظام الجديد
  /// 
  /// [response] - استجابة API من الخادم
  /// [language] - اللغة المفضلة للمستخدم ('ar' أو 'en')
  /// 
  /// Returns: Map يحتوي على معلومات الرسالة المعالجة
  Map<String, dynamic> handleApiResponse(
    Map<String, dynamic> response, 
    String language
  ) {
    try {
      debugPrint('🔍 [SMART_MESSAGE] Processing API response...');
      debugPrint('🔍 [SMART_MESSAGE] Response keys: ${response.keys.toList()}');
      
      // التحقق من وجود الحقول المطلوبة
      final bool success = response['success'] ?? false;
      final String messageAr = response['messageAr'] ?? '';
      final String messageEn = response['messageEn'] ?? '';
      final String code = response['code'] ?? '';
      final dynamic data = response['data'];
      
      debugPrint('🔍 [SMART_MESSAGE] Success: $success');
      debugPrint('🔍 [SMART_MESSAGE] Code: $code');
      debugPrint('🔍 [SMART_MESSAGE] MessageAr: $messageAr');
      debugPrint('🔍 [SMART_MESSAGE] MessageEn: $messageEn');
      
      // اختيار الرسالة المناسبة حسب اللغة
      String displayMessage;
      if (language == 'en' && messageEn.isNotEmpty) {
        displayMessage = messageEn;
      } else if (messageAr.isNotEmpty) {
        displayMessage = messageAr;
      } else if (messageEn.isNotEmpty) {
        displayMessage = messageEn;
      } else {
        displayMessage = success ? 'تم بنجاح' : 'حدث خطأ';
      }
      
      debugPrint('🔍 [SMART_MESSAGE] Selected message: $displayMessage');
      
      return {
        'success': success,
        'message': displayMessage,
        'messageAr': messageAr,
        'messageEn': messageEn,
        'code': code,
        'data': data,
        'timestamp': response['timestamp'],
        'isSmartMessage': true,
      };
      
    } catch (error) {
      debugPrint('❌ [SMART_MESSAGE] Error processing response: $error');
      return {
        'success': false,
        'message': 'خطأ في معالجة الاستجابة',
        'messageAr': 'خطأ في معالجة الاستجابة',
        'messageEn': 'Error processing response',
        'code': 'PROCESSING_ERROR',
        'data': null,
        'isSmartMessage': false,
      };
    }
  }
  
  /// معالجة استجابة تسجيل الدخول بشكل خاص
  Map<String, dynamic> handleLoginResponse(
    Map<String, dynamic> response, 
    String language
  ) {
    final processedResponse = handleApiResponse(response, language);
    
    if (processedResponse['success'] == true && processedResponse['data'] != null) {
      final data = processedResponse['data'] as Map<String, dynamic>?;
      
      if (data != null) {
        // استخراج بيانات المستخدم والرموز
        final user = data['user'];
        final tokens = data['tokens'];
        
        processedResponse['user'] = user;
        processedResponse['tokens'] = tokens;
        
        // استخراج الرموز مباشرة
        if (tokens != null) {
          final tokensMap = tokens as Map<String, dynamic>;
          processedResponse['accessToken'] = tokensMap['accessToken'];
          processedResponse['refreshToken'] = tokensMap['refreshToken'];
        }
        
        debugPrint('🔍 [SMART_MESSAGE] Login data extracted successfully');
      }
    }
    
    return processedResponse;
  }
  
  /// معالجة استجابة التسجيل بشكل خاص
  Map<String, dynamic> handleRegisterResponse(
    Map<String, dynamic> response, 
    String language
  ) {
    return handleApiResponse(response, language);
  }
  
  /// معالجة استجابة التحقق من OTP بشكل خاص
  Map<String, dynamic> handleOtpResponse(
    Map<String, dynamic> response, 
    String language
  ) {
    return handleApiResponse(response, language);
  }
  
  /// الحصول على رسالة خطأ محددة حسب الكود
  Map<String, String> getErrorMessageByCode(String code, String language) {
    final errorMessages = {
      'AUTH_LOGIN_FAILED': {
        'ar': 'فشل في تسجيل الدخول. تحقق من البيانات المدخلة',
        'en': 'Login failed. Please check your credentials'
      },
      'AUTH_INVALID_PASSWORD': {
        'ar': 'كلمة المرور غير صحيحة. تحقق من كلمة المرور المدخلة',
        'en': 'Invalid password. Please check your password'
      },
      'AUTH_USER_NOT_FOUND': {
        'ar': 'المستخدم غير موجود. تحقق من رقم الهاتف',
        'en': 'User not found. Please check your phone number'
      },
      'AUTH_PHONE_NOT_VERIFIED': {
        'ar': 'رقم الهاتف غير محقق. يرجى التحقق من رقم الهاتف أولاً',
        'en': 'Phone number not verified. Please verify your phone number first'
      },
      'AUTH_PHONE_EXISTS': {
        'ar': 'رقم الهاتف مستخدم بالفعل. جرب تسجيل الدخول',
        'en': 'Phone number already exists. Try logging in'
      },
      'AUTH_OTP_VERIFICATION_FAILED': {
        'ar': 'فشل في التحقق من الرمز. تحقق من الرمز المدخل',
        'en': 'OTP verification failed. Please check the code'
      },
      'AUTH_OTP_EXPIRED': {
        'ar': 'انتهت صلاحية الرمز. اطلب رمز جديد',
        'en': 'OTP expired. Please request a new code'
      },
      'AUTH_OTP_INVALID': {
        'ar': 'الرمز غير صحيح. تحقق من الرمز المدخل',
        'en': 'Invalid OTP. Please check the code'
      },
      'NETWORK_ERROR': {
        'ar': 'خطأ في الاتصال. تحقق من اتصال الإنترنت',
        'en': 'Network error. Please check your internet connection'
      },
      'SYSTEM_ERROR': {
        'ar': 'خطأ في النظام. حاول مرة أخرى لاحقاً',
        'en': 'System error. Please try again later'
      },
    };
    
    final message = errorMessages[code];
    if (message != null) {
      return {
        'ar': message['ar']!,
        'en': message['en']!,
      };
    }
    
    return {
      'ar': 'حدث خطأ غير متوقع',
      'en': 'An unexpected error occurred'
    };
  }
}