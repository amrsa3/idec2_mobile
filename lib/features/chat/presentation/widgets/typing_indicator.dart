import 'package:flutter/material.dart';

/// Typing Indicator Widget
/// Animated dots showing someone is typing
class TypingIndicator extends StatefulWidget {
  final Color? color;
  final double dotSize;
  final String? userName;
  final bool showLabel;

  const TypingIndicator({
    super.key,
    this.color,
    this.dotSize = 8,
    this.userName,
    this.showLabel = true,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dotAnimations = List.generate(3, (index) {
      final start = index * 0.15;
      final end = start + 0.4;
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, (end).clamp(0.0, 1.0)),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _dotAnimations[index],
                builder: (context, child) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: widget.dotSize * 0.25),
                    width: widget.dotSize,
                    height: widget.dotSize + (_dotAnimations[index].value * widget.dotSize * 0.5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.4 + _dotAnimations[index].value * 0.6),
                      borderRadius: BorderRadius.circular(widget.dotSize / 2),
                    ),
                  );
                },
              );
            }),
          ),

          // Label
          if (widget.showLabel) ...[
            const SizedBox(width: 10),
            Text(
              widget.userName != null
                  ? '${widget.userName} يكتب...'
                  : 'يكتب...',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated typing dots only (without container)
class TypingDots extends StatefulWidget {
  final Color? color;
  final double size;

  const TypingDots({
    super.key,
    this.color,
    this.size = 6,
  });

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final value = (((_controller.value * 3) - index) % 3).clamp(0.0, 1.0);
            final bounce = value < 0.5 ? value * 2 : (1 - value) * 2;
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              width: widget.size,
              height: widget.size + (bounce * widget.size * 0.5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3 + bounce * 0.7),
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Voice recording indicator
class RecordingIndicator extends StatefulWidget {
  final Color? color;
  final VoidCallback? onStop;

  const RecordingIndicator({
    super.key,
    this.color,
    this.onStop,
  });

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Update duration
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _duration += const Duration(seconds: 1));
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formattedDuration {
    final minutes = _duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5 + _controller.value * 0.5),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),

          const SizedBox(width: 12),

          // Duration
          Text(
            _formattedDuration,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(width: 12),

          // Stop button
          if (widget.onStop != null)
            GestureDetector(
              onTap: widget.onStop,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Connection Status Indicator
class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.isConnecting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isConnected) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isConnecting
          ? Colors.orange.shade100
          : Colors.red.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isConnecting) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'جاري الاتصال...',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 13,
              ),
            ),
          ] else ...[
            Icon(
              Icons.cloud_off,
              size: 16,
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              'لا يوجد اتصال',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
