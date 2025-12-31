import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../services/unified_token_manager.dart';

/// مدير التوكنات الموحد
/// 
/// هذه طبقة wrapper تغلف UnifiedTokenManager الموجود
/// للحفاظ على التوافق العكسي وتوفير واجهة موحدة
/// 
/// في المستقبل، يمكن استبدال التنفيذ الداخلي دون التأثير على الكود الخارجي
class TokenManager {
  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._();
  
  TokenManager._();
  
  /// المندوب - يستخدم UnifiedTokenManager الموجود
  final _delegate = UnifiedTokenManager.instance;
  
  /// هل تم التهيئة
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  // ============================================================
  // التهيئة
  // ============================================================
  
  /// تهيئة مدير التوكنات
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ [TokenManager] Already initialized');
      return;
    }
    
    try {
      await _delegate.initialize();
      _isInitialized = true;
      debugPrint('✅ [TokenManager] Initialized successfully');
    } catch (e) {
      debugPrint('❌ [TokenManager] Initialization failed: $e');
      rethrow;
    }
  }
  
  /// التأكد من التهيئة
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // ============================================================
  // حفظ التوكنات
  // ============================================================
  
  /// حفظ التوكنات وبيانات الجلسة
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    int? refreshExpiresIn,
    String? sessionId,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? deviceInfo,
  }) async {
    await ensureInitialized();
    
    debugPrint('💾 [TokenManager] Saving tokens...');
    debugPrint('   - Access token length: ${accessToken.length}');
    debugPrint('   - Refresh token length: ${refreshToken.length}');
    debugPrint('   - Expires in: $expiresIn seconds');
    debugPrint('   - Refresh expires in: $refreshExpiresIn seconds');
    
    await _delegate.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      refreshExpiresIn: refreshExpiresIn,
      sessionId: sessionId,
      userData: userData,
      deviceInfo: deviceInfo,
    );
    
    debugPrint('✅ [TokenManager] Tokens saved successfully');
  }
  
  // ============================================================
  // الحصول على التوكنات
  // ============================================================
  
  /// الحصول على access token صالح
  /// 
  /// يتم تجديد التوكن تلقائياً إذا كان منتهياً
  Future<String?> getValidAccessToken() async {
    await ensureInitialized();
    return _delegate.getValidAccessToken();
  }
  
  /// الحصول على refresh token
  Future<String?> getRefreshToken() async {
    await ensureInitialized();
    return _delegate.getRefreshToken();
  }
  
  /// الحصول على session ID
  Future<String?> getSessionId() async {
    await ensureInitialized();
    return _delegate.getSessionId();
  }
  
  // ============================================================
  // التحقق من صحة التوكنات
  // ============================================================
  
  /// التحقق من صحة access token
  Future<bool> isAccessTokenValid() async {
    await ensureInitialized();
    return _delegate.isAccessTokenValid();
  }
  
  /// التحقق من صحة refresh token
  Future<bool> hasValidRefreshToken() async {
    await ensureInitialized();
    return _delegate.hasValidRefreshToken();
  }
  
  /// التحقق من وجود جلسة صالحة
  Future<bool> hasValidSession() async {
    await ensureInitialized();
    return _delegate.hasValidSession();
  }
  
  // ============================================================
  // تجديد التوكن
  // ============================================================
  
  /// تجديد access token باستخدام refresh token
  Future<bool> refreshAccessToken() async {
    await ensureInitialized();
    debugPrint('🔄 [TokenManager] Refreshing access token...');
    
    try {
      final success = await _delegate.refreshAccessToken();
      
      if (success) {
        debugPrint('✅ [TokenManager] Access token refreshed successfully');
      } else {
        debugPrint('❌ [TokenManager] Access token refresh failed');
      }
      
      return success;
    } catch (e) {
      debugPrint('❌ [TokenManager] Access token refresh error: $e');
      return false;
    }
  }
  
  // ============================================================
  // مسح التوكنات
  // ============================================================
  
  /// مسح جميع التوكنات وبيانات الجلسة
  Future<void> clearTokens() async {
    await ensureInitialized();
    debugPrint('🗑️ [TokenManager] Clearing tokens...');
    
    await _delegate.clearTokens();
    
    debugPrint('✅ [TokenManager] Tokens cleared');
  }
  
  // ============================================================
  // بيانات المستخدم
  // ============================================================
  
  /// الحصول على بيانات المستخدم المخزنة
  Future<Map<String, dynamic>?> getUserData() async {
    await ensureInitialized();
    return _delegate.getUserData();
  }
  
  // ============================================================
  // معلومات التوكن
  // ============================================================
  
  /// الحصول على معلومات شاملة عن التوكن
  Future<Map<String, dynamic>> getTokenInfo() async {
    await ensureInitialized();
    return _delegate.getTokenInfo();
  }
  
  // ============================================================
  // أحداث الجلسة
  // ============================================================
  
  /// Stream لأحداث الجلسة
  Stream<SessionEvent> get sessionEvents => _delegate.sessionEvents;
  
  // ============================================================
  // تسجيل الخروج
  // ============================================================
  
  /// تسجيل الخروج (مسح التوكنات + إخطار الخادم)
  Future<bool> logout() async {
    await ensureInitialized();
    debugPrint('🚪 [TokenManager] Logging out...');
    
    try {
      final success = await _delegate.logout();
      debugPrint('✅ [TokenManager] Logout completed: $success');
      return success;
    } catch (e) {
      debugPrint('⚠️ [TokenManager] Logout error: $e');
      // حتى لو فشل، نمسح التوكنات محلياً
      await clearTokens();
      return false;
    }
  }
  
  // ============================================================
  // التخلص
  // ============================================================
  
  /// التخلص من الموارد
  void dispose() {
    _delegate.dispose();
    _isInitialized = false;
    debugPrint('🗑️ [TokenManager] Disposed');
  }
  
  /// إعادة تعيين الـ instance (للاختبارات)
  @visibleForTesting
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}

/// Extension للوصول السهل للـ delegate
extension TokenManagerDelegate on TokenManager {
  /// الحصول على الـ delegate الأصلي
  /// 
  /// استخدم هذا فقط إذا كنت تحتاج وظائف غير متوفرة في TokenManager
  UnifiedTokenManager get delegate => _delegate;
}
