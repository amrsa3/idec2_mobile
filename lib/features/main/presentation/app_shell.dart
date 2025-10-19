import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/enhanced_auth_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../services/navigation_service.dart';
import '../../notifications/presentation/widgets/verification_reminder_banner.dart';
import '../../profile/presentation/widgets/profile_avatar.dart';

/// Main app shell that wraps the entire application
/// Provides common UI elements like app bar, navigation, and global state
class AppShell extends ConsumerWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showAppBar;
  final bool showBottomNavigation;
  final PreferredSizeWidget? customAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  const AppShell({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showAppBar = true,
    this.showBottomNavigation = false,
    this.customAppBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isRTL = ref.watch(isRTLProvider);
    
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar ? (customAppBar ?? _buildAppBar(context, ref, l10n, authState)) : null,
      body: Column(
        children: [
          // Verification reminder banner
          if (authState.isAuthenticated && authState.user != null)
            const VerificationReminderBanner(),
          
          // Main content
          Expanded(child: child),
        ],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AuthState authState,
  ) {
    return AppBar(
      title: title != null ? Text(title!) : _buildAppTitle(l10n),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: _buildLeading(context),
      actions: actions ?? _buildDefaultActions(context, ref, authState),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitle(AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.medical_services,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            l10n.appTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    return null;
  }

  List<Widget> _buildDefaultActions(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) {
    final actions = <Widget>[];

    if (authState.isAuthenticated && authState.user != null) {
      // Notifications button
      actions.add(
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              // Notification badge (if there are unread notifications)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => NavigationService.instance.goToNotifications(),
        ),
      );

      // Profile avatar
      actions.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => NavigationService.instance.goToProfile(),
            child: ProfileAvatar(
              user: authState.user!,
              size: 32,
              showBorder: true,
              borderColor: Colors.white,
            ),
          ),
        ),
      );
    } else {
      // Connection status button for non-authenticated users
      actions.add(
        IconButton(
          icon: const Icon(Icons.wifi_outlined, color: Colors.white),
          onPressed: () => NavigationService.instance.goToConnectionStatus(),
        ),
      );
    }

    return actions;
  }
}

/// App shell with bottom navigation
class AppShellWithBottomNav extends ConsumerWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int>? onTabChanged;
  final String? title;
  final List<Widget>? actions;

  const AppShellWithBottomNav({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onTabChanged,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isRTL = ref.watch(isRTLProvider);

    return AppShell(
      title: title,
      actions: actions,
      child: child,
    );
  }
}

/// Branded app bar widget that can be used independently
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const BrandedAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return AppBar(
      title: title != null ? Text(title!) : _buildBrandedTitle(l10n),
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandedTitle(AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.medical_services,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            l10n.appTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Global app state provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

/// App state model
class AppState {
  final bool isLoading;
  final String? error;
  final bool isOnline;
  final Map<String, dynamic> globalData;

  const AppState({
    this.isLoading = false,
    this.error,
    this.isOnline = true,
    this.globalData = const {},
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    bool? isOnline,
    Map<String, dynamic>? globalData,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOnline: isOnline ?? this.isOnline,
      globalData: globalData ?? this.globalData,
    );
  }
}

/// App state notifier
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setOnlineStatus(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void setGlobalData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.globalData);
    newData[key] = value;
    state = state.copyWith(globalData: newData);
  }

  void removeGlobalData(String key) {
    final newData = Map<String, dynamic>.from(state.globalData);
    newData.remove(key);
    state = state.copyWith(globalData: newData);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const AppState();
  }
}
