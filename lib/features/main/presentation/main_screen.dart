import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/courses/presentation/courses_screen.dart';
import '../../../features/profile/presentation/screens/profile_main_screen.dart';
import '../../../features/schedule/presentation/schedule_screen.dart';
import '../../../features/speakers/presentation/speakers_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/back_button_service.dart';
import '../../home/presentation/home_screen_new.dart';

// Provider for bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // List of screens
    final screens = const [
      HomeScreen(),
      ScheduleScreen(),
      SpeakersScreen(),
      CoursesScreen(),
      ProfileMainScreen(),
    ];

    return BackButtonHandler(
      showExitDialog: true,
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(bottomNavIndexProvider.notifier).state = index;
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.schedule_outlined),
                activeIcon: const Icon(Icons.schedule),
                label: l10n.schedule,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline),
                activeIcon: const Icon(Icons.people),
                label: l10n.speakers,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.school_outlined),
                activeIcon: const Icon(Icons.school),
                label: 'الدورات',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: l10n.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
