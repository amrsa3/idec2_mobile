import 'package:flutter/material.dart';
import 'dart:async';
import 'data/models/conversation_model.dart';
import 'data/models/chat_enums.dart';
import 'data/repositories/chat_repository.dart';
import 'data/services/chat_api_service.dart';
import 'data/services/chat_socket_service.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/screens/conversations_screen.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/new_conversation_screen.dart';

/// Chat Page
/// Main entry point for the chat feature
class ChatPage extends StatefulWidget {
  final String baseUrl;
  final String Function() getToken;
  final String userId;
  final ChatConversationType? initialFilter;

  const ChatPage({
    super.key,
    required this.baseUrl,
    required this.getToken,
    required this.userId,
    this.initialFilter,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  late ChatApiService _apiService;
  late ChatSocketService _socketService;
  late ChatRepository _repository;
  late ChatProvider _provider;

  bool _isInitialized = false;
  bool _isConnected = false;
  bool _showReconnecting = false; // تأخير إظهار شريط إعادة الاتصال
  Timer? _reconnectingTimer;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // Initialize services
    _apiService = ChatApiService(
      baseUrl: widget.baseUrl,
      getToken: widget.getToken,
    );
    
    _socketService = ChatSocketService.instance;

    _repository = ChatRepository(
      apiService: _apiService,
      socketService: _socketService,
      userId: widget.userId,
    );

    _provider = ChatProvider(repository: _repository);

    // Connect to socket
    await _socketService.connect(
      baseUrl: widget.baseUrl,
      token: widget.getToken(),
      userId: widget.userId,
    );

    // Listen to connection state with delay for reconnecting indicator
    _connectionSubscription = _socketService.connectionState.listen((connected) {
      if (mounted) {
        _isConnected = connected;
        
        // If connected, hide reconnecting immediately
        if (connected) {
          _reconnectingTimer?.cancel();
          setState(() => _showReconnecting = false);
        } else {
          // If disconnected, show reconnecting after 2 seconds delay
          // This prevents flickering on brief disconnections
          _reconnectingTimer?.cancel();
          _reconnectingTimer = Timer(const Duration(seconds: 2), () {
            if (mounted && !_isConnected) {
              setState(() => _showReconnecting = true);
            }
          });
        }
      }
    });
    
    // Get initial connection state
    _isConnected = _socketService.isConnected;

    // Load conversations
    await _provider.loadConversations(type: widget.initialFilter);

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reconnect when app comes to foreground
      if (!_isConnected) {
        _socketService.connect(
          baseUrl: widget.baseUrl,
          token: widget.getToken(),
          userId: widget.userId,
        );
      }
      _provider.refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reconnectingTimer?.cancel();
    _connectionSubscription?.cancel();
    _provider.dispose();
    // Don't dispose socket here as it might be used elsewhere
    super.dispose();
  }

  void _openConversation(ChatConversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatDetailPage(
          conversationId: conversation.id,
          repository: _repository,
        ),
      ),
    ).then((_) {
      // Refresh conversations when returning
      _provider.refresh();
    });
  }

  void _openNewConversation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewConversationScreen(
          onCreateConversation: ({
            required type,
            required recipientId,
            subject,
            productId,
            initialMessage,
          }) async {
            final conversation = await _provider.createConversation(
              type: type,
              recipientId: recipientId,
              subject: subject,
              productId: productId,
              initialMessage: initialMessage,
            );
            
            if (conversation != null && mounted) {
              Navigator.pop(context);
              _openConversation(conversation);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل المحادثات...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) {
        return Column(
          children: [
            // Connection status - only show after delay
            if (_showReconnecting)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.orange.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'جاري إعادة الاتصال...',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

            // Conversations
            Expanded(
              child: ConversationsScreen(
                conversations: _provider.conversations,
                isLoading: _provider.state == ChatLoadingState.loading,
                error: _provider.error,
                unreadCount: _provider.totalUnreadCount,
                onRefresh: () => _provider.refresh(),
                onConversationTap: _openConversation,
                onNewConversation: _openNewConversation,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Chat Detail Page (internal)
class _ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final ChatRepository repository;

  const _ChatDetailPage({
    required this.conversationId,
    required this.repository,
  });

  @override
  State<_ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<_ChatDetailPage> {
  late ConversationProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ConversationProvider(
      repository: widget.repository,
      conversationId: widget.conversationId,
    );
    _provider.load();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) {
        return ChatScreen(
          conversation: _provider.conversation,
          messages: _provider.messages,
          isLoading: _provider.state == ChatLoadingState.loading,
          isTyping: _provider.isTyping,
          typingUsers: _provider.typingUsers,
          suggestedReplies: _provider.suggestedReplies,
          onSendMessage: (message) => _provider.sendMessage(message),
          onLoadMore: _provider.loadMoreMessages,
          onTypingChanged: _provider.setTyping,
          onAttachmentTap: () => _showAttachmentOptions(context),
        );
      },
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.image, color: Colors.blue.shade700),
              ),
              title: const Text('صورة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.insert_drive_file, color: Colors.orange.shade700),
              ),
              title: const Text('ملف'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: Colors.green.shade700),
              ),
              title: const Text('الكاميرا'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: Colors.red.shade700),
              ),
              title: const Text('الموقع'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
