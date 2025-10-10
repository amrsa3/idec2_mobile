import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import 'dio_service.dart';

/// خدمة لتحميل الصور مع المصادقة
class AuthenticatedImageService {
  static final Dio _dio = Dio();

  /// تحميل الصورة مع رؤوس المصادقة
  static Future<Uint8List?> loadImageWithAuth(String imageUrl) async {
    try {
      debugPrint('🖼️ AuthenticatedImageService: Loading image with auth: $imageUrl');

      // الحصول على رمز المصادقة
      final token = await DioService.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('❌ AuthenticatedImageService: No authentication token found');
        return null;
      }

      // إرسال طلب تحميل الصورة مع رؤوس المصادقة
      final response = await _dio.get(
        imageUrl,
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
        debugPrint('❌ AuthenticatedImageService: Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ AuthenticatedImageService: Error loading image: $e');
      return null;
    }
  }

  /// تحويل URL النسبي إلى URL مطلق
  static String getFullImageUrl(String relativeUrl) {
    if (relativeUrl.startsWith('http')) {
      return relativeUrl;
    }
    
    // إزالة الشرطة المائلة في البداية إذا كانت موجودة
    final cleanUrl = relativeUrl.startsWith('/') ? relativeUrl.substring(1) : relativeUrl;
    
    return '${AppConstants.baseUrl}/$cleanUrl';
  }

  /// فحص ما إذا كان URL يحتاج إلى مصادقة
  static bool requiresAuthentication(String imageUrl) {
    // إذا كان URL يحتوي على endpoint تحميل الملفات، فهو يحتاج مصادقة
    return imageUrl.contains('/api/v1/files/') && imageUrl.contains('/download');
  }
}