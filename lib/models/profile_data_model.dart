import 'dart:io';
import 'profile_model.dart';

// VerificationStatus moved to profile_model.dart to avoid conflicts

class PersonalData {
  final String arabicName;
  final String englishName;
  final String? email;
  final DateTime? birthDate;
  final String governorate;

  const PersonalData({
    required this.arabicName,
    required this.englishName,
    this.email,
    this.birthDate,
    required this.governorate,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) {
    return PersonalData(
      arabicName: json['arabicName'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      email: json['email'] as String?,
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      governorate: json['governorate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabicName': arabicName,
      'englishName': englishName,
      'email': email,
      'birthDate': birthDate?.toIso8601String(),
      'governorate': governorate,
    };
  }

  PersonalData copyWith({
    String? arabicName,
    String? englishName,
    String? email,
    DateTime? birthDate,
    String? governorate,
  }) {
    return PersonalData(
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      governorate: governorate ?? this.governorate,
    );
  }
}

class AcademicData {
  final String qualificationId;
  final String qualificationName;
  final int graduationYear;
  final String university;
  final String workplace;

  const AcademicData({
    required this.qualificationId,
    required this.qualificationName,
    required this.graduationYear,
    required this.university,
    required this.workplace,
  });

  factory AcademicData.fromJson(Map<String, dynamic> json) {
    return AcademicData(
      qualificationId: json['qualificationId'] as String? ?? '',
      qualificationName: json['qualificationName'] as String? ?? '',
      graduationYear: json['graduationYear'] as int? ?? DateTime.now().year,
      university: json['university'] as String? ?? '',
      workplace: json['workplace'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qualificationId': qualificationId,
      'qualificationName': qualificationName,
      'graduationYear': graduationYear,
      'university': university,
      'workplace': workplace,
    };
  }

  AcademicData copyWith({
    String? qualificationId,
    String? qualificationName,
    int? graduationYear,
    String? university,
    String? workplace,
  }) {
    return AcademicData(
      qualificationId: qualificationId ?? this.qualificationId,
      qualificationName: qualificationName ?? this.qualificationName,
      graduationYear: graduationYear ?? this.graduationYear,
      university: university ?? this.university,
      workplace: workplace ?? this.workplace,
    );
  }
}

class DocumentFile {
  final String fieldName;
  final String fileName;
  final String filePath;
  final File? file;
  final String? uploadedUrl;
  final String? uploadedFileId;
  final bool isUploaded;

  const DocumentFile({
    required this.fieldName,
    required this.fileName,
    required this.filePath,
    this.file,
    this.uploadedUrl,
    this.uploadedFileId,
    this.isUploaded = false,
  });

  DocumentFile copyWith({
    String? fieldName,
    String? fileName,
    String? filePath,
    File? file,
    String? uploadedUrl,
    String? uploadedFileId,
    bool? isUploaded,
  }) {
    return DocumentFile(
      fieldName: fieldName ?? this.fieldName,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      file: file ?? this.file,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      uploadedFileId: uploadedFileId ?? this.uploadedFileId,
      isUploaded: isUploaded ?? this.isUploaded,
    );
  }
}

class ProfileData {
  final PersonalData personalData;
  final AcademicData academicData;
  final VerificationStatus verificationStatus;
  final String? profilePictureUrl;
  final List<DocumentFile> documents;
  final String? rejectionReason;

  const ProfileData({
    required this.personalData,
    required this.academicData,
    required this.verificationStatus,
    this.profilePictureUrl,
    this.documents = const [],
    this.rejectionReason,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      personalData: PersonalData.fromJson(json['personalData'] as Map<String, dynamic>? ?? {}),
      academicData: AcademicData.fromJson(json['academicData'] as Map<String, dynamic>? ?? {}),
      verificationStatus: _parseVerificationStatus(json['verificationStatus'] as String?),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((doc) => DocumentFile(
                fieldName: doc['fieldName'] as String,
                fileName: doc['fileName'] as String,
                filePath: doc['filePath'] as String,
                uploadedUrl: doc['uploadedUrl'] as String?,
                uploadedFileId: doc['uploadedFileId'] as String?,
                isUploaded: doc['isUploaded'] as bool? ?? false,
              ))
          .toList() ?? [],
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  static VerificationStatus _parseVerificationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return VerificationStatus.verified;
      case 'under_review':
      case 'underreview':
        return VerificationStatus.underReview;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.unverified;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'personalData': personalData.toJson(),
      'academicData': academicData.toJson(),
      'verificationStatus': verificationStatus.name,
      'profilePictureUrl': profilePictureUrl,
      'documents': documents.map((doc) => {
        'fieldName': doc.fieldName,
        'fileName': doc.fileName,
        'filePath': doc.filePath,
        'uploadedUrl': doc.uploadedUrl,
        'uploadedFileId': doc.uploadedFileId,
        'isUploaded': doc.isUploaded,
      }).toList(),
      'rejectionReason': rejectionReason,
    };
  }

  ProfileData copyWith({
    PersonalData? personalData,
    AcademicData? academicData,
    VerificationStatus? verificationStatus,
    String? profilePictureUrl,
    List<DocumentFile>? documents,
    String? rejectionReason,
  }) {
    return ProfileData(
      personalData: personalData ?? this.personalData,
      academicData: academicData ?? this.academicData,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      documents: documents ?? this.documents,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}