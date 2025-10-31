import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/platform_storage_service.dart';

part 'theme_provider.g.dart';

/// Theme state management
class ThemeState {
  final ThemeMode themeMode;
  final bool isLoading;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isLoading = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme_mode';
  
  ThemeNotifier() : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      state = state.copyWith(isLoading: true);
      
      final storage = PlatformStorageService.instance;
      final themeString = await storage.getString(_themeKey);
      
      ThemeMode themeMode = ThemeMode.system;
      if (themeString != null) {
        switch (themeString) {
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          case 'system':
          default:
            themeMode = ThemeMode.system;
            break;
        }
      }
      
      state = state.copyWith(
        themeMode: themeMode,
        isLoading: false,
      );
    } catch (e) {
      print('❌ Error loading theme: $e');
      state = state.copyWith(
        themeMode: ThemeMode.system,
        isLoading: false,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      state = state.copyWith(themeMode: themeMode);
      
      final storage = PlatformStorageService.instance;
      String themeString;
      switch (themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
        default:
          themeString = 'system';
          break;
      }
      
      await storage.setString(_themeKey, themeString);
      print('✅ Theme saved: $themeString');
    } catch (e) {
      print('❌ Error saving theme: $e');
    }
  }

  void toggleTheme() {
    final currentMode = state.themeMode;
    ThemeMode newMode;
    
    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        break;
      case ThemeMode.system:
      default:
        newMode = ThemeMode.light;
        break;
    }
    
    setThemeMode(newMode);
  }
}

// Providers
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

@riverpod
ThemeMode currentThemeMode(CurrentThemeModeRef ref) {
  return ref.watch(themeProvider).themeMode;
}

@riverpod
bool isThemeLoading(IsThemeLoadingRef ref) {
  return ref.watch(themeProvider).isLoading;
}