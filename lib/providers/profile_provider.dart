import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../services/file_upload_service.dart';
import '../services/profile_rules_service.dart';
import '../services/profile_service.dart';

/// حالة الملف الشخصي
class ProfileState {
  final UserProfileExtended? profile;
  final List<Qualification> qualifications;
  final List<dynamic> governorates;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingDocument;
  final String? error;
  final String? successMessage;
  final bool showApprovalWarning;
  final String? approvalWarningMessage;
  final ProfileValidationResult? validationResult;

  const ProfileState({
    this.profile,
    this.qualifications = const [],
    this.governorates = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingDocument = false,
    this.error,
    this.successMessage,
    this.showApprovalWarning = false,
    this.approvalWarningMessage,
    this.validationResult,
  });

  /// Getter للحصول على الملف الشخصي الحالي
  UserProfileExtended? get currentProfile => profile;

  ProfileState copyWith({
    UserProfileExtended? profile,
    List<Qualification>? qualifications,
    List<dynamic>? governorates,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingDocument,
    String? error,
    String? successMessage,
    bool? showApprovalWarning,
    String? approvalWarningMessage,
    ProfileValidationResult? validationResult,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      qualifications: qualifications ?? this.qualifications,
      governorates: governorates ?? this.governorates,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingDocument: isUploadingDocument ?? this.isUploadingDocument,
      error: error,
      successMessage: successMessage,
      showApprovalWarning: showApprovalWarning ?? this.showApprovalWarning,
      approvalWarningMessage: approvalWarningMessage,
      validationResult: validationResult ?? this.validationResult,
    );
  }

  ProfileState clearMessages() {
    return copyWith(
      error: null,
      successMessage: null,
      showApprovalWarning: false,
      approvalWarningMessage: null,
    );
  }
}

