import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/notification_provider.dart';

/// Badge يعرض عدد الإشعارات غير المقروءة
class NotificationBadge extends ConsumerWidget {
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;
  final double? fontSize;

  const NotificationBadge({
    super.key,
    required this.child,
    this.badgeColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return unreadCountAsync.when(
      data: (unreadCount) {
        if (unreadCount == 0) {
          return child;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: fontSize ?? 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}








