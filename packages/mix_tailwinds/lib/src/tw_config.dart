import 'package:flutter/material.dart';

/// Runtime configuration for translating Tailwind-like tokens into Mix stylers.
class TwConfig {
  const TwConfig({
    required this.space,
    required this.radii,
    required this.borderWidths,
    required this.breakpoints,
    required this.fontSizes,
    required this.colors,
  });

  final Map<String, double> space;
  final Map<String, double> radii;
  final Map<String, double> borderWidths;
  final Map<String, double> breakpoints;
  final Map<String, double> fontSizes;
  final Map<String, Color> colors;

  double spaceOf(String key, {double fallback = 0}) => space[key] ?? fallback;

  double radiusOf(String key, {double fallback = 0}) => radii[key] ?? fallback;

  double borderWidthOf(String key, {double fallback = 1}) =>
      borderWidths[key] ?? fallback;

  double breakpointOf(String key, {double fallback = 0}) =>
      breakpoints[key] ?? fallback;

  double fontSizeOf(String key, {double fallback = 14}) =>
      fontSizes[key] ?? fallback;

  Color? colorOf(String key) => colors[key];

  static const TwConfig _standard = TwConfig(
    space: {
      '0': 0,
      'px': 1,
      '0.5': 2,
      '1': 4,
      '1.5': 6,
      '2': 8,
      '2.5': 10,
      '3': 12,
      '3.5': 14,
      '4': 16,
      '5': 20,
      '6': 24,
      '8': 32,
      '10': 40,
      '12': 48,
      '16': 64,
      '20': 80,
      '24': 96,
      '32': 128,
      '40': 160,
      '48': 192,
      '56': 224,
      '64': 256,
    },
    radii: {
      'none': 0,
      '': 4,
      'sm': 2,
      'md': 6,
      'lg': 8,
      'xl': 12,
      '2xl': 16,
      'full': 9999,
    },
    borderWidths: {
      '': 1,
      '2': 2,
      '4': 4,
      '8': 8,
    },
    breakpoints: {
      'sm': 640,
      'md': 768,
      'lg': 1024,
      'xl': 1280,
    },
    fontSizes: {
      'xs': 12,
      'sm': 14,
      'base': 16,
      'lg': 18,
      'xl': 20,
      '2xl': 24,
      '3xl': 30,
      '4xl': 36,
    },
    colors: {
      'blue-50': Color(0xFFEFF6FF),
      'blue-100': Color(0xFFDBEAFE),
      'blue-500': Color(0xFF3B82F6),
      'blue-600': Color(0xFF2563EB),
      'blue-700': Color(0xFF1D4ED8),
      'gray-100': Color(0xFFF3F4F6),
      'gray-200': Color(0xFFE5E7EB),
      'gray-500': Color(0xFF6B7280),
      'gray-700': Color(0xFF374151),
      'red-500': Color(0xFFEF4444),
      'red-600': Color(0xFFDC2626),
      'black': Colors.black,
      'white': Colors.white,
      'transparent': Colors.transparent,
    },
  );

  factory TwConfig.standard() => _standard;
}
