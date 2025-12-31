import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_gateway_model.freezed.dart';
part 'payment_gateway_model.g.dart';

@freezed
class PaymentGatewayModel with _$PaymentGatewayModel {
  const factory PaymentGatewayModel({
    required String id,
    required String name,
    @JsonKey(name: 'adapterName') required String adapterName,
    @JsonKey(name: 'isActive') required bool isActive,
    @JsonKey(name: 'mode') required String mode, // TEST or PRODUCTION
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _PaymentGatewayModel;

  factory PaymentGatewayModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentGatewayModelFromJson(json);
}

extension PaymentGatewayModelExtensions on PaymentGatewayModel {
  /// Get gateway display name based on adapter
  String get displayName {
    switch (adapterName) {
      case 'JwaliAdapter':
        return 'محفظة جوالي';
      case 'JaibAdapter':
        return 'محفظة جيب';
      case 'KurimiAdapter':
        return 'محفظة كريمي';
      default:
        return name;
    }
  }

  /// Get gateway icon identifier
  String get iconName {
    switch (adapterName) {
      case 'JwaliAdapter':
        return 'jwali';
      case 'JaibAdapter':
        return 'jaib';
      case 'KurimiAdapter':
        return 'kurimi';
      default:
        return 'wallet';
    }
  }

  /// Get gateway logo path
  String get logoPath {
    switch (adapterName) {
      case 'JwaliAdapter':
        return 'assets/images/jawali.jpg';
      case 'JaibAdapter':
        return 'assets/images/jeeb.jpg';
      case 'KurimiAdapter':
        return 'assets/images/kurimi.jpg';
      default:
        return 'assets/images/placeholder.png';
    }
  }

  /// Get gateway accent color
  Color get accentColor {
    switch (adapterName) {
      case 'JwaliAdapter':
        return const Color(0xFFFF6B00); // Orange
      case 'JaibAdapter':
        return const Color(0xFFE53935); // Red
      case 'KurimiAdapter':
        return const Color(0xFF6C3483); // Purple
      default:
        return Colors.blue;
    }
  }

  bool get isTestMode => mode == 'TEST';
  bool get isProductionMode => mode == 'PRODUCTION';
}

