// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user_model.dart';

part 'auth_state.freezed.dart';

/// حالات المصادقة الموحدة
/// 
/// هذه الحالات تغطي جميع السيناريوهات الممكنة:
/// - [AuthState.initial] - الحالة الأولية عند بدء التطبيق
/// - [AuthState.loading] - جاري تحميل/معالجة عملية مصادقة
/// - [AuthState.authenticated] - المستخدم مسجل دخوله
/// - [AuthState.unauthenticated] - المستخدم غير مسجل دخوله
/// - [AuthState.phoneNotVerified] - الهاتف غير مفعل، يحتاج OTP
/// - [AuthState.error] - حدث خطأ
/// - [AuthState.sessionExpired] - انتهت صلاحية الجلسة
@freezed
class AuthState with _$AuthState {
  /// الحالة الأولية - عند بدء التطبيق
  const factory AuthState.initial() = AuthInitial;
  
  /// جاري التحميل - أثناء عمليات المصادقة
  const factory AuthState.loading({
    /// رسالة اختيارية لعرضها أثناء التحميل
    String? message,
  }) = AuthLoading;
  
  /// مُصادق - المستخدم مسجل دخوله بنجاح
  const factory AuthState.authenticated({
    /// بيانات المستخدم
    required UserModel user,
    /// هل تم تحديث البيانات حديثاً
    @Default(false) bool isRefreshed,
  }) = AuthAuthenticated;
  
  /// غير مُصادق - المستخدم غير مسجل دخوله
  const factory AuthState.unauthenticated({
    /// رسالة اختيارية (مثلاً: "تم تسجيل الخروج بنجاح")
    String? message,
  }) = AuthUnauthenticated;
  
  /// الهاتف غير مُفعل - يحتاج التحقق عبر OTP
  const factory AuthState.phoneNotVerified({
    /// رقم الهاتف الذي يحتاج التفعيل
    required String phone,
    /// رسالة للمستخدم
    String? message,
    /// هل تم إرسال OTP بالفعل
    @Default(false) bool otpSent,
  }) = AuthPhoneNotVerified;
  
  /// حدث خطأ
  const factory AuthState.error({
    /// رسالة الخطأ
    required String message,
    /// كود الخطأ (اختياري)
    String? code,
    /// هل يمكن إعادة المحاولة
    @Default(true) bool canRetry,
  }) = AuthError;
  
  /// انتهت صلاحية الجلسة
  const factory AuthState.sessionExpired({
    /// سبب انتهاء الجلسة
    String? reason,
    /// هل يجب التوجيه لصفحة تسجيل الدخول
    @Default(true) bool shouldRedirectToLogin,
  }) = AuthSessionExpired;
}

/// Extension methods للحصول على معلومات من الحالة بسهولة
extension AuthStateExtension on AuthState {
  /// هل المستخدم مُصادق؟
  bool get isAuthenticated => this is AuthAuthenticated;
  
  /// هل جاري التحميل؟
  bool get isLoading => this is AuthLoading;
  
  /// هل يوجد خطأ؟
  bool get hasError => this is AuthError;
  
  /// هل الهاتف غير مُفعل؟
  bool get isPhoneNotVerified => this is AuthPhoneNotVerified;
  
  /// هل الجلسة منتهية؟
  bool get isSessionExpired => this is AuthSessionExpired;
  
  /// الحصول على المستخدم (null إذا غير مُصادق)
  UserModel? get user {
    return maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );
  }
  
  /// الحصول على رسالة الخطأ (null إذا لا يوجد خطأ)
  String? get errorMessage {
    return maybeWhen(
      error: (message, _, __) => message,
      orElse: () => null,
    );
  }
  
  /// الحصول على رقم الهاتف غير المُفعل
  String? get unverifiedPhone {
    return maybeWhen(
      phoneNotVerified: (phone, _, __) => phone,
      orElse: () => null,
    );
  }
}
