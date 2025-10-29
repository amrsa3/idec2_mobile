class GalleryPhotoModel {
  final String id;
  final String albumId;
  final String imageUrl;
  final String? thumbnailUrl;
  final String? caption;
  final DateTime? takenAt;
  final String? photographer;

  GalleryPhotoModel({
    required this.id,
    required this.albumId,
    required this.imageUrl,
    this.thumbnailUrl,
    this.caption,
    this.takenAt,
    this.photographer,
  });
}
