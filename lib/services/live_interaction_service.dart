import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'server_config_service.dart';
import 'secure_token_manager.dart';

class LiveInteractionService {
  static final LiveInteractionService _instance = LiveInteractionService._internal();
  factory LiveInteractionService() => _instance;
  LiveInteractionService._internal();

  IO.Socket? _socket;
  final _serverConfigService = ServerConfigService();
  final _tokenManager = SecureTokenManager.instance;

  // Observable state could be managed via streams or callbacks
  // For simplicity, we expose streams for events
  final _questionStreamController = ValueNotifier<List<dynamic>>([]); // Simpler than StreamController for now? No, better use StreamController usually.
  
  // Using callbacks for simplicity in MVP or expose Streams via getters
  Function(dynamic)? onNewQuestion;
  Function(dynamic)? onQuestionApproved;
  Function(dynamic)? onPollLive;
  Function(dynamic)? onPollResults;

  Future<void> connect(String sessionId) async {
    final config = await _serverConfigService.getServerConfig();
    final token = await _tokenManager.getValidAccessToken();

    if (token == null) {
      debugPrint('LiveInteractionService: No token found');
      return;
    }

    final url = config.fullUrl; // e.g. https://api.idec-ye.com
    // Namespace is /live
    final socketUrl = '$url/live';
    
    debugPrint('Connecting to Socket.io: $socketUrl');

    _socket = IO.io(socketUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect() // Connect manually
      .setAuth({'token': token})
      // .setExtraHeaders({'Authorization': 'Bearer $token'}) // Some setups use this
      .build()
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('Socket connected');
      joinSession(sessionId);
    });

    _socket!.onDisconnect((_) => debugPrint('Socket disconnected'));
    _socket!.onConnectError((data) => debugPrint('Socket connection error: $data'));
    _socket!.onError((data) => debugPrint('Socket error: $data'));

    // Listeners
    _socket!.on('question:published', (data) {
       onQuestionApproved?.call(data);
    });

    _socket!.on('poll:live', (data) {
       onPollLive?.call(data);
    });

    _socket!.on('poll:results', (data) {
       onPollResults?.call(data);
    });
  }

  void joinSession(String sessionId) {
    _socket?.emit('joinSession', {'sessionId': sessionId, 'userId': 'TODO_GET_USER_ID'}); 
    // UserId might be extracted from token on server, but good to send if protocol requires
  }

  void leaveSession(String sessionId) {
    _socket?.emit('leaveSession', {'sessionId': sessionId});
    _socket?.disconnect();
  }

  void askQuestion(String sessionId, String content, String userId) {
    _socket?.emit('question:ask', {
      'sessionId': sessionId,
      'content': content,
      'userId': userId
    });
  }

  void votePoll(String sessionId, String pollId, String? optionId, String? textValue, String userId) {
    _socket?.emit('poll:vote', {
      'sessionId': sessionId,
      'pollId': pollId,
      'optionId': optionId,
      'userId': userId
    });
  }
}
