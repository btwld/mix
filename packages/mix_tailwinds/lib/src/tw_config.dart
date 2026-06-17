import 'package:flutter/material.dart';

import 'theme/data/default_theme.g.dart';

/// Controls how Tailwind directional gradients (`to-*`) are mapped in Flutter.
enum TwGradientStrategy {
  /// Uses direct begin/end alignments (for example, `to-br` -> topLeft to bottomRight).
  alignment,

  /// Uses a centered horizontal axis with rotation (`GradientRotation`).
  angle,

  /// Uses CSS keyword semantics with bounds-aware transform parity.
  ///
  /// This makes corner directions like `to-br` adapt to rectangle aspect ratio,
  /// matching CSS "magic corners" behavior.
  cssAngleRect,
}

/// Tailwind-oriented typography defaults for Flutter text rendering.
///
/// These values are applied through Mix `TextScope` (via `TwScope`) so
/// parity does not depend on `ThemeData.textTheme`.
@immutable
class TwTextDefaults {
  static const Object _noChange = Object();

  const TwTextDefaults({
    this.fontFamily,
    this.fontFamilyFallback = const [
      '.SF Pro Text',
      'SF Pro Text',
      '-apple-system',
      'BlinkMacSystemFont',
      'Segoe UI',
      'Roboto',
      'Helvetica Neue',
      'Arial',
      'Noto Sans',
      'sans-serif',
    ],
    this.letterSpacing = 0,
    this.lineHeight = 1.5,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  /// Tailwind-compatible defaults using a system sans stack.
  const TwTextDefaults.tailwindSans()
    : fontFamily = 'system-ui',
      fontFamilyFallback = const [
        'ui-sans-serif',
        '.SF Pro Text',
        'SF Pro Text',
        '-apple-system',
        'BlinkMacSystemFont',
        'Segoe UI',
        'Roboto',
        'Helvetica Neue',
        'Arial',
        'Noto Sans',
        'sans-serif',
      ],
      letterSpacing = 0,
      lineHeight = 1.5,
      fontSize = 16,
      fontWeight = FontWeight.w400;

  /// Platform-default typography (no explicit font family override).
  ///
  /// Useful when you want Flutter to pick the native system font stack.
  const TwTextDefaults.platformDefault()
    : fontFamily = null,
      fontFamilyFallback = const [],
      letterSpacing = 0,
      lineHeight = 1.5,
      fontSize = 16,
      fontWeight = FontWeight.w400;

  /// Primary font family. If null, Flutter uses the platform default.
  final String? fontFamily;

  /// Font fallback chain used when [fontFamily] cannot render a glyph.
  final List<String> fontFamilyFallback;

  /// Base tracking equivalent to Tailwind's normal letter spacing.
  final double letterSpacing;

  /// Base line-height (Tailwind Preflight is 1.5).
  final double lineHeight;

  /// Base font size (Tailwind Preflight is 16px).
  final double fontSize;

  /// Base font weight (Tailwind Preflight is normal / 400).
  final FontWeight fontWeight;

  TwTextDefaults copyWith({
    Object? fontFamily = _noChange,
    List<String>? fontFamilyFallback,
    double? letterSpacing,
    double? lineHeight,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final resolvedFontFamily = identical(fontFamily, _noChange)
        ? this.fontFamily
        : fontFamily as String?;

    return TwTextDefaults(
      fontFamily: resolvedFontFamily,
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }

  TextStyle toTextStyle() {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      letterSpacing: letterSpacing,
      height: lineHeight,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

/// Runtime configuration for translating Tailwind-like tokens into Mix stylers.
///
/// Maps are stored as unmodifiable to ensure `updateShouldNotify` identity
/// comparison works correctly. To change config, create a new TwConfig instance.
class TwConfig {
  TwConfig({
    required Map<String, double> space,
    required Map<String, double> radii,
    required Map<String, double> borderWidths,
    required Map<String, double> breakpoints,
    required Map<String, double> fontSizes,
    required Map<String, Color> colors,
    required Map<String, int> durations,
    required Map<String, int> delays,
    required Map<String, double> scales,
    required Map<String, double> rotations,
    required Map<String, double> blurs,
    this.textDefaults = const TwTextDefaults.tailwindSans(),
    this.gradientStrategy = TwGradientStrategy.cssAngleRect,
  }) : space = Map.unmodifiable(space),
       radii = Map.unmodifiable(radii),
       borderWidths = Map.unmodifiable(borderWidths),
       breakpoints = Map.unmodifiable(breakpoints),
       fontSizes = Map.unmodifiable(fontSizes),
       colors = Map.unmodifiable(colors),
       durations = Map.unmodifiable(durations),
       delays = Map.unmodifiable(delays),
       scales = Map.unmodifiable(scales),
       rotations = Map.unmodifiable(rotations),
       blurs = Map.unmodifiable(blurs);

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
  final Map<String, double> blurs;
  final TwTextDefaults textDefaults;
  final TwGradientStrategy gradientStrategy;

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
      if (baseColor != null &&
          opacity != null &&
          opacity >= 0 &&
          opacity <= 100) {
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

  double? blurOf(String key) => blurs[key];

  // Key existence checks for strict validation
  bool hasSpace(String key) => space.containsKey(key);
  bool hasRadius(String key) => radii.containsKey(key);
  bool hasBorderWidth(String key) => borderWidths.containsKey(key);
  bool hasBreakpoint(String key) => breakpoints.containsKey(key);
  bool hasFontSize(String key) => fontSizes.containsKey(key);
  bool hasDuration(String key) => durations.containsKey(key);
  bool hasDelay(String key) => delays.containsKey(key);
  bool hasScale(String key) => scales.containsKey(key);
  bool hasRotation(String key) => rotations.containsKey(key);
  bool hasBlur(String key) => blurs.containsKey(key);

  bool hasColor(String key) {
    // Handle opacity modifiers like 'white/10', 'purple-500/30'
    final slashIndex = key.indexOf('/');
    if (slashIndex > 0) {
      final colorKey = key.substring(0, slashIndex);
      return colors.containsKey(colorKey);
    }
    return colors.containsKey(key);
  }

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
    Map<String, double>? blurs,
    TwTextDefaults? textDefaults,
    TwGradientStrategy? gradientStrategy,
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
      blurs: blurs ?? this.blurs,
      textDefaults: textDefaults ?? this.textDefaults,
      gradientStrategy: gradientStrategy ?? this.gradientStrategy,
    );
  }

  static final TwConfig _standard = TwConfig(
    space: twDefaultSpacing,
    radii: twDefaultRadii,
    borderWidths: twDefaultBorderWidths,
    breakpoints: twDefaultBreakpoints,
    fontSizes: twDefaultFontSizes,
    colors: twDefaultColors,
    durations: twDefaultDurations,
    delays: twDefaultDelays,
    scales: twDefaultScales,
    rotations: twDefaultRotations,
    blurs: twDefaultBlurs,
    textDefaults: const TwTextDefaults.tailwindSans(),
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
