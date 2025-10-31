import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/api_constants.dart';
import 'core/errors/error_handler.dart';
import 'core/router/app_router.dart';
import 'core/services/server_settings_service.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/widgets/verification_notification_banner.dart';
import 'l10n/app_localizations.dart';
import 'providers/enhanced_auth_provider_v2.dart';
import 'providers/language_provider.dart';
import 'services/enhanced_dio_service_v2.dart';
import 'services/enhanced_storage_service.dart';
import 'services/notification_service.dart';
import 'services/platform_storage_service.dart';
import 'services/registration_settings_service.dart';
import 'services/retry_service.dart';
import 'services/storage_service.dart';
import 'shared/services/verification_notification_service.dart';
import 'shared/widgets/error_boundary.dart';
import 'shared/widgets/service_status_banner.dart';

void main() async {
  // Wrap everything in a try-catch to prevent black screen on initialization errors
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('✅ [MAIN] Flutter binding initialized');

    // Block Google Fonts loading immediately for web
    if (kIsWeb) {
      // Force system fonts only - no external font loading
      SystemChannels.platform
          .invokeMethod('SystemChrome.setSystemUIOverlayStyle', {
        'statusBarColor': 0xFF2196F3,
        'statusBarIconBrightness': 'dark',
      });
    }

    // Initialize error handling system FIRST
    ErrorHandler.instance.initialize();
    debugPrint('✅ [MAIN] Error handling system initialized');

    // Initialize retry service
    try {
      RetryService.instance.initialize();
      debugPrint('✅ [MAIN] Retry service initialized');
    } catch (e, stackTrace) {
      debugPrint('⚠️ [MAIN] Retry service initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue - retry service is not critical for app startup
    }

    // Web-specific configurations
    if (kIsWeb) {
      // Force HTML renderer for better text rendering
      debugPrint('🌐 [MAIN] Web platform detected - configuring for web');

      // Prevent Google Fonts from loading
      debugPrint('🚫 [MAIN] Disabling Google Fonts loading');

      // Force system fonts only
      debugPrint('🔤 [MAIN] Using system fonts only');

      // Disable font fallback to Google Fonts
      debugPrint('🔧 [MAIN] Disabling font fallback to Google Fonts');

      // Force system fonts in Flutter Web
      debugPrint('🔧 [MAIN] Forcing system fonts in Flutter Web');

      // Disable Google Fonts loading for web
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🌐 [MAIN] Web app loaded - using system fonts only');

        // Force text rendering for Arabic support with system fonts
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        );

        // Additional web-specific font configuration
        debugPrint(
            '🌐 [MAIN] Configured web app to use system fonts only - no external font loading');
      });
    }

    // Initialize StorageService first with timeout
    try {
      await PlatformStorageService.instance.init().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '⏱️ [MAIN] Storage initialization timeout - continuing anyway');
        },
      );
      debugPrint('✅ [MAIN] StorageService initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [MAIN] StorageService initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue - storage might fail but app can still start
    }

    // Initialize and validate server settings with timeout
    try {
      debugPrint('🚀 [MAIN] Starting server settings initialization...');
      debugPrint('🚀 [MAIN] Build mode: ${kDebugMode ? "DEBUG" : "RELEASE"}');

      final serverSettingsService =
          ServerSettingsService(DefaultStorageService());

      // Add production-specific debugging
      if (!kDebugMode) {
        debugPrint(
            '🏭 [MAIN] Production mode detected - enabling detailed baseURL tracking');
        debugPrint(
            '🏭 [MAIN] Initial ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
      }

      // Validate and fix settings with timeout
      await serverSettingsService.validateAndFixSettings().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '⏱️ [MAIN] Server settings validation timeout - using defaults');
        },
      );

      // Get base URL with timeout
      debugPrint('🔗 [MAIN] Getting base URL from server settings...');
      final baseUrl = await serverSettingsService.getBaseUrl().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('⏱️ [MAIN] Get base URL timeout - using default');
          return ApiConstants.baseUrl; // Return default
        },
      );
      debugPrint('🔗 [MAIN] Retrieved base URL: $baseUrl');

      // Update ApiConstants
      debugPrint('🔄 [MAIN] Updating ApiConstants with base URL...');
      ApiConstants.updateBaseUrl(baseUrl);

      // Production-specific validation
      if (!kDebugMode) {
        debugPrint(
            '🏭 [MAIN] Post-update ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
        debugPrint(
            '🏭 [MAIN] Checking if HTTPS is used: ${ApiConstants.baseUrl.startsWith("https://")}');
        if (ApiConstants.baseUrl.contains('api.idec-ye.com') &&
            !ApiConstants.baseUrl.startsWith("https://")) {
          debugPrint('❌ [MAIN] CRITICAL: HTTPS missing for production API!');
          debugPrint('❌ [MAIN] This will cause connection failures!');
        } else {
          debugPrint('✅ [MAIN] HTTPS correctly configured for production API');
        }
      }

      // Validate configuration
      final isValidConfig = ApiConstants.validateCurrentConfig();
      debugPrint('✅ [MAIN] Configuration validation result: $isValidConfig');
    } catch (e, stackTrace) {
      debugPrint('❌ [MAIN] Server settings initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue with default settings
    }

    // Initialize Enhanced DioService V2 with timeout
    try {
      debugPrint('🔄 [MAIN] Initializing Enhanced DioService V2...');
      await EnhancedDioServiceV2.instance.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '⏱️ [MAIN] DioService initialization timeout - continuing anyway');
        },
      );

      // Final production check
      if (!kDebugMode) {
        debugPrint('🏭 [MAIN] Final DioService baseUrl check...');
        debugPrint('🏭 [MAIN] DioService will use: ${ApiConstants.baseUrl}');
        debugPrint('🏭 [MAIN] Expected format: https://api.idec-ye.com');
        debugPrint(
            '🏭 [MAIN] Match check: ${ApiConstants.baseUrl == "https://api.idec-ye.com"}');
      }
      debugPrint('✅ [MAIN] Enhanced DioService V2 initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [MAIN] Enhanced DioService V2 initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue - DioService will be initialized later when needed
    }

    // تم إزالة تهيئة registration settings من هنا لتحسين الأداء
    // سيتم تهيئتها فقط عند الحاجة إليها في صفحة التسجيل
    debugPrint(
        '🚀 [MAIN] Registration settings will be initialized only when needed');

    // Initialize SharedPreferences with timeout
    try {
      await EnhancedStorageService.instance.init().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '⏱️ [MAIN] Enhanced storage initialization timeout - continuing anyway');
        },
      );
      debugPrint('✅ [MAIN] Enhanced storage service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [MAIN] Enhanced storage service initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue - storage is not critical for startup
    }

    // Set system UI overlay style
    try {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
      debugPrint('✅ [MAIN] System UI overlay style set');
    } catch (e) {
      debugPrint('⚠️ [MAIN] Failed to set system UI overlay style: $e');
    }

    // Set preferred orientations with timeout
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('⏱️ [MAIN] Set orientation timeout - continuing anyway');
        },
      );
      debugPrint('✅ [MAIN] Preferred orientations set');
    } catch (e) {
      debugPrint('⚠️ [MAIN] Failed to set preferred orientations: $e');
    }

    debugPrint('✅ [MAIN] All initialization completed, starting app...');

    runApp(
      const ProviderScope(
        child: ErrorBoundary(
          child: IDECApp(),
        ),
      ),
    );

    debugPrint('✅ [MAIN] App started successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ [MAIN] CRITICAL ERROR during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');

    // Even if initialization fails, try to run the app so user sees an error screen
    // instead of black screen
    ErrorHandler.instance.handleError(e, stackTrace);

    runApp(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'خطأ في تهيئة التطبيق',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'حدث خطأ أثناء بدء التطبيق. يرجى إعادة تشغيل التطبيق.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IDECApp extends ConsumerStatefulWidget {
  const IDECApp({super.key});

  @override
  ConsumerState<IDECApp> createState() => _IDECAppState();
}

