import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/chat_enums.dart';
import '../services/chat_api_service.dart';
import '../services/chat_socket_service.dart';
import '../services/chat_local_storage.dart';
import '../services/chat_connection_manager.dart';

/// Chat Repository
/// Combines API and Socket services for complete chat functionality
class ChatRepository {
  final ChatApiService apiService;
  final ChatSocketService socketService;

  // Local cache
  final Map<String, ChatConversation> _conversationsCache = {};
  final Map<String, List<ChatMessage>> _messagesCache = {};
  
  // Local storage for offline support
  final ChatLocalStorage _localStorage = ChatLocalStorage.instance;
  
  // Stream Controllers
  final _conversationsStreamController = StreamController<List<ChatConversation>>.broadcast();
  final _messagesStreamController = StreamController<Map<String, List<ChatMessage>>>.broadcast();
  
  // Subscriptions to manage lifecycle
  final List<StreamSubscription> _subscriptions = [];

  Stream<List<ChatConversation>> get conversationsStream => _conversationsStreamController.stream;
  Stream<Map<String, List<ChatMessage>>> get messagesStream => _messagesStreamController.stream;

  final String userId;

  ChatRepository({
    required this.apiService,
    required this.socketService,
    required this.userId,
  }) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _localStorage.initialize();
    await chatConnection.initialize();
    _setupSocketListeners();
    await _loadFromLocalStorage();
    
    // Setup callback for pending messages when connection is restored
    socketService.onConnectionRestored = () {
      retrySendingPendingMessages();
    };
    
