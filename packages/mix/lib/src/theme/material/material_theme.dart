/// Material Design theme integration for Mix framework.
///
/// Provides pre-configured material tokens that map Material Design tokens
/// to Flutter's Material theme values, enabling seamless integration between
/// Mix styling and Material Design systems.
library;

import 'package:flutter/widgets.dart';

import '../../core/internal/internal_extensions.dart';
import '../mix_theme.dart';
import '../tokens/mix_token.dart';
import 'material_tokens.dart';

const _md = MaterialTokens();

/// Creates color token map from the current Material theme context.
Map<MixToken, Object> _createMaterialColorTokens(BuildContext context) {
  return {
    _md.colorScheme.primary: context.colorScheme.primary,
    _md.colorScheme.secondary: context.colorScheme.secondary,
    _md.colorScheme.tertiary: context.colorScheme.tertiary,
    _md.colorScheme.surface: context.colorScheme.surface,
    _md.colorScheme.background: context.colorScheme.surface,
    _md.colorScheme.error: context.colorScheme.error,
    _md.colorScheme.onPrimary: context.colorScheme.onPrimary,
    _md.colorScheme.onSecondary: context.colorScheme.onSecondary,
    _md.colorScheme.onTertiary: context.colorScheme.onTertiary,
    _md.colorScheme.onSurface: context.colorScheme.onSurface,
    _md.colorScheme.onBackground: context.colorScheme.onSurface,
    _md.colorScheme.onError: context.colorScheme.onError,
  };
}

/// Creates text style token map from the current Material theme context.
Map<MixToken, Object> _createMaterialTextStyleTokens(BuildContext context) {
  return {
    _md.textTheme.displayLarge: context.textTheme.displayLarge!,
    _md.textTheme.displayMedium: context.textTheme.displayMedium!,
    _md.textTheme.displaySmall: context.textTheme.displaySmall!,
    _md.textTheme.headlineLarge: context.textTheme.headlineLarge!,
    _md.textTheme.headlineMedium: context.textTheme.headlineMedium!,
    _md.textTheme.headlineSmall: context.textTheme.headlineSmall!,
    _md.textTheme.titleLarge: context.textTheme.titleLarge!,
    _md.textTheme.titleMedium: context.textTheme.titleMedium!,
    _md.textTheme.titleSmall: context.textTheme.titleSmall!,
    _md.textTheme.bodyLarge: context.textTheme.bodyLarge!,
    _md.textTheme.bodyMedium: context.textTheme.bodyMedium!,
    _md.textTheme.bodySmall: context.textTheme.bodySmall!,
    _md.textTheme.labelLarge: context.textTheme.labelLarge!,
    _md.textTheme.labelMedium: context.textTheme.labelMedium!,
    _md.textTheme.labelSmall: context.textTheme.labelSmall!,
    // Deprecated aliases
    _md.textTheme.headline1: context.textTheme.displayLarge!,
    _md.textTheme.headline2: context.textTheme.displayMedium!,
    _md.textTheme.headline3: context.textTheme.displaySmall!,
    _md.textTheme.headline4: context.textTheme.headlineMedium!,
    _md.textTheme.headline5: context.textTheme.headlineSmall!,
    _md.textTheme.headline6: context.textTheme.titleLarge!,
    _md.textTheme.subtitle1: context.textTheme.titleMedium!,
    _md.textTheme.subtitle2: context.textTheme.titleSmall!,
    _md.textTheme.bodyText1: context.textTheme.bodyLarge!,
    _md.textTheme.bodyText2: context.textTheme.bodyMedium!,
    _md.textTheme.caption: context.textTheme.bodySmall!,
    _md.textTheme.button: context.textTheme.labelLarge!,
    _md.textTheme.overline: context.textTheme.labelSmall!,
  };
}

/// Creates a MixScope with Material Design tokens pre-configured.
///
/// This method uses a Builder to dynamically access the current Material theme
/// and creates token map with concrete values from the theme.
Widget createMaterialMixScope({
  Map<MixToken, Object>? additionalTokens,
  List<Type>? orderOfModifiers,
  required Widget child,
  Key? key,
}) {
  return Builder(
    builder: (context) {
      final materialColorTokens = _createMaterialColorTokens(context);
      final materialTextStyleTokens = _createMaterialTextStyleTokens(context);
      final allMaterialTokens = {
        ...materialColorTokens,
        ...materialTextStyleTokens,
      };
      final tokens = {...allMaterialTokens, ...?additionalTokens};

      return MixScope(
        key: key,
        tokens: tokens,
        orderOfModifiers: orderOfModifiers,
        child: child,
      );
    },
  );
}
