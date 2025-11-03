// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      invoiceId: json['invoiceId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      amount: const DecimalConverter().fromJson(json['amount']),
      currencyCode: json['currencyCode'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      gatewayId: json['gatewayId'] as String?,
      gatewayRequestId: json['gatewayRequestId'] as String?,
      gatewayTransactionId: json['gatewayTransactionId'] as String?,
      timestampInitiated: DateTime.parse(json['timestampInitiated'] as String),
      timestampCompleted: json['timestampCompleted'] == null
          ? null
          : DateTime.parse(json['timestampCompleted'] as String),
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      gateway: json['gateway'] as Map<String, dynamic>?,
      invoice: json['invoice'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'invoiceId': instance.invoiceId,
      'paymentMethod': instance.paymentMethod,
      'amount': const DecimalConverter().toJson(instance.amount),
      'currencyCode': instance.currencyCode,
      'type': instance.type,
      'status': instance.status,
      'gatewayId': instance.gatewayId,
      'gatewayRequestId': instance.gatewayRequestId,
      'gatewayTransactionId': instance.gatewayTransactionId,
      'timestampInitiated': instance.timestampInitiated.toIso8601String(),
      'timestampCompleted': instance.timestampCompleted?.toIso8601String(),
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'gateway': instance.gateway,
      'invoice': instance.invoice,
    };
