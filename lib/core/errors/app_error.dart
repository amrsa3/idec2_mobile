import 'package:dio/dio.dart';

/// Base class for all application errors
abstract class AppError {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related errors
class NetworkError extends AppError {
  final int? statusCode;
  final bool isTimeout;
  final bool isConnectionError;

  const NetworkError({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
    this.isTimeout = false,
    this.isConnectionError = false,
  });

  factory NetworkError.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError(
          message: 'Connection timeout',
          code: 'TIMEOUT',
          originalError: error,
          isTimeout: true,
        );
      
      case DioExceptionType.connectionError:
        return NetworkError(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
          originalError: error,
          isConnectionError: true,
        );
      
      case DioExceptionType.badResponse:
        return NetworkError(
          message: _getErrorMessageFromResponse(error.response),
          code: error.response?.statusCode.toString(),
          originalError: error,
          statusCode: error.response?.statusCode,
        );
      
      case DioExceptionType.cancel:
        return NetworkError(
          message: 'Request was cancelled',
          code: 'CANCELLED',
          originalError: error,
        );
      
      case DioExceptionType.unknown:
      default:
        return NetworkError(
          message: 'Network error occurred',
          code: 'UNKNOWN',
          originalError: error,
        );
    }
  }

  static String _getErrorMessageFromResponse(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] ?? data['error'] ?? 'Server error occurred';
    }
    return 'Server error occurred';
  }

  bool get isRetryable => isTimeout || isConnectionError || (statusCode != null && statusCode! >= 500);
}

/// Authentication-related errors
class AuthError extends AppError {
  final bool requiresReauth;
  final bool isTokenExpired;

  const AuthError({
    required super.message,
    super.code,
    super.originalError,
    this.requiresReauth = false,
    this.isTokenExpired = false,
  });

  factory AuthError.unauthorized() {
    return const AuthError(
      message: 'Authentication required',
      code: 'UNAUTHORIZED',
      requiresReauth: true,
    );
  }

  factory AuthError.tokenExpired() {
    return const AuthError(
      message: 'Session expired',
      code: 'TOKEN_EXPIRED',
      requiresReauth: true,
      isTokenExpired: true,
    );
  }

  factory AuthError.invalidCredentials() {
    return const AuthError(
      message: 'Invalid credentials',
      code: 'INVALID_CREDENTIALS',
    );
  }
}

/// Validation-related errors
class ValidationError extends AppError {
  final Map<String, List<String>>? fieldErrors;

  const ValidationError({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  factory ValidationError.fromMap(Map<String, dynamic> errors) {
    final fieldErrors = <String, List<String>>{};
    
    errors.forEach((key, value) {
      if (value is List) {
        fieldErrors[key] = value.cast<String>();
      } else if (value is String) {
        fieldErrors[key] = [value];
      }
    });

    return ValidationError(
      message: 'Validation failed',
      code: 'VALIDATION_ERROR',
      fieldErrors: fieldErrors,
    );
  }
}

/// File operation errors
class FileError extends AppError {
  final String? filePath;
  final String? fileType;

  const FileError({
    required super.message,
    super.code,
    super.originalError,
    this.filePath,
    this.fileType,
  });

  factory FileError.fileTooLarge(String? fileName) {
    return FileError(
      message: 'File size is too large',
      code: 'FILE_TOO_LARGE',
      filePath: fileName,
    );
  }

  factory FileError.invalidFormat(String? fileName, String? expectedType) {
    return FileError(
      message: 'Invalid file format',
      code: 'INVALID_FORMAT',
      filePath: fileName,
      fileType: expectedType,
    );
  }

  factory FileError.uploadFailed(String? fileName) {
    return FileError(
      message: 'File upload failed',
      code: 'UPLOAD_FAILED',
      filePath: fileName,
    );
  }
}

/// Server maintenance errors
class MaintenanceError extends AppError {
  final DateTime? estimatedEndTime;
  final String? maintenanceType;

  const MaintenanceError({
    required super.message,
    super.code,
    super.originalError,
    this.estimatedEndTime,
    this.maintenanceType,
  });

  factory MaintenanceError.scheduled({
    String? message,
    DateTime? endTime,
  }) {
    return MaintenanceError(
      message: message ?? 'Server is under maintenance',
      code: 'MAINTENANCE',
      estimatedEndTime: endTime,
      maintenanceType: 'scheduled',
    );
  }

  factory MaintenanceError.emergency({
    String? message,
  }) {
    return MaintenanceError(
      message: message ?? 'Emergency maintenance in progress',
      code: 'EMERGENCY_MAINTENANCE',
      maintenanceType: 'emergency',
    );
  }
}

/// Business logic errors
class BusinessError extends AppError {
  final String? action;

  const BusinessError({
    required super.message,
    super.code,
    super.originalError,
    this.action,
  });

  factory BusinessError.registrationClosed() {
    return const BusinessError(
      message: 'Registration is currently closed',
      code: 'REGISTRATION_CLOSED',
      action: 'registration',
    );
  }

  factory BusinessError.accountNotVerified() {
    return const BusinessError(
      message: 'Account verification required',
      code: 'ACCOUNT_NOT_VERIFIED',
      action: 'verification',
    );
  }
}

/// Unknown or unexpected errors
class UnknownError extends AppError {
  const UnknownError({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN',
    super.originalError,
  });
}
