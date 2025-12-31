import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/platform_storage_service.dart';

/// نموذج جلسة في الجدول الشخصي
class ScheduleSession {
  final String sessionId;
  final String title;
  final String? titleEn;
  final String? speakerName;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;
  final bool hasReminder;
  final int? reminderMinutes;
  final DateTime addedAt;

  const ScheduleSession({
    required this.sessionId,
    required this.title,
    this.titleEn,
    this.speakerName,
    this.location,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
    this.hasReminder = false,
    this.reminderMinutes,
    required this.addedAt,
  });

  ScheduleSession copyWith({
    String? sessionId,
    String? title,
    String? titleEn,
    String? speakerName,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    String? imageUrl,
    bool? hasReminder,
    int? reminderMinutes,
    DateTime? addedAt,
  }) {
    return ScheduleSession(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      speakerName: speakerName ?? this.speakerName,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      imageUrl: imageUrl ?? this.imageUrl,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Duration get duration => endTime.difference(startTime);
  String get durationText {
    final mins = duration.inMinutes;
    if (mins >= 60) {
      final hours = mins ~/ 60;
      final remainingMins = mins % 60;
      if (remainingMins == 0) {
        return '$hours ساعة';
      }
      return '$hours ساعة و $remainingMins دقيقة';
    }
    return '$mins دقيقة';
  }

  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isOngoing => DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime);
  bool get isPast => endTime.isBefore(DateTime.now());

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'title': title,
        'titleEn': titleEn,
        'speakerName': speakerName,
        'location': location,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'imageUrl': imageUrl,
        'hasReminder': hasReminder,
        'reminderMinutes': reminderMinutes,
        'addedAt': addedAt.toIso8601String(),
      };

  factory ScheduleSession.fromJson(Map<String, dynamic> json) => ScheduleSession(
        sessionId: json['sessionId'] ?? '',
        title: json['title'] ?? '',
        titleEn: json['titleEn'],
        speakerName: json['speakerName'],
        location: json['location'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        imageUrl: json['imageUrl'],
        hasReminder: json['hasReminder'] ?? false,
        reminderMinutes: json['reminderMinutes'],
        addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      );
}

/// حالة الجدول الشخصي
class PersonalScheduleState {
  final List<ScheduleSession> sessions;
  final bool isLoading;
  final String? error;
  final DateTime? selectedDate;

