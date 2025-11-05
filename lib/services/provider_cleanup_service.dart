import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/providers/profile_provider.dart';
import '../features/profile/providers/smart_file_provider.dart' as smart_file_provider;

/// خدمة مركزية لمسح وإلغاء تفعيل جميع Providers عند logout
class ProviderCleanupService {
  static final ProviderCleanupService _instance = ProviderCleanupService._internal();
  factory ProviderCleanupService() => _instance;
  ProviderCleanupService._internal();

  /// إلغاء تفعيل جميع providers المتعلقة بالمستخدم
  /// يجب استدعاؤها عند تسجيل الخروج
  /// 
  /// Note: يمكن استخدام ProviderContainer بدلاً من WidgetRef إذا لم يكن WidgetRef متاحاً
  Future<void> invalidateAllUserProviders(dynamic ref) async {
    try {
      debugPrint('🔄 [PROVIDER_CLEANUP] Starting provider invalidation...');

      // إلغاء تفعيل profile-related providers
      debugPrint('🔄 [PROVIDER_CLEANUP] Invalidating profileProvider...');
      ref.invalidate(profileProvider);
      
      // إلغاء تفعيل userDocumentsProvider بشكل صريح
      debugPrint('🔄 [PROVIDER_CLEANUP] Invalidating userDocumentsProvider...');
      ref.invalidate(smart_file_provider.userDocumentsProvider);
      
      // إلغاء تفعيل جميع الـ providers التي تعتمد على profileProvider
      // Note: currentProfileProvider, requiredDocumentsProvider, 
      // و verificationRulesProvider تعتمد جميعها على profileProvider
      // لذا سيتم إلغاء تفعيلها تلقائياً عند إلغاء تفعيل profileProvider
      debugPrint('🔄 [PROVIDER_CLEANUP] Profile-dependent providers will be auto-invalidated');

      debugPrint('✅ [PROVIDER_CLEANUP] All user providers invalidated successfully');
    } catch (e) {
      debugPrint('❌ [PROVIDER_CLEANUP] Error during provider invalidation: $e');
      // لا نرمي الخطأ لأن هذا قد يمنع تسجيل الخروج
    }
  }

  /// إلغاء تفعيل جميع providers المتعلقة بالملف الشخصي
  Future<void> invalidateProfileProviders(dynamic ref) async {
    try {
      debugPrint('🔄 [PROVIDER_CLEANUP] Invalidating profile-related providers...');
      
      ref.invalidate(profileProvider);
      
      debugPrint('✅ [PROVIDER_CLEANUP] Profile providers invalidated successfully');
    } catch (e) {
      debugPrint('❌ [PROVIDER_CLEANUP] Error invalidating profile providers: $e');
    }
  }

  /// إعادة تحميل جميع providers بعد تسجيل الدخول
  Future<void> refreshAllUserProviders(dynamic ref) async {
    try {
      debugPrint('🔄 [PROVIDER_CLEANUP] Refreshing all user providers...');
      
      // إعادة تحميل profileProvider
      ref.invalidate(profileProvider);
      
      // تحميل profile جديد
      await ref.read(profileProvider.notifier).loadCurrentProfile();
      
      debugPrint('✅ [PROVIDER_CLEANUP] All user providers refreshed successfully');
    } catch (e) {
      debugPrint('❌ [PROVIDER_CLEANUP] Error refreshing user providers: $e');
    }
  }
}

