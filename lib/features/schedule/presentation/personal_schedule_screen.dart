import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/language_provider.dart';
import '../../../shared/widgets/animated_widgets.dart';
import '../providers/personal_schedule_provider.dart';

class PersonalScheduleScreen extends ConsumerStatefulWidget {
  const PersonalScheduleScreen({super.key});

  @override
  ConsumerState<PersonalScheduleScreen> createState() => _PersonalScheduleScreenState();
}

class _PersonalScheduleScreenState extends ConsumerState<PersonalScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

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
    final scheduleState = ref.watch(personalScheduleProvider);
    final isRTL = ref.watch(isRTLProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      appBar: AppBar(
        title: Text(
          isRTL ? 'جدولي الشخصي' : 'My Schedule',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey[600],
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.upcoming, size: 18),
                  const SizedBox(width: 6),
                  Text(isRTL ? 'القادمة' : 'Upcoming'),
                  if (scheduleState.upcomingCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge(scheduleState.upcomingCount),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 6),
                  Text(isRTL ? 'التقويم' : 'Calendar'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history, size: 18),
                  const SizedBox(width: 6),
                  Text(isRTL ? 'السابقة' : 'Past'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: scheduleState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSessionsList(
                  scheduleState.upcomingSessions,
                  isRTL,
                  isDark,
                  isRTL ? 'لا توجد جلسات قادمة' : 'No upcoming sessions',
                ),
                _buildCalendarView(scheduleState, isRTL, isDark),
                _buildSessionsList(
                  scheduleState.pastSessions,
                  isRTL,
                  isDark,
                  isRTL ? 'لا توجد جلسات سابقة' : 'No past sessions',
                ),
              ],
            ),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
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
    );
  }

  Widget _buildSessionsList(
    List<ScheduleSession> sessions,
    bool isRTL,
    bool isDark,
    String emptyMessage,
  ) {
    if (sessions.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: emptyMessage,
        subtitle: isRTL
            ? 'أضف جلسات من برنامج المؤتمر إلى جدولك الشخصي'
            : 'Add sessions from the conference program to your personal schedule',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return AnimatedListCard(
          index: index,
          child: _buildSessionCard(session, isRTL, isDark),
        );
      },
    );
  }

  Widget _buildSessionCard(ScheduleSession session, bool isRTL, bool isDark) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEEE, d MMMM', isRTL ? 'ar' : 'en');

    return Dismissible(
      key: Key(session.sessionId),
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
        ref.read(personalScheduleProvider.notifier).removeFromSchedule(session.sessionId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isRTL ? 'تم إزالة الجلسة من الجدول' : 'Session removed from schedule'),
            action: SnackBarAction(
              label: isRTL ? 'تراجع' : 'Undo',
              onPressed: () {
                ref.read(personalScheduleProvider.notifier).addToSchedule(
                  sessionId: session.sessionId,
                  title: session.title,
                  titleEn: session.titleEn,
                  speakerName: session.speakerName,
                  location: session.location,
                  startTime: session.startTime,
                  endTime: session.endTime,
                  imageUrl: session.imageUrl,
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
          border: session.isOngoing
              ? Border.all(color: Colors.green, width: 2)
              : null,
        ),
        child: InkWell(
          onTap: () => _showSessionDetails(context, session, isRTL, isDark),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مؤشر الوقت
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: session.isOngoing
                            ? Colors.green
                            : (session.isPast ? Colors.grey : AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            timeFormat.format(session.startTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            width: 1,
                            height: 8,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Text(
                            timeFormat.format(session.endTime),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (session.isOngoing)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isRTL ? 'الآن' : 'LIVE',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // معلومات الجلسة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(session.startTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isRTL ? session.title : (session.titleEn ?? session.title),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (session.speakerName != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                session.speakerName!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (session.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                session.location!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // زر التذكير
                IconButton(
                  icon: Icon(
                    session.hasReminder
                        ? Icons.notifications_active
                        : Icons.notifications_outlined,
                    color: session.hasReminder ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    ref.read(personalScheduleProvider.notifier)
                        .toggleReminder(session.sessionId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          session.hasReminder
                              ? (isRTL ? 'تم إلغاء التذكير' : 'Reminder cancelled')
                              : (isRTL ? 'تم تفعيل التذكير' : 'Reminder set'),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(PersonalScheduleState state, bool isRTL, bool isDark) {
    final sessionsByDay = state.sessionsByDay;
    final dates = sessionsByDay.keys.toList()..sort();

    if (dates.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_month_outlined,
        title: isRTL ? 'لا توجد جلسات' : 'No sessions',
        subtitle: isRTL
            ? 'جدولك فارغ، أضف جلسات للبدء'
            : 'Your schedule is empty, add sessions to get started',
      );
    }

    return Column(
      children: [
        // Calendar Header with date picker
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: dates.isNotEmpty && dates.first.isBefore(_selectedDate)
                    ? () => setState(() {
                          final index = dates.indexWhere((d) =>
                              d.year == _selectedDate.year &&
                              d.month == _selectedDate.month &&
                              d.day == _selectedDate.day);
                          if (index > 0) {
                            _selectedDate = dates[index - 1];
                          }
                        })
                    : null,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE', isRTL ? 'ar' : 'en').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy', isRTL ? 'ar' : 'en').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: dates.isNotEmpty && dates.last.isAfter(_selectedDate)
                    ? () => setState(() {
                          final index = dates.indexWhere((d) =>
                              d.year == _selectedDate.year &&
                              d.month == _selectedDate.month &&
                              d.day == _selectedDate.day);
                          if (index < dates.length - 1) {
                            _selectedDate = dates[index + 1];
                          }
                        })
                    : null,
              ),
            ],
          ),
        ),

        // Date chips
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE', isRTL ? 'ar' : 'en').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : (isDark ? Colors.grey[500] : Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Sessions for selected date
        Expanded(
          child: _buildSessionsList(
            state.getSessionsByDate(_selectedDate),
            isRTL,
            isDark,
            isRTL ? 'لا توجد جلسات في هذا اليوم' : 'No sessions on this day',
          ),
        ),
      ],
    );
  }

  void _showSessionDetails(
    BuildContext context,
    ScheduleSession session,
    bool isRTL,
    bool isDark,
  ) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', isRTL ? 'ar' : 'en');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              Text(
                isRTL ? session.title : (session.titleEn ?? session.title),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Time info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.calendar_today,
                      dateFormat.format(session.startTime),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.access_time,
                      '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime)}',
                      isDark,
                    ),
                    if (session.location != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        session.location!,
                        isDark,
                      ),
                    ],
                    if (session.speakerName != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.person_outline,
                        session.speakerName!,
                        isDark,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(personalScheduleProvider.notifier)
                            .toggleReminder(session.sessionId);
                      },
                      icon: Icon(
                        session.hasReminder
                            ? Icons.notifications_active
                            : Icons.notifications_outlined,
                      ),
                      label: Text(
                        session.hasReminder
                            ? (isRTL ? 'إلغاء التذكير' : 'Cancel Reminder')
                            : (isRTL ? 'تفعيل التذكير' : 'Set Reminder'),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(personalScheduleProvider.notifier)
                            .removeFromSchedule(session.sessionId);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: Text(isRTL ? 'إزالة' : 'Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
