import 'chat_enums.dart';

/// Message Model
/// Represents a single message in a conversation
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final ChatMessageType type;
  final String content;
  final Map<String, dynamic>? attachments;
  final Map<String, dynamic>? contextCard;
  final List<QuickAction>? quickActions;
  final bool isFromMe;
  final bool isRead;
  final bool isDelivered;
  final bool isSystemMessage;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? editedAt;
  final String? replyToId;
  final ChatMessage? replyTo;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.type,
    required this.content,
    this.attachments,
    this.contextCard,
    this.quickActions,
    this.isFromMe = false,
    this.isRead = false,
    this.isDelivered = false,
    this.isSystemMessage = false,
    required this.createdAt,
    this.readAt,
    this.editedAt,
    this.replyToId,
    this.replyTo,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Determine isRead - check multiple possible fields
    bool isRead = json['isRead'] == true || 
                  json['readAt'] != null;
    
    // Determine isDelivered - check multiple possible fields
    bool isDelivered = json['isDelivered'] == true || 
                       json['deliveredAt'] != null ||
                       json['delivered'] == true;
    
    return ChatMessage(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? json['sender']?['id'] ?? '',
      senderName: json['sender']?['name'] ?? 
                  json['sender']?['profile']?['fullNameAr'] ?? 
                  json['sender']?['phone'] ?? 
                  json['senderName'],
      senderAvatar: json['sender']?['avatar'] ??
                    json['sender']?['profile']?['profilePhotoUrl'] ?? 
                    json['senderAvatar'],
      type: ChatMessageTypeX.fromString(json['type'] ?? 'TEXT'),
      content: json['content'] ?? '',
      attachments: json['attachments'],
      contextCard: json['contextCard'],
      quickActions: (json['quickActions'] as List?)
          ?.map((e) => QuickAction.fromJson(e))
          .toList(),
      isFromMe: json['isFromMe'] ?? false,
      isRead: isRead,
      isDelivered: isDelivered,
      isSystemMessage: json['isSystemMessage'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      readAt: json['readAt'] != null 
          ? DateTime.parse(json['readAt']) 
          : null,
      editedAt: json['editedAt'] != null 
          ? DateTime.parse(json['editedAt']) 
          : null,
      replyToId: json['replyToId'],
      replyTo: json['replyTo'] != null 
          ? ChatMessage.fromJson(json['replyTo']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'senderName': senderName,
    'senderAvatar': senderAvatar,
    'type': type.value,
    'content': content,
    'attachments': attachments,
    'contextCard': contextCard,
    'quickActions': quickActions?.map((e) => e.toJson()).toList(),
    'isFromMe': isFromMe,
    'isRead': isRead,
    'isSystemMessage': isSystemMessage,
    'createdAt': createdAt.toIso8601String(),
    'readAt': readAt?.toIso8601String(),
    'editedAt': editedAt?.toIso8601String(),
    'replyToId': replyToId,
  };

  bool get isEdited => editedAt != null;

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    
    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      final weekdays = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
      return weekdays[createdAt.weekday % 7];
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    ChatMessageType? type,
    String? content,
    Map<String, dynamic>? attachments,
    Map<String, dynamic>? contextCard,
    List<QuickAction>? quickActions,
    bool? isFromMe,
    bool? isRead,
    bool? isDelivered,
    bool? isSystemMessage,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? editedAt,
    String? replyToId,
    ChatMessage? replyTo,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      contextCard: contextCard ?? this.contextCard,
      quickActions: quickActions ?? this.quickActions,
      isFromMe: isFromMe ?? this.isFromMe,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
      isSystemMessage: isSystemMessage ?? this.isSystemMessage,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      editedAt: editedAt ?? this.editedAt,
      replyToId: replyToId ?? this.replyToId,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}

/// Quick Action for messages
class QuickAction {
  final String id;
  final String label;
  final String? icon;
  final String action;
  final Map<String, dynamic>? data;
  final String? type;

  QuickAction({
    required this.id,
    required this.label,
    this.icon,
    required this.action,
    this.data,
    this.type,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) {
    return QuickAction(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      icon: json['icon'],
      action: json['action'] ?? '',
      data: json['data'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'icon': icon,
    'action': action,
    'data': data,
    'type': type,
  };
}

/// Context Card Types
class ProductContextCard {
  final String productId;
  final String name;
  final String? image;
  final double price;
  final String? currency;
  final String? vendorName;

  ProductContextCard({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
    this.currency,
    this.vendorName,
  });

  factory ProductContextCard.fromJson(Map<String, dynamic> json) {
    return ProductContextCard(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
      vendorName: json['vendorName'],
    );
  }
}
