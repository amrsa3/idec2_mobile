import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A widget that provides theme-aware styling automatically
/// Wrap your screen content with this widget to get automatic dark mode support
class ThemeAwareScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  
  const ThemeAwareScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: appBar,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}

/// Theme-aware card widget
class ThemeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final double elevation;
  
  const ThemeCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: elevation * 4,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: child,
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    
    return content;
  }
}

/// Theme-aware text styles
class ThemeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final ThemeTextType type;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  
  const ThemeText(
    this.text, {
    super.key,
    this.style,
    this.type = ThemeTextType.body,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });
  
  const ThemeText.title(this.text, {super.key, this.style, this.maxLines, this.overflow, this.textAlign})
      : type = ThemeTextType.title;
  
  const ThemeText.subtitle(this.text, {super.key, this.style, this.maxLines, this.overflow, this.textAlign})
      : type = ThemeTextType.subtitle;
  
  const ThemeText.body(this.text, {super.key, this.style, this.maxLines, this.overflow, this.textAlign})
      : type = ThemeTextType.body;
  
  const ThemeText.caption(this.text, {super.key, this.style, this.maxLines, this.overflow, this.textAlign})
      : type = ThemeTextType.caption;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    TextStyle baseStyle;
    switch (type) {
      case ThemeTextType.title:
        baseStyle = TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        );
        break;
      case ThemeTextType.subtitle:
        baseStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        );
        break;
      case ThemeTextType.body:
        baseStyle = TextStyle(
          fontSize: 14,
          color: colors.textSecondary,
        );
        break;
      case ThemeTextType.caption:
        baseStyle = TextStyle(
          fontSize: 12,
          color: colors.textTertiary,
        );
        break;
    }
    
    return Text(
      text,
      style: style != null ? baseStyle.merge(style) : baseStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

enum ThemeTextType { title, subtitle, body, caption }

/// Theme-aware icon button
class ThemeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  final bool withBackground;
  
  const ThemeIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
    this.color,
    this.withBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: color ?? colors.iconPrimary,
    );
    
    if (withBackground) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.containerBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: iconWidget,
        ),
      );
    }
    
    return IconButton(
      icon: iconWidget,
      onPressed: onTap,
    );
  }
}

/// Theme-aware section header
class ThemeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  
  const ThemeSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        if (actionText != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Row(
              children: [
                Text(
                  actionText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
              ],
            ),
          ),
      ],
    );
  }
}

/// Theme-aware loading indicator
class ThemeLoadingIndicator extends StatelessWidget {
  final double size;
  
  const ThemeLoadingIndicator({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Theme-aware empty state widget
class ThemeEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  
  const ThemeEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: colors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Theme-aware error state widget
class ThemeErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  const ThemeErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ],
      ),
    );
  }
}
