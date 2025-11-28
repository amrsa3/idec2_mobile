import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../models/gallery_album_model.dart';
import '../models/gallery_photo_model.dart';
import 'gallery_fullscreen_view.dart';

class GalleryAlbumView extends ConsumerStatefulWidget {
  final GalleryAlbumModel album;

  const GalleryAlbumView({
    super.key,
    required this.album,
  });

  @override
  ConsumerState<GalleryAlbumView> createState() => _GalleryAlbumViewState();
}

class _GalleryAlbumViewState extends ConsumerState<GalleryAlbumView> {
  // Generate sample photos for the album
  List<GalleryPhotoModel> get _photos {
    return List.generate(
      widget.album.photoCount > 20 ? 20 : widget.album.photoCount,
      (index) => GalleryPhotoModel(
        id: '${widget.album.id}_$index',
        albumId: widget.album.id,
        imageUrl: 'https://picsum.photos/800/600?random=${index + 10}',
        thumbnailUrl: 'https://picsum.photos/200/200?random=${index + 10}',
        caption: index % 3 == 0 ? 'صورة من ${widget.album.title}' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.album.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.album.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Photos Grid
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final photo = _photos[index];
                  return _buildPhotoThumbnail(context, photo, index);
                },
                childCount: _photos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(
    BuildContext context,
    GalleryPhotoModel photo,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryFullscreenView(
              photos: _photos,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[900],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                photo.thumbnailUrl ?? photo.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary,
                    child:
                        const Icon(Icons.image, color: Colors.white, size: 30),
                  );
                },
              ),
            ),
            if (photo.caption != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