  const PersonalScheduleState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
    this.selectedDate,
  });

  PersonalScheduleState copyWith({
    List<ScheduleSession>? sessions,
    bool? isLoading,
    String? error,
    DateTime? selectedDate,
  }) {
    return PersonalScheduleState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  bool isInSchedule(String sessionId) {
    return sessions.any((s) => s.sessionId == sessionId);
  }

  List<ScheduleSession> get upcomingSessions =>
      sessions.where((s) => s.isUpcoming).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<ScheduleSession> get ongoingSessions =>
      sessions.where((s) => s.isOngoing).toList();

  List<ScheduleSession> get pastSessions =>
      sessions.where((s) => s.isPast).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));

  List<ScheduleSession> getSessionsByDate(DateTime date) {
    return sessions.where((s) =>
        s.startTime.year == date.year &&
        s.startTime.month == date.month &&
        s.startTime.day == date.day).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Map<DateTime, List<ScheduleSession>> get sessionsByDay {
    final map = <DateTime, List<ScheduleSession>>{};
    for (final session in sessions) {
      final dateKey = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      if (!map.containsKey(dateKey)) {
        map[dateKey] = [];
      }
      map[dateKey]!.add(session);
    }
    return map;
  }

  ScheduleSession? get nextSession {
    final upcoming = upcomingSessions;
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  int get totalCount => sessions.length;
  int get upcomingCount => upcomingSessions.length;
}

/// Notifier للجدول الشخصي
class PersonalScheduleNotifier extends StateNotifier<PersonalScheduleState> {
  static const String _storageKey = 'personal_schedule';

  PersonalScheduleNotifier() : super(const PersonalScheduleState()) {
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    state = state.copyWith(isLoading: true);
    try {
      final storage = PlatformStorageService.instance;
      final data = await storage.getString(_storageKey);
      
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
        final sessions = jsonList
            .map((json) => ScheduleSession.fromJson(json as Map<String, dynamic>))
            .toList();
        
        state = state.copyWith(sessions: sessions, isLoading: false);
        debugPrint('✅ [SCHEDULE] Loaded ${sessions.length} sessions');
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('❌ [SCHEDULE] Error loading schedule: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _saveSchedule() async {
    try {
      final storage = PlatformStorageService.instance;
      final jsonList = state.sessions.map((s) => s.toJson()).toList();
      await storage.setString(_storageKey, jsonEncode(jsonList));
      debugPrint('✅ [SCHEDULE] Saved ${state.sessions.length} sessions');
    } catch (e) {
      debugPrint('❌ [SCHEDULE] Error saving schedule: $e');
    }
  }

  /// إضافة جلسة للجدول
  Future<void> addToSchedule({
    required String sessionId,
    required String title,
    String? titleEn,
    String? speakerName,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    String? imageUrl,
    bool setReminder = false,
    int reminderMinutes = 15,
  }) async {
    if (state.isInSchedule(sessionId)) {
      debugPrint('⚠️ [SCHEDULE] Session already in schedule: $sessionId');
      return;
    }

    final newSession = ScheduleSession(
      sessionId: sessionId,
      title: title,
      titleEn: titleEn,
      speakerName: speakerName,
      location: location,
      startTime: startTime,
      endTime: endTime,
      imageUrl: imageUrl,
      hasReminder: setReminder,
      reminderMinutes: setReminder ? reminderMinutes : null,
      addedAt: DateTime.now(),
    );

    state = state.copyWith(sessions: [...state.sessions, newSession]);
    await _saveSchedule();

    // إنشاء تذكير إذا كان مفعل
    if (setReminder) {
      await _scheduleReminder(newSession);
    }

    debugPrint('✅ [SCHEDULE] Added session: $title');
  }

  /// إزالة جلسة من الجدول
  Future<void> removeFromSchedule(String sessionId) async {
    final updatedSessions = state.sessions
        .where((s) => s.sessionId != sessionId)
        .toList();
    
    state = state.copyWith(sessions: updatedSessions);
    await _saveSchedule();
    debugPrint('✅ [SCHEDULE] Removed session: $sessionId');
  }

  /// تبديل حالة الجلسة في الجدول
  Future<bool> toggleSchedule({
    required String sessionId,
    required String title,
    String? titleEn,
    String? speakerName,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    String? imageUrl,
  }) async {
    if (state.isInSchedule(sessionId)) {
      await removeFromSchedule(sessionId);
      return false;
    } else {
      await addToSchedule(
        sessionId: sessionId,
        title: title,
        titleEn: titleEn,
        speakerName: speakerName,
        location: location,
        startTime: startTime,
        endTime: endTime,
        imageUrl: imageUrl,
      );
      return true;
    }
  }

  /// تفعيل/إلغاء التذكير
  Future<void> toggleReminder(String sessionId, {int reminderMinutes = 15}) async {
    final index = state.sessions.indexWhere((s) => s.sessionId == sessionId);
    if (index < 0) return;

    final session = state.sessions[index];
    final updatedSession = session.copyWith(
      hasReminder: !session.hasReminder,
      reminderMinutes: !session.hasReminder ? reminderMinutes : null,
    );

    final updatedSessions = [...state.sessions];
    updatedSessions[index] = updatedSession;
    
    state = state.copyWith(sessions: updatedSessions);
    await _saveSchedule();

    if (updatedSession.hasReminder) {
      await _scheduleReminder(updatedSession);
    } else {
      await _cancelReminder(sessionId);
    }
  }

  /// تحديد تاريخ معين لعرضه
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// مسح الجدول
  Future<void> clearSchedule() async {
    state = state.copyWith(sessions: []);
    await _saveSchedule();
    debugPrint('✅ [SCHEDULE] Schedule cleared');
  }

  // إنشاء تذكير محلي
  Future<void> _scheduleReminder(ScheduleSession session) async {
    // TODO: استخدام flutter_local_notifications لإنشاء تذكير
    debugPrint('🔔 [SCHEDULE] Reminder scheduled for: ${session.title}');
  }

  // إلغاء تذكير
  Future<void> _cancelReminder(String sessionId) async {
    // TODO: إلغاء التذكير
    debugPrint('🔕 [SCHEDULE] Reminder cancelled for: $sessionId');
  }
}

/// Provider للجدول الشخصي
final personalScheduleProvider =
    StateNotifierProvider<PersonalScheduleNotifier, PersonalScheduleState>((ref) {
  return PersonalScheduleNotifier();
});

/// Provider للتحقق من جلسة في الجدول
final isInScheduleProvider = Provider.family<bool, String>((ref, sessionId) {
  return ref.watch(personalScheduleProvider).isInSchedule(sessionId);
});

/// Provider للجلسة القادمة
final nextSessionProvider = Provider<ScheduleSession?>((ref) {
  return ref.watch(personalScheduleProvider).nextSession;
});

/// Provider لعدد الجلسات القادمة
final upcomingSessionsCountProvider = Provider<int>((ref) {
  return ref.watch(personalScheduleProvider).upcomingCount;
});
