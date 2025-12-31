import 'package:flutter/material.dart';
import '../data/models/chat_enums.dart';
import '../data/models/conversation_model.dart';
import '../data/models/participant_model.dart';

/// Chat Helper Functions
/// Shared utilities for chat module to avoid code duplication
class ChatHelpers {
  ChatHelpers._();

  // ============== DISPLAY NAME ==============

  /// Get display name for a conversation
  /// Priority: fullNameAr > phone > subject > type name
  static String getDisplayName(ChatConversation conversation) {
    // First check otherParticipant
    if (conversation.otherParticipant?.userName != null &&
        conversation.otherParticipant!.userName!.isNotEmpty &&
        conversation.otherParticipant!.userName != 'مستخدم') {
      return conversation.otherParticipant!.userName!;
    }
    
    // Check subject
    if (conversation.subject != null && conversation.subject!.isNotEmpty) {
      return conversation.subject!;
    }
    
    // Fallback to first participant
    if (conversation.participants.isNotEmpty) {
      final firstParticipant = conversation.participants.first;
      if (firstParticipant.userName != null && 
          firstParticipant.userName!.isNotEmpty &&
          firstParticipant.userName != 'مستخدم') {
        return firstParticipant.userName!;
      }
      // Use phone if available
      if (firstParticipant.userPhone != null) {
        return firstParticipant.userPhone!;
      }
    }
    
    // Default fallback based on type
    return conversation.type.displayNameAr;
  }

  /// Get participant name
  static String getParticipantName(ChatParticipant? participant) {
    if (participant == null) return 'مستخدم';
    
    if (participant.userName != null && 
        participant.userName!.isNotEmpty &&
        participant.userName != 'مستخدم') {
      return participant.userName!;
    }
    
    if (participant.userPhone != null && participant.userPhone!.isNotEmpty) {
      return participant.userPhone!;
    }
    
    return 'مستخدم';
  }

  // ============== AVATAR ==============

  /// Get avatar URL for conversation
  static String? getAvatarUrl(ChatConversation conversation) {
    return conversation.displayAvatar ?? 
           conversation.otherParticipant?.userAvatar;
  }

  /// Get first letter for avatar fallback
  static String getAvatarLetter(String name) {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  /// Check if avatar URL is valid
  static bool isValidAvatarUrl(String? url) {
    return url != null && url.isNotEmpty && url.startsWith('http');
  }

  // ============== COLORS ==============

  /// Get context color based on conversation type
  static Color getContextColor(ChatConversationType type) {
    switch (type) {
      case ChatConversationType.marketplace:
        return const Color(0xFF10B981); // Green
      case ChatConversationType.support:
        return const Color(0xFFF59E0B); // Orange
      case ChatConversationType.event:
        return const Color(0xFF3B82F6); // Blue
      case ChatConversationType.group:
        return const Color(0xFF8B5CF6); // Purple
      case ChatConversationType.broadcast:
        return const Color(0xFFEC4899); // Pink
      case ChatConversationType.direct:
        return const Color(0xFF06B6D4); // Cyan
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  /// Get context icon based on conversation type
  static IconData getContextIcon(ChatConversationType type) {
    switch (type) {
      case ChatConversationType.marketplace:
        return Icons.store;
      case ChatConversationType.support:
        return Icons.support_agent;
      case ChatConversationType.event:
        return Icons.event;
      case ChatConversationType.group:
        return Icons.group;
      case ChatConversationType.broadcast:
        return Icons.campaign;
      case ChatConversationType.direct:
        return Icons.person;
      default:
        return Icons.chat;
    }
  }

  // ============== TIME FORMATTING ==============

  /// Format time for conversation list
  static String formatConversationTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      const weekdays = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
      return weekdays[dateTime.weekday % 7];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  /// Format message time
  static String formatMessageTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // ============== MESSAGE STATUS ==============

  /// Get status icon for message
  static IconData getStatusIcon({
    required bool isRead,
    required bool isDelivered,
  }) {
    if (isRead) {
      return Icons.done_all;
    } else if (isDelivered) {
      return Icons.done_all;
    } else {
      return Icons.done;
    }
  }

  /// Get status color for message
  static Color getStatusColor({
    required bool isRead,
    required bool isDelivered,
    Color defaultColor = Colors.grey,
  }) {
    if (isRead) {
      return Colors.lightBlue;
    }
    return defaultColor.withOpacity(0.7);
  }

  // ============== UTILITY ==============

  /// Truncate message for preview
  static String truncateMessage(String content, {int maxLength = 50}) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }

  /// Check if user is online
  static bool isUserOnline(ChatConversation conversation) {
    return conversation.otherParticipant?.isOnline == true;
  }

  /// Get unread count text
  static String getUnreadCountText(int count) {
    if (count <= 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }
}

/// Extension for easy access on conversations
extension ChatConversationHelpers on ChatConversation {
  String get displayName => ChatHelpers.getDisplayName(this);
  String? get avatarUrl => ChatHelpers.getAvatarUrl(this);
  String get avatarLetter => ChatHelpers.getAvatarLetter(displayName);
  Color get contextColor => ChatHelpers.getContextColor(type);
  IconData get contextIcon => ChatHelpers.getContextIcon(type);
  bool get isOtherUserOnline => ChatHelpers.isUserOnline(this);
}
