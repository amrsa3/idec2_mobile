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
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize error handling system
  ErrorHandler.instance.initialize();
  debugPrint('✅ Error handling system initialized');

  // Initialize retry service
  RetryService.instance.initialize();
  debugPrint('✅ Retry service initialized');

  // Web-specific configurations
  if (kIsWeb) {
    // Force HTML renderer for better text rendering
    debugPrint('🌐 Web platform detected - configuring for web');

    // Prevent Google Fonts from loading
    debugPrint('🚫 Disabling Google Fonts loading');

    // Force system fonts only
    debugPrint('🔤 Using system fonts only');

    // Disable font fallback to Google Fonts
    debugPrint('🔧 Disabling font fallback to Google Fonts');

    // Force system fonts in Flutter Web
    debugPrint('🔧 Forcing system fonts in Flutter Web');

    // Disable Google Fonts loading for web
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Web app loaded - using system fonts only');

      // Force text rendering for Arabic support with system fonts
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      );

      // Additional web-specific font configuration
      debugPrint(
          'Configured web app to use system fonts only - no external font loading');
    });
  }

  // Initialize StorageService first
  await PlatformStorageService.instance.init();
  debugPrint('✅ StorageService initialized successfully');

  // Initialize and validate server settings
  // Initialize server settings with enhanced production debugging
  debugPrint('🚀 [MAIN] Starting server settings initialization...');
  debugPrint('🚀 [MAIN] Build mode: ${kDebugMode ? "DEBUG" : "RELEASE"}');

  final serverSettingsService = ServerSettingsService(DefaultStorageService());

  // Add production-specific debugging
  if (!kDebugMode) {
    debugPrint(
        '🏭 [PRODUCTION] Production mode detected - enabling detailed baseURL tracking');
    debugPrint(
        '🏭 [PRODUCTION] Initial ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
  }

  // Validate and fix settings
  debugPrint('🔧 [MAIN] Validating and fixing server settings...');
  await serverSettingsService.validateAndFixSettings();

  // Get base URL
  debugPrint('🔗 [MAIN] Getting base URL from server settings...');
  final baseUrl = await serverSettingsService.getBaseUrl();
  debugPrint('🔗 [MAIN] Retrieved base URL: $baseUrl');

  // Update ApiConstants
  debugPrint('🔄 [MAIN] Updating ApiConstants with base URL...');
  ApiConstants.updateBaseUrl(baseUrl);

  // Production-specific validation
  if (!kDebugMode) {
    debugPrint(
        '🏭 [PRODUCTION] Post-update ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
    debugPrint(
        '🏭 [PRODUCTION] Checking if HTTPS is used: ${ApiConstants.baseUrl.startsWith("https://")}');
    if (ApiConstants.baseUrl.contains('api.idec-ye.com') &&
        !ApiConstants.baseUrl.startsWith("https://")) {
      debugPrint('❌ [PRODUCTION] CRITICAL: HTTPS missing for production API!');
      debugPrint('❌ [PRODUCTION] This will cause connection failures!');
    } else {
      debugPrint(
          '✅ [PRODUCTION] HTTPS correctly configured for production API');
    }
  }

  // Validate configuration
  final isValidConfig = ApiConstants.validateCurrentConfig();
  debugPrint('✅ [MAIN] Configuration validation result: $isValidConfig');

  // Initialize Enhanced DioService V2
  debugPrint('🔄 [MAIN] Initializing Enhanced DioService V2...');
  await EnhancedDioServiceV2.instance.initialize();

  // Final production check
  if (!kDebugMode) {
    debugPrint('🏭 [PRODUCTION] Final DioService baseUrl check...');
    debugPrint('🏭 [PRODUCTION] DioService will use: ${ApiConstants.baseUrl}');
    debugPrint('🏭 [PRODUCTION] Expected format: https://api.idec-ye.com');
    debugPrint(
        '🏭 [PRODUCTION] Match check: ${ApiConstants.baseUrl == "https://api.idec-ye.com"}');
  }
  debugPrint('🔍 ApiConstants validation result: $isValidConfig');

  // Enhanced DioService V2 is already initialized with new settings
  debugPrint('✅ Enhanced DioService V2 initialized with new server settings');

  // تم إزالة تهيئة registration settings من هنا لتحسين الأداء
  // سيتم تهيئتها فقط عند الحاجة إليها في صفحة التسجيل
  debugPrint('🚀 Registration settings will be initialized only when needed');

  // Initialize SharedPreferences
  // Initialize enhanced storage service
  await EnhancedStorageService.instance.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: ErrorBoundary(
        child: IDECApp(),
      ),
    ),
  );
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
