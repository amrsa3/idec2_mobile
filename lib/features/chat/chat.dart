/// Chat Hub Feature Entry Point
/// Unified Communication Hub for IDEC Platform
///
/// This module provides:
/// - Marketplace Chat (Vendor ↔ Customer)
/// - Support Tickets
/// - Event Concierge
/// - Group Chats & Broadcast

library chat;

// Models
export 'data/models/conversation_model.dart';
export 'data/models/message_model.dart';
export 'data/models/participant_model.dart';
export 'data/models/chat_enums.dart';

// Core
export 'core/chat_helpers.dart';
export 'core/chat_constants.dart';

// Repositories
export 'data/repositories/chat_repository.dart';

// Services
export 'data/services/chat_socket_service.dart';
export 'data/services/chat_api_service.dart';
export 'data/services/chat_local_storage.dart';
export 'data/services/chat_connection_manager.dart';

// Providers
export 'presentation/providers/chat_provider.dart';
export 'presentation/providers/conversation_provider.dart';

// Screens
export 'presentation/screens/conversations_screen.dart';
export 'presentation/screens/chat_screen.dart';
export 'presentation/screens/new_conversation_screen.dart';

// Widgets
export 'presentation/widgets/conversation_tile.dart';
export 'presentation/widgets/message_bubble.dart';
export 'presentation/widgets/chat_input.dart';
export 'presentation/widgets/typing_indicator.dart';
export 'presentation/widgets/connection_status_indicator.dart';
