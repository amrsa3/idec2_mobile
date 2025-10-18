import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _refreshTokenExpiryKey = 'refresh_token_expiry';

  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._();
  
  TokenManager._();

  SharedPreferences? _prefs;
  
  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// حفظ التوكنات في التخزين المحلي
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    await _ensurePrefs();
    
    final now = DateTime.now();
    final accessTokenExpiry = now.add(Duration(seconds: expiresIn));
    final refreshTokenExpiry = now.add(Duration(days: 30)); // Refresh token expires in 30 days
    
    await _prefs!.setString(_accessTokenKey, accessToken);
    await _prefs!.setString(_refreshTokenKey, refreshToken);
    await _prefs!.setString(_tokenExpiryKey, accessTokenExpiry.toIso8601String());
    await _prefs!.setString(_refreshTokenExpiryKey, refreshTokenExpiry.toIso8601String());
    
    if (kDebugMode) {
      print('Tokens saved successfully');
    }
  }

  /// الحصول على Access Token صالح
  Future<String?> getValidAccessToken() async {
    await _ensurePrefs();
    
    final accessToken = _prefs!.getString(_accessTokenKey);
    if (accessToken == null) return null;
    
    // تحقق من انتهاء الصلاحية
    if (!await isAccessTokenValid()) {
      // محاولة تحديث التوكن
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        return _prefs!.getString(_accessTokenKey);
      }
      return null;
    }
    
    return accessToken;
  }

  /// فحص صلاحية Access Token
  Future<bool> isAccessTokenValid() async {
    await _ensurePrefs();
    
    final expiryString = _prefs!.getString(_tokenExpiryKey);
    if (expiryString == null) return false;
    
    try {
      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();
      
      // إضافة buffer من 5 دقائق قبل انتهاء الصلاحية
      final bufferTime = Duration(minutes: 5);
      return now.isBefore(expiry.subtract(bufferTime));
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing token expiry: $e');
      }
      return false;
    }
  }

  /// فحص صلاحية Refresh Token
  Future<bool> hasValidRefreshToken() async {
    await _ensurePrefs();
    
    final refreshToken = _prefs!.getString(_refreshTokenKey);
    if (refreshToken == null) return false;
    
    final expiryString = _prefs!.getString(_refreshTokenExpiryKey);
    if (expiryString == null) return false;
    
    try {
      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();
      
      return now.isBefore(expiry);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing refresh token expiry: $e');
      }
      return false;
    }
  }

  /// تحديث Access Token باستخدام Refresh Token
  Future<bool> refreshAccessToken() async {
    await _ensurePrefs();
    
    final refreshToken = _prefs!.getString(_refreshTokenKey);
    if (refreshToken == null) return false;
    
    if (!await hasValidRefreshToken()) {
      if (kDebugMode) {
        print('Refresh token expired');
      }
      await clearTokens();
      return false;
    }
    
    try {
      final dio = Dio();
      final response = await dio.post(
        '${_getBaseUrl()}/auth/refresh-silent',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        await saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          expiresIn: data['expiresIn'],
        );
        
        if (kDebugMode) {
          print('Token refreshed successfully');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing token: $e');
      }
      
      // إذا فشل التحديث، امسح التوكنات
      await clearTokens();
    }
    
    return false;
  }

  /// مسح جميع التوكنات
  Future<void> clearTokens() async {
    await _ensurePrefs();
    
    await _prefs!.remove(_accessTokenKey);
    await _prefs!.remove(_refreshTokenKey);
    await _prefs!.remove(_tokenExpiryKey);
    await _prefs!.remove(_refreshTokenExpiryKey);
    
    if (kDebugMode) {
      print('Tokens cleared');
    }
  }

  /// الحصول على Refresh Token
  Future<String?> getRefreshToken() async {
    await _ensurePrefs();
    return _prefs!.getString(_refreshTokenKey);
  }

  /// فحص وجود جلسة صالحة
  Future<bool> hasValidSession() async {
    return await hasValidRefreshToken();
  }

  /// الحصول على معلومات التوكنات
  Future<Map<String, dynamic>> getTokenInfo() async {
    await _ensurePrefs();
    
    final accessToken = _prefs!.getString(_accessTokenKey);
    final refreshToken = _prefs!.getString(_refreshTokenKey);
    final accessExpiry = _prefs!.getString(_tokenExpiryKey);
    final refreshExpiry = _prefs!.getString(_refreshTokenExpiryKey);
    
    return {
      'hasAccessToken': accessToken != null,
      'hasRefreshToken': refreshToken != null,
      'accessTokenValid': await isAccessTokenValid(),
      'refreshTokenValid': await hasValidRefreshToken(),
      'accessExpiry': accessExpiry,
      'refreshExpiry': refreshExpiry,
    };
  }

  /// تسجيل خروج من جميع الأجهزة
  Future<bool> logoutFromAllDevices() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;
      
      final dio = Dio();
      final response = await dio.post(
        '${_getBaseUrl()}/auth/logout-all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        await clearTokens();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging out from all devices: $e');
      }
    }
    
    return false;
  }

  /// تسجيل خروج عادي
  Future<bool> logout() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        await clearTokens();
        return true;
      }
      
      final dio = Dio();
      final response = await dio.post(
        '${_getBaseUrl()}/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        await clearTokens();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging out: $e');
      }
    }
    
    // في حالة الفشل، امسح التوكنات محلياً
    await clearTokens();
    return true;
  }

  /// الحصول على الجلسات النشطة
  Future<List<Map<String, dynamic>>> getActiveSessions() async {
    try {
      final accessToken = await getValidAccessToken();
      if (accessToken == null) return [];
      
      final dio = Dio();
      final response = await dio.get(
        '${_getBaseUrl()}/auth/active-sessions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting active sessions: $e');
      }
    }
    
    return [];
  }

  /// إنهاء جلسة محددة
  Future<bool> terminateSession(String sessionId) async {
    try {
      final accessToken = await getValidAccessToken();
      if (accessToken == null) return false;
      
      final dio = Dio();
      final response = await dio.delete(
        '${_getBaseUrl()}/auth/session/$sessionId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error terminating session: $e');
      }
      return false;
    }
  }

  /// الحصول على التنبيهات الأمنية
  Future<List<Map<String, dynamic>>> getSecurityAlerts() async {
    try {
      final accessToken = await getValidAccessToken();
      if (accessToken == null) return [];
      
      final dio = Dio();
      final response = await dio.get(
        '${_getBaseUrl()}/audit/security-alerts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting security alerts: $e');
      }
    }
    
    return [];
  }

  /// تحديد تنبيه كمقروء
  Future<bool> markAlertAsRead(String alertId) async {
    try {
      final accessToken = await getValidAccessToken();
      if (accessToken == null) return false;
      
      final dio = Dio();
      final response = await dio.post(
        '${_getBaseUrl()}/audit/security-alerts/$alertId/read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error marking alert as read: $e');
      }
      return false;
    }
  }

  String _getBaseUrl() {
    // يمكن تخصيص هذا حسب البيئة
    return 'https://api.idec-ye.com'; // استخدام الخادم الرئيسي
  }
}
