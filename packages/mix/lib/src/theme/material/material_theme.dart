/// Material Design theme integration for Mix framework.
///
/// Provides a pre-configured [MixScopeData] that maps Material Design tokens
/// to Flutter's Material theme values, enabling seamless integration between
/// Mix styling and Material Design systems.

import '../../internal/internal_extensions.dart';
import '../mix/mix_theme.dart';
import 'material_tokens.dart';

const _md = MaterialTokens();

/// Pre-configured Mix scope data that integrates with Material Design theme.
///
/// Maps Material Design color and typography tokens to Flutter's theme values,
/// providing automatic theme integration for Mix-styled widgets.
final materialMixScope = MixScopeData.fromResolvers(
  tokens: {
    // Color tokens
    _md.colorScheme.primary: (c) => c.colorScheme.primary,
    _md.colorScheme.secondary: (c) => c.colorScheme.secondary,
    _md.colorScheme.tertiary: (c) => c.colorScheme.tertiary,
    _md.colorScheme.surface: (c) => c.colorScheme.surface,
    _md.colorScheme.background: (c) => c.colorScheme.surface,
    _md.colorScheme.error: (c) => c.colorScheme.error,
    _md.colorScheme.onPrimary: (c) => c.colorScheme.onPrimary,
    _md.colorScheme.onSecondary: (c) => c.colorScheme.onSecondary,
    _md.colorScheme.onTertiary: (c) => c.colorScheme.onTertiary,
    _md.colorScheme.onSurface: (c) => c.colorScheme.onSurface,
    _md.colorScheme.onBackground: (context) => context.colorScheme.onSurface,
    _md.colorScheme.onError: (context) => context.colorScheme.onError,

    // Text style tokens
    _md.textTheme.displayLarge: (c) => c.textTheme.displayLarge!,
    _md.textTheme.displayMedium: (c) => c.textTheme.displayMedium!,
    _md.textTheme.displaySmall: (c) => c.textTheme.displaySmall!,
    _md.textTheme.headlineLarge: (c) => c.textTheme.headlineLarge!,
    _md.textTheme.headlineMedium: (c) => c.textTheme.headlineMedium!,
    _md.textTheme.headlineSmall: (c) => c.textTheme.headlineSmall!,
    _md.textTheme.titleLarge: (c) => c.textTheme.titleLarge!,
    _md.textTheme.titleMedium: (c) => c.textTheme.titleMedium!,
    _md.textTheme.titleSmall: (c) => c.textTheme.titleSmall!,
    _md.textTheme.bodyLarge: (c) => c.textTheme.bodyLarge!,
    _md.textTheme.bodyMedium: (c) => c.textTheme.bodyMedium!,
    _md.textTheme.bodySmall: (c) => c.textTheme.bodySmall!,
    _md.textTheme.labelLarge: (c) => c.textTheme.labelLarge!,
    _md.textTheme.labelMedium: (c) => c.textTheme.labelMedium!,
    _md.textTheme.labelSmall: (c) => c.textTheme.labelSmall!,
    _md.textTheme.headline1: (c) => c.textTheme.displayLarge!,
    _md.textTheme.headline2: (c) => c.textTheme.displayMedium!,
    _md.textTheme.headline3: (c) => c.textTheme.displaySmall!,
    _md.textTheme.headline4: (c) => c.textTheme.headlineMedium!,
    _md.textTheme.headline5: (c) => c.textTheme.headlineSmall!,
    _md.textTheme.headline6: (c) => c.textTheme.titleLarge!,
    _md.textTheme.subtitle1: (c) => c.textTheme.titleMedium!,
    _md.textTheme.subtitle2: (c) => c.textTheme.titleSmall!,
    _md.textTheme.bodyText1: (c) => c.textTheme.bodyLarge!,
    _md.textTheme.bodyText2: (c) => c.textTheme.bodyMedium!,
    _md.textTheme.caption: (c) => c.textTheme.bodySmall!,
    _md.textTheme.button: (c) => c.textTheme.labelLarge!,
    _md.textTheme.overline: (c) => c.textTheme.labelSmall!,
  },
);
