import 'package:flutter/material.dart';

abstract final class AtlasPalette {
  static const canvas = Color(0xFFF5F6F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF0F2F5);
  static const border = Color(0xFFD9DDE5);
  static const text = Color(0xFF1B1F28);
  static const textMuted = Color(0xFF5F687A);
  static const accent = Color(0xFF3157D5);
  static const accentSoft = Color(0xFFE8EDFF);
  static const warning = Color(0xFF8A651D);
  static const warningSoft = Color(0xFFFFF7E1);
  static const success = Color(0xFF267A52);
}

ThemeData atlasTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AtlasPalette.accent,
    brightness: .light,
    surface: AtlasPalette.surface,
  );

  return ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: .symmetric(vertical: 10, horizontal: 12),
      filled: true,
      fillColor: AtlasPalette.surface,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AtlasPalette.border),
      ),
      border: OutlineInputBorder(),
    ),
    splashFactory: InkSparkle.splashFactory,
    colorScheme: scheme,
    dividerColor: AtlasPalette.border,
    focusColor: AtlasPalette.accentSoft,
    scaffoldBackgroundColor: AtlasPalette.canvas,
    textTheme: Typography.material2021().black.apply(
      displayColor: AtlasPalette.text,
      bodyColor: AtlasPalette.text,
    ),
  );
}
