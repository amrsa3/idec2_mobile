import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum LoadingSize {
  small,
  medium,
  large,
}

enum LoadingType {
  circular,
  linear,
  dots,
  skeleton,
}

/// Customizable loading indicator widget
class LoadingIndicator extends StatelessWidget {
  final LoadingSize size;
  final LoadingType type;
  final Color? color;
  final String? message;
  final bool overlay;
  final double? value; // For progress indicators

  const LoadingIndicator({
    super.key,
    this.size = LoadingSize.medium,
    this.type = LoadingType.circular,
    this.color,
    this.message,
    this.overlay = false,
    this.value,
  });

  /// Circular loading indicator
  const LoadingIndicator.circular({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.overlay = false,
    this.value,
  }) : type = LoadingType.circular;

  /// Linear progress indicator
  const LoadingIndicator.linear({
    super.key,
    this.color,
    this.message,
    this.overlay = false,
    this.value,
  }) : size = LoadingSize.medium, type = LoadingType.linear;

  /// Dots loading animation
  const LoadingIndicator.dots({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.overlay = false,
  }) : type = LoadingType.dots, value = null;

  /// Skeleton loading placeholder
  const LoadingIndicator.skeleton({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.overlay = false,
  }) : type = LoadingType.skeleton, value = null;

  /// Full screen overlay loading
  const LoadingIndicator.overlay({
    super.key,
    this.size = LoadingSize.medium,
    this.type = LoadingType.circular,
    this.color,
    this.message,
    this.value,
  }) : overlay = true;

  @override
  Widget build(BuildContext context) {
    final widget = _buildLoadingWidget(context);

    if (overlay) {
      return Container(
        color: Colors.black54,
        child: Center(child: widget),
      );
    }

    return widget;
  }

  Widget _buildLoadingWidget(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    switch (type) {
      case LoadingType.circular:
        return _buildCircularIndicator(effectiveColor);
      case LoadingType.linear:
        return _buildLinearIndicator(effectiveColor);
      case LoadingType.dots:
        return _buildDotsIndicator(effectiveColor);
      case LoadingType.skeleton:
        return _buildSkeletonIndicator();
    }
  }

  Widget _buildCircularIndicator(Color color) {
    final indicatorSize = _getCircularSize();
    
    final indicator = SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: _getStrokeWidth(),
      ),
    );

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }

  Widget _buildLinearIndicator(Color color) {
    final indicator = LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      backgroundColor: color.withOpacity(0.2),
    );

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 8),
          Text(
            message!,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }

  Widget _buildDotsIndicator(Color color) {
    return DotsLoadingAnimation(
      color: color,
      size: _getDotSize(),
      message: message,
    );
  }

  Widget _buildSkeletonIndicator() {
    return SkeletonLoader(
      width: _getSkeletonWidth(),
      height: _getSkeletonHeight(),
    );
  }

  double _getCircularSize() {
    switch (size) {
      case LoadingSize.small:
        return 20;
      case LoadingSize.medium:
        return 32;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  double _getDotSize() {
    switch (size) {
      case LoadingSize.small:
        return 6;
      case LoadingSize.medium:
        return 8;
      case LoadingSize.large:
        return 12;
    }
  }

  double _getSkeletonWidth() {
    switch (size) {
      case LoadingSize.small:
        return 100;
      case LoadingSize.medium:
        return 200;
      case LoadingSize.large:
        return 300;
    }
  }

  double _getSkeletonHeight() {
    switch (size) {
      case LoadingSize.small:
        return 16;
      case LoadingSize.medium:
        return 20;
      case LoadingSize.large:
        return 24;
    }
  }
}

/// Animated dots loading indicator
class DotsLoadingAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final String? message;

  const DotsLoadingAnimation({
    super.key,
    required this.color,
    required this.size,
    this.message,
  });

  @override
  State<DotsLoadingAnimation> createState() => _DotsLoadingAnimationState();
}

class _DotsLoadingAnimationState extends State<DotsLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
              child: Opacity(
                opacity: 0.3 + (_animations[index].value * 0.7),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );

    if (widget.message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dots,
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return dots;
  }
}

/// Skeleton loading placeholder
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}
