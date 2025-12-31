import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/language_provider.dart';
import '../../../shared/widgets/animated_widgets.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final isRTL = ref.watch(isRTLProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
        appBar: AppBar(
          title: Text(
            isRTL ? 'المفضلة' : 'Favorites',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            if (favoritesState.items.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => _showClearConfirmation(context, ref, isRTL),
              ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey[600],
            tabs: [
              _buildTab(
                Icons.shopping_bag_outlined,
                isRTL ? 'المنتجات' : 'Products',
                favoritesState.productCount,
              ),
              _buildTab(
                Icons.storefront_outlined,
                isRTL ? 'العارضون' : 'Exhibitors',
                favoritesState.exhibitorCount,
              ),
              _buildTab(
                Icons.event_outlined,
                isRTL ? 'الجلسات' : 'Sessions',
                favoritesState.sessionCount,
              ),
              _buildTab(
                Icons.person_outline,
                isRTL ? 'المتحدثون' : 'Speakers',
                favoritesState.speakerCount,
              ),
            ],
          ),
        ),
        body: favoritesState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildFavoritesList(
                    context, ref, 
                    favoritesState.getByType(FavoriteType.product),
                    FavoriteType.product,
                    isRTL, isDark,
                  ),
                  _buildFavoritesList(
                    context, ref,
                    favoritesState.getByType(FavoriteType.exhibitor),
                    FavoriteType.exhibitor,
                    isRTL, isDark,
                  ),
                  _buildFavoritesList(
                    context, ref,
                    favoritesState.getByType(FavoriteType.session),
                    FavoriteType.session,
                    isRTL, isDark,
                  ),
                  _buildFavoritesList(
                    context, ref,
                    favoritesState.getByType(FavoriteType.speaker),
                    FavoriteType.speaker,
                    isRTL, isDark,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteItem> items,
    FavoriteType type,
    bool isRTL,
    bool isDark,
  ) {
    if (items.isEmpty) {
      return EmptyStateWidget(
        icon: _getIconForType(type),
        title: isRTL ? 'لا توجد عناصر مفضلة' : 'No favorites yet',
        subtitle: isRTL
            ? 'أضف ${_getTypeLabelAr(type)} للمفضلة للوصول إليها بسرعة'
            : 'Add ${_getTypeLabelEn(type)} to favorites for quick access',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AnimatedListCard(
          index: index,
          child: _buildFavoriteCard(context, ref, item, isRTL, isDark),
        );
      },
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    WidgetRef ref,
    FavoriteItem item,
    bool isRTL,
    bool isDark,
  ) {
    return Dismissible(
      key: Key('${item.type.name}_${item.id}'),
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
        ref.read(favoritesProvider.notifier).removeFavorite(item.id, item.type);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isRTL ? 'تم الإزالة من المفضلة' : 'Removed from favorites'),
            action: SnackBarAction(
              label: isRTL ? 'تراجع' : 'Undo',
              onPressed: () {
                ref.read(favoritesProvider.notifier).addFavorite(
                  id: item.id,
                  type: item.type,
                  name: item.name,
                  nameEn: item.nameEn,
                  imageUrl: item.imageUrl,
                  subtitle: item.subtitle,
                );
              },
            ),
          ),
        );
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
        child: InkWell(
          onTap: () => _navigateToItem(context, item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // صورة العنصر
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const ShimmerLoading(
                            width: 70,
                            height: 70,
                            borderRadius: 12,
                          ),
                          errorWidget: (_, __, ___) => _buildPlaceholder(item.type, isDark),
                        )
                      : _buildPlaceholder(item.type, isDark),
                ),
                const SizedBox(width: 16),
                // معلومات العنصر
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRTL ? item.name : (item.nameEn ?? item.name),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getColorForType(item.type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isRTL ? item.typeLabel : item.typeLabelEn,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getColorForType(item.type),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(item.addedAt, isRTL),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey[600] : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // زر المفضلة
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).removeFavorite(item.id, item.type);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(FavoriteType type, bool isDark) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: _getColorForType(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIconForType(type),
        color: _getColorForType(type),
        size: 30,
      ),
    );
  }

  IconData _getIconForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.product:
        return Icons.shopping_bag_outlined;
      case FavoriteType.exhibitor:
        return Icons.storefront_outlined;
      case FavoriteType.session:
        return Icons.event_outlined;
      case FavoriteType.speaker:
        return Icons.person_outline;
    }
  }

  Color _getColorForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.product:
        return Colors.teal;
      case FavoriteType.exhibitor:
        return AppColors.primary;
      case FavoriteType.session:
        return Colors.blue;
      case FavoriteType.speaker:
        return Colors.purple;
    }
  }

  String _getTypeLabelAr(FavoriteType type) {
    switch (type) {
      case FavoriteType.product:
        return 'منتجات';
      case FavoriteType.exhibitor:
        return 'عارضين';
      case FavoriteType.session:
        return 'جلسات';
      case FavoriteType.speaker:
        return 'متحدثين';
    }
  }

  String _getTypeLabelEn(FavoriteType type) {
    switch (type) {
      case FavoriteType.product:
        return 'products';
      case FavoriteType.exhibitor:
        return 'exhibitors';
      case FavoriteType.session:
        return 'sessions';
      case FavoriteType.speaker:
        return 'speakers';
    }
  }

  String _formatDate(DateTime date, bool isRTL) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return isRTL ? 'اليوم' : 'Today';
    } else if (diff.inDays == 1) {
      return isRTL ? 'أمس' : 'Yesterday';
    } else if (diff.inDays < 7) {
      return isRTL ? 'منذ ${diff.inDays} أيام' : '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _navigateToItem(BuildContext context, FavoriteItem item) {
    // TODO: Navigate to the appropriate screen based on item type
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${item.name}...')),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref, bool isRTL) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isRTL ? 'مسح المفضلة' : 'Clear Favorites'),
        content: Text(
          isRTL 
            ? 'هل أنت متأكد من مسح جميع العناصر المفضلة؟'
            : 'Are you sure you want to clear all favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isRTL ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(favoritesProvider.notifier).clearAllFavorites();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isRTL ? 'مسح' : 'Clear'),
          ),
        ],
      ),
    );
  }
}
