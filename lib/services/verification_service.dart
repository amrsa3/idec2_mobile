import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'api_service.dart';
import 'dio_service.dart';

class VerificationService {
  static VerificationService? _instance;
  static VerificationService get instance => _instance ??= VerificationService._internal();

  late ApiService _apiService;

  VerificationService._internal() {
    _apiService = ApiService(DioService.instance.dio);
  }

  // Get verification rules
  Future<VerificationRulesModel> getVerificationRules() async {
    try {
      return await _apiService.getVerificationRules();
    } catch (e) {
      debugPrint('Error getting verification rules: $e');
      rethrow;
    }
  }

  // Get verification requests
  Future<List<VerificationRequestModel>> getVerificationRequests({
    String? status,
    int? page,
    int? limit,
  }) async {
    try {
      // Return empty list for now - API implementation needed
      return [];
    } catch (e) {
      debugPrint('Error getting verification requests: $e');
      rethrow;
    }
  }

  // Submit verification request
  Future<VerificationRequestModel> submitVerificationRequest({
    required String documentType,
    required String documentUrl,
    String? description,
  }) async {
    try {
      final request = SubmitVerificationRequest(
        requestType: VerificationRequestType.documentVerification,
        newData: {
          'documentType': documentType,
          'documentUrl': documentUrl,
          'description': description,
        },
      );
      // Return mock data for now - API implementation needed
      return VerificationRequestModel(
        id: 'temp_id',
        userId: 'temp_user',
        requestType: VerificationRequestType.documentVerification,
        newData: request.newData,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error submitting verification request: $e');
      rethrow;
    }
  }

  // Get verification request by ID
  Future<VerificationRequestModel> getVerificationRequest(String requestId) async {
    try {
      return await _apiService.getVerificationRequest(requestId);
    } catch (e) {
      debugPrint('Error getting verification request: $e');
      rethrow;
    }
  }

  // Approve verification request (admin only)
  Future<void> approveVerificationRequest(String requestId) async {
    try {
      await _apiService.approveVerificationRequest(requestId);
    } catch (e) {
      debugPrint('Error approving verification request: $e');
      rethrow;
    }
  }

  // Reject verification request (admin only)
  Future<void> rejectVerificationRequest(String requestId, String reason) async {
    try {
      final request = {'reason': reason};
      await _apiService.rejectVerificationRequest(requestId, request);
    } catch (e) {
      debugPrint('Error rejecting verification request: $e');
      rethrow;
    }
  }

  // Upload verification document
  Future<void> uploadVerificationDocument({
    required String documentType,
    required String fileId,
    String? description,
  }) async {
    try {
      final request = DocumentUploadRequest(
        documentType: documentType,
        fileId: fileId,
        description: description,
      );
      await _apiService.uploadVerificationDocument(request);
    } catch (e) {
      debugPrint('Error uploading verification document: $e');
      rethrow;
    }
  }
}
