import '../../services/storage_service.dart';

/// مساعد التخزين - يوفر واجهة مبسطة للوصول إلى StorageService
class StorageHelper {
  static StorageService get _storage => DefaultStorageService();

  /// الحصول على رمز الوصول
  static Future<String?> getToken() async {
    try {
      return _storage.getString('access_token');
    } catch (e) {
      return null;
    }
  }

  /// حفظ رمز الوصول
  static Future<void> setToken(String token) async {
    try {
      await _storage.setString('access_token', token);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// الحصول على رمز التحديث
  static Future<String?> getRefreshToken() async {
    try {
      return _storage.getString('refresh_token');
    } catch (e) {
      return null;
    }
  }

  /// حفظ رمز التحديث
  static Future<void> setRefreshToken(String token) async {
    try {
      await _storage.setString('refresh_token', token);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// مسح جميع الرموز
  static Future<void> clearTokens() async {
    try {
      await _storage.remove('access_token');
      await _storage.remove('refresh_token');
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// الحصول على قيمة نصية
  static Future<String?> getString(String key) async {
    try {
      return _storage.getString(key);
    } catch (e) {
      return null;
    }
  }

  /// حفظ قيمة نصية
  static Future<void> setString(String key, String value) async {
    try {
      await _storage.setString(key, value);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// الحصول على قيمة منطقية
  static Future<bool?> getBool(String key) async {
    try {
      return _storage.getBool(key);
    } catch (e) {
      return null;
    }
  }

  /// حفظ قيمة منطقية
  static Future<void> setBool(String key, bool value) async {
    try {
      await _storage.setBool(key, value);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// حذف مفتاح
  static Future<void> remove(String key) async {
    try {
      await _storage.remove(key);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// مسح جميع البيانات
  static Future<void> clear() async {
    try {
      await _storage.clear();
    } catch (e) {
      // تجاهل الأخطاء
    }
  }
}
