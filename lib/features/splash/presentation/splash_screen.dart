import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/enhanced_auth_provider_v2.dart';
import '../../../providers/language_provider.dart';
import '../../../services/app_version_service.dart';
import '../../../services/enhanced_storage_service.dart';
import '../../../services/language_service.dart';
import '../../../services/migration_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/registration_settings_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _currentVersion = '2.0.1+3'; // Default fallback from pubspec.yaml
  bool _versionLoaded = false;
  DateTime? _splashStartTime;
  DateTime? _versionInitStartTime;
  DateTime? _versionInitEndTime;

  @override
  void initState() {
    super.initState();
    _splashStartTime = DateTime.now();
    
    // طباعة رسائل واضحة جداً في بداية التطبيق
    print('');
    print('🚀🚀🚀 ===== SPLASH SCREEN INIT STATE STARTED ===== 🚀🚀🚀');
    print('📅 Init Time: ${_splashStartTime!.toIso8601String()}');
    print('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    print('🔧 Debug Mode: ${kDebugMode ? 'YES' : 'NO'}');
    print('🏭 Profile Mode: ${kProfileMode ? 'YES' : 'NO'}');
    print('🚀 Release Mode: ${kReleaseMode ? 'YES' : 'NO'}');
    print('📦 Expected Version: 2.0.1+3');
    print('🎯 Current Version (fallback): $_currentVersion');
    print('🚀🚀🚀 ============================================== 🚀🚀🚀');
    print('');
    
    // طباعة رسالة واضحة في JavaScript console
    _logToJSConsole('🚀🚀🚀 SPLASH SCREEN INIT STATE STARTED 🚀🚀🚀');
    _logToJSConsole('📅 Start Time: ${_splashStartTime!.toIso8601String()}');
    _logToJSConsole('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    _logToJSConsole('🔧 Debug Mode: ${kDebugMode ? 'YES' : 'NO'}');
    _logToJSConsole('🏭 Profile Mode: ${kProfileMode ? 'YES' : 'NO'}');
    _logToJSConsole('🚀 Release Mode: ${kReleaseMode ? 'YES' : 'NO'}');
    _logToJSConsole('📦 Expected Version: 2.0.1+3');
    _logToJSConsole('🎯 Current Version (fallback): $_currentVersion');
    
    // إضافة developer.log للتأكد من ظهور الرسائل
    developer.log('🚀 SPLASH SCREEN INIT STATE STARTED', name: 'SPLASH_INIT');
    developer.log('Platform: ${kIsWeb ? 'Web' : 'Mobile'}', name: 'SPLASH_PLATFORM');
    developer.log('Debug Mode: ${kDebugMode ? 'YES' : 'NO'}', name: 'SPLASH_DEBUG');
    developer.log('Release Mode: ${kReleaseMode ? 'YES' : 'NO'}', name: 'SPLASH_RELEASE');
    developer.log('Expected Version: 2.0.1+3', name: 'SPLASH_EXPECTED_VERSION');
    
    _printComprehensiveSplashInfo();
    _setupAnimations();
    _initializeVersionAndNavigate();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo scale animation
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text fade animation
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Start logo animation
    _logoController.forward();

    // Start text animation after logo animation completes
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });
  }

  /// طباعة معلومات شاملة عن بداية Splash
  void _printComprehensiveSplashInfo() {
    final now = DateTime.now();
    
    // معلومات النظام
    String platformInfo = 'Unknown';
    String osVersion = 'Unknown';
    String deviceInfo = 'Unknown';
    
    try {
      if (kIsWeb) {
        platformInfo = 'Web Browser';
        osVersion = 'Web Platform';
        deviceInfo = 'Browser Environment';
      } else {
        platformInfo = Platform.operatingSystem;
        osVersion = Platform.operatingSystemVersion;
        deviceInfo = '${Platform.operatingSystem} Device';
      }
    } catch (e) {
      platformInfo = 'Error getting platform info';
      osVersion = 'Error: $e';
      deviceInfo = 'Error getting device info';
    }
    
    print('');
    print('🚀 ========== SPLASH SCREEN COMPREHENSIVE INFO ==========');
    print('📅 Splash Start Time: ${now.toIso8601String()}');
    print('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)');
    print('💻 OS Version: $osVersion');
    print('📱 Device Info: $deviceInfo');
    print('🔧 Debug Mode: ${kDebugMode ? 'YES' : 'NO'}');
    print('🏭 Profile Mode: ${kProfileMode ? 'YES' : 'NO'}');
    print('🚀 Release Mode: ${kReleaseMode ? 'YES' : 'NO'}');
    print('📦 Expected Version: 2.0.1+3 (from pubspec.yaml)');
    print('🎯 Current Version (fallback): $_currentVersion');
    print('✅ Version Loaded: $_versionLoaded');
    print('🚀 ================================================');
    print('');
    
    // إضافة developer.log للتأكد من ظهور الرسائل في الكونسول
    final comprehensiveMessage = '''
SPLASH COMPREHENSIVE INFO:
- Start Time: ${now.toIso8601String()}
- Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)
- OS: $osVersion
- Debug: ${kDebugMode ? 'YES' : 'NO'}
- Profile: ${kProfileMode ? 'YES' : 'NO'}
- Release: ${kReleaseMode ? 'YES' : 'NO'}
- Expected Version: 2.0.1+3
- Current Version: $_currentVersion
- Version Loaded: $_versionLoaded
''';
    
    developer.log(comprehensiveMessage, name: 'SPLASH_COMPREHENSIVE');
    
    // طباعة في JavaScript console للويب
    _logToJSConsole('🚀 SPLASH SCREEN STARTED');
    _logToJSConsole('📅 Start Time: ${now.toIso8601String()}');
    _logToJSConsole('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'} ($platformInfo)');
    _logToJSConsole('🔧 Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}');
    _logToJSConsole('📦 Expected Version: 2.0.1+3');
    _logToJSConsole('🎯 Current Version: $_currentVersion');
  }

  /// تهيئة الإصدار وطباعة معلومات التشخيص ثم التنقل
  Future<void> _initializeVersionAndNavigate() async {
    // طباعة معلومات بداية التطبيق
    _printSplashStartInfo();
    
    // تهيئة خدمة الإصدار
    await _initializeVersionService();
    
    // طباعة معلومات ما بعد التهيئة
    _printPostInitializationInfo();
    
    // انتظار لإكمال الرسوم المتحركة وإتاحة الوقت لرؤية معلومات التشخيص
    print('⏳ Waiting 8 seconds for version tracking and smooth transition...');
    developer.log('Waiting 8 seconds for version tracking and smooth transition', name: 'SPLASH_WAIT');
    _logToJSConsole('⏳ Waiting 8 seconds for version tracking and smooth transition...');
    
    // طباعة countdown للمساعدة في التتبع
    for (int i = 8; i > 0; i--) {
      print('⏰ Splash countdown: $i seconds remaining...');
      _logToJSConsole('⏰ Splash countdown: $i seconds remaining...');
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
    }

    if (!mounted) return;

    // Check authentication status
    final authState = ref.read(enhancedAuthProvider);

    // Check first-time flags
    final isLanguageFirstTime = await LanguageService.isLanguageFirstTime();
    final isOnboardingCompleted = await LanguageService.isOnboardingCompleted();

    // Determine next route based on app state
    String nextRoute;

    final authProvider = ref.read(enhancedAuthProvider.notifier);

    if (authProvider.isAuthenticated) {
      // User is logged in - go to main screen
      nextRoute = AppRoutes.main;
    } else {
      // User not logged in - check first-time flow
      if (isLanguageFirstTime) {
        // First time - show language selection
        nextRoute = AppRoutes.languageSelection;
      } else if (!isOnboardingCompleted) {
        // Language selected but onboarding not completed
        nextRoute = AppRoutes.onboarding;
      } else {
        // Everything completed - go to login
        nextRoute = AppRoutes.login;
      }
    }

    // طباعة معلومات التنقل
    _printNavigationInfo(nextRoute);

    if (mounted) {
      context.go(nextRoute);
    }
  }
  
  /// طباعة معلومات بداية التطبيق
  void _printSplashStartInfo() {
    final now = DateTime.now();
    final platformName = kIsWeb ? 'Web' : 'Mobile';
    final message = '🚀 SPLASH SCREEN STARTED - ${now.toIso8601String()} - Platform: $platformName';
    
    print('');
    print('🚀 ===== SPLASH SCREEN STARTED =====');
    print('📅 Start Time: ${now.toIso8601String()}');
    print('🌐 Platform: $platformName');
    print('📱 Screen: Splash Screen');
    print('🔄 Status: Initializing...');
    print('🚀 ================================');
    print('');
    
    // إضافة developer.log للتأكد من ظهور الرسائل في الكونسول
    developer.log(message, name: 'SPLASH_SCREEN');
  }
  
  /// تهيئة خدمة الإصدار وطباعة المعلومات
  Future<void> _initializeVersionService() async {
    _versionInitStartTime = DateTime.now();
    
    try {
      print('🔄 Initializing AppVersionService...');
      _logToJSConsole('🔄 Initializing AppVersionService...');
      developer.log('Starting AppVersionService initialization from Splash', name: 'SPLASH_VERSION_INIT');
      
      // تهيئة خدمة الإصدار
      await AppVersionService.instance.initialize();
      
      _versionInitEndTime = DateTime.now();
      
      // تحديث الإصدار المحلي
      if (mounted) {
        setState(() {
          _currentVersion = AppVersionService.instance.fullVersion;
          _versionLoaded = true;
        });
      }
      
      // طباعة معلومات الإصدار في JavaScript console
      _logToJSConsole('✅ Version Service Initialized Successfully!');
      _logToJSConsole('📦 App Version: ${AppVersionService.instance.version}');
      _logToJSConsole('🏗️  Build Number: ${AppVersionService.instance.buildNumber}');
      _logToJSConsole('📊 Full Version: ${AppVersionService.instance.fullVersion}');
      _logToJSConsole('📦 Version Source: ${AppVersionService.instance.versionSource}');
      
      // طباعة معلومات مفصلة عن الإصدار في Splash
      _printSplashVersionInfo();
      
      // التحقق من صحة الإصدار
      _validateVersion();
      
    } catch (e) {
      _versionInitEndTime = DateTime.now();
      
      print('❌ Error initializing version service in Splash: $e');
      developer.log('Version service initialization error in Splash: $e', name: 'SPLASH_VERSION_ERROR');
      
      // استخدام الإصدار الافتراضي في حالة الخطأ
      if (mounted) {
        setState(() {
          _currentVersion = '2.0.1+3'; // fallback من pubspec.yaml
          _versionLoaded = true;
        });
      }
    }
  }
  
  /// طباعة معلومات الإصدار في صفحة Splash
  void _printSplashVersionInfo() {
    final versionService = AppVersionService.instance;
    final now = DateTime.now();
    final initDuration = _versionInitEndTime != null && _versionInitStartTime != null
        ? _versionInitEndTime!.difference(_versionInitStartTime!)
        : null;
    
    print('');
    print('📱 ===== SPLASH VERSION INFO =====');
    print('⏰ Check Time: ${now.toIso8601String()}');
    print('⏳ Version Init Duration: ${initDuration?.inMilliseconds ?? 0}ms');
    print('📦 Version Source: ${versionService.versionSource}');
    print('✅ Service Initialized: ${versionService.isInitialized}');
    print('🔢 App Version: ${versionService.version}');
    print('🏗️  Build Number: ${versionService.buildNumber}');
    print('📊 Full Version: ${versionService.fullVersion}');
    print('📱 App Name: ${versionService.appName}');
    print('📋 Package Name: ${versionService.packageName}');
    print('🎯 Displayed Version: $_currentVersion');
    print('✅ Version Loaded: $_versionLoaded');
    print('❌ Service Error: ${versionService.initializationError ?? 'None'}');
    print('🔍 Version Match Check: ${versionService.fullVersion == '2.0.1+3' ? '✅ MATCHES' : '❌ MISMATCH'}');
    print('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    print('🔧 Build Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}');
    print('📱 ==============================');
    print('');
    
    // إضافة developer.log للتأكد من ظهور الرسائل في الكونسول
    final versionMessage = '''
SPLASH VERSION INFO:
- App Version: ${versionService.fullVersion}
- Source: ${versionService.versionSource}
- Displayed: $_currentVersion
- Init Duration: ${initDuration?.inMilliseconds ?? 0}ms
- Service Error: ${versionService.initializationError ?? 'None'}
- Version Match: ${versionService.fullVersion == '2.0.1+3' ? 'YES' : 'NO'}
- Platform: ${kIsWeb ? 'Web' : 'Mobile'}
- Build Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}
''';
    
    developer.log(versionMessage, name: 'SPLASH_VERSION');
    
    // رسائل منفصلة لكل معلومة مهمة
    developer.log('Splash App Version: ${versionService.fullVersion}', name: 'SPLASH_APP_VERSION');
    developer.log('Splash Version Source: ${versionService.versionSource}', name: 'SPLASH_VERSION_SOURCE');
    developer.log('Splash Displayed Version: $_currentVersion', name: 'SPLASH_DISPLAYED_VERSION');
    developer.log('Version Match Check: ${versionService.fullVersion == '2.0.1+3' ? 'MATCHES' : 'MISMATCH'}', name: 'VERSION_MATCH_CHECK');
    
    // طباعة في JavaScript console للويب
    _logToJSConsole('📱 VERSION INFO LOADED');
    _logToJSConsole('📊 Full Version: ${versionService.fullVersion}');
    _logToJSConsole('📦 Version Source: ${versionService.versionSource}');
    _logToJSConsole('⏳ Init Duration: ${initDuration?.inMilliseconds ?? 0}ms');
    _logToJSConsole('🔍 Version Match: ${versionService.fullVersion == '2.0.1+3' ? 'YES (✅)' : 'NO (❌)'}');
    _logToJSConsole('🌐 Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    _logToJSConsole('🔧 Build Mode: ${kDebugMode ? 'Debug' : kProfileMode ? 'Profile' : 'Release'}');
    
    // إضافة تحذير واضح إذا كان الإصدار لا يطابق المتوقع
    if (versionService.fullVersion != '2.0.1+3') {
      print('');
      print('⚠️  ===== VERSION MISMATCH WARNING =====');
      print('🎯 Expected: 2.0.1+3');
      print('📊 Actual: ${versionService.fullVersion}');
      print('📦 Source: ${versionService.versionSource}');
      print('🔧 This may indicate a caching or build issue');
      print('⚠️  ===================================');
      print('');
      
      developer.log('VERSION MISMATCH WARNING - Expected: 2.0.1+3, Actual: ${versionService.fullVersion}', name: 'VERSION_MISMATCH_WARNING');
      _logToJSConsole('⚠️  VERSION MISMATCH WARNING');
      _logToJSConsole('🎯 Expected: 2.0.1+3');
      _logToJSConsole('📊 Actual: ${versionService.fullVersion}');
    }
  }
  
  /// التحقق من صحة الإصدار
  void _validateVersion() {
    final versionService = AppVersionService.instance;
    final isValid = versionService.isVersionValid();
    
    print('');
    print('🔍 ===== VERSION VALIDATION =====');
    print('✅ Version Valid: $isValid');
    print('🎯 Expected: 2.0.1+3');
    print('📊 Actual: ${versionService.fullVersion}');
    print('📦 Source: ${versionService.versionSource}');
    
    if (versionService.fullVersion == '2.0.1+3') {
      print('✅ SUCCESS: Version matches expected value!');
      developer.log('SUCCESS: Version matches expected value (2.0.1+3)', name: 'VERSION_VALIDATION_SUCCESS');
    } else {
      print('⚠️  WARNING: Version does not match expected value!');
      developer.log('WARNING: Version mismatch - Expected: 2.0.1+3, Actual: ${versionService.fullVersion}', name: 'VERSION_VALIDATION_WARNING');
    }
    
    print('🔍 ============================');
    print('');
  }
  
  /// طباعة معلومات ما بعد التهيئة
  void _printPostInitializationInfo() {
    final now = DateTime.now();
    final totalDuration = _splashStartTime != null 
        ? now.difference(_splashStartTime!)
        : null;
    
    print('');
    print('📊 ===== POST-INITIALIZATION INFO =====');
    print('⏰ Current Time: ${now.toIso8601String()}');
    print('⏳ Total Splash Duration: ${totalDuration?.inMilliseconds ?? 0}ms');
    print('✅ Version Service Ready: ${AppVersionService.instance.isInitialized}');
    print('🎯 Final Version: $_currentVersion');
    print('📊 ================================');
    print('');
    
    developer.log('Post-initialization complete - Version: $_currentVersion', name: 'SPLASH_POST_INIT');
  }
  
  /// طباعة معلومات التنقل
  void _printNavigationInfo(String nextRoute) {
    final now = DateTime.now();
    final totalDuration = _splashStartTime != null 
        ? now.difference(_splashStartTime!)
        : null;
    
    print('');
    print('🧭 ===== NAVIGATION INFO =====');
    print('⏰ Navigation Time: ${now.toIso8601String()}');
    print('⏳ Total Splash Duration: ${totalDuration?.inMilliseconds ?? 0}ms');
    print('🎯 Next Route: $nextRoute');
    print('📊 Final Version: $_currentVersion');
    print('🧭 ========================');
    print('');
    
    developer.log('Navigating to: $nextRoute after ${totalDuration?.inMilliseconds ?? 0}ms', name: 'SPLASH_NAVIGATION');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// طباعة رسالة إلى JavaScript console (تظهر في الإنتاج)
  void _logToJSConsole(String message) {
    if (kIsWeb) {
      try {
        // استخدام طرق متعددة للتأكد من ظهور الرسائل
        js.context.callMethod('console.log', ['[FLUTTER] $message']);
        js.context.callMethod('console.info', ['[FLUTTER] $message']);
        js.context.callMethod('console.warn', ['[FLUTTER] $message']);
        
        // إضافة رسالة إلى DOM أيضاً
        js.context.callMethod('eval', ['''
          if (!window.flutterLogs) window.flutterLogs = [];
          window.flutterLogs.push("$message");
          console.log("[FLUTTER-DOM] $message");
        ''']);
      } catch (e) {
        print('Failed to log to JS console: $e');
        print(message);
      }
    } else {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // طباعة رسالة واضحة أن صفحة Splash تعمل
    developer.log('🎨 SPLASH SCREEN BUILD METHOD CALLED', name: 'SPLASH_BUILD');
    print('🎨 Splash Screen build method called - Version: $_currentVersion');
    
    final isRTL = ref.watch(isRTLProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacing
              const Spacer(flex: 2),

              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            AppImages.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Text section
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _textAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Conference title
                            Text(
                              'IDEC 2026',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              isRTL
                                  ? 'معرض ومؤتمر IDEC لطب الاسنان'
                                  : 'IDEC Dental Conference & Exhibition',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w300,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // Loading indicator
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom spacing
              const Spacer(flex: 1),

              // Version info
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        'الإصدار $_currentVersion',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
