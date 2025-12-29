import 'package:flutter/material.dart';
import '../../../../core/utils/enhanced_image_manager.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/chat_enums.dart';
import '../../core/chat_helpers.dart';

/// Conversation Tile Widget
/// Beautiful card for displaying a conversation in the list
class ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = conversation.unreadCount > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected 
            ? theme.primaryColor.withOpacity(0.1)
            : hasUnread 
                ? _getContextColor(conversation.type).withOpacity(0.05)
                : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
              ? theme.primaryColor 
              : hasUnread
                  ? _getContextColor(conversation.type).withOpacity(0.3)
                  : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with online indicator
                _buildAvatar(),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and time row
                      Row(
                        children: [
                          // Name (with user avatar initial if available)
                          Expanded(
                            child: Row(
                              children: [
                                // Context badge
                                _buildContextBadge(),
                                const SizedBox(width: 6),
                                // Name
                                Expanded(
                                  child: Text(
                                    _getParticipantName(),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                                      color: hasUnread ? theme.colorScheme.onSurface : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Time
                          Text(
                            conversation.formattedLastMessageTime,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: hasUnread 
                                  ? _getContextColor(conversation.type)
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Last message and unread count row
                      Row(
                        children: [
                          // Delivery status for my messages
                          if (conversation.lastMessage?.isFromMe == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: _buildDeliveryStatus(),
                            ),
                          
                          // Last message
                          Expanded(
                            child: Text(
                              _getLastMessageText(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: hasUnread 
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Unread badge
                          if (hasUnread) ...[
                            const SizedBox(width: 12),
                            _buildUnreadBadge(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get participant name using shared helper
  String _getParticipantName() => ChatHelpers.getDisplayName(conversation);

  /// Build delivery status icon for sent messages
  Widget _buildDeliveryStatus() {
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null) return const SizedBox.shrink();
    
    return Icon(
      ChatHelpers.getStatusIcon(
        isRead: lastMessage.isRead,
        isDelivered: lastMessage.isDelivered,
      ),
      size: 16,
      color: ChatHelpers.getStatusColor(
        isRead: lastMessage.isRead,
        isDelivered: lastMessage.isDelivered,
      ),
    );
  }

  Widget _buildAvatar() {
    // Get avatar URL from multiple sources
    String? avatarUrl = conversation.displayAvatar ?? 
                        conversation.otherParticipant?.userAvatar;
    
    final participantName = _getParticipantName();
    final contextColor = _getContextColor(conversation.type);
    
    return Stack(
      children: [
        // Use enhanced image manager for better caching and error handling
        imageManager.buildGradientAvatar(
          imageUrl: avatarUrl,
          name: participantName,
          size: 56,
          gradientColors: [
            contextColor,
            contextColor.withOpacity(0.7),
          ],
          borderRadius: BorderRadius.circular(16),
        ),

        // Online indicator
        if (conversation.otherParticipant?.isOnline == true)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback([String? letter]) {
    return Center(
      child: Text(
        letter ?? '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _buildContextBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getContextColor(conversation.type).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        conversation.type.displayNameAr,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _getContextColor(conversation.type),
        ),
      ),
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getContextColor(conversation.type),
            _getContextColor(conversation.type).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getContextColor(conversation.type).withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        conversation.unreadCount > 99 ? '99+' : conversation.unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getLastMessageText() {
    final lastMessage = conversation.lastMessage;
    if (lastMessage == null) {
      return 'لا توجد رسائل بعد';
    }

    String prefix = '';
    if (lastMessage.isFromMe) {
      prefix = 'أنت: ';
    }

    switch (lastMessage.type) {
      case ChatMessageType.image:
        return '$prefix📷 صورة';
      case ChatMessageType.file:
        return '$prefix📎 ملف';
      case ChatMessageType.audio:
        return '$prefix🎙️ رسالة صوتية';
      case ChatMessageType.video:
        return '$prefix🎥 فيديو';
      case ChatMessageType.location:
        return '$prefix📍 موقع';
      case ChatMessageType.productCard:
        return '$prefix🛍️ منتج';
      case ChatMessageType.quoteCard:
        return '$prefix💰 عرض سعر';
      case ChatMessageType.invoiceCard:
        return '$prefix🧾 فاتورة';
      case ChatMessageType.system:
        return lastMessage.content;
      default:
        return '$prefix${lastMessage.content}';
    }
  }

  /// Delegate to shared helper
  Color _getContextColor(ChatConversationType type) => ChatHelpers.getContextColor(type);

  /// Delegate to shared helper
  IconData _getContextIcon(ChatConversationType type) => ChatHelpers.getContextIcon(type);
}
