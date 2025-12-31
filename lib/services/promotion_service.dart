import 'package:dio/dio.dart';
import '../models/promotion_model.dart';
import 'enhanced_dio_service_v2.dart';

/// Service for handling promotion-related API calls
class PromotionService {
  final EnhancedDioServiceV2 _dioService;

  PromotionService._internal() : _dioService = EnhancedDioServiceV2.instance;

  static final PromotionService instance = PromotionService._internal();

  /// Get active promotions
  Future<List<Promotion>> getActivePromotions({
    String? vendorId,
    bool? conferenceOnly,
    bool? flashSaleOnly,
    bool? featuredOnly,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (vendorId != null) queryParams['vendorId'] = vendorId;
      if (conferenceOnly != null) queryParams['conferenceOnly'] = conferenceOnly;
      if (flashSaleOnly != null) queryParams['flashSaleOnly'] = flashSaleOnly;
      if (featuredOnly != null) queryParams['featuredOnly'] = featuredOnly;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dioService.get(
        '/market/promotions/active',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((e) => Promotion.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is Map && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => Promotion.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching active promotions: $e');
      return [];
    }
  }

  /// Get promotions for a specific product
  Future<List<Promotion>> getProductPromotions(String productId) async {
    try {
      final response = await _dioService.get('/market/promotions/product/$productId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((e) => Promotion.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is Map && data['promotions'] is List) {
          return (data['promotions'] as List)
              .map((e) => Promotion.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching product promotions: $e');
      return [];
    }
  }

  /// Get featured/flash sale promotions for display
  Future<List<Promotion>> getFeaturedPromotions({int limit = 5}) async {
    return getActivePromotions(featuredOnly: true, limit: limit);
  }

  /// Get conference-only promotions
  Future<List<Promotion>> getConferencePromotions({int limit = 10}) async {
    return getActivePromotions(conferenceOnly: true, limit: limit);
  }

  /// Get flash sale promotions
  Future<List<Promotion>> getFlashSalePromotions({int limit = 10}) async {
    return getActivePromotions(flashSaleOnly: true, limit: limit);
  }

  /// Apply a coupon code
  Future<CouponResult> applyCoupon({
    required String code,
    double? orderTotal,
    List<String>? productIds,
  }) async {
    try {
      final response = await _dioService.post(
        '/market/promotions/apply-coupon',
        data: {
          'code': code,
          if (orderTotal != null) 'orderTotal': orderTotal,
          if (productIds != null) 'productIds': productIds,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CouponResult.fromJson(response.data as Map<String, dynamic>);
      }
      return CouponResult(valid: false, message: 'كوبون غير صالح');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'حدث خطأ';
      return CouponResult(valid: false, message: message.toString());
    } catch (e) {
      print('Error applying coupon: $e');
      return CouponResult(valid: false, message: 'حدث خطأ غير متوقع');
    }
  }

  /// Calculate discount for cart items
  Future<DiscountCalculation?> calculateDiscount({
    required List<Map<String, dynamic>> items,
    String? vendorId,
    String? couponCode,
  }) async {
    try {
      final response = await _dioService.post(
        '/market/promotions/calculate-discount',
        data: {
          'items': items,
          if (vendorId != null) 'vendorId': vendorId,
          if (couponCode != null) 'couponCode': couponCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DiscountCalculation.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error calculating discount: $e');
      return null;
    }
  }

  /// Scan booth QR code
  Future<CouponResult> scanBoothQr(String qrCode) async {
    try {
      final response = await _dioService.post(
        '/market/promotions/booth/scan',
        data: {'qrCode': qrCode},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CouponResult.fromJson(response.data as Map<String, dynamic>);
      }
      return CouponResult(valid: false, message: 'رمز QR غير صالح');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'حدث خطأ';
      return CouponResult(valid: false, message: message.toString());
    } catch (e) {
      print('Error scanning booth QR: $e');
      return CouponResult(valid: false, message: 'حدث خطأ غير متوقع');
    }
  }

  /// Record promotion view for analytics
  Future<void> recordView(String promotionId) async {
    try {
      await _dioService.post('/market/promotions/$promotionId/view');
    } catch (e) {
      // Silently fail - analytics shouldn't block UX
      print('Error recording promotion view: $e');
    }
  }

  /// Record promotion click for analytics
  Future<void> recordClick(String promotionId) async {
    try {
      await _dioService.post('/market/promotions/$promotionId/click');
    } catch (e) {
      // Silently fail
      print('Error recording promotion click: $e');
    }
  }
}
