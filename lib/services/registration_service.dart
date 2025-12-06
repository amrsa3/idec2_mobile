import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/registration_model.dart';
import 'enhanced_dio_service_v2.dart';

class RegistrationService {
  static final RegistrationService _instance = RegistrationService._internal();
  factory RegistrationService() => _instance;
  RegistrationService._internal();

  // Use EnhancedDioServiceV2 which has automatic token refresh interceptor
  Future<Dio> get _dio async {
    final dioService = EnhancedDioServiceV2.instance;
    await dioService.initialize();
    return dioService.dio;
  }

  /// Register to a conference
  Future<RegistrationModel> registerToConference({
    required String conferenceId,
    String? notes,
  }) async {
    try {
      final dio = await _dio;
      final response = await dio.post(
        '/api/v1/events/conferences/$conferenceId/register',
        data: {
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        // Handle ApiResponse structure: { success, messageAr, messageEn, code, data: { registration: {...} } }
        if (data.containsKey('data') && data['data'] is Map) {
          final dataMap = data['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('registration')) {
            return RegistrationModel.fromJson(dataMap['registration']);
          }
        }
        return RegistrationModel.fromJson(data);
      } else {
        throw Exception('Failed to register to conference');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String errorMessage = 'فشل في التسجيل';
      
      if (errorData is Map<String, dynamic>) {
        // Check for messageAr/messageEn (from ApiResponse)
        if (errorData.containsKey('messageAr') || errorData.containsKey('messageEn')) {
          final messageAr = errorData['messageAr'] as String? ?? '';
          final messageEn = errorData['messageEn'] as String? ?? '';
          errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
        }
        // Check for error.message (from HttpExceptionFilter)
        else if (errorData.containsKey('error') && errorData['error'] is Map) {
          final errorObj = errorData['error'] as Map<String, dynamic>;
          if (errorObj.containsKey('message')) {
            errorMessage = errorObj['message'] as String? ?? errorMessage;
          }
          // Also check for messageAr/messageEn in error object
          if (errorObj.containsKey('messageAr') || errorObj.containsKey('messageEn')) {
            final messageAr = errorObj['messageAr'] as String? ?? '';
            final messageEn = errorObj['messageEn'] as String? ?? '';
            errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
          }
        }
        // Fallback to top-level message
        else if (errorData.containsKey('message')) {
          errorMessage = errorData['message'] as String? ?? errorMessage;
        }
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error registering to conference: $e');
    }
  }

  /// Register to an event
  Future<RegistrationModel> registerToEvent({
    required String eventId,
    String? notes,
  }) async {
    try {
      final dio = await _dio;
      final response = await dio.post(
        '/api/v1/events/registrations',
        data: {
          'eventId': eventId,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        // Handle ApiResponse structure: { success, messageAr, messageEn, code, data: { registration: {...} } }
        Map<String, dynamic> registrationData;
        
        if (data.containsKey('data') && data['data'] is Map) {
          final dataMap = data['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('registration')) {
            registrationData = dataMap['registration'] as Map<String, dynamic>;
          } else {
            registrationData = dataMap;
          }
        } else {
          registrationData = data;
        }
        
        // Backend now sends all required fields, but we keep minimal defaults as fallback for edge cases
        // Only apply defaults if field is truly missing (not just null, which is valid)
        final completeRegistrationData = <String, dynamic>{
          ...registrationData,
        };
        
        // Only set defaults if field is completely missing (not null)
        if (!completeRegistrationData.containsKey('userId') || completeRegistrationData['userId'] == null) {
          completeRegistrationData['userId'] = '';
        }
        if (!completeRegistrationData.containsKey('registrationType') || completeRegistrationData['registrationType'] == null) {
          completeRegistrationData['registrationType'] = 'EVENT';
        }
        if (!completeRegistrationData.containsKey('status') || completeRegistrationData['status'] == null) {
          completeRegistrationData['status'] = 'UNDER_REVIEW';
        }
        if (!completeRegistrationData.containsKey('calculatedPrice') || completeRegistrationData['calculatedPrice'] == null) {
          completeRegistrationData['calculatedPrice'] = 0.0;
        }
        if (!completeRegistrationData.containsKey('currency') || completeRegistrationData['currency'] == null) {
          completeRegistrationData['currency'] = 'YER';
        }
        if (!completeRegistrationData.containsKey('createdAt') || completeRegistrationData['createdAt'] == null) {
          completeRegistrationData['createdAt'] = DateTime.now().toIso8601String();
        }
        
        return RegistrationModel.fromJson(completeRegistrationData);
      } else {
        throw Exception('Failed to register to event');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      
      // Check for Smart Messages System error response
      String errorMessage = 'فشل في التسجيل';
      
      if (errorData is Map<String, dynamic>) {
        // Check for messageAr/messageEn (from ApiResponse)
        if (errorData.containsKey('messageAr') || errorData.containsKey('messageEn')) {
          final messageAr = errorData['messageAr'] as String? ?? '';
          final messageEn = errorData['messageEn'] as String? ?? '';
          errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
        }
        // Check for error.message (from HttpExceptionFilter)
        else if (errorData.containsKey('error') && errorData['error'] is Map) {
          final errorObj = errorData['error'] as Map<String, dynamic>;
          if (errorObj.containsKey('message')) {
            errorMessage = errorObj['message'] as String? ?? errorMessage;
          }
          // Also check for messageAr/messageEn in error object
          if (errorObj.containsKey('messageAr') || errorObj.containsKey('messageEn')) {
            final messageAr = errorObj['messageAr'] as String? ?? '';
            final messageEn = errorObj['messageEn'] as String? ?? '';
            errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
          }
        }
        // Fallback to top-level message
        else if (errorData.containsKey('message')) {
          errorMessage = errorData['message'] as String? ?? errorMessage;
        }
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      // If it's already an Exception with a message, rethrow it
      if (e is Exception && !e.toString().contains('Error registering to event')) {
        rethrow;
      }
      throw Exception('خطأ في التسجيل: ${e.toString()}');
    }
  }

  /// Get user's registrations
  Future<List<RegistrationModel>> getMyRegistrations() async {
    try {
      final dio = await _dio;
      final response = await dio.get('/api/v1/events/registrations/my-registrations');

      if (response.statusCode == 200) {
        final dynamic decoded = response.data;
        
        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data') && decoded['data'] is List) {
          data = decoded['data'] as List;
        } else {
          throw Exception('Unexpected response format from server');
        }
        
        final registrations = data.map((json) {
          try {
            return RegistrationModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            throw Exception('Error parsing registration: $e');
          }
        }).toList();
        
        return registrations;
      } else {
        throw Exception('Failed to load registrations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching registrations: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Error fetching registrations: $e');
    }
  }

  /// Get registration details by ID
  Future<RegistrationModel> getRegistrationDetails(
      String registrationId) async {
    try {
      final dio = await _dio;
      final response = await dio.get('/api/v1/events/registrations/$registrationId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return RegistrationModel.fromJson(data);
      } else {
        throw Exception('Failed to load registration');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      throw Exception(errorData?['message'] ?? 'Failed to load registration');
    } catch (e) {
      throw Exception('Error fetching registration details: $e');
    }
  }

  /// Get user registration status for an event
  Future<Map<String, dynamic>?> getEventRegistrationStatus(String eventId) async {
    try {
      final dio = await _dio;
      final response = await dio.get('/api/v1/events/registrations/my-status/$eventId');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data;
      } else {
        throw Exception('Failed to get registration status');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // User not registered
        return null;
      }
      final errorData = e.response?.data;
      throw Exception(errorData?['message'] ?? 'Failed to get registration status');
    } catch (e) {
      if (e.toString().contains('404')) {
        return null; // Not registered
      }
      throw Exception('Error fetching registration status: $e');
    }
  }

  /// Get registration timeline
  Future<Map<String, dynamic>> getRegistrationTimeline(
      String registrationId) async {
    try {
      final dio = await _dio;
      final response = await dio.get('/api/v1/events/registrations/$registrationId/timeline');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load timeline: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Error fetching timeline');
    } catch (e) {
      throw Exception('Error fetching timeline: $e');
    }
  }

  /// Request reactivation for ON_HOLD registration
  Future<void> requestReactivation({
    required String registrationId,
    String? reason,
  }) async {
    try {
      final dio = await _dio;
      final response = await dio.post(
        '/api/v1/events/registrations/$registrationId/request-reactivation',
        data: {
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = response.data;
        // Try to get Arabic message first, then English, then default
        final message = errorData['messageAr'] ?? 
                       errorData['message'] ?? 
                       'فشل في طلب إعادة التفعيل';
        throw Exception(message);
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final message = errorData?['messageAr'] ?? 
                     errorData?['message'] ?? 
                     'فشل في طلب إعادة التفعيل';
      throw Exception(message);
    } catch (e) {
      throw Exception('Error requesting reactivation: $e');
    }
  }

  /// Complete payment (mark as paid)
  Future<void> completePayment({
    required String registrationId,
    String? paymentId,
    String? transactionId,
  }) async {
    try {
      final dio = await _dio;
      final response = await dio.post(
        '/api/v1/events/registrations/$registrationId/payment-completed',
        data: {
          if (paymentId != null) 'paymentId': paymentId,
          if (transactionId != null) 'transactionId': transactionId,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = response.data;
        throw Exception(errorData['message'] ?? 'فشل في تسجيل الدفع');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      throw Exception(errorData?['message'] ?? 'فشل في تسجيل الدفع');
    } catch (e) {
      throw Exception('Error completing payment: $e');
    }
  }
}
