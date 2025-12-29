import 'package:flutter/material.dart';

/// Chat Theme Extensions
/// Provides consistent theming for chat feature
class ChatTheme {
  /// Context colors
  static const Color marketplaceColor = Color(0xFF10B981);
  static const Color supportColor = Color(0xFFF59E0B);
  static const Color eventColor = Color(0xFF3B82F6);
  static const Color groupColor = Color(0xFF8B5CF6);
  static const Color broadcastColor = Color(0xFFEC4899);

  /// Message colors
  static const Color sentMessageColor = Color(0xFF0088CC);
  static const Color receivedMessageColor = Color(0xFFF1F5F8);

  /// Status colors
  static const Color onlineColor = Color(0xFF22C55E);
  static const Color offlineColor = Color(0xFF9CA3AF);
  static const Color typingColor = Color(0xFF3B82F6);

  /// Get gradient for sent messages
  static LinearGradient get sentMessageGradient => LinearGradient(
        colors: [
          sentMessageColor,
          sentMessageColor.withOpacity(0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Get color for conversation type
  static Color getContextColor(String type) {
    switch (type.toUpperCase()) {
      case 'MARKETPLACE':
        return marketplaceColor;
      case 'SUPPORT':
        return supportColor;
      case 'EVENT':
        return eventColor;
      case 'GROUP':
        return groupColor;
      case 'BROADCAST':
        return broadcastColor;
      default:
        return Colors.grey;
    }
  }

  /// Get icon for conversation type
  static IconData getContextIcon(String type) {
    switch (type.toUpperCase()) {
      case 'MARKETPLACE':
        return Icons.shopping_bag_outlined;
      case 'SUPPORT':
        return Icons.support_agent_outlined;
      case 'EVENT':
        return Icons.event_outlined;
      case 'GROUP':
        return Icons.groups_outlined;
      case 'BROADCAST':
        return Icons.campaign_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}

/// Chat Animations
class ChatAnimations {
  static const Duration messageFadeIn = Duration(milliseconds: 200);
  static const Duration typingIndicator = Duration(milliseconds: 300);
  static const Duration scrollToBottom = Duration(milliseconds: 300);
  static const Duration bubbleExpand = Duration(milliseconds: 150);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
}

/// Chat Strings (Arabic)
class ChatStrings {
  // General
  static const String conversations = 'المحادثات';
  static const String newConversation = 'محادثة جديدة';
  static const String search = 'بحث';
  static const String noConversations = 'لا توجد محادثات';
  static const String startConversation = 'ابدأ محادثة جديدة';

  // Types
  static const String marketplace = 'المتجر';
  static const String support = 'الدعم الفني';
  static const String event = 'المؤتمر';
  static const String group = 'مجموعة';
  static const String broadcast = 'إعلانات';

  // Messages
  static const String typeMessage = 'اكتب رسالتك...';
  static const String send = 'إرسال';
  static const String delivered = 'تم التسليم';
  static const String read = 'مقروء';
  static const String typing = 'يكتب...';
  static const String online = 'متصل';
  static const String offline = 'غير متصل';

  // Time
  static const String now = 'الآن';
  static const String today = 'اليوم';
  static const String yesterday = 'أمس';
  static const String minute = 'دقيقة';
  static const String hour = 'ساعة';

  // Actions
  static const String reply = 'رد';
  static const String copy = 'نسخ';
  static const String delete = 'حذف';
  static const String forward = 'إعادة توجيه';
  static const String star = 'تميز';
  static const String report = 'إبلاغ';

  // Attachments
  static const String photo = 'صورة';
  static const String file = 'ملف';
  static const String voice = 'رسالة صوتية';
  static const String video = 'فيديو';
  static const String location = 'موقع';
  static const String product = 'منتج';
  static const String quote = 'عرض سعر';
  static const String invoice = 'فاتورة';

  // Errors
  static const String connectionError = 'خطأ في الاتصال';
  static const String sendError = 'فشل إرسال الرسالة';
  static const String loadError = 'فشل تحميل المحادثات';
  static const String retry = 'إعادة المحاولة';
}

/// Chat Configuration
class ChatConfig {
  /// API Configuration
  static const int messagesPerPage = 50;
  static const int conversationsPerPage = 20;

  /// Socket Configuration
  static const int reconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 2);
  static const Duration heartbeatInterval = Duration(seconds: 30);
  static const Duration typingTimeout = Duration(seconds: 3);

  /// UI Configuration
  static const double maxBubbleWidth = 0.75; // Percentage of screen width
  static const double avatarSize = 40.0;
  static const double smallAvatarSize = 32.0;
  static const int maxAttachments = 10;
  static const int maxMessageLength = 4000;

  /// File Configuration
  static const int maxFileSize = 50 * 1024 * 1024; // 50 MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'zip'];
}
