import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

class DecimalConverter implements JsonConverter<double, dynamic> {
  const DecimalConverter();

  @override
  double fromJson(dynamic json) {
    if (json is num) {
      return json.toDouble();
    } else if (json is String) {
      return double.parse(json);
    }
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'invoiceId') required String invoiceId,
    @JsonKey(name: 'paymentMethod') required String paymentMethod, // ELECTRONIC, CASH
    @DecimalConverter() required double amount,
    @JsonKey(name: 'currencyCode') required String currencyCode,
    required String type, // PAYMENT, REFUND, FEE
    required String status, // PENDING, SUCCESSFUL, FAILED, CANCELLED
    @JsonKey(name: 'gatewayId') String? gatewayId,
    @JsonKey(name: 'gatewayRequestId') String? gatewayRequestId,
    @JsonKey(name: 'gatewayTransactionId') String? gatewayTransactionId,
    @JsonKey(name: 'timestampInitiated') required DateTime timestampInitiated,
    @JsonKey(name: 'timestampCompleted') DateTime? timestampCompleted,
    @JsonKey(name: 'errorCode') String? errorCode,
    @JsonKey(name: 'errorMessage') String? errorMessage,
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    // Relations
    @JsonKey(name: 'gateway') Map<String, dynamic>? gateway,
    @JsonKey(name: 'invoice') Map<String, dynamic>? invoice,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionModelExtensions on TransactionModel {
  bool get isPending => status == 'PENDING';
  bool get isSuccessful => status == 'SUCCESSFUL';
  bool get isFailed => status == 'FAILED';
  bool get isCancelled => status == 'CANCELLED';

  bool get isElectronic => paymentMethod == 'ELECTRONIC';
  bool get isCash => paymentMethod == 'CASH';

  String get statusAr {
    switch (status) {
      case 'PENDING':
        return 'قيد المعالجة';
      case 'SUCCESSFUL':
        return 'ناجحة';
      case 'FAILED':
        return 'فاشلة';
      case 'CANCELLED':
        return 'ملغاة';
      default:
        return status;
    }
  }

  String get paymentMethodAr {
    switch (paymentMethod) {
      case 'ELECTRONIC':
        return 'إلكتروني';
      case 'CASH':
        return 'نقدي';
      default:
        return paymentMethod;
    }
  }

  /// Format amount with currency
  String get formattedAmount {
    return '${amount.toStringAsFixed(2)} $currencyCode';
  }

  /// Get gateway name from relation
  String get gatewayName {
    if (gateway != null) {
      return gateway?['name'] ?? 'غير محدد';
    }
    return 'غير محدد';
  }
}

