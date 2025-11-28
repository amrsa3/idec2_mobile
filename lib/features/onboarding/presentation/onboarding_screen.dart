import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/language_provider.dart';
import '../../../services/language_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      icon: Icons.medical_services,
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_description_1',
      color: AppColors.primary,
      backgroundColor: AppColors.background,
    ),
    const OnboardingPage(
      icon: Icons.groups,
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_description_2',
      color: Colors.blue,
      backgroundColor: Colors.white,
    ),
    const OnboardingPage(
      icon: Icons.business_center,
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_description_3',
      color: Colors.green,
      backgroundColor: Colors.white,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _navigateToAuth() async {
    // Mark onboarding as completed
    await LanguageService.markOnboardingCompleted();
    
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  Future<void> _skipOnboarding() async {
    // Mark onboarding as completed even when skipped
    await LanguageService.markOnboardingCompleted();
    
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRTL = ref.watch(isRTLProvider);

    return Scaffold(
      backgroundColor: _pages[_currentPage].backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      AppImages.logo,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Skip button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        color:
                            _pages[_currentPage].backgroundColor == Colors.white
                                ? Colors.black54
                                : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageWidget(
                    page: page,
                    l10n: l10n,
                  );
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _PageIndicator(
                        isActive: index == _currentPage,
                        color: _pages[index].color,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Navigation buttons
                  Row(
                    children: [
                      // Previous button
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousPage,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                  color: _pages[_currentPage].backgroundColor ==
                                          Colors.white
                                      ? Colors.black26
                                      : AppColors.border),
                            ),
                            child: Text(
                              l10n.previous,
                              style: TextStyle(
                                color: _pages[_currentPage].backgroundColor ==
                                        Colors.white
                                    ? Colors.black54
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),

                      if (_currentPage > 0) const SizedBox(width: 16),

                      // Next/Get Started button
                      Expanded(
                        flex: _currentPage == 0 ? 1 : 1,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pages[_currentPage].color,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? l10n.getStarted
                                : l10n.next,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;
  final Color color;
  final Color backgroundColor;

  const OnboardingPage({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.color,
    required this.backgroundColor,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final AppLocalizations l10n;

  const _OnboardingPageWidget({
    required this.page,
    required this.l10n,
  });

  String _getLocalizedText(String key) {
    switch (key) {
      case 'onboarding_title_1':
        return l10n.onboardingTitle1;
      case 'onboarding_description_1':
        return l10n.onboardingDescription1;
      case 'onboarding_title_2':
        return l10n.onboardingTitle2;
      case 'onboarding_description_2':
        return l10n.onboardingDescription2;
      case 'onboarding_title_3':
        return l10n.onboardingTitle3;
      case 'onboarding_description_3':
        return l10n.onboardingDescription3;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine text colors based on background
    final isWhiteBackground = page.backgroundColor == Colors.white;
    final titleColor =
        isWhiteBackground ? Colors.black87 : AppColors.textPrimary;
    final descriptionColor =
        isWhiteBackground ? Colors.black54 : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            _getLocalizedText(page.titleKey),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            _getLocalizedText(page.descriptionKey),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: descriptionColor,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _PageIndicator({
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
