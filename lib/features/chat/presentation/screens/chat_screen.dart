import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/enhanced_image_manager.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_enums.dart';
import '../../core/chat_helpers.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

/// Chat Screen
/// Beautiful and functional chat interface
class ChatScreen extends StatefulWidget {
  final ChatConversation? conversation;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isTyping;
  final Set<String> typingUsers;
  final List<String> suggestedReplies;
  final Future<bool> Function(String) onSendMessage;
  final VoidCallback? onLoadMore;
  final Function(bool) onTypingChanged;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onBackPressed;

  const ChatScreen({
    super.key,
    this.conversation,
    required this.messages,
    this.isLoading = false,
    this.isTyping = false,
    this.typingUsers = const {},
    this.suggestedReplies = const [],
    required this.onSendMessage,
    this.onLoadMore,
    required this.onTypingChanged,
    this.onAttachmentTap,
    this.onBackPressed,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  String? _replyToMessage;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final showButton = _scrollController.offset > 200;
    if (showButton != _showScrollToBottom) {
      setState(() => _showScrollToBottom = showButton);
    }

    // Load more on scroll to top
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 100) {
      widget.onLoadMore?.call();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversation = widget.conversation;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, theme, conversation),
      body: Stack(
        children: [
          // Background pattern
          _buildBackground(theme),

          // Content
          Column(
            children: [
              // Messages list
              // Messages list
              Expanded(
                child: widget.isLoading && widget.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : widget.messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, 
                                  size: 48, 
                                  color: theme.colorScheme.outline.withOpacity(0.5)
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد رسائل بعد',
                                  style: TextStyle(color: theme.colorScheme.outline),
                                ),
                              ],
                            ),
                          )
                        : _buildMessagesList(theme),
              ),

              // Typing indicator
              if (widget.isTyping) _buildTypingIndicator(theme),

              // Input
              ChatInput(
                onSend: (text) async {
                  final success = await widget.onSendMessage(text);
                  if (success) {
                    _scrollToBottom();
                  }
                },
                onTypingChanged: widget.onTypingChanged,
                onAttachmentTap: widget.onAttachmentTap,
                replyToMessage: _replyToMessage,
                onCancelReply: () => setState(() => _replyToMessage = null),
                suggestedReplies: widget.suggestedReplies,
              ),
            ],
          ),

          // Scroll to bottom button
          if (_showScrollToBottom)
            Positioned(
              bottom: 100,
              right: 16,
              child: _buildScrollToBottomButton(theme),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    ChatConversation? conversation,
  ) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
      ),
      title: conversation != null
          ? GestureDetector(
              onTap: () => _showConversationDetails(context, conversation),
              child: Row(
                children: [
                  // Avatar
                  _buildAvatar(conversation),
                  const SizedBox(width: 12),

                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDisplayName(conversation),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _buildTypeBadge(conversation.type),
                            if (conversation.otherParticipant?.isOnline == true) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'متصل',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.green,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Text('محادثة'),
      actions: [
        // More options
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  /// Get display name using shared helper
  String _getDisplayName(ChatConversation conversation) =>
      ChatHelpers.getDisplayName(conversation);

  Widget _buildAvatar(ChatConversation conversation) {
    final avatarUrl = conversation.displayAvatar ?? 
                      conversation.otherParticipant?.userAvatar;
    final displayName = _getDisplayName(conversation);
    final contextColor = _getContextColor(conversation.type);
    
    // Use enhanced image manager for optimized loading
    return imageManager.buildGradientAvatar(
      imageUrl: avatarUrl,
      name: displayName,
      size: 44,
      gradientColors: [
        contextColor,
        contextColor.withOpacity(0.7),
      ],
      borderRadius: BorderRadius.circular(14),
    );
  }

  Widget _avatarFallback([String? letter]) {
    return Center(
      child: Text(
        letter ?? '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(ChatConversationType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getContextColor(type).withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.displayNameAr,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _getContextColor(type),
        ),
      ),
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.03),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: CustomPaint(
          painter: _ChatBackgroundPainter(
            color: theme.primaryColor.withOpacity(0.02),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final previousMessage = index < widget.messages.length - 1
            ? widget.messages[index + 1]
            : null;
        final nextMessage = index > 0 ? widget.messages[index - 1] : null;

        // Show date separator if needed
        final showDate = previousMessage == null ||
            !_isSameDay(message.createdAt, previousMessage.createdAt);

        // Show avatar if different sender or long time gap
        final showAvatar = nextMessage == null ||
            nextMessage.senderId != message.senderId ||
            nextMessage.createdAt.difference(message.createdAt).inMinutes > 5;

        return Column(
          children: [
            if (showDate) _buildDateSeparator(message.createdAt, theme),
            MessageBubble(
              message: message,
              showAvatar: false, // User requested to hide avatar in messages
              showTime: true,
              onLongPress: () => _showMessageOptions(context, message),
              onQuickActionTap: (action) => _handleQuickAction(action),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(DateTime date, ThemeData theme) {
    String text;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      text = 'اليوم';
    } else if (messageDate == yesterday) {
      text = 'أمس';
    } else {
      text = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDots(theme),
                const SizedBox(width: 8),
                Text(
                  'يكتب...',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDots(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (i * 150)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.5 + value * 0.5),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildScrollToBottomButton(ThemeData theme) {
    return FloatingActionButton.small(
      onPressed: _scrollToBottom,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.primaryColor,
      elevation: 4,
      child: const Icon(Icons.keyboard_arrow_down),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showConversationDetails(BuildContext context, ChatConversation conversation) {
    // Show conversation details
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('بحث في المحادثة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('الإشعارات'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('الرسائل المميزة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('إبلاغ'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context, ChatMessage message) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('رد'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyToMessage = message.content);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('نسخ'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم النسخ')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('تميز'),
              onTap: () => Navigator.pop(context),
            ),
            if (message.isFromMe)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('حذف', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }

  void _handleQuickAction(QuickAction action) {
    // Handle quick action
  }

  /// Delegate to shared helper
  Color _getContextColor(ChatConversationType type) =>
      ChatHelpers.getContextColor(type);

  /// Delegate to shared helper
  IconData _getContextIcon(ChatConversationType type) =>
      ChatHelpers.getContextIcon(type);
}

/// Background pattern painter
class _ChatBackgroundPainter extends CustomPainter {
  final Color color;

  _ChatBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
