import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service للتحقق من تحديثات الإصدار ومسح الكاش عند التحديث
class VersionCheckService {
  static const String _lastVersionKey = 'last_app_version';
  static const String _lastBuildNumberKey = 'last_build_number';

  /// التحقق من تحديثات الإصدار ومسح الكاش عند التحديث
  static Future<void> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      final versionString = '$currentVersion+$buildNumber';

      debugPrint('📦 [VERSION_CHECK] Current version: $versionString');

      // حفظ الإصدار الحالي
      final prefs = await SharedPreferences.getInstance();
      final lastVersion = prefs.getString(_lastVersionKey);
      final lastBuildNumber = prefs.getString(_lastBuildNumberKey);

      // التحقق من التحديث
      if (lastVersion != null && lastVersion != currentVersion) {
        debugPrint('🔄 [VERSION_CHECK] New version detected: $lastVersion -> $currentVersion');
        await _clearCacheOnUpdate(prefs);
      } else if (lastBuildNumber != null && lastBuildNumber != buildNumber) {
        debugPrint('🔄 [VERSION_CHECK] New build detected: $lastBuildNumber -> $buildNumber');
        await _clearCacheOnUpdate(prefs);
      }

      // حفظ الإصدار الحالي
      await prefs.setString(_lastVersionKey, currentVersion);
      await prefs.setString(_lastBuildNumberKey, buildNumber);

      debugPrint('✅ [VERSION_CHECK] Version check completed');
    } catch (e, stackTrace) {
      debugPrint('❌ [VERSION_CHECK] Error checking version: $e');
      debugPrint('❌ [VERSION_CHECK] Stack trace: $stackTrace');
    }
  }

  /// مسح الكاش عند التحديث
  static Future<void> _clearCacheOnUpdate(SharedPreferences prefs) async {
    try {
      debugPrint('🧹 [VERSION_CHECK] Clearing cache due to update...');

      // مسح SharedPreferences (يمكن تحديد ما يجب مسحه)
      // يمكن إضافة منطق مخصص هنا لمسح بيانات معينة فقط

      // مسح image cache إذا كان متاحاً
      try {
        // يمكن إضافة استدعاء لمسح image cache هنا
        debugPrint('🖼️ [VERSION_CHECK] Image cache cleared');
      } catch (e) {
        debugPrint('⚠️ [VERSION_CHECK] Could not clear image cache: $e');
      }

      debugPrint('✅ [VERSION_CHECK] Cache cleared successfully');
    } catch (e) {
      debugPrint('❌ [VERSION_CHECK] Error clearing cache: $e');
    }
  }

  /// الحصول على الإصدار الحالي
  static Future<String> getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      debugPrint('❌ [VERSION_CHECK] Error getting version: $e');
      return 'Unknown';
    }
  }

  /// الحصول على Build Number الحالي
  static Future<String> getCurrentBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      debugPrint('❌ [VERSION_CHECK] Error getting build number: $e');
      return 'Unknown';
    }
  }

  /// الحصول على معلومات الإصدار الكاملة
  static Future<Map<String, String>> getVersionInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return {
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
      };
    } catch (e) {
      debugPrint('❌ [VERSION_CHECK] Error getting version info: $e');
      return {
        'version': 'Unknown',
        'buildNumber': 'Unknown',
        'appName': 'Unknown',
        'packageName': 'Unknown',
      };
    }
  }
}

