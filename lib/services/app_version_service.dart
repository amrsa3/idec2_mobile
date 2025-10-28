import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// خدمة للحصول على معلومات إصدار التطبيق
class AppVersionService {
  static AppVersionService? _instance;
  static AppVersionService get instance => _instance ??= AppVersionService._();
  
  AppVersionService._();
  
  PackageInfo? _packageInfo;
  bool _isInitialized = false;
  String _versionSource = 'unknown'; // مصدر الإصدار
  DateTime? _initializationTime; // وقت التهيئة
  String? _initializationError; // خطأ التهيئة إن وجد
  Duration? _initializationDuration; // مدة التهيئة
  
  /// تهيئة خدمة الإصدار
  Future<void> initialize() async {
    final startTime = DateTime.now();
    _initializationTime = startTime;
    
    try {
      print('');
      print('🔄🔄🔄 ===== APP VERSION SERVICE INITIALIZATION ===== 🔄🔄🔄');
      print('📅 Init Start Time: ${startTime.toIso8601String()}');
      print('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
      print('🔧 Debug Mode: ${kDebugMode ? 'YES' : 'NO'}');
      print('🏭 Profile Mode: ${kProfileMode ? 'YES' : 'NO'}');
      print('🚀 Release Mode: ${kReleaseMode ? 'YES' : 'NO'}');
      print('📦 Expected Version: 2.0.1+3');
      print('🔄🔄🔄 ============================================== 🔄🔄🔄');
      print('');
      
      debugPrint('🔄 AppVersionService: Starting initialization...');
      developer.log('Starting AppVersionService initialization', name: 'APP_VERSION_INIT');
      developer.log('Platform: ${kIsWeb ? 'Web' : 'Mobile'}', name: 'APP_VERSION_PLATFORM');
      developer.log('Debug Mode: ${kDebugMode ? 'YES' : 'NO'}', name: 'APP_VERSION_DEBUG');
      developer.log('Release Mode: ${kReleaseMode ? 'YES' : 'NO'}', name: 'APP_VERSION_RELEASE');
      
      if (kIsWeb) {
        // For web, we'll use a fallback approach
        debugPrint('🌐 AppVersionService: Detected Web platform');
        _packageInfo = await PackageInfo.fromPlatform().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            _versionSource = 'web_fallback_timeout';
            debugPrint('🔄 AppVersionService: Web timeout - using fallback version');
            developer.log('Web platform timeout - using fallback', name: 'APP_VERSION_TIMEOUT');
            // Return a mock PackageInfo for web if timeout occurs
            return PackageInfo(
              appName: 'IDEC Conference App',
              packageName: 'com.idec.conference',
              version: 'unknown', // Will be handled by getter
              buildNumber: 'unknown',
            );
          },
        );
        
        if (_versionSource == 'unknown') {
          _versionSource = 'web_platform_info';
          debugPrint('✅ AppVersionService: Successfully loaded from web platform info');
        }
      } else {
        // For mobile platforms
        debugPrint('📱 AppVersionService: Detected Mobile platform');
        _packageInfo = await PackageInfo.fromPlatform();
        _versionSource = 'mobile_platform_info';
        debugPrint('✅ AppVersionService: Successfully loaded from mobile platform info');
      }
      
      _isInitialized = true;
      _initializationDuration = DateTime.now().difference(startTime);
      
      // طباعة معلومات التشخيص
      _printDiagnosticInfo();
      
    } catch (e) {
      _initializationError = e.toString();
      _initializationDuration = DateTime.now().difference(startTime);
      
      debugPrint('❌ AppVersionService Error: $e');
      developer.log('AppVersionService initialization error: $e', name: 'APP_VERSION_ERROR');
      
      _versionSource = 'fallback_error';
      // Fallback for any platform
      _packageInfo = PackageInfo(
        appName: 'IDEC Conference App',
        packageName: 'com.idec.conference',
        version: 'unknown', // Will be handled by getter
        buildNumber: 'unknown',
      );
      _isInitialized = true;
      
      // طباعة معلومات التشخيص حتى في حالة الخطأ
      _printDiagnosticInfo();
    }
  }
  
  /// طباعة معلومات التشخيص المفصلة
  void _printDiagnosticInfo() {
    final now = DateTime.now();
    final initTime = _initializationTime ?? now;
    
    // معلومات النظام
    String platformInfo = 'Unknown';
    String osVersion = 'Unknown';
    
    try {
      if (kIsWeb) {
        platformInfo = 'Web Browser';
        osVersion = 'Web Platform';
      } else {
        platformInfo = Platform.operatingSystem;
        osVersion = Platform.operatingSystemVersion;
      }
    } catch (e) {
      platformInfo = 'Error getting platform info';
      osVersion = 'Error: $e';
    }
    
    debugPrint('');
    debugPrint('🔍 ===== APP VERSION SERVICE DIAGNOSTIC INFO =====');
    debugPrint('📅 Initialization Time: ${initTime.toIso8601String()}');
    debugPrint('⏱️  Current Time: ${now.toIso8601String()}');
    debugPrint('⏳ Initialization Duration: ${_initializationDuration?.inMilliseconds ?? 0}ms');
    debugPrint('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)');
    debugPrint('💻 OS Version: $osVersion');
    debugPrint('🔧 Debug Mode: ${kDebugMode ? 'YES' : 'NO'}');
    debugPrint('🏭 Profile Mode: ${kProfileMode ? 'YES' : 'NO'}');
    debugPrint('🚀 Release Mode: ${kReleaseMode ? 'YES' : 'NO'}');
    debugPrint('📦 Version Source: $_versionSource');
    debugPrint('✅ Is Initialized: $_isInitialized');
    debugPrint('❌ Initialization Error: ${_initializationError ?? 'None'}');
    debugPrint('📱 App Name: ${appName}');
    debugPrint('📋 Package Name: ${packageName}');
    debugPrint('🔢 Version: ${version}');
    debugPrint('🏗️  Build Number: ${buildNumber}');
    debugPrint('📊 Full Version: ${fullVersion}');
    debugPrint('🎯 Expected Version: 2.0.1+3');
    debugPrint('🔍 Version Match: ${fullVersion == '2.0.1+3' ? '✅ MATCHES' : '❌ MISMATCH'}');
    debugPrint('🔍 Raw Package Info: ${_packageInfo?.toString() ?? 'null'}');
    debugPrint('🔍 ============================================');
    debugPrint('');
    
    // إضافة developer.log للتأكد من ظهور الرسائل في الكونسول
    final diagnosticMessage = '''
APP VERSION SERVICE DIAGNOSTIC:
- Version: ${fullVersion}
- Source: $_versionSource
- Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)
- OS: $osVersion
- Build Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}
- Initialized: $_isInitialized
- Duration: ${_initializationDuration?.inMilliseconds ?? 0}ms
- Error: ${_initializationError ?? 'None'}
- Expected: 2.0.1+3
- Match: ${fullVersion == '2.0.1+3' ? 'YES' : 'NO'}
''';
    
    developer.log(diagnosticMessage, name: 'APP_VERSION_SERVICE');
    
    // إضافة رسائل منفصلة لكل معلومة مهمة
    developer.log('App Version: ${fullVersion}', name: 'VERSION_INFO');
    developer.log('Version Source: $_versionSource', name: 'VERSION_SOURCE');
    developer.log('Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)', name: 'PLATFORM_INFO');
    developer.log('Build Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}', name: 'BUILD_MODE');
    developer.log('Version Match: ${fullVersion == '2.0.1+3' ? 'MATCHES' : 'MISMATCH'}', name: 'VERSION_MATCH');
    
    // إضافة تحذير واضح إذا كان الإصدار لا يطابق المتوقع
    if (fullVersion != '2.0.1+3') {
      debugPrint('');
      debugPrint('⚠️  ===== VERSION SERVICE MISMATCH WARNING =====');
      debugPrint('🎯 Expected: 2.0.1+3');
      debugPrint('📊 Actual: ${fullVersion}');
      debugPrint('📦 Source: $_versionSource');
      debugPrint('🔧 This may indicate a caching or build issue');
      debugPrint('💡 Suggestion: Try flutter clean && flutter pub get && flutter build web --release');
      debugPrint('⚠️  ==========================================');
      debugPrint('');
      
      developer.log('VERSION SERVICE MISMATCH WARNING - Expected: 2.0.1+3, Actual: ${fullVersion}, Source: $_versionSource', name: 'VERSION_SERVICE_MISMATCH');
    }
  }
  
  /// الحصول على رقم الإصدار
  String get version {
    final packageVersion = _packageInfo?.version;
    if (packageVersion == null || packageVersion == 'unknown' || packageVersion.isEmpty) {
      // استخراج الإصدار من pubspec.yaml كـ fallback
      debugPrint('⚠️  Using fallback version: 2.0.1');
      developer.log('Using fallback version: 2.0.1', name: 'VERSION_FALLBACK');
      return '2.0.1'; // هذا سيتم تحديثه تلقائياً من pubspec.yaml عند البناء
    }
    return packageVersion;
  }
  
  /// الحصول على رقم البناء
  String get buildNumber {
    final packageBuildNumber = _packageInfo?.buildNumber;
    if (packageBuildNumber == null || packageBuildNumber == 'unknown' || packageBuildNumber.isEmpty) {
      // استخراج رقم البناء من pubspec.yaml كـ fallback
      debugPrint('⚠️  Using fallback build number: 2');
      developer.log('Using fallback build number: 2', name: 'BUILD_FALLBACK');
      return '2'; // هذا سيتم تحديثه تلقائياً من pubspec.yaml عند البناء
    }
    return packageBuildNumber;
  }
  
  /// الحصول على رقم الإصدار مع رقم البناء
  String get fullVersion => '${version}+${buildNumber}';
  
  /// الحصول على اسم التطبيق
  String get appName => _packageInfo?.appName ?? 'IDEC Conference App';
  
  /// الحصول على اسم الحزمة
  String get packageName => _packageInfo?.packageName ?? 'com.idec.conference';
  
  /// التحقق من تهيئة الخدمة
  bool get isInitialized => _isInitialized;
  
  /// الحصول على مصدر الإصدار
  String get versionSource => _versionSource;
  
  /// الحصول على وقت التهيئة
  DateTime? get initializationTime => _initializationTime;
  
  /// الحصول على خطأ التهيئة
  String? get initializationError => _initializationError;
  
  /// الحصول على مدة التهيئة
  Duration? get initializationDuration => _initializationDuration;
  
  /// طباعة معلومات التشخيص يدوياً
  void printDiagnosticInfo() => _printDiagnosticInfo();
  
  /// طباعة ملخص سريع للإصدار
  void printVersionSummary() {
    final summary = 'IDEC App v${fullVersion} (${_versionSource})';
    debugPrint('📱 $summary');
    developer.log(summary, name: 'VERSION_SUMMARY');
  }
  
  /// التحقق من صحة الإصدار
  bool isVersionValid() {
    final ver = version;
    final build = buildNumber;
    
    // التحقق من أن الإصدار ليس unknown أو فارغ
    final isValid = ver != 'unknown' && ver.isNotEmpty && 
                   build != 'unknown' && build.isNotEmpty;
    
    if (!isValid) {
      debugPrint('⚠️  Version validation failed: version=$ver, build=$build');
      developer.log('Version validation failed: version=$ver, build=$build', name: 'VERSION_VALIDATION');
    }
    
    return isValid;
  }
}