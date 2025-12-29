import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

/// Chat Local Storage Service
/// Provides offline caching for conversations and messages
class ChatLocalStorage {
  static final ChatLocalStorage _instance = ChatLocalStorage._internal();
  static ChatLocalStorage get instance => _instance;
  ChatLocalStorage._internal();

  SharedPreferences? _prefs;
  bool _initialized = false;

  // Cache Keys
  static const String _conversationsKey = 'chat_conversations_cache';
  static const String _messagesPrefix = 'chat_messages_';
  static const String _lastSyncKey = 'chat_last_sync';
  static const String _pendingMessagesKey = 'chat_pending_messages';
  static const String _draftMessagesKey = 'chat_draft_messages';

  // Cache Configuration
  static const int maxConversationsCache = 100;
  static const int maxMessagesPerConversation = 200;
  static const Duration cacheExpiry = Duration(days: 7);

  /// Initialize the storage
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      debugPrint('✅ [ChatLocalStorage] Initialized');
      
      // Clean up expired cache
      await _cleanExpiredCache();
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Initialization failed: $e');
    }
  }

  /// Ensure initialized
  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }

  // ============== CONVERSATIONS ==============

  /// Save conversations to local cache
  Future<void> saveConversations(List<ChatConversation> conversations) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      // Limit to maxConversationsCache
      final toSave = conversations.take(maxConversationsCache).toList();
      final jsonList = toSave.map((c) => c.toJson()).toList();
      
      await _prefs!.setString(_conversationsKey, jsonEncode(jsonList));
      await _prefs!.setString(_lastSyncKey, DateTime.now().toIso8601String());
      
      debugPrint('💾 [ChatLocalStorage] Saved ${toSave.length} conversations');
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Save conversations error: $e');
    }
  }

  /// Load conversations from local cache
  Future<List<ChatConversation>> loadConversations() async {
    await _ensureInitialized();
    if (_prefs == null) return [];

    try {
      final jsonString = _prefs!.getString(_conversationsKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      final conversations = jsonList
          .map((json) => ChatConversation.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('📂 [ChatLocalStorage] Loaded ${conversations.length} conversations');
      return conversations;
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Load conversations error: $e');
      return [];
    }
  }

  /// Update a single conversation in cache
  Future<void> updateConversation(ChatConversation conversation) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final conversations = await loadConversations();
      final index = conversations.indexWhere((c) => c.id == conversation.id);
      
      if (index != -1) {
        conversations[index] = conversation;
      } else {
        conversations.insert(0, conversation);
      }
      
      await saveConversations(conversations);
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Update conversation error: $e');
    }
  }

  // ============== MESSAGES ==============

  /// Save messages for a conversation
  Future<void> saveMessages(String conversationId, List<ChatMessage> messages) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      // Limit to maxMessagesPerConversation
      final toSave = messages.take(maxMessagesPerConversation).toList();
      final jsonList = toSave.map((m) => m.toJson()).toList();
      
      await _prefs!.setString(
        '$_messagesPrefix$conversationId',
        jsonEncode(jsonList),
      );
      
      debugPrint('💾 [ChatLocalStorage] Saved ${toSave.length} messages for $conversationId');
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Save messages error: $e');
    }
  }

  /// Load messages for a conversation
  Future<List<ChatMessage>> loadMessages(String conversationId) async {
    await _ensureInitialized();
    if (_prefs == null) return [];

    try {
      final jsonString = _prefs!.getString('$_messagesPrefix$conversationId');
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      final messages = jsonList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('📂 [ChatLocalStorage] Loaded ${messages.length} messages for $conversationId');
      return messages;
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Load messages error: $e');
      return [];
    }
  }

  /// Add a message to cache
  Future<void> addMessage(ChatMessage message) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final messages = await loadMessages(message.conversationId);
      
      // Check if exists
      final existingIndex = messages.indexWhere((m) => m.id == message.id);
      if (existingIndex != -1) {
        messages[existingIndex] = message;
      } else {
        messages.insert(0, message);
      }
      
      await saveMessages(message.conversationId, messages);
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Add message error: $e');
    }
  }

  /// Update message status
  Future<void> updateMessageStatus(
    String conversationId,
    String messageId, {
    bool? isDelivered,
    bool? isRead,
  }) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final messages = await loadMessages(conversationId);
      final index = messages.indexWhere((m) => m.id == messageId);
      
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          isDelivered: isDelivered ?? messages[index].isDelivered,
          isRead: isRead ?? messages[index].isRead,
        );
        await saveMessages(conversationId, messages);
      }
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Update message status error: $e');
    }
  }

  // ============== PENDING MESSAGES ==============

  /// Save a pending message (for offline sending)
  Future<void> savePendingMessage(ChatMessage message) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final pending = await getPendingMessages();
      pending.add(message);
      
      final jsonList = pending.map((m) => m.toJson()).toList();
      await _prefs!.setString(_pendingMessagesKey, jsonEncode(jsonList));
      
      debugPrint('💾 [ChatLocalStorage] Saved pending message: ${message.id}');
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Save pending message error: $e');
    }
  }

  /// Get all pending messages
  Future<List<ChatMessage>> getPendingMessages() async {
    await _ensureInitialized();
    if (_prefs == null) return [];

    try {
      final jsonString = _prefs!.getString(_pendingMessagesKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Get pending messages error: $e');
      return [];
    }
  }

  /// Remove a pending message
  Future<void> removePendingMessage(String messageId) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final pending = await getPendingMessages();
      pending.removeWhere((m) => m.id == messageId);
      
      final jsonList = pending.map((m) => m.toJson()).toList();
      await _prefs!.setString(_pendingMessagesKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Remove pending message error: $e');
    }
  }

  /// Clear all pending messages
  Future<void> clearPendingMessages() async {
    await _ensureInitialized();
    if (_prefs == null) return;
    
    await _prefs!.remove(_pendingMessagesKey);
  }

  // ============== DRAFT MESSAGES ==============

  /// Save draft message for a conversation
  Future<void> saveDraft(String conversationId, String text) async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final drafts = await _getDrafts();
      if (text.isEmpty) {
        drafts.remove(conversationId);
      } else {
        drafts[conversationId] = text;
      }
      
      await _prefs!.setString(_draftMessagesKey, jsonEncode(drafts));
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Save draft error: $e');
    }
  }

  /// Get draft message for a conversation
  Future<String?> getDraft(String conversationId) async {
    await _ensureInitialized();
    if (_prefs == null) return null;

    try {
      final drafts = await _getDrafts();
      return drafts[conversationId];
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Get draft error: $e');
      return null;
    }
  }

  Future<Map<String, String>> _getDrafts() async {
    try {
      final jsonString = _prefs!.getString(_draftMessagesKey);
      if (jsonString == null) return {};
      
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return {};
    }
  }

  // ============== SYNC & CLEANUP ==============

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    await _ensureInitialized();
    if (_prefs == null) return null;

    try {
      final timeString = _prefs!.getString(_lastSyncKey);
      if (timeString == null) return null;
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Check if cache is stale
  Future<bool> isCacheStale() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;
    
    return DateTime.now().difference(lastSync) > cacheExpiry;
  }

  /// Clean expired cache
  Future<void> _cleanExpiredCache() async {
    if (_prefs == null) return;

    try {
      final lastSync = await getLastSyncTime();
      if (lastSync != null && DateTime.now().difference(lastSync) > cacheExpiry) {
        await clearAllCache();
        debugPrint('🧹 [ChatLocalStorage] Cleared expired cache');
      }
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Clean cache error: $e');
    }
  }

  /// Clear all conversation messages cache
  Future<void> clearConversationCache(String conversationId) async {
    await _ensureInitialized();
    if (_prefs == null) return;
    
    await _prefs!.remove('$_messagesPrefix$conversationId');
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    await _ensureInitialized();
    if (_prefs == null) return;

    try {
      final keys = _prefs!.getKeys();
      for (final key in keys) {
        if (key.startsWith('chat_')) {
          await _prefs!.remove(key);
        }
      }
      debugPrint('🧹 [ChatLocalStorage] Cleared all chat cache');
    } catch (e) {
      debugPrint('❌ [ChatLocalStorage] Clear all cache error: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    await _ensureInitialized();
    if (_prefs == null) return {};

    try {
      final conversations = await loadConversations();
      final pending = await getPendingMessages();
      final lastSync = await getLastSyncTime();
      
      return {
        'conversationsCount': conversations.length,
        'pendingMessagesCount': pending.length,
        'lastSync': lastSync?.toIso8601String(),
        'isStale': await isCacheStale(),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