/// Provider لإدارة الملف الشخصي
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRulesService _rulesService;

  ProfileNotifier(this._rulesService) : super(const ProfileState());

  /// جلب الملف الشخصي
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load profile
      final profileModel = await ProfileService.getProfile();

      // Convert ProfileModel to UserProfileExtended
      final profile = UserProfileExtended(
        id: profileModel.id,
        userId: profileModel.userId,
        fullNameAr: profileModel.fullNameAr,
        fullNameEn: profileModel.fullNameEn,
        email: profileModel.email,
        birthDate: profileModel.birthDate,
        governorateId: profileModel.governorateId,
        qualificationId: profileModel.qualificationId,
        graduationYear: profileModel.graduationYear,
        university: profileModel.university,
        workplace: profileModel.workplace,
        status: _mapProfileStatus(profileModel.verificationStatus),
        profilePictureUrl: profileModel.profilePictureUrl,
        createdAt: profileModel.createdAt,
        updatedAt: profileModel.updatedAt,
      );

      // Load qualifications
      final qualificationsData = await ProfileService.getQualifications();
      final qualifications = qualificationsData
          .map((json) => Qualification.fromJson(json))
          .toList();

      // Load governorates
      final governorates = await ProfileService.getGovernorates();

      state = state.copyWith(
        profile: profile,
        qualifications: qualifications,
        governorates: governorates,
        isLoading: false,
      );

      debugPrint('✅ [PROFILE_PROVIDER] تم جلب الملف الشخصي بنجاح');
    } catch (e) {
      debugPrint('❌ [PROFILE_PROVIDER] خطأ في جلب الملف الشخصي: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في جلب الملف الشخصي: $e',
      );
    }
  }

  /// تحديث حقل في الملف الشخصي
  void updateField(String fieldName, dynamic value) {
    if (state.profile == null) return;

    final updatedProfile = state.profile!.updateField(fieldName, value);
    state = state.copyWith(profile: updatedProfile);

    debugPrint('📝 [PROFILE_PROVIDER] تم تحديث الحقل: $fieldName');
  }

  /// رفع صورة الملف الشخصي
  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      // تعيين حالة التحميل
      state = state.copyWith(
        isLoading: true,
        error: null,
        successMessage: null,
      );

      // رفع الصورة
      final imageUrl = await ProfileService.uploadProfilePicture(imageFile);

      if (imageUrl != null) {
        // تحديث الملف الشخصي بالصورة الجديدة
        updateField('profilePictureUrl', imageUrl);

        // تعيين رسالة النجاح
        state = state.copyWith(
          isLoading: false,
          successMessage: 'تم تحديث صورة الملف الشخصي بنجاح',
        );
      } else {
        throw Exception('فشل في رفع الصورة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_PROVIDER] خطأ في رفع صورة الملف الشخصي: $e');
      
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في رفع صورة الملف الشخصي: ${e.toString()}',
      );
    }
  }

  /// رفع صورة الملف الشخصي مع تقدم
  Future<void> uploadProfilePictureWithProgress(
    File imageFile, {
    Function(double)? onProgress,
  }) async {
    try {
      // تعيين حالة التحميل
      state = state.copyWith(
        isLoading: true,
        error: null,
        successMessage: null,
      );

      // رفع الصورة مع تتبع التقدم
      final imageUrl = await ProfileService.uploadProfilePictureWithProgress(
        imageFile,
        onProgress: onProgress,
      );

      if (imageUrl != null) {
        // تحديث الملف الشخصي بالصورة الجديدة
        updateField('profilePictureUrl', imageUrl);

        // تعيين رسالة النجاح
        state = state.copyWith(
          isLoading: false,
          successMessage: 'تم تحديث صورة الملف الشخصي بنجاح',
        );
      } else {
        throw Exception('فشل في رفع الصورة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_PROVIDER] خطأ في رفع صورة الملف الشخصي: $e');
      
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في رفع صورة الملف الشخصي: ${e.toString()}',
      );
    }
  }

  /// إرفاق وثيقة لحقل معين
  Future<void> attachDocument(String fieldName, File file) async {
    if (state.profile == null) return;

    state = state.copyWith(isUploadingDocument: true, error: null);

    try {
      // Validate file first
      final validation = await FileUploadService.validateFile(file);
      if (!validation.isValid) {
        throw Exception(validation.errorMessage ?? 'ملف غير صالح');
      }

      // Upload document
      final result = await FileUploadService.uploadProfileDocument(
        documentFile: file,
        profileId: state.profile!.id,
        fieldName: fieldName,
      );

      if (result.isSuccess) {
        final updatedProfile = state.profile!.attachDocument(
          fieldName,
          result.fileUrl!,
          result.fileId!,
        );

        state = state.copyWith(
          profile: updatedProfile,
          isUploadingDocument: false,
          successMessage: 'تم رفع الوثيقة بنجاح',
        );

        debugPrint('✅ [PROFILE_PROVIDER] تم رفع الوثيقة للحقل: $fieldName');
      } else {
        throw Exception(result.errorMessage ?? 'فشل في رفع الوثيقة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_PROVIDER] خطأ في رفع الوثيقة: $e');
      state = state.copyWith(
        isUploadingDocument: false,
        error: 'فشل في رفع الوثيقة: $e',
      );
    }
  }

  /// حفظ الملف الشخصي
  Future<bool> saveProfile({bool skipValidation = false}) async {
    if (state.profile == null) return false;

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Validate changes if not skipped
      if (!skipValidation && state.profile!.hasPendingChanges) {
        final currentValues = _getCurrentValues();
        final validation = await _rulesService.validateChangesWithOldValues(
          state.profile!.pendingChanges,
          currentValues,
          state.profile!.status,
        );

        state = state.copyWith(validationResult: validation);

        // Check if requires approval
        if (validation.requiresApproval) {
          state = state.copyWith(
            isSaving: false,
            showApprovalWarning: true,
            approvalWarningMessage:
                'التعديلات تتطلب موافقة إدارية. هل تريد المتابعة؟',
          );
          return false; // Wait for user confirmation
        }

        // Check for errors
        if (!validation.isValid) {
          state = state.copyWith(
            isSaving: false,
            error: validation.errors.join('\n'),
          );
          return false;
        }
      }

      // Apply pending changes
      final updatedProfile = state.profile!.applyPendingChanges();

      // Create update DTO
      final updateDto = updatedProfile.toUpdateDto();

      // Update profile on server
      final response = await ProfileService.updateProfile(
        ProfileUpdateRequest.fromJson(updateDto),
      );

      if (response.success) {
        state = state.copyWith(
          profile: updatedProfile,
          isSaving: false,
          successMessage: 'تم حفظ التعديلات بنجاح',
        );

        debugPrint('✅ [PROFILE_PROVIDER] تم حفظ الملف الشخصي بنجاح');
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_PROVIDER] خطأ في حفظ الملف الشخصي: $e');
      state = state.copyWith(
        isSaving: false,
        error: 'فشل في حفظ الملف الشخصي: $e',
      );
      return false;
    }
  }

  /// تأكيد الحفظ مع الموافقة
  Future<bool> confirmSaveWithApproval() async {
    state = state.copyWith(showApprovalWarning: false);
    return await saveProfile(skipValidation: true);
  }

  /// إلغاء الحفظ
  void cancelSave() {
    state = state.copyWith(
      showApprovalWarning: false,
      approvalWarningMessage: null,
    );
  }

  /// مسح الرسائل
  void clearMessages() {
    state = state.clearMessages();
  }

  /// إعادة تحميل البيانات
  Future<void> refresh() async {
    await loadProfile();
  }

  /// الحصول على القيم الحالية للحقول
  Map<String, dynamic> _getCurrentValues() {
    if (state.profile == null) return {};

    return {
      'fullNameAr': state.profile!.fullNameAr,
      'fullNameEn': state.profile!.fullNameEn,
      'email': state.profile!.email,
      'birthDate': state.profile!.birthDate,
      'governorateId': state.profile!.governorateId,
      'qualificationId': state.profile!.qualificationId,
      'graduationYear': state.profile!.graduationYear,
      'university': state.profile!.university,
      'workplace': state.profile!.workplace,
    };
  }

  /// تحويل VerificationStatus إلى ProfileStatus
  ProfileStatus _mapProfileStatus(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.unverified:
        return ProfileStatus.unverified;
      case VerificationStatus.underReview:
        return ProfileStatus.pendingVerification;
      case VerificationStatus.verified:
        return ProfileStatus.verified;
      case VerificationStatus.rejected:
        return ProfileStatus.rejected;
    }
  }
}

/// Provider الرئيسي
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ProfileRulesService());
});

/// Provider للحصول على المؤهل الحالي
final currentQualificationProvider = Provider<Qualification?>((ref) {
  final profileState = ref.watch(profileProvider);
  if (profileState.profile?.qualificationId == null) return null;

  return profileState.qualifications.firstWhere(
    (q) => q.id == profileState.profile!.qualificationId,
    orElse: () => profileState.qualifications.first,
  );
});

/// Provider للحصول على المحافظة الحالية
final currentGovernorateProvider = Provider<dynamic>((ref) {
  final profileState = ref.watch(profileProvider);
  if (profileState.profile?.governorateId == null) return null;

  try {
    return profileState.governorates.firstWhere(
      (g) => g['id'] == profileState.profile!.governorateId,
    );
  } catch (e) {
    return null;
  }
});
