import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/news_article_model.dart';
import '../../../../models/news_category_model.dart';
import '../../providers/news_provider.dart';
import '../../providers/news_category_provider.dart';
import '../widgets/news_card_widget.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategoryId;
  String? _searchQuery;
  int _currentPage = 1;
  final int _limit = 20;
  late AnimationController _animationController;
  late AnimationController _breakingTextController;
  late Animation<double> _breakingTextAnimation;
  PageController? _featuredPageController;
  Timer? _featuredAutoPlayTimer;
  int _currentFeaturedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
    
    // Breaking news text animation - smooth and reversed direction
    _breakingTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _breakingTextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breakingTextController,
      curve: Curves.easeInOut, // Smoother animation
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _breakingTextController.dispose();
    _featuredPageController?.dispose();
    _featuredAutoPlayTimer?.cancel();
    super.dispose();
  }
  
  void _initFeaturedCarousel(int itemCount) {
    if (itemCount <= 1) return;
    
    // Cancel existing timer
    _featuredAutoPlayTimer?.cancel();
    
    // Dispose existing controller if any
    if (_featuredPageController != null) {
      _featuredPageController!.dispose();
    }
    
    // Create new controller
    _featuredPageController = PageController(initialPage: 0);
    _currentFeaturedIndex = 0;
    
    // Start auto-play timer
    _featuredAutoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _featuredPageController != null && _featuredPageController!.hasClients) {
        final nextIndex = (_currentFeaturedIndex + 1) % itemCount;
        _featuredPageController!.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
    
    // Force rebuild to show PageView
    if (mounted) {
      setState(() {});
    }
  }
  
  void _onFeaturedPageChanged(int index) {
    setState(() {
      _currentFeaturedIndex = index;
    });
  }

  NewsFilters get _filters => NewsFilters(
        page: _currentPage,
        limit: _limit,
        categoryId: _selectedCategoryId,
        search: _searchQuery,
        sortBy: 'publishedAt',
        sortOrder: 'desc',
      );

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsListProvider(_filters));
    final categoriesAsync = ref.watch(newsCategoriesProvider);
    final featuredAsync = ref.watch(featuredNewsProvider);
    final breakingAsync = ref.watch(breakingNewsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: newsAsync.when(
        data: (data) {
          final articles = (data['data'] as List<NewsArticleModel>);
          final total = data['total'] as int;
          final totalPages = data['totalPages'] as int;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(newsListProvider(_filters));
              ref.invalidate(featuredNewsProvider);
              ref.invalidate(breakingNewsProvider);
              ref.invalidate(newsCategoriesProvider);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                // Breaking news banner
                breakingAsync.when(
                  data: (breaking) => breaking.isEmpty
                      ? const SliverToBoxAdapter(child: SizedBox.shrink())
                      : _buildBreakingNewsBanner(breaking.first),
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                // Featured news section
                featuredAsync.when(
                  data: (featured) => featured.isEmpty
                      ? const SliverToBoxAdapter(child: SizedBox.shrink())
                      : _buildFeaturedSection(featured),
                  loading: () => _buildFeaturedSectionShimmer(),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                // Category filter
                categoriesAsync.when(
                  data: (categories) => categories.isEmpty
                      ? const SliverToBoxAdapter(child: SizedBox.shrink())
                      : _buildCategoryFilter(categories),
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
                // News list header
                if (articles.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'آخر الأخبار',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$total مقال',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // News list
                if (articles.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < articles.length) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 200 + (index * 30)),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(20 * (1 - value), 0),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildListCard(articles[index], index),
                              ),
                            );
                          } else if (index == articles.length &&
                              _currentPage < totalPages) {
                            // Load more
                            _loadMore();
                            return const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return null;
                        },
                        childCount: articles.length + (_currentPage < totalPages ? 1 : 0),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => Scaffold(
          appBar: _buildAppBar(),
          body: _buildLoadingState(),
        ),
        error: (error, stack) => Scaffold(
          appBar: _buildAppBar(),
          body: _buildErrorState(error),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      title: const Text(
        'الأخبار',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'ابحث في الأخبار...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
              suffixIcon: _searchQuery != null && _searchQuery!.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchQuery = null;
                          _currentPage = 1;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.isEmpty ? null : value;
                _currentPage = 1;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBreakingNewsBanner(NewsArticleModel breaking) {
    return SliverToBoxAdapter(
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (mounted) {
                context.push('/news/${breaking.id}');
              }
            },
            child: Row(
              children: [
                // Icon on the right
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: const Icon(Icons.whatshot, color: Colors.white, size: 20),
                ),
                // Scrolling text
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final text = breaking.displayTitle;
                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                      );
                      textPainter.layout(maxWidth: double.infinity);
                      
                      final containerWidth = constraints.maxWidth;
                      final textWidth = textPainter.width;
                      final shouldScroll = textWidth > containerWidth;
                      
                      if (!shouldScroll) {
                        // Show full text centered if it fits
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      
                      // Text is longer than container, so scroll it
                      return ClipRect(
                        child: AnimatedBuilder(
                          animation: _breakingTextAnimation,
                          builder: (context, child) {
                            // Calculate scroll animation (from left to right - reversed direction)
                            // Animation value goes from 0 to 1, we scroll from end to start (reversed)
                            final scrollRange = textWidth - containerWidth;
                            // Reverse direction: start from the end (1.0) and move to the beginning (0.0)
                            final reversedValue = 1.0 - _breakingTextAnimation.value;
                            final offset = scrollRange * reversedValue;
                            
                            return Transform.translate(
                              offset: Offset(-offset, 0),
                              child: SizedBox(
                                width: textWidth,
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(List<NewsArticleModel> featured) {
    final displayCount = featured.length > 5 ? 5 : featured.length;
    
    // Initialize carousel when section is built
    if (displayCount > 1 && _featuredPageController == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initFeaturedCarousel(displayCount);
        }
      });
    }
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.warning,
                            AppColors.warning.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warning.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'الأخبار المميزة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                if (featured.length > 5)
                  TextButton(
                    onPressed: () {
                      // يمكن إضافة فلتر للأخبار المميزة هنا
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios,
                            size: 12, color: AppColors.primary),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 140,
            child: displayCount > 1
                ? _featuredPageController != null
                    ? PageView.builder(
                        controller: _featuredPageController,
                        onPageChanged: _onFeaturedPageChanged,
                        itemCount: displayCount,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildFeaturedCardWithBackground(featured[index]),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildFeaturedCardWithBackground(featured[0]),
                      )
                : displayCount > 0
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildFeaturedCardWithBackground(featured[0]),
                      )
                    : const SizedBox.shrink(),
          ),
          // Page indicators
          Builder(
            builder: (context) {
              final displayCount = featured.length > 5 ? 5 : featured.length;
              if (displayCount <= 1) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    displayCount,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentFeaturedIndex == index
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFeaturedCardWithBackground(NewsArticleModel article) {
    final hasImage = article.mainImage != null && article.mainImage!.isNotEmpty;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image or gradient
            if (hasImage)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: article.mainImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            
            // Gradient overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (mounted) {
                    context.push('/news/${article.id}');
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Category badge
                      Builder(
                        builder: (context) {
                          Color categoryColor = AppColors.primary;
                          try {
                            if (article.category.color.isNotEmpty) {
                              final colorString = article.category.color.replaceFirst('#', '0xFF');
                              categoryColor = Color(int.parse(colorString));
                            }
                          } catch (e) {
                            categoryColor = AppColors.primary;
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  categoryColor,
                                  categoryColor.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: categoryColor.withOpacity(0.3),
                                  blurRadius: 6,
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
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      // Title and meta
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              article.displayTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 11, color: Colors.white.withOpacity(0.9)),
                                const SizedBox(width: 4),
                                Text(
                                  article.timeAgo,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.favorite_border, size: 11, color: Colors.white.withOpacity(0.9)),
                                const SizedBox(width: 4),
                                Text(
                                  '${article.likes}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSectionShimmer() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<NewsCategoryModel> categories) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              final isSelected = _selectedCategoryId == null;
              return _buildCategoryChip(
                label: 'الكل',
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                    _currentPage = 1;
                  });
                },
              );
            }
            final category = categories[index - 1];
            final isSelected = _selectedCategoryId == category.id;
            return _buildCategoryChip(
              label: category.displayName,
              isSelected: isSelected,
              color: Color(int.parse(category.color.replaceFirst('#', '0xFF'))),
              onTap: () {
                setState(() {
                  _selectedCategoryId = isSelected ? null : category.id;
                  _currentPage = 1;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: FilterChip(
          selected: isSelected,
          label: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? (color ?? AppColors.primary)
                  : AppColors.textPrimary,
            ),
          ),
          avatar: color != null
              ? CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  radius: 12,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
          backgroundColor: AppColors.surface,
          selectedColor: (color ?? AppColors.primary).withOpacity(0.1),
          side: BorderSide(
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          elevation: isSelected ? 2 : 0,
          onSelected: (_) => onTap(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.article_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد أخبار',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'حدث خطأ في تحميل الأخبار',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'يرجى المحاولة مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(newsListProvider(_filters));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(NewsArticleModel article, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (mounted) {
            context.push('/news/${article.id}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                child: SizedBox(
                  width: 120,
                  height: 140,
                  child: article.mainImage != null
                      ? CachedNetworkImage(
                          imageUrl: article.mainImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.border,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.border,
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Container(
                          width: 120,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withOpacity(0.3),
                                AppColors.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.article,
                            size: 40,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category badge
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              Color categoryColor = AppColors.primary;
                              try {
                                if (article.category.color.isNotEmpty) {
                                  final colorString = article.category.color.replaceFirst('#', '0xFF');
                                  categoryColor = Color(int.parse(colorString));
                                }
                              } catch (e) {
                                categoryColor = AppColors.primary;
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      categoryColor,
                                      categoryColor.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  article.category.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (article.isBreaking) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade700, Colors.red.shade600],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.whatshot, color: Colors.white, size: 10),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        article.displayTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Summary or content
                      if ((article.displaySummary.isNotEmpty) ||
                          (article.displayContent.isNotEmpty)) ...[
                        const SizedBox(height: 6),
                        Text(
                          article.displaySummary.isNotEmpty
                              ? article.displaySummary
                              : (article.displayContent.isNotEmpty
                                  ? (article.displayContent.length > 100
                                      ? '${article.displayContent.substring(0, 100)}...'
                                      : article.displayContent)
                                  : ''),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary.withOpacity(0.8),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // Meta info
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            article.timeAgo,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.favorite_border, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${article.likes}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.comment_outlined, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${article.commentsCount}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadMore() {
    // TODO: Implement pagination loading
    // This will be handled by the provider or a state notifier
  }
}