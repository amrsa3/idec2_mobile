class GalleryAlbumModel {
  final String id;
  final String titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? coverImageUrl;
  final int photoCount;
  final int viewCount;
  final int likeCount;
  final String category; // 'CONFERENCE', 'EVENT', 'EXHIBITION', 'SPEAKER', 'GENERAL'
  final bool isPublic;
  final DateTime? albumDate;
  final DateTime createdAt;
  final String? conferenceId;
  final String? eventId;

  GalleryAlbumModel({
    required this.id,
    required this.titleAr,
    this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    this.coverImageUrl,
    required this.photoCount,
    required this.viewCount,
    required this.likeCount,
    required this.category,
    required this.isPublic,
    this.albumDate,
    required this.createdAt,
    this.conferenceId,
    this.eventId,
  });

  // Getter for display title
  String get title => titleAr;
  String get description => descriptionAr ?? descriptionEn ?? '';

  factory GalleryAlbumModel.fromJson(Map<String, dynamic> json) {
    return GalleryAlbumModel(
      id: json['id'] as String,
      titleAr: json['titleAr'] as String,
      titleEn: json['titleEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      photoCount: (json['photoCount'] ?? 0) as int,
      viewCount: (json['viewCount'] ?? 0) as int,
      likeCount: (json['likeCount'] ?? 0) as int,
      category: json['category'] as String? ?? 'GENERAL',
      isPublic: (json['isPublic'] ?? true) as bool,
      albumDate: json['albumDate'] != null
          ? DateTime.parse(json['albumDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      conferenceId: json['conferenceId'] as String?,
      eventId: json['eventId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'coverImageUrl': coverImageUrl,
      'photoCount': photoCount,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'category': category,
      'isPublic': isPublic,
      'albumDate': albumDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'conferenceId': conferenceId,
      'eventId': eventId,
    };
  }
}
