import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/language_provider.dart';
import '../../../core/auth/auth.dart';
import '../../../services/language_service.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(Locale locale) async {
    setState(() {
      _selectedLocale = locale;
    });

    // Save language preference
    await ref.read(languageProvider.notifier).changeLanguage(locale);

    // Mark language selection as completed
    await LanguageService.markLanguageSelectionCompleted();

    // Navigate to next screen after a short delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if user is authenticated
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      context.go(AppRoutes.main);
    } else {
      // Always go to onboarding after language selection for first-time users
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageState = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              context.colors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Top spacing
                        const SizedBox(height: 20),

                        // Logo section
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: context.colors.card,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.shadow,
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            AppImages.logo,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Choose Your Language',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        // Subtitle
                        Text(
                          'اختر لغتك المفضلة',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Language options
                        Expanded(
                          child: Column(
                            children: [
                              // English option
                              _LanguageOption(
                                locale: const Locale('en'),
                                title: 'English',
                                subtitle:
                                    'IDEC Dental Conference & Exhibition 2026',
                                flag: '🇺🇸',
                                isSelected:
                                    _selectedLocale == const Locale('en'),
                                isLoading: languageState.isLoading &&
                                    _selectedLocale == const Locale('en'),
                                onTap: () =>
                                    _selectLanguage(const Locale('en')),
                              ),

                              const SizedBox(height: 16),

                              // Arabic option
                              _LanguageOption(
                                locale: const Locale('ar'),
                                title: 'العربية',
                                subtitle: 'معرض ومؤتمر IDEC لطب الاسنان 2026',
                                flag:
                                    '🇾🇪', // Yemeni flag instead of Saudi flag
                                isSelected:
                                    _selectedLocale == const Locale('ar'),
                                isLoading: languageState.isLoading &&
                                    _selectedLocale == const Locale('ar'),
                                onTap: () =>
                                    _selectLanguage(const Locale('ar')),
                              ),

                              // Flexible spacing
                              const Spacer(),
                            ],
                          ),
                        ),

                        // Bottom spacing
                        const SizedBox(height: 16),

                        // Skip button (if user is already authenticated)
                        if (ref.watch(isAuthenticatedProvider))
                          TextButton(
                            onPressed: () {
                              context.go(AppRoutes.main);
                            },
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final Locale locale;
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : context.colors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : context.colors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadow,
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : context.colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Loading or check icon
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                else if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.border),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
