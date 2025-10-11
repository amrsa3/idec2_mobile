import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../models/profile_data_models.dart';
import '../../../models/profile_model.dart';
import '../../../models/governorate_model.dart' hide QualificationModel;
import '../../../models/verification_request_model.dart';
import '../../../shared/services/notification_service.dart';
import '../../../services/image_cache_service.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/profile_rules_provider.dart';
import '../services/profile_service.dart';

/// Profile state
class ProfileState {
  final ProfileDataResponse? profileData;
  final ProfileCompletionStatus? completionStatus;
  final ProfileModel? currentProfile;
  final ProfileRulesState? profileRules;
  final List<QualificationModel>? qualifications;
  final List<GovernorateModel>? governorates;
  final List<DocumentUploadModel> documents;
  final Map<String, File?> selectedDocuments;
  final bool isLoading;
  final bool isUpdating;
  final bool isUploadingDocument;
  final bool isUploadingProfilePicture;
  final bool isLoadingRules;
  final bool isLoadingQualifications;
  final bool isLoadingGovernorates;
  final bool isSubmittingVerification;
  final String? error;
  final String? successMessage;

  const ProfileState({
    this.profileData,
    this.completionStatus,
    this.currentProfile,
    this.profileRules,
    this.qualifications,
    this.governorates,
    this.documents = const [],
    this.selectedDocuments = const {},
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploadingDocument = false,
    this.isUploadingProfilePicture = false,
    this.isLoadingRules = false,
    this.isLoadingQualifications = false,
    this.isLoadingGovernorates = false,
    this.isSubmittingVerification = false,
    this.error,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileDataResponse? profileData,
    ProfileCompletionStatus? completionStatus,
    ProfileModel? currentProfile,
    ProfileRulesState? profileRules,
    List<QualificationModel>? qualifications,
    List<GovernorateModel>? governorates,
    List<DocumentUploadModel>? documents,
    Map<String, File?>? selectedDocuments,
    bool? isLoading,
    bool? isUpdating,
    bool? isUploadingDocument,
    bool? isUploadingProfilePicture,
    bool? isLoadingRules,
    bool? isLoadingQualifications,
    bool? isLoadingGovernorates,
    bool? isSubmittingVerification,
    String? error,
    String? successMessage,
  }) {
    return ProfileState(
      profileData: profileData ?? this.profileData,
      completionStatus: completionStatus ?? this.completionStatus,
      currentProfile: currentProfile ?? this.currentProfile,
      profileRules: profileRules ?? this.profileRules,
      qualifications: qualifications ?? this.qualifications,
      governorates: governorates ?? this.governorates,
      documents: documents ?? this.documents,
      selectedDocuments: selectedDocuments ?? this.selectedDocuments,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploadingDocument: isUploadingDocument ?? this.isUploadingDocument,
      isUploadingProfilePicture: isUploadingProfilePicture ?? this.isUploadingProfilePicture,
      isLoadingRules: isLoadingRules ?? this.isLoadingRules,
      isLoadingQualifications: isLoadingQualifications ?? this.isLoadingQualifications,
      isLoadingGovernorates: isLoadingGovernorates ?? this.isLoadingGovernorates,
      isSubmittingVerification: isSubmittingVerification ?? this.isSubmittingVerification,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Profile provider
class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;
  
  ProfileNotifier(this.ref) : super(const ProfileState()) {
    // Listen to authentication state changes
    _listenToAuthChanges();
  }
  
  /// Listen to authentication state changes to auto-reload profile
  void _listenToAuthChanges() {
    ref.listen<AuthState>(authProvider, (previous, next) {
      debugPrint('🔄 ProfileProvider: Auth state changed - prev: ${previous?.isAuthenticated}/${previous?.sessionExpired}, next: ${next.isAuthenticated}/${next.sessionExpired}');
      
      // If user just logged in successfully, reload profile
      if (previous != null && 
          !previous.isAuthenticated && 
          next.isAuthenticated && 
          !next.sessionExpired &&
          !next.isLoading) {
        debugPrint('🔄 ProfileProvider: User logged in, auto-reloading profile');
        Future.delayed(const Duration(milliseconds: 100), () {
          loadCurrentProfile(forceRefresh: true);
        });
      }
      
      // If session expiration was cleared, try to reload profile
      if (previous != null && 
          previous.sessionExpired && 
          !next.sessionExpired && 
          next.isAuthenticated &&
          !next.isLoading) {
        debugPrint('🔄 ProfileProvider: Session expiration cleared, auto-reloading profile');
        Future.delayed(const Duration(milliseconds: 300), () {
          loadCurrentProfile(forceRefresh: true);
        });
      }
      
      // If user logged out or session expired, clear profile
      if (previous != null && 
          previous.isAuthenticated && 
          (!next.isAuthenticated || next.sessionExpired)) {
        debugPrint('🔄 ProfileProvider: User logged out or session expired, clearing profile');
        state = state.copyWith(
          currentProfile: null,
          error: next.sessionExpired ? 
            (next.sessionExpiredReason ?? 'انتهت صلاحية جلسة العمل') : 
            'تم تسجيل الخروج',
        );
      }
    });
  }

  /// Load profile data
  Future<void> loadProfile({bool forceRefresh = false}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      debugPrint('📋 ProfileProvider: Loading profile data (forceRefresh: $forceRefresh)');
      
      // Load all data concurrently
      final results = await Future.wait([
        LocalProfileService.getCurrentProfile(forceRefresh: forceRefresh),
        LocalProfileService.getGovernorates(),
        LocalProfileService.getQualifications(),
        LocalProfileService.getUserDocuments(),
      ]);
      
      final profile = results[0] as ProfileModel?;
      final governoratesData = results[1] as List<dynamic>;
      final qualificationsData = results[2] as List<dynamic>;
      final documents = results[3] as List<DocumentUploadModel>;
      
      // Convert data to proper models
      List<GovernorateModel> governorates = [];
      List<QualificationModel> qualifications = [];
      
      try {
        governorates = governoratesData.map((data) => 
          GovernorateModel.fromJson(data as Map<String, dynamic>)
        ).toList();
        debugPrint('✅ ProfileProvider: Governorates converted successfully');
      } catch (e) {
        debugPrint('❌ ProfileProvider: Error converting governorates: $e');
      }
      
      try {
        for (final data in qualificationsData) {
          try {
            if (data != null && data is Map<String, dynamic>) {
              // Additional null safety for boolean fields
              final Map<String, dynamic> safeData = Map<String, dynamic>.from(data);
              
              // Ensure boolean fields have safe defaults
              safeData['isActive'] ??= true;
              safeData['requiresDocument'] ??= false;
              
              final qualification = QualificationModel.fromJson(safeData);
              qualifications.add(qualification);
            }
          } catch (e) {
            debugPrint('❌ ProfileProvider: Error parsing qualification in loadProfile: $e');
            continue;
          }
        }
        debugPrint('✅ ProfileProvider: Qualifications converted successfully');
      } catch (e) {
        debugPrint('❌ ProfileProvider: Error converting qualifications: $e');
      }
      
      state = state.copyWith(
        currentProfile: profile,
        governorates: governorates,
        qualifications: qualifications,
        documents: documents,
        isLoading: false,
      );
      
      debugPrint('✅ ProfileProvider: Profile data loaded successfully');
      debugPrint('✅ Loaded ${governorates.length} governorates');
      debugPrint('✅ Loaded ${qualifications.length} qualifications');
      
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      debugPrint('❌ ProfileProvider: Error loading profile data: $e');
    }
  }

  /// Update profile
  Future<bool> updateProfile(ProfileUpdateRequest request) async {
    try {
      state = state.copyWith(isUpdating: true, error: null, successMessage: null);
      
      debugPrint('💾 ProfileProvider: Updating profile');
      
      final response = await LocalProfileService.updateProfileData(request);
      
      if (response.success) {
        // Clear cache to force fresh data fetch
        await LocalProfileService.clearCache();
        
        // Reload current profile with fresh data
        await loadCurrentProfile(forceRefresh: true);
        
        // Reload completion status - تعطيل مؤقت بسبب خطأ 404
        // final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        final completionStatus = null;
        
        state = state.copyWith(
          completionStatus: completionStatus,
          isUpdating: false,
          successMessage: 'تم تحديث الملف الشخصي بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Profile updated successfully');
        
        NotificationService.showSuccess('تم تحديث الملف الشخصي بنجاح');
        
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'فشل في تحديث الملف الشخصي',
        );
        
        NotificationService.showError('فشل في تحديث الملف الشخصي');
        
        return false;
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      state = state.copyWith(
        isUpdating: false,
        error: errorMessage,
      );
      debugPrint('❌ ProfileProvider: Error updating profile: $e');
      
      NotificationService.showError(errorMessage);
      
      return false;
    }
  }

  /// Upload document
  Future<bool> uploadDocument({
    required String documentType,
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      state = state.copyWith(isUploadingDocument: true, error: null, successMessage: null);
      
      debugPrint('📄 ProfileProvider: Uploading document: $documentType');
      
      final document = await LocalProfileService.uploadDocument(
        documentType: documentType,
        fileUrl: fileUrl,
        fileName: fileName,
      );
      
      if (document != null) {
        // Add new document to the list
        final updatedDocuments = [...state.documents, document];
        
        // Reload completion status - تعطيل مؤقت بسبب خطأ 404
        // final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        final completionStatus = null;
        
        state = state.copyWith(
          documents: updatedDocuments,
          completionStatus: completionStatus,
          isUploadingDocument: false,
          successMessage: 'تم رفع الوثيقة بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Document uploaded successfully');
        
        NotificationService.showSuccess('تم رفع الوثيقة بنجاح');
        
        return true;
      } else {
        throw Exception('فشل في رفع الوثيقة');
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      state = state.copyWith(
        isUploadingDocument: false,
        error: errorMessage,
      );
      debugPrint('❌ ProfileProvider: Error uploading document: $e');
      
      NotificationService.showError(errorMessage);
      
      return false;
    }
  }

  /// Delete document
  Future<bool> deleteDocument(String documentId) async {
    try {
      debugPrint('🗑️ ProfileProvider: Deleting document: $documentId');
      
      final success = await LocalProfileService.deleteDocument(documentId);
      
      if (success) {
        // Remove document from the list
        final updatedDocuments = state.documents
            .where((doc) => doc.id != documentId)
            .toList();
        
        // Reload completion status - تعطيل مؤقت بسبب خطأ 404
        // final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        final completionStatus = null;
        
        state = state.copyWith(
          documents: updatedDocuments,
          completionStatus: completionStatus,
          successMessage: 'تم حذف الوثيقة بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Document deleted successfully');
        
        NotificationService.showSuccess('تم حذف الوثيقة بنجاح');
        
        return true;
      } else {
        throw Exception('فشل في حذف الوثيقة');
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      state = state.copyWith(
        error: errorMessage,
      );
      debugPrint('❌ ProfileProvider: Error deleting document: $e');
      
      NotificationService.showError(errorMessage);
      
      return false;
    }
  }

  /// Submit profile for verification
  Future<bool> submitForVerification() async {
    try {
      debugPrint('✅ ProfileProvider: Submitting profile for verification');
      
      final success = await LocalProfileService.submitForVerification();
      
      if (success) {
        // Reload completion status
        final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        
        state = state.copyWith(
          completionStatus: completionStatus,
          successMessage: 'تم إرسال طلب التوثيق بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Profile submitted for verification successfully');
        
        NotificationService.showSuccess('تم إرسال طلب التوثيق بنجاح وهو قيد المراجعة');
        
        return true;
      } else {
        throw Exception('فشل في إرسال طلب التوثيق');
      }
    } catch (e) {
      state = state.copyWith(
        error: 'فشل في إرسال طلب التوثيق: $e',
      );
      debugPrint('❌ ProfileProvider: Error submitting for verification: $e');
      
      NotificationService.showError('فشل في إرسال طلب التوثيق');
      
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success message
  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  /// Load profile rules using ProfileRulesProvider
  Future<void> loadVerificationRules() async {
    try {
      state = state.copyWith(isLoadingRules: true, error: null);
      
      debugPrint('📋 ProfileProvider: Loading profile rules');
      
      // استخدام ProfileRulesProvider الجديد
      final profileRulesNotifier = ref.read(profileRulesProvider.notifier);
      await profileRulesNotifier.loadRules(forceRefresh: true);
      
      final profileRulesState = ref.read(profileRulesProvider);
      
      state = state.copyWith(
        profileRules: profileRulesState,
        isLoadingRules: false,
      );
      
      debugPrint('✅ ProfileProvider: Profile rules loaded successfully');
    } catch (e) {
      state = state.copyWith(
        isLoadingRules: false,
        error: 'فشل في جلب قواعد التوثيق: $e',
      );
      debugPrint('❌ ProfileProvider: Error loading profile rules: $e');
    }
  }

  /// Load governorates
  Future<void> loadGovernorates() async {
    try {
      state = state.copyWith(isLoadingGovernorates: true, error: null);
      
      debugPrint('🏛️ ProfileProvider: Loading governorates');
      
      final governoratesData = await LocalProfileService.getGovernorates();
      final governorates = governoratesData.map((data) => 
        GovernorateModel.fromJson(data as Map<String, dynamic>)
      ).toList();
      
      state = state.copyWith(
        governorates: governorates,
        isLoadingGovernorates: false,
      );
      
      debugPrint('✅ ProfileProvider: Loaded ${governorates.length} governorates');
    } catch (e) {
      debugPrint('❌ ProfileProvider: Error loading governorates: $e');
      state = state.copyWith(
        isLoadingGovernorates: false,
        error: 'فشل في تحميل قائمة المحافظات: $e',
      );
    }
  }

  /// Load qualifications
  Future<void> loadQualifications() async {
    try {
      state = state.copyWith(isLoadingQualifications: true, error: null);
      
      debugPrint('🎓 ProfileProvider: Loading qualifications');
      
      final qualificationsData = await LocalProfileService.getQualifications();
      
      // Enhanced null safety checks and error handling
      if (qualificationsData == null) {
        debugPrint('⚠️ ProfileProvider: Qualifications data is null');
        state = state.copyWith(
          qualifications: [],
          isLoadingQualifications: false,
        );
        return;
      }
      
      final List<QualificationModel> qualifications = [];
      
      for (final data in qualificationsData) {
        try {
          if (data != null && data is Map<String, dynamic>) {
            // Additional null safety for boolean fields
            final Map<String, dynamic> safeData = Map<String, dynamic>.from(data);
            
            // Ensure boolean fields have safe defaults
            safeData['isActive'] ??= true;
            safeData['requiresDocument'] ??= false;
            
            final qualification = QualificationModel.fromJson(safeData);
            qualifications.add(qualification);
          } else {
            debugPrint('⚠️ ProfileProvider: Skipping invalid qualification data: $data');
          }
        } catch (e) {
          debugPrint('❌ ProfileProvider: Error parsing qualification: $e');
          debugPrint('❌ Data that caused error: $data');
          // Continue processing other qualifications instead of failing completely
          continue;
        }
      }
      
      state = state.copyWith(
        qualifications: qualifications,
        isLoadingQualifications: false,
      );
      
      debugPrint('✅ ProfileProvider: Loaded ${qualifications.length} qualifications');
    } catch (e) {
      debugPrint('❌ ProfileProvider: Error loading qualifications: $e');
      state = state.copyWith(
        isLoadingQualifications: false,
        qualifications: [], // Provide empty list as fallback
        error: 'فشل في تحميل قائمة المؤهلات: $e',
      );
    }
  }

  /// Load current profile with retry mechanism and improved timing
  Future<void> loadCurrentProfile({bool forceRefresh = false, int retryCount = 0}) async {
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 500);
    const authCheckDelay = Duration(milliseconds: 300);
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      debugPrint('👤 ProfileProvider: Loading current profile (forceRefresh: $forceRefresh, retry: $retryCount)');
      
      // Wait a bit for AuthProvider to stabilize if this is the first attempt
      if (retryCount == 0) {
        await Future.delayed(authCheckDelay);
        debugPrint('👤 ProfileProvider: Waited for auth state to stabilize');
      }
      
      // Initial authentication check
      var authState = ref.read(authProvider);
      debugPrint('👤 ProfileProvider: Auth state - isAuthenticated: ${authState.isAuthenticated}, sessionExpired: ${authState.sessionExpired}, isLoading: ${authState.isLoading}');
      
      // If AuthProvider is still loading, wait a bit more
      if (authState.isLoading && retryCount < maxRetries) {
        debugPrint('👤 ProfileProvider: AuthProvider still loading, waiting...');
        await Future.delayed(const Duration(milliseconds: 500));
        authState = ref.read(authProvider);
        debugPrint('👤 ProfileProvider: Auth state after wait - isAuthenticated: ${authState.isAuthenticated}, sessionExpired: ${authState.sessionExpired}, isLoading: ${authState.isLoading}');
      }
      
      if (!authState.isAuthenticated) {
        debugPrint('❌ ProfileProvider: User not authenticated, cannot load profile');
        state = state.copyWith(
          isLoading: false,
          error: 'يجب تسجيل الدخول أولاً للوصول للملف الشخصي',
        );
        return;
      }
      
      // Check if session has expired
      if (authState.sessionExpired) {
        debugPrint('❌ ProfileProvider: Session expired, cannot load profile');
        state = state.copyWith(
          isLoading: false,
          error: authState.sessionExpiredReason ?? 'انتهت صلاحية جلسة العمل، يرجى تسجيل الدخول مرة أخرى',
        );
        return;
      }
      
      debugPrint('👤 ProfileProvider: Authentication verified, loading profile from service...');
      final currentProfile = await LocalProfileService.getCurrentProfile(forceRefresh: forceRefresh);
      
      // إضافة تسجيل تفصيلي لمعرفة قيمة profilePictureUrl
      debugPrint('🖼️ ProfileProvider: Profile loaded with profilePictureUrl: ${currentProfile?.profilePictureUrl}');
      debugPrint('🖼️ ProfileProvider: Profile loaded - full profile data: $currentProfile');
      
      state = state.copyWith(
        currentProfile: currentProfile,
        isLoading: false,
      );
      
      debugPrint('✅ ProfileProvider: Current profile loaded successfully');
    } catch (e) {
      // Check if the error is related to authentication
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('401') || 
          errorMessage.contains('unauthorized') || 
          errorMessage.contains('token') ||
          errorMessage.contains('session') ||
          errorMessage.contains('authentication')) {
        debugPrint('❌ ProfileProvider: Authentication error detected: $e');
        
        // Wait a bit for SessionManager to notify AuthProvider
        await Future.delayed(const Duration(milliseconds: 150));
        
        // Re-check authentication status after delay
        final updatedAuthState = ref.read(authProvider);
        debugPrint('👤 ProfileProvider: Updated auth state - isAuthenticated: ${updatedAuthState.isAuthenticated}, sessionExpired: ${updatedAuthState.sessionExpired}');
        
        // If still authenticated and we haven't exceeded retry limit, try again
        if (updatedAuthState.isAuthenticated && 
            !updatedAuthState.sessionExpired && 
            retryCount < maxRetries) {
          debugPrint('🔄 ProfileProvider: Retrying profile load after auth error (attempt ${retryCount + 1})');
          await Future.delayed(retryDelay);
          return loadCurrentProfile(forceRefresh: forceRefresh, retryCount: retryCount + 1);
        }
        
        // If session is actually expired or max retries reached
        if (updatedAuthState.sessionExpired) {
          debugPrint('❌ ProfileProvider: Session confirmed expired after retry');
          state = state.copyWith(
            isLoading: false,
            error: updatedAuthState.sessionExpiredReason ?? 'انتهت صلاحية جلسة العمل، يرجى تسجيل الدخول مرة أخرى',
          );
        } else if (!updatedAuthState.isAuthenticated) {
          debugPrint('❌ ProfileProvider: User no longer authenticated after retry');
          state = state.copyWith(
            isLoading: false,
            error: 'يجب تسجيل الدخول أولاً للوصول للملف الشخصي',
          );
        } else {
          // Clear session expiration state and show generic auth error
          debugPrint('🔄 ProfileProvider: Clearing session expiration and showing auth error');
          ref.read(authProvider.notifier).clearSessionExpiration();
          
          state = state.copyWith(
            isLoading: false,
            error: 'خطأ في المصادقة، يرجى المحاولة مرة أخرى',
          );
        }
      } else {
        // Non-authentication error
        debugPrint('❌ ProfileProvider: Non-auth error: $e');
        state = state.copyWith(
          isLoading: false,
          error: 'فشل في جلب بيانات الملف الشخصي: $e',
        );
      }
      debugPrint('❌ ProfileProvider: Error loading current profile: $e');
    }
  }

  /// Upload profile picture
  Future<bool> uploadProfilePicture(File imageFile) async {
    try {
      state = state.copyWith(isUploadingProfilePicture: true, error: null, successMessage: null);
      
      debugPrint('📸 ProfileProvider: Uploading profile picture');
      
      final response = await LocalProfileService.uploadProfilePicture(imageFile);
      
      // If we reach here, upload was successful (no exception thrown)
      debugPrint('✅ ProfileProvider: Profile picture upload response received: $response');
      
      // Extract the new image URL from the response
      String? newImageUrl;
      if (response != null && response.url != null) {
        newImageUrl = response.url;
        debugPrint('🖼️ ProfileProvider: New image URL from upload response: $newImageUrl');
        
        // Update the current profile immediately with the new image URL
        if (state.currentProfile != null) {
          final updatedProfile = state.currentProfile!.copyWith(
            profilePictureUrl: newImageUrl,
          );
          
          state = state.copyWith(
            currentProfile: updatedProfile,
            isUploadingProfilePicture: false,
            successMessage: 'تم تحديث صورة الملف الشخصي بنجاح',
          );
          
          debugPrint('🔄 ProfileProvider: Profile updated immediately with new image URL');
        }
      }
      
      // Reload profile data to ensure consistency and wait for it
      await loadCurrentProfile(forceRefresh: true);
      debugPrint('🔄 ProfileProvider: Profile data reloaded from server');
      
      // Clear any cached images to force reload
      try {
        // Clear image cache for both old and new URLs
        final oldImageUrl = state.currentProfile?.profilePictureUrl;
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          await ImageCacheService.evictImage(oldImageUrl);
          debugPrint('🗑️ ProfileProvider: Cleared cache for old image: $oldImageUrl');
        }
        
        if (newImageUrl != null && newImageUrl != oldImageUrl) {
          await ImageCacheService.evictImage(newImageUrl);
          debugPrint('🗑️ ProfileProvider: Cleared cache for new image: $newImageUrl');
        }
      } catch (e) {
        debugPrint('⚠️ ProfileProvider: Error clearing image cache: $e');
      }
      
      debugPrint('✅ ProfileProvider: Profile picture uploaded successfully');
      
      NotificationService.showSuccess('تم تحديث صورة الملف الشخصي بنجاح');
      
      return true;
    } catch (e) {
      debugPrint('❌ ProfileProvider: Exception caught during profile picture upload: $e');
      debugPrint('❌ ProfileProvider: Exception type: ${e.runtimeType}');
      
      String errorMessage = 'فشل في رفع صورة الملف الشخصي';
      
      // Extract the actual error message from the exception
      String exceptionMessage = e.toString();
      if (exceptionMessage.contains('Exception:')) {
        errorMessage = exceptionMessage.replaceFirst('Exception:', '').trim();
      } else if (exceptionMessage.contains('DioException')) {
        errorMessage = 'خطأ في الاتصال بالخادم';
      }
      
      state = state.copyWith(
        isUploadingProfilePicture: false,
        error: errorMessage,
      );
      
      debugPrint('❌ ProfileProvider: Error uploading profile picture: $errorMessage');
      
      NotificationService.showError(errorMessage);
      
      return false;
    }
  }

  /// Select document for field
  void selectDocumentForField(String fieldName, File? file) {
    final updatedDocuments = Map<String, File?>.from(state.selectedDocuments);
    updatedDocuments[fieldName] = file;
    
    state = state.copyWith(selectedDocuments: updatedDocuments);
    
    debugPrint('📄 ProfileProvider: Document selected for field: $fieldName');
  }

  /// Upload document for field
  Future<bool> uploadDocumentForField({
    required String fieldName,
    required String documentType,
    required File file,
  }) async {
    try {
      state = state.copyWith(isUploadingDocument: true, error: null, successMessage: null);
      
      debugPrint('📄 ProfileProvider: Uploading document for field: $fieldName');
      
      final response = await LocalProfileService.uploadDocumentFile(
        file: file,
        documentType: documentType,
        fieldName: fieldName,
      );
      
      if (response != null) {
        // Remove the selected file for this field
        final updatedDocuments = Map<String, File?>.from(state.selectedDocuments);
        updatedDocuments.remove(fieldName);
        
        state = state.copyWith(
          selectedDocuments: updatedDocuments,
          isUploadingDocument: false,
          successMessage: 'تم رفع الوثيقة بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Document uploaded successfully for field: $fieldName');
        
        NotificationService.showSuccess('تم رفع الوثيقة بنجاح');
        
        return true;
      } else {
        throw Exception('فشل في رفع الوثيقة');
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingDocument: false,
        error: 'فشل في رفع الوثيقة: $e',
      );
      debugPrint('❌ ProfileProvider: Error uploading document for field: $e');
      
      NotificationService.showError('فشل في رفع الوثيقة');
      
      return false;
    }
  }

  /// Submit verification request
  Future<bool> submitVerificationRequest(SubmitVerificationRequest request) async {
    try {
      state = state.copyWith(isSubmittingVerification: true, error: null, successMessage: null);
      
      debugPrint('✅ ProfileProvider: Submitting verification request');
      
      final response = await LocalProfileService.submitVerificationRequest(request);
      
      if (response != null && response.success) {
        // Reload current profile to get updated verification status
        await loadCurrentProfile(forceRefresh: true);
        
        state = state.copyWith(
          isSubmittingVerification: false,
          successMessage: 'تم إرسال طلب التوثيق بنجاح',
        );
        
        debugPrint('✅ ProfileProvider: Verification request submitted successfully');
        
        NotificationService.showSuccess('تم إرسال طلب التوثيق بنجاح وهو قيد المراجعة');
        
        return true;
      } else {
        throw Exception('فشل في إرسال طلب التوثيق');
      }
    } catch (e) {
      state = state.copyWith(
        isSubmittingVerification: false,
        error: 'فشل في إرسال طلب التوثيق: $e',
      );
      debugPrint('❌ ProfileProvider: Error submitting verification request: $e');
      
      NotificationService.showError('فشل في إرسال طلب التوثيق');
      
      return false;
    }
  }

  /// Update profile data
  Future<bool> updateProfileData(ProfileUpdateRequest request) async {
    try {
      state = state.copyWith(isUpdating: true, error: null, successMessage: null);
      
      debugPrint('💾 ProfileProvider: Updating profile data');
      
      final response = await LocalProfileService.updateProfileData(request);
      
      if (response.success) {
        // Clear cache to force fresh data fetch
        await LocalProfileService.clearCache();
        
        // Reload current profile to get updated data
        await loadCurrentProfile(forceRefresh: true);
        
        state = state.copyWith(
          isUpdating: false,
          successMessage: response.message,
        );
        
        debugPrint('✅ ProfileProvider: Profile data updated successfully');
        
        NotificationService.showSuccess(response.message);
        
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: response.message,
        );
        
        NotificationService.showError(response.message);
        
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'فشل في تحديث البيانات: $e',
      );
      debugPrint('❌ ProfileProvider: Error updating profile data: $e');
      
      NotificationService.showError('فشل في تحديث بيانات الملف الشخصي');
      
      return false;
    }
  }

