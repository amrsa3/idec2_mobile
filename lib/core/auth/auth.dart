/// نظام المصادقة الموحد
/// 
/// هذا الملف هو نقطة الدخول الرئيسية لنظام المصادقة الموحد.
/// 
/// الاستخدام:
/// ```dart
/// import 'package:idec_conference_app/core/auth/auth.dart';
/// 
/// // في Widget
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final isAuth = ref.watch(isAuthenticatedProvider);
///     final user = ref.watch(currentUserProvider);
///     
///     if (!isAuth) {
///       return LoginScreen();
///     }
///     
///     return Text('مرحباً ${user?.fullName}');
///   }
/// }
/// ```

// Core exports
export 'auth_state.dart';
export 'auth_exceptions.dart';
export 'auth_service.dart';
export 'auth_provider.dart';
export 'auth_repository.dart';
export 'token_manager.dart';
export 'session_manager.dart';

// Compatibility layer (for gradual migration)
export 'auth_compat.dart';