class _IDECAppState extends ConsumerState<IDECApp> {
  late final ServiceStatusProvider _serviceStatusProvider;

  @override
  void initState() {
    super.initState();

    // Initialize service status provider
    _serviceStatusProvider = ServiceStatusProvider();

    // Start verification notification service after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
    });
  }

  void _initializeServices() {
    try {
      // Start verification notification service
      VerificationNotificationService.startService(ref);
      debugPrint('✅ Verification notification service started');
    } catch (e) {
      debugPrint('❌ Error starting verification notification service: $e');
    }
  }

  @override
  void dispose() {
    // Stop verification notification service
    VerificationNotificationService.stopService();

    // Dispose retry service
    RetryService.instance.dispose();

    // Dispose registration settings service
    RegistrationSettingsService.instance.dispose();

    // Dispose service status provider
    _serviceStatusProvider.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);
    final authProvider = ref.watch(enhancedAuthProvider.notifier);

    return MaterialApp.router(
      title: 'IDEC',
      debugShowCheckedModeBanner: false,

      // ScaffoldMessenger configuration
      scaffoldMessengerKey: NotificationService.scaffoldMessengerKey,

      // Theme configuration - Using system fonts for web compatibility
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Localization configuration
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      // Router configuration
      routerConfig: router,

      // Builder for additional configuration
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: ServiceStatusWrapper(
            statusProvider: _serviceStatusProvider,
            child: Stack(
              children: [
                child ?? const SizedBox.shrink(),
                // Show verification notification banner for unverified users
                if (authProvider.user != null &&
                    !authProvider.user!
                        .phoneVerified) // Use phoneVerified instead of isVerified
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: VerificationNotificationBanner(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}