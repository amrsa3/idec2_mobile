import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gallery_album_model.dart';
import '../models/gallery_photo_model.dart';
import '../../../services/gallery_service.dart';
import '../../../services/connectivity_service.dart';

// Initialize Gallery Service Provider
final galleryServiceProvider = Provider<GalleryService>((ref) {
  final service = GalleryService.instance;
  service.initialize();
  return service;
});

/// Provider for Gallery Albums
final galleryAlbumsProvider = FutureProvider.autoDispose<List<GalleryAlbumModel>>((ref) async {
  final service = ref.watch(galleryServiceProvider);
  
  final connectivityService = ConnectivityService.instance;
  await connectivityService.initialize();
  final isConnected = connectivityService.isConnected;
  
  try {
    final albumsData = await service.getAlbums(forceRefresh: !isConnected);
    return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
  } catch (e) {
    // Try to get from cache if online fetch fails
    if (isConnected) {
      final albumsData = await service.getAlbums(forceRefresh: false);
      return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
    }
    // Try cache only
    final albumsData = await service.getAlbumsFromCache();
    return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
  }
});

/// Provider for Gallery Albums by Category
final galleryAlbumsByCategoryProvider = FutureProvider.autoDispose.family<List<GalleryAlbumModel>, String>((ref, category) async {
  final service = ref.watch(galleryServiceProvider);
  
  final connectivityService = ConnectivityService.instance;
  await connectivityService.initialize();
  final isConnected = connectivityService.isConnected;
  
  try {
    final albumsData = await service.getAlbums(
      category: category,
      forceRefresh: !isConnected,
    );
    return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
  } catch (e) {
    if (isConnected) {
      final albumsData = await service.getAlbums(
        category: category,
        forceRefresh: false,
      );
      return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
    }
    // Try cache only
    final albumsData = await service.getAlbumsFromCache(category: category);
    return albumsData.map((json) => GalleryAlbumModel.fromJson(json)).toList();
  }
});

/// Provider for Gallery Photos by Album
final galleryPhotosProvider = FutureProvider.autoDispose.family<List<GalleryPhotoModel>, String>((ref, albumId) async {
  final service = ref.watch(galleryServiceProvider);
  
  final connectivityService = ConnectivityService.instance;
  await connectivityService.initialize();
  final isConnected = connectivityService.isConnected;
  
  try {
    final photosData = await service.getPhotos(
      albumId: albumId,
      forceRefresh: !isConnected,
    );
    return photosData.map((json) => GalleryPhotoModel.fromJson(json)).toList();
  } catch (e) {
    if (isConnected) {
      final photosData = await service.getPhotos(
        albumId: albumId,
        forceRefresh: false,
      );
      return photosData.map((json) => GalleryPhotoModel.fromJson(json)).toList();
    }
    // Try cache only
    final photosData = await service.getPhotosFromCache(albumId);
    return photosData.map((json) => GalleryPhotoModel.fromJson(json)).toList();
  }
});

/// Provider for Single Album
final galleryAlbumProvider = FutureProvider.autoDispose.family<GalleryAlbumModel, String>((ref, albumId) async {
  final service = ref.watch(galleryServiceProvider);
  
  try {
    final albumData = await service.getAlbumById(albumId);
    return GalleryAlbumModel.fromJson(albumData);
  } catch (e) {
    rethrow;
  }
});

/// Provider for Photo Like State
final photoLikeProvider = StateNotifierProvider.autoDispose.family<PhotoLikeNotifier, bool, String>((ref, photoId) {
  return PhotoLikeNotifier(photoId, ref);
});

class PhotoLikeNotifier extends StateNotifier<bool> {
  final String photoId;
  final Ref ref;

  PhotoLikeNotifier(this.photoId, this.ref) : super(false) {
    _loadLikeState();
  }

  Future<void> _loadLikeState() async {
    // Load initial like state from photo data
    // This would typically come from the photo model
  }

  Future<void> toggleLike() async {
    try {
      final service = ref.read(galleryServiceProvider);
      if (state) {
        await service.unlikePhoto(photoId);
        state = false;
      } else {
        await service.likePhoto(photoId);
        state = true;
      }
    } catch (e) {
      // Revert on error
      state = !state;
      rethrow;
    }
  }
}

