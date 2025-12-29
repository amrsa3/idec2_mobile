/// Chat Enums
/// Defines all enumerations used in the chat feature

/// Conversation type
enum ChatConversationType {
  marketplace,
  support,
  event,
  group,
  broadcast,
}

extension ChatConversationTypeX on ChatConversationType {
  String get value {
    switch (this) {
      case ChatConversationType.marketplace:
        return 'MARKETPLACE';
      case ChatConversationType.support:
        return 'SUPPORT';
      case ChatConversationType.event:
        return 'EVENT';
      case ChatConversationType.group:
        return 'GROUP';
      case ChatConversationType.broadcast:
        return 'BROADCAST';
    }
  }

  static ChatConversationType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'MARKETPLACE':
        return ChatConversationType.marketplace;
      case 'SUPPORT':
        return ChatConversationType.support;
      case 'EVENT':
        return ChatConversationType.event;
      case 'GROUP':
        return ChatConversationType.group;
      case 'BROADCAST':
        return ChatConversationType.broadcast;
      default:
        return ChatConversationType.marketplace;
    }
  }

  String get displayNameAr {
    switch (this) {
      case ChatConversationType.marketplace:
        return 'المتجر';
      case ChatConversationType.support:
        return 'الدعم الفني';
      case ChatConversationType.event:
        return 'المؤتمر';
      case ChatConversationType.group:
        return 'مجموعة';
      case ChatConversationType.broadcast:
        return 'إعلانات';
    }
  }

  String get displayNameEn {
    switch (this) {
      case ChatConversationType.marketplace:
        return 'Marketplace';
      case ChatConversationType.support:
        return 'Support';
      case ChatConversationType.event:
        return 'Event';
      case ChatConversationType.group:
        return 'Group';
      case ChatConversationType.broadcast:
        return 'Broadcast';
    }
  }
}

/// Conversation status
enum ChatConversationStatus {
  open,
  active,
  waiting,
  resolved,
  closed,
}

extension ChatConversationStatusX on ChatConversationStatus {
  String get value {
    switch (this) {
      case ChatConversationStatus.open:
        return 'OPEN';
      case ChatConversationStatus.active:
        return 'ACTIVE';
      case ChatConversationStatus.waiting:
        return 'WAITING';
      case ChatConversationStatus.resolved:
        return 'RESOLVED';
      case ChatConversationStatus.closed:
        return 'CLOSED';
    }
  }

  static ChatConversationStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'OPEN':
        return ChatConversationStatus.open;
      case 'ACTIVE':
        return ChatConversationStatus.active;
      case 'WAITING':
        return ChatConversationStatus.waiting;
      case 'RESOLVED':
        return ChatConversationStatus.resolved;
      case 'CLOSED':
        return ChatConversationStatus.closed;
      default:
        return ChatConversationStatus.open;
    }
  }
}

/// Message type
enum ChatMessageType {
  text,
  image,
  file,
  audio,
  video,
  location,
  productCard,
  quoteCard,
  invoiceCard,
  orderCard,
  system,
  quickReply,
}

extension ChatMessageTypeX on ChatMessageType {
  String get value {
    switch (this) {
      case ChatMessageType.text:
        return 'TEXT';
      case ChatMessageType.image:
        return 'IMAGE';
      case ChatMessageType.file:
        return 'FILE';
      case ChatMessageType.audio:
        return 'AUDIO';
      case ChatMessageType.video:
        return 'VIDEO';
      case ChatMessageType.location:
        return 'LOCATION';
      case ChatMessageType.productCard:
        return 'PRODUCT_CARD';
      case ChatMessageType.quoteCard:
        return 'QUOTE_CARD';
      case ChatMessageType.invoiceCard:
        return 'INVOICE_CARD';
      case ChatMessageType.orderCard:
        return 'ORDER_CARD';
      case ChatMessageType.system:
        return 'SYSTEM';
      case ChatMessageType.quickReply:
        return 'QUICK_REPLY';
    }
  }

  static ChatMessageType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'TEXT':
        return ChatMessageType.text;
      case 'IMAGE':
        return ChatMessageType.image;
      case 'FILE':
        return ChatMessageType.file;
      case 'AUDIO':
        return ChatMessageType.audio;
      case 'VIDEO':
        return ChatMessageType.video;
      case 'LOCATION':
        return ChatMessageType.location;
      case 'PRODUCT_CARD':
        return ChatMessageType.productCard;
      case 'QUOTE_CARD':
        return ChatMessageType.quoteCard;
      case 'INVOICE_CARD':
        return ChatMessageType.invoiceCard;
      case 'ORDER_CARD':
        return ChatMessageType.orderCard;
      case 'SYSTEM':
        return ChatMessageType.system;
      case 'QUICK_REPLY':
        return ChatMessageType.quickReply;
      default:
        return ChatMessageType.text;
    }
  }
}

/// Priority level
enum ChatPriority {
  low,
  normal,
  high,
  urgent,
}

extension ChatPriorityX on ChatPriority {
  String get value {
    switch (this) {
      case ChatPriority.low:
        return 'LOW';
      case ChatPriority.normal:
        return 'NORMAL';
      case ChatPriority.high:
        return 'HIGH';
      case ChatPriority.urgent:
        return 'URGENT';
    }
  }

  static ChatPriority fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return ChatPriority.low;
      case 'NORMAL':
        return ChatPriority.normal;
      case 'HIGH':
        return ChatPriority.high;
      case 'URGENT':
        return ChatPriority.urgent;
      default:
        return ChatPriority.normal;
    }
  }
}
