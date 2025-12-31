import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for web utilities
import '../../../services/web_utils.dart';

import '../../../core/constants/api_constants.dart';
import '../../../models/models.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/enhanced_dio_service_v2.dart';
import '../../../services/platform_storage_service.dart';
import '../../../services/profile_rules_service.dart';

class LocalProfileService {
  static Dio get _dio => EnhancedDioServiceV2.instance.dio;
  static const String _cacheKey = 'cached_profile_data';
  static const String _cacheTimestampKey = 'profile_cache_timestamp';
  static const int _cacheValidityHours = 24; // Cache valid for 24 hours

  /// Check if cached data is still valid (for offline use)
  static Future<bool> _isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime).inHours;

      return difference < _cacheValidityHours;
    } catch (e) {
      debugPrint('Error checking cache validity: $e');
      return false;
    }
  }

  /// Check if cached data is very recent (less than 5 minutes)
  static Future<bool> _isRecentCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime).inMinutes;

      return difference < 5; // Only use cache if less than 5 minutes old
    } catch (e) {
      debugPrint('Error checking recent cache: $e');
      return false;
    }
  }

  /// Get cached profile data
  static Future<ProfileModel?> _getCachedProfile() async {
    try {
      // الحصول على userId الحالي من auth service
      final currentUserId = await _getCurrentUserId();
      
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      const userIdKey = '${_cacheKey}_user_id';
      final cachedUserId = prefs.getString(userIdKey);

      // التحقق من تطابق userId قبل استخدام الكاش
      if (cachedData != null) {
        if (currentUserId != null && cachedUserId != null && currentUserId != cachedUserId) {
          debugPrint('⚠️ Cached profile userId ($cachedUserId) does not match current userId ($currentUserId), clearing cache');
          await clearCache();
          return null;
        }
        
        final profileJson = json.decode(cachedData);
        final profile = ProfileModel.fromJson(profileJson);
        
        // التحقق مرة أخرى من userId في profile نفسه
        if (currentUserId != null && profile.userId != currentUserId) {
          debugPrint('⚠️ Profile userId (${profile.userId}) does not match current userId ($currentUserId), clearing cache');
          await clearCache();
          return null;
        }
        
        return profile;
      }
      
      // على الويب، محاولة قراءة من localStorage
      if (kIsWeb) {
        try {
          final cachedDataWeb = getLocalStorageValue(_cacheKey);
          final cachedUserIdWeb = getLocalStorageValue(userIdKey);
          
          if (cachedDataWeb != null) {
            if (currentUserId != null && cachedUserIdWeb != null && currentUserId != cachedUserIdWeb) {
              debugPrint('⚠️ Web cached profile userId ($cachedUserIdWeb) does not match current userId ($currentUserId), clearing cache');
              await clearCache();
              return null;
            }
            
            final profileJson = json.decode(cachedDataWeb);
            final profile = ProfileModel.fromJson(profileJson);
            
            if (currentUserId != null && profile.userId != currentUserId) {
              debugPrint('⚠️ Web profile userId (${profile.userId}) does not match current userId ($currentUserId), clearing cache');
              await clearCache();
              return null;
            }
            
            return profile;
          }
        } catch (e) {
          debugPrint('⚠️ Error reading cached profile from localStorage: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading cached profile: $e');
    }
    return null;
  }
  
  /// Get current user ID from auth service
  static Future<String?> _getCurrentUserId() async {
    try {
      final authService = CompatibleAuthService.instance;
      final user = authService.user;
      return user?.id;
    } catch (e) {
      debugPrint('⚠️ Error getting current user ID: $e');
      return null;
    }
  }

  /// Cache profile data
  static Future<void> _cacheProfile(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      
      // حفظ userId مع الكاش للتحقق لاحقاً
      const userIdKey = '${_cacheKey}_user_id';
      await prefs.setString(_cacheKey, profileJson);
      await prefs.setString(userIdKey, profile.userId);
      await prefs.setInt(
          _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      
      // على الويب، حفظ في localStorage أيضاً
      if (kIsWeb) {
        try {
          setLocalStorageValue(_cacheKey, profileJson);
          setLocalStorageValue(userIdKey, profile.userId);
          setLocalStorageValue(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch.toString());
        } catch (e) {
          debugPrint('⚠️ Error caching profile to localStorage: $e');
        }
      }
      
      debugPrint('✅ Profile cached successfully (userId: ${profile.userId})');
    } catch (e) {
      debugPrint('❌ Error caching profile: $e');
    }
  }

  /// Check internet connectivity
  static Future<bool> _isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  /// Get profile data (qualifications, universities, etc.)
  static Future<ProfileDataResponse?> getProfileData() async {
    try {
      debugPrint('📋 ProfileService: Fetching profile data');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }
      debugPrint('🔑 ProfileService: Token found, length: ${token.length}');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/profile-data',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint(
          '📋 ProfileService: Profile data response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('📋 ProfileService: Profile data received successfully');

        return ProfileDataResponse.fromJson(data);
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching profile data: $e');
      return null;
    }
  }

  /// Get profile completion status
  static Future<ProfileCompletionStatus?> getProfileCompletionStatus() async {
    try {
      debugPrint('📊 ProfileService: Fetching profile completion status');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/profiles/me/completion-status',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint(
          '📊 ProfileService: Completion status response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint(
            '📊 ProfileService: Completion status received successfully');

        return ProfileCompletionStatus.fromJson(data);
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch completion status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching completion status: $e');
      return null;
    }
  }

  /// Get current user profile with caching and offline support
  /// [forceRefresh] - Force fetch from server even if cache is valid
  /// [useRecentCache] - Use cache if it's very recent (less than 5 minutes)
  static Future<ProfileModel?> getProfile(
      {bool forceRefresh = false, bool useRecentCache = true}) async {
    try {
      debugPrint(
          '👤 ProfileService: Fetching user profile (forceRefresh: $forceRefresh)');

      // Check connectivity
      final isConnected = await _isConnected();

      // If not connected, try to return cached data
      if (!isConnected) {
        debugPrint(
            '📱 ProfileService: No internet connection, trying cached data');
        final cachedProfile = await _getCachedProfile();
        if (cachedProfile != null) {
          debugPrint('✅ ProfileService: Returning cached profile data');
          return cachedProfile;
        } else {
          debugPrint('❌ ProfileService: No cached data available');
          throw Exception('لا يوجد اتصال بالإنترنت ولا توجد بيانات محفوظة');
        }
      }

      // If connected, check cache strategy
      // IMPORTANT: When forceRefresh is true, NEVER use cache (even recent cache)
      if (!forceRefresh) {
        // Use recent cache if available and requested (only if not forceRefresh)
        if (useRecentCache && await _isRecentCache()) {
          final cachedProfile = await _getCachedProfile();
          if (cachedProfile != null) {
            debugPrint(
                '✅ ProfileService: Returning recent cached profile data');
            return cachedProfile;
          }
        }

        // Use regular cache if valid (only if not forceRefresh)
        if (await _isCacheValid()) {
          final cachedProfile = await _getCachedProfile();
          if (cachedProfile != null) {
            debugPrint('✅ ProfileService: Using cached profile data');
            return cachedProfile;
          }
        }
      } else {
        debugPrint('🔄 ProfileService: forceRefresh=true, skipping all cache checks');
        // Clear cache when forceRefresh to ensure fresh data
        try {
          await clearCache();
          debugPrint('✅ ProfileService: Cache cleared due to forceRefresh');
        } catch (e) {
          debugPrint('⚠️ ProfileService: Error clearing cache: $e');
          // Continue anyway
        }
      }

      // Fetch fresh data from server
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        throw Exception('لم يتم العثور على رمز المصادقة');
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/profiles/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint(
          '👤 ProfileService: Profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('👤 ProfileService: Profile received successfully');

        // التحقق من وجود بيانات الملف الشخصي
        // الخادم يرسل البيانات مباشرة وليس داخل كائن profile
        if (data == null || data['profile_id'] == null) {
          debugPrint('❌ ProfileService: No profile data found in response');
          throw Exception('لم يتم العثور على بيانات الملف الشخصي');
        }

        debugPrint('📊 ProfileService: Profile data: $data');

        // Transform the response to match ProfileModel structure
        // الخادم يرجع البيانات مباشرة مع snake_case field names
        final transformedData = {
          'id': data['profile_id']?.toString() ?? '',
          'userId': data['user_id']?.toString() ?? data['id']?.toString() ?? '',
          'full_name_ar': data['full_name_ar']?.toString() ?? '',
          'full_name_en': data['full_name_en']?.toString() ?? '',
          'email': data['email']?.toString() ?? '',
          'birth_date': data['birth_date']?.toString(),
          'governorate_id': data['governorate_id']?.toString(),
          'qualification_id': data['qualification_id']?.toString(),
          'graduation_year': data['graduation_year'] ?? 0,
          'university': data['university']?.toString() ?? '',
          'workplace': data['workplace']?.toString() ?? '',
          'status': data['status']?.toString() ?? 'UNVERIFIED',
          'completion_percentage': 0.0, // Will be calculated
          'profile_picture_url': data['profile_photo_url']?.toString(),
          'documents': [], // Will be loaded separately
          'required_documents': [], // Will be loaded separately
          'created_at': data['profile_created_at']?.toString(),
          'updated_at': data['profile_updated_at']?.toString(),
          'verified_at': null, // Not available from this endpoint
        };

        debugPrint('📊 ProfileService: Transformed data: $transformedData');

        try {
          final profile = ProfileModel.fromJson(transformedData);

          debugPrint('✅ ProfileService: ProfileModel created successfully');
          debugPrint(
              '🖼️ ProfileService: Profile picture URL: ${profile.profilePictureUrl}');

          // Cache the profile data
          await _cacheProfile(profile);

          return profile;
        } catch (jsonError) {
          debugPrint(
              '❌ ProfileService: Error creating ProfileModel from JSON: $jsonError');
          debugPrint('📊 ProfileService: Problematic data: $transformedData');
          throw Exception('خطأ في تحويل بيانات الملف الشخصي: $jsonError');
        }
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch profile: ${response.statusCode}');
        throw Exception('فشل في جلب بيانات الملف الشخصي');
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching profile: $e');

      // طباعة تفاصيل إضافية للخطأ
      if (e is DioException) {
        debugPrint('📊 ProfileService: DioException details:');
        debugPrint('  - Status Code: ${e.response?.statusCode}');
        debugPrint('  - Response Data: ${e.response?.data}');
        debugPrint('  - Request Path: ${e.requestOptions.path}');
        debugPrint('  - Headers: ${e.requestOptions.headers}');

        // معالجة أخطاء محددة
        if (e.response?.statusCode == 404) {
          debugPrint('❌ ProfileService: Profile not found (404)');
          throw Exception('لم يتم العثور على الملف الشخصي');
        } else if (e.response?.statusCode == 401) {
          debugPrint('❌ ProfileService: Unauthorized (401)');
          throw Exception('غير مصرح بالوصول - يرجى تسجيل الدخول مرة أخرى');
        } else if (e.response?.statusCode == 403) {
          debugPrint('❌ ProfileService: Forbidden (403)');
          throw Exception('ممنوع الوصول إلى هذا المورد');
        }
      } else {
        debugPrint(
            '📊 ProfileService: Non-DioException error: ${e.runtimeType}');
        debugPrint('📊 ProfileService: Error message: ${e.toString()}');
      }

      // Try to return cached data as fallback
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        debugPrint('⚠️ ProfileService: Returning cached profile due to error');
        return cachedProfile;
      }

      rethrow;
    }
  }

  /// Update profile
  static Future<ProfileModel?> updateProfile(ProfileModel profile) async {
    try {
      debugPrint('🔄 ProfileService: Updating profile');

      // استخدام DioService للصصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }

      final response = await _dio.put(
        '${ApiConstants.baseUrl}/api/v1/profiles/me',
        data: profile.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
          '💾 ProfileService: Update response status: ${response.statusCode}');
      debugPrint('💾 ProfileService: Update response data: ${response.data}');

      if (response.statusCode == 200) {
        debugPrint('✅ ProfileService: Profile updated successfully');
        final data = response.data;

        // تحويل البيانات لضمان التوافق مع ProfileModel
        final transformedData = Map<String, dynamic>.from(data);

        // التأكد من أن documents هو قائمة وليس string أو رقم
        if (transformedData['documents'] != null &&
            transformedData['documents'] is! List) {
          debugPrint(
              '⚠️ ProfileService: Converting documents from ${transformedData['documents'].runtimeType} to List');
          transformedData['documents'] = [];
        }

        // التأكد من أن required_documents هو قائمة
        if (transformedData['required_documents'] != null &&
            transformedData['required_documents'] is! List) {
          debugPrint(
              '⚠️ ProfileService: Converting required_documents from ${transformedData['required_documents'].runtimeType} to List');
          transformedData['required_documents'] = [];
        }

        return ProfileModel.fromJson(transformedData);
      } else {
        debugPrint(
            '❌ ProfileService: Update failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error updating profile: $e');
      return null;
    }
  }

  /// Upload profile document
  static Future<DocumentUploadModel?> uploadDocument({
    required String documentType,
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      debugPrint('📄 ProfileService: Uploading document');
      debugPrint('📄 Document type: $documentType');
      debugPrint('📄 File URL: $fileUrl');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }

      final response = await _dio.post(
        '/api/v1/files/upload',
        data: {
          'documentType': documentType,
          'fileUrl': fileUrl,
          'fileName': fileName,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
          '📄 ProfileService: Document upload response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        debugPrint('📄 ProfileService: Document uploaded successfully');

        // تحويل البيانات مع معالجة أفضل للأخطاء
        try {
          // التأكد من تحويل جميع الحقول للنوع الصحيح
          final safeData = Map<String, dynamic>.from(data);

          // التأكد من أن userId هو string
          if (safeData['userId'] != null) {
            safeData['userId'] = safeData['userId'].toString();
          }

          // التأكد من أن id هو string
          if (safeData['id'] != null) {
            safeData['id'] = safeData['id'].toString();
          }

          // التأكد من أن documentType هو string
          if (safeData['documentType'] != null) {
            safeData['documentType'] = safeData['documentType'].toString();
          }

          // التأكد من أن fileName هو string
          if (safeData['fileName'] != null) {
            safeData['fileName'] = safeData['fileName'].toString();
          }

          // التأكد من أن fileUrl هو string
          if (safeData['fileUrl'] != null) {
            safeData['fileUrl'] = safeData['fileUrl'].toString();
          }

          // التأكد من أن status هو string
          if (safeData['status'] != null) {
            safeData['status'] = safeData['status'].toString();
          }

          return DocumentUploadModel.fromJson(safeData);
        } catch (conversionError) {
          debugPrint(
              '❌ ProfileService: Error converting document data: $conversionError');
          debugPrint('📊 ProfileService: Original data: $data');
          throw Exception('خطأ في تحويل بيانات الوثيقة: $conversionError');
        }
      } else {
        debugPrint(
            '❌ ProfileService: Failed to upload document: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error uploading document: $e');
      return null;
    }
  }

  /// Get user documents
  static Future<List<DocumentUploadModel>> getUserDocuments({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      debugPrint('📄 ProfileService: Fetching user documents');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return [];
      }

      final allDocuments = <DocumentUploadModel>[];
      int currentPage = page;
      int safetyCounter = 0;

      while (true) {
        final response = await _dio.get(
          '/api/v1/files/documents',
          queryParameters: {
            'page': currentPage,
            'limit': limit,
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        debugPrint(
            '📄 ProfileService: Documents response status (page $currentPage): ${response.statusCode}');

        if (response.statusCode != 200 && response.statusCode != 201) {
          debugPrint(
              '❌ ProfileService: Failed to fetch documents: ${response.statusCode}');
          break;
        }

        final responseData = response.data;
        List<dynamic> filesJson = [];

        if (responseData is Map<String, dynamic>) {
          if (responseData['files'] is List) {
            filesJson = responseData['files'] as List<dynamic>;
          } else if (responseData['documents'] is List) {
            filesJson = responseData['documents'] as List<dynamic>;
          } else {
            debugPrint(
                '⚠️ ProfileService: No files/documents array in response: keys=${responseData.keys}');
          }
        } else if (responseData is List) {
          filesJson = responseData;
        } else {
          debugPrint(
              '⚠️ ProfileService: Unexpected documents response type: ${responseData.runtimeType}');
        }

        final pageDocuments = filesJson
            .map((json) {
              try {
                final fileData =
                    Map<String, dynamic>.from(json as Map<String, dynamic>);
                return _convertFileResponseToDocumentModel(fileData);
              } catch (e) {
                debugPrint(
                    '❌ ProfileService: Error converting file to document: $e');
                debugPrint('📊 ProfileService: Original file data: $json');
                return null;
              }
            })
            .whereType<DocumentUploadModel>()
            .toList();

        if (pageDocuments.isEmpty) {
          break;
        }

        // Avoid duplicates by ID
        final existingIds = allDocuments.map((doc) => doc.id).toSet();
        for (final doc in pageDocuments) {
          if (existingIds.add(doc.id)) {
            allDocuments.add(doc);
          }
        }

        bool hasMore = false;
        if (responseData is Map<String, dynamic>) {
          final totalPages = responseData['totalPages'];
          if (totalPages is num && currentPage < totalPages) {
            hasMore = true;
          } else if (totalPages == null && filesJson.length == limit) {
            hasMore = true;
          }
        } else if (filesJson.length == limit) {
          hasMore = true;
        }

        currentPage += 1;
        safetyCounter += 1;

        if (!hasMore || safetyCounter >= 10) {
          break;
        }
      }

      return allDocuments;
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching documents: $e');

      // إذا كان الخطأ 401 (Unauthorized) أو 404 (Not Found)، فهذا يعني أن المستخدم ليس لديه ملف شخصي كامل
      // في هذه الحالة، نعيد قائمة فارغة بدلاً من إيقاف تحميل الصفحة
      if (e.toString().contains('401') || e.toString().contains('404')) {
        debugPrint(
            '📄 ProfileService: User has no complete profile yet, returning empty documents list');
        return [];
      }

      return [];
    }
  }

  static DocumentUploadModel? _convertFileResponseToDocumentModel(
      Map<String, dynamic> fileData) {
    try {
      final metadata = fileData['metadata'] is Map
          ? Map<String, dynamic>.from(fileData['metadata'] as Map)
          : null;

      DateTime? uploadedAt;
      if (fileData['createdAt'] != null) {
        uploadedAt = DateTime.tryParse(fileData['createdAt'].toString());
      }
      uploadedAt ??= DateTime.now();

      DateTime? reviewedAt;
      if (metadata != null && metadata['reviewedAt'] != null) {
        reviewedAt = DateTime.tryParse(metadata['reviewedAt'].toString());
      }

      final convertedData = <String, dynamic>{
        'id': fileData['id']?.toString() ?? '',
        'userId': fileData['entityId']?.toString() ??
            fileData['uploadedBy']?.toString() ??
            '',
        'documentType': fileData['fileCategory']?.toString() ??
            metadata?['documentType']?.toString() ??
            'OTHER_DOCUMENT',
        'fileName': fileData['originalName']?.toString() ??
            fileData['fileName']?.toString() ??
            '',
        'fileUrl': fileData['url']?.toString() ?? '',
        'status': metadata?['status']?.toString() ?? 'uploaded',
        'uploadedAt': uploadedAt.toIso8601String(),
        'rejectionReason': metadata?['rejectionReason']?.toString(),
        'reviewedAt': reviewedAt?.toIso8601String(),
        'reviewedBy': metadata?['reviewedBy']?.toString(),
        'metadata': metadata,
      };

      return DocumentUploadModel.fromJson(convertedData);
    } catch (e) {
      debugPrint('❌ ProfileService: Failed to convert file data: $e');
      debugPrint('📊 ProfileService: File data: $fileData');
      return null;
    }
  }

  /// Delete document
  static Future<bool> deleteDocument(String documentId) async {
    try {
      debugPrint('🗑️ ProfileService: Deleting document: $documentId');

      final token = await PlatformStorageService.instance.getAccessToken();
      if (token == null) {
        debugPrint('❌ ProfileService: No authentication token found');
        return false;
      }

      final response = await _dio.delete(
        '${ApiConstants.baseUrl}/api/v1/files/$documentId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint('🗑️ ProfileService: Delete response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ ProfileService: Error deleting document: $e');
      return false;
    }
  }

  /// Submit profile for verification
  static Future<bool> submitForVerification() async {
    try {
      debugPrint('✅ ProfileService: Submitting profile for verification');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return false;
      }

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/v1/profiles/me/submit-verification',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint(
          '✅ ProfileService: Submit verification response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ ProfileService: Error submitting for verification: $e');
      return false;
    }
  }

  /// Get verification history
  static Future<List<Map<String, dynamic>>> getVerificationHistory() async {
    try {
      debugPrint('📜 ProfileService: Fetching verification history');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return [];
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/profiles/me/verification-history',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint(
          '📜 ProfileService: Verification history response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint(
            '📜 ProfileService: Verification history received successfully');

        return List<Map<String, dynamic>>.from(data['history'] ?? []);
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch verification history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching verification history: $e');
      return [];
    }
  }

  /// Get profile rules using ProfileRulesService (updated to use new system)
  @Deprecated('Use ProfileRulesService.getActiveRules() instead')
  static Future<VerificationRulesResponse?> getVerificationRules() async {
    try {
      debugPrint('📋 ProfileService: Fetching profile rules using new system');

      // استخدام ProfileRulesService الجديد
      final profileRulesService = ProfileRulesService();
      final rules = await profileRulesService.getActiveRules();

      if (rules.isNotEmpty) {
        debugPrint(
            '📋 ProfileService: Profile rules received successfully (${rules.length} rules)');

        // إنشاء VerificationRulesResponse للتوافق مع النظام القديم
        // هذا مؤقت حتى يتم تحديث جميع الملفات
        return VerificationRulesResponse(
          requiredDocuments: _extractRequiredDocuments(rules),
          requiredFields: _extractRequiredFields(rules),
          rules: _extractRulesText(rules),
        );
      } else {
        debugPrint('❌ ProfileService: No profile rules found');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching profile rules: $e');
      return null;
    }
  }

  /// Extract required documents from profile rules
  static List<RequiredDocumentModel> _extractRequiredDocuments(
      List<ProfileRuleModel> rules) {
    final requiredDocs = <RequiredDocumentModel>[];

    for (final rule in rules) {
      if (rule.requiresDocument && rule.isActive) {
        requiredDocs.add(RequiredDocumentModel(
          id: rule.id,
          documentType: DocumentType.other, // Default type
          title: (rule.fieldDisplayName?.isNotEmpty == true)
              ? rule.fieldDisplayName!
              : rule.fieldName,
          description: rule.fieldDescription ?? '',
          isRequired: rule.requiresDocument,
        ));
      }
    }

    return requiredDocs;
  }

  /// Extract allowed fields from profile rules
  static List<String> _extractAllowedFields(List<ProfileRuleModel> rules) {
    return rules
        .where((rule) => rule.allowEdit && rule.isActive)
        .map((rule) => rule.fieldName)
        .toList();
  }

  /// Get profile rules using new ProfileRulesService (recommended)
  static Future<List<ProfileRuleModel>> getProfileRules(
      {bool forceRefresh = false}) async {
    try {
      debugPrint(
          '📋 ProfileService: Fetching profile rules using ProfileRulesService');

      final profileRulesService = ProfileRulesService();
      final rules =
          await profileRulesService.getActiveRules(forceRefresh: forceRefresh);

      debugPrint(
          '✅ ProfileService: Profile rules fetched successfully (${rules.length} rules)');
      return rules;
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching profile rules: $e');
      return [];
    }
  }

  /// Upload profile picture (for mobile platforms)
  static Future<Map<String, dynamic>?> uploadProfilePicture(
      File imageFile) async {
    try {
      debugPrint('📸 ProfileService: Uploading profile picture');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      debugPrint(
          '🔑 ProfileService: Token check - ${token != null ? "Token exists (length: ${token.length})" : "No token found"}');

      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
      }

      // Get current user ID from CompatibleAuthService
      final compatibleAuthService = CompatibleAuthService.instance;
      final currentUser = compatibleAuthService.user;
      String userId;
      if (currentUser == null || currentUser.id.isEmpty) {
        debugPrint('⚠️ ProfileService: Current user is null, trying fallback...');
        try {
          final profile = await getProfile(useRecentCache: true);
          if (profile != null && profile.userId.isNotEmpty) {
            userId = profile.userId;
            debugPrint('✅ ProfileService: Retrieved userId from profile: $userId');
          } else {
             throw Exception('User data not found');
          }
        } catch (e) {
          debugPrint('❌ ProfileService: Failed to retrieve user info: $e');
          throw Exception('لم يتم العثور على بيانات المستخدم الحالي');
        }
      } else {
        userId = currentUser.id;
      }
      debugPrint('👤 ProfileService: Current user ID: $userId');

      // Determine the correct content type based on file extension
      String contentType = 'image/jpeg';
      final fileName = imageFile.path.toLowerCase();
      if (fileName.endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (fileName.endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        contentType = 'image/webp';
      }

      debugPrint('📸 ProfileService: Detected content type: $contentType');

      // User ID is already available from authService.getCurrentUser() above

      // Create form data with correct content type and user ID
      MultipartFile multipartFile;
      if (kIsWeb) {
        // في بيئة الويب، نحتاج لقراءة البيانات من XFile
        // هذا يتطلب تمرير XFile بدلاً من File
        debugPrint(
            '🌐 Web: Profile picture upload - need XFile for web platform');
        throw Exception('رفع صورة الملف الشخصي في الويب يتطلب استخدام XFile');
      } else {
        // في بيئة الموبايل، استخدم File
        multipartFile = await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_picture.jpg',
          contentType: MediaType.parse(contentType),
        );
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
        'entityType': 'USER_PROFILE', // enum value
        'entityId': userId,
        'fileCategory': 'PROFILE_PICTURE', // enum value
        'description': 'صورة الملف الشخصي',
      });
      
      debugPrint('📤 [UPLOAD_PROFILE_PICTURE] Uploading profile picture with:');
      debugPrint('   - entityType: USER_PROFILE');
      debugPrint('   - entityId: $userId');
      debugPrint('   - fileCategory: PROFILE_PICTURE');

      // Use the correct endpoint that matches the backend
      debugPrint('🚀 === MOBILE FILE UPLOAD REQUEST STARTED ===');
      debugPrint('📅 Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('🔗 Upload URL: ${ApiConstants.baseUrl}/api/v1/files/upload');
      debugPrint('📁 File info: ${imageFile.path}');
      debugPrint('👤 User ID: $userId');
      debugPrint('📦 Form data fields count: ${formData.fields.length}');
      debugPrint('📦 Form data files count: ${formData.files.length}');
      debugPrint(
          '📦 Form data keys: ${formData.fields.map((e) => e.key).toList()}');
      debugPrint(
          '📦 Form data files: ${formData.files.map((e) => e.key).toList()}');
      debugPrint(
          '📦 Form data values: ${formData.fields.map((e) => '${e.key}: ${e.value}').toList()}');
      debugPrint('🔑 Token length: ${token.length}');
      debugPrint('🔑 Token prefix: ${token.substring(0, 20)}...');

      final response = await _dio.post(
        '/api/v1/files/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // لا نضع Content-Type هنا، دع Dio يتعامل معه تلقائياً
          },
          sendTimeout:
              const Duration(seconds: 300), // timeout للإرسال لملفات كبيرة
          receiveTimeout: const Duration(seconds: 300), // timeout للاستقبال
        ),
      );

      debugPrint(
          '📸 ProfileService: Profile picture upload response: ${response.statusCode}');
      debugPrint('📸 ProfileService: Response data: ${response.data}');
      debugPrint('🎉 === MOBILE FILE UPLOAD RESPONSE RECEIVED ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        debugPrint('📸 ProfileService: Profile picture uploaded successfully');
        
        // 🔍 DEBUG: طباعة تفاصيل الاستجابة من الخادم
        debugPrint('📥 [UPLOAD_PROFILE_PICTURE] Server response:');
        final fileData = data['file'] ?? data;
        if (fileData is Map<String, dynamic>) {
          debugPrint('   - id: ${fileData['id']}');
          debugPrint('   - entityType: ${fileData['entityType']}');
          debugPrint('   - entityId: ${fileData['entityId']}');
          debugPrint('   - fileCategory: ${fileData['fileCategory']}');
          debugPrint('   - url: ${fileData['url']}');
          debugPrint('   - originalName: ${fileData['originalName']}');
        }

        // Extract file data from the response
        if (fileData != null) {
          return fileData is Map<String, dynamic> ? fileData : data;
        } else {
          // Fallback if file data is not in expected format
          return data;
        }
      } else {
        debugPrint(
            '❌ ProfileService: Failed to upload profile picture: ${response.statusCode}');
        debugPrint('❌ ProfileService: Error response: ${response.data}');

        // Extract error message from response if available
        String errorMessage = 'فشل في رفع الصورة';
        final errorData = response.data;
        if (errorData != null && errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error uploading profile picture: $e');

      // Re-throw DioException with more specific error handling
      if (e is DioException) {
        debugPrint(
            '❌ ProfileService: DioException details - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');

        if (e.response?.statusCode == 400) {
          final errorData = e.response?.data;
          String errorMessage = 'نوع الملف غير مدعوم أو البيانات غير صحيحة';

          // Try to extract error message from different response formats
          if (errorData != null) {
            if (errorData is Map<String, dynamic>) {
              if (errorData['message'] != null) {
                errorMessage = errorData['message'].toString();
              } else if (errorData['error'] != null) {
                errorMessage = errorData['error'].toString();
              }
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          debugPrint(
              '❌ ProfileService: Extracted error message: $errorMessage');
          throw Exception(errorMessage);
        } else if (e.response?.statusCode == 401) {
          throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
        } else if (e.response?.statusCode == 413) {
          throw Exception('حجم الملف كبير جداً');
        } else if (e.response?.statusCode == 500) {
          throw Exception('خطأ في الخادم - يرجى المحاولة لاحقاً');
        } else {
          // For any other HTTP error codes
          final errorData = e.response?.data;
          String errorMessage = 'فشل في رفع الصورة';

          if (errorData != null) {
            if (errorData is Map<String, dynamic> &&
                errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          throw Exception(
              '$errorMessage (كود الخطأ: ${e.response?.statusCode})');
        }
      }

      if (e.toString().contains('خطأ في المصادقة')) {
        rethrow;
      }

      // For any other type of exception
      debugPrint('❌ ProfileService: Non-DioException error: $e');
      throw Exception('فشل في رفع صورة الملف الشخصي: $e');
    }
  }

  /// Upload profile picture (for web platforms using XFile)
  static Future<Map<String, dynamic>?> uploadProfilePictureWeb(
      XFile imageFile) async {
    try {
      debugPrint('📸 ProfileService: Uploading profile picture (Web)');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      debugPrint(
          '🔑 ProfileService: Token check - ${token != null ? "Token exists (length: ${token.length})" : "No token found"}');

      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
      }

      // Get current user ID from CompatibleAuthService
      final compatibleAuthService = CompatibleAuthService.instance;
      final currentUser = compatibleAuthService.user;
      String userId;
      if (currentUser == null || currentUser.id.isEmpty) {
        debugPrint('⚠️ ProfileService: Current user is null, trying fallback...');
        try {
          final profile = await getProfile(useRecentCache: true);
          if (profile != null && profile.userId.isNotEmpty) {
            userId = profile.userId;
            debugPrint('✅ ProfileService: Retrieved userId from profile: $userId');
          } else {
             throw Exception('User data not found');
          }
        } catch (e) {
          debugPrint('❌ ProfileService: Failed to retrieve user info: $e');
          throw Exception('لم يتم العثور على بيانات المستخدم الحالي');
        }
      } else {
        userId = currentUser.id;
      }
      debugPrint('👤 ProfileService: Current user ID: $userId');

      // Determine the correct content type based on file extension
      String contentType = 'image/jpeg';
      final fileName = imageFile.name.toLowerCase();
      if (fileName.endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (fileName.endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        contentType = 'image/webp';
      }

      debugPrint('📸 ProfileService: Detected content type: $contentType');

      // Create form data for web platform
      final bytes = await imageFile.readAsBytes();
      final multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: 'profile_picture.jpg', // Use a fixed filename for web
        contentType: MediaType.parse(contentType),
      );

      debugPrint('📸 ProfileService: File bytes length: ${bytes.length}');
      debugPrint('📸 ProfileService: MultipartFile created successfully');

      final formData = FormData.fromMap({
        'file': multipartFile,
        'entityType': 'USER_PROFILE', // enum value
        'entityId': userId,
        'fileCategory': 'PROFILE_PICTURE', // enum value
        'description': 'صورة الملف الشخصي',
      });
      
      debugPrint('📤 [UPLOAD_PROFILE_PICTURE] Uploading profile picture with:');
      debugPrint('   - entityType: USER_PROFILE');
      debugPrint('   - entityId: $userId');
      debugPrint('   - fileCategory: PROFILE_PICTURE');

      // Use the correct endpoint that matches the backend
      debugPrint('🚀 === MOBILE FILE UPLOAD REQUEST STARTED ===');
      debugPrint('📅 Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('🔗 Upload URL: ${ApiConstants.baseUrl}/api/v1/files/upload');
      debugPrint('📁 File info: ${imageFile.path}');
      debugPrint('👤 User ID: $userId');
      debugPrint('📦 Form data fields count: ${formData.fields.length}');
      debugPrint('📦 Form data files count: ${formData.files.length}');
      debugPrint(
          '📦 Form data keys: ${formData.fields.map((e) => e.key).toList()}');
      debugPrint(
          '📦 Form data files: ${formData.files.map((e) => e.key).toList()}');
      debugPrint(
          '📦 Form data values: ${formData.fields.map((e) => '${e.key}: ${e.value}').toList()}');
      debugPrint('🔑 Token length: ${token.length}');
      debugPrint('🔑 Token prefix: ${token.substring(0, 20)}...');

      final response = await _dio.post(
        '/api/v1/files/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // لا نضع Content-Type هنا، دع Dio يتعامل معه تلقائياً
          },
          sendTimeout:
              const Duration(seconds: 300), // timeout للإرسال لملفات كبيرة
          receiveTimeout: const Duration(seconds: 300), // timeout للاستقبال
        ),
      );

      debugPrint(
          '📸 ProfileService: Profile picture upload response: ${response.statusCode}');
      debugPrint('📸 ProfileService: Response data: ${response.data}');
      debugPrint('🎉 === MOBILE FILE UPLOAD RESPONSE RECEIVED ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        debugPrint('📸 ProfileService: Profile picture uploaded successfully (Web)');
        
        // 🔍 DEBUG: طباعة تفاصيل الاستجابة من الخادم
        debugPrint('📥 [UPLOAD_PROFILE_PICTURE_WEB] Server response:');
        final fileData = data['file'] ?? data;
        if (fileData is Map<String, dynamic>) {
          debugPrint('   - id: ${fileData['id']}');
          debugPrint('   - entityType: ${fileData['entityType']}');
          debugPrint('   - entityId: ${fileData['entityId']}');
          debugPrint('   - fileCategory: ${fileData['fileCategory']}');
          debugPrint('   - url: ${fileData['url']}');
          debugPrint('   - originalName: ${fileData['originalName']}');
        }

        // Extract file data from the response
        if (fileData != null) {
          return fileData is Map<String, dynamic> ? fileData : data;
        } else {
          // Fallback if file data is not in expected format
          return data;
        }
      } else {
        debugPrint(
            '❌ ProfileService: Failed to upload profile picture: ${response.statusCode}');
        debugPrint('❌ ProfileService: Error response: ${response.data}');

        // Extract error message from response if available
        String errorMessage = 'فشل في رفع الصورة';
        if (response.data != null && response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData['message'] != null) {
            errorMessage = errorData['message'].toString();
          }
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error uploading profile picture (Web): $e');

      // Re-throw DioException with more specific error handling
      if (e is DioException) {
        debugPrint(
            '❌ ProfileService: DioException details - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');

        if (e.response?.statusCode == 400) {
          final errorData = e.response?.data;
          String errorMessage = 'نوع الملف غير مدعوم أو البيانات غير صحيحة';

          // Try to extract error message from different response formats
          if (errorData != null) {
            if (errorData is Map<String, dynamic> &&
                errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          debugPrint(
              '❌ ProfileService: Extracted error message: $errorMessage');
          throw Exception(errorMessage);
        } else if (e.response?.statusCode == 401) {
          throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
        } else {
          final errorData = e.response?.data;
          String errorMessage = 'فشل في رفع الصورة';

          if (errorData != null) {
            if (errorData is Map<String, dynamic> &&
                errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          throw Exception(
              '$errorMessage (كود الخطأ: ${e.response?.statusCode})');
        }
      }

      if (e.toString().contains('خطأ في المصادقة')) {
        rethrow;
      }

      // For any other type of exception
      debugPrint('❌ ProfileService: Non-DioException error: $e');
      throw Exception('فشل في رفع صورة الملف الشخصي: $e');
    }
  }

  /// Remove profile picture
  static Future<bool> removeProfilePicture() async {
    try {
      debugPrint('🗑️ ProfileService: Removing profile picture');

      // استخدام DioService للحصول على الرمز المميز
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      debugPrint(
          '🔑 ProfileService: Token check - ${token != null ? "Token exists (length: ${token.length})" : "No token found"}');

      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
      }

      // Get current user ID from CompatibleAuthService
      final compatibleAuthService = CompatibleAuthService.instance;
      final currentUser = compatibleAuthService.user;
      if (currentUser == null || currentUser.id.isEmpty) {
        debugPrint('❌ ProfileService: No current user found');
        throw Exception('لم يتم العثور على بيانات المستخدم الحالي');
      }
      final userId = currentUser.id;
      debugPrint('👤 ProfileService: Current user ID: $userId');

      // Use the correct endpoint to remove profile picture
      final response = await _dio.delete(
        '${ApiConstants.baseUrl}/api/v1/users/$userId/profile-picture',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
          '🗑️ ProfileService: Profile picture removal response: ${response.statusCode}');
      debugPrint('🗑️ ProfileService: Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ ProfileService: Profile picture removed successfully');
        return true;
      } else {
        debugPrint(
            '❌ ProfileService: Failed to remove profile picture: ${response.statusCode}');
        debugPrint('❌ ProfileService: Error response: ${response.data}');

        // Extract error message from response if available
        String errorMessage = 'فشل في حذف الصورة';
        final errorData = response.data;
        if (errorData != null && errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error removing profile picture: $e');

      // Re-throw DioException with more specific error handling
      if (e is DioException) {
        debugPrint(
            '❌ ProfileService: DioException details - Status: ${e.response?.statusCode}, Data: ${e.response?.data}');

        if (e.response?.statusCode == 401) {
          throw Exception('خطأ في المصادقة - يرجى تسجيل الدخول أولاً');
        } else if (e.response?.statusCode == 404) {
          throw Exception('لا توجد صورة للحذف');
        } else if (e.response?.statusCode == 500) {
          throw Exception('خطأ في الخادم - يرجى المحاولة لاحقاً');
        } else {
          // For any other HTTP error codes
          final errorData = e.response?.data;
          String errorMessage = 'فشل في حذف الصورة';

          if (errorData != null) {
            if (errorData is Map<String, dynamic> &&
                errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          throw Exception(
              '$errorMessage (كود الخطأ: ${e.response?.statusCode})');
        }
      }

      if (e.toString().contains('خطأ في المصادقة')) {
        rethrow;
      }

      // For any other type of exception
      debugPrint('❌ ProfileService: Non-DioException error: $e');
      throw Exception('فشل في حذف صورة الملف الشخصي: $e');
    }
  }

  /// Submit verification request
  static Future<VerificationRequestResponse?> submitVerificationRequest(
    SubmitVerificationRequest request,
  ) async {
    try {
      debugPrint('✅ ProfileService: Submitting verification request');
      debugPrint('✅ Request data: ${request.toJson()}');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/api/v1/verification/submit',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
          '✅ ProfileService: Verification request response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        debugPrint(
            '✅ ProfileService: Verification request submitted successfully');

        return VerificationRequestResponse.fromJson(data);
      } else {
        debugPrint(
            '❌ ProfileService: Failed to submit verification request: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error submitting verification request: $e');
      return null;
    }
  }

  /// Alias for getProfile() for backward compatibility
  /// Use getProfile() instead - this method will be deprecated
  /// When forceRefresh is true, NEVER use cache (not even recent cache)
  static Future<ProfileModel?> getCurrentProfile(
      {bool forceRefresh = false}) async {
    // If forceRefresh is true, disable both regular cache and recent cache
    return getProfile(
      forceRefresh: forceRefresh, 
      useRecentCache: !forceRefresh // Disable recent cache if forceRefresh
    );
  }

  /// Update profile picture URL locally without server call
  static Future<void> updateProfilePictureUrlLocally(String imageUrl) async {
    try {
      debugPrint(
          '🔄 ProfileService: Updating profile picture URL locally: $imageUrl');

      // تحديث URL الصورة في التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_picture_url', imageUrl);

      // تحديث الملف الشخصي المحفوظ محلياً
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        try {
          final profileJson = json.decode(cachedData);
          profileJson['profilePictureUrl'] = imageUrl;
          profileJson['profilePhotoUrl'] = imageUrl; // للتوافق مع الباك إند

          // حفظ الملف الشخصي المحدث
          await prefs.setString(_cacheKey, json.encode(profileJson));
          debugPrint(
              '✅ ProfileService: Cached profile updated with new image URL');
        } catch (e) {
          debugPrint('⚠️ ProfileService: Error updating cached profile: $e');
        }
      }

      debugPrint('✅ ProfileService: Profile picture URL updated locally');
    } catch (e) {
      debugPrint(
          '❌ ProfileService: Error updating profile picture URL locally: $e');
      // لا نريد أن يفشل العملية بسبب فشل التحديث المحلي
    }
  }

  /// Update profile picture URL in user profile
  static Future<void> _updateProfilePictureUrl(String imageUrl) async {
    try {
      debugPrint('🔄 ProfileService: Updating profile picture URL');

      // Note: Profile picture URL update needs to be implemented
      // This would require a separate API endpoint for profile picture updates
      debugPrint('✅ ProfileService: Profile picture URL updated successfully');
    } catch (e) {
      debugPrint('❌ ProfileService: Error updating profile picture URL: $e');
      rethrow;
    }
  }

  /// Get qualifications list
  static Future<List<dynamic>> getQualifications() async {
    try {
      debugPrint('🎓 ProfileService: Fetching qualifications');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/rule-data/qualifications',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      debugPrint(
          '🎓 ProfileService: Qualifications response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        debugPrint('🎓 ProfileService: Qualifications received successfully');
        debugPrint('🎓 ProfileService: Qualifications response: $responseData');

        // Handle the API response format {success: true, data: [...]}
        if (responseData is Map<String, dynamic> &&
            responseData['data'] != null) {
          final data = responseData['data'];
          if (data is List) {
            debugPrint(
                '🎓 ProfileService: Returning ${data.length} qualifications');
            return List<dynamic>.from(data);
          }
        }

        // Fallback for direct array response
        if (responseData is List) {
          return List<dynamic>.from(responseData);
        }

        debugPrint('❌ ProfileService: Unexpected qualifications data format');
        return [];
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch qualifications: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching qualifications: $e');
      return [];
    }
  }

  /// Get governorates list
  static Future<List<dynamic>> getGovernorates() async {
    try {
      debugPrint('🏛️ ProfileService: Fetching governorates');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/rule-data/governorates',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      debugPrint(
          '🏛️ ProfileService: Governorates response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        debugPrint('🏛️ ProfileService: Governorates received successfully');
        debugPrint('🏛️ ProfileService: Governorates response: $responseData');

        // Handle the API response format {success: true, data: [...]}
        if (responseData is Map<String, dynamic> &&
            responseData['data'] != null) {
          final data = responseData['data'];
          if (data is List) {
            debugPrint(
                '🏛️ ProfileService: Returning ${data.length} governorates');
            return List<dynamic>.from(data);
          }
        }

        // Fallback for direct array response
        if (responseData is List) {
          return List<dynamic>.from(responseData);
        }

        debugPrint('❌ ProfileService: Unexpected governorates data format');
        return [];
      } else {
        debugPrint(
            '❌ ProfileService: Failed to fetch governorates: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error fetching governorates: $e');
      return [];
    }
  }

  /// Upload document file for specific field with retry mechanism and progress tracking
  static Future<DocumentUploadModel?> uploadDocumentFileWithRetry({
    required File file,
    required String documentType,
    required String fieldName,
    Uint8List? fileBytes, // إضافة البيانات للويب
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    Function(double)? onProgress, // إضافة callback للتقدم
  }) async {
    int retryCount = 0;
    Exception? lastException;

    while (retryCount < maxRetries) {
      try {
        debugPrint(
            '📄 ProfileService: Uploading document file for field: $fieldName (attempt ${retryCount + 1}/$maxRetries)');

        // فحص الاتصال قبل المحاولة
        if (retryCount > 0) {
          debugPrint(
              '📄 ProfileService: Waiting ${retryDelay.inSeconds} seconds before retry...');
          await Future.delayed(retryDelay);
        }

        // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
        final token = await EnhancedDioServiceV2.instance.getAccessToken();
        if (token == null || token.isEmpty) {
          debugPrint('❌ ProfileService: No authentication token found');
          throw Exception('لا يوجد رمز مصادقة صالح');
        }

        // Create form data
        MultipartFile multipartFile;
        String fileName;

        if (kIsWeb) {
          // في بيئة الويب، استخدم اسم ملف مع الحفاظ على الامتداد الأصلي
          final originalFileName = file.path.split('/').last;

          // الحفاظ على الامتداد الأصلي من اسم الملف
          String fileExtension = 'bin'; // امتداد افتراضي للأغراض العامة
          if (originalFileName.contains('.')) {
            fileExtension = originalFileName.split('.').last.toLowerCase();
          }

          fileName =
              'document_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

          if (fileBytes != null) {
            // استخدام البيانات المرسلة مباشرة مع الحفاظ على نوع الملف الأصلي
            multipartFile = MultipartFile.fromBytes(
              fileBytes,
              filename: fileName,
            );
            debugPrint(
                '✅ ProfileService: Retry - Web upload preserving original file type: .$fileExtension');
            debugPrint(
                '📄 ProfileService: Document bytes length: ${fileBytes.length}');
          } else {
            debugPrint(
                '❌ ProfileService: No file bytes provided for web upload');
            throw Exception('لم يتم توفير بيانات الملف لرفعه في بيئة الويب');
          }
        } else {
          // في بيئة الموبايل، استخدم path مع الحفاظ على الامتداد الأصلي
          fileName = file.path.split('/').last;
          multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          );
          debugPrint(
              '✅ ProfileService: Retry - Mobile upload preserving original file name: $fileName');
        }

        // الحصول على معرف المستخدم من CompatibleAuthService
        // الحصول على معرف المستخدم
        final compatibleAuthService = CompatibleAuthService.instance;
        var currentUser = compatibleAuthService.user;
        String userId;

        if (currentUser == null || currentUser.id.isEmpty) {
          debugPrint('⚠️ ProfileService: Current user is null in auth service, trying to fetch profile...');
          try {
            // محاولة جلب البروفايل للحصول على المعرف
            final profile = await getProfile(useRecentCache: true);
            if (profile != null && profile.userId.isNotEmpty) {
              userId = profile.userId;
              debugPrint('✅ ProfileService: Retrieved userId from profile: $userId');
            } else {
              throw Exception('لم يتم العثور على بيانات المستخدم');
            }
          } catch (e) {
            debugPrint('❌ ProfileService: Failed to retrieve user info: $e');
            throw Exception('لم يتم العثور على بيانات المستخدم الحالي');
          }
        } else {
          userId = currentUser.id;
        }

        debugPrint('👤 ProfileService: Current user ID: $userId');

        final formData = FormData.fromMap({
          'file': multipartFile,
          'entityType': 'USER_DOCUMENT', // نوع الكيان - enum value
          'entityId': userId, // معرف المستخدم الحقيقي
          'fileCategory': fieldName, // فئة الملف (يجب أن تكون OTHER_DOCUMENT)
          'description':
              'Document uploaded from mobile app for profile review', // وصف الملف
        });
        
        // 🔍 DEBUG: طباعة تفاصيل الرفع
        debugPrint('📤 [UPLOAD_DOCUMENT] Uploading document with:');
        debugPrint('   - entityType: USER_DOCUMENT');
        debugPrint('   - entityId: $userId');
        debugPrint('   - fileCategory: $fieldName');
        debugPrint('   - fileName: $fileName');

        final response = await _dio.post(
          '/api/v1/files/upload',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              // لا نضع Content-Type هنا، دع Dio يتعامل معه تلقائياً
            },
            sendTimeout:
                const Duration(seconds: 300), // 5 دقائق للملفات الكبيرة
            receiveTimeout: const Duration(
                seconds: 300), // 5 دقائق لاستقبال الملفات الكبيرة
          ),
          onSendProgress: (sent, total) {
            // حساب نسبة التقدم
            if (total > 0) {
              final progress = sent / total;
              debugPrint(
                  '📄 ProfileService: Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
              onProgress?.call(progress);
            }
          },
        );

        debugPrint(
            '📄 ProfileService: Upload response status: ${response.statusCode}');

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          final data = response.data;
          debugPrint('📄 ProfileService: Document uploaded successfully');
          debugPrint('📄 ProfileService: Response data: $data');

          // فحص البيانات قبل المعالجة
          if (data != null && data is Map<String, dynamic>) {
            try {
              // الخادم يرجع البيانات مباشرة (object)
              Map<String, dynamic> documentData =
                  Map<String, dynamic>.from(data);
              debugPrint(
                  '✅ ProfileService: Using direct response data: ${documentData.keys}');

              // تحويل البيانات من FileResponseDto إلى DocumentUploadModel
              final convertedData = <String, dynamic>{
                'id': documentData['id']?.toString() ?? '',
                'userId': documentData['entityId']?.toString() ??
                    documentData['uploadedBy']?.toString() ??
                    '',
                'documentType': documentData['fileCategory']?.toString() ??
                    documentData['documentType']?.toString() ??
                    'general',
                'fileName': documentData['originalName']?.toString() ??
                    documentData['fileName']?.toString() ??
                    '',
                'fileUrl': documentData['url']?.toString() ??
                    documentData['fileUrl']?.toString() ??
                    '',
                'status': 'uploaded', // افتراضي لأن الرفع نجح
                'uploadedAt': DateTime.now().toIso8601String(),
              };

              final document = DocumentUploadModel.fromJson(convertedData);
              debugPrint(
                  '✅ ProfileService: Document model created successfully');
              return document;
            } catch (e) {
              debugPrint('❌ ProfileService: Error parsing document data: $e');
              throw Exception('خطأ في معالجة بيانات الوثيقة: $e');
            }
          } else {
            debugPrint('❌ ProfileService: Invalid response data format');
            throw Exception('تنسيق بيانات الاستجابة غير صحيح');
          }
        } else {
          debugPrint(
              '❌ ProfileService: Upload failed with status: ${response.statusCode}');
          throw Exception(
              'فشل في رفع الوثيقة. رمز الخطأ: ${response.statusCode}');
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        retryCount++;

        debugPrint('❌ ProfileService: Upload attempt $retryCount failed: $e');

        // إذا كان الخطأ متعلق بالمصادقة، لا نحاول مرة أخرى
        if (e.toString().contains('مصادقة') || e.toString().contains('token')) {
          debugPrint('❌ ProfileService: Authentication error, not retrying');
          break;
        }

        // إذا كان الخطأ متعلق بالملف نفسه، لا نحاول مرة أخرى
        if (e.toString().contains('file') &&
            e.toString().contains('not found')) {
          debugPrint('❌ ProfileService: File error, not retrying');
          break;
        }

        if (retryCount >= maxRetries) {
          debugPrint('❌ ProfileService: All retry attempts failed');
          break;
        }
      }
    }

    // إذا وصلنا هنا، فشلت جميع المحاولات
    debugPrint(
        '❌ ProfileService: Document upload failed after $maxRetries attempts');
    throw lastException ??
        Exception('فشل في رفع الوثيقة بعد $maxRetries محاولات');
  }

  /// Upload document file for specific field
  static Future<DocumentUploadModel?> uploadDocumentFile({
    required File file,
    required String documentType,
    required String fieldName,
    Uint8List? fileBytes, // إضافة البيانات للويب
  }) async {
    try {
      debugPrint(
          '📄 ProfileService: Uploading document file for field: $fieldName');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return null;
      }

      // Create form data
      MultipartFile multipartFile;
      String fileName;

      if (kIsWeb) {
        // في بيئة الويب، استخدم البيانات المرسلة مباشرة مع الحفاظ على الامتداد الأصلي
        final originalFileName = file.path.isNotEmpty
            ? file.path.split('/').last
            : 'document_${DateTime.now().millisecondsSinceEpoch}';

        // الحفاظ على الامتداد الأصلي من اسم الملف
        String fileExtension = 'bin'; // امتداد افتراضي للأغراض العامة
        if (originalFileName.contains('.')) {
          fileExtension = originalFileName.split('.').last.toLowerCase();
        }

        fileName =
            'document_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        if (fileBytes != null) {
          // استخدام البيانات المرسلة مباشرة مع الحفاظ على نوع الملف الأصلي
          multipartFile = MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
          );
          debugPrint(
              '✅ ProfileService: Web upload - preserving original file type: .$fileExtension');
        } else {
          debugPrint('❌ ProfileService: No file bytes provided for web upload');
          throw Exception('لم يتم توفير بيانات الملف لرفعه في بيئة الويب');
        }
      } else {
        // في بيئة الموبايل، استخدم path مع الحفاظ على الامتداد الأصلي
        fileName = file.path.split('/').last;
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
        debugPrint(
            '✅ ProfileService: Mobile upload - preserving original file name: $fileName');
      }

      // الحصول على معرف المستخدم من CompatibleAuthService (مثل uploadDocumentFileWithRetry)
      final compatibleAuthService = CompatibleAuthService.instance;
      var currentUser = compatibleAuthService.user;
      String userId;

      if (currentUser == null || currentUser.id.isEmpty) {
        debugPrint('⚠️ ProfileService: Current user is null in auth service, trying to fetch profile...');
        try {
          // محاولة جلب البروفايل للحصول على المعرف
          final profile = await getProfile(useRecentCache: true);
          if (profile != null && profile.userId.isNotEmpty) {
            userId = profile.userId;
            debugPrint('✅ ProfileService: Retrieved userId from profile: $userId');
          } else {
             throw Exception('لم يتم العثور على بيانات المستخدم');
          }
        } catch (e) {
          debugPrint('❌ ProfileService: Failed to retrieve user info: $e');
          throw Exception('لم يتم العثور على بيانات المستخدم الحالي');
        }
      } else {
        userId = currentUser.id;
      }
      
      debugPrint('👤 ProfileService: Current user ID: $userId');

      final formData = FormData.fromMap({
        'file': multipartFile,
        'entityType': 'USER_DOCUMENT', // نوع الكيان - enum value
        'entityId': userId, // معرف المستخدم الحقيقي
        'fileCategory': fieldName, // فئة الملف (يجب أن تكون OTHER_DOCUMENT)
        'description':
            'Document uploaded from mobile app for profile review', // وصف الملف
      });
      
      // 🔍 DEBUG: طباعة تفاصيل الرفع
      debugPrint('📤 [UPLOAD_DOCUMENT] Uploading document with:');
      debugPrint('   - entityType: USER_DOCUMENT');
      debugPrint('   - entityId: $userId');
      debugPrint('   - fileCategory: $fieldName');
      debugPrint('   - fileName: $fileName');

      final response = await _dio.post(
        '/api/v1/files/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // لا نضع Content-Type هنا، دع Dio يتعامل معه تلقائياً
          },
          sendTimeout:
              const Duration(seconds: 300), // timeout للإرسال لملفات كبيرة
          receiveTimeout: const Duration(seconds: 300), // timeout للاستقبال
        ),
      );

      debugPrint(
          '📄 ProfileService: Upload response status: ${response.statusCode}');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        debugPrint('📄 ProfileService: Document uploaded successfully');
        debugPrint('📄 ProfileService: Response data: $data');

        // فحص البيانات قبل المعالجة
        if (data != null && data is Map<String, dynamic>) {
          try {
            // الخادم يرجع البيانات في حقل 'file'
            Map<String, dynamic> documentData;
            if (data.containsKey('file') && data['file'] != null) {
              documentData = Map<String, dynamic>.from(data['file']);
            } else {
              documentData = Map<String, dynamic>.from(data);
            }

            // تحويل البيانات من FileResponseDto إلى DocumentUploadModel
            final convertedData = <String, dynamic>{
              'id': documentData['id']?.toString() ?? '',
              'userId': documentData['entityId']?.toString() ??
                  documentData['uploadedBy']?.toString() ??
                  '',
              'documentType': documentData['fileCategory']?.toString() ??
                  documentData['documentType']?.toString() ??
                  'general',
              'fileName': documentData['originalName']?.toString() ??
                  documentData['fileName']?.toString() ??
                  '',
              'fileUrl': documentData['url']?.toString() ??
                  documentData['fileUrl']?.toString() ??
                  '',
              'status': 'uploaded', // افتراضي لأن الرفع نجح
              'uploadedAt': DateTime.now().toIso8601String(),
            };

            return DocumentUploadModel.fromJson(convertedData);
          } catch (e) {
            debugPrint(
                '⚠️ ProfileService: Could not parse response as DocumentUploadModel: $e');
            debugPrint(
                '⚠️ ProfileService: Response data structure: ${data.keys.toList()}');

            // بما أن الرفع نجح، نرجع نموذج بسيط يشير للنجاح
            debugPrint(
                '✅ ProfileService: Upload succeeded but could not parse response, treating as success');
            // إنشاء نموذج بسيط للنجاح
            return DocumentUploadModel(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              userId: 'current_user', // قيمة مؤقتة
              fileName: file.path.split('/').last,
              fileUrl: 'uploaded',
              documentType: documentType,
              uploadedAt: DateTime.now(),
              status: 'uploaded',
            );
          }
        } else {
          debugPrint(
              '⚠️ ProfileService: Response data is null or invalid format');
          debugPrint('⚠️ ProfileService: Data type: ${data.runtimeType}');
          return null;
        }
      } else {
        debugPrint(
            '❌ ProfileService: Failed to upload document: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error uploading document: $e');
      return null;
    }
  }

  /// Update profile data
  static Future<ProfileUpdateResponse> updateProfileData(
      ProfileUpdateRequest request) async {
    try {
      debugPrint('💾 ProfileService: Updating profile data');
      debugPrint('💾 Request data: ${request.toJson()}');

      // استخدام DioService للحصول على الرمز المميز بدلاً من StorageService
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ ProfileService: No authentication token found');
        return const ProfileUpdateResponse(
          success: false,
          message: 'Authentication token not found',
        );
      }
      debugPrint('🔑 ProfileService: Token found, length: ${token.length}');

      final response = await _dio.put(
        '${ApiConstants.baseUrl}/api/v1/profiles/me',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
          '💾 ProfileService: Update response status: ${response.statusCode}');
      debugPrint('💾 ProfileService: Update response data: ${response.data}');

      if (response.statusCode == 200) {
        debugPrint('💾 ProfileService: Update response data: ${response.data}');

        // Check if response contains reviewRequestId (indicating review request was created)
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('reviewRequestId')) {
          final responseData = response.data as Map<String, dynamic>;
          debugPrint(
              '📋 ProfileService: Review request created with ID: ${responseData['reviewRequestId']}');

          return ProfileUpdateResponse(
            success: true,
            message: responseData['message'] ?? 'تم إرسال طلب المراجعة بنجاح',
            reviewRequestId: responseData['reviewRequestId'],
          );
        } else {
          // Normal profile update (no review required)
          debugPrint('✅ ProfileService: Profile data updated successfully');
          return const ProfileUpdateResponse(
            success: true,
            message: 'تم تحديث بيانات الملف الشخصي بنجاح',
          );
        }
      } else {
        return ProfileUpdateResponse(
          success: false,
          message: 'Update failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error updating profile data: $e');

      if (e is DioException) {
        if (e.response?.data != null) {
          final errorData = e.response!.data;
          // Handle error response - don't try to parse as ProfileUpdateResponse
          String errorMessage = 'Update failed';
          if (errorData is Map<String, dynamic>) {
            errorMessage = errorData['message']?.toString() ??
                errorData['error']?.toString() ??
                'Update failed';
          } else if (errorData is String) {
            errorMessage = errorData;
          }

          return ProfileUpdateResponse(
            success: false,
            message: errorMessage,
          );
        } else {
          return ProfileUpdateResponse(
            success: false,
            message: 'Network error: ${e.message}',
          );
        }
      } else {
        return ProfileUpdateResponse(
          success: false,
          message: 'Unexpected error: $e',
        );
      }
    }
  }

  /// Clear cached profile data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const userIdKey = '${_cacheKey}_user_id';
      
      // مسح جميع المفاتيح المتعلقة بالكاش
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
      await prefs.remove(userIdKey);
      debugPrint('✅ Profile cache cleared from SharedPreferences');
      
      // على الويب، مسح localStorage أيضاً بشكل مباشر
      if (kIsWeb) {
        try {
          // مسح المفاتيح الأساسية
          removeLocalStorageValue(_cacheKey);
          removeLocalStorageValue(_cacheTimestampKey);
          removeLocalStorageValue(userIdKey);
          
          // مسح جميع المفاتيح التي تبدأ بـ cached_ أو profile_
          final keysToRemove = <String>[];
          forEachLocalStorage((key, value) {
            if (key.startsWith('cached_') || 
                key.startsWith('profile_') ||
                key.contains('cached_profile') ||
                key.contains('profile_cache') ||
                key.contains('_user_id')) {
              keysToRemove.add(key);
            }
          });
          
          for (final key in keysToRemove) {
            removeLocalStorageValue(key);
          }
          
          // مسح من sessionStorage أيضاً
          removeSessionStorageValue(_cacheKey);
          removeSessionStorageValue(_cacheTimestampKey);
          removeSessionStorageValue(userIdKey);
          
          for (final key in keysToRemove) {
            removeSessionStorageValue(key);
          }
          
          debugPrint('✅ Profile cache cleared from web storage (${keysToRemove.length + 3} keys)');
        } catch (e) {
          debugPrint('⚠️ Error clearing profile cache from web storage: $e');
        }
      }
      
      debugPrint('✅ Profile cache cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing profile cache: $e');
    }
  }

  /// Get cache status information
  static Future<Map<String, dynamic>> getCacheStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);
      final hasCache = prefs.containsKey(_cacheKey);

      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final ageHours = now.difference(cacheTime).inHours;

        return {
          'hasCache': hasCache,
          'cacheTime': cacheTime.toIso8601String(),
          'ageHours': ageHours,
          'isValid': ageHours < _cacheValidityHours,
        };
      }

      return {
        'hasCache': hasCache,
        'cacheTime': null,
        'ageHours': null,
        'isValid': false,
      };
    } catch (e) {
      debugPrint('Error getting cache status: $e');
      return {
        'hasCache': false,
        'cacheTime': null,
        'ageHours': null,
        'isValid': false,
        'error': e.toString(),
      };
    }
  }

  /// استخراج الحقول المطلوبة من قواعد البروفايل
  static List<String> _extractRequiredFields(List<ProfileRuleModel> rules) {
    final requiredFields = <String>[];

    for (final rule in rules) {
      if (rule.requiresDocument && rule.fieldName.isNotEmpty) {
        requiredFields.add(rule.fieldName);
      }
    }

    return requiredFields;
  }

  /// استخراج نصوص القواعد من قواعد البروفايل
  static List<String> _extractRulesText(List<ProfileRuleModel> rules) {
    final rulesText = <String>[];

    for (final rule in rules) {
      if (rule.fieldDescription != null && rule.fieldDescription!.isNotEmpty) {
        rulesText.add(rule.fieldDescription!);
      }
    }

    return rulesText;
  }

  /// حساب نسبة إكمال الملف الشخصي حسب النسب المحددة
  /// النسب المطلوبة:
  /// - الاسم العربي: 20%
  /// - الاسم الإنجليزي: 20%
  /// - البريد الإلكتروني: 5%
  /// - تاريخ الميلاد: 10%
  /// - المحافظة: 10%
  /// - المؤهل: 20%
  /// - سنة التخرج: 5%
  /// - الجامعة: 5%
  /// - مكان العمل: 5%
  static double calculateCompletionPercentage(ProfileModel profile) {
    double completionPercentage = 0.0;

    // الاسم العربي - 20%
    if (profile.fullNameAr.isNotEmpty) {
      completionPercentage += 20.0;
    }

    // الاسم الإنجليزي - 20%
    if (profile.fullNameEn.isNotEmpty) {
      completionPercentage += 20.0;
    }

    // البريد الإلكتروني - 5%
    if (profile.email.isNotEmpty) {
      completionPercentage += 5.0;
    }

    // تاريخ الميلاد - 10%
    if (profile.birthDate != null) {
      completionPercentage += 10.0;
    }

    // المحافظة - 10%
    if (profile.governorateId != null && profile.governorateId!.isNotEmpty) {
      completionPercentage += 10.0;
    }

    // المؤهل - 20%
    if (profile.qualificationId != null &&
        profile.qualificationId!.isNotEmpty) {
      completionPercentage += 20.0;
    }

    // سنة التخرج - 5%
    if (profile.graduationYear != null && profile.graduationYear! > 0) {
      completionPercentage += 5.0;
    }

    // الجامعة - 5%
    if (profile.university.isNotEmpty) {
      completionPercentage += 5.0;
    }

    // مكان العمل - 5%
    if (profile.workplace.isNotEmpty) {
      completionPercentage += 5.0;
    }

    return completionPercentage;
  }
}

