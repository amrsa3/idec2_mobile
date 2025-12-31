import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/favorites/providers/favorites_provider.dart';
import '../../core/theme/app_colors.dart';

/// زر المفضلة القابل لإعادة الاستخدام
class FavoriteButton extends ConsumerWidget {
  final String itemId;
  final FavoriteType type;
  final String name;
  final String? nameEn;
  final String? imageUrl;
  final String? subtitle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.itemId,
    required this.type,
    required this.name,
    this.nameEn,
    this.imageUrl,
    this.subtitle,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider((itemId, type)));

    return GestureDetector(
      onTap: () async {
        final added = await ref.read(favoritesProvider.notifier).toggleFavorite(
          id: itemId,
          type: type,
          name: name,
          nameEn: nameEn,
          imageUrl: imageUrl,
          subtitle: subtitle,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    added ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(added ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة'),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: showBackground ? const EdgeInsets.all(8) : EdgeInsets.zero,
        decoration: showBackground
            ? BoxDecoration(
                color: isFavorite
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              )
            : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavorite),
            size: size,
            color: isFavorite
                ? (activeColor ?? Colors.red)
                : (inactiveColor ?? Colors.grey),
          ),
        ),
      ),
    );
  }
}

/// زر إضافة للسلة
class AddToCartButton extends ConsumerWidget {
  final String productId;
  final String name;
  final String? nameEn;
  final String? imageUrl;
  final double price;
  final double? salePrice;
  final String currency;
  final String? vendorName;
  final bool isCompact;
  final bool showLabel;

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.name,
    this.nameEn,
    this.imageUrl,
    required this.price,
    this.salePrice,
    this.currency = 'SAR',
    this.vendorName,
    this.isCompact = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Import cart provider dynamically to avoid circular imports
    // final isInCart = ref.watch(isInCartProvider(productId));

    if (isCompact) {
      return GestureDetector(
        onTap: () => _addToCart(context, ref),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade600, Colors.teal.shade800],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _addToCart(context, ref),
      icon: const Icon(Icons.add_shopping_cart, size: 18),
      label: Text(showLabel ? 'إضافة للسلة' : ''),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref) {
    // TODO: Add to cart using cartProvider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('تمت الإضافة للسلة: $name')),
          ],
        ),
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// زر إضافة للجدول الشخصي
class AddToScheduleButton extends ConsumerWidget {
  final String sessionId;
  final String title;
  final String? titleEn;
  final String? speakerName;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;
  final bool isCompact;

  const AddToScheduleButton({
    super.key,
    required this.sessionId,
    required this.title,
    this.titleEn,
    this.speakerName,
    this.location,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Import schedule provider dynamically
    // final isInSchedule = ref.watch(isInScheduleProvider(sessionId));

    if (isCompact) {
      return GestureDetector(
        onTap: () => _toggleSchedule(context, ref),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _toggleSchedule(context, ref),
      icon: const Icon(Icons.calendar_today, size: 18),
      label: const Text('إضافة للجدول'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleSchedule(BuildContext context, WidgetRef ref) {
    // TODO: Toggle schedule using personalScheduleProvider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('تمت الإضافة للجدول: $title')),
          ],
        ),
        action: SnackBarAction(
          label: 'عرض الجدول',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to schedule
          },
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// شارة عدد السلة
class CartBadge extends ConsumerWidget {
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;

  const CartBadge({
    super.key,
    required this.child,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Import cart provider dynamically
    // final itemCount = ref.watch(cartItemCountProvider);
    const itemCount = 0; // Placeholder

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (itemCount > 0)
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
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                itemCount > 99 ? '99+' : '$itemCount',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// شارة عدد المفضلة
class FavoritesBadge extends ConsumerWidget {
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;

  const FavoritesBadge({
    super.key,
    required this.child,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(favoritesCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (itemCount > 0)
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
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                itemCount > 99 ? '99+' : '$itemCount',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
