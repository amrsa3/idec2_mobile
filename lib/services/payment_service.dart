import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/invoice_model.dart';
import '../models/payment_gateway_model.dart';
import '../models/payment_instruction_model.dart';
import '../models/transaction_model.dart';
import 'unified_token_manager.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final UnifiedTokenManager _tokenManager = UnifiedTokenManager.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenManager.getValidAccessToken();
    debugPrint('🔐 [PAYMENT_SERVICE] Getting headers with token: ${token != null ? "Present" : "Absent"}');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get invoice by registration ID
  Future<InvoiceModel> getInvoiceByRegistrationId(String registrationId) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/invoices/registration/$registrationId';

      print('📄 [PAYMENT_SERVICE] Fetching invoice from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📄 [PAYMENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return InvoiceModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب الفاتورة';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الفاتورة: ${e.toString()}');
    }
  }

  /// Get invoice by ID
  Future<InvoiceModel> getInvoiceById(String invoiceId) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/invoices/$invoiceId';

      print('📄 [PAYMENT_SERVICE] Fetching invoice from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return InvoiceModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب الفاتورة';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الفاتورة: ${e.toString()}');
    }
  }

  /// Get active payment gateways
  Future<List<PaymentGatewayModel>> getActiveGateways() async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/payments/gateways';

      print('🏦 [PAYMENT_SERVICE] Fetching gateways from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('🏦 [PAYMENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Filter only active gateways
        final activeGateways = data
            .map((json) => PaymentGatewayModel.fromJson(json))
            .where((gateway) => gateway.isActive)
            .toList();

        print(
            '🏦 [PAYMENT_SERVICE] Found ${activeGateways.length} active gateways');
        return activeGateways;
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب بوابات الدفع';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب بوابات الدفع: ${e.toString()}');
    }
  }

  /// Initiate electronic payment
  Future<Map<String, dynamic>> initiatePayment({
    required String invoiceId,
    required String gatewayId,
  }) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/transactions/electronic';

      print('💳 [PAYMENT_SERVICE] Initiating payment');
      print('   Invoice ID: $invoiceId');
      print('   Gateway ID: $gatewayId');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          'invoiceId': invoiceId,
          'gatewayId': gatewayId,
        }),
      );

      print('💳 [PAYMENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Parse transaction
        final transactionJson = data['transaction'] as Map<String, dynamic>;
        final transaction = TransactionModel.fromJson(transactionJson);

        // Parse payment instruction
        final instructionJson =
            data['paymentInstruction'] as Map<String, dynamic>;
        final paymentInstruction =
            PaymentInstructionModel.fromJson(instructionJson);

        return {
          'transaction': transaction,
          'paymentInstruction': paymentInstruction,
        };
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل بدء عملية الدفع';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في بدء عملية الدفع: ${e.toString()}');
    }
  }

  /// Confirm electronic payment
  Future<TransactionModel> confirmPayment({
    required String transactionId,
    required Map<String, dynamic> inputData,
  }) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/transactions/$transactionId/confirm';

      print('✅ [PAYMENT_SERVICE] Confirming payment');
      print('   Transaction ID: $transactionId');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          'inputData': inputData,
        }),
      );

      print('✅ [PAYMENT_SERVICE] Response status: ${response.statusCode}');
      print('✅ [PAYMENT_SERVICE] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ [PAYMENT_SERVICE] Parsed data keys: ${data.keys}');
        
        // Backend returns { transaction, paymentResult }, so extract transaction
        if (data.containsKey('transaction')) {
          final transactionJson = data['transaction'] as Map<String, dynamic>;
          print('✅ [PAYMENT_SERVICE] Transaction extracted successfully');
          print('✅ [PAYMENT_SERVICE] Transaction status: ${transactionJson['status']}');
          if (transactionJson.containsKey('errorMessage')) {
            print('⚠️ [PAYMENT_SERVICE] Transaction has error message: ${transactionJson['errorMessage']}');
          }
          return TransactionModel.fromJson(transactionJson);
        } else {
          // Fallback: if backend returns transaction directly
          print('⚠️ [PAYMENT_SERVICE] No transaction key found, trying direct parse');
          return TransactionModel.fromJson(data);
        }
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل تأكيد الدفع';
        print('❌ [PAYMENT_SERVICE] Error response: $errorBody');
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      print('❌ [PAYMENT_SERVICE] Exception during confirm payment: $e');
      print('❌ [PAYMENT_SERVICE] Stack trace: $stackTrace');
      
      if (e is Exception) {
        // Try to extract more details if it's an HTTP exception
        if (e.toString().contains('Exception')) {
          rethrow;
        }
      }
      throw Exception('خطأ في تأكيد الدفع: ${e.toString()}');
    }
  }

  /// Cancel electronic payment
  Future<void> cancelTransaction({
    required String transactionId,
    String? reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/transactions/$transactionId/cancel';

      print('🛑 [PAYMENT_SERVICE] Cancelling transaction: $transactionId');

      final body = reason != null ? {'reason': reason} : {};
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      print('🛑 [PAYMENT_SERVICE] Cancel response: ${response.statusCode}');

      if (response.statusCode != 200) {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'فشل إلغاء عملية الدفع';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في إلغاء عملية الدفع: ${e.toString()}');
    }
  }

  /// Get transaction by ID
  Future<TransactionModel> getTransactionById(String transactionId) async {
    try {
      final headers = await _getHeaders();
      final url =
          '${ApiConstants.baseUrl}/api/v1/payments/transactions/$transactionId';

      print('📋 [PAYMENT_SERVICE] Fetching transaction from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TransactionModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب المعاملة';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب المعاملة: ${e.toString()}');
    }
  }
}

