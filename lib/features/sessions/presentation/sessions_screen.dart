import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';
import '../../../services/conference_service.dart';
import '../../../services/session_service.dart';

// Provider for conference sessions
final conferenceSessionsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, conferenceId) async {
  final sessionService = SessionService();
  return await sessionService.getConferenceSessions(
    conferenceId: conferenceId,
    page: 1,
    limit: 100,
  );
});

// Provider for active conference
final activeConferenceForSessionsProvider = FutureProvider((ref) async {
  final conferenceService = ConferenceService();
  return await conferenceService.getActiveConference();
});

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conferenceAsync = ref.watch(activeConferenceForSessionsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'الجلسات',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
      ),
      body: conferenceAsync.when(
        data: (conference) {
          if (conference == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا يوجد مؤتمر نشط',
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final sessionsAsync = ref.watch(conferenceSessionsProvider(conference.id));

          return sessionsAsync.when(
            data: (data) {
              final sessions = (data['data'] as List<SessionModel>);

              if (sessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note,
                        size: 80,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد جلسات متاحة',
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group sessions by date
              final groupedSessions = <String, List<SessionModel>>{};
              for (final session in sessions) {
                final dateKey = DateFormat('yyyy-MM-dd').format(session.startTime);
                groupedSessions.putIfAbsent(dateKey, () => []).add(session);
              }

              final sortedDates = groupedSessions.keys.toList()..sort();

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(conferenceSessionsProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final daySessions = groupedSessions[date]!;
                    daySessions.sort((a, b) => a.startTime.compareTo(b.startTime));

                    return _buildDateSection(context, date, daySessions);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              print('❌ [SESSIONS_SCREEN] Error: $error');
              print('❌ [SESSIONS_SCREEN] Stack: $stack');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ في تحميل الجلسات',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        if (conference != null) {
                          ref.invalidate(conferenceSessionsProvider(conference.id));
                        }
                      },
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print('❌ [SESSIONS_SCREEN] Conference error: $error');
          print('❌ [SESSIONS_SCREEN] Stack: $stack');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل المؤتمر',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref.invalidate(activeConferenceForSessionsProvider);
                  },
                  child: Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSection(
      BuildContext context, String dateKey, List<SessionModel> sessions) {
    final date = DateTime.parse(dateKey);
    final dayName = DateFormat('EEEE', 'ar').format(date);
    final dayNumber = date.day;
    final monthName = DateFormat('MMMM', 'ar').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Sessions list
        ...sessions.map((session) => _buildSessionCard(context, session)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, SessionModel session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              session.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (session.description != null) ...[
              const SizedBox(height: 8),
              Text(
                session.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            // Time and info
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 18, color: context.colors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  session.formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
            if (session.location != null && session.location!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 18, color: context.colors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      session.location!,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (session.speakersCountValue > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 18, color: context.colors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    '${session.speakersCountValue} متحدث',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            if (session.capacity != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people, size: 18, color: context.colors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'السعة: ${session.capacity} شخص',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            if (session.event != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event, size: 14, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(
                      session.event!['title'] as String? ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

