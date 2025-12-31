import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/chat_enums.dart';

/// Chat API Service
/// Handles REST API calls for chat functionality
class ChatApiService {
  final String baseUrl;
  final String Function() getToken;

  ChatApiService({
    required this.baseUrl,
    required this.getToken,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${getToken()}',
  };

  String get _chatUrl => '$baseUrl/api/v1/chat';

  /// Create a new conversation
  Future<ChatConversation> createConversation({
    required ChatConversationType type,
    required String recipientId,
    String? subject,
    String? productId,
    String? initialMessage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_chatUrl/conversations'),
        headers: _headers,
        body: jsonEncode({
          'type': type.value,
          'recipientId': recipientId,
          if (subject != null) 'subject': subject,
          if (productId != null) 'productId': productId,
          if (initialMessage != null) 'initialMessage': initialMessage,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatConversation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Create conversation error: $e');
      rethrow;
    }
  }

  /// Get conversations list
  Future<ConversationsResponse> getConversations({
    ChatConversationType? type,
    ChatConversationStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type.value,
        if (status != null) 'status': status.value,
      };

      final uri = Uri.parse('$_chatUrl/conversations').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return ConversationsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get conversations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get conversations error: $e');
      rethrow;
    }
  }

  /// Get single conversation
  Future<ChatConversation> getConversation(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_chatUrl/conversations/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return ChatConversation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get conversation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get conversation error: $e');
      rethrow;
    }
  }

  /// Get messages for a conversation
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    String? before,
    int limit = 50,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        if (before != null) 'before': before,
      };

      final uri = Uri.parse('$_chatUrl/conversations/$conversationId/messages')
          .replace(queryParameters: queryParams);
          
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        debugPrint('📥 [ChatAPI] Raw Response for conversation $conversationId: ${response.body}');
        final dynamic data = jsonDecode(response.body);
        
        List<dynamic> messagesList = [];
        
        if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            messagesList = data['data'];
          } else if (data['messages'] is List) {
            messagesList = data['messages'];
          }
        } else if (data is List) {
          messagesList = data;
        }

        final messages = <ChatMessage>[];
        for (final m in messagesList) {
          try {
            messages.add(ChatMessage.fromJson(m));
          } catch (e) {
            debugPrint('⚠️ [ChatAPI] Failed to parse message: $e, Data: $m');
          }
        }
            
        return messages;
      } else {
        debugPrint('❌ [ChatAPI] Failed status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to get messages: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get messages error: $e');
      rethrow;
    }
  }

  /// Send a message
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
    ChatMessageType type = ChatMessageType.text,
    Map<String, dynamic>? attachments,
    String? replyToId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_chatUrl/messages'),
        headers: _headers,
        body: jsonEncode({
          'conversationId': conversationId,
          'content': content,
          'type': type.value,
          if (attachments != null) 'attachments': attachments,
          if (replyToId != null) 'replyToId': replyToId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatMessage.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Send message error: $e');
      rethrow;
    }
  }

  /// Mark messages as read
  Future<void> markAsRead(String conversationId, List<String> messageIds) async {
    try {
      await http.post(
        Uri.parse('$_chatUrl/conversations/$conversationId/read'),
        headers: _headers,
        body: jsonEncode({'messageIds': messageIds}),
      );
    } catch (e) {
      debugPrint('❌ [ChatAPI] Mark as read error: $e');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse('$_chatUrl/unread-count'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['unreadCount'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get unread count error: $e');
      return 0;
    }
  }

  /// Get suggested replies
  Future<List<String>> getSuggestedReplies({
    required String conversationId,
    required String lastMessage,
    String? type,
    String? category,
  }) async {
    try {
      final queryParams = {
        'conversationId': conversationId,
        'lastMessage': lastMessage,
        if (type != null) 'type': type,
        if (category != null) 'category': category,
      };

      final uri = Uri.parse('$_chatUrl/ai/suggestions').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get suggestions error: $e');
      return [];
    }
  }

  /// Get support categories
  Future<List<Map<String, dynamic>>> getSupportCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_chatUrl/support/categories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get support categories error: $e');
      return [];
    }
  }

  /// Get event FAQs
  Future<List<Map<String, dynamic>>> getEventFAQs({String? conferenceId}) async {
    try {
      final queryParams = conferenceId != null ? {'conferenceId': conferenceId} : null;
      final uri = Uri.parse('$_chatUrl/event/faqs');
      final response = await http.get(
        queryParams != null ? uri.replace(queryParameters: queryParams) : uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get FAQs error: $e');
      return [];
    }
  }

  /// Create a group
  Future<ChatConversation> createGroup({
    required String name,
    required List<String> memberIds,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_chatUrl/groups'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'memberIds': memberIds,
          if (description != null) 'description': description,
          if (imageUrl != null) 'imageUrl': imageUrl,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatConversation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create group: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [ChatAPI] Create group error: $e');
      rethrow;
    }
  }

  /// Get vendor chat stats
  Future<Map<String, dynamic>> getVendorStats(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_chatUrl/vendor/$vendorId/stats'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (e) {
      debugPrint('❌ [ChatAPI] Get vendor stats error: $e');
      return {};
    }
  }

  /// Close conversation
  Future<void> closeConversation(String conversationId) async {
    try {
      await http.patch(
        Uri.parse('$_chatUrl/conversations/$conversationId'),
        headers: _headers,
        body: jsonEncode({'status': 'CLOSED'}),
      );
    } catch (e) {
      debugPrint('❌ [ChatAPI] Close conversation error: $e');
      rethrow;
    }
  }

  /// Rate conversation
  Future<void> rateConversation(String conversationId, int rating, {String? feedback}) async {
    try {
      await http.post(
        Uri.parse('$_chatUrl/conversations/$conversationId/rate'),
        headers: _headers,
        body: jsonEncode({
          'rating': rating,
          if (feedback != null) 'feedback': feedback,
        }),
      );
    } catch (e) {
      debugPrint('❌ [ChatAPI] Rate conversation error: $e');
    }
  }
}
