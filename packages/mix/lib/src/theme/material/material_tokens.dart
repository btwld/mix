import 'package:flutter/material.dart';

import '../tokens/color_token.dart';
import '../tokens/text_style_token.dart';

/// Provides access to Material Design tokens for colors and text styles.
///
/// Contains organized token collections that map to Material Design 3
/// color schemes and typography system.
@immutable
class MaterialTokens {
  final colorScheme = const _MaterialColorTokens();
  final textTheme = const _MaterialTextStyles();

  const MaterialTokens();
}

/// Material Design color tokens for theme integration.
@immutable
class _MaterialColorTokens {
  final primary = const ColorToken('md.color.primary');

  final secondary = const ColorToken('md.color.secondary');

  final tertiary = const ColorToken('md.color.tertiary');

  final surface = const ColorToken('md.color.surface');

  final background = const ColorToken('md.color.background');

  final error = const ColorToken('md.color.error');

  final onPrimary = const ColorToken('md.color.on.primary');

  final onSecondary = const ColorToken('md.color.on.secondary');

  final onTertiary = const ColorToken('md.color.on.tertiary');

  final onSurface = const ColorToken('md.color.on.surface');

  final onBackground = const ColorToken('md.color.on.background');

  final onError = const ColorToken('md.color.on.error');

  const _MaterialColorTokens();
}

/// Material Design 3 text style tokens for typography.
@immutable
class _MaterialTextStyles {
  //  Material 3 text styles
  final displayLarge = const TextStyleToken('md3.text.theme.display.large');
  final displayMedium = const TextStyleToken('md3.text.theme.display.medium');
  final displaySmall = const TextStyleToken('md3.text.theme.display.small');
  final headlineLarge = const TextStyleToken('md3.text.theme.headline.large');
  final headlineMedium = const TextStyleToken('md3.text.theme.headline.medium');
  final headlineSmall = const TextStyleToken('md3.text.theme.headline.small');

  final titleLarge = const TextStyleToken('md3.text.theme.title.large');
  final titleMedium = const TextStyleToken('md3.text.theme.title.medium');
  final titleSmall = const TextStyleToken('md3.text.theme.title.small');
  final bodyLarge = const TextStyleToken('md3.text.theme.body.large');
  final bodyMedium = const TextStyleToken('md3.text.theme.body.medium');
  final bodySmall = const TextStyleToken('md3.text.theme.body.small');
  final labelLarge = const TextStyleToken('md3.text.theme.label.large');
  final labelMedium = const TextStyleToken('md3.text.theme.label.medium');
  final labelSmall = const TextStyleToken('md3.text.theme.label.small');
  // Material 2 text styles
  final headline1 = const TextStyleToken('md2.text.theme.headline1');
  final headline2 = const TextStyleToken('md2.text.theme.headline2');
  final headline3 = const TextStyleToken('md2.text.theme.headline3');
  final headline4 = const TextStyleToken('md2.text.theme.headline4');
  final headline5 = const TextStyleToken('md2.text.theme.headline5');
  final headline6 = const TextStyleToken('md2.text.theme.headline6');
  final subtitle1 = const TextStyleToken('md2.text.theme.subtitle1');
  final subtitle2 = const TextStyleToken('md2.text.theme.subtitle2');
  final bodyText1 = const TextStyleToken('md2.text.theme.bodyText1');
  final bodyText2 = const TextStyleToken('md2.text.theme.bodyText2');
  final caption = const TextStyleToken('md2.text.theme.caption');
  final button = const TextStyleToken('md2.text.theme.button');
  final overline = const TextStyleToken('md2.text.theme.overline');

  const _MaterialTextStyles();
}
