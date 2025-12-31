// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceModelImpl _$$InvoiceModelImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceModelImpl(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      userId: json['userId'] as String,
      registrationId: json['registrationId'] as String?,
      eventId: json['eventId'] as String?,
      conferenceId: json['conferenceId'] as String?,
      status: json['status'] as String,
      description: json['description'] as String,
      amountDue: const DecimalConverter().fromJson(json['amountDue']),
      currencyCode: json['currencyCode'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      revenueType: json['revenueType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] as Map<String, dynamic>?,
      event: json['event'] as Map<String, dynamic>?,
      conference: json['conference'] as Map<String, dynamic>?,
      registration: json['registration'] as Map<String, dynamic>?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$InvoiceModelImplToJson(_$InvoiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'userId': instance.userId,
      'registrationId': instance.registrationId,
      'eventId': instance.eventId,
      'conferenceId': instance.conferenceId,
      'status': instance.status,
      'description': instance.description,
      'amountDue': const DecimalConverter().toJson(instance.amountDue),
      'currencyCode': instance.currencyCode,
      'issueDate': instance.issueDate.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'revenueType': instance.revenueType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'event': instance.event,
      'conference': instance.conference,
      'registration': instance.registration,
      'transactions': instance.transactions,
    };
