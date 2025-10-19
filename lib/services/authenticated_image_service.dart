import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import 'dio_service.dart';

/// خدمة لتحميل الصور مع المصادقة
class AuthenticatedImageService {
  /// تحميل الصورة مع رؤوس المصادقة
  static Future<Uint8List?> loadImageWithAuth(String imageUrl) async {
    try {
      debugPrint(
          '🖼️ AuthenticatedImageService: Loading image with auth: $imageUrl');

      // الحصول على رمز المصادقة
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint(
            '❌ AuthenticatedImageService: No authentication token found');
        throw Exception('No authentication token available');
      }

      // استخدام EnhancedDioServiceV2.instance.dio للاستفادة من interceptors
      // استخراج fileId من URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      String? fileId;

      // البحث عن fileId في المسار
      for (int i = 0; i < pathSegments.length; i++) {
        if (pathSegments[i] == 'files' && i + 1 < pathSegments.length) {
          fileId = pathSegments[i + 1];
          break;
        }
      }

      if (fileId == null) {
        throw Exception('Invalid file URL format');
      }

      // استخدام endpoint الملفات الشخصية الجديد
      final profileFileUrl =
          '${ApiConstants.baseUrl}/api/v1/profiles/me/files/$fileId/download';

      final response = await EnhancedDioServiceV2.instance.dio.get(
        profileFileUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ AuthenticatedImageService: Image loaded successfully');
        return Uint8List.fromList(response.data);
      } else {
        debugPrint(
            '❌ AuthenticatedImageService: Failed to load image: ${response.statusCode}');
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint(
          '❌ AuthenticatedImageService: DioException loading image: ${e.response?.statusCode} - ${e.message}');

      // إذا كان خطأ 401، فهذا يعني مشكلة في المصادقة
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed');
      }

      throw Exception('Failed to load image: ${e.message}');
    } catch (e) {
      debugPrint('❌ AuthenticatedImageService: Error loading image: $e');
      throw Exception('Failed to load image: $e');
    }
  }

  /// تحويل URL النسبي إلى URL مطلق
  static String getFullImageUrl(String relativeUrl) {
    if (relativeUrl.startsWith('http')) {
      return relativeUrl;
    }

    // إزالة الشرطة المائلة في البداية إذا كانت موجودة
    final cleanUrl =
        relativeUrl.startsWith('/') ? relativeUrl.substring(1) : relativeUrl;

    return '${ApiConstants.baseUrl}/$cleanUrl';
  }

  /// فحص ما إذا كان URL يحتاج إلى مصادقة
  static bool requiresAuthentication(String imageUrl) {
    // إذا كان URL يحتوي على endpoint تحميل الملفات، فهو يحتاج مصادقة
    return imageUrl.contains('/api/v1/files/') &&
        imageUrl.contains('/download');
  }
}
