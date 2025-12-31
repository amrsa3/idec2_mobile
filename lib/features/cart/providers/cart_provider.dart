import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/platform_storage_service.dart';

/// نموذج عنصر السلة
class CartItem {
  final String productId;
  final String name;
  final String? nameEn;
  final String? imageUrl;
  final double price;
  final double? salePrice;
  final String currency;
  final int quantity;
  final String? vendorName;
  final DateTime addedAt;

  const CartItem({
    required this.productId,
    required this.name,
    this.nameEn,
    this.imageUrl,
    required this.price,
    this.salePrice,
    this.currency = 'SAR',
    this.quantity = 1,
    this.vendorName,
    required this.addedAt,
  });

  double get effectivePrice => salePrice ?? price;
  double get totalPrice => effectivePrice * quantity;
  bool get hasDiscount => salePrice != null && salePrice! < price;
  double get discountPercent => hasDiscount ? ((price - salePrice!) / price * 100) : 0;

  CartItem copyWith({
    String? productId,
    String? name,
    String? nameEn,
    String? imageUrl,
    double? price,
    double? salePrice,
    String? currency,
    int? quantity,
    String? vendorName,
    DateTime? addedAt,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      vendorName: vendorName ?? this.vendorName,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'nameEn': nameEn,
        'imageUrl': imageUrl,
        'price': price,
        'salePrice': salePrice,
        'currency': currency,
        'quantity': quantity,
        'vendorName': vendorName,
        'addedAt': addedAt.toIso8601String(),
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] ?? '',
        name: json['name'] ?? '',
        nameEn: json['nameEn'],
        imageUrl: json['imageUrl'],
        price: (json['price'] ?? 0).toDouble(),
        salePrice: json['salePrice']?.toDouble(),
        currency: json['currency'] ?? 'SAR',
        quantity: json['quantity'] ?? 1,
        vendorName: json['vendorName'],
        addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      );
}

/// حالة السلة
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;
  final bool isCheckingOut;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.isCheckingOut = false,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    bool? isCheckingOut,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get productCount => items.length;
  
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discount => items.fold(0, (sum, item) => 
      item.hasDiscount ? (item.price - item.salePrice!) * item.quantity : 0);
  double get total => subtotal;
  
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  bool containsProduct(String productId) {
    return items.any((item) => item.productId == productId);
  }

  CartItem? getItem(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (_) {
      return null;
    }
  }
}

/// Notifier للسلة
class CartNotifier extends StateNotifier<CartState> {
  static const String _storageKey = 'shopping_cart';

  CartNotifier() : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final storage = PlatformStorageService.instance;
      final data = await storage.getString(_storageKey);
      
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
        final items = jsonList
            .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
            .toList();
        
        state = state.copyWith(items: items, isLoading: false);
        debugPrint('✅ [CART] Loaded ${items.length} items from cart');
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('❌ [CART] Error loading cart: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _saveCart() async {
    try {
      final storage = PlatformStorageService.instance;
      final jsonList = state.items.map((item) => item.toJson()).toList();
      await storage.setString(_storageKey, jsonEncode(jsonList));
      debugPrint('✅ [CART] Saved ${state.items.length} items to cart');
    } catch (e) {
      debugPrint('❌ [CART] Error saving cart: $e');
    }
  }

  /// إضافة منتج للسلة
  Future<void> addToCart({
    required String productId,
    required String name,
    String? nameEn,
    String? imageUrl,
    required double price,
    double? salePrice,
    String currency = 'SAR',
    int quantity = 1,
    String? vendorName,
  }) async {
    final existingIndex = state.items.indexWhere((item) => item.productId == productId);
    
    if (existingIndex >= 0) {
      // زيادة الكمية إذا كان المنتج موجود
      final existing = state.items[existingIndex];
      final updatedItem = existing.copyWith(quantity: existing.quantity + quantity);
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItem;
      state = state.copyWith(items: updatedItems);
    } else {
      // إضافة منتج جديد
      final newItem = CartItem(
        productId: productId,
        name: name,
        nameEn: nameEn,
        imageUrl: imageUrl,
        price: price,
        salePrice: salePrice,
        currency: currency,
        quantity: quantity,
        vendorName: vendorName,
        addedAt: DateTime.now(),
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
    
    await _saveCart();
    debugPrint('✅ [CART] Added to cart: $name');
  }

  /// إزالة منتج من السلة
  Future<void> removeFromCart(String productId) async {
    final updatedItems = state.items
        .where((item) => item.productId != productId)
        .toList();
    
    state = state.copyWith(items: updatedItems);
    await _saveCart();
    debugPrint('✅ [CART] Removed from cart: $productId');
  }

  /// تحديث كمية منتج
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    
    state = state.copyWith(items: updatedItems);
    await _saveCart();
    debugPrint('✅ [CART] Updated quantity for $productId: $newQuantity');
  }

  /// زيادة كمية منتج
  Future<void> incrementQuantity(String productId) async {
    final item = state.getItem(productId);
    if (item != null) {
      await updateQuantity(productId, item.quantity + 1);
    }
  }

  /// تقليل كمية منتج
  Future<void> decrementQuantity(String productId) async {
    final item = state.getItem(productId);
    if (item != null) {
      await updateQuantity(productId, item.quantity - 1);
    }
  }

  /// مسح السلة
  Future<void> clearCart() async {
    state = state.copyWith(items: []);
    await _saveCart();
    debugPrint('✅ [CART] Cart cleared');
  }

  /// بدء عملية الدفع
  Future<bool> checkout() async {
    if (state.isEmpty) return false;
    
    state = state.copyWith(isCheckingOut: true);
    
    try {
      // TODO: إرسال الطلب للخادم
      await Future.delayed(const Duration(seconds: 2));
      
      // مسح السلة بعد النجاح
      state = state.copyWith(items: [], isCheckingOut: false);
      await _saveCart();
      
      debugPrint('✅ [CART] Checkout completed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [CART] Checkout error: $e');
      state = state.copyWith(isCheckingOut: false, error: e.toString());
      return false;
    }
  }
}

/// Provider للسلة
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Provider لعدد العناصر في السلة
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

/// Provider للمجموع
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

/// Provider للتحقق من وجود منتج في السلة
final isInCartProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(cartProvider).containsProduct(productId);
});
