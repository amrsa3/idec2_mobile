import 'chat_enums.dart';

/// Participant Model
/// Represents a user in a conversation
class ChatParticipant {
  final String id;
  final String conversationId;
  final String userId;
  final String role;
  final String? userName;
  final String? userAvatar;
  final String? userPhone;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final DateTime joinedAt;
  final DateTime? leftAt;

  ChatParticipant({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    this.userName,
    this.userAvatar,
    this.userPhone,
    this.isOnline = false,
    this.lastSeenAt,
    required this.joinedAt,
    this.leftAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    // Extract user data from various possible paths
    final user = json['user'] as Map<String, dynamic>?;
    final profile = user?['profile'] as Map<String, dynamic>?;
    final userProfile = user?['userProfile'] as Map<String, dynamic>?;
    
    // Get userName - check multiple paths
    String? userName = json['name'] ?? 
                       profile?['fullNameAr'] ?? 
                       userProfile?['fullNameAr'] ?? 
                       user?['phone'] ?? 
                       json['userName'];
    
    // If userName is empty or 'مستخدم', try to get phone as fallback
    if (userName == null || userName.isEmpty || userName == 'مستخدم') {
      userName = user?['phone'] ?? json['userPhone'] ?? 'مستخدم';
    }
    
    // Get userAvatar - check multiple paths
    String? userAvatar = json['avatar'] ??
                         profile?['profilePhotoUrl'] ??
                         userProfile?['profilePhotoUrl'] ??
                         json['userAvatar'];
    
    // Debug log for avatar
    // debugPrint('👤 [Participant] name: $userName, avatar: $userAvatar');
    
    // Get userPhone
    String? userPhone = user?['phone'] ?? json['userPhone'];
    
    bool isOnline = json['isOnline'] ?? false;
    
    return ChatParticipant(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      userId: json['userId'] ?? json['id'] ?? '',
      role: json['role'] ?? 'MEMBER',
      userName: userName,
      userAvatar: userAvatar,
      userPhone: userPhone,
      isOnline: isOnline,
      lastSeenAt: json['lastSeenAt'] != null 
          ? DateTime.parse(json['lastSeenAt']) 
          : null,
      joinedAt: json['joinedAt'] != null 
          ? DateTime.parse(json['joinedAt']) 
          : DateTime.now(),
      leftAt: json['leftAt'] != null 
          ? DateTime.parse(json['leftAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'userId': userId,
    'role': role,
    'userName': userName,
    'userAvatar': userAvatar,
    'userPhone': userPhone,
    'isOnline': isOnline,
    'lastSeenAt': lastSeenAt?.toIso8601String(),
    'joinedAt': joinedAt.toIso8601String(),
    'leftAt': leftAt?.toIso8601String(),
  };

  bool get isActive => leftAt == null;

  ChatParticipant copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? role,
    String? userName,
    String? userAvatar,
    String? userPhone,
    bool? isOnline,
    DateTime? lastSeenAt,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      userPhone: userPhone ?? this.userPhone,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
    );
  }
}
