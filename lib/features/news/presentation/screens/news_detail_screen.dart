import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/news_article_model.dart';
import '../../../../models/news_category_model.dart';
import '../../../../services/news_service.dart';
import '../../providers/news_provider.dart';
import '../../providers/news_comments_provider.dart';
import '../widgets/news_comment_item.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final String articleId;

  const NewsDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _isLoadingLike = false;
  bool _isLoadingBookmark = false;
  String? _replyingToCommentId;
  String? _replyingToAuthorName;

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsDetailProvider(widget.articleId));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: newsAsync.when(
        data: (article) {
          // Update local state from article to sync with server state
          final articleIsLiked = article.isLiked ?? false;
          final articleIsBookmarked = article.isBookmarked ?? false;
          
          // Always sync local state with article state
          if (_isLiked != articleIsLiked || _isBookmarked != articleIsBookmarked) {
            // Update immediately in the next frame to avoid build conflicts
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLiked = articleIsLiked;
                  _isBookmarked = articleIsBookmarked;
                });
              }
            });
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(newsDetailProvider(widget.articleId));
              ref.invalidate(newsCommentsProvider(widget.articleId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(article),
                _buildContent(article),
                _buildActionButtons(article),
                _buildCommentsSection(),
              ],
            ),
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(
            backgroundColor: context.colors.surface,
            elevation: 0,
          ),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(
            backgroundColor: context.colors.surface,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل الخبر',
                  style: TextStyle(fontSize: 18, color: AppColors.error),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(newsDetailProvider(widget.articleId));
                  },
                  child: Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(NewsArticleModel article) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: context.colors.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: article.mainImage != null
            ? CachedNetworkImage(
                imageUrl: article.mainImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported),
                ),
              )
            : Container(color: context.colors.surfaceVariant),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () => _shareArticle(article),
        ),
      ],
    );
  }

  Widget _buildContent(NewsArticleModel article) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(int.parse(article.category.color.replaceFirst('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article.category.displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (article.isBreaking)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(20),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (article.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(20),
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
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              article.displayTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Meta info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.person, size: 16, color: context.colors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  article.authorName ?? 'مؤلف',
                  style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: context.colors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  article.timeAgo,
                  style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content
          if (article.displaySummary.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article.displaySummary,
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              article.displayContent,
              style: TextStyle(
                fontSize: 16,
                color: context.colors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Additional Images Gallery
          if (article.images != null && article.images!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: article.images!.length,
                      itemBuilder: (context, index) {
                        final imageUrl = article.images![index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Tags
          if (article.tags.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: article.tags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    backgroundColor: AppColors.surfaceVariant,
                    padding: const EdgeInsets.all(4),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(NewsArticleModel article) {
    // Use article.isLiked if available, otherwise fall back to local state
    final isLiked = article.isLiked ?? _isLiked;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: isLiked ? Icons.favorite : Icons.favorite_border,
              label: '${article.likes}',
              color: isLiked ? Colors.red : context.colors.textSecondary,
              iconColor: isLiked ? Colors.red : context.colors.textSecondary,
              isLiked: isLiked,
              onTap: () => _toggleLike(article.id),
              isLoading: _isLoadingLike,
            ),
            _buildActionButton(
              icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              label: 'حفظ',
              color: _isBookmarked ? AppColors.primary : context.colors.textSecondary,
              onTap: () => _toggleBookmark(article.id),
              isLoading: _isLoadingBookmark,
            ),
            _buildActionButton(
              icon: Icons.share,
              label: 'مشاركة',
              color: context.colors.textSecondary,
              onTap: () => _shareArticle(article),
            ),
            // Hide comments button if comments are hidden
            if (!article.hideComments)
              _buildActionButton(
                icon: Icons.comment,
                label: '${article.commentsCount}',
                color: context.colors.textSecondary,
                onTap: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
    Color? iconColor,
    bool? isLiked,
  }) {
    final finalIconColor = iconColor ?? color;
    final isLikedButton = icon == Icons.favorite || icon == Icons.favorite_border;
    final liked = isLiked ?? (isLikedButton && _isLiked);
    
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isLikedButton && liked 
              ? Colors.red.withOpacity(0.1) 
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(finalIconColor),
                    ),
                  )
                : Icon(
                    icon, 
                    color: finalIconColor, 
                    size: 24,
                    fill: isLikedButton && liked ? 1.0 : 0.0,
                  ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color, 
                fontSize: 12,
                fontWeight: isLikedButton && liked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    final newsAsync = ref.watch(newsDetailProvider(widget.articleId));
    
    return newsAsync.when(
      data: (article) {
        // If comments are hidden, don't show the section at all
        if (article.hideComments) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final commentsAsync = ref.watch(newsCommentsProvider(widget.articleId));

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 32),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'التعليقات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    commentsAsync.when(
                      data: (comments) => Text(
                        '${comments.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              // Add comment field - only show if comments are allowed
              if (article.allowComments) ...[
                // Main comment field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'أضف تعليقاً...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: AppColors.primary),
                        onPressed: () => _addComment(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Comments list
              commentsAsync.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'لا توجد تعليقات بعد',
                          style: TextStyle(color: context.colors.textSecondary),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return NewsCommentItem(
                        comment: comments[index],
                        onReply: (comment) {
                          setState(() {
                            _replyingToCommentId = comment.id;
                            _replyingToAuthorName = comment.authorName;
                          });
                        },
                        replyingToCommentId: _replyingToCommentId,
                        replyController: _replyController,
                        onSendReply: (commentId) {
                          _addReply(commentId);
                        },
                        onCancelReply: () {
                          setState(() {
                            _replyingToCommentId = null;
                            _replyingToAuthorName = null;
                            _replyController.clear();
                          });
                        },
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'حدث خطأ في تحميل التعليقات',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Future<void> _toggleLike(String articleId) async {
    if (_isLoadingLike) return;

    setState(() => _isLoadingLike = true);

    try {
      final service = NewsService();
      final result = await service.toggleLike(articleId);

      if (mounted) {
        setState(() {
          _isLiked = result['liked'] as bool;
          _isLoadingLike = false;
        });
        ref.invalidate(newsDetailProvider(articleId));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLike = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  Future<void> _toggleBookmark(String articleId) async {
    if (_isLoadingBookmark) return;

    setState(() => _isLoadingBookmark = true);

    try {
      final service = NewsService();
      final result = await service.toggleBookmark(articleId);

      if (mounted) {
        setState(() {
          _isBookmarked = result['bookmarked'] as bool;
          _isLoadingBookmark = false;
        });
        ref.invalidate(newsDetailProvider(articleId));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingBookmark = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  Future<void> _shareArticle(NewsArticleModel article) async {
    final text = '${article.displayTitle}\n\n${article.displaySummary}\n\n';
    await Share.share(text);
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      final service = NewsService();
      await service.addComment(widget.articleId, content);

      _commentController.clear();
      ref.invalidate(newsCommentsProvider(widget.articleId));
      ref.invalidate(newsDetailProvider(widget.articleId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة التعليق بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  Future<void> _addReply(String parentCommentId) async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    try {
      final service = NewsService();
      await service.addComment(widget.articleId, content, parentId: parentCommentId);

      setState(() {
        _replyingToCommentId = null;
        _replyingToAuthorName = null;
        _replyController.clear();
      });
      
      ref.invalidate(newsCommentsProvider(widget.articleId));
      ref.invalidate(newsDetailProvider(widget.articleId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة الرد بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }
}

