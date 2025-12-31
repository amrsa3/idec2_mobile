import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/app_constants.dart';
import '../services/language_service.dart';

part 'language_provider.g.dart';

// Language State
class LanguageState {
  final Locale locale;
  final bool isLoading;
  final String? error;

  const LanguageState({
    required this.locale,
    this.isLoading = false,
    this.error,
  });

  LanguageState copyWith({
    Locale? locale,
    bool? isLoading,
    String? error,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Language Notifier
class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier()
      : super(const LanguageState(locale: AppConstants.defaultLocale)) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final locale = await LanguageService.getSavedLanguage();
      state = state.copyWith(locale: locale, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        locale: AppConstants.defaultLocale,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await LanguageService.saveLanguage(locale);
      state = state.copyWith(locale: locale, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  TextDirection get textDirection =>
      LanguageService.getTextDirection(state.locale);
  bool get isRTL => LanguageService.isRTL(state.locale);
}

// Providers
final languageProvider =
    StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});

@riverpod
Locale currentLocale(CurrentLocaleRef ref) {
  return ref.watch(languageProvider).locale;
}

@riverpod
TextDirection textDirection(TextDirectionRef ref) {
  final locale = ref.watch(currentLocaleProvider);
  return LanguageService.getTextDirection(locale);
}

@riverpod
bool isRTL(IsRTLRef ref) {
  final locale = ref.watch(currentLocaleProvider);
  return LanguageService.isRTL(locale);
}
