import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    // Listen for system brightness changes
    PlatformDispatcher.instance.onPlatformBrightnessChanged =
        _onPlatformBrightnessChanged;
  }

  /// Change the theme mode
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Handle system brightness changes
  void _onPlatformBrightnessChanged() {
    if (state == ThemeMode.system) {
      // Trigger UI rebuild on system theme changes
      state = ThemeMode.system;
    }
  }

  @override
  void dispose() {
    // Remove the system brightness listener
    PlatformDispatcher.instance.onPlatformBrightnessChanged = null;
    super.dispose();
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
