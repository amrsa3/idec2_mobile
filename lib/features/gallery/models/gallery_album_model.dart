class GalleryAlbumModel {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;
  final int photoCount;
  final DateTime? date;
  final String category; // 'conference', 'exhibition', 'workshops'

  GalleryAlbumModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.photoCount,
    this.date,
    this.category = 'conference',
  });
}
