class GalleryPhotoModel {
  final String id;
  final String albumId;
  final String imageUrl;
  final String? thumbnailUrl;
  final String? previewUrl;
  final String? titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final int viewCount;
  final int likeCount;
  final int downloadCount;
  final bool isLiked;
  final bool isPublic;
  final bool allowDownload;
  final List<String> tags;
  final DateTime createdAt;
  final String? uploadedByName;

  GalleryPhotoModel({
    required this.id,
    required this.albumId,
    required this.imageUrl,
    this.thumbnailUrl,
    this.previewUrl,
    this.titleAr,
    this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.viewCount,
    required this.likeCount,
    required this.downloadCount,
    required this.isLiked,
    required this.isPublic,
    required this.allowDownload,
    required this.tags,
    required this.createdAt,
    this.uploadedByName,
  });

  // Getter for display title
  String get title => titleAr ?? titleEn ?? '';
  String get description => descriptionAr ?? descriptionEn ?? '';
  String get caption => description;

  factory GalleryPhotoModel.fromJson(Map<String, dynamic> json) {
    return GalleryPhotoModel(
      id: json['id'] as String,
      albumId: json['albumId'] as String,
      imageUrl: json['imageUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
      titleAr: json['titleAr'] as String?,
      titleEn: json['titleEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      viewCount: (json['viewCount'] ?? 0) as int,
      likeCount: (json['likeCount'] ?? 0) as int,
      downloadCount: (json['downloadCount'] ?? 0) as int,
      isLiked: (json['isLiked'] ?? false) as bool,
      isPublic: (json['isPublic'] ?? true) as bool,
      allowDownload: (json['allowDownload'] ?? true) as bool,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      uploadedByName: json['uploadedByName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'previewUrl': previewUrl,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'downloadCount': downloadCount,
      'isLiked': isLiked,
      'isPublic': isPublic,
      'allowDownload': allowDownload,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'uploadedByName': uploadedByName,
    };
  }
}
