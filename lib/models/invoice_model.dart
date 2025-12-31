import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

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
class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required String id,
    @JsonKey(name: 'invoiceNumber') required String invoiceNumber,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'registrationId') String? registrationId,
    @JsonKey(name: 'eventId') String? eventId,
    @JsonKey(name: 'conferenceId') String? conferenceId,
    required String status, // UNPAID, PAID, CANCELLED
    required String description,
    @DecimalConverter() @JsonKey(name: 'amountDue') required double amountDue,
    @JsonKey(name: 'currencyCode') required String currencyCode,
    @JsonKey(name: 'issueDate') required DateTime issueDate,
    @JsonKey(name: 'dueDate') DateTime? dueDate,
    @JsonKey(name: 'revenueType') required String revenueType,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    // Relations
    @JsonKey(name: 'user') Map<String, dynamic>? user,
    @JsonKey(name: 'event') Map<String, dynamic>? event,
    @JsonKey(name: 'conference') Map<String, dynamic>? conference,
    @JsonKey(name: 'registration') Map<String, dynamic>? registration,
    @JsonKey(name: 'transactions') List<Map<String, dynamic>>? transactions,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}

extension InvoiceModelExtensions on InvoiceModel {
  bool get isUnpaid => status == 'UNPAID';
  bool get isPaid => status == 'PAID';
  bool get isCancelled => status == 'CANCELLED';

  String get entityTitle {
    if (conference != null) {
      return conference?['nameAr'] ?? conference?['nameEn'] ?? 'مؤتمر';
    } else if (event != null) {
      return event?['title'] ?? 'فعالية';
    }
    return 'فعالية';
  }

  String get statusAr {
    switch (status) {
      case 'UNPAID':
        return 'غير مدفوعة';
      case 'PAID':
        return 'مدفوعة';
      case 'CANCELLED':
        return 'ملغاة';
      default:
        return status;
    }
  }

  String? get registrationStatus {
    return registration?['status'];
  }

  /// Format amount with currency
  String get formattedAmount {
    return '${amountDue.toStringAsFixed(2)} $currencyCode';
  }

  /// Get latest transaction if exists
  Map<String, dynamic>? get latestTransaction {
    if (transactions != null && transactions!.isNotEmpty) {
      return transactions!.first;
    }
    return null;
  }
}

