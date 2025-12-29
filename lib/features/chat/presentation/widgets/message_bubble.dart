import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_enums.dart';

/// Message Bubble Widget
/// Beautiful message bubble with animations and context cards
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool showTime;
  final VoidCallback? onLongPress;
  final Function(QuickAction)? onQuickActionTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.showTime = true,
    this.onLongPress,
    this.onQuickActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFromMe = message.isFromMe;

    // System message style
    if (message.isSystemMessage) {
      return _buildSystemMessage(context);
    }

    return Padding(
      padding: EdgeInsets.only(
        left: isFromMe ? 8 : 60,
        right: isFromMe ? 60 : 8,
        top: 4,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment: isFromMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isFromMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar (for received messages)
              if (!isFromMe && showAvatar) ...[
                _buildAvatar(),
                const SizedBox(width: 8),
              ],

              // Message content
              Flexible(
                child: GestureDetector(
                  onLongPress: onLongPress,
                  child: _buildBubble(context, theme, isFromMe),
                ),
              ),

              // Avatar placeholder (for sent messages to maintain alignment)
              if (isFromMe && showAvatar) ...[
                const SizedBox(width: 8),
                const SizedBox(width: 32), // Avatar placeholder
              ],
            ],
          ),

          // Quick actions
          if (message.quickActions != null && message.quickActions!.isNotEmpty)
            _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade600,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: message.senderAvatar != null
          ? ClipOval(
              child: Image.network(
                message.senderAvatar!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _avatarFallback(),
              ),
            )
          : _avatarFallback(),
    );
  }

  Widget _avatarFallback() {
    return Center(
      child: Text(
        (message.senderName ?? '?')[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, ThemeData theme, bool isFromMe) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        gradient: isFromMe
            ? LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isFromMe ? null : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isFromMe ? 20 : 4),
          bottomRight: Radius.circular(isFromMe ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: (isFromMe ? theme.primaryColor : Colors.black).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isFromMe ? 20 : 4),
          bottomRight: Radius.circular(isFromMe ? 4 : 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context card (if any)
            if (message.contextCard != null) _buildContextCard(context),

            // Message content
            _buildContent(context, theme, isFromMe),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, bool isFromMe) {
    final textColor = isFromMe ? Colors.white : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply preview
          if (message.replyTo != null) _buildReplyPreview(context, isFromMe),

          // Main content based on type
          _buildMessageContent(context, textColor),

          const SizedBox(height: 6),

          // Time and status row
          if (showTime) _buildTimeRow(theme, isFromMe, textColor),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, Color textColor) {
    switch (message.type) {
      case ChatMessageType.image:
        return _buildImageMessage(context);
      case ChatMessageType.file:
        return _buildFileMessage(context, textColor);
      case ChatMessageType.audio:
        return _buildAudioMessage(context, textColor);
      case ChatMessageType.location:
        return _buildLocationMessage(context, textColor);
      case ChatMessageType.productCard:
        return _buildProductCard(context);
      case ChatMessageType.quoteCard:
        return _buildQuoteCard(context);
      default:
        return SelectableText(
          message.content,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            height: 1.4,
          ),
        );
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    final imageUrl = message.attachments?['url'] ?? message.content;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: 200,
          height: 200,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image_outlined, size: 48),
        ),
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context, Color textColor) {
    final fileName = message.attachments?['name'] ?? 'ملف';
    final fileSize = message.attachments?['size'] ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.insert_drive_file_outlined, color: textColor),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (fileSize.isNotEmpty)
                  Text(
                    fileSize,
                    style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.download_outlined, color: textColor),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(BuildContext context, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, color: textColor),
          ),
          const SizedBox(width: 12),
          // Audio waveform placeholder
          ...List.generate(12, (i) => Container(
            width: 3,
            height: (10 + (i % 4) * 8).toDouble(),
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          )),
          const SizedBox(width: 12),
          Text(
            message.attachments?['duration'] ?? '0:00',
            style: TextStyle(color: textColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage(BuildContext context, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: textColor, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message.attachments?['address'] ?? 'موقع',
              style: TextStyle(color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextCard(BuildContext context) {
    // Placeholder for context cards (products, quotes, etc.)
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Colors.teal),
          SizedBox(width: 8),
          Text('Product Card', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade200,
              child: const Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('اسم المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('السعر: ₴ 100', style: TextStyle(color: Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.request_quote_outlined, color: Colors.green),
          SizedBox(width: 8),
          Text('عرض سعر', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context, bool isFromMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isFromMe ? 0.15 : 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          right: BorderSide(
            color: isFromMe ? Colors.white : Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyTo!.senderName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isFromMe ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            message.replyTo!.content,
            style: TextStyle(
              fontSize: 12,
              color: isFromMe ? Colors.white.withOpacity(0.8) : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(ThemeData theme, bool isFromMe, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.formattedTime,
          style: TextStyle(
            fontSize: 11,
            color: textColor.withOpacity(0.7),
          ),
        ),

        if (message.isEdited) ...[
          const SizedBox(width: 4),
          Text(
            '(معدّل)',
            style: TextStyle(
              fontSize: 10,
              color: textColor.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],

        if (isFromMe) ...[
          const SizedBox(width: 6),
          Icon(
            message.isRead 
                ? Icons.done_all 
                : message.isDelivered 
                    ? Icons.done_all 
                    : Icons.done,
            size: 16,
            color: message.isRead 
                ? Colors.lightBlue 
                : textColor.withOpacity(0.7),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.quickActions!.map((action) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onQuickActionTap?.call(action),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
