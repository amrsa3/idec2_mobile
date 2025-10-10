import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'api_response_model.freezed.dart';
part 'api_response_model.g.dart';

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required bool success,
    required String message,
    @JsonKey(name: 'data') Map<String, dynamic>? data,
    List<String>? errors,
    Map<String, dynamic>? metadata,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  // Safe fromJson with detailed debugging
  factory ApiResponse.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('ApiResponse.fromJsonSafe: Starting parsing');
      debugPrint('ApiResponse.fromJsonSafe: Input JSON: $json');
      
      // Extract fields with safe casting
      final success = json['success'] as bool? ?? true; // Default to true if not present
      final message = json['message'] as String? ?? '';
      final data = json['data'] as Map<String, dynamic>?;
      final errors = (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList();
      final metadata = json['metadata'] as Map<String, dynamic>?;
      
      final apiResponse = ApiResponse(
        success: success,
        message: message,
        data: data,
        errors: errors,
        metadata: metadata,
      );
      
      debugPrint('ApiResponse.fromJsonSafe: Success');
      return apiResponse;
      
    } catch (e, stackTrace) {
      debugPrint('ApiResponse.fromJsonSafe: Error: $e');
      debugPrint('ApiResponse.fromJsonSafe: Stack trace: $stackTrace');
      rethrow;
    }
  }
}

@freezed
class ServerSettingsModel with _$ServerSettingsModel {
  const factory ServerSettingsModel({
    required bool registrationEnabled,
    required List<String> availableOtpChannels,
    required List<String> supportedLanguages,
    required String defaultLanguage,
    required Map<String, dynamic> appConfig,
    String? maintenanceMessage,
    bool? isMaintenanceMode,
  }) = _ServerSettingsModel;

  factory ServerSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ServerSettingsModelFromJson(json);
}

@freezed
class HealthCheckModel with _$HealthCheckModel {
  const factory HealthCheckModel({
    required String status,
    required String version,
    required DateTime timestamp,
    Map<String, dynamic>? services,
  }) = _HealthCheckModel;

  factory HealthCheckModel.fromJson(Map<String, dynamic> json) =>
      _$HealthCheckModelFromJson(json);
}

@freezed
class ErrorModel with _$ErrorModel {
  const factory ErrorModel({
    required String code,
    required String message,
    String? details,
    Map<String, dynamic>? context,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
}
