/// Cross-platform web utilities
/// Automatically selects the correct implementation based on platform
/// 
/// Usage:
/// ```dart
/// import 'package:idec_conference_app/services/web_utils.dart';
/// 
/// // Clear storage
/// clearBrowserStorage();
/// 
/// // Check platform
/// if (isWebPlatform) {
///   // Web-specific code
/// }
/// ```

export 'web_utils_stub.dart'
    if (dart.library.html) 'web_utils_web.dart';
