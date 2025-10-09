import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/errors/error_handler.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'l10n/app_localizations.dart';
import 'services/storage_service.dart';
import 'services/retry_service.dart';
import 'services/registration_settings_service.dart';
import 'shared/services/verification_notification_service.dart';
import 'shared/widgets/error_boundary.dart';
import 'shared/widgets/service_status_banner.dart';
import 'features/profile/presentation/widgets/verification_notification_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize error handling system
  ErrorHandler.instance.initialize();
  debugPrint('✅ Error handling system initialized');
  
  // Initialize retry service
  RetryService.instance.initialize();
  debugPrint('✅ Retry service initialized');
  
  // Initialize registration settings service (non-blocking)
  RegistrationSettingsService.instance.initialize().then((_) {
    debugPrint('✅ Registration settings service initialized');
  }).catchError((e) {
    debugPrint('⚠️ Registration settings service initialization failed: $e');
  });
  debugPrint('🚀 Registration settings service initialization started (non-blocking)');
  
  // Web-specific configuration
  if (kIsWeb) {
    // Force HTML renderer for better text support
    debugPrint('Running on web - using HTML renderer for text');
    // Ensure text is visible immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Web app loaded - text should be visible');
    });
  }
  
  // Initialize StorageService first
  await StorageService.instance.init();
  debugPrint('✅ StorageService initialized successfully');
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
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
    final authState = ref.watch(authProvider);
    
    return MaterialApp.router(
      title: 'IDEC',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
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
                if (authState.user != null && !authState.user!.isVerified)
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
