import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile_rule_model.dart';

part 'user_profile_extended.freezed.dart';
part 'user_profile_extended.g.dart';

/// Extended User Profile Model with document URLs and pending changes
@freezed
class UserProfileExtended with _$UserProfileExtended {
  const factory UserProfileExtended({
    required String id,
    required String userId,

    // Personal Data
    String? fullNameAr,
    String? fullNameEn,
    String? email,
    DateTime? birthDate,
    String? governorateId,

    // Academic Data
    String? qualificationId,
    int? graduationYear,
    String? university,
    String? workplace,

    // Profile Status
    @Default(ProfileStatus.unverified) ProfileStatus status,
    String? rejectionReason,

    // Profile Picture
    String? profilePictureUrl,
    String? profilePictureFileId,

    // Document URLs mapped by field name
    @Default({}) Map<String, String> documentUrls,

    // Document File IDs mapped by field name
    @Default({}) Map<String, String> documentFileIds,

    // Pending changes for approval tracking
    @Default({}) Map<String, dynamic> pendingChanges,

    // Timestamps
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? verifiedAt,
  }) = _UserProfileExtended;

  factory UserProfileExtended.fromJson(Map<String, dynamic> json) =>
      _$UserProfileExtendedFromJson(json);
}

/// Extension methods for UserProfileExtended
extension UserProfileExtendedX on UserProfileExtended {
  /// Check if a field has pending changes
  bool hasFieldChanged(String fieldName) {
    return pendingChanges.containsKey(fieldName);
  }

  /// Get the pending value for a field
  dynamic getPendingValue(String fieldName) {
    return pendingChanges[fieldName];
  }

  /// Check if profile has any pending changes
  bool get hasPendingChanges => pendingChanges.isNotEmpty;

  /// Check if a field has an attached document
  bool hasDocument(String fieldName) {
    return documentUrls.containsKey(fieldName) &&
        documentUrls[fieldName]!.isNotEmpty;
  }

  /// Get document URL for a field
  String? getDocumentUrl(String fieldName) {
    return documentUrls[fieldName];
  }

  /// Get document file ID for a field
  String? getDocumentFileId(String fieldName) {
    return documentFileIds[fieldName];
  }

  /// Check if profile is verified
  bool get isVerified => status == ProfileStatus.verified;

  /// Check if profile is pending verification
  bool get isPendingVerification => status == ProfileStatus.pendingVerification;

  /// Check if profile is rejected
  bool get isRejected => status == ProfileStatus.rejected;

  /// Check if profile is unverified
  bool get isUnverified => status == ProfileStatus.unverified;

  /// Get display name (prefer Arabic, fallback to English)
  String get displayName {
    if (fullNameAr != null && fullNameAr!.isNotEmpty) {
      return fullNameAr!;
    }
    if (fullNameEn != null && fullNameEn!.isNotEmpty) {
      return fullNameEn!;
    }
    return 'مستخدم';
  }

  /// Calculate profile completion percentage
  double get completionPercentage {
    int totalFields = 8; // Total required fields
    int completedFields = 0;

    if (fullNameAr != null && fullNameAr!.isNotEmpty) completedFields++;
    if (fullNameEn != null && fullNameEn!.isNotEmpty) completedFields++;
    if (email != null && email!.isNotEmpty) completedFields++;
    if (birthDate != null) completedFields++;
    if (governorateId != null && governorateId!.isNotEmpty) completedFields++;
    if (qualificationId != null && qualificationId!.isNotEmpty)
      completedFields++;
    if (graduationYear != null && graduationYear! > 0) completedFields++;
    if (university != null && university!.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  /// Create a copy with updated field
  UserProfileExtended updateField(String fieldName, dynamic value) {
    final updatedPendingChanges = Map<String, dynamic>.from(pendingChanges);
    updatedPendingChanges[fieldName] = value;

    return copyWith(pendingChanges: updatedPendingChanges);
  }

  /// Create a copy with attached document
  UserProfileExtended attachDocument(
      String fieldName, String fileUrl, String fileId) {
    final updatedDocumentUrls = Map<String, String>.from(documentUrls);
    updatedDocumentUrls[fieldName] = fileUrl;

    final updatedDocumentFileIds = Map<String, String>.from(documentFileIds);
    updatedDocumentFileIds[fieldName] = fileId;

    return copyWith(
      documentUrls: updatedDocumentUrls,
      documentFileIds: updatedDocumentFileIds,
    );
  }

  /// Clear pending changes
  UserProfileExtended clearPendingChanges() {
    return copyWith(pendingChanges: {});
  }

  /// Apply pending changes to profile
  UserProfileExtended applyPendingChanges() {
    var updated = this;

    for (var entry in pendingChanges.entries) {
      switch (entry.key) {
        case 'fullNameAr':
          updated = updated.copyWith(fullNameAr: entry.value as String?);
          break;
        case 'fullNameEn':
          updated = updated.copyWith(fullNameEn: entry.value as String?);
          break;
        case 'email':
          updated = updated.copyWith(email: entry.value as String?);
          break;
        case 'birthDate':
          updated = updated.copyWith(birthDate: entry.value as DateTime?);
          break;
        case 'governorateId':
          updated = updated.copyWith(governorateId: entry.value as String?);
          break;
        case 'qualificationId':
          updated = updated.copyWith(qualificationId: entry.value as String?);
          break;
        case 'graduationYear':
          updated = updated.copyWith(graduationYear: entry.value as int?);
          break;
        case 'university':
          updated = updated.copyWith(university: entry.value as String?);
          break;
        case 'workplace':
          updated = updated.copyWith(workplace: entry.value as String?);
          break;
      }
    }

    return updated.clearPendingChanges();
  }

  /// Convert to update DTO
  Map<String, dynamic> toUpdateDto() {
    final dto = <String, dynamic>{};

    if (fullNameAr != null) dto['fullNameAr'] = fullNameAr;
    if (fullNameEn != null) dto['fullNameEn'] = fullNameEn;
    if (email != null) dto['email'] = email;
    if (birthDate != null) dto['birthDate'] = birthDate!.toIso8601String();
    if (governorateId != null) dto['governorateId'] = governorateId;
    if (qualificationId != null) dto['qualificationId'] = qualificationId;
    if (graduationYear != null) dto['graduationYear'] = graduationYear;
    if (university != null) dto['university'] = university;
    if (workplace != null) dto['workplace'] = workplace;

    // Include document file IDs
    if (documentFileIds.isNotEmpty) {
      dto['documents'] = documentFileIds;
    }

    return dto;
  }
}