    // Also retry when network connection restored
    chatConnection.onConnectionRestored = () {
      debugPrint('🌐 [ChatRepository] Network restored - retrying pending messages');
      retrySendingPendingMessages();
    };
  }

  /// Load cached data from local storage on startup
  Future<void> _loadFromLocalStorage() async {
    try {
      // Load cached conversations
      final cachedConversations = await _localStorage.loadConversations();
      for (final conv in cachedConversations) {
        _conversationsCache[conv.id] = conv;
      }
      if (cachedConversations.isNotEmpty) {
        _emitConversations();
        debugPrint('📂 [ChatRepository] Loaded ${cachedConversations.length} cached conversations');
      }
    } catch (e) {
      debugPrint('⚠️ [ChatRepository] Load from local storage error: $e');
    }
  }

  void _setupSocketListeners() {
    // Listen for new messages
    _subscriptions.add(socketService.onNewMessage.listen((message) {
      // Correct isFromMe based on current user ID
      final correctedMessage = message.copyWith(
        isFromMe: message.senderId == userId,
      );
      
      // Check if message already exists (avoid duplicates from own messages)
      final existingMessages = _messagesCache[message.conversationId];
      if (existingMessages != null) {
        final exists = existingMessages.any((m) => m.id == message.id);
        if (exists) {
          // Message already in cache, just update it silently (might have new properties)
          _addMessageToCache(correctedMessage, silent: true);
          return;
        }
      }
      
      _addMessageToCache(correctedMessage);
      _updateConversationLastMessage(correctedMessage);
    }));

    // Listen for conversation updates
    _subscriptions.add(socketService.onConversationUpdated.listen((conversation) {
      _conversationsCache[conversation.id] = conversation;
      _emitConversations();
    }));

    // Listen for message read events
    _subscriptions.add(socketService.onMessageRead.listen((event) {
      debugPrint('👀 [ChatRepository] Read event: ${event.messageIds.length} messages in ${event.conversationId}');
      _markMessagesAsRead(event.conversationId, event.messageIds);
    }));

    // Listen for message delivered events
    _subscriptions.add(socketService.onMessageDelivered.listen((event) {
      debugPrint('🚚 [ChatRepository] Delivered event: ${event.messageId}');
      _markMessageAsDelivered(event.messageId);
    }));
  }

  void _addMessageToCache(ChatMessage message, {bool silent = false}) {
    _messagesCache[message.conversationId] ??= [];
    
    // Check if message already exists
    final existingIndex = _messagesCache[message.conversationId]!
        .indexWhere((m) => m.id == message.id);
    
    if (existingIndex != -1) {
      // Update existing message without changing position
      _messagesCache[message.conversationId]![existingIndex] = message;
    } else {
      // Insert new message at the beginning (newest first)
      _messagesCache[message.conversationId]!.insert(0, message);
    }
    
    if (!silent) {
      _emitMessages();
    }
  }

  void _updateConversationLastMessage(ChatMessage message) {
    final conversation = _conversationsCache[message.conversationId];
    if (conversation != null) {
      _conversationsCache[message.conversationId] = conversation.copyWith(
        lastMessage: message,
        lastMessageAt: message.createdAt,
        messagesCount: conversation.messagesCount + 1,
        unreadCount: message.isFromMe ? conversation.unreadCount : conversation.unreadCount + 1,
      );
      _emitConversations();
    }
  }

  void _markMessagesAsRead(String conversationId, List<String> messageIds) {
    debugPrint('👀 [ChatRepository] Marking ${messageIds.length} messages as read in $conversationId');
    final messages = _messagesCache[conversationId];
    if (messages != null) {
      bool updated = false;
      for (var i = 0; i < messages.length; i++) {
        if (messageIds.contains(messages[i].id)) {
          _messagesCache[conversationId]![i] = messages[i].copyWith(isRead: true);
          updated = true;
        }
      }
      if (updated) {
        debugPrint('✅ [ChatRepository] Messages marked as read');
        _emitMessages();
      }
    } else {
      debugPrint('⚠️ [ChatRepository] No cached messages for conversation $conversationId');
    }
  }

  void _markMessageAsDelivered(String messageId) {
    debugPrint('🔍 [ChatRepository] Marking message $messageId as delivered');
    for (var conversationId in _messagesCache.keys) {
      final messages = _messagesCache[conversationId]!;
      final index = messages.indexWhere((m) => m.id == messageId);
      
      if (index != -1) {
        debugPrint('✅ [ChatRepository] Message found and updated');
        _messagesCache[conversationId]![index] = messages[index].copyWith(isDelivered: true);
        _emitMessages();
        return; // Message found and updated
      }
    }
    debugPrint('⚠️ [ChatRepository] Message $messageId not found in local cache');
  }

  void _emitConversations() {
    final sorted = _conversationsCache.values.toList()
      ..sort((a, b) => (b.lastMessageAt ?? b.createdAt).compareTo(a.lastMessageAt ?? a.createdAt));
    _conversationsStreamController.add(sorted);
  }

  void _emitMessages() {
    _messagesStreamController.add(Map.from(_messagesCache));
  }

  // ============== CONVERSATIONS ==============

  /// Load conversations
  Future<List<ChatConversation>> loadConversations({
    ChatConversationType? type,
    ChatConversationStatus? status,
    int page = 1,
    int limit = 20,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _conversationsCache.clear();
      }

      final response = await apiService.getConversations(
        type: type,
        status: status,
        page: page,
        limit: limit,
      );

      for (final conv in response.conversations) {
        _conversationsCache[conv.id] = conv;
      }

      _emitConversations();
      
      // Save to local storage for offline access
      await _localStorage.saveConversations(_conversationsCache.values.toList());
      
      return response.conversations;
    } catch (e) {
      debugPrint('❌ [ChatRepository] Load conversations error: $e');
      
      // On error, try to return cached data
      if (_conversationsCache.isEmpty) {
        final cached = await _localStorage.loadConversations();
        for (final conv in cached) {
          _conversationsCache[conv.id] = conv;
        }
        if (cached.isNotEmpty) {
          _emitConversations();
          return cached;
        }
      }
      
      rethrow;
    }
  }

  /// Get conversation by ID
  Future<ChatConversation> getConversation(String id) async {
    try {
      // Check cache first
      if (_conversationsCache.containsKey(id)) {
        return _conversationsCache[id]!;
      }

      final conversation = await apiService.getConversation(id);
      _conversationsCache[id] = conversation;
      return conversation;
    } catch (e) {
      debugPrint('❌ [ChatRepository] Get conversation error: $e');
      rethrow;
    }
  }

  /// Create new conversation
  Future<ChatConversation> createConversation({
    required ChatConversationType type,
    required String recipientId,
    String? subject,
    String? productId,
    String? initialMessage,
  }) async {
    try {
      final conversation = await apiService.createConversation(
        type: type,
        recipientId: recipientId,
        subject: subject,
        productId: productId,
        initialMessage: initialMessage,
      );

      _conversationsCache[conversation.id] = conversation;
      _emitConversations();

      // Join the conversation room
      socketService.joinConversation(conversation.id);

      return conversation;
    } catch (e) {
      debugPrint('❌ [ChatRepository] Create conversation error: $e');
      rethrow;
    }
  }

  // ============== MESSAGES ==============

  /// Load messages for a conversation
  Future<List<ChatMessage>> loadMessages(
    String conversationId, {
    String? before,
    int limit = 50,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _messagesCache[conversationId]?.clear();
      }

      final messages = await apiService.getMessages(
        conversationId,
        before: before,
        limit: limit,
      );

      // API returns oldest -> newest
      // Cache stores newest -> oldest
      final newMessagesReversed = messages.reversed.toList();

      if (before == null) {
         // Initial load or refresh: Replace cache or prepend updates
         if (refresh || _messagesCache[conversationId] == null) {
            _messagesCache[conversationId] = newMessagesReversed;
         } else {
            // Merge needed? Usually for initial load without refresh
            // But if before is null, it means we are fetching the LATEST messages
             _messagesCache[conversationId] = [
                ...newMessagesReversed,
                 ..._messagesCache[conversationId]!
             ];
         }
      } else {
         // Load more (older messages): Append to end
          _messagesCache[conversationId] = [
             ...(_messagesCache[conversationId] ?? []),
             ...newMessagesReversed,
          ];
      }

      // Remove duplicates based on ID (keep first occurrence - newest)
      final seen = <String>{};
      _messagesCache[conversationId] = _messagesCache[conversationId]!
          .where((m) => seen.add(m.id))
          .toList();
      
      // Note: We don't sort here to avoid animation glitches
      // Messages from API are already in correct order

      _emitMessages();
      
      // Save to local storage for offline access
      await _localStorage.saveMessages(conversationId, _messagesCache[conversationId] ?? []);
      
      return messages;
    } catch (e) {
      debugPrint('❌ [ChatRepository] Load messages error: $e');
      
      // On error, try to return cached data from local storage
      if (_messagesCache[conversationId]?.isEmpty ?? true) {
        final cached = await _localStorage.loadMessages(conversationId);
        if (cached.isNotEmpty) {
          _messagesCache[conversationId] = cached;
          _emitMessages();
          return cached;
        }
      }
      
      rethrow;
    }
  }

  /// Get cached messages for a conversation
  List<ChatMessage> getCachedMessages(String conversationId) {
    return _messagesCache[conversationId] ?? [];
  }

  /// Send a message
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
    ChatMessageType type = ChatMessageType.text,
    Map<String, dynamic>? attachments,
    String? replyToId,
  }) async {
    // Create optimistic message
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessage(
      id: tempId,
      conversationId: conversationId,
      senderId: userId, // Use current user ID
      type: type,
      content: content,
      isFromMe: true,
      isDelivered: false,
      createdAt: DateTime.now(),
      attachments: attachments,
      replyToId: replyToId,
    );

    // Add to cache immediately for optimistic UI
    _addMessageToCache(optimisticMessage);

    try {
      // Send via API
      final message = await apiService.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        attachments: attachments,
        replyToId: replyToId,
      );

      // Replace optimistic message with real message (in-place, no animation)
      final messages = _messagesCache[conversationId];
      if (messages != null) {
        final tempIndex = messages.indexWhere((m) => m.id == tempId);
        if (tempIndex != -1) {
          // Replace in the same position
          _messagesCache[conversationId]![tempIndex] = message.copyWith(isFromMe: true);
          _emitMessages();
        }
      }
      
      // Remove from pending if it was saved there
      await _localStorage.removePendingMessage(tempId);
      
      return message;
    } catch (e) {
      debugPrint('❌ [ChatRepository] Send message error: $e');
      
      // Save as pending message for retry when connection is back
      await _localStorage.savePendingMessage(optimisticMessage);
      
      // Mark message as failed in UI (keep it visible)
      final messages = _messagesCache[conversationId];
      if (messages != null) {
        final tempIndex = messages.indexWhere((m) => m.id == tempId);
        if (tempIndex != -1) {
          // Keep the message but mark as not delivered
          _emitMessages();
        }
      }
      
      rethrow;
    }
  }

  /// Retry sending pending messages
  Future<void> retrySendingPendingMessages() async {
    try {
      final pendingMessages = await _localStorage.getPendingMessages();
      if (pendingMessages.isEmpty) return;
      
      debugPrint('🔄 [ChatRepository] Retrying ${pendingMessages.length} pending messages');
      
      for (final message in pendingMessages) {
        try {
          await apiService.sendMessage(
            conversationId: message.conversationId,
            content: message.content,
            type: message.type,
            attachments: message.attachments,
            replyToId: message.replyToId,
          );
          
          // Remove from pending on success
          await _localStorage.removePendingMessage(message.id);
          
          // Update UI - remove temp message
          _messagesCache[message.conversationId]?.removeWhere((m) => m.id == message.id);
          _emitMessages();
          
          debugPrint('✅ [ChatRepository] Pending message sent: ${message.id}');
        } catch (e) {
          debugPrint('❌ [ChatRepository] Failed to send pending message: ${message.id}');
        }
      }
    } catch (e) {
      debugPrint('❌ [ChatRepository] Retry pending messages error: $e');
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    try {
      final messages = _messagesCache[conversationId] ?? [];
      final unreadIds = messages
          .where((m) => !m.isRead && !m.isFromMe)
          .map((m) => m.id)
          .toList();

      if (unreadIds.isEmpty) return;

      // Optimistic update
      _markMessagesAsRead(conversationId, unreadIds);

      // Update conversation unread count
      final conversation = _conversationsCache[conversationId];
      if (conversation != null) {
        _conversationsCache[conversationId] = conversation.copyWith(unreadCount: 0);
        _emitConversations();
      }

      // Send to API
      await apiService.markAsRead(conversationId, unreadIds);
      
      // Also notify via socket
      socketService.markAsRead(conversationId, unreadIds);
    } catch (e) {
      debugPrint('❌ [ChatRepository] Mark as read error: $e');
    }
  }

  // ============== TYPING ==============

  /// Set typing indicator
  void setTyping(String conversationId, bool isTyping) {
    socketService.setTyping(conversationId, isTyping);
  }

  // ============== ROOM MANAGEMENT ==============

  /// Join a conversation room
  void joinConversation(String conversationId) {
    socketService.joinConversation(conversationId);
  }

  /// Leave a conversation room
  void leaveConversation(String conversationId) {
    socketService.leaveConversation(conversationId);
  }

  // ============== UTILITIES ==============

  /// Get total unread count
  Future<int> getTotalUnreadCount() async {
    try {
      return await apiService.getUnreadCount();
    } catch (e) {
      // Fallback to cache
      int total = 0;
      for (final conv in _conversationsCache.values) {
        total += conv.unreadCount;
      }
      return total;
    }
  }

  /// Get suggested replies
  Future<List<String>> getSuggestedReplies(String conversationId, String lastMessage) async {
    return apiService.getSuggestedReplies(
      conversationId: conversationId,
      lastMessage: lastMessage,
    );
  }

  /// Clear cache
  void clearCache() {
    _conversationsCache.clear();
    _messagesCache.clear();
    _emitConversations();
    _emitMessages();
  }

  /// Dispose resources
  void dispose() {
    for (var s in _subscriptions) s.cancel();
    _subscriptions.clear();
    _conversationsStreamController.close();
    _messagesStreamController.close();
  }
}
