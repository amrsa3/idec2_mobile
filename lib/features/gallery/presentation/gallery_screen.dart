import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../models/gallery_album_model.dart';
import 'gallery_album_view.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<String> _categories = ['الكل', 'المؤتمر', 'المعرض', 'الورش'];

  final List<GalleryAlbumModel> _albums = [
    GalleryAlbumModel(
      id: '1',
      title: 'اليوم الأول',
      description: 'صور المؤتمر - اليوم الأول',
      coverImageUrl: 'https://picsum.photos/400/300?random=1',
      photoCount: 45,
      category: 'conference',
    ),
    GalleryAlbumModel(
      id: '2',
      title: 'اليوم الثاني',
      description: 'صور المؤتمر - اليوم الثاني',
      coverImageUrl: 'https://picsum.photos/400/300?random=2',
      photoCount: 38,
      category: 'conference',
    ),
    GalleryAlbumModel(
      id: '3',
      title: 'اليوم الثالث',
      description: 'صور المؤتمر - اليوم الثالث',
      coverImageUrl: 'https://picsum.photos/400/300?random=3',
      photoCount: 42,
      category: 'conference',
    ),
    GalleryAlbumModel(
      id: '4',
      title: 'المعرض التجاري',
      description: 'صور المعرض التجاري',
      coverImageUrl: 'https://picsum.photos/400/300?random=4',
      photoCount: 28,
      category: 'exhibition',
    ),
    GalleryAlbumModel(
      id: '5',
      title: 'مؤتمر 2024',
      description: 'الاحتفال بافتتاح المؤتمر',
      coverImageUrl: 'https://picsum.photos/400/300?random=5',
      photoCount: 52,
      category: 'conference',
    ),
    GalleryAlbumModel(
      id: '6',
      title: 'مؤتمر 2025',
      description: 'مؤتمر العام الحالي',
      coverImageUrl: 'https://picsum.photos/400/300?random=6',
      photoCount: 60,
      category: 'conference',
    ),
    GalleryAlbumModel(
      id: '7',
      title: 'ورشة العمل الأولى',
      description: 'ورشة عمل تبييض الأسنان',
      coverImageUrl: 'https://picsum.photos/400/300?random=7',
      photoCount: 24,
      category: 'workshops',
    ),
    GalleryAlbumModel(
      id: '8',
      title: 'ورشة العمل الثانية',
      description: 'ورشة عمل التقنيات الحديثة',
      coverImageUrl: 'https://picsum.photos/400/300?random=8',
      photoCount: 19,
      category: 'workshops',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<GalleryAlbumModel> get _filteredAlbums {
    if (_selectedTabIndex == 0) {
      return _albums;
    }

    String categoryFilter = '';
    switch (_selectedTabIndex) {
      case 1:
        categoryFilter = 'conference';
        break;
      case 2:
        categoryFilter = 'exhibition';
        break;
      case 3:
        categoryFilter = 'workshops';
        break;
    }

    return _albums.where((album) => album.category == categoryFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'معرض الصور',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_albums.length} ألبوم • ${_albums.fold<int>(0, (sum, album) => sum + album.photoCount)} صورة',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
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
              ),
            ),
          ),

          // Category Filter Tabs
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs:
                    _categories.map((category) => Tab(text: category)).toList(),
              ),
            ),
          ),

          // Albums Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _filteredAlbums.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 80,
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد ألبومات',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final album = _filteredAlbums[index];
                        return _buildAlbumCard(context, album);
                      },
                      childCount: _filteredAlbums.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumCard(BuildContext context, GalleryAlbumModel album) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryAlbumView(album: album),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    album.coverImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary,
                        child: const Icon(Icons.image,
                            color: Colors.white, size: 60),
                      );
                    },
                  ),
                  // Gradient Overlay
                  Container(
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
                  // Photo Count Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo,
                              size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${album.photoCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Album Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        album.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
}
