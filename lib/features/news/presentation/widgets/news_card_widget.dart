import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/news_article_model.dart';
import '../../../../models/news_category_model.dart';

class NewsCardWidget extends StatelessWidget {
  final NewsArticleModel article;
  final VoidCallback? onTap;
  final bool isFeaturedCard;

  const NewsCardWidget({
    super.key,
    required this.article,
    this.onTap,
    this.isFeaturedCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isFeaturedCard ? 2 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isFeaturedCard ? 12 : 16),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: AppColors.surface,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isFeaturedCard ? 12 : 16),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Featured Image with category badge
            if (article.mainImage != null) _buildImageSection(),
            // Content
            Padding(
              padding: EdgeInsets.all(isFeaturedCard ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category and Breaking badges (only show if not in image)
                  if (article.mainImage == null) ...[
                    _buildBadges(),
                    const SizedBox(height: 8),
                  ],
                    // Title
                    Text(
                      article.displayTitle,
                      style: TextStyle(
                        fontSize: isFeaturedCard ? 13 : 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: isFeaturedCard ? 2 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Show summary or first part of content
                    if (!isFeaturedCard) ...[
                      const SizedBox(height: 8),
                      Text(
                        article.displaySummary.isNotEmpty 
                            ? article.displaySummary 
                            : (article.displayContent.isNotEmpty && article.displayContent.length > 150
                                ? '${article.displayContent.substring(0, 150)}...' 
                                : article.displayContent.isNotEmpty ? article.displayContent : ''),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: isFeaturedCard ? 8 : 12),
                    // Meta info
                    _buildMetaInfo(isCompact: isFeaturedCard),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: CachedNetworkImage(
            imageUrl: article.mainImage!,
            height: isFeaturedCard ? 120 : 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: isFeaturedCard ? 120 : 200,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: isFeaturedCard ? 120 : 200,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        // Category badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Color(int.parse(article.category.color.replaceFirst('#', '0xFF'))),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              article.category.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        // Breaking badge
        if (article.isBreaking)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade700.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.whatshot, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'عاجل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      children: [
        if (article.isFeatured)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'مميز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMetaInfo({bool isCompact = false}) {
    if (isCompact) {
      // تصميم مدمج للأخبار المميزة
      return Row(
        children: [
          Icon(Icons.access_time, size: 11, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              article.timeAgo,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, size: 11, color: AppColors.textSecondary),
              const SizedBox(width: 2),
              Text(
                '${article.likes}',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              Icon(Icons.comment, size: 11, color: AppColors.textSecondary),
              const SizedBox(width: 2),
              Text(
                '${article.commentsCount}',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      );
    }
    
    // التصميم الكامل للأخبار العادية
    return Row(
      children: [
        Icon(Icons.visibility, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '${article.views}',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 16),
        Icon(Icons.favorite, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '${article.likes}',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 16),
        Icon(Icons.comment, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '${article.commentsCount}',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          article.timeAgo,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

