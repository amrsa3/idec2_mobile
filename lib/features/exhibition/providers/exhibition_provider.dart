import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../services/enhanced_dio_service_v2.dart';

// Exhibitor Model
class Exhibitor {
  final String id;
  final String name;
  final String? nameEn;
  final String? description;
  final String? imageUrl;
  final String? logoUrl;
  final String? boothNumber;
  final String? category;
  final String? phone;
  final String? email;
  final String? website;
  final List<String> products;
  final bool isSponsored;

  const Exhibitor({
    required this.id,
    required this.name,
    this.nameEn,
    this.description,
    this.imageUrl,
    this.logoUrl,
    this.boothNumber,
    this.category,
    this.phone,
    this.email,
    this.website,
    this.products = const [],
    this.isSponsored = false,
  });

  factory Exhibitor.fromJson(Map<String, dynamic> json) {
    return Exhibitor(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['nameAr'] ?? '',
      nameEn: json['nameEn'],
      description: json['description'] ?? json['descriptionAr'],
      imageUrl: json['image'] ?? json['imageUrl'] ?? json['coverImage'],
      logoUrl: json['logo'] ?? json['logoUrl'],
      boothNumber: json['boothNumber'] ?? json['booth'],
      category: json['category']?['name'] ?? json['categoryName'] ?? json['type'],
      phone: json['phone'] ?? json['contactPhone'],
      email: json['email'] ?? json['contactEmail'],
      website: json['website'] ?? json['websiteUrl'],
      products: (json['products'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isSponsored: json['isSponsored'] ?? json['sponsored'] ?? false,
    );
  }
}

// Exhibition Category
class ExhibitionCategory {
  final String id;
  final String name;
  final String? nameEn;
  final int count;

  const ExhibitionCategory({
    required this.id,
    required this.name,
    this.nameEn,
    this.count = 0,
  });
}

// State
class ExhibitionState {
  final List<Exhibitor> exhibitors;
  final List<ExhibitionCategory> categories;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final String searchQuery;
  final int page;
  final bool hasMore;

  const ExhibitionState({
    this.exhibitors = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.searchQuery = '',
    this.page = 1,
    this.hasMore = true,
  });

  ExhibitionState copyWith({
    List<Exhibitor>? exhibitors,
    List<ExhibitionCategory>? categories,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    int? page,
    bool? hasMore,
  }) {
    return ExhibitionState(
      exhibitors: exhibitors ?? this.exhibitors,
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
class ExhibitionNotifier extends StateNotifier<ExhibitionState> {
  ExhibitionNotifier() : super(const ExhibitionState()) {
    _initCategories();
    loadExhibitors();
  }

  void _initCategories() {
    state = state.copyWith(
      categories: const [
        ExhibitionCategory(id: 'all', name: 'الكل', nameEn: 'All'),
        ExhibitionCategory(id: 'equipment', name: 'معدات طبية', nameEn: 'Equipment'),
        ExhibitionCategory(id: 'materials', name: 'مواد استهلاكية', nameEn: 'Materials'),
        ExhibitionCategory(id: 'tech', name: 'تقنيات', nameEn: 'Technology'),
        ExhibitionCategory(id: 'services', name: 'خدمات', nameEn: 'Services'),
        ExhibitionCategory(id: 'education', name: 'تعليم', nameEn: 'Education'),
      ],
    );
  }

  Future<void> loadExhibitors({bool refresh = false}) async {
    if (state.isLoading) return;
    
    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, exhibitors: [], error: null);
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
      
      final response = await dio.get('/api/v1/exhibition/exhibitors', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final data = response.data;
        List exhibitorsData = [];
        int total = 0;
        
        if (data is Map) {
          exhibitorsData = data['data'] ?? data['exhibitors'] ?? [];
          total = data['pagination']?['total'] ?? data['total'] ?? exhibitorsData.length;
        } else if (data is List) {
          exhibitorsData = data;
          total = data.length;
        }
        
        final newExhibitors = exhibitorsData
            .map((json) => Exhibitor.fromJson(json))
            .toList();
            
        state = state.copyWith(
          exhibitors: refresh ? newExhibitors : [...state.exhibitors, ...newExhibitors],
          isLoading: false,
          page: state.page + 1,
          hasMore: (state.exhibitors.length + newExhibitors.length) < total,
        );
      }
    } catch (e) {
      debugPrint('❌ [EXHIBITION] Error loading exhibitors: $e');
      // Use mock data
      state = state.copyWith(
        isLoading: false,
        exhibitors: _getMockExhibitors(),
        hasMore: false,
      );
    }
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(selectedCategory: categoryId);
    loadExhibitors(refresh: true);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadExhibitors(refresh: true);
  }

  Future<dynamic> _getDio() async {
    final dioService = EnhancedDioServiceV2.instance;
    await dioService.initialize();
    return dioService.dio;
  }

  List<Exhibitor> _getMockExhibitors() {
    final categories = ['معدات طبية', 'مواد استهلاكية', 'تقنيات', 'خدمات', 'تعليم'];
    return List.generate(10, (index) => Exhibitor(
      id: 'exhibitor_$index',
      name: 'شركة ${_getCompanyName(index)}',
      nameEn: 'Company ${index + 1}',
      description: 'شركة رائدة في مجال ${categories[index % categories.length]} وتقديم الحلول المتكاملة لأطباء الأسنان.',
      boothNumber: '${String.fromCharCode(65 + (index ~/ 5))}-${100 + index}',
      category: categories[index % categories.length],
      isSponsored: index < 3,
      products: ['منتج 1', 'منتج 2', 'منتج 3'],
      phone: '+966 50 123 456${index}',
      email: 'info@company${index + 1}.com',
      website: 'https://company${index + 1}.com',
    ));
  }

  String _getCompanyName(int index) {
    final names = [
      'التقنيات الطبية المتقدمة',
      'الأسنان الحديثة',
      'المعدات الطبية الدولية',
      'حلول طب الأسنان',
      'التميز للمواد الطبية',
      'الإبداع التقني',
      'المستلزمات الطبية',
      'الخدمات المتكاملة',
      'التعليم الطبي',
      'الابتكار الطبي',
    ];
    return names[index % names.length];
  }
}

// Provider
final exhibitionProvider = StateNotifierProvider<ExhibitionNotifier, ExhibitionState>((ref) {
  return ExhibitionNotifier();
});
