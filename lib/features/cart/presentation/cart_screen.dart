import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/language_provider.dart';
import '../../../shared/widgets/animated_widgets.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final isRTL = ref.watch(isRTLProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              isRTL ? 'سلة التسوق' : 'Shopping Cart',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (cartState.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cartState.itemCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        elevation: 0,
        actions: [
          if (cartState.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => _showClearConfirmation(context, ref, isRTL),
            ),
        ],
      ),
      body: cartState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartState.isEmpty
              ? _buildEmptyCart(context, isRTL)
              : _buildCartContent(context, ref, cartState, isRTL, isDark),
      bottomNavigationBar: cartState.isNotEmpty
          ? _buildCheckoutBar(context, ref, cartState, isRTL, isDark)
          : null,
    );
  }

  Widget _buildEmptyCart(BuildContext context, bool isRTL) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: isRTL ? 'سلتك فارغة' : 'Your cart is empty',
      subtitle: isRTL
          ? 'ابدأ التسوق وأضف منتجات إلى سلتك'
          : 'Start shopping and add products to your cart',
      actionText: isRTL ? 'تصفح المنتجات' : 'Browse Products',
      onAction: () => Navigator.pop(context),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
    bool isRTL,
    bool isDark,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartState.items.length,
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return AnimatedListCard(
                index: index,
                child: _buildCartItemCard(context, ref, item, isRTL, isDark),
              );
            },
          ),
        ),
        // Order Summary
        _buildOrderSummary(cartState, isRTL, isDark),
      ],
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
    bool isRTL,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        ref.read(cartProvider.notifier).removeFromCart(item.productId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // صورة المنتج
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ShimmerLoading(
                          width: 80,
                          height: 80,
                          borderRadius: 12,
                        ),
                        errorWidget: (_, __, ___) => _buildPlaceholder(isDark),
                      )
                    : _buildPlaceholder(isDark),
              ),
              const SizedBox(width: 12),
              // معلومات المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRTL ? item.name : (item.nameEn ?? item.name),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.vendorName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.vendorName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // السعر
                    Row(
                      children: [
                        if (item.hasDiscount) ...[
                          Text(
                            '${item.price.toStringAsFixed(0)} ${item.currency}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          '${item.effectivePrice.toStringAsFixed(0)} ${item.currency}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // التحكم بالكمية
              Column(
                children: [
                  _buildQuantityButton(
                    Icons.add,
                    () => ref.read(cartProvider.notifier).incrementQuantity(item.productId),
                    isDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    Icons.remove,
                    () => ref.read(cartProvider.notifier).decrementQuantity(item.productId),
                    isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed, bool isDark) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.grey[400],
        size: 32,
      ),
    );
  }

  Widget _buildOrderSummary(CartState cartState, bool isRTL, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            isRTL ? 'عدد المنتجات' : 'Products',
            '${cartState.productCount}',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            isRTL ? 'إجمالي الكمية' : 'Total Quantity',
            '${cartState.itemCount}',
            isDark,
          ),
          if (cartState.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              isRTL ? 'الخصم' : 'Discount',
              '- ${cartState.discount.toStringAsFixed(0)} SAR',
              isDark,
              valueColor: Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label, 
    String value, 
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[500] : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
    bool isRTL,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // المجموع
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRTL ? 'الإجمالي' : 'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${cartState.total.toStringAsFixed(0)} SAR',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ),
            // زر الدفع
            Expanded(
              child: ElevatedButton(
                onPressed: cartState.isCheckingOut
                    ? null
                    : () => _proceedToCheckout(context, ref, isRTL),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: cartState.isCheckingOut
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_checkout, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isRTL ? 'إتمام الطلب' : 'Checkout',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToCheckout(BuildContext context, WidgetRef ref, bool isRTL) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CheckoutSheet(isRTL: isRTL),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isRTL ? 'مسح السلة' : 'Clear Cart'),
        content: Text(
          isRTL
              ? 'هل أنت متأكد من مسح جميع المنتجات من السلة؟'
              : 'Are you sure you want to remove all items from the cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRTL ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cartProvider.notifier).clearCart();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isRTL ? 'مسح' : 'Clear'),
          ),
        ],
      ),
    );
  }
}

/// شاشة إتمام الطلب
class _CheckoutSheet extends ConsumerStatefulWidget {
  final bool isRTL;

  const _CheckoutSheet({required this.isRTL});

  @override
  ConsumerState<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<_CheckoutSheet> {
  int _currentStep = 0;
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isRTL ? 'إتمام الطلب' : 'Checkout',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Steps
              Expanded(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      _confirmOrder();
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    }
                  },
                  steps: [
                    Step(
                      title: Text(widget.isRTL ? 'العنوان' : 'Address'),
                      isActive: _currentStep >= 0,
                      content: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: widget.isRTL ? 'أدخل عنوان التوصيل' : 'Enter delivery address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Step(
                      title: Text(widget.isRTL ? 'طريقة الدفع' : 'Payment'),
                      isActive: _currentStep >= 1,
                      content: Column(
                        children: [
                          _buildPaymentOption('cash', widget.isRTL ? 'الدفع عند الاستلام' : 'Cash on Delivery', Icons.money),
                          _buildPaymentOption('card', widget.isRTL ? 'بطاقة ائتمان' : 'Credit Card', Icons.credit_card),
                          _buildPaymentOption('wallet', widget.isRTL ? 'المحفظة' : 'Wallet', Icons.account_balance_wallet),
                        ],
                      ),
                    ),
                    Step(
                      title: Text(widget.isRTL ? 'ملاحظات' : 'Notes'),
                      isActive: _currentStep >= 2,
                      content: TextField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: widget.isRTL ? 'ملاحظات إضافية (اختياري)' : 'Additional notes (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _paymentMethod == value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[50]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmOrder() async {
    final success = await ref.read(cartProvider.notifier).checkout();
    
    if (mounted) {
      Navigator.pop(context);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(widget.isRTL ? 'تم الطلب بنجاح!' : 'Order placed successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isRTL ? 'فشل في إتمام الطلب' : 'Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
