import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../services/enhanced_session_manager.dart';

/// مدير الجلسات الموحد
/// 
/// هذه طبقة wrapper تغلف EnhancedSessionManager الموجود
/// للحفاظ على التوافق العكسي وتوفير واجهة موحدة
class SessionManager {
  static SessionManager? _instance;
  static SessionManager get instance => _instance ??= SessionManager._();
  
  SessionManager._();
  
  /// المندوب - يستخدم EnhancedSessionManager الموجود
  EnhancedSessionManager get _delegate => EnhancedSessionManager.instance;
  
  /// هل تم التهيئة
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  // ============================================================
  // التهيئة
  // ============================================================
  
  /// تهيئة مدير الجلسات
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ [SessionManager] Already initialized');
      return;
    }
    
    try {
      await _delegate.initialize();
      _isInitialized = true;
      debugPrint('✅ [SessionManager] Initialized successfully');
    } catch (e) {
      debugPrint('❌ [SessionManager] Initialization failed: $e');
      // لا نرمي الخطأ لأن الجلسات ليست حرجة
    }
  }
  
  /// التأكد من التهيئة
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // ============================================================
  // إدارة الجلسة
  // ============================================================
  
  /// بدء جلسة جديدة
  Future<void> startSession({
    required String userId,
    String? deviceId,
    Map<String, dynamic>? metadata,
  }) async {
    await ensureInitialized();
    
    debugPrint('🟢 [SessionManager] Starting session for user: $userId');
    
    try {
      // EnhancedSessionManager يتطلب deviceId
      final actualDeviceId = deviceId ?? 'device_${DateTime.now().millisecondsSinceEpoch}';
      
      await _delegate.startSession(
        userId: userId,
        deviceId: actualDeviceId,
        metadata: metadata,
      );
      debugPrint('✅ [SessionManager] Session started');
    } catch (e) {
      debugPrint('❌ [SessionManager] Failed to start session: $e');
    }
  }
  
  /// إنهاء الجلسة الحالية
  Future<void> endSession({String? reason}) async {
    await ensureInitialized();
    
    debugPrint('🔴 [SessionManager] Ending session${reason != null ? ": $reason" : ""}');
    
    try {
      await _delegate.endSession(reason: reason);
      debugPrint('✅ [SessionManager] Session ended');
    } catch (e) {
      debugPrint('❌ [SessionManager] Failed to end session: $e');
    }
  }
  
  /// مسح بيانات الجلسة
  Future<void> clearSession() async {
    await ensureInitialized();
    
    debugPrint('🗑️ [SessionManager] Clearing session...');
    
    try {
      // EnhancedSessionManager يستخدم endSession بدلاً من clearSession
      await _delegate.endSession(reason: 'Session cleared');
      debugPrint('✅ [SessionManager] Session cleared');
    } catch (e) {
      debugPrint('❌ [SessionManager] Failed to clear session: $e');
    }
  }
  
  // ============================================================
  // حالة الجلسة
  // ============================================================
  
  /// هل يوجد جلسة نشطة
  bool get hasActiveSession => _delegate.isSessionActive;
  
  /// الحصول على بيانات الجلسة الحالية
  Future<SessionData?> get currentSession async => await _delegate.getCurrentSession();
  
  /// الحصول على معرف المستخدم الحالي
  Future<String?> get currentUserId async => (await _delegate.getCurrentSession())?.userId;
  
  // ============================================================
  // تحديث النشاط
  // ============================================================
  
  /// تحديث وقت آخر نشاط
  Future<void> updateActivity({
    Map<String, dynamic>? metadata,
  }) async {
    await ensureInitialized();
    
    try {
      await _delegate.updateActivity(metadata: metadata);
    } catch (e) {
      debugPrint('⚠️ [SessionManager] Failed to update activity: $e');
    }
  }
  
  // ============================================================
  // أحداث الجلسة
  // ============================================================
  
  /// Stream لأحداث انتهاء الجلسة
  Stream<SessionExpiredEvent> get sessionExpiredStream => _delegate.sessionExpiredStream;
  
  /// Stream لأحداث تغيير حالة الجلسة
  Stream<SessionStateEvent> get sessionStateStream => _delegate.sessionStateStream;
  
  // ============================================================
  // التخلص
  // ============================================================
  
  /// التخلص من الموارد
  void dispose() {
    _delegate.dispose();
    _isInitialized = false;
    debugPrint('🗑️ [SessionManager] Disposed');
  }
  
  /// إعادة تعيين الـ instance (للاختبارات)
  @visibleForTesting
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}

/// Extension للوصول للـ delegate
extension SessionManagerDelegate on SessionManager {
  /// الحصول على الـ delegate الأصلي
  EnhancedSessionManager get delegate => _delegate;
}
