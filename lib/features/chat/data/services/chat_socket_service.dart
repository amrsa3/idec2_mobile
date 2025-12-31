import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';
import '../models/conversation_model.dart';

/// Chat Socket Service
/// Handles real-time WebSocket connection for chat
class ChatSocketService {
  static ChatSocketService? _instance;
  static ChatSocketService get instance => _instance ??= ChatSocketService._();
  
  ChatSocketService._();

  IO.Socket? _socket;
  String? _currentUserId;
  bool _isConnected = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  // Stream Controllers
  final _connectionStateController = StreamController<bool>.broadcast();
  final _newMessageController = StreamController<ChatMessage>.broadcast();
  final _typingController = StreamController<TypingEvent>.broadcast();
  final _messageReadController = StreamController<MessageReadEvent>.broadcast();
  final _userPresenceController = StreamController<UserPresenceEvent>.broadcast();
  final _conversationUpdatedController = StreamController<ChatConversation>.broadcast();
  final _messageDeliveredController = StreamController<MessageStatusEvent>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  
  // Callback for when connection is restored
  VoidCallback? onConnectionRestored;

  // Streams
  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<ChatMessage> get onNewMessage => _newMessageController.stream;
  Stream<TypingEvent> get onTyping => _typingController.stream;
  Stream<MessageReadEvent> get onMessageRead => _messageReadController.stream;
  Stream<UserPresenceEvent> get onUserPresence => _userPresenceController.stream;
  Stream<ChatConversation> get onConversationUpdated => _conversationUpdatedController.stream;
  Stream<MessageStatusEvent> get onMessageDelivered => _messageDeliveredController.stream;
  Stream<String> get onError => _errorController.stream;

  bool get isConnected => _isConnected;

  /// Initialize and connect to the chat server
  Future<void> connect({
    required String baseUrl,
    required String token,
    required String userId,
  }) async {
    if (_isConnecting || _isConnected) {
      debugPrint('📱 [ChatSocket] Already connected or connecting');
      return;
    }

    _isConnecting = true;
    _currentUserId = userId;
    _reconnectAttempts = 0;

    try {
      // Clean base URL (remove /api/v1 suffix if exists)
      String socketUrl = baseUrl.replaceAll('/api/v1', '');
      if (socketUrl.endsWith('/')) {
        socketUrl = socketUrl.substring(0, socketUrl.length - 1);
      }
      
      // Append chat namespace
      socketUrl = '$socketUrl/chat';
      
      debugPrint('📱 [ChatSocket] Connecting to $socketUrl...');

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(10000)
            .build(),
      );

      _setupListeners();
      _socket?.connect();
    } catch (e) {
      debugPrint('❌ [ChatSocket] Connection error: $e');
      _isConnecting = false;
      _errorController.add('فشل الاتصال بالخادم');
      _scheduleReconnect();
    }
  }

  void _setupListeners() {
    _socket?.onConnect((_) {
      debugPrint('✅ [ChatSocket] Connected successfully');
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;
      _connectionStateController.add(true);
      _startHeartbeat();
      
      // Notify about connection restoration for pending messages
      onConnectionRestored?.call();
    });

    _socket?.onDisconnect((_) {
      debugPrint('❌ [ChatSocket] Disconnected');
      _isConnected = false;
      _connectionStateController.add(false);
      _stopHeartbeat();
      _scheduleReconnect();
    });

    _socket?.onConnectError((error) {
      debugPrint('⚠️ [ChatSocket] Connection error: $error');
      _isConnecting = false;
      _errorController.add('خطأ في الاتصال');
    });

    _socket?.onError((error) {
      debugPrint('⚠️ [ChatSocket] Error: $error');
      _errorController.add('حدث خطأ');
    });

    // Message Events
    // Message Events
    _socket?.on('message:new', (data) {
      try {
        final message = ChatMessage.fromJson(data);
        debugPrint('📩 [ChatSocket] New message: ${message.content}');
        _newMessageController.add(message);
        
        // Acknowledge delivery if message is not from me
        if (message.senderId != _currentUserId) {
          _socket?.emit('message:delivered', {'messageId': message.id});
        }
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing message: $e');
      }
    });

    _socket?.on('typing:start', (data) {
        _handleTypingEvent(data, true);
    });

    _socket?.on('typing:stop', (data) {
        _handleTypingEvent(data, false);
    });

    _socket?.on('message:read', (data) {
      try {
        debugPrint('📖 [ChatSocket] Read event received: $data');
        final event = MessageReadEvent.fromJson(data);
        _messageReadController.add(event);
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing read event: $e');
      }
    });

    _socket?.on('message:delivered', (data) {
      try {
        final event = MessageStatusEvent.fromJson(data);
        _messageDeliveredController.add(event);
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing delivered event: $e');
      }
    });

    _socket?.on('presence:changed', (data) {
      try {
        final event = UserPresenceEvent.fromJson(data);
        _userPresenceController.add(event);
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing presence event: $e');
      }
    });

    _socket?.on('conversation:updated', (data) {
      try {
        final conversation = ChatConversation.fromJson(data);
        _conversationUpdatedController.add(conversation);
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing conversation update: $e');
      }
    });

    // ... (Reconnection logic remains same)
    _socket?.on('reconnect', (_) {
      debugPrint('🔄 [ChatSocket] Reconnected');
      _connectionStateController.add(true);
    });

    _socket?.on('reconnect_attempt', (attempt) {
      debugPrint('🔄 [ChatSocket] Reconnection attempt: $attempt');
    });
  }

  void _handleTypingEvent(dynamic data, bool isTyping) {
      try {
        // Gateway sends { conversationId, userId }
        // We need to map it to TypingEvent
        final conversationId = data['conversationId'];
        final userId = data['userId'];
        
        if (conversationId != null && userId != null) {
            final event = TypingEvent(
                conversationId: conversationId,
                userId: userId,
                isTyping: isTyping,
            );
            _typingController.add(event);
        }
      } catch (e) {
        debugPrint('❌ [ChatSocket] Error parsing typing event: $e');
      }
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) {
        _socket?.emit('heartbeat', {'userId': _currentUserId});
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    if (_reconnectAttempts < _maxReconnectAttempts) {
      final delay = Duration(seconds: (_reconnectAttempts + 1) * 2);
      _reconnectTimer = Timer(delay, () {
        _reconnectAttempts++;
        debugPrint('🔄 [ChatSocket] Attempting reconnect $_reconnectAttempts/$_maxReconnectAttempts');
        _socket?.connect();
      });
    }
  }

  /// Join a conversation room
  void joinConversation(String conversationId) {
    if (!_isConnected) return;
    debugPrint('🚪 [ChatSocket] Joining conversation: $conversationId');
    _socket?.emit('conversation:join', {'conversationId': conversationId});
  }

  /// Leave a conversation room
  void leaveConversation(String conversationId) {
    if (!_isConnected) return;
    debugPrint('🚪 [ChatSocket] Leaving conversation: $conversationId');
    _socket?.emit('conversation:leave', {'conversationId': conversationId});
  }

  /// Send a message (Socket fallback, mainly used REST API)
  void sendMessage({
    required String conversationId,
    required String content,
    String type = 'TEXT',
    Map<String, dynamic>? attachments,
    String? replyToId,
  }) {
    if (!_isConnected) {
      _errorController.add('لا يوجد اتصال بالخادم');
      return;
    }

    _socket?.emit('message:send', {
      'conversationId': conversationId,
      'content': content,
      'type': type,
      if (attachments != null) 'attachments': attachments,
      if (replyToId != null) 'replyToId': replyToId,
    });
  }

  /// Set typing status
  void setTyping(String conversationId, bool isTyping) {
    if (!_isConnected) return;
    _socket?.emit(isTyping ? 'typing:start' : 'typing:stop', {
      'conversationId': conversationId,
    });
  }

  /// Mark messages as read
  void markAsRead(String conversationId, List<String> messageIds) {
    if (!_isConnected) return;
    _socket?.emit('message:read', {
      'conversationId': conversationId,
      'messageIds': messageIds,
    });
  }

  /// Disconnect from the server
  void disconnect() {
    debugPrint('📱 [ChatSocket] Disconnecting...');
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _isConnecting = false;
    _connectionStateController.add(false);
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _connectionStateController.close();
    _newMessageController.close();
    _typingController.close();
    _messageReadController.close();
    _userPresenceController.close();
    _conversationUpdatedController.close();
    _messageDeliveredController.close();
    _errorController.close();
    _instance = null;
  }
}