  /// Initialize profile page data
  Future<void> initializeProfilePage({bool forceRefresh = false}) async {
    await Future.wait([
      loadCurrentProfile(forceRefresh: forceRefresh),
      loadVerificationRules(),
      loadQualifications(),
      loadGovernorates(),
    ]);
  }

  /// Refresh profile data
  Future<void> refresh() async {
    // Clear cache to ensure fresh data
    await LocalProfileService.clearCache();
    
    // Force refresh all data
    await loadProfile(forceRefresh: true);
  }

  /// Get user-friendly error message in Arabic
  String _getErrorMessage(dynamic error) {
    if (error == null) return 'حدث خطأ غير معروف';
    
    String errorString = error.toString().toLowerCase();
    
    // Network connectivity errors
    if (errorString.contains('لا يوجد اتصال بالإنترنت') || 
        errorString.contains('no internet') ||
        errorString.contains('network')) {
      return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.';
    }
    
    // Authentication errors
    if (errorString.contains('لم يتم العثور على رمز المصادقة') ||
        errorString.contains('authentication') ||
        errorString.contains('unauthorized') ||
        errorString.contains('401')) {
      return 'انتهت صلاحية جلسة العمل. يرجى تسجيل الدخول مرة أخرى.';
    }
    
    // Server errors
    if (errorString.contains('500') || errorString.contains('server error')) {
      return 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';
    }
    
    // Timeout errors
    if (errorString.contains('timeout') || errorString.contains('انتهت المهلة')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
    }
    
    // File upload errors
    if (errorString.contains('upload') || errorString.contains('رفع')) {
      return 'فشل في رفع الملف. يرجى التحقق من حجم الملف ونوعه والمحاولة مرة أخرى.';
    }
    
    // Profile update errors
    if (errorString.contains('update') || errorString.contains('تحديث')) {
      return 'فشل في تحديث البيانات. يرجى التحقق من البيانات المدخلة والمحاولة مرة أخرى.';
    }
    
    // Document errors
    if (errorString.contains('document') || errorString.contains('وثيقة')) {
      return 'فشل في معالجة الوثيقة. يرجى المحاولة مرة أخرى.';
    }
    
    // Verification errors
    if (errorString.contains('verification') || errorString.contains('تحقق')) {
      return 'فشل في عملية التحقق. يرجى المحاولة مرة أخرى.';
    }
    
    // Generic error message
    return 'حدث خطأ أثناء معالجة طلبك. يرجى المحاولة مرة أخرى.';
  }
}

