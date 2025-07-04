import 'package:flutter/material.dart';

import '../mix/mix_theme.dart';
import 'material_tokens.dart';

const _md = MaterialTokens();

extension on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
  ColorScheme get color => Theme.of(this).colorScheme;
}

final materialMixScope = MixScopeData.static(
  tokens: {
    // Color tokens
    _md.colorScheme.primary: (c) => c.color.primary,
    _md.colorScheme.secondary: (c) => c.color.secondary,
    _md.colorScheme.tertiary: (c) => c.color.tertiary,
    _md.colorScheme.surface: (c) => c.color.surface,
    _md.colorScheme.background: (c) => c.color.surface,
    _md.colorScheme.error: (c) => c.color.error,
    _md.colorScheme.onPrimary: (c) => c.color.onPrimary,
    _md.colorScheme.onSecondary: (c) => c.color.onSecondary,
    _md.colorScheme.onTertiary: (c) => c.color.onTertiary,
    _md.colorScheme.onSurface: (c) => c.color.onSurface,
    _md.colorScheme.onBackground: (context) => context.color.onSurface,
    _md.colorScheme.onError: (context) => context.color.onError,

    // Text style tokens
    _md.textTheme.displayLarge: (c) => c.text.displayLarge!,
    _md.textTheme.displayMedium: (c) => c.text.displayMedium!,
    _md.textTheme.displaySmall: (c) => c.text.displaySmall!,
    _md.textTheme.headlineLarge: (c) => c.text.headlineLarge!,
    _md.textTheme.headlineMedium: (c) => c.text.headlineMedium!,
    _md.textTheme.headlineSmall: (c) => c.text.headlineSmall!,
    _md.textTheme.titleLarge: (c) => c.text.titleLarge!,
    _md.textTheme.titleMedium: (c) => c.text.titleMedium!,
    _md.textTheme.titleSmall: (c) => c.text.titleSmall!,
    _md.textTheme.bodyLarge: (c) => c.text.bodyLarge!,
    _md.textTheme.bodyMedium: (c) => c.text.bodyMedium!,
    _md.textTheme.bodySmall: (c) => c.text.bodySmall!,
    _md.textTheme.labelLarge: (c) => c.text.labelLarge!,
    _md.textTheme.labelMedium: (c) => c.text.labelMedium!,
    _md.textTheme.labelSmall: (c) => c.text.labelSmall!,
    _md.textTheme.headline1: (c) => c.text.displayLarge!,
    _md.textTheme.headline2: (c) => c.text.displayMedium!,
    _md.textTheme.headline3: (c) => c.text.displaySmall!,
    _md.textTheme.headline4: (c) => c.text.headlineMedium!,
    _md.textTheme.headline5: (c) => c.text.headlineSmall!,
    _md.textTheme.headline6: (c) => c.text.titleLarge!,
    _md.textTheme.subtitle1: (c) => c.text.titleMedium!,
    _md.textTheme.subtitle2: (c) => c.text.titleSmall!,
    _md.textTheme.bodyText1: (c) => c.text.bodyLarge!,
    _md.textTheme.bodyText2: (c) => c.text.bodyMedium!,
    _md.textTheme.caption: (c) => c.text.bodySmall!,
    _md.textTheme.button: (c) => c.text.labelLarge!,
    _md.textTheme.overline: (c) => c.text.labelSmall!,
  },
);
