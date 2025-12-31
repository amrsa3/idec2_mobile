import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/gallery/presentation/gallery_screen.dart';
import '../../features/main/providers/bottom_navigation_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/auth/auth.dart';
import '../../shared/widgets/notification_badge.dart';
import '../../features/exhibition/presentation/exhibition_screen.dart';
import '../../features/market/presentation/market_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/screens/user_documents_viewer_screen.dart';
import '../../providers/language_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;
    final isRTL = ref.watch(isRTLProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(context, l10n, user, isAuthenticated, isDark, isRTL),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: l10n.home,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(bottomNavIndexProvider.notifier).state = 0;
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.schedule_outlined,
                  title: l10n.schedule,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_outline,
                  title: l10n.speakers,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(bottomNavIndexProvider.notifier).state = 3;
                  },
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    isRTL ? 'المعرض والمتجر' : 'Exhibition & Store',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.storefront_outlined,
                  title: isRTL ? 'المعرض التجاري' : 'Exhibition',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ExhibitionScreen()));
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: isRTL ? 'المتجر الإلكتروني' : 'Online Store',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen()));
                  },
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    isRTL ? 'الوسائط' : 'Media',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.photo_library_outlined,
                  title: isRTL ? 'معرض الصور' : 'Photo Gallery',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GalleryScreen()),
                    );
                  },
                ),
                
                if (isAuthenticated) ...[
                  _buildDrawerItem(
                    context,
                    icon: Icons.folder_shared_outlined,
                    title: isRTL ? 'مستنداتي' : 'My Documents',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const UserDocumentsViewerScreen()));
                    },
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                  ),
                  
                  _buildDrawerItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: isRTL ? 'المحادثات' : 'Chat',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.chat);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    isDark: isDark,
                    showBadge: true,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.notifications);
                    },
                  ),
                ],
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                ),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
          if (isAuthenticated) _buildLogoutButton(context, ref, l10n, isDark),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    AppLocalizations l10n,
    dynamic user,
    bool isAuthenticated,
    bool isDark,
    bool isRTL,
  ) {
    final profilePhotoUrl = user?.profile?.profilePhotoUrl;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar or Logo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: isAuthenticated && profilePhotoUrl != null
                      ? Image.network(
                          profilePhotoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(AppImages.logo, fit: BoxFit.contain),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(AppImages.logo, fit: BoxFit.contain),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthenticated
                          ? (isRTL
                              ? user?.profile?.fullNameAr ?? l10n.welcome
                              : user?.profile?.fullNameEn ?? user?.profile?.fullNameAr ?? l10n.welcome)
                          : l10n.welcome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isAuthenticated && user?.email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.email!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!isAuthenticated) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.login);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.login),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.register);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.register),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDark = false,
    bool showBadge = false,
  }) {
    return ListTile(
      leading: showBadge
          ? NotificationBadge(
              badgeColor: Colors.red,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: isDark ? Colors.grey[600] : Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: AppColors.primary.withOpacity(0.05),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text(l10n.confirmLogout),
                content: Text(l10n.logoutConfirmation),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(l10n.logoutButton),
                  ),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            }
          },
          icon: const Icon(Icons.logout_outlined, size: 20),
          label: Text(l10n.logout, style: const TextStyle(fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
