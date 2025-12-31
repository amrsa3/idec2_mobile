/// طبقة التوافق مع النظام القديم
/// 
/// هذا الملف يوفر توافقاً عكسياً مع الكود القديم الذي يستخدم:
/// - `compatibleAuthProvider`
/// - `enhancedAuthProvider`
/// - `CompatibleAuthState`
/// 
/// الاستخدام:
/// بدلاً من تحديث جميع الملفات دفعة واحدة، يمكنك:
/// 1. استبدال imports القديمة بهذا الملف
/// 2. الكود القديم سيعمل بدون تعديل
/// 3. ترحيل الملفات تدريجياً إلى النظام الجديد
/// 
/// ⚠️ هذا الملف مؤقت وسيتم حذفه بعد اكتمال الترحيل

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../services/compatible_auth_service.dart' as old_auth;
import 'auth_provider.dart';
import 'auth_state.dart';
import 'auth_service.dart';

// ============================================================
// Re-exports للتوافق
// ============================================================

// تصدير الأنواع الجديدة كبديل
export 'auth_state.dart';
export 'auth_provider.dart';
export 'auth_service.dart';

// ============================================================
// Compatibility Aliases
// ============================================================

/// Alias للـ provider الجديد باسم قديم
/// 
/// استخدم هذا مؤقتاً في الملفات التي تستخدم enhancedAuthProvider
/// 
/// ```dart
/// // قبل
/// final state = ref.watch(enhancedAuthProvider);
/// 
/// // بعد (باستخدام هذا الـ alias)
/// final state = ref.watch(enhancedAuthProvider);
/// // أو الأفضل
/// final state = ref.watch(authProvider);
/// ```
@Deprecated('Use authProvider instead')
final enhancedAuthProvider = authProvider;

/// Alias آخر للتوافق
@Deprecated('Use authProvider instead')
final unifiedAuthProvider = authProvider;

// ============================================================
// Compatible Auth State (للتوافق مع الكود القديم)
// ============================================================

/// حالة المصادقة المتوافقة مع الكود القديم
/// 
/// هذا الـ class يحاكي الـ CompatibleAuthState القديم
@Deprecated('Use AuthState instead')
class CompatibleAuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;
  final String? unverifiedPhoneNumber;
  final bool sessionExpired;
  final Map<String, dynamic>? lastResponse;
  
  const CompatibleAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.unverifiedPhoneNumber,
    this.sessionExpired = false,
    this.lastResponse,
  });
  
  /// إنشاء من AuthState الجديد
  factory CompatibleAuthState.fromAuthState(AuthState state) {
    return state.when(
      initial: () => const CompatibleAuthState(),
      loading: (message) => CompatibleAuthState(
        isLoading: true,
        error: message,
      ),
      authenticated: (user, _) => CompatibleAuthState(
        isAuthenticated: true,
        user: user,
      ),
      unauthenticated: (message) => CompatibleAuthState(
        error: message,
      ),
      phoneNotVerified: (phone, message, _) => CompatibleAuthState(
        unverifiedPhoneNumber: phone,
        error: message,
      ),
      error: (message, code, _) => CompatibleAuthState(
        error: message,
      ),
      sessionExpired: (reason, _) => CompatibleAuthState(
        sessionExpired: true,
        error: reason,
      ),
    );
  }
  
  /// نسخة معدلة
  CompatibleAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
    String? unverifiedPhoneNumber,
    bool? sessionExpired,
    Map<String, dynamic>? lastResponse,
  }) {
    return CompatibleAuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
      unverifiedPhoneNumber: unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      lastResponse: lastResponse ?? this.lastResponse,
    );
  }
}

// ============================================================
// Compatible Auth Provider (للترحيل التدريجي)
// ============================================================

/// مُزود متوافق يُرجع CompatibleAuthState
/// 
/// يمكن استخدامه في الملفات القديمة التي تتوقع CompatibleAuthState
/// 
/// ```dart
/// // الكود القديم يعمل بدون تعديل
/// final state = ref.watch(compatibleAuthStateProvider);
/// if (state.isAuthenticated) {
///   print(state.user?.fullName);
/// }
/// ```
@Deprecated('Use authProvider instead')
final compatibleAuthStateProvider = Provider<CompatibleAuthState>((ref) {
  final state = ref.watch(authProvider);
  return CompatibleAuthState.fromAuthState(state);
});

// ============================================================
// Bridge to Old System
// ============================================================

/// جسر للنظام القديم
/// 
/// يسمح بالوصول للـ CompatibleAuthService القديم للملفات التي تحتاجه
/// 
/// ⚠️ استخدم هذا فقط إذا كنت تحتاج وظائف غير موجودة في النظام الجديد
@Deprecated('Use AuthService.instance instead')
final legacyAuthServiceProvider = Provider<old_auth.CompatibleAuthService>((ref) {
  return old_auth.CompatibleAuthService.instance;
});

// ============================================================
// Migration Helpers
// ============================================================

/// Extension لتسهيل الترحيل من CompatibleAuthState إلى AuthState
extension CompatibleAuthStateMigration on CompatibleAuthState {
  /// تحويل إلى AuthState
  AuthState toAuthState() {
    if (isLoading) {
      return AuthState.loading(message: error);
    }
    if (sessionExpired) {
      return AuthState.sessionExpired(reason: error);
    }
    if (unverifiedPhoneNumber != null) {
      return AuthState.phoneNotVerified(
        phone: unverifiedPhoneNumber!,
        message: error,
      );
    }
    if (error != null && !isAuthenticated) {
      return AuthState.error(message: error!);
    }
    if (isAuthenticated && user != null) {
      return AuthState.authenticated(user: user!);
    }
    return const AuthState.unauthenticated();
  }
}

/// Extension للـ Ref لتسهيل الترحيل
extension AuthRefExtension on Ref {
  /// الحصول على حالة المصادقة (جديد)
  AuthState get authState => watch(authProvider);
  
  /// هل المستخدم مُصادق
  bool get isAuthenticated => watch(isAuthenticatedProvider);
  
  /// المستخدم الحالي
  UserModel? get currentUser => watch(currentUserProvider);
  
  /// خدمة المصادقة
  AuthService get authService => AuthService.instance;
}

/// Extension للـ WidgetRef لتسهيل الترحيل
extension AuthWidgetRefExtension on WidgetRef {
  /// الحصول على حالة المصادقة (جديد)
  AuthState get authState => watch(authProvider);
  
  /// هل المستخدم مُصادق
  bool get isAuthenticated => watch(isAuthenticatedProvider);
  
  /// المستخدم الحالي
  UserModel? get currentUser => watch(currentUserProvider);
  
  /// مدير المصادقة
  AuthNotifier get authNotifier => read(authProvider.notifier);
}

// ============================================================
// Deprecation Notices
// ============================================================

/// دليل الترحيل:
/// 
/// | القديم | الجديد |
/// |--------|--------|
/// | `compatibleAuthProvider` | `authProvider` |
/// | `enhancedAuthProvider` | `authProvider` |
/// | `CompatibleAuthState` | `AuthState` |
/// | `CompatibleAuthService.instance` | `AuthService.instance` |
/// | `state.isAuthenticated` | `state.isAuthenticated` (نفسه) |
/// | `state.user` | `state.user` (نفسه) |
/// | `ref.read(compatibleAuthProvider.notifier).loginWithPhone(...)` | `ref.read(authProvider.notifier).loginWithPhone(...)` |
