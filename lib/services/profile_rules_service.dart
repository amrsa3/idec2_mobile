import 'package:flutter/foundation.dart';

import '../models/profile_rule_model.dart';
import '../services/dio_service.dart';

/// خدمة قواعد تعديل الملف الشخصي
class ProfileRulesService {
  static final ProfileRulesService _instance = ProfileRulesService._internal();
  factory ProfileRulesService() => _instance;
  ProfileRulesService._internal();

  // Cache للقواعد
  List<ProfileRuleModel>? _cachedRules;
  DateTime? _cacheExpiry;

  /// جلب جميع القواعد النشطة
  Future<List<ProfileRuleModel>> getActiveRules(
      {bool forceRefresh = false}) async {
    try {
      // التحقق من الـ cache
      if (!forceRefresh && _isCacheValid()) {
        debugPrint('✅ [PROFILE_RULES] استخدام القواعد من الـ cache');
        return _cachedRules!;
      }

      debugPrint('🔍 [PROFILE_RULES] جلب القواعد من الخادم...');

      final dio = DioService.instance.dio;
      final response = await dio.get('/api/v1/profile-rules');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['data'] ?? []);

        _cachedRules =
            data.map((json) => ProfileRuleModel.fromJson(json)).toList();

        // تعيين وقت انتهاء الـ cache (5 دقائق)
        _cacheExpiry = DateTime.now().add(const Duration(minutes: 5));

        debugPrint('✅ [PROFILE_RULES] تم جلب ${_cachedRules!.length} قاعدة');
        return _cachedRules!;
      } else {
        throw Exception('فشل في جلب القواعد: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES] خطأ في جلب القواعد: $e');

      // لا نستخدم قواعد افتراضية - التعديل يتطلب اتصال بالخادم
      throw Exception('فشل في جلب قواعد التعديل من الخادم. يرجى التأكد من الاتصال بالإنترنت والمحاولة مرة أخرى.');
    }
  }

  /// جلب القواعد الخاصة بحقل معين وحالة معينة
  Future<List<ProfileRuleModel>> getRulesForField(
    String fieldName,
    ProfileStatus status,
  ) async {
    final allRules = await getActiveRules();
    return allRules
        .where((rule) =>
            rule.fieldName == fieldName &&
            rule.targetStatus == status &&
            rule.isActive)
        .toList();
  }

  /// التحقق من صحة التعديلات المقترحة
  Future<ProfileValidationResult> validateChanges(
    Map<String, dynamic> proposedChanges,
    ProfileStatus currentStatus,
  ) async {
    try {
      debugPrint('🔍 [PROFILE_RULES] التحقق من التعديلات...');

      // Get active rules
      final activeRules = await getActiveRules();

      bool requiresApproval = false;
      bool requiresDocument = false;
      List<String> fieldsRequiringApproval = [];
      List<String> fieldsRequiringDocument = [];
      List<String> warnings = [];
      List<String> errors = [];
      List<ProfileRuleModel> appliedRules = [];

      // Validate each changed field
      for (var entry in proposedChanges.entries) {
        final fieldName = entry.key;
        final newValue = entry.value;

        // Find rules for this field and status
        final fieldRules = activeRules
            .where((rule) =>
                rule.fieldName == fieldName &&
                rule.targetStatus == currentStatus &&
                rule.isActive)
            .toList();

        if (fieldRules.isEmpty) {
          // No rules = allow editing
          continue;
        }

        for (var rule in fieldRules) {
          appliedRules.add(rule);

          // Check if editing is allowed
          if (!rule.allowEdit) {
            errors.add(
                'تعديل ${rule.fieldDisplayName ?? fieldName} غير مسموح في هذه الحالة');
            continue;
          }

          // Check approval policy
          switch (rule.approvalPolicy) {
            case ApprovalPolicy.alwaysRequired:
              requiresApproval = true;
              fieldsRequiringApproval.add(fieldName);
              warnings.add(
                  'تعديل ${rule.fieldDisplayName ?? fieldName} يتطلب موافقة إدارية');
              break;

            case ApprovalPolicy.conditionalByChangeLimit:
              // This would need old value to calculate change size
              // For now, we'll mark it as potentially requiring approval
              warnings.add(
                  'تعديل ${rule.fieldDisplayName ?? fieldName} قد يتطلب موافقة حسب حجم التغيير');
              break;

            case ApprovalPolicy.noApprovalRequired:
              warnings.add(
                  'تعديل ${rule.fieldDisplayName ?? fieldName} مسموح بدون موافقة');
              break;
          }

          // Check if document is required
          if (rule.requiresDocument) {
            requiresDocument = true;
            fieldsRequiringDocument.add(fieldName);
            warnings.add(
                'تعديل ${rule.fieldDisplayName ?? fieldName} يتطلب رفع وثيقة');
          }
        }
      }

      final result = ProfileValidationResult(
        isValid: errors.isEmpty,
        requiresApproval: requiresApproval,
        requiresDocument: requiresDocument,
        appliedRules: appliedRules,
        errors: errors,
        warnings: warnings,
        fieldsRequiringApproval: fieldsRequiringApproval,
      );

      debugPrint(
          '✅ [PROFILE_RULES] نتيجة التحقق: ${result.isValid}, يتطلب موافقة: ${result.requiresApproval}');
      return result;
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES] خطأ في التحقق: $e');

      // إرجاع نتيجة افتراضية تسمح بالتعديل
      return const ProfileValidationResult(
        isValid: true,
        requiresApproval: false,
        requiresDocument: false,
        warnings: ['تعذر التحقق من القواعد، سيتم السماح بالتعديل'],
      );
    }
  }

  /// التحقق من إمكانية تعديل حقل معين
  Future<bool> canEditField(
    String fieldName,
    ProfileStatus currentStatus,
  ) async {
    final rules = await getRulesForField(fieldName, currentStatus);

    if (rules.isEmpty) {
      // لا توجد قواعد = مسموح بالتعديل
      return true;
    }

    // التحقق من وجود قاعدة تمنع التعديل
    return rules.every((rule) => rule.allowEdit);
  }

  /// التحقق من حاجة الحقل لوثيقة
  Future<bool> fieldRequiresDocument(
    String fieldName,
    ProfileStatus currentStatus,
  ) async {
    final rules = await getRulesForField(fieldName, currentStatus);
    return rules.any((rule) => rule.requiresDocument);
  }

  /// التحقق من حاجة التعديل لموافقة
  Future<bool> changeRequiresApproval(
    String fieldName,
    String oldValue,
    String newValue,
    ProfileStatus currentStatus,
  ) async {
    final rules = await getRulesForField(fieldName, currentStatus);

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

  /// حساب حجم التغيير بين قيمتين (Levenshtein distance)
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

  /// التحقق من صحة التعديلات مع القيم القديمة
  Future<ProfileValidationResult> validateChangesWithOldValues(
    Map<String, dynamic> proposedChanges,
    Map<String, dynamic> currentValues,
    ProfileStatus currentStatus,
  ) async {
    try {
      debugPrint('🔍 [PROFILE_RULES] التحقق من التعديلات مع القيم القديمة...');

      // Get active rules
      final activeRules = await getActiveRules();

      bool requiresApproval = false;
      bool requiresDocument = false;
      List<String> fieldsRequiringApproval = [];
      List<String> fieldsRequiringDocument = [];
      List<String> warnings = [];
      List<String> errors = [];
      List<ProfileRuleModel> appliedRules = [];

      // Validate each changed field
      for (var entry in proposedChanges.entries) {
        final fieldName = entry.key;
        final newValue = entry.value?.toString() ?? '';
        final oldValue = currentValues[fieldName]?.toString() ?? '';

        // Find rules for this field and status
        final fieldRules = activeRules
            .where((rule) =>
                rule.fieldName == fieldName &&
                rule.targetStatus == currentStatus &&
                rule.isActive)
            .toList();

        if (fieldRules.isEmpty) {
          // No rules = allow editing
          continue;
        }

        for (var rule in fieldRules) {
          appliedRules.add(rule);

          // Check if editing is allowed
          if (!rule.allowEdit) {
            errors.add(
                'تعديل ${rule.fieldDisplayName ?? fieldName} غير مسموح في هذه الحالة');
            continue;
          }

          // Check approval policy
          switch (rule.approvalPolicy) {
            case ApprovalPolicy.alwaysRequired:
              requiresApproval = true;
              fieldsRequiringApproval.add(fieldName);
              warnings.add(
                  'تعديل ${rule.fieldDisplayName ?? fieldName} يتطلب موافقة إدارية');
              break;

            case ApprovalPolicy.conditionalByChangeLimit:
              if (rule.changeLimit != null) {
                final changeSize = _calculateChangeSize(oldValue, newValue);
                if (changeSize > rule.changeLimit!) {
                  requiresApproval = true;
                  fieldsRequiringApproval.add(fieldName);
                  warnings.add(
                      'تعديل ${rule.fieldDisplayName ?? fieldName} يتجاوز الحد المسموح (${rule.changeLimit} حرف) ويتطلب موافقة إدارية');
                } else {
                  warnings.add(
                      'تعديل ${rule.fieldDisplayName ?? fieldName} ضمن الحد المسموح (${rule.changeLimit} حرف)');
                }
              }
              break;

            case ApprovalPolicy.noApprovalRequired:
              warnings.add(
                  'تعديل ${rule.fieldDisplayName ?? fieldName} مسموح بدون موافقة');
              break;
          }

          // Check if document is required
          if (rule.requiresDocument) {
            requiresDocument = true;
            fieldsRequiringDocument.add(fieldName);
            warnings.add(
                'تعديل ${rule.fieldDisplayName ?? fieldName} يتطلب رفع وثيقة');
          }
        }
      }

      final result = ProfileValidationResult(
        isValid: errors.isEmpty,
        requiresApproval: requiresApproval,
        requiresDocument: requiresDocument,
        appliedRules: appliedRules,
        errors: errors,
        warnings: warnings,
        fieldsRequiringApproval: fieldsRequiringApproval,
      );

      debugPrint(
          '✅ [PROFILE_RULES] نتيجة التحقق: ${result.isValid}, يتطلب موافقة: ${result.requiresApproval}');
      return result;
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES] خطأ في التحقق: $e');

      // إرجاع نتيجة افتراضية تسمح بالتعديل
      return const ProfileValidationResult(
        isValid: true,
        requiresApproval: false,
        requiresDocument: false,
        warnings: ['تعذر التحقق من القواعد، سيتم السماح بالتعديل'],
      );
    }
  }

  /// التحقق من صلاحية الـ cache
  bool _isCacheValid() {
    return _cachedRules != null &&
        _cacheExpiry != null &&
        DateTime.now().isBefore(_cacheExpiry!);
  }

  /// مسح الـ cache
  void clearCache() {
    _cachedRules = null;
    _cacheExpiry = null;
    debugPrint('🗑️ [PROFILE_RULES] تم مسح الـ cache');
  }



  /// جلب أسماء الحقول المتاحة
  Future<List<String>> getAvailableFieldNames() async {
    try {
      final dio = DioService.instance.dio;
      final response = await dio.get('/api/v1/profile-rules/field-names');

      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      }
      return [];
    } catch (e) {
      debugPrint('❌ [PROFILE_RULES] خطأ في جلب أسماء الحقول: $e');
      return [];
    }
  }
}
