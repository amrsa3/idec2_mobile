import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'course_details_screen.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Tabs
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
                        const Text(
                          'الدورات التدريبية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'استكشف برامجنا التدريبية المميزة',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'الكل'),
                Tab(text: 'القادمة'),
                Tab(text: 'المكتملة'),
              ],
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllCoursesTab(),
                  _buildUpcomingCoursesTab(),
                  _buildCompletedCoursesTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCoursesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCourseCard(
          title: 'تقنيات تبييض الأسنان الحديثة',
          instructor: 'د. سارة القحطاني',
          date: '26 أكتوبر 2026',
          time: '10:00 صباحاً',
          duration: 'ساعتان',
          level: 'متقدم',
          imageUrl: 'https://picsum.photos/400/300?random=1',
          registered: true,
        ),
        const SizedBox(height: 16),
        _buildCourseCard(
          title: 'التصوير الرقمي في طب الأسنان',
          instructor: 'د. عمر الهاشمي',
          date: '25 أكتوبر 2026',
          time: '2:00 ظهراً',
          duration: '3 ساعات',
          level: 'مبتدئ',
          imageUrl: 'https://picsum.photos/400/300?random=2',
          registered: false,
        ),
        const SizedBox(height: 16),
        _buildCourseCard(
          title: 'إدارة عيادات الأسنان بنجاح',
          instructor: 'أ. خالد العمري',
          date: '27 أكتوبر 2026',
          time: '4:00 عصراً',
          duration: 'ساعتان',
          level: 'متوسط',
          imageUrl: 'https://picsum.photos/400/300?random=3',
          registered: true,
        ),
      ],
    );
  }

  Widget _buildUpcomingCoursesTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد دورات قادمة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم إضافة الدورات القادمة قريباً',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCoursesTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد دورات مكتملة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ستظهر الدورات المكتملة هنا',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String instructor,
    required String date,
    required String time,
    required String duration,
    required String level,
    required String imageUrl,
    required bool registered,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsScreen(
                courseId: '1',
                courseTitle: title,
                instructor: instructor,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: AppColors.primary,
                        child: const Icon(Icons.image_outlined,
                            color: Colors.white, size: 60),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Instructor
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          instructor,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date & Time
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '$date - $time',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Duration
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle registration
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            registered ? Colors.green : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              registered
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            registered ? 'مسجل' : 'سجل الآن',
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
          ],
        ),
      ),
    );
  }
}
