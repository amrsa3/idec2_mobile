import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import '../../services/compatible_auth_service.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../features/profile/presentation/screens/profile_edit_screen.dart';

/// إشعار التوثيق - يظهر عندما يكون الحساب غير موثق
class VerificationNotificationBanner extends ConsumerWidget {
  const VerificationNotificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(compatibleAuthProvider);
    
    // استخراج المستخدم من auth state
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;

    debugPrint('🔍 [VERIFICATION_BANNER] Building banner - isAuthenticated: $isAuthenticated, user: ${user?.phone}');

    // إذا لم يكن المستخدم مسجل دخول، لا نعرض الإشعار
    if (!isAuthenticated || user == null) {
      debugPrint('⚠️ [VERIFICATION_BANNER] User not authenticated, hiding banner');
      return const SizedBox.shrink();
    }

    // محاولة الحصول على حالة التوثيق من مصدرين:
    // 1. من user.profile.status مباشرة (أسرع)
    // 2. من profileProvider (أكثر دقة)
    
    bool isUnverified = false;
    ProfileModel? profileForNavigation;
    
    // محاولة 1: من user.profile.status مباشرة
    if (user!.profile != null) {
      final status = user!.profile!.status;
      debugPrint('🔍 [VERIFICATION_BANNER] User profile exists, status: $status');
      
      if (status != null) {
        final statusUpper = status.toUpperCase();
        debugPrint('🔍 [VERIFICATION_BANNER] Status (uppercase): $statusUpper');
        
        // التحقق من الحالة - نعرض الإشعار إذا كان unverified أو rejected
        isUnverified = statusUpper == 'UNVERIFIED' || statusUpper == 'REJECTED';
        
        if (isUnverified) {
          debugPrint('✅ [VERIFICATION_BANNER] User is unverified based on user.profile.status: $status');
        } else {
          debugPrint('ℹ️ [VERIFICATION_BANNER] User status is: $status (not unverified)');
        }
      } else {
        debugPrint('⚠️ [VERIFICATION_BANNER] User profile exists but status is null');
      }
    } else {
      debugPrint('⚠️ [VERIFICATION_BANNER] User profile is null');
    }
    
    // محاولة 2: من profileProvider (أكثر دقة وموثوقية)
    final profileState = ref.watch(profileProvider);
    debugPrint('🔍 [VERIFICATION_BANNER] Profile state - isLoading: ${profileState.isLoading}, currentProfile: ${profileState.currentProfile != null}');
    
    // إذا كان profileProvider محملاً، استخدمه
    if (profileState.currentProfile != null) {
      final profile = profileState.currentProfile!;
      profileForNavigation = profile;
      
      final profileStatus = profile.verificationStatus;
      debugPrint('🔍 [VERIFICATION_BANNER] Profile status from provider: $profileStatus');
      
      isUnverified = profileStatus == VerificationStatus.unverified ||
                    profileStatus == VerificationStatus.rejected;
      
      if (isUnverified) {
        debugPrint('✅ [VERIFICATION_BANNER] User is unverified based on profileProvider: $profileStatus');
      } else {
        debugPrint('ℹ️ [VERIFICATION_BANNER] Profile status is: $profileStatus (not unverified)');
      }
    } else if (!profileState.isLoading && isAuthenticated) {
      // إذا لم يكن محملاً ولم يكن قيد التحميل، حاول تحميله
      debugPrint('🔄 [VERIFICATION_BANNER] Profile not loaded, attempting to load...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileProvider.notifier).loadCurrentProfile();
      });
    }
    
    // إذا لم نجد حالة توثيق واضحة، لا نعرض الإشعار
    if (!isUnverified) {
      debugPrint('ℹ️ [VERIFICATION_BANNER] User is verified or status unknown, hiding banner');
      debugPrint('🔍 [VERIFICATION_BANNER] Final check - isUnverified: $isUnverified, profileForNavigation: ${profileForNavigation != null}');
      return const SizedBox.shrink();
    }

    debugPrint('✅ [VERIFICATION_BANNER] Showing verification banner - user is unverified');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
        color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
                  boxShadow: [
                    BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
          onTap: () async {
            // الانتقال إلى صفحة تعديل البيانات الشخصية
            // إذا لم يكن لدينا profile محملاً، نحاول تحميله أولاً
            ProfileModel? profileToEdit = profileForNavigation;
            
            if (profileToEdit == null) {
              // محاولة تحميل profile
              final profileState = ref.read(profileProvider);
              profileToEdit = profileState.currentProfile;
              
              if (profileToEdit == null) {
                // إذا لم يكن محملاً، نحاول تحميله
                await ref.read(profileProvider.notifier).loadCurrentProfile();
                final updatedState = ref.read(profileProvider);
                profileToEdit = updatedState.currentProfile;
              }
            }
            
            if (profileToEdit != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(profile: profileToEdit!),
                ),
              );
            } else if (context.mounted) {
              // إذا لم نتمكن من تحميل profile، ننتقل إلى صفحة الملف الشخصي
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري تحميل بيانات الملف الشخصي...'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                // أيقونة المعلومات
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                // النص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                      Text(
                        'يجب توثيق الحساب',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                        'للاشتراك بالمؤتمر والفعاليات',
                                  style: TextStyle(
                                    fontSize: 12,
                          color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                // سهم التنقل
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue.shade700,
                  size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
