import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import 'enhanced_dio_service_v2.dart';
import 'offline_storage_service.dart';
import 'image_cache_service.dart';

class GalleryService {
  static GalleryService? _instance;
  static GalleryService get instance => _instance ??= GalleryService._internal();

  GalleryService._internal();

  late Dio _dio;
  final OfflineStorageService _offlineStorage = OfflineStorageService.instance;
  final ImageCacheService _imageCache = ImageCacheService();

  Future<void> initialize() async {
    _dio = EnhancedDioServiceV2.instance.dio;
  }

  // Get Albums
  Future<List<Map<String, dynamic>>> getAlbums({
    String? category,
    String? conferenceId,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'gallery_albums_${category ?? 'all'}_${conferenceId ?? 'all'}';
    
    try {
      // Try to get from offline storage first
      if (!forceRefresh) {
        final cached = await _offlineStorage.get(cacheKey);
        if (cached != null) {
          debugPrint('📦 [GALLERY] Returning albums from offline cache');
          return List<Map<String, dynamic>>.from(json.decode(cached));
        }
      }

      // Fetch from API
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/gallery/albums',
        queryParameters: {
          if (category != null) 'category': category,
          if (conferenceId != null) 'conferenceId': conferenceId,
        },
      );

      final albums = List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      
      // Cache for offline use
      await _offlineStorage.set(cacheKey, json.encode(albums));
      
      // Pre-cache cover images (using CachedNetworkImage will handle caching automatically)
      // No need to manually preload
      
      return albums;
    } catch (e) {
      debugPrint('❌ [GALLERY] Error fetching albums: $e');
      
      // Try to return from cache on error
      final cached = await _offlineStorage.get(cacheKey);
      if (cached != null) {
        debugPrint('📦 [GALLERY] Returning albums from cache after error');
        return List<Map<String, dynamic>>.from(json.decode(cached));
      }
      
      rethrow;
    }
  }

  // Get Albums from Cache only
  Future<List<Map<String, dynamic>>> getAlbumsFromCache({
    String? category,
    String? conferenceId,
  }) async {
    final cacheKey = 'gallery_albums_${category ?? 'all'}_${conferenceId ?? 'all'}';
    final cached = await _offlineStorage.get(cacheKey);
    if (cached != null) {
      return List<Map<String, dynamic>>.from(json.decode(cached));
    }
    return [];
  }

  // Get Photos for Album
  Future<List<Map<String, dynamic>>> getPhotos({
    required String albumId,
    int page = 1,
    int limit = 20,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'gallery_photos_$albumId';
    
    try {
      // Try to get from offline storage first
      if (!forceRefresh) {
        final cached = await _offlineStorage.get(cacheKey);
        if (cached != null) {
          debugPrint('📦 [GALLERY] Returning photos from offline cache');
          return List<Map<String, dynamic>>.from(json.decode(cached));
        }
      }

      // Fetch from API
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/gallery/photos',
        queryParameters: {
          'albumId': albumId,
          'page': page,
          'limit': limit,
        },
      );

      final photos = List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      
      // Cache for offline use
      await _offlineStorage.set(cacheKey, json.encode(photos));
      
      // Pre-cache images (using CachedNetworkImage will handle caching automatically)
      // No need to manually preload
      
      return photos;
    } catch (e) {
      debugPrint('❌ [GALLERY] Error fetching photos: $e');
      
      // Try to return from cache on error
      final cached = await _offlineStorage.get(cacheKey);
      if (cached != null) {
        debugPrint('📦 [GALLERY] Returning photos from cache after error');
        return List<Map<String, dynamic>>.from(json.decode(cached));
      }
      
      rethrow;
    }
  }

  // Get Photos from Cache only
  Future<List<Map<String, dynamic>>> getPhotosFromCache(String albumId) async {
    final cacheKey = 'gallery_photos_$albumId';
    final cached = await _offlineStorage.get(cacheKey);
    if (cached != null) {
      return List<Map<String, dynamic>>.from(json.decode(cached));
    }
    return [];
  }

  // Get Album by ID
  Future<Map<String, dynamic>> getAlbumById(String albumId) async {
    try {
      final cacheKey = 'gallery_album_$albumId';
      
      // Try cache first
      final cached = await _offlineStorage.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(json.decode(cached));
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/gallery/albums/$albumId',
      );

      final album = Map<String, dynamic>.from(response.data);
      await _offlineStorage.set(cacheKey, json.encode(album));
      
      return album;
    } catch (e) {
      debugPrint('❌ [GALLERY] Error fetching album: $e');
      
      // Try cache on error
      final cacheKey = 'gallery_album_$albumId';
      final cached = await _offlineStorage.get(cacheKey);
      if (cached != null) {
        return Map<String, dynamic>.from(json.decode(cached));
      }
      
      rethrow;
    }
  }

  // Like Photo
  Future<void> likePhoto(String photoId) async {
    try {
      await _dio.post('${ApiConstants.baseUrl}/api/v1/gallery/interactions/like', data: {
        'photoId': photoId,
      });
    } catch (e) {
      debugPrint('❌ [GALLERY] Error liking photo: $e');
      rethrow;
    }
  }

  // Unlike Photo
  Future<void> unlikePhoto(String photoId) async {
    try {
      await _dio.delete('${ApiConstants.baseUrl}/api/v1/gallery/interactions/like/$photoId');
    } catch (e) {
      debugPrint('❌ [GALLERY] Error unliking photo: $e');
      rethrow;
    }
  }
}

