import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

import '../models/profile_rule_model.dart';
import 'storage_service.dart';

/// خدمة إدارة قواعد التوثيق الديناميكية
class VerificationRulesService {
  static final VerificationRulesService _instance = VerificationRulesService._internal();
  factory VerificationRulesService() => _instance;
  VerificationRulesService._internal();

  final StorageService _storageService = StorageService.instance;


  /// جلب قواعد التوثيق من الخادم
  Future<List<ProfileRuleModel>> getVerificationRules() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/profile/verification-rules'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> rulesJson = data['data'] ?? [];
        
        return rulesJson
            .map((json) => ProfileRuleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load verification rules: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading verification rules: $e');
    }
  }

  /// جلب قواعد التوثيق لحقل معين
  Future<ProfileRuleModel?> getRuleForField(String fieldName) async {
    try {
      final rules = await getVerificationRules();
      return rules.firstWhere(
        (rule) => rule.fieldName == fieldName,
        orElse: () => ProfileRuleModel(
          id: '',
          fieldName: fieldName,
          allowEdit: true,
          approvalPolicy: ApprovalPolicy.noApprovalRequired,
          requiresDocument: false,
          targetStatus: ProfileStatus.unverified,
          category: RuleCategory.personal,
          priority: 0,
          tags: [],
          version: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // في حالة الخطأ، إرجاع قاعدة افتراضية تسمح بالتعديل
      return ProfileRuleModel(
        id: '',
        fieldName: fieldName,
        allowEdit: true,
        approvalPolicy: ApprovalPolicy.noApprovalRequired,
        requiresDocument: false,
        targetStatus: ProfileStatus.unverified,
        category: RuleCategory.personal,
        priority: 0,
        tags: [],
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// التحقق من إمكانية تعديل حقل معين
  Future<bool> canEditField(String fieldName, ProfileStatus userStatus) async {
    try {
      final rule = await getRuleForField(fieldName);
      if (rule == null) return true;

      // التحقق من حالة المستخدم والقواعد
      switch (userStatus) {
        case ProfileStatus.verified:
          // المستخدمون الموثقون قد يحتاجون موافقة لتعديل بعض الحقول
          return rule.allowEdit && 
                 (rule.approvalPolicy == ApprovalPolicy.noApprovalRequired ||
                  rule.approvalPolicy == ApprovalPolicy.conditionalByChangeLimit);
        
        case ProfileStatus.pendingVerification:
          // المستخدمون تحت المراجعة لا يمكنهم التعديل
          return false;
        
        case ProfileStatus.rejected:
          // المستخدمون المرفوضون يمكنهم التعديل لإعادة التقديم
          return rule.allowEdit;
        
        case ProfileStatus.unverified:
        default:
          // المستخدمون غير الموثقين يمكنهم التعديل
          return rule.allowEdit;
      }
    } catch (e) {
      // في حالة الخطأ، السماح بالتعديل
      return true;
    }
  }

  /// التحقق من متطلبات الوثائق لحقل معين
  Future<bool> requiresDocument(String fieldName) async {
    try {
      final rule = await getRuleForField(fieldName);
      return rule?.requiresDocument ?? false;
    } catch (e) {
      return false;
    }
  }

  /// جلب قائمة الحقول المطلوبة للتوثيق
  Future<List<String>> getRequiredFields() async {
    try {
      final rules = await getVerificationRules();
      return rules
          .where((rule) => rule.category == RuleCategory.personal || 
                          rule.category == RuleCategory.academic)
          .map((rule) => rule.fieldName)
          .toList();
    } catch (e) {
      // قائمة افتراضية للحقول المطلوبة
      return [
        'fullNameAr',
        'fullNameEn',
        'birthDate',
        'governorateId',
        'qualificationId',
        'graduationYear',
        'university',
      ];
    }
  }

  /// جلب قائمة الحقول التي تتطلب وثائق
  Future<List<String>> getDocumentRequiredFields() async {
    try {
      final rules = await getVerificationRules();
      return rules
          .where((rule) => rule.requiresDocument)
          .map((rule) => rule.fieldName)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// حساب نسبة اكتمال الملف الشخصي بناءً على القواعد
  Future<double> calculateCompletionPercentage(
    Map<String, dynamic> profileData,
    Map<String, String> documentUrls,
  ) async {
    try {
      final rules = await getVerificationRules();
      if (rules.isEmpty) return 0.0;

      int totalFields = 0;
      int completedFields = 0;

      for (final rule in rules) {
        totalFields++;
        
        final fieldValue = profileData[rule.fieldName];
        bool isFieldComplete = false;

        // التحقق من وجود قيمة للحقل
        if (fieldValue != null) {
          if (fieldValue is String && fieldValue.isNotEmpty) {
            isFieldComplete = true;
          } else if (fieldValue is! String) {
            isFieldComplete = true;
          }
        }

        // التحقق من متطلبات الوثائق
        if (isFieldComplete && rule.requiresDocument) {
          final documentKey = _getDocumentKeyForField(rule.fieldName);
          isFieldComplete = documentUrls.containsKey(documentKey) &&
                           documentUrls[documentKey]!.isNotEmpty;
        }

        if (isFieldComplete) {
          completedFields++;
        }
      }

      return totalFields > 0 ? (completedFields / totalFields) : 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// تحديد مفتاح الوثيقة للحقل
  String _getDocumentKeyForField(String fieldName) {
    switch (fieldName) {
      case 'qualificationId':
        return 'qualification';
      case 'fullNameAr':
      case 'fullNameEn':
        return 'identity';
      case 'birthDate':
        return 'birthCertificate';
      default:
        return fieldName;
    }
  }

  /// إرسال طلب توثيق للإدارة
  Future<bool> submitVerificationRequest(String profileId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/profile/submit-verification'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'profileId': profileId,
          'submittedAt': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// جلب أسباب الرفض للمستخدم
  Future<List<String>> getRejectionReasons(String profileId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/profile/$profileId/rejection-reasons'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> reasons = data['reasons'] ?? [];
        return reasons.cast<String>();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }
}