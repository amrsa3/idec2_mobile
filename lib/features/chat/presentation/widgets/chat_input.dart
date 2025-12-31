import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Chat Input Widget
/// Beautiful and functional input widget with attachments support
class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback? onAttachmentTap;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onCameraTap;
  final Function(bool)? onTypingChanged;
  final String? replyToMessage;
  final VoidCallback? onCancelReply;
  final List<String>? suggestedReplies;
  final Function(String)? onSuggestionTap;
  final bool enabled;
  final String hintText;

  const ChatInput({
    super.key,
    required this.onSend,
    this.onAttachmentTap,
    this.onVoiceTap,
    this.onCameraTap,
    this.onTypingChanged,
    this.replyToMessage,
    this.onCancelReply,
    this.suggestedReplies,
    this.onSuggestionTap,
    this.enabled = true,
    this.hintText = 'اكتب رسالتك...',
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  bool _isRecording = false;
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonAnimation;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sendButtonAnimation = CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.easeInOut,
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }

    // Typing indicator with debounce
    _typingTimer?.cancel();
    widget.onTypingChanged?.call(true);
    _typingTimer = Timer(const Duration(seconds: 2), () {
      widget.onTypingChanged?.call(false);
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
    widget.onTypingChanged?.call(false);
    _typingTimer?.cancel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Suggested replies
        if (widget.suggestedReplies != null && widget.suggestedReplies!.isNotEmpty)
          _buildSuggestedReplies(theme),

        // Reply preview
        if (widget.replyToMessage != null) _buildReplyPreview(theme),

        // Main input area
        Container(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              _buildIconButton(
                icon: Icons.add_circle_outline,
                onTap: widget.onAttachmentTap,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(width: 4),

              // Input field
              Expanded(child: _buildTextField(theme)),

              const SizedBox(width: 4),

              // Camera button
              AnimatedCrossFade(
                firstChild: _buildIconButton(
                  icon: Icons.camera_alt_outlined,
                  onTap: widget.onCameraTap,
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: _hasText 
                    ? CrossFadeState.showSecond 
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),

              // Send / Voice button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _hasText
                    ? _buildSendButton(theme)
                    : _buildVoiceButton(theme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: 5,
        minLines: 1,
        textInputAction: TextInputAction.newline,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        onSubmitted: (_) => _handleSend(),
      ),
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    return GestureDetector(
      onTap: _handleSend,
      child: Container(
        key: const ValueKey('send'),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.8),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildVoiceButton(ThemeData theme) {
    return GestureDetector(
      onTap: widget.onVoiceTap,
      onLongPressStart: (_) {
        HapticFeedback.mediumImpact();
        setState(() => _isRecording = true);
      },
      onLongPressEnd: (_) {
        setState(() => _isRecording = false);
      },
      child: AnimatedContainer(
        key: const ValueKey('voice'),
        duration: const Duration(milliseconds: 200),
        width: _isRecording ? 60 : 44,
        height: _isRecording ? 60 : 44,
        decoration: BoxDecoration(
          color: _isRecording 
              ? Colors.red 
              : theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.mic_outlined,
          color: _isRecording 
              ? Colors.white 
              : theme.colorScheme.onSurfaceVariant,
          size: _isRecording ? 28 : 22,
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          right: BorderSide(color: theme.primaryColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, color: theme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'رد على رسالة',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.replyToMessage!,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onCancelReply,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedReplies(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: widget.suggestedReplies!.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (widget.onSuggestionTap != null) {
                      widget.onSuggestionTap!(suggestion);
                    } else {
                      _controller.text = suggestion;
                      _handleSend();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Typing Indicator Widget
class TypingIndicator extends StatefulWidget {
  final Color? color;
  final double size;

  const TypingIndicator({
    super.key,
    this.color,
    this.size = 8,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true);
    });

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              width: widget.size,
              height: widget.size + (_animations[index].value * widget.size * 0.5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.5 + _animations[index].value * 0.5),
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
            );
          },
        );
      }),
    );
  }
}