/// Profile provider
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

/// Profile notifier provider (alias for profileProvider)
final profileNotifierProvider = profileProvider;

/// Profile data provider (for easy access to profile data)
final profileDataProvider = Provider<ProfileDataResponse?>((ref) {
  return ref.watch(profileProvider).profileData;
});

/// Profile completion status provider
final profileCompletionStatusProvider = Provider<ProfileCompletionStatus?>((ref) {
  return ref.watch(profileProvider).completionStatus;
});

/// Profile documents provider
final profileDocumentsProvider = Provider<List<DocumentUploadModel>>((ref) {
  return ref.watch(profileProvider).documents;
});

/// Profile loading state provider
final profileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoading;
});

/// Profile updating state provider
final profileUpdatingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isUpdating;
});

/// Profile error provider
final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileProvider).error;
});

/// Profile success message provider
final profileSuccessMessageProvider = Provider<String?>((ref) {
  return ref.watch(profileProvider).successMessage;
});

/// User documents provider
final userDocumentsProvider = Provider<List<DocumentUploadModel>>((ref) {
  return ref.watch(profileProvider).documents;
});

/// Required documents provider
final requiredDocumentsProvider = Provider<List<DocumentUploadModel>>((ref) {
  // For now, return empty list. This should be implemented based on your requirements
  return [];
});

/// Current profile provider
final currentProfileProvider = Provider<ProfileModel?>((ref) {
  return ref.watch(profileProvider).currentProfile;
});

/// Profile rules provider (updated to use ProfileRulesState)
final verificationRulesProvider = Provider<ProfileRulesState?>((ref) {
  return ref.watch(profileProvider).profileRules;
});

/// Qualifications provider
final qualificationsProvider = Provider<List<QualificationModel>?>((ref) {
  return ref.watch(profileProvider).qualifications;
});

/// Selected documents provider
final selectedDocumentsProvider = Provider<Map<String, File?>>((ref) {
  return ref.watch(profileProvider).selectedDocuments;
});

/// Profile picture uploading state provider
final profilePictureUploadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isUploadingProfilePicture;
});

/// Verification rules loading state provider
final verificationRulesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoadingRules;
});

/// Qualifications loading state provider
final qualificationsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoadingQualifications;
});

/// Verification submitting state provider
final verificationSubmittingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isSubmittingVerification;
});
