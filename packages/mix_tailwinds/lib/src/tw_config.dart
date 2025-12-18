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
    required this.durations,
    required this.delays,
    required this.scales,
    required this.rotations,
  });

  final Map<String, double> space;
  final Map<String, double> radii;
  final Map<String, double> borderWidths;
  final Map<String, double> breakpoints;
  final Map<String, double> fontSizes;
  final Map<String, Color> colors;
  final Map<String, int> durations;
  final Map<String, int> delays;
  final Map<String, double> scales;
  final Map<String, double> rotations;

  double spaceOf(String key, {double fallback = 0}) => space[key] ?? fallback;

  double radiusOf(String key, {double fallback = 0}) => radii[key] ?? fallback;

  double borderWidthOf(String key, {double fallback = 1}) =>
      borderWidths[key] ?? fallback;

  double breakpointOf(String key, {double fallback = 0}) =>
      breakpoints[key] ?? fallback;

  double fontSizeOf(String key, {double fallback = 14}) =>
      fontSizes[key] ?? fallback;

  Color? colorOf(String key) {
    // Handle opacity modifiers like 'white/10', 'purple-500/30'
    final slashIndex = key.indexOf('/');
    if (slashIndex > 0) {
      final colorKey = key.substring(0, slashIndex);
      final opacityStr = key.substring(slashIndex + 1);
      final opacity = int.tryParse(opacityStr);
      final baseColor = colors[colorKey];
      if (baseColor != null && opacity != null && opacity >= 0 && opacity <= 100) {
        // Convert percentage (0-100) to alpha (0-255)
        final alpha = (opacity * 255 / 100).round();
        return baseColor.withAlpha(alpha);
      }
    }
    return colors[key];
  }

  int? durationOf(String key) => durations[key];

  int? delayOf(String key) => delays[key];

  double? scaleOf(String key) => scales[key];

  double? rotationOf(String key) => rotations[key];

  /// Creates a copy of this config with the given fields replaced.
  ///
  /// Use this to customize the default config:
  /// ```dart
  /// final customConfig = TwConfig.standard().copyWith(
  ///   colors: {
  ///     ...TwConfig.standard().colors,
  ///     'brand-500': myBrandColor,
  ///   },
  /// );
  /// ```
  TwConfig copyWith({
    Map<String, double>? space,
    Map<String, double>? radii,
    Map<String, double>? borderWidths,
    Map<String, double>? breakpoints,
    Map<String, double>? fontSizes,
    Map<String, Color>? colors,
    Map<String, int>? durations,
    Map<String, int>? delays,
    Map<String, double>? scales,
    Map<String, double>? rotations,
  }) {
    return TwConfig(
      space: space ?? this.space,
      radii: radii ?? this.radii,
      borderWidths: borderWidths ?? this.borderWidths,
      breakpoints: breakpoints ?? this.breakpoints,
      fontSizes: fontSizes ?? this.fontSizes,
      colors: colors ?? this.colors,
      durations: durations ?? this.durations,
      delays: delays ?? this.delays,
      scales: scales ?? this.scales,
      rotations: rotations ?? this.rotations,
    );
  }

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
    borderWidths: {'0': 0, '': 1, '2': 2, '4': 4, '8': 8},
    breakpoints: {'sm': 640, 'md': 768, 'lg': 1024, 'xl': 1280, '2xl': 1536},
    fontSizes: {
      'xs': 12,
      'sm': 14,
      'base': 16,
      'lg': 18,
      'xl': 20,
      '2xl': 24,
      '3xl': 30,
      '4xl': 36,
      '5xl': 48,
      '6xl': 60,
      '7xl': 72,
      '8xl': 96,
      '9xl': 128,
    },
    colors: {
      // Slate
      'slate-300': Color(0xFFCBD5E1),
      'slate-600': Color(0xFF475569),
      'slate-700': Color(0xFF334155),
      'slate-800': Color(0xFF1E293B),
      'slate-900': Color(0xFF0F172A),
      // Gray
      'gray-100': Color(0xFFF3F4F6),
      'gray-200': Color(0xFFE5E7EB),
      'gray-500': Color(0xFF6B7280),
      'gray-700': Color(0xFF374151),
      // Blue
      'blue-50': Color(0xFFEFF6FF),
      'blue-100': Color(0xFFDBEAFE),
      'blue-500': Color(0xFF3B82F6),
      'blue-600': Color(0xFF2563EB),
      'blue-700': Color(0xFF1D4ED8),
      // Purple
      'purple-200': Color(0xFFE9D5FF),
      'purple-400': Color(0xFFC084FC),
      'purple-500': Color(0xFFA855F7),
      'purple-600': Color(0xFF9333EA),
      'purple-700': Color(0xFF7C3AED),
      'purple-900': Color(0xFF581C87),
      // Pink
      'pink-400': Color(0xFFF472B6),
      'pink-500': Color(0xFFEC4899),
      // Red
      'red-500': Color(0xFFEF4444),
      'red-600': Color(0xFFDC2626),
      // Amber
      'amber-300': Color(0xFFFCD34D),
      // Emerald
      'emerald-400': Color(0xFF34D399),
      // Base
      'black': Colors.black,
      'white': Colors.white,
      'transparent': Colors.transparent,
    },
    durations: {
      '0': 0,
      '75': 75,
      '100': 100,
      '150': 150,
      '200': 200,
      '300': 300,
      '500': 500,
      '700': 700,
      '1000': 1000,
    },
    delays: {
      '0': 0,
      '75': 75,
      '100': 100,
      '150': 150,
      '200': 200,
      '300': 300,
      '500': 500,
      '700': 700,
      '1000': 1000,
    },
    scales: {
      '0': 0.0,
      '50': 0.5,
      '75': 0.75,
      '90': 0.9,
      '95': 0.95,
      '100': 1.0,
      '105': 1.05,
      '110': 1.1,
      '125': 1.25,
      '150': 1.5,
    },
    rotations: {
      '0': 0,
      '1': 1,
      '2': 2,
      '3': 3,
      '6': 6,
      '12': 12,
      '45': 45,
      '90': 90,
      '180': 180,
    },
  );

  factory TwConfig.standard() => _standard;
}

/// Provides [TwConfig] to descendant widgets via the widget tree.
///
/// Wrap your app or subtree with this to set a default config:
/// ```dart
/// TwConfigProvider(
///   config: TwConfig.standard().copyWith(
///     colors: {'brand-500': myBrandColor},
///   ),
///   child: MyApp(),
/// )
/// ```
///
/// Descendants can then use `Div` and `Span` without explicitly passing
/// a config - they will automatically use the nearest provider's config.
class TwConfigProvider extends InheritedWidget {
  /// Creates a config provider.
  const TwConfigProvider({
    super.key,
    required this.config,
    required super.child,
  });

  /// The configuration to provide to descendant widgets.
  final TwConfig config;

  /// Returns the nearest [TwConfig], or [TwConfig.standard()] if none found.
  ///
  /// Use this when you need a config and want a sensible default.
  static TwConfig of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<TwConfigProvider>();
    return provider?.config ?? TwConfig.standard();
  }

  /// Returns the nearest [TwConfig], or null if none found.
  ///
  /// Use this when you want to explicitly check if a provider exists.
  static TwConfig? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<TwConfigProvider>();
    return provider?.config;
  }

  @override
  bool updateShouldNotify(TwConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}
