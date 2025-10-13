import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_rule_model.dart';
import '../services/profile_rules_service.dart';

/// حالة قواعد الملف الشخصي
class ProfileRulesState {
  final List<ProfileRuleModel> rules;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const ProfileRulesState({
    this.rules = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  ProfileRulesState copyWith({
    List<ProfileRuleModel>? rules,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return ProfileRulesState(
      rules: rules ?? this.rules,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Provider لإدارة قواعد الملف الشخصي
class ProfileRulesNotifier extends StateNotifier<ProfileRulesState> {
  final ProfileRulesService _rulesService;

  ProfileRulesNotifier(this._rulesService) : super(const ProfileRulesState());

  /// جلب القواعد للمستخدم الحالي (يتم فحص الحالة تلقائياً في الخادم)
  Future<void> loadRulesForCurrentUser({bool forceRefresh = false}) async {
    try {
      debugPrint(
          '🔄 [PROFILE_RULES_PROVIDER] بدء تحميل قواعد المستخدم الحالي (forceRefresh: $forceRefresh)');
      state = state.copyWith(isLoading: true, error: null);

      final result = await _rulesService.getRulesForCurrentUser(
          forceRefresh: forceRefresh);

      debugPrint(
          '✅ [PROFILE_RULES_PROVIDER] تم تحميل ${result.rules.length} قاعدة للمستخدم (الحالة: ${result.userStatus.name})');

      // طباعة تفاصيل القواعد المحملة
      for (var rule in result.rules) {
        debugPrint(
            '   - قاعدة: ${rule.fieldName} (${rule.targetStatus}) - يسمح بالتعديل: ${rule.allowEdit}');
      }

      state = state.copyWith(
        rules: result.rules,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint(
          '❌ [PROFILE_RULES_PROVIDER] خطأ في جلب قواعد المستخدم الحالي: $e');
      state = state.copyWith(
        isLoading: false,
        error:
            'فشل في جلب قواعد التعديل من الخادم. يرجى التأكد من الاتصال بالإنترنت والمحاولة مرة أخرى.',
      );
    }
  }

  /// جلب القواعد حسب حالة معينة (للاستخدام الإداري)
  Future<void> loadRulesForStatus(ProfileStatus status,
      {bool forceRefresh = false}) async {
    try {
      debugPrint(
          '🔄 [PROFILE_RULES_PROVIDER] بدء تحميل قواعد الحالة ${status.name} (forceRefresh: $forceRefresh)');
      state = state.copyWith(isLoading: true, error: null);

      final rules = await _rulesService.getRulesForStatus(status,
          forceRefresh: forceRefresh);

      debugPrint(
          '✅ [PROFILE_RULES_PROVIDER] تم تحميل ${rules.length} قاعدة للحالة ${status.name}');

      // طباعة تفاصيل القواعد المحملة
      for (var rule in rules) {
        debugPrint(
            '   - قاعدة: ${rule.fieldName} (${rule.targetStatus}) - يسمح بالتعديل: ${rule.allowEdit}');
      }

      state = state.copyWith(
        rules: rules,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint(
          '❌ [PROFILE_RULES_PROVIDER] خطأ في جلب قواعد الحالة ${status.name}: $e');
      state = state.copyWith(
        isLoading: false,
        error:
            'فشل في جلب قواعد التعديل من الخادم. يرجى التأكد من الاتصال بالإنترنت والمحاولة مرة أخرى.',
      );
    }
  }

  /// جلب جميع القواعد (للتوافق مع الكود القديم)
  Future<void> loadRules({bool forceRefresh = false}) async {
    try {
      debugPrint(
          '🔄 [PROFILE_RULES_PROVIDER] بدء تحميل جميع القواعد (forceRefresh: $forceRefresh)');
      state = state.copyWith(isLoading: true, error: null);

      final rules =
          await _rulesService.getActiveRules(forceRefresh: forceRefresh);

      debugPrint(
          '✅ [PROFILE_RULES_PROVIDER] تم تحميل ${rules.length} قاعدة بنجاح');

      // طباعة تفاصيل القواعد المحملة
      for (var rule in rules) {
        debugPrint(
            '   - قاعدة: ${rule.fieldName} (${rule.targetStatus}) - يسمح بالتعديل: ${rule.allowEdit}');
      }

      state = state.copyWith(
        rules: rules,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES_PROVIDER] خطأ في جلب القواعد: $e');
      state = state.copyWith(
        isLoading: false,
        error:
            'فشل في جلب قواعد التعديل من الخادم. يرجى التأكد من الاتصال بالإنترنت والمحاولة مرة أخرى.',
      );
    }
  }

  /// جلب القواعد الخاصة بحقل معين
  List<ProfileRuleModel> getRulesForField(
      String fieldName, ProfileStatus status) {
    final matchingRules = state.rules
        .where((rule) =>
            rule.fieldName == fieldName &&
            rule.targetStatus == status &&
            rule.isActive)
        .toList();

    // تقليل التسجيلات - طباعة مرة واحدة فقط عند الحاجة
    if (kDebugMode && matchingRules.isNotEmpty) {
      debugPrint(
          '🔍 [PROFILE_RULES] البحث عن قواعد للحقل: $fieldName والحالة: $status - ${matchingRules.length} قاعدة');
    }

    return matchingRules;
  }

  /// التحقق من إمكانية تعديل حقل
  bool canEditField(String fieldName, ProfileStatus currentStatus) {
    final rules = getRulesForField(fieldName, currentStatus);

    if (rules.isEmpty) {
      return true; // لا توجد قواعد = مسموح بالتعديل
    }

    return rules.every((rule) => rule.allowEdit);
  }

  /// التحقق من حاجة الحقل لوثيقة
  bool fieldRequiresDocument(String fieldName, ProfileStatus currentStatus) {
    final rules = getRulesForField(fieldName, currentStatus);
    return rules.any((rule) => rule.requiresDocument);
  }

  /// التحقق من حاجة التعديل لموافقة
  bool changeRequiresApproval(
    String fieldName,
    String oldValue,
    String newValue,
    ProfileStatus currentStatus,
  ) {
    final rules = getRulesForField(fieldName, currentStatus);

    if (rules.isEmpty) {
      return false;
    }

    for (final rule in rules) {
      switch (rule.approvalPolicy) {
        case ApprovalPolicy.alwaysRequired:
          return true;

        case ApprovalPolicy.conditionalByChangeLimit:
          final changeSize = _calculateChangeSize(oldValue, newValue);
          if (rule.changeLimit != null && changeSize > rule.changeLimit!) {
            return true;
          }
          break;

        case ApprovalPolicy.noApprovalRequired:
          continue;
      }
    }

    return false;
  }

  /// حساب حجم التغيير (Levenshtein distance)
  int _calculateChangeSize(String oldValue, String newValue) {
    if (oldValue == newValue) return 0;
    if (oldValue.isEmpty) return newValue.length;
    if (newValue.isEmpty) return oldValue.length;

    // Simple character difference count
    int changes = 0;
    int maxLength =
        oldValue.length > newValue.length ? oldValue.length : newValue.length;

    for (int i = 0; i < maxLength; i++) {
      if (i >= oldValue.length || i >= newValue.length) {
        changes++;
      } else if (oldValue[i] != newValue[i]) {
        changes++;
      }
    }

    return changes;
  }

  /// التحقق من صحة التعديلات
  Future<ProfileValidationResult> validateChanges(
    Map<String, dynamic> proposedChanges,
    Map<String, dynamic> currentValues,
    ProfileStatus currentStatus,
  ) async {
    try {
      return await _rulesService.validateChangesWithOldValues(
        proposedChanges,
        currentValues,
        currentStatus,
      );
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES_PROVIDER] خطأ في التحقق من التعديلات: $e');
      return const ProfileValidationResult(
        isValid: false,
        errors: ['فشل في التحقق من التعديلات'],
      );
    }
  }

  /// الحصول على سياسة الموافقة لحقل معين
  ApprovalPolicy? getApprovalPolicy(
      String fieldName, ProfileStatus currentStatus) {
    final rules = getRulesForField(fieldName, currentStatus);
    if (rules.isEmpty) return null;
    return rules.first.approvalPolicy;
  }

  /// الحصول على حد التغيير لحقل معين
  int? getChangeLimit(String fieldName, ProfileStatus currentStatus) {
    final rules = getRulesForField(fieldName, currentStatus);
    if (rules.isEmpty) return null;
    return rules.first.changeLimit;
  }

  /// مسح الـ cache وإعادة التحميل
  Future<void> refresh() async {
    _rulesService.clearCache();
    await loadRulesForCurrentUser(forceRefresh: true);
  }

  /// التحقق من إمكانية تعديل الملف الموثق
  bool canEditVerifiedProfile() {
    // التحقق من وجود قواعد تسمح بتعديل الملفات الموثقة
    final verifiedRules = state.rules
        .where((rule) =>
            rule.targetStatus == ProfileStatus.verified &&
            rule.allowEdit &&
            rule.isActive)
        .toList();

    return verifiedRules.isNotEmpty;
  }

  /// الحصول على نسبة الاكتمال المطلوبة للتوثيق
  double getRequiredCompletionPercentage() {
    // القيمة الافتراضية 80%
    return 80.0;
  }

  /// الحصول على الحقول المطلوبة للتوثيق
  /// تنبيهات بصرية للحقول المطلوبة
  List<String> getRequiredFieldsForVerification() {
    // الحقول الأساسية المطلوبة للتوثيق
    return [
      // 'fullNameAr',
      // 'fullNameEn',
      // 'email',
      //  'birthDate',
      // 'governorateId',
      // 'qualificationId',
    ];
  }

  /// الحصول على الوثائق المطلوبة للتوثيق
  List<String> getRequiredDocumentsForVerification() {
    // الوثائق الأساسية المطلوبة للتوثيق
    return [
      'identity',
      'qualification',
    ];
  }
}

/// Provider الرئيسي
final profileRulesProvider =
    StateNotifierProvider<ProfileRulesNotifier, ProfileRulesState>((ref) {
  return ProfileRulesNotifier(ProfileRulesService());
});

/// Provider للتحقق من إمكانية تعديل حقل معين
final canEditFieldProvider =
    Provider.family<bool, ({String fieldName, ProfileStatus status})>(
  (ref, params) {
    final rulesState = ref.watch(profileRulesProvider);
    final rules = rulesState.rules
        .where((rule) =>
            rule.fieldName == params.fieldName &&
            rule.targetStatus == params.status &&
            rule.isActive)
        .toList();

    if (rules.isEmpty) return true;
    return rules.every((rule) => rule.allowEdit);
  },
);

/// Provider للتحقق من حاجة الحقل لوثيقة
final fieldRequiresDocumentProvider =
    Provider.family<bool, ({String fieldName, ProfileStatus status})>(
  (ref, params) {
    final rulesState = ref.watch(profileRulesProvider);
    final rules = rulesState.rules
        .where((rule) =>
            rule.fieldName == params.fieldName &&
            rule.targetStatus == params.status &&
            rule.isActive)
        .toList();

    return rules.any((rule) => rule.requiresDocument);
  },
);
