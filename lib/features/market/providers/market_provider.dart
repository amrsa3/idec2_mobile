import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../services/enhanced_dio_service_v2.dart';

// Product Model
class MarketProduct {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final String? imageUrl;
  final double price;
  final double? salePrice;
  final String? currency;
  final String? category;
  final String? vendorName;
  final double? rating;
  final int? reviewCount;
  final bool inStock;

  const MarketProduct({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.imageUrl,
    required this.price,
    this.salePrice,
    this.currency = 'SAR',
    this.category,
    this.vendorName,
    this.rating,
    this.reviewCount,
    this.inStock = true,
  });

  factory MarketProduct.fromJson(Map<String, dynamic> json) {
    return MarketProduct(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['nameAr'] ?? '',
      nameEn: json['nameEn'],
      description: json['description'] ?? json['descriptionAr'],
      imageUrl: json['mainImage'] ?? json['imageUrl'] ?? json['image'],
      price: (json['price'] ?? json['basePrice'] ?? 0).toDouble(),
      salePrice: json['salePrice']?.toDouble(),
      currency: json['currency'] ?? 'SAR',
      category: json['category']?['name'] ?? json['categoryName'],
      vendorName: json['store']?['name'] ?? json['vendorName'],
      rating: json['averageRating']?.toDouble(),
      reviewCount: json['reviewCount'],
      inStock: json['inStock'] ?? json['quantity'] != null && json['quantity'] > 0,
    );
  }
}

// Category Model
class MarketCategory {
  final String id;
  final String name;
  final String? nameEn;
  final String? icon;
  final int productCount;

  const MarketCategory({
    required this.id,
    required this.name,
    this.nameEn,
    this.icon,
    this.productCount = 0,
  });

  factory MarketCategory.fromJson(Map<String, dynamic> json) {
    return MarketCategory(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['nameAr'] ?? '',
      nameEn: json['nameEn'],
      icon: json['icon'],
      productCount: json['productCount'] ?? 0,
    );
  }
}

// State
class MarketState {
  final List<MarketProduct> products;
  final List<MarketCategory> categories;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final String searchQuery;
  final int page;
  final bool hasMore;

  const MarketState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.searchQuery = '',
    this.page = 1,
    this.hasMore = true,
  });

  MarketState copyWith({
    List<MarketProduct>? products,
    List<MarketCategory>? categories,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    int? page,
    bool? hasMore,
  }) {
    return MarketState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Notifier
class MarketNotifier extends StateNotifier<MarketState> {
  MarketNotifier() : super(const MarketState()) {
    loadCategories();
    loadProducts();
  }

  Future<void> loadCategories() async {
    try {
      final dio = await _getDio();
      final response = await dio.get('/api/v1/market/categories');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List categoriesData = [];
        
        if (data is Map && data['data'] != null) {
          categoriesData = data['data'] as List;
        } else if (data is List) {
          categoriesData = data;
        }
        
        final categories = categoriesData
            .map((json) => MarketCategory.fromJson(json))
            .toList();
            
        state = state.copyWith(categories: categories);
      }
    } catch (e) {
      debugPrint('❌ [MARKET] Error loading categories: $e');
      // Use default categories
      state = state.copyWith(
        categories: [
          const MarketCategory(id: 'all', name: 'الكل', nameEn: 'All'),
          const MarketCategory(id: 'tools', name: 'أدوات طبية', nameEn: 'Medical Tools'),
          const MarketCategory(id: 'consumables', name: 'مواد استهلاكية', nameEn: 'Consumables'),
          const MarketCategory(id: 'equipment', name: 'أجهزة', nameEn: 'Equipment'),
          const MarketCategory(id: 'books', name: 'كتب', nameEn: 'Books'),
        ],
      );
    }
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (state.isLoading) return;
    
    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, products: [], error: null);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true);
    }

    try {
      final dio = await _getDio();
      final queryParams = <String, dynamic>{
        'page': state.page,
        'limit': 20,
      };
      
      if (state.selectedCategory != null && state.selectedCategory != 'all') {
        queryParams['category'] = state.selectedCategory;
      }
      
      if (state.searchQuery.isNotEmpty) {
        queryParams['search'] = state.searchQuery;
      }
      
      final response = await dio.get('/api/v1/market/products', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        List productsData = [];
        int total = 0;
        
        if (data is Map) {
          productsData = data['data'] ?? data['products'] ?? [];
          total = data['pagination']?['total'] ?? data['total'] ?? productsData.length;
        } else if (data is List) {
          productsData = data;
          total = data.length;
        }
        
        final newProducts = productsData
            .map((json) => MarketProduct.fromJson(json))
            .toList();
            
        state = state.copyWith(
          products: refresh ? newProducts : [...state.products, ...newProducts],
          isLoading: false,
          page: state.page + 1,
          hasMore: (state.products.length + newProducts.length) < total,
        );
      }
    } catch (e) {
      debugPrint('❌ [MARKET] Error loading products: $e');
      // Use mock data for demo
      state = state.copyWith(
        isLoading: false,
        products: _getMockProducts(),
        hasMore: false,
      );
    }
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(selectedCategory: categoryId);
    loadProducts(refresh: true);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadProducts(refresh: true);
  }

  Future<dynamic> _getDio() async {
    final dioService = EnhancedDioServiceV2.instance;
    await dioService.initialize();
    return dioService.dio;
  }

  List<MarketProduct> _getMockProducts() {
    return List.generate(8, (index) => MarketProduct(
      id: 'mock_$index',
      name: 'منتج تجريبي ${index + 1}',
      nameEn: 'Sample Product ${index + 1}',
      description: 'وصف المنتج التجريبي رقم ${index + 1}',
      price: (index + 1) * 50.0,
      salePrice: index % 3 == 0 ? (index + 1) * 40.0 : null,
      category: ['أدوات', 'مواد استهلاكية', 'أجهزة', 'كتب'][index % 4],
      vendorName: 'متجر ${index + 1}',
      rating: 3.5 + (index % 3) * 0.5,
      reviewCount: (index + 1) * 10,
      inStock: index % 5 != 0,
    ));
  }
}

// Provider
final marketProvider = StateNotifierProvider<MarketNotifier, MarketState>((ref) {
  return MarketNotifier();
});
