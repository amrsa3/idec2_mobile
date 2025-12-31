/// استثناءات المصادقة المخصصة
/// 
/// توفر هذه الملفات استثناءات محددة لكل نوع من أخطاء المصادقة
/// مما يسهل معالجة الأخطاء بشكل دقيق

/// الاستثناء الأساسي للمصادقة
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AuthException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AuthException: $message (code: $code)';
  
  /// إنشاء من خطأ عام
  factory AuthException.fromError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AuthException) return error;
    return AuthException(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}

/// خطأ في بيانات الاعتماد (اسم المستخدم أو كلمة المرور غير صحيحة)
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    String message = 'بيانات الاعتماد غير صحيحة',
    String? code,
  }) : super(message: message, code: code ?? 'INVALID_CREDENTIALS');
}

/// خطأ الهاتف غير موجود
class PhoneNotFoundException extends AuthException {
  final String phone;
  
  const PhoneNotFoundException({
    required this.phone,
    String message = 'رقم الهاتف غير مسجل',
    String? code,
  }) : super(message: message, code: code ?? 'PHONE_NOT_FOUND');
}

/// خطأ الهاتف غير متحقق منه
class PhoneNotVerifiedException extends AuthException {
  final String phone;
  
  const PhoneNotVerifiedException({
    required this.phone,
    String message = 'رقم الهاتف غير متحقق منه',
    String? code,
  }) : super(message: message, code: code ?? 'PHONE_NOT_VERIFIED');
}

/// خطأ الهاتف مستخدم مسبقاً
class PhoneAlreadyExistsException extends AuthException {
  final String phone;
  
  const PhoneAlreadyExistsException({
    required this.phone,
    String message = 'رقم الهاتف مستخدم بالفعل',
    String? code,
  }) : super(message: message, code: code ?? 'PHONE_ALREADY_EXISTS');
}

/// خطأ OTP غير صحيح
class InvalidOtpException extends AuthException {
  const InvalidOtpException({
    String message = 'رمز التحقق غير صحيح',
    String? code,
  }) : super(message: message, code: code ?? 'INVALID_OTP');
}

/// خطأ OTP منتهي الصلاحية
class OtpExpiredException extends AuthException {
  const OtpExpiredException({
    String message = 'انتهت صلاحية رمز التحقق',
    String? code,
  }) : super(message: message, code: code ?? 'OTP_EXPIRED');
}

/// خطأ تجاوز عدد محاولات OTP
class OtpRateLimitException extends AuthException {
  final Duration? retryAfter;
  
  const OtpRateLimitException({
    this.retryAfter,
    String message = 'تم تجاوز عدد المحاولات المسموح به',
    String? code,
  }) : super(message: message, code: code ?? 'OTP_RATE_LIMIT');
}

/// خطأ انتهاء صلاحية التوكن
class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    String message = 'انتهت صلاحية الجلسة',
    String? code,
  }) : super(message: message, code: code ?? 'TOKEN_EXPIRED');
}

/// خطأ فشل تجديد التوكن
class TokenRefreshException extends AuthException {
  const TokenRefreshException({
    String message = 'فشل في تجديد الجلسة',
    String? code,
    dynamic originalError,
  }) : super(
    message: message, 
    code: code ?? 'TOKEN_REFRESH_FAILED',
    originalError: originalError,
  );
}

/// خطأ انتهاء الجلسة
class SessionExpiredException extends AuthException {
  final String? reason;
  
  const SessionExpiredException({
    this.reason,
    String message = 'انتهت صلاحية الجلسة',
    String? code,
  }) : super(message: message, code: code ?? 'SESSION_EXPIRED');
}

/// خطأ عدم الاتصال بالشبكة
class NetworkException extends AuthException {
  const NetworkException({
    String message = 'لا يوجد اتصال بالإنترنت',
    String? code,
    dynamic originalError,
  }) : super(
    message: message, 
    code: code ?? 'NETWORK_ERROR',
    originalError: originalError,
  );
}

/// خطأ في الخادم
class ServerException extends AuthException {
  final int? statusCode;
  
  const ServerException({
    this.statusCode,
    String message = 'خطأ في الخادم',
    String? code,
    dynamic originalError,
  }) : super(
    message: message, 
    code: code ?? 'SERVER_ERROR',
    originalError: originalError,
  );
}

/// خطأ صيانة الخادم
class MaintenanceException extends AuthException {
  final DateTime? expectedEndTime;
  
  const MaintenanceException({
    this.expectedEndTime,
    String message = 'الخادم تحت الصيانة',
    String? code,
  }) : super(message: message, code: code ?? 'MAINTENANCE');
}

/// خطأ التسجيل مغلق
class RegistrationClosedException extends AuthException {
  const RegistrationClosedException({
    String message = 'التسجيل مغلق حالياً',
    String? code,
  }) : super(message: message, code: code ?? 'REGISTRATION_CLOSED');
}

/// خطأ الحساب معطل
class AccountDisabledException extends AuthException {
  final String? reason;
  
  const AccountDisabledException({
    this.reason,
    String message = 'الحساب معطل',
    String? code,
  }) : super(message: message, code: code ?? 'ACCOUNT_DISABLED');
}

/// خطأ الحساب محظور
class AccountBlockedException extends AuthException {
  final DateTime? blockedUntil;
  final String? reason;
  
  const AccountBlockedException({
    this.blockedUntil,
    this.reason,
    String message = 'الحساب محظور',
    String? code,
  }) : super(message: message, code: code ?? 'ACCOUNT_BLOCKED');
}

/// خطأ كلمة المرور ضعيفة
class WeakPasswordException extends AuthException {
  final List<String>? requirements;
  
  const WeakPasswordException({
    this.requirements,
    String message = 'كلمة المرور ضعيفة',
    String? code,
  }) : super(message: message, code: code ?? 'WEAK_PASSWORD');
}

/// خطأ البيانات غير صالحة
class ValidationException extends AuthException {
  final Map<String, String>? fieldErrors;
  
  const ValidationException({
    this.fieldErrors,
    String message = 'بيانات غير صالحة',
    String? code,
  }) : super(message: message, code: code ?? 'VALIDATION_ERROR');
}

/// خطأ غير معروف
class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    String message = 'خطأ غير متوقع',
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message, 
    code: code ?? 'UNKNOWN_ERROR',
    originalError: originalError,
    stackTrace: stackTrace,
  );
}
