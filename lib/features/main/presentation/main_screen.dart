import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/courses/presentation/courses_screen.dart';
import '../../../features/main/widgets/app_bottom_navigation_bar.dart';
import '../../../features/news/presentation/screens/news_list_screen.dart';
import '../../../features/profile/presentation/screens/profile_main_screen.dart';
import '../../../features/sessions/presentation/sessions_screen.dart';
import '../../../features/speakers/presentation/speakers_screen.dart';
import '../../../services/back_button_service.dart';
import '../../home/presentation/home_screen.dart';
import '../providers/bottom_navigation_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // List of screens
    const screens = [
      HomeScreen(),
      NewsListScreen(),
      SessionsScreen(),
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
        bottomNavigationBar: const AppBottomNavigationBar(),
      ),
    );
  }
}
