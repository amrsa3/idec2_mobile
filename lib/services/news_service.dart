import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/news_article_model.dart';
import '../models/news_category_model.dart';
import '../models/news_comment_model.dart';
import 'platform_storage_service.dart';
import 'enhanced_dio_service_v2.dart';

class NewsService {
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  final PlatformStorageService _storageService = PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get all news articles with optional filters
  Future<Map<String, dynamic>> getNews({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? status,
    String? priority,
    bool featuredOnly = false,
    bool breakingOnly = false,
    String? search,
    String? targetType,
    String? targetId,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
        if (featuredOnly) 'featuredOnly': 'true',
        if (breakingOnly) 'breakingOnly': 'true',
        if (search != null && search.isNotEmpty) 'search': search,
        if (targetType != null) 'targetType': targetType,
        if (targetId != null) 'targetId': targetId,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as Map<String, dynamic>;
        
        List<NewsArticleModel> articles = [];
        if (decodedData['data'] != null && decodedData['data'] is List) {
          articles = (decodedData['data'] as List)
              .map((json) => NewsArticleModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        return {
          'data': articles,
          'total': decodedData['total'] ?? 0,
          'page': decodedData['page'] ?? page,
          'limit': decodedData['limit'] ?? limit,
          'totalPages': decodedData['totalPages'] ?? 0,
        };
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  /// Get news article by ID
  Future<NewsArticleModel> getNewsById(String id) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/$id');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as Map<String, dynamic>;
        return NewsArticleModel.fromJson(decodedData);
      } else {
        throw Exception('Failed to load news article: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news article: $e');
      rethrow;
    }
  }

  /// Get featured news articles
  Future<List<NewsArticleModel>> getFeatured() async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/featured');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as List;
        return decodedData
            .map((json) => NewsArticleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load featured news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching featured news: $e');
      rethrow;
    }
  }

  /// Get breaking news articles
  Future<List<NewsArticleModel>> getBreaking() async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/breaking');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as List;
        return decodedData
            .map((json) => NewsArticleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load breaking news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching breaking news: $e');
      rethrow;
    }
  }

  /// Toggle like on news article
  Future<Map<String, dynamic>> toggleLike(String articleId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/$articleId/like');

      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  /// Toggle bookmark on news article
  Future<Map<String, dynamic>> toggleBookmark(String articleId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/$articleId/bookmark');

      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to toggle bookmark: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      rethrow;
    }
  }

  /// Get all news categories
  Future<List<NewsCategoryModel>> getCategories({bool activeOnly = false}) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        if (activeOnly) 'activeOnly': 'true',
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/categories')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as List;
        return decodedData
            .map((json) => NewsCategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Get comments for a news article
  Future<List<NewsCommentModel>> getComments(String articleId, {bool includeReplies = true}) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        if (!includeReplies) 'includeReplies': 'false',
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/$articleId/comments')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as List;
        return decodedData
            .map((json) => NewsCommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      rethrow;
    }
  }

  /// Add comment to news article
  Future<NewsCommentModel> addComment(String articleId, String content, {String? parentId}) async {
    try {
      // Use Dio service to benefit from token interceptor and automatic refresh
      final dioService = EnhancedDioServiceV2.instance;
      await dioService.ensureInitialized();
      final dio = dioService.dio;
      
      final body = {
        'content': content,
        if (parentId != null) 'parentId': parentId,
      };

      final response = await dio.post(
        '/api/v1/news/$articleId/comments',
        data: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedData = response.data as Map<String, dynamic>;
        return NewsCommentModel.fromJson(decodedData);
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  /// Delete comment
  Future<void> deleteComment(String articleId, String commentId) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/news/$articleId/comments/comment/$commentId');

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting comment: $e');
      rethrow;
    }
  }
}

