class GamificationProfile {
  final String id;
  final String userId;
  final int totalPoints;
  final int currentLevel;
  final int? rank;
  final List<UserBadge> badges;
  final Map<String, dynamic>? user; // Contains user info like name, photo

  GamificationProfile({
    required this.id,
    required this.userId,
    required this.totalPoints,
    required this.currentLevel,
    this.rank,
    required this.badges,
    this.user,
  });

  factory GamificationProfile.fromJson(Map<String, dynamic> json) {
    return GamificationProfile(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      totalPoints: json['totalPoints'] ?? json['total_points'] ?? 0,
      currentLevel: json['currentLevel'] ?? 1,
      rank: json['rank'],
      badges: (json['badges'] as List?)
              ?.map((e) => UserBadge.fromJson(e))
              .toList() ??
          [],
      user: json['user'],
    );
  }
}

class Badge {
  final String id;
  final String nameAr;
  final String nameEn;
  final String iconUrl;
  final String? descriptionAr;

  Badge({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    this.descriptionAr,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      descriptionAr: json['descriptionAr'],
    );
  }
}

class UserBadge {
  final String id;
  final String badgeId;
  final DateTime earnedAt;
  final Badge badge;

  UserBadge({
    required this.id,
    required this.badgeId,
    required this.earnedAt,
    required this.badge,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'] ?? '',
      badgeId: json['badgeId'] ?? json['badge_id'] ?? '',
      earnedAt: DateTime.parse(json['earnedAt'] ?? json['earned_at']),
      badge: Badge.fromJson(json['badge']),
    );
  }
}
