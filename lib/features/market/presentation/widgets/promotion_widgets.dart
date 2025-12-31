import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/promotion_model.dart';

/// Widget for displaying countdown timer for flash sales
class CountdownTimer extends StatefulWidget {
  final DateTime endTime;
  final TextStyle? textStyle;
  final bool showLabels;
  final Color? backgroundColor;

  const CountdownTimer({
    super.key,
    required this.endTime,
    this.textStyle,
    this.showLabels = true,
    this.backgroundColor,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final now = DateTime.now();
    if (widget.endTime.isAfter(now)) {
      setState(() => _remaining = widget.endTime.difference(now));
    } else {
      setState(() => _remaining = Duration.zero);
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (days > 0) ...[
          _buildTimeBox(days.toString().padLeft(2, '0'), isArabic ? 'يوم' : 'D'),
          const SizedBox(width: 4),
        ],
        _buildTimeBox(hours.toString().padLeft(2, '0'), isArabic ? 'ساعة' : 'H'),
        const Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        _buildTimeBox(minutes.toString().padLeft(2, '0'), isArabic ? 'دقيقة' : 'M'),
        const Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        _buildTimeBox(seconds.toString().padLeft(2, '0'), isArabic ? 'ثانية' : 'S'),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.red.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: widget.textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
          ),
          if (widget.showLabels)
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 8,
              ),
            ),
        ],
      ),
    );
  }
}

/// Promotion badge widget
class PromotionBadge extends StatelessWidget {
  final Promotion promotion;
  final bool isRTL;
  final double? fontSize;

  const PromotionBadge({
    super.key,
    required this.promotion,
    required this.isRTL,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.red;
    if (promotion.badgeColor != null) {
      try {
        badgeColor = Color(int.parse(promotion.badgeColor!.replaceAll('#', '0xFF')));
      } catch (_) {}
    }

    final badgeText = promotion.getLocalizedBadgeText(isRTL) ?? promotion.discountDisplayText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Flash sale indicator
class FlashSaleIndicator extends StatelessWidget {
  final Promotion promotion;
  final bool isRTL;

  const FlashSaleIndicator({
    super.key,
    required this.promotion,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flash_on, color: Colors.yellow, size: 14),
          const SizedBox(width: 4),
          Text(
            isRTL ? 'عرض سريع' : 'Flash Sale',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Conference offer indicator
class ConferenceOfferIndicator extends StatelessWidget {
  final bool isRTL;

  const ConferenceOfferIndicator({super.key, required this.isRTL});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            isRTL ? 'عرض مؤتمر' : 'Conference',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Promotion card widget for displaying individual promotions
class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  final bool isRTL;
  final VoidCallback? onTap;
  final bool showCountdown;

  const PromotionCard({
    super.key,
    required this.promotion,
    required this.isRTL,
    this.onTap,
    this.showCountdown = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or Gradient
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  promotion.image != null
                      ? CachedNetworkImage(
                          imageUrl: promotion.image!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _buildPlaceholder(),
                          errorWidget: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  // Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PromotionBadge(promotion: promotion, isRTL: isRTL),
                        if (promotion.isFlashSale) ...[
                          const SizedBox(height: 4),
                          FlashSaleIndicator(promotion: promotion, isRTL: isRTL),
                        ],
                        if (promotion.isConferenceOffer) ...[
                          const SizedBox(height: 4),
                          ConferenceOfferIndicator(isRTL: isRTL),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promotion.getLocalizedTitle(isRTL),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (promotion.vendor != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      promotion.vendor!.getLocalizedName(isRTL),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Countdown or expiry
                  if (showCountdown && promotion.isFlashSale && promotion.isActive)
                    CountdownTimer(endTime: promotion.endDate)
                  else if (promotion.isExpiringSoon)
                    Text(
                      isRTL ? '⏰ ينتهي قريباً!' : '⏰ Ending Soon!',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade600, Colors.teal.shade800],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_offer,
          size: 40,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// Flash sale banner for home screen
class FlashSaleBanner extends StatelessWidget {
  final List<Promotion> promotions;
  final bool isRTL;
  final Function(Promotion)? onPromotionTap;

  const FlashSaleBanner({
    super.key,
    required this.promotions,
    required this.isRTL,
    this.onPromotionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.yellow, size: 24),
              const SizedBox(width: 8),
              Text(
                isRTL ? 'عروض سريعة ⚡' : '⚡ Flash Deals',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (promotions.first.isActive)
                CountdownTimer(
                  endTime: promotions.first.endDate,
                  showLabels: false,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: promotions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return PromotionCard(
                  promotion: promotions[index],
                  isRTL: isRTL,
                  onTap: () => onPromotionTap?.call(promotions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Conference offers section
class ConferenceOffersSection extends StatelessWidget {
  final List<Promotion> promotions;
  final bool isRTL;
  final Function(Promotion)? onPromotionTap;

  const ConferenceOffersSection({
    super.key,
    required this.promotions,
    required this.isRTL,
    this.onPromotionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                isRTL ? 'عروض المؤتمر الحصرية' : 'Exclusive Conference Deals',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: promotions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return PromotionCard(
                promotion: promotions[index],
                isRTL: isRTL,
                onTap: () => onPromotionTap?.call(promotions[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
