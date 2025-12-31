import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/governorate_model.dart';
import '../../../models/profile_data_models.dart';
import '../../../models/profile_model.dart';
import '../../../models/verification_request_model.dart';
import '../../../providers/profile_rules_provider.dart';
import '../../../services/authenticated_image_service.dart';
import '../../../core/auth/auth.dart';
import '../../../services/image_cache_service.dart';
import '../../../shared/services/notification_service.dart';
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
      isUploadingProfilePicture:
          isUploadingProfilePicture ?? this.isUploadingProfilePicture,
      isLoadingRules: isLoadingRules ?? this.isLoadingRules,
      isLoadingQualifications:
          isLoadingQualifications ?? this.isLoadingQualifications,
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      isSubmittingVerification:
          isSubmittingVerification ?? this.isSubmittingVerification,
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
    
    // Initialize profile if user is already authenticated (e.g., app restart)
    _initializeIfAuthenticated();
  }
  
  /// Initialize profile if user is already authenticated
  Future<void> _initializeIfAuthenticated() async {
    // Small delay to ensure auth state is ready
    await Future.delayed(const Duration(milliseconds: 500));
    
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && state.currentProfile == null) {
      debugPrint('🔄 ProfileProvider: User already authenticated, loading profile on init');
      
      // Clear cache first
      try {
        await LocalProfileService.clearCache();
        debugPrint('✅ ProfileProvider: Cache cleared on init');
      } catch (e) {
        debugPrint('⚠️ ProfileProvider: Error clearing cache on init: $e');
      }
      
      // Load profile with qualifications and governorates
      // Use initializeProfilePage to ensure all reference data is available
      await initializeProfilePage(forceRefresh: true);
    }
  }

  /// تحديث الحالة بأمان مع فحص mounted
  void _safeUpdateState(ProfileState Function() updateFunction) {
    if (mounted) {
      state = updateFunction();
    }
  }

  /// تحديث الحالة مع الحفاظ على الملف الشخصي الحالي
  void _safeUpdateStatePreservingProfile(
      ProfileState Function() updateFunction) {
    if (mounted) {
      final currentProfile = state.currentProfile;
      debugPrint(
          '🔄 ProfileProvider: Before update - currentProfile exists: ${currentProfile != null}');

      state = updateFunction();

      // إذا فقد الملف الشخصي، استرده
      if (state.currentProfile == null && currentProfile != null) {
        state = state.copyWith(currentProfile: currentProfile);
        debugPrint(
            '🔄 ProfileProvider: Restored currentProfile after state update');
      } else if (state.currentProfile != null) {
        debugPrint('🔄 ProfileProvider: Profile preserved successfully');
      } else {
        debugPrint('⚠️ ProfileProvider: No profile to preserve');
      }
    }
  }

  /// Listen to authentication state changes to auto-reload profile
  void _listenToAuthChanges() {
    // Use ref.listen to listen to auth state changes
    ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        // If user logged out, clear profile state
        if (previous?.isAuthenticated == true && !next.isAuthenticated) {
          debugPrint('🔄 ProfileProvider: User logged out, clearing profile state');
          _clearProfileState();
          
          // مسح كاش الصور أيضاً
          Future.microtask(() async {
            try {
              await ImageCacheService.clearAllCache();
              AuthenticatedImageService.clearAllImageCache();
              debugPrint('✅ ProfileProvider: Image cache cleared after logout');
            } catch (e) {
              debugPrint('⚠️ ProfileProvider: Error clearing image cache: $e');
            }
          });
        }
        // If user logged in, load profile
        else if ((previous == null || !previous.isAuthenticated) && next.isAuthenticated) {
          debugPrint('🔄 ProfileProvider: User logged in, loading profile');
          debugPrint('🔄 ProfileProvider: Previous auth: ${previous?.isAuthenticated}, Next auth: ${next.isAuthenticated}');
          debugPrint('🔄 ProfileProvider: User ID: ${next.user?.id}');
          
          // Clear cache first to ensure fresh data
          // Use async operation in the listener
          Future.microtask(() async {
            try {
              await LocalProfileService.clearCache();
              debugPrint('✅ ProfileProvider: Cache cleared after login');
            } catch (e) {
              debugPrint('⚠️ ProfileProvider: Error clearing cache: $e');
            }
            
            // Use a delay to ensure auth state and tokens are fully ready
            await Future.delayed(const Duration(milliseconds: 500));
            
            if (mounted) {
              debugPrint('🔄 ProfileProvider: Loading profile after login with force refresh');
              // Use initializeProfilePage to ensure qualifications and governorates are also loaded
              // This prevents "غير محدد" from appearing when displaying qualification
              await initializeProfilePage(forceRefresh: true);
              debugPrint('✅ ProfileProvider: Profile, qualifications, and governorates loaded successfully after login');
            }
          });
        }
        // Also refresh profile if user was already authenticated and auth state is refreshed
        // Check if user ID changed or if we need to refresh (e.g., after admin approval)
        else if (previous?.isAuthenticated == true && next.isAuthenticated) {
          // If user ID changed, it's a different user
          if (previous?.user?.id != next.user?.id) {
            debugPrint('🔄 ProfileProvider: User changed, loading new profile');
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                loadCurrentProfile(forceRefresh: true);
              }
            });
          }
          // If same user but we want to refresh (e.g., after profile edit or admin approval)
          // We'll check if profile data is missing or stale
          else if (state.currentProfile == null) {
            debugPrint('🔄 ProfileProvider: Authenticated but no profile data, loading profile');
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                loadCurrentProfile(forceRefresh: true);
              }
            });
          }
        }
      },
    );
  }

  /// Clear profile state completely
  void _clearProfileState() {
    if (mounted) {
      // مسح جميع البيانات بما في ذلك المستندات
      state = const ProfileState(
        documents: [],
        selectedDocuments: {},
      );
      debugPrint('✅ ProfileProvider: Profile state cleared (including documents)');
    }
  }

  /// Load profile data
  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (!mounted) return;

    try {
      _safeUpdateState(() => state.copyWith(isLoading: true, error: null));

      debugPrint(
          '📋 ProfileProvider: Loading profile data (forceRefresh: $forceRefresh)');

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
        governorates = governoratesData
            .map((data) =>
                GovernorateModel.fromJson(data as Map<String, dynamic>))
            .toList();
        debugPrint('✅ ProfileProvider: Governorates converted successfully');
      } catch (e) {
        debugPrint('❌ ProfileProvider: Error converting governorates: $e');
      }

      try {
        for (final data in qualificationsData) {
          try {
            if (data != null && data is Map<String, dynamic>) {
              // Additional null safety for boolean fields
              final Map<String, dynamic> safeData =
                  Map<String, dynamic>.from(data);

              // Ensure boolean fields have safe defaults
              safeData['isActive'] ??= true;
              safeData['requiresDocument'] ??= false;
              
              // Ensure categoryId exists (required field)
              if (safeData['categoryId'] == null || safeData['categoryId'].toString().isEmpty) {
                debugPrint('⚠️ ProfileProvider: Qualification missing categoryId: ${safeData['id']}');
                // Skip qualifications without categoryId
                continue;
              }
              
              // Convert displayOrder/order to sortOrder for compatibility
              if (safeData['displayOrder'] != null) {
                safeData['sortOrder'] = safeData['displayOrder'];
              } else if (safeData['order'] != null) {
                safeData['sortOrder'] = safeData['order'];
              }

              final qualification = QualificationModel.fromJson(safeData);
              qualifications.add(qualification);
            }
          } catch (e) {
            debugPrint(
                '❌ ProfileProvider: Error parsing qualification in loadProfile: $e');
            continue;
          }
        }
        
        // Sort qualifications by sortOrder (displayOrder)
        qualifications.sort((a, b) {
          final orderA = a.sortOrder ?? 0;
          final orderB = b.sortOrder ?? 0;
          return orderA.compareTo(orderB);
        });
        
        debugPrint('✅ ProfileProvider: Qualifications converted and sorted successfully');
      } catch (e) {
        debugPrint('❌ ProfileProvider: Error converting qualifications: $e');
      }

      _safeUpdateState(() => state.copyWith(
            currentProfile: profile,
            governorates: governorates,
            qualifications: qualifications,
            documents: documents,
            isLoading: false,
          ));

      debugPrint('✅ ProfileProvider: Profile data loaded successfully');
      debugPrint('✅ Loaded ${governorates.length} governorates');
      debugPrint('✅ Loaded ${qualifications.length} qualifications');
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      // التحقق من أن الـ notifier لم يتم dispose قبل تحديث الحالة
      _safeUpdateState(() => state.copyWith(
            isLoading: false,
            error: errorMessage,
          ));
      debugPrint('❌ ProfileProvider: Error loading profile data: $e');
    }
  }

  /// Update profile
  Future<bool> updateProfile(ProfileUpdateRequest request) async {
    if (!mounted) return false;

    try {
      _safeUpdateState(() =>
          state.copyWith(isUpdating: true, error: null, successMessage: null));

      debugPrint('💾 ProfileProvider: Updating profile');

      final response = await LocalProfileService.updateProfileData(request);

      if (response.success) {
        // Clear cache to force fresh data fetch
        await LocalProfileService.clearCache();

        // Reload current profile with fresh data - مع معالجة الأخطاء
        try {
          await loadCurrentProfile(forceRefresh: true);
        } catch (e) {
          debugPrint(
              '⚠️ ProfileProvider: Failed to reload profile after update: $e');
          // لا نريد أن يفشل التحديث بسبب فشل إعادة التحميل
          // سنحاول إعادة التحميل لاحقاً
        }

        // Reload completion status - تعطيل مؤقت بسبب خطأ 404
        // final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        const completionStatus = null;

        _safeUpdateState(() => state.copyWith(
              completionStatus: completionStatus,
              isUpdating: false,
              successMessage: 'تم تحديث الملف الشخصي بنجاح',
              error: null, // Clear any previous errors
            ));

        debugPrint('✅ ProfileProvider: Profile updated successfully');

        NotificationService.showSuccess('تم تحديث الملف الشخصي بنجاح');

        return true;
      } else {
        _safeUpdateState(() => state.copyWith(
              isUpdating: false,
              error: 'فشل في تحديث الملف الشخصي',
            ));

        NotificationService.showError('فشل في تحديث الملف الشخصي');

        return false;
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      _safeUpdateState(() => state.copyWith(
            isUpdating: false,
            error: errorMessage,
          ));
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
    if (!mounted) return false;

    try {
      _safeUpdateState(() => state.copyWith(
          isUploadingDocument: true, error: null, successMessage: null));

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
        const completionStatus = null;

        _safeUpdateState(() => state.copyWith(
              documents: updatedDocuments,
              completionStatus: completionStatus,
              isUploadingDocument: false,
              successMessage: 'تم رفع الوثيقة بنجاح',
            ));

        debugPrint('✅ ProfileProvider: Document uploaded successfully');

        NotificationService.showSuccess('تم رفع الوثيقة بنجاح');

        return true;
      } else {
        throw Exception('فشل في رفع الوثيقة');
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      _safeUpdateState(() => state.copyWith(
            isUploadingDocument: false,
            error: errorMessage,
          ));
      debugPrint('❌ ProfileProvider: Error uploading document: $e');

      NotificationService.showError(errorMessage);

      return false;
    }
  }

  /// Delete document
  Future<bool> deleteDocument(String documentId) async {
    if (!mounted) return false;

    try {
      debugPrint('🗑️ ProfileProvider: Deleting document: $documentId');

      final success = await LocalProfileService.deleteDocument(documentId);

      if (success) {
        // Remove document from the list
        final updatedDocuments =
            state.documents.where((doc) => doc.id != documentId).toList();

        // Reload completion status - تعطيل مؤقت بسبب خطأ 404
        // final completionStatus = await LocalProfileService.getProfileCompletionStatus();
        const completionStatus = null;

        _safeUpdateState(() => state.copyWith(
              documents: updatedDocuments,
              completionStatus: completionStatus,
              successMessage: 'تم حذف الوثيقة بنجاح',
            ));

        debugPrint('✅ ProfileProvider: Document deleted successfully');

        NotificationService.showSuccess('تم حذف الوثيقة بنجاح');

        return true;
      } else {
        throw Exception('فشل في حذف الوثيقة');
      }
    } catch (e) {
      String errorMessage = _getErrorMessage(e);
      _safeUpdateState(() => state.copyWith(
            error: errorMessage,
          ));
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
        final completionStatus =
            await LocalProfileService.getProfileCompletionStatus();

        state = state.copyWith(
          completionStatus: completionStatus,
          successMessage: 'تم إرسال طلب التوثيق بنجاح',
        );

        debugPrint(
            '✅ ProfileProvider: Profile submitted for verification successfully');

        NotificationService.showSuccess(
            'تم إرسال طلب التوثيق بنجاح وهو قيد المراجعة');

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
      await profileRulesNotifier.loadRulesForCurrentUser(forceRefresh: true);

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
  Future<void> loadGovernorates({bool forceRefresh = false}) async {
    try {
      state = state.copyWith(isLoadingGovernorates: true, error: null);

      debugPrint('🏛️ ProfileProvider: Loading governorates (forceRefresh: $forceRefresh)');

      final governoratesData = await LocalProfileService.getGovernorates();
      final governorates = governoratesData
          .map(
              (data) => GovernorateModel.fromJson(data as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        governorates: governorates,
        isLoadingGovernorates: false,
      );

      debugPrint(
          '✅ ProfileProvider: Loaded ${governorates.length} governorates');
    } catch (e) {
      debugPrint('❌ ProfileProvider: Error loading governorates: $e');
      state = state.copyWith(
        isLoadingGovernorates: false,
        error: 'فشل في تحميل قائمة المحافظات: $e',
      );
    }
  }

  /// Load qualifications
  Future<void> loadQualifications({bool forceRefresh = false}) async {
    try {
      state = state.copyWith(isLoadingQualifications: true, error: null);

      debugPrint('🎓 ProfileProvider: Loading qualifications (forceRefresh: $forceRefresh)');

      final qualificationsData = await LocalProfileService.getQualifications();

      final List<QualificationModel> qualifications = [];

      for (final data in qualificationsData) {
        try {
          if (data != null && data is Map<String, dynamic>) {
            // Additional null safety for boolean fields
            final Map<String, dynamic> safeData =
                Map<String, dynamic>.from(data);

            // Ensure boolean fields have safe defaults
            safeData['isActive'] ??= true;
            safeData['requiresDocument'] ??= false;

            final qualification = QualificationModel.fromJson(safeData);
            qualifications.add(qualification);
          } else {
            debugPrint(
                '⚠️ ProfileProvider: Skipping invalid qualification data: $data');
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

      debugPrint(
          '✅ ProfileProvider: Loaded ${qualifications.length} qualifications');
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
  Future<void> loadCurrentProfile(
      {bool forceRefresh = false, int retryCount = 0}) async {
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 1000);
    const authCheckDelay = Duration(milliseconds: 500);

    try {
      // Only set loading state if this is the first attempt
      if (retryCount == 0) {
        _safeUpdateState(() => state.copyWith(isLoading: true, error: null));
      }

      // Wait a bit for AuthProvider to stabilize if this is the first attempt
      if (retryCount == 0) {
        await Future.delayed(authCheckDelay);
      }

      // Initial authentication check - استخدام compatibleAuthProvider بدلاً من enhancedAuthProvider
      final authState = ref.read(authProvider);

      // If AuthProvider is still loading, wait a bit more
      if (authState.isLoading && retryCount < maxRetries) {
        await Future.delayed(const Duration(milliseconds: 1000));
        final updatedAuthState = ref.read(authProvider);
        if (!updatedAuthState.isAuthenticated) {
          debugPrint(
              '❌ ProfileProvider: User not authenticated after loading, cannot load profile');
          _safeUpdateState(() => state.copyWith(
                isLoading: false,
                error: 'يجب تسجيل الدخول أولاً للوصول للملف الشخصي',
              ));
          return;
        }
      }

      if (!authState.isAuthenticated) {
        debugPrint(
            '❌ ProfileProvider: User not authenticated, cannot load profile');
        _safeUpdateState(() => state.copyWith(
              isLoading: false,
              error: 'يجب تسجيل الدخول أولاً للوصول للملف الشخصي',
            ));
        return;
      }

      // Check if session has expired
      if (authState.isSessionExpired) {
        debugPrint('❌ ProfileProvider: Session expired, cannot load profile');
        _safeUpdateState(() => state.copyWith(
              isLoading: false,
              error: 'انتهت صلاحية جلسة العمل، يرجى تسجيل الدخول مرة أخرى',
            ));
        return;
      }

      // Clear cache if forceRefresh is true to ensure fresh data
      if (forceRefresh) {
        try {
          await LocalProfileService.clearCache();
          debugPrint('✅ ProfileProvider: Cache cleared before loading with forceRefresh');
        } catch (e) {
          debugPrint('⚠️ ProfileProvider: Error clearing cache: $e');
          // Continue anyway
        }
      }

      // Try to load profile with timeout
      ProfileModel? currentProfile;
      try {
        currentProfile = await LocalProfileService.getCurrentProfile(
                forceRefresh: forceRefresh)
            .timeout(const Duration(seconds: 10));
      } on TimeoutException {
        debugPrint('⏰ ProfileProvider: Profile loading timed out');
        if (retryCount < maxRetries) {
          debugPrint(
              '🔄 ProfileProvider: Retrying profile load due to timeout (attempt ${retryCount + 1})');
          await Future.delayed(retryDelay);
          return loadCurrentProfile(
              forceRefresh: forceRefresh, retryCount: retryCount + 1);
        } else {
          throw Exception('انتهت مهلة تحميل بيانات الملف الشخصي');
        }
      }

      // إضافة تسجيل تفصيلي لمعرفة قيمة profilePictureUrl
      debugPrint(
          '🖼️ ProfileProvider: Profile loaded with profilePictureUrl: ${currentProfile?.profilePictureUrl}');
      debugPrint(
          '🖼️ ProfileProvider: Profile loaded - full profile data: $currentProfile');

      // حساب نسبة الإكمال الجديدة وتحديث الملف الشخصي
      ProfileModel? updatedProfile = currentProfile;
      if (currentProfile != null) {
        try {
          final newCompletionPercentage =
              LocalProfileService.calculateCompletionPercentage(currentProfile);
          debugPrint(
              '📊 ProfileProvider: Calculated completion percentage: $newCompletionPercentage%');

          // تحديث الملف الشخصي بنسبة الإكمال الجديدة
          updatedProfile = currentProfile.copyWith(
            completionPercentage: newCompletionPercentage,
          );
        } catch (e) {
          debugPrint(
              '❌ ProfileProvider: Error calculating completion percentage: $e');
          // في حالة الخطأ، استخدم الملف الشخصي كما هو
          updatedProfile = currentProfile;
        }
      }

      _safeUpdateState(() => state.copyWith(
            currentProfile: updatedProfile,
            isLoading: false,
            error: null, // Clear any previous errors
          ));

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
        await Future.delayed(const Duration(milliseconds: 300));

        // Re-check authentication status after delay
        final updatedAuthState = ref.read(authProvider);
        debugPrint(
            '👤 ProfileProvider: Updated auth state - isAuthenticated: ${updatedAuthState.isAuthenticated}, sessionExpired: ${updatedAuthState.isSessionExpired}');

        // If still authenticated and we haven't exceeded retry limit, try again
        if (updatedAuthState.isAuthenticated &&
            !updatedAuthState.isSessionExpired &&
            retryCount < maxRetries) {
          debugPrint(
              '🔄 ProfileProvider: Retrying profile load after auth error (attempt ${retryCount + 1})');
          await Future.delayed(retryDelay);
          return loadCurrentProfile(
              forceRefresh: forceRefresh, retryCount: retryCount + 1);
        }

        // If session is actually expired or max retries reached
        if (updatedAuthState.isSessionExpired) {
          debugPrint(
              '❌ ProfileProvider: Session confirmed expired after retry');
          state = state.copyWith(
            isLoading: false,
            error: 'انتهت صلاحية جلسة العمل، يرجى تسجيل الدخول مرة أخرى',
          );
        } else if (!updatedAuthState.isAuthenticated) {
          debugPrint(
              '❌ ProfileProvider: User no longer authenticated after retry');
          state = state.copyWith(
            isLoading: false,
            error: 'يجب تسجيل الدخول أولاً للوصول للملف الشخصي',
          );
        } else {
          // Clear session expiration state and show generic auth error
          debugPrint(
              '🔄 ProfileProvider: Clearing session expiration and showing auth error');
          ref.read(authProvider.notifier).clearError();

          state = state.copyWith(
            isLoading: false,
            error: 'خطأ في المصادقة، يرجى المحاولة مرة أخرى',
          );
        }
      } else if (errorMessage.contains('404') ||
          errorMessage.contains('not found')) {
        // Profile not found - this might be a new user
        debugPrint(
            '❌ ProfileProvider: Profile not found (404) - might be new user');

        // If this is not a retry, try once more after a delay
        if (retryCount < maxRetries) {
          debugPrint(
              '🔄 ProfileProvider: Retrying profile load for new user (attempt ${retryCount + 1})');
          await Future.delayed(retryDelay);
          return loadCurrentProfile(
              forceRefresh: true, retryCount: retryCount + 1);
        } else {
          state = state.copyWith(
            isLoading: false,
            error:
                'لم يتم العثور على بيانات الملف الشخصي. يرجى إنشاء ملف شخصي جديد.',
          );
        }
      } else {
        // Non-authentication error
        debugPrint('❌ ProfileProvider: Non-auth error: $e');

        // If this is not a retry and it's a network error, try again
        if (retryCount < maxRetries &&
            (errorMessage.contains('network') ||
                errorMessage.contains('connection') ||
                errorMessage.contains('timeout') ||
                errorMessage.contains('dio'))) {
          debugPrint(
              '🔄 ProfileProvider: Retrying profile load due to network error (attempt ${retryCount + 1})');
          await Future.delayed(retryDelay);
          return loadCurrentProfile(
              forceRefresh: forceRefresh, retryCount: retryCount + 1);
        }

        state = state.copyWith(
          isLoading: false,
          error: 'فشل في جلب بيانات الملف الشخصي: $e',
        );
      }
      debugPrint('❌ ProfileProvider: Error loading current profile: $e');
    }
  }

  /// Upload profile picture (supports both mobile and web)
  Future<bool> uploadProfilePicture(dynamic imageFile) async {
    try {
      state = state.copyWith(
          isUploadingProfilePicture: true, error: null, successMessage: null);

      debugPrint('📸 ProfileProvider: Uploading profile picture');

      // حفظ URL الصورة القديمة قبل الرفع
      final oldImageUrl = state.currentProfile?.profilePictureUrl;
      debugPrint('🖼️ ProfileProvider: Old image URL: $oldImageUrl');

      Map<String, dynamic>? response;

      if (kIsWeb && imageFile is XFile) {
        // في بيئة الويب، استخدم XFile
        response = await LocalProfileService.uploadProfilePictureWeb(imageFile);
      } else if (imageFile is File) {
        // في بيئة الموبايل، استخدم File
        response = await LocalProfileService.uploadProfilePicture(imageFile);
      } else {
        throw Exception('نوع الملف غير مدعوم');
      }

      // If we reach here, upload was successful (no exception thrown)
      debugPrint(
          '✅ ProfileProvider: Profile picture upload response received: $response');

      // Extract the new image URL from the response
      String? newImageUrl;
      if (response != null) {
        debugPrint('🔍 ProfileProvider: Full response data: $response');

        // Backend returns FileResponseDto directly, URL is in response.url
        newImageUrl = response['url'];

        debugPrint('🔍 ProfileProvider: Extracting URL from response:');
        debugPrint('  - response["url"]: ${response['url']}');
        debugPrint('  - response["id"]: ${response['id']}');
        debugPrint('  - response["filename"]: ${response['filename']}');
        debugPrint('🖼️ ProfileProvider: Final extracted URL: $newImageUrl');

        // مسح الـ cache للصور القديمة والجديدة فوراً
        try {
          if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
            await ImageCacheService.evictImage(oldImageUrl);
            // مسح cache شامل من AuthenticatedImageService
            AuthenticatedImageService.clearImageCacheCompletely(oldImageUrl);
            debugPrint(
                '🗑️ ProfileProvider: Completely cleared cache for old image: $oldImageUrl');
          }

          if (newImageUrl != null && newImageUrl.isNotEmpty) {
            await ImageCacheService.evictImage(newImageUrl);
            // مسح cache شامل من AuthenticatedImageService
            AuthenticatedImageService.clearImageCacheCompletely(newImageUrl);
            debugPrint(
                '🗑️ ProfileProvider: Completely cleared cache for new image: $newImageUrl');

            // مسح cache إضافي للتأكد
            await Future.delayed(const Duration(milliseconds: 100));
            await ImageCacheService.evictImage(newImageUrl);
            AuthenticatedImageService.clearImageCacheCompletely(newImageUrl);
            debugPrint(
                '🗑️ ProfileProvider: Double-cleared cache completely for new image');
          }
        } catch (e) {
          debugPrint('⚠️ ProfileProvider: Error clearing image cache: $e');
        }

        // Update the current profile immediately with the new image URL
        if (state.currentProfile != null) {
          // If newImageUrl is null or empty, create a temporary URL or keep the old one
          String? finalImageUrl;

          if (newImageUrl?.isNotEmpty == true) {
            finalImageUrl = newImageUrl;
            debugPrint(
                '✅ ProfileProvider: Using new image URL: $finalImageUrl');
          } else if (oldImageUrl?.isNotEmpty == true) {
            finalImageUrl = oldImageUrl;
            debugPrint(
                '⚠️ ProfileProvider: Using old image URL as fallback: $finalImageUrl');
          } else {
            // Create a temporary URL to trigger UI update
            finalImageUrl = 'temp_${DateTime.now().millisecondsSinceEpoch}';
            debugPrint(
                '⚠️ ProfileProvider: Created temporary URL: $finalImageUrl');
          }

          final updatedProfile = state.currentProfile!.copyWith(
            profilePictureUrl: finalImageUrl,
          );

          // إشعار فوري للواجهة بالتحديث
          _safeUpdateStatePreservingProfile(() => state.copyWith(
                currentProfile: updatedProfile,
                isUploadingProfilePicture: false,
                successMessage: newImageUrl?.isNotEmpty == true
                    ? 'تم تحديث صورة الملف الشخصي بنجاح'
                    : 'تم رفع الصورة بنجاح - جاري معالجة الرابط',
                error: null, // Clear any previous errors
              ));

          debugPrint(
              '🔄 ProfileProvider: Profile updated immediately with image URL: $finalImageUrl');

          // إشعار إضافي للتأكد من تحديث الواجهة (Riverpod يتولى هذا تلقائياً)
          debugPrint(
              '🔔 ProfileProvider: State updated, Riverpod will notify listeners automatically');

          if (newImageUrl?.isEmpty == true) {
            debugPrint(
                '⚠️ ProfileProvider: Warning - newImageUrl is empty, using fallback: $finalImageUrl');
          }
        } else {
          // If currentProfile is null, just update the uploading state
          debugPrint(
              '⚠️ ProfileProvider: currentProfile is null, updating state only');
          state = state.copyWith(
            isUploadingProfilePicture: false,
            successMessage: newImageUrl?.isNotEmpty == true
                ? 'تم تحديث صورة الملف الشخصي بنجاح'
                : 'تم رفع الصورة بنجاح - جاري معالجة الرابط',
            error: null, // Clear any previous errors
          );

          // إشعار للواجهة حتى لو كان currentProfile فارغ (Riverpod يتولى هذا تلقائياً)
          debugPrint(
              '🔔 ProfileProvider: State updated, Riverpod will notify listeners automatically');
        }

        // تحديث محلي فوري بدون إعادة تحميل من الخادم لتجنب مشاكل المصادقة
        try {
          final urlToSave = newImageUrl?.isNotEmpty == true
              ? newImageUrl!
              : oldImageUrl ?? '';
          await LocalProfileService.updateProfilePictureUrlLocally(urlToSave);
          debugPrint(
              '🔄 ProfileProvider: Profile picture URL updated locally: $urlToSave');

          // تحديث الحالة مرة أخرى للتأكد من أن URL الجديد محفوظ
          if (state.currentProfile != null) {
            final finalUpdatedProfile = state.currentProfile!.copyWith(
              profilePictureUrl: urlToSave,
            );

            _safeUpdateStatePreservingProfile(() => state.copyWith(
                  currentProfile: finalUpdatedProfile,
                  successMessage: 'تم تحديث صورة الملف الشخصي بنجاح',
                ));

            debugPrint(
                '🔄 ProfileProvider: Profile state updated with final URL: $urlToSave');
          }
        } catch (e) {
          debugPrint(
              '⚠️ ProfileProvider: Failed to update local profile picture URL: $e');
        }

        // إعادة تحميل الملف الشخصي فوراً بعد التحديث لضمان التحديث
        // لا نستخدم delay لأننا نريد التحديث الفوري
        Future.microtask(() async {
          try {
            debugPrint(
                '🔄 ProfileProvider: Refreshing profile after image upload...');
            // إعادة تحميل الملف الشخصي من الخادم
            await loadCurrentProfile(forceRefresh: true);
            debugPrint(
                '✅ ProfileProvider: Profile refreshed successfully after image upload');
          } catch (e) {
            debugPrint(
                '⚠️ ProfileProvider: Error refreshing profile after upload: $e');
            // حتى لو فشل التحديث، نترك URL المحدث في state
          }
        });

        // مسح الـ cache للصورة الجديدة فقط
        try {
          if (newImageUrl != null && newImageUrl.isNotEmpty) {
            await ImageCacheService.evictImage(newImageUrl);
            AuthenticatedImageService.clearImageCache(newImageUrl);
            debugPrint(
                '🗑️ ProfileProvider: Cache cleared for new image: $newImageUrl');
          }
        } catch (e) {
          debugPrint(
              '⚠️ ProfileProvider: Error clearing cache for new image: $e');
        }

        // تأكيد إضافي أن الملف الشخصي لا يزال موجوداً
        if (state.currentProfile == null) {
          debugPrint(
              '❌ ProfileProvider: CRITICAL - Profile lost after upload! Attempting recovery...');
          // محاولة استرداد الملف الشخصي من التخزين المحلي
          try {
            final cachedProfile = await LocalProfileService.getCurrentProfile();
            if (cachedProfile != null) {
              state = state.copyWith(currentProfile: cachedProfile);
              debugPrint('✅ ProfileProvider: Profile recovered from cache');
            } else {
              debugPrint(
                  '❌ ProfileProvider: No cached profile available for recovery');
            }
          } catch (e) {
            debugPrint(
                '❌ ProfileProvider: Failed to recover profile from cache: $e');
          }
        } else {
          debugPrint(
              '✅ ProfileProvider: Profile state confirmed - still exists after upload');
        }
      }

      debugPrint('✅ ProfileProvider: Profile picture uploaded successfully');

      NotificationService.showSuccess('تم تحديث صورة الملف الشخصي بنجاح');

      return true;
    } catch (e) {
      debugPrint(
          '❌ ProfileProvider: Exception caught during profile picture upload: $e');
      debugPrint('❌ ProfileProvider: Exception type: ${e.runtimeType}');

      String errorMessage = 'فشل في رفع صورة الملف الشخصي';

      // Extract the actual error message from the exception
      String exceptionMessage = e.toString();
      if (exceptionMessage.contains('Exception:')) {
        errorMessage = exceptionMessage.replaceFirst('Exception:', '').trim();
      } else if (exceptionMessage.contains('DioException')) {
        errorMessage = 'خطأ في الاتصال بالخادم';
      }

      // استرداد الملف الشخصي في حالة فشل العملية
      if (state.currentProfile == null) {
        debugPrint(
            '🔄 ProfileProvider: Profile lost after upload failure, attempting recovery...');
        try {
          final cachedProfile = await LocalProfileService.getCurrentProfile();
          if (cachedProfile != null) {
            state = state.copyWith(
              currentProfile: cachedProfile,
              isUploadingProfilePicture: false,
              error: errorMessage,
            );
            debugPrint(
                '✅ ProfileProvider: Profile restored from cache after upload failure');
          } else {
            state = state.copyWith(
              isUploadingProfilePicture: false,
              error: errorMessage,
            );
            debugPrint(
                '❌ ProfileProvider: No cached profile available for recovery');
          }
        } catch (e) {
          state = state.copyWith(
            isUploadingProfilePicture: false,
            error: errorMessage,
          );
          debugPrint(
              '❌ ProfileProvider: Failed to recover profile from cache: $e');
        }
      } else {
        state = state.copyWith(
          isUploadingProfilePicture: false,
          error: errorMessage,
        );
      }

      debugPrint(
          '❌ ProfileProvider: Error uploading profile picture: $errorMessage');

      NotificationService.showError(errorMessage);

      return false;
    }
  }

  /// Remove profile picture
  Future<bool> removeProfilePicture() async {
    try {
      state = state.copyWith(
          isUploadingProfilePicture: true, error: null, successMessage: null);

      debugPrint('🗑️ ProfileProvider: Removing profile picture');

      // حفظ URL الصورة القديمة قبل الحذف
      final oldImageUrl = state.currentProfile?.profilePictureUrl;
      debugPrint('🖼️ ProfileProvider: Old image URL to remove: $oldImageUrl');

      final response = await LocalProfileService.removeProfilePicture();

      // If we reach here, removal was successful (no exception thrown)
      debugPrint(
          '✅ ProfileProvider: Profile picture removal response received: $response');

      // مسح الـ cache للصورة القديمة فوراً
      try {
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          await ImageCacheService.evictImage(oldImageUrl);
          debugPrint(
              '🗑️ ProfileProvider: Cleared cache for removed image: $oldImageUrl');
        }
      } catch (e) {
        debugPrint('⚠️ ProfileProvider: Error clearing image cache: $e');
      }

      // Update the current profile immediately by removing the image URL
      if (state.currentProfile != null) {
        final updatedProfile = state.currentProfile!.copyWith(
          profilePictureUrl: null,
        );

        _safeUpdateStatePreservingProfile(() => state.copyWith(
              currentProfile: updatedProfile,
              isUploadingProfilePicture: false,
              successMessage: 'تم حذف صورة الملف الشخصي بنجاح',
              error: null, // Clear any previous errors
            ));

        debugPrint(
            '🔄 ProfileProvider: Profile updated immediately with removed image');
      } else {
        // If currentProfile is null, just update the uploading state
        debugPrint(
            '⚠️ ProfileProvider: currentProfile is null, updating state only');
        state = state.copyWith(
          isUploadingProfilePicture: false,
          successMessage: 'تم حذف صورة الملف الشخصي بنجاح',
          error: null, // Clear any previous errors
        );
      }

      // تحديث الملف الشخصي محلياً فقط - لا نحتاج إعادة تحميل من الخادم
      debugPrint(
          '🔄 ProfileProvider: Profile updated locally - no server reload needed');

      debugPrint('✅ ProfileProvider: Profile picture removed successfully');

      NotificationService.showSuccess('تم حذف صورة الملف الشخصي بنجاح');

      return true;
    } catch (e) {
      debugPrint(
          '❌ ProfileProvider: Exception caught during profile picture removal: $e');
      debugPrint('❌ ProfileProvider: Exception type: ${e.runtimeType}');

      String errorMessage = 'فشل في حذف صورة الملف الشخصي';

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

      debugPrint(
          '❌ ProfileProvider: Error removing profile picture: $errorMessage');

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

  /// Upload document for field with retry mechanism and progress tracking
  Future<bool> uploadDocumentForFieldWithRetry({
    required String fieldName,
    required String documentType,
    required File file,
    Uint8List? fileBytes, // إضافة البيانات للويب
    int maxRetries = 1, // محاولة واحدة فقط
    Function(double)? onProgress, // إضافة callback للتقدم
  }) async {
    try {
      state = state.copyWith(
          isUploadingDocument: true, error: null, successMessage: null);

      debugPrint(
          '📄 ProfileProvider: Uploading document for field: $fieldName (single attempt)');

      final response = await LocalProfileService.uploadDocumentFile(
        file: file,
        documentType: documentType,
        fieldName: fieldName,
        fileBytes: fileBytes, // تمرير البيانات للويب
      );

      if (response != null) {
        // Remove the selected file for this field
        final updatedDocuments =
            Map<String, File?>.from(state.selectedDocuments);
        updatedDocuments.remove(fieldName);

        state = state.copyWith(
          selectedDocuments: updatedDocuments,
          isUploadingDocument: false,
          successMessage: 'تم رفع الوثيقة بنجاح',
        );

        debugPrint(
            '✅ ProfileProvider: Document uploaded successfully for field: $fieldName');

        NotificationService.showSuccess('تم رفع الوثيقة بنجاح');

        return true;
      } else {
        debugPrint(
            '❌ ProfileProvider: Upload response is null, returning false');
        // لا نرمي exception، نرجع false فقط لنسمح بمعالجة الأخطاء في الكود الأصلي
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingDocument: false,
        error: 'فشل في رفع الوثيقة: $e',
      );

      debugPrint('❌ ProfileProvider: Document upload error: $e');

      NotificationService.showError('فشل في رفع الوثيقة: $e');

      return false;
    }
  }

  /// Upload document for field
  Future<bool> uploadDocumentForField({
    required String fieldName,
    required String documentType,
    required File file,
    Uint8List? fileBytes, // إضافة البيانات للويب
  }) async {
    try {
      state = state.copyWith(
          isUploadingDocument: true, error: null, successMessage: null);

      debugPrint(
          '📄 ProfileProvider: Uploading document for field: $fieldName');

      final response = await LocalProfileService.uploadDocumentFile(
        file: file,
        documentType: documentType,
        fieldName: fieldName,
        fileBytes: fileBytes, // تمرير البيانات للويب
      );

      if (response != null) {
        // Remove the selected file for this field
        final updatedDocuments =
            Map<String, File?>.from(state.selectedDocuments);
        updatedDocuments.remove(fieldName);

        state = state.copyWith(
          selectedDocuments: updatedDocuments,
          isUploadingDocument: false,
          successMessage: 'تم رفع الوثيقة بنجاح',
        );

        debugPrint(
            '✅ ProfileProvider: Document uploaded successfully for field: $fieldName');

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
  Future<bool> submitVerificationRequest(
      SubmitVerificationRequest request) async {
    try {
      state = state.copyWith(
          isSubmittingVerification: true, error: null, successMessage: null);

      debugPrint('✅ ProfileProvider: Submitting verification request');

      final response =
          await LocalProfileService.submitVerificationRequest(request);

      if (response != null && response.success) {
        // Reload current profile to get updated verification status
        await loadCurrentProfile(forceRefresh: true);

        state = state.copyWith(
          isSubmittingVerification: false,
          successMessage: 'تم إرسال طلب التوثيق بنجاح',
        );

        debugPrint(
            '✅ ProfileProvider: Verification request submitted successfully');

        NotificationService.showSuccess(
            'تم إرسال طلب التوثيق بنجاح وهو قيد المراجعة');

        return true;
      } else {
        throw Exception('فشل في إرسال طلب التوثيق');
      }
    } catch (e) {
      state = state.copyWith(
        isSubmittingVerification: false,
        error: 'فشل في إرسال طلب التوثيق: $e',
      );
      debugPrint(
          '❌ ProfileProvider: Error submitting verification request: $e');

      NotificationService.showError('فشل في إرسال طلب التوثيق');

      return false;
    }
  }

  /// Update profile data
  Future<bool> updateProfileData(ProfileUpdateRequest request) async {
    try {
      state =
          state.copyWith(isUpdating: true, error: null, successMessage: null);

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
      _safeUpdateState(() => state.copyWith(
            isUpdating: false,
            error: 'فشل في تحديث البيانات: $e',
          ));
      debugPrint('❌ ProfileProvider: Error updating profile data: $e');

      NotificationService.showError('فشل في تحديث بيانات الملف الشخصي');

      return false;
    }
  }

  /// Initialize profile page data
  /// This method ensures profile, qualifications, and governorates are all loaded
  /// which is essential for displaying qualification/governorate names correctly
  Future<void> initializeProfilePage({bool forceRefresh = false}) async {
    try {
      debugPrint('🔄 ProfileProvider: Initializing profile page (forceRefresh: $forceRefresh)');
      
      // Clear cache first if forceRefresh is true to ensure fresh data
      if (forceRefresh) {
        try {
          await LocalProfileService.clearCache();
          debugPrint('✅ ProfileProvider: Cache cleared before initialization');
        } catch (e) {
          debugPrint('⚠️ ProfileProvider: Error clearing cache: $e');
        }
      }
      
      // First load profile data
      await loadCurrentProfile(forceRefresh: forceRefresh);

      // Wait a bit to ensure token is properly saved and profile is loaded
      await Future.delayed(const Duration(milliseconds: 200));

      // Then load other data in parallel (qualifications and governorates are critical for display)
      // Use forceRefresh for qualifications and governorates too to ensure fresh data
      await Future.wait([
        loadQualifications(forceRefresh: forceRefresh),
        loadGovernorates(forceRefresh: forceRefresh),
        loadVerificationRules(), // This can be in background
      ]);
      
      debugPrint('✅ ProfileProvider: Profile page initialized successfully');
    } catch (e) {
      debugPrint('❌ ProfileProvider: Error initializing profile page: $e');
      _safeUpdateState(() => state.copyWith(
            error: 'فشل في تحميل بيانات الصفحة: $e',
          ));
    }
  }

  /// Refresh profile data
  /// Uses loadCurrentProfile to ensure fresh data from server
  Future<void> refresh() async {
    if (!mounted) return;

    debugPrint('🔄 ProfileProvider: Refreshing profile data...');

    // Clear cache to ensure fresh data
    await LocalProfileService.clearCache();

    // Force refresh all data using loadCurrentProfile (better error handling)
    await loadCurrentProfile(forceRefresh: true);
    
    // Also reload other data in background
    try {
      await Future.wait([
        loadGovernorates(),
        loadQualifications(),
      ]);
    } catch (e) {
      debugPrint('⚠️ ProfileProvider: Error loading reference data during refresh: $e');
      // Don't fail the refresh if reference data fails
    }
  }

  /// Light refresh - just update state without server call
  void lightRefresh() {
    if (!mounted) return;

    debugPrint('🔄 ProfileProvider: Light refresh - updating state only');
    _safeUpdateState(() => state.copyWith(
          error: null,
          successMessage: null,
        ));
  }

  @override
  void dispose() {
    debugPrint('🗑️ ProfileNotifier: Disposing...');
    super.dispose();
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
    if (errorString.contains('timeout') ||
        errorString.contains('انتهت المهلة')) {
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
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

/// Profile notifier provider (alias for profileProvider)
final profileNotifierProvider = profileProvider;

/// Profile data provider (for easy access to profile data)
final profileDataProvider = Provider<ProfileDataResponse?>((ref) {
  return ref.watch(profileProvider).profileData;
});

/// Profile completion status provider
final profileCompletionStatusProvider =
    Provider<ProfileCompletionStatus?>((ref) {
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
