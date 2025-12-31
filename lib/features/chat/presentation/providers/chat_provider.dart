import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_enums.dart';
import '../../data/repositories/chat_repository.dart';

/// Chat State
enum ChatLoadingState { initial, loading, loaded, error }

/// Conversations Provider
/// Manages the list of conversations
class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;

  ChatProvider({required this.repository}) {
    _init();
  }

  // State
  ChatLoadingState _state = ChatLoadingState.initial;
  List<ChatConversation> _conversations = [];
  String? _error;
  int _totalUnreadCount = 0;
  ChatConversationType? _currentFilter;

  // Getters
  ChatLoadingState get state => _state;
  List<ChatConversation> get conversations => _conversations;
  String? get error => _error;
  int get totalUnreadCount => _totalUnreadCount;
  ChatConversationType? get currentFilter => _currentFilter;

  // Subscriptions
  StreamSubscription? _conversationsSubscription;
  bool _isDisposed = false;

  void _init() {
    _conversationsSubscription = repository.conversationsStream.listen((conversations) {
      if (!_isDisposed) {
        _conversations = conversations;
        _updateUnreadCount();
        notifyListeners();
      }
    });
  }

  void _updateUnreadCount() {
    _totalUnreadCount = _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Load conversations
  Future<void> loadConversations({
    ChatConversationType? type,
    bool refresh = false,
  }) async {
    if (_state == ChatLoadingState.loading) return;

    _state = ChatLoadingState.loading;
    _error = null;
    _currentFilter = type;
    notifyListeners();

    try {
      await repository.loadConversations(
        type: type,
        refresh: refresh,
      );
      _state = ChatLoadingState.loaded;
    } catch (e) {
      _state = ChatLoadingState.error;
      _error = 'فشل تحميل المحادثات';
      debugPrint('❌ [ChatProvider] Load error: $e');
    }

    if (!_isDisposed) notifyListeners();
  }

  /// Refresh conversations
  Future<void> refresh() async {
    await loadConversations(type: _currentFilter, refresh: true);
  }

  /// Filter conversations by type
  List<ChatConversation> getFilteredConversations(ChatConversationType? type) {
    if (type == null) return _conversations;
    return _conversations.where((c) => c.type == type).toList();
  }

  /// Get conversation by ID
  ChatConversation? getConversationById(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create new conversation
  Future<ChatConversation?> createConversation({
    required ChatConversationType type,
    required String recipientId,
    String? subject,
    String? productId,
    String? initialMessage,
  }) async {
    try {
      final conversation = await repository.createConversation(
        type: type,
        recipientId: recipientId,
        subject: subject,
        productId: productId,
        initialMessage: initialMessage,
      );
      return conversation;
    } catch (e) {
      _error = 'فشل إنشاء المحادثة';
      notifyListeners();
      return null;
    }
  }

  /// Get unread count by type
  int getUnreadCountByType(ChatConversationType type) {
    return _conversations
        .where((c) => c.type == type)
        .fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Mark conversation as read locally
  void markConversationAsReadLocally(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
      _updateUnreadCount();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _conversationsSubscription?.cancel();
    super.dispose();
  }
}

/// Conversation Detail Provider
/// Manages a single conversation and its messages
class ConversationProvider extends ChangeNotifier {
  final ChatRepository repository;
  final String conversationId;

  ConversationProvider({
    required this.repository,
    required this.conversationId,
  }) {
    _init();
  }

  // State
  ChatLoadingState _state = ChatLoadingState.initial;
  ChatConversation? _conversation;
  List<ChatMessage> _messages = [];
  String? _error;
  bool _isTyping = false;
  Set<String> _typingUsers = {};
  bool _hasMoreMessages = true;
  List<String> _suggestedReplies = [];

  // Getters
  ChatLoadingState get state => _state;
  ChatConversation? get conversation => _conversation;
  List<ChatMessage> get messages => _messages;
  String? get error => _error;
  bool get isTyping => _typingUsers.isNotEmpty;
  Set<String> get typingUsers => _typingUsers;
  bool get hasMoreMessages => _hasMoreMessages;
  List<String> get suggestedReplies => _suggestedReplies;

  // Subscriptions
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;
  bool _isDisposed = false;
  Timer? _typingTimer;

  void _init() {
    // Join conversation room
    repository.joinConversation(conversationId);

    // Listen for messages
    _messagesSubscription = repository.messagesStream.listen((messagesMap) {
      if (!_isDisposed && messagesMap.containsKey(conversationId)) {
        _messages = List.from(messagesMap[conversationId]!);
        notifyListeners();
      }
    });

    // Listen for typing events
    _typingSubscription = repository.socketService.onTyping.listen((event) {
      if (!_isDisposed && event.conversationId == conversationId) {
        if (event.isTyping) {
          _typingUsers.add(event.userId);
        } else {
          _typingUsers.remove(event.userId);
        }
        notifyListeners();
      }
    });
  }

  /// Load conversation and messages
  Future<void> load() async {
    if (_state == ChatLoadingState.loading) return;

    _state = ChatLoadingState.loading;
    _error = null;
    notifyListeners();

    try {
      _conversation = await repository.getConversation(conversationId);
      _messages = List.from(repository.getCachedMessages(conversationId));
      
      if (_messages.isEmpty) {
        await loadMoreMessages();
      }

      // Mark as read
      await repository.markAsRead(conversationId);

      _state = ChatLoadingState.loaded;
    } catch (e) {
      _state = ChatLoadingState.error;
      _error = 'فشل تحميل المحادثة';
      debugPrint('❌ [ConversationProvider] Load error: $e');
    }

    if (!_isDisposed) notifyListeners();
  }

  /// Load more messages (pagination)
  Future<void> loadMoreMessages() async {
    if (!_hasMoreMessages) return;

    try {
      final before = _messages.isNotEmpty ? _messages.last.id : null;
      final newMessages = await repository.loadMessages(
        conversationId,
        before: before,
      );

      if (newMessages.length < 50) {
        _hasMoreMessages = false;
      }

      _messages = List.from(repository.getCachedMessages(conversationId));
      if (!_isDisposed) notifyListeners();
    } catch (e) {
      debugPrint('❌ [ConversationProvider] Load more error: $e');
    }
  }

  /// Send a message
  Future<bool> sendMessage(String content, {ChatMessageType type = ChatMessageType.text}) async {
    if (content.trim().isEmpty) return false;

    try {
      await repository.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
      );

      // Clear suggestions after sending
      _suggestedReplies = [];
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'فشل إرسال الرسالة';
      notifyListeners();
      return false;
    }
  }

  /// Set typing indicator
  void setTyping(bool isTyping) {
    _isTyping = isTyping;
    repository.setTyping(conversationId, isTyping);

    // Auto-clear typing after 3 seconds
    _typingTimer?.cancel();
    if (isTyping) {
      _typingTimer = Timer(const Duration(seconds: 3), () {
        setTyping(false);
      });
    }
  }

  /// Load suggested replies
  Future<void> loadSuggestions() async {
    if (_messages.isEmpty) return;

    final lastMessage = _messages.first;
    if (lastMessage.isFromMe) return;

    try {
      _suggestedReplies = await repository.getSuggestedReplies(
        conversationId,
        lastMessage.content,
      );
      if (!_isDisposed) notifyListeners();
    } catch (e) {
      debugPrint('❌ [ConversationProvider] Load suggestions error: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _typingTimer?.cancel();
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    repository.leaveConversation(conversationId);
    super.dispose();
  }
}
