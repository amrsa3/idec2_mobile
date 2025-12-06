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
import '../../providers/enhanced_auth_provider_v2.dart';
import '../../shared/widgets/notification_badge.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authNotifier = ref.watch(enhancedAuthProvider.notifier);
    final user = authNotifier.user;
    final isAuthenticated = user != null;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(context, l10n, user, isAuthenticated),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context, Icons.home_outlined, l10n.home, () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).state = 0;
                }),
                _buildDrawerItem(
                    context, Icons.schedule_outlined, l10n.schedule, () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).state = 1;
                }),
                _buildDrawerItem(context, Icons.people_outline, l10n.speakers,
                    () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).state = 2;
                }),
                _buildDrawerItem(context, Icons.store_outlined, l10n.exhibition,
                    () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).state = 3;
                }),
                _buildDrawerItem(
                    context, Icons.photo_library_outlined, 'معرض الصور', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryScreen(),
                    ),
                  );
                }),
                _buildDrawerItem(
                    context, Icons.notifications_outlined, l10n.notifications,
                    () {
                  Navigator.pop(context);
                  context.push(AppRoutes.notifications);
                }, showBadge: true),
                const Divider(),
                _buildDrawerItem(
                    context, Icons.settings_outlined, l10n.settings, () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
          if (isAuthenticated) _buildLogoutButton(context, ref, l10n),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AppLocalizations l10n,
      dynamic user, bool isAuthenticated) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(AppImages.logo, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.welcome,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (isAuthenticated && user != null) ...[
            const SizedBox(height: 8),
            Text(
              user.phone ?? '',
              style:
                  TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap, {bool showBadge = false}) {
    return ListTile(
      leading: showBadge
          ? NotificationBadge(
              badgeColor: Colors.red,
              child: Icon(icon, color: AppColors.primary, size: 28),
            )
          : Icon(icon, color: AppColors.primary, size: 28),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.confirmLogout),
              content: Text(l10n.logoutConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.logoutButton),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            Navigator.pop(context);
            ref.read(enhancedAuthProvider.notifier).logout();
          }
        },
        icon: const Icon(Icons.logout_outlined),
        label: Text(l10n.logout),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
