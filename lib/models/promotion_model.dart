/// Promotion model for handling discount and offer data
class Promotion {
  final String id;
  final String? code;
  final String name;
  final String titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String type;
  final String? status;
  final String discountType;
  final double discountValue;
  final double? maxDiscountAmount;
  final double? minOrderValue;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFlashSale;
  final bool isConferenceOffer;
  final bool isFeatured;
  final bool isBoothOffer;
  final String? image;
  final String? bannerImage;
  final String? badgeText;
  final String? badgeTextEn;
  final String? badgeColor;
  final int? usageLimit;
  final int usageCount;
  final int? earlyAccessLimit;
  final int? earlyAccessUsed;
  final String? happyHourStartTime;
  final String? happyHourEndTime;
  final List<String>? happyHourDays;
  final VendorInfo? vendor;

  Promotion({
    required this.id,
    this.code,
    required this.name,
    required this.titleAr,
    this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.type,
    this.status,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    this.minOrderValue,
    required this.startDate,
    required this.endDate,
    this.isFlashSale = false,
    this.isConferenceOffer = false,
    this.isFeatured = false,
    this.isBoothOffer = false,
    this.image,
    this.bannerImage,
    this.badgeText,
    this.badgeTextEn,
    this.badgeColor,
    this.usageLimit,
    this.usageCount = 0,
    this.earlyAccessLimit,
    this.earlyAccessUsed,
    this.happyHourStartTime,
    this.happyHourEndTime,
    this.happyHourDays,
    this.vendor,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      code: json['code'] as String?,
      name: json['name'] as String,
      titleAr: json['titleAr'] as String,
      titleEn: json['titleEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      type: json['type'] as String,
      status: json['status'] as String?,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      maxDiscountAmount: json['maxDiscountAmount'] != null
          ? (json['maxDiscountAmount'] as num).toDouble()
          : null,
      minOrderValue: json['minOrderValue'] != null
          ? (json['minOrderValue'] as num).toDouble()
          : null,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isFlashSale: json['isFlashSale'] as bool? ?? false,
      isConferenceOffer: json['isConferenceOffer'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isBoothOffer: json['isBoothOffer'] as bool? ?? false,
      image: json['image'] as String?,
      bannerImage: json['bannerImage'] as String?,
      badgeText: json['badgeText'] as String?,
      badgeTextEn: json['badgeTextEn'] as String?,
      badgeColor: json['badgeColor'] as String?,
      usageLimit: json['usageLimit'] as int?,
      usageCount: json['usageCount'] as int? ?? 0,
      earlyAccessLimit: json['earlyAccessLimit'] as int?,
      earlyAccessUsed: json['earlyAccessUsed'] as int?,
      happyHourStartTime: json['happyHourStartTime'] as String?,
      happyHourEndTime: json['happyHourEndTime'] as String?,
      happyHourDays: json['happyHourDays'] != null
          ? List<String>.from(json['happyHourDays'] as List)
          : null,
      vendor: json['vendor'] != null
          ? VendorInfo.fromJson(json['vendor'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
        'type': type,
        'status': status,
        'discountType': discountType,
        'discountValue': discountValue,
        'maxDiscountAmount': maxDiscountAmount,
        'minOrderValue': minOrderValue,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isFlashSale': isFlashSale,
        'isConferenceOffer': isConferenceOffer,
        'isFeatured': isFeatured,
        'isBoothOffer': isBoothOffer,
        'image': image,
        'bannerImage': bannerImage,
        'badgeText': badgeText,
        'badgeTextEn': badgeTextEn,
        'badgeColor': badgeColor,
        'usageLimit': usageLimit,
        'usageCount': usageCount,
        'earlyAccessLimit': earlyAccessLimit,
        'earlyAccessUsed': earlyAccessUsed,
        'happyHourStartTime': happyHourStartTime,
        'happyHourEndTime': happyHourEndTime,
        'happyHourDays': happyHourDays,
        'vendor': vendor?.toJson(),
      };

  /// Check if the promotion is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Check if the promotion is expiring soon (within 24 hours)
  bool get isExpiringSoon {
    final now = DateTime.now();
    final hoursLeft = endDate.difference(now).inHours;
    return hoursLeft > 0 && hoursLeft <= 24;
  }

  /// Get remaining time until expiration
  Duration get remainingTime => endDate.difference(DateTime.now());

  /// Get the discount display text
  String get discountDisplayText {
    if (discountType == 'PERCENTAGE') {
      return '${discountValue.toInt()}%';
    }
    return '${discountValue.toStringAsFixed(0)} YER';
  }

  /// Get localized title based on language
  String getLocalizedTitle(bool isRTL) {
    if (isRTL) return titleAr;
    return titleEn ?? titleAr;
  }

  /// Get localized description based on language
  String? getLocalizedDescription(bool isRTL) {
    if (isRTL) return descriptionAr;
    return descriptionEn ?? descriptionAr;
  }

  /// Get localized badge text based on language
  String? getLocalizedBadgeText(bool isRTL) {
    if (isRTL) return badgeText;
    return badgeTextEn ?? badgeText;
  }
}

class VendorInfo {
  final String id;
  final String? storeNameAr;
  final String? storeNameEn;

  VendorInfo({
    required this.id,
    this.storeNameAr,
    this.storeNameEn,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['id'] as String,
      storeNameAr: json['storeNameAr'] as String?,
      storeNameEn: json['storeNameEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'storeNameAr': storeNameAr,
        'storeNameEn': storeNameEn,
      };

  String getLocalizedName(bool isRTL) {
    if (isRTL) return storeNameAr ?? '';
    return storeNameEn ?? storeNameAr ?? '';
  }
}

/// Coupon application result
class CouponResult {
  final bool valid;
  final String? message;
  final Promotion? promotion;
  final double? discountAmount;

  CouponResult({
    required this.valid,
    this.message,
    this.promotion,
    this.discountAmount,
  });

  factory CouponResult.fromJson(Map<String, dynamic> json) {
    return CouponResult(
      valid: json['valid'] as bool? ?? false,
      message: json['message'] as String?,
      promotion: json['promotion'] != null
          ? Promotion.fromJson(json['promotion'] as Map<String, dynamic>)
          : null,
      discountAmount: json['discountAmount'] != null
          ? (json['discountAmount'] as num).toDouble()
          : null,
    );
  }
}

/// Discount calculation result
class DiscountCalculation {
  final double originalTotal;
  final double discountAmount;
  final double finalTotal;
  final List<AppliedPromotion> appliedPromotions;

  DiscountCalculation({
    required this.originalTotal,
    required this.discountAmount,
    required this.finalTotal,
    required this.appliedPromotions,
  });

  factory DiscountCalculation.fromJson(Map<String, dynamic> json) {
    return DiscountCalculation(
      originalTotal: (json['originalTotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalTotal: (json['finalTotal'] as num).toDouble(),
      appliedPromotions: json['appliedPromotions'] != null
          ? (json['appliedPromotions'] as List)
              .map((e) => AppliedPromotion.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class AppliedPromotion {
  final String promotionId;
  final String name;
  final double discountAmount;
  final String? type;

  AppliedPromotion({
    required this.promotionId,
    required this.name,
    required this.discountAmount,
    this.type,
  });

  factory AppliedPromotion.fromJson(Map<String, dynamic> json) {
    return AppliedPromotion(
      promotionId: json['promotionId'] as String,
      name: json['name'] as String,
      discountAmount: (json['discountAmount'] as num).toDouble(),
      type: json['type'] as String?,
    );
  }
}
