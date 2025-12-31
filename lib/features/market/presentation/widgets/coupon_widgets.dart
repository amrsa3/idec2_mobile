import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/promotion_model.dart';
import '../../providers/promotions_provider.dart';

/// Widget for applying coupon codes in cart
class CouponInput extends ConsumerStatefulWidget {
  final double? orderTotal;
  final List<String>? productIds;
  final Function(CouponResult)? onCouponApplied;
  final Function()? onCouponRemoved;

  const CouponInput({
    super.key,
    this.orderTotal,
    this.productIds,
    this.onCouponApplied,
    this.onCouponRemoved,
  });

  @override
  ConsumerState<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends ConsumerState<CouponInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  CouponResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ref.read(promotionsProvider.notifier).applyCoupon(
          _controller.text.trim(),
          orderTotal: widget.orderTotal,
          productIds: widget.productIds,
        );

    setState(() {
      _isLoading = false;
      _result = result;
      if (!result.valid) {
        _errorMessage = result.message;
      }
    });

    if (result.valid && widget.onCouponApplied != null) {
      widget.onCouponApplied!(result);
    }
  }

  void _removeCoupon() {
    setState(() {
      _result = null;
      _controller.clear();
      _errorMessage = null;
    });
    ref.read(promotionsProvider.notifier).removeCoupon();
    widget.onCouponRemoved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Applied coupon
        if (_result != null && _result!.valid)
          _buildAppliedCoupon(isRTL, isDark)
        else
          _buildCouponInput(isRTL, isDark),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCouponInput(bool isRTL, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _errorMessage != null ? Colors.red : Colors.transparent,
              ),
            ),
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: isRTL ? 'أدخل كود الخصم' : 'Enter coupon code',
                prefixIcon: Icon(Icons.local_offer_outlined, color: Colors.teal.shade600),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (_) => _applyCoupon(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isLoading ? null : _applyCoupon,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(isRTL ? 'تطبيق' : 'Apply'),
        ),
      ],
    );
  }

  Widget _buildAppliedCoupon(bool isRTL, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.green.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.text.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                if (_result?.discountAmount != null)
                  Text(
                    isRTL
                        ? 'خصم: ${_result!.discountAmount!.toStringAsFixed(0)} YER'
                        : 'Discount: ${_result!.discountAmount!.toStringAsFixed(0)} YER',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _removeCoupon,
            icon: const Icon(Icons.close, color: Colors.grey),
            tooltip: isRTL ? 'إزالة' : 'Remove',
          ),
        ],
      ),
    );
  }
}

/// Compact coupon badge showing applied discount
class AppliedCouponBadge extends StatelessWidget {
  final String code;
  final double? discountAmount;
  final VoidCallback? onRemove;
  final bool isRTL;

  const AppliedCouponBadge({
    super.key,
    required this.code,
    this.discountAmount,
    this.onRemove,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, color: Colors.green.shade700, size: 16),
          const SizedBox(width: 6),
          Text(
            code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
              fontSize: 12,
            ),
          ),
          if (discountAmount != null) ...[
            const SizedBox(width: 4),
            Text(
              '(-${discountAmount!.toStringAsFixed(0)})',
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 11,
              ),
            ),
          ],
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, color: Colors.green.shade700, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

/// Cart discount summary widget
class CartDiscountSummary extends StatelessWidget {
  final double originalTotal;
  final double discountAmount;
  final double finalTotal;
  final List<AppliedPromotion> appliedPromotions;
  final bool isRTL;

  const CartDiscountSummary({
    super.key,
    required this.originalTotal,
    required this.discountAmount,
    required this.finalTotal,
    required this.appliedPromotions,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Original total
          _buildRow(
            isRTL ? 'المجموع الفرعي' : 'Subtotal',
            '${originalTotal.toStringAsFixed(0)} YER',
            isDark,
          ),

          // Applied promotions
          if (appliedPromotions.isNotEmpty) ...[
            const Divider(height: 16),
            ...appliedPromotions.map((promo) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildRow(
                    '🎁 ${promo.name}',
                    '-${promo.discountAmount.toStringAsFixed(0)} YER',
                    isDark,
                    valueColor: Colors.green,
                  ),
                )),
          ],

          // Total discount
          if (discountAmount > 0) ...[
            const Divider(height: 16),
            _buildRow(
              isRTL ? 'إجمالي الخصم' : 'Total Discount',
              '-${discountAmount.toStringAsFixed(0)} YER',
              isDark,
              valueColor: Colors.green,
              isBold: true,
            ),
          ],

          const Divider(height: 16),

          // Final total
          _buildRow(
            isRTL ? 'الإجمالي' : 'Total',
            '${finalTotal.toStringAsFixed(0)} YER',
            isDark,
            isBold: true,
            valueColor: Colors.teal.shade700,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
