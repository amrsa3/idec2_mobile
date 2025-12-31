# 📱 IDEC Chat Module - Flutter Implementation

## 🎯 Overview

This is a professional, feature-rich chat module for the IDEC Mobile App, implementing the Unified Communication Hub's frontend.

## 📁 Directory Structure

```
lib/features/chat/
├── chat.dart                 # Main export file
├── chat_page.dart           # Main entry point page
├── core/
│   └── chat_constants.dart  # Themes, strings, config
├── data/
│   ├── models/
│   │   ├── chat_enums.dart        # Enums
│   │   ├── conversation_model.dart # Conversation model
│   │   ├── message_model.dart      # Message model
│   │   └── participant_model.dart  # Participant model
│   ├── repositories/
│   │   └── chat_repository.dart    # Data repository
│   └── services/
│       ├── chat_api_service.dart   # REST API service
│       └── chat_socket_service.dart # WebSocket service
└── presentation/
    ├── providers/
    │   └── chat_provider.dart      # State management
    ├── screens/
    │   ├── conversations_screen.dart # Conversations list
    │   ├── chat_screen.dart          # Chat detail
    │   └── new_conversation_screen.dart # New conversation
    └── widgets/
        ├── conversation_tile.dart    # Conversation card
        ├── message_bubble.dart       # Message bubble
        ├── chat_input.dart          # Input widget
        └── typing_indicator.dart    # Typing indicator
```

## 🚀 Quick Start

### 1. Add to pubspec.yaml
```yaml
dependencies:
  socket_io_client: ^2.0.3+1
```

### 2. Import the module
```dart
import 'package:idec_conference_app/features/chat/chat_page.dart';
```

### 3. Use in your app
```dart
ChatPage(
  baseUrl: 'https://your-api-url.com',
  getToken: () => authService.getAccessToken(),
  userId: currentUser.id,
)
```

## 🎨 Features

### Conversation Types
| Type | Icon | Color | Description |
|------|------|-------|-------------|
| Marketplace | 🛒 | Green | Vendor-Customer chat |
| Support | 🛠️ | Orange | Technical support tickets |
| Event | 🎤 | Blue | Conference/event queries |
| Group | 👥 | Purple | Group conversations |
| Broadcast | 📢 | Pink | Announcement channels |

### Message Types
- ✅ Text messages
- ✅ Image messages
- ✅ File attachments
- ✅ Audio messages
- ✅ Location sharing
- ✅ Product cards
- ✅ Quote cards
- ✅ Invoice cards
- ✅ System messages
- ✅ Quick reply actions

### Real-time Features
- ✅ WebSocket connection
- ✅ Typing indicators
- ✅ Online/offline status
- ✅ Read receipts
- ✅ Message delivery status
- ✅ Auto-reconnection

## 🔧 Configuration

### ChatConfig Constants
```dart
class ChatConfig {
  static const int messagesPerPage = 50;
  static const int conversationsPerPage = 20;
  static const int reconnectAttempts = 5;
  static const Duration typingTimeout = Duration(seconds: 3);
  static const double maxBubbleWidth = 0.75;
}
```

### Theme Colors
```dart
class ChatTheme {
  static const Color marketplaceColor = Color(0xFF10B981);
  static const Color supportColor = Color(0xFFF59E0B);
  static const Color eventColor = Color(0xFF3B82F6);
  static const Color groupColor = Color(0xFF8B5CF6);
  static const Color broadcastColor = Color(0xFFEC4899);
}
```

## 📡 API Integration

### REST Endpoints Used
```
GET    /api/v1/chat/conversations
GET    /api/v1/chat/conversations/:id
POST   /api/v1/chat/conversations
GET    /api/v1/chat/conversations/:id/messages
POST   /api/v1/chat/messages
POST   /api/v1/chat/conversations/:id/read
GET    /api/v1/chat/unread-count
GET    /api/v1/chat/ai/suggestions
```

### WebSocket Events
```
// Emit
join       - Join conversation room
leave      - Leave conversation room
message    - Send message
typing     - Typing indicator
read       - Mark as read
heartbeat  - Keep alive

// Listen
newMessage        - New message received
userTyping        - User typing
messageRead       - Messages read
userPresence      - Online/offline
conversationUpdated - Conversation updated
```

## 🎭 State Management

Using `ChangeNotifier` with `ListenableBuilder`:

```dart
class ChatProvider extends ChangeNotifier {
  ChatLoadingState _state = ChatLoadingState.initial;
  List<ChatConversation> _conversations = [];
  
  Future<void> loadConversations() async {
    _state = ChatLoadingState.loading;
    notifyListeners();
    
    try {
      await repository.loadConversations();
      _state = ChatLoadingState.loaded;
    } catch (e) {
      _state = ChatLoadingState.error;
    }
    
    notifyListeners();
  }
}
```

## 🎨 UI Components

### ConversationTile
Beautiful card with:
- Gradient avatar with context color
- Online indicator
- Context type badge
- Unread count badge
- Formatted last message time

### MessageBubble
Features:
- Sent/received styling
- Read receipts (single ✓, double ✓✓, blue ✓✓)
- Reply preview
- Context cards (product, quote, etc.)
- Quick action buttons

### ChatInput
Features:
- Auto-expanding text field
- Attachment button
- Voice recording button
- Send button with animation
- Reply preview
- Suggested replies

## 🧪 Testing

Run tests:
```bash
cd mobile-app
flutter test test/chat/
```

Test files:
- `chat_models_test.dart` - Model unit tests

## 📝 Arabic Strings

All UI strings are in Arabic:
```dart
class ChatStrings {
  static const String conversations = 'المحادثات';
  static const String newConversation = 'محادثة جديدة';
  static const String typeMessage = 'اكتب رسالتك...';
  static const String typing = 'يكتب...';
  static const String online = 'متصل';
  // ...
}
```

## 🔒 Security

- JWT token authentication
- Secure WebSocket connection
- Token refresh on expiry
- User presence management

## 📱 Screenshots

The chat module features:
- Modern glassmorphism design
- Gradient accents
- Smooth animations
- RTL support for Arabic
- Dark mode compatible

## 🚧 Future Improvements

- [ ] Voice message recording
- [ ] Image compression before upload
- [ ] Message search
- [ ] Message reactions
- [ ] Message forwarding
- [ ] Chat export
- [ ] Push notification integration

---

*Built with ❤️ for IDEC Digital Ecosystem*
