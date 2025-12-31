import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/promotion_model.dart';
import '../../../services/promotion_service.dart';

/// Provider for PromotionService (singleton)
final promotionServiceProvider = Provider<PromotionService>((ref) {
  return PromotionService.instance;
});

/// State for promotions
class PromotionsState {
  final List<Promotion> activePromotions;
  final List<Promotion> featuredPromotions;
  final List<Promotion> flashSalePromotions;
  final List<Promotion> conferencePromotions;
  final bool isLoading;
  final String? error;
  final String? appliedCouponCode;
  final CouponResult? couponResult;

  PromotionsState({
    this.activePromotions = const [],
    this.featuredPromotions = const [],
    this.flashSalePromotions = const [],
    this.conferencePromotions = const [],
    this.isLoading = false,
    this.error,
    this.appliedCouponCode,
    this.couponResult,
  });

  PromotionsState copyWith({
    List<Promotion>? activePromotions,
    List<Promotion>? featuredPromotions,
    List<Promotion>? flashSalePromotions,
    List<Promotion>? conferencePromotions,
    bool? isLoading,
    String? error,
    String? appliedCouponCode,
    CouponResult? couponResult,
  }) {
    return PromotionsState(
      activePromotions: activePromotions ?? this.activePromotions,
      featuredPromotions: featuredPromotions ?? this.featuredPromotions,
      flashSalePromotions: flashSalePromotions ?? this.flashSalePromotions,
      conferencePromotions: conferencePromotions ?? this.conferencePromotions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      couponResult: couponResult ?? this.couponResult,
    );
  }
}

/// Notifier for managing promotions state
class PromotionsNotifier extends StateNotifier<PromotionsState> {
  final PromotionService _service;

  PromotionsNotifier(this._service) : super(PromotionsState());

  /// Load all active promotions
  Future<void> loadActivePromotions({String? vendorId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final promotions = await _service.getActivePromotions(vendorId: vendorId);
      state = state.copyWith(
        activePromotions: promotions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load featured promotions for home screen banners
  Future<void> loadFeaturedPromotions() async {
    try {
      final promotions = await _service.getFeaturedPromotions(limit: 5);
      state = state.copyWith(featuredPromotions: promotions);
    } catch (e) {
      print('Error loading featured promotions: $e');
    }
  }

  /// Load flash sale promotions
  Future<void> loadFlashSalePromotions() async {
    try {
      final promotions = await _service.getFlashSalePromotions(limit: 10);
      state = state.copyWith(flashSalePromotions: promotions);
    } catch (e) {
      print('Error loading flash sale promotions: $e');
    }
  }

  /// Load conference-specific promotions
  Future<void> loadConferencePromotions() async {
    try {
      final promotions = await _service.getConferencePromotions(limit: 10);
      state = state.copyWith(conferencePromotions: promotions);
    } catch (e) {
      print('Error loading conference promotions: $e');
    }
  }

  /// Load all promotion types
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    await Future.wait([
      loadActivePromotions(),
      loadFeaturedPromotions(),
      loadFlashSalePromotions(),
      loadConferencePromotions(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  /// Apply a coupon code
  Future<CouponResult> applyCoupon(String code, {double? orderTotal, List<String>? productIds}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.applyCoupon(
        code: code,
        orderTotal: orderTotal,
        productIds: productIds,
      );
      state = state.copyWith(
        isLoading: false,
        appliedCouponCode: result.valid ? code : null,
        couponResult: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return CouponResult(valid: false, message: e.toString());
    }
  }

  /// Remove applied coupon
  void removeCoupon() {
    state = state.copyWith(
      appliedCouponCode: null,
      couponResult: null,
    );
  }

  /// Scan booth QR code
  Future<CouponResult> scanBoothQr(String qrCode) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.scanBoothQr(qrCode);
      state = state.copyWith(
        isLoading: false,
        couponResult: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return CouponResult(valid: false, message: e.toString());
    }
  }

  /// Record view for analytics
  void recordView(String promotionId) {
    _service.recordView(promotionId);
  }

  /// Record click for analytics
  void recordClick(String promotionId) {
    _service.recordClick(promotionId);
  }
}

/// Provider for promotions state
final promotionsProvider = StateNotifierProvider<PromotionsNotifier, PromotionsState>((ref) {
  final service = ref.watch(promotionServiceProvider);
  return PromotionsNotifier(service);
});

/// Provider for product-specific promotions
final productPromotionsProvider = FutureProvider.family<List<Promotion>, String>((ref, productId) async {
  final service = ref.watch(promotionServiceProvider);
  return service.getProductPromotions(productId);
});

/// Provider for vendor-specific promotions
final vendorPromotionsProvider = FutureProvider.family<List<Promotion>, String>((ref, vendorId) async {
  final service = ref.watch(promotionServiceProvider);
  return service.getActivePromotions(vendorId: vendorId);
});