/// Typing Event
class TypingEvent {
  final String conversationId;
  final String userId;
  final String? userName;
  final bool isTyping;

  TypingEvent({
    required this.conversationId,
    required this.userId,
    this.userName,
    required this.isTyping,
  });

  factory TypingEvent.fromJson(Map<String, dynamic> json) {
    return TypingEvent(
      conversationId: json['conversationId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'],
      isTyping: json['isTyping'] ?? false,
    );
  }
}

/// Message Read Event
class MessageReadEvent {
  final String conversationId;
  final List<String> messageIds;
  final String readBy;
  final DateTime readAt;

  MessageReadEvent({
    required this.conversationId,
    required this.messageIds,
    required this.readBy,
    required this.readAt,
  });

  factory MessageReadEvent.fromJson(Map<String, dynamic> json) {
    return MessageReadEvent(
      conversationId: json['conversationId'] ?? '',
      messageIds: List<String>.from(json['messageIds'] ?? []),
      readBy: json['readBy'] ?? '',
      readAt: json['readAt'] != null 
          ? DateTime.parse(json['readAt']) 
          : DateTime.now(),
    );
  }
}

/// User Presence Event
class UserPresenceEvent {
  final String userId;
  final bool isOnline;
  final DateTime? lastSeenAt;

  UserPresenceEvent({
    required this.userId,
    required this.isOnline,
    this.lastSeenAt,
  });

  factory UserPresenceEvent.fromJson(Map<String, dynamic> json) {
    return UserPresenceEvent(
      userId: json['userId'] ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeenAt: json['lastSeenAt'] != null 
          ? DateTime.parse(json['lastSeenAt']) 
          : null,
    );
  }
}

/// Message Status Event (Delivered)
class MessageStatusEvent {
  final String messageId;
  final String conversationId;
  final DateTime timestamp;

  MessageStatusEvent({
    required this.messageId,
    required this.conversationId,
    required this.timestamp,
  });

  factory MessageStatusEvent.fromJson(Map<String, dynamic> json) {
    return MessageStatusEvent(
      messageId: json['messageId'] ?? '',
      conversationId: json['conversationId'] ?? '', // Backend needs to send this!
      timestamp: json['deliveredAt'] != null 
          ? DateTime.parse(json['deliveredAt']) 
          : DateTime.now(),
    );
  }
}
