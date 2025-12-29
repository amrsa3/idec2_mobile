import 'chat_enums.dart';
import 'message_model.dart';
import 'participant_model.dart';

/// Conversation Model
/// Represents a chat conversation
class ChatConversation {
  final String id;
  final ChatConversationType type;
  final ChatConversationStatus status;
  final ChatPriority priority;
  final String? subject;
  final String? category;
  final String? productId;
  final String? vendorId;
  final String? orderId;
  final String? conferenceId;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final ChatParticipant? otherParticipant;
  final int unreadCount;
  final int messagesCount;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final DateTime? closedAt;
  final Map<String, dynamic>? metadata;

  ChatConversation({
    required this.id,
    required this.type,
    required this.status,
    this.priority = ChatPriority.normal,
    this.subject,
    this.category,
    this.productId,
    this.vendorId,
    this.orderId,
    this.conferenceId,
    this.participants = const [],
    this.lastMessage,
    this.otherParticipant,
    this.unreadCount = 0,
    this.messagesCount = 0,
    required this.createdAt,
    this.lastMessageAt,
    this.closedAt,
    this.metadata,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    final participants = (json['participants'] as List?)
        ?.map((p) => ChatParticipant.fromJson(p))
        .toList() ?? [];

    ChatParticipant? otherParticipant;
    if (json['otherParticipant'] != null) {
      otherParticipant = ChatParticipant.fromJson(json['otherParticipant']);
    }

    return ChatConversation(
      id: json['id'] ?? '',
      type: ChatConversationTypeX.fromString(json['type'] ?? 'MARKETPLACE'),
      status: ChatConversationStatusX.fromString(json['status'] ?? 'OPEN'),
      priority: ChatPriorityX.fromString(json['priority'] ?? 'NORMAL'),
      subject: json['subject'],
      category: json['category'],
      productId: json['productId'],
      vendorId: json['vendorId'],
      orderId: json['orderId'],
      conferenceId: json['conferenceId'],
      participants: participants,
      lastMessage: json['lastMessage'] != null 
          ? ChatMessage.fromJson(json['lastMessage']) 
          : null,
      otherParticipant: otherParticipant,
      unreadCount: json['unreadCount'] ?? 0,
      messagesCount: json['messagesCount'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      lastMessageAt: json['lastMessageAt'] != null 
          ? DateTime.parse(json['lastMessageAt']) 
          : null,
      closedAt: json['closedAt'] != null 
          ? DateTime.parse(json['closedAt']) 
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.value,
    'status': status.value,
    'priority': priority.value,
    'subject': subject,
    'category': category,
    'productId': productId,
    'vendorId': vendorId,
    'orderId': orderId,
    'conferenceId': conferenceId,
    'participants': participants.map((p) => p.toJson()).toList(),
    'lastMessage': lastMessage?.toJson(),
    'unreadCount': unreadCount,
    'messagesCount': messagesCount,
    'createdAt': createdAt.toIso8601String(),
    'lastMessageAt': lastMessageAt?.toIso8601String(),
    'closedAt': closedAt?.toIso8601String(),
    'metadata': metadata,
  };

  /// Get display name for the conversation
  String getDisplayName({bool isArabic = true}) {
    if (subject != null && subject!.isNotEmpty) {
      return subject!;
    }
    
    if (otherParticipant?.userName != null) {
      return otherParticipant!.userName!;
    }

    if (participants.isNotEmpty) {
      return participants.first.userName ?? 'محادثة';
    }

    return isArabic ? type.displayNameAr : type.displayNameEn;
  }

  /// Get avatar for the conversation
  String? get displayAvatar {
    return otherParticipant?.userAvatar ?? 
           (participants.isNotEmpty ? participants.first.userAvatar : null);
  }

  /// Check if conversation has unread messages
  bool get hasUnread => unreadCount > 0;

  /// Check if conversation is active
  bool get isActive => status == ChatConversationStatus.open || 
                       status == ChatConversationStatus.active;

  /// Get formatted time for last message
  String get formattedLastMessageTime {
    if (lastMessageAt == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(lastMessageAt!);
    
    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} د';
    } else if (diff.inDays < 1) {
      return '${lastMessageAt!.hour.toString().padLeft(2, '0')}:${lastMessageAt!.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      final weekdays = ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
      return weekdays[lastMessageAt!.weekday % 7];
    } else {
      return '${lastMessageAt!.day}/${lastMessageAt!.month}';
    }
  }

  ChatConversation copyWith({
    String? id,
    ChatConversationType? type,
    ChatConversationStatus? status,
    ChatPriority? priority,
    String? subject,
    String? category,
    String? productId,
    String? vendorId,
    String? orderId,
    String? conferenceId,
    List<ChatParticipant>? participants,
    ChatMessage? lastMessage,
    ChatParticipant? otherParticipant,
    int? unreadCount,
    int? messagesCount,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    DateTime? closedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      productId: productId ?? this.productId,
      vendorId: vendorId ?? this.vendorId,
      orderId: orderId ?? this.orderId,
      conferenceId: conferenceId ?? this.conferenceId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      otherParticipant: otherParticipant ?? this.otherParticipant,
      unreadCount: unreadCount ?? this.unreadCount,
      messagesCount: messagesCount ?? this.messagesCount,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      closedAt: closedAt ?? this.closedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Conversations List Response
class ConversationsResponse {
  final List<ChatConversation> conversations;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  ConversationsResponse({
    required this.conversations,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    return ConversationsResponse(
      conversations: (json['data'] as List?)
          ?.map((c) => ChatConversation.fromJson(c))
          .toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      hasMore: json['hasMore'] ?? false,
    );
  }
}
