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

/// Creates color token definitions from the current Material theme context.
Set<TokenDefinition> _createMaterialColorTokens(BuildContext context) {
  return {
    TokenDefinition(_md.colorScheme.primary, context.colorScheme.primary),
    TokenDefinition(_md.colorScheme.secondary, context.colorScheme.secondary),
    TokenDefinition(_md.colorScheme.tertiary, context.colorScheme.tertiary),
    TokenDefinition(_md.colorScheme.surface, context.colorScheme.surface),
    TokenDefinition(_md.colorScheme.background, context.colorScheme.surface),
    TokenDefinition(_md.colorScheme.error, context.colorScheme.error),
    TokenDefinition(_md.colorScheme.onPrimary, context.colorScheme.onPrimary),
    TokenDefinition(
      _md.colorScheme.onSecondary,
      context.colorScheme.onSecondary,
    ),
    TokenDefinition(_md.colorScheme.onTertiary, context.colorScheme.onTertiary),
    TokenDefinition(_md.colorScheme.onSurface, context.colorScheme.onSurface),
    TokenDefinition(
      _md.colorScheme.onBackground,
      context.colorScheme.onSurface,
    ),
    TokenDefinition(_md.colorScheme.onError, context.colorScheme.onError),
  };
}

/// Creates text style token definitions from the current Material theme context.
Set<TokenDefinition> _createMaterialTextStyleTokens(BuildContext context) {
  return {
    TokenDefinition(
      _md.textTheme.displayLarge,
      context.textTheme.displayLarge!,
    ),
    TokenDefinition(
      _md.textTheme.displayMedium,
      context.textTheme.displayMedium!,
    ),
    TokenDefinition(
      _md.textTheme.displaySmall,
      context.textTheme.displaySmall!,
    ),
    TokenDefinition(
      _md.textTheme.headlineLarge,
      context.textTheme.headlineLarge!,
    ),
    TokenDefinition(
      _md.textTheme.headlineMedium,
      context.textTheme.headlineMedium!,
    ),
    TokenDefinition(
      _md.textTheme.headlineSmall,
      context.textTheme.headlineSmall!,
    ),
    TokenDefinition(_md.textTheme.titleLarge, context.textTheme.titleLarge!),
    TokenDefinition(_md.textTheme.titleMedium, context.textTheme.titleMedium!),
    TokenDefinition(_md.textTheme.titleSmall, context.textTheme.titleSmall!),
    TokenDefinition(_md.textTheme.bodyLarge, context.textTheme.bodyLarge!),
    TokenDefinition(_md.textTheme.bodyMedium, context.textTheme.bodyMedium!),
    TokenDefinition(_md.textTheme.bodySmall, context.textTheme.bodySmall!),
    TokenDefinition(_md.textTheme.labelLarge, context.textTheme.labelLarge!),
    TokenDefinition(_md.textTheme.labelMedium, context.textTheme.labelMedium!),
    TokenDefinition(_md.textTheme.labelSmall, context.textTheme.labelSmall!),
    // Deprecated aliases
    TokenDefinition(_md.textTheme.headline1, context.textTheme.displayLarge!),
    TokenDefinition(_md.textTheme.headline2, context.textTheme.displayMedium!),
    TokenDefinition(_md.textTheme.headline3, context.textTheme.displaySmall!),
    TokenDefinition(_md.textTheme.headline4, context.textTheme.headlineMedium!),
    TokenDefinition(_md.textTheme.headline5, context.textTheme.headlineSmall!),
    TokenDefinition(_md.textTheme.headline6, context.textTheme.titleLarge!),
    TokenDefinition(_md.textTheme.subtitle1, context.textTheme.titleMedium!),
    TokenDefinition(_md.textTheme.subtitle2, context.textTheme.titleSmall!),
    TokenDefinition(_md.textTheme.bodyText1, context.textTheme.bodyLarge!),
    TokenDefinition(_md.textTheme.bodyText2, context.textTheme.bodyMedium!),
    TokenDefinition(_md.textTheme.caption, context.textTheme.bodySmall!),
    TokenDefinition(_md.textTheme.button, context.textTheme.labelLarge!),
    TokenDefinition(_md.textTheme.overline, context.textTheme.labelSmall!),
  };
}

/// Creates a MixScope with Material Design tokens pre-configured.
///
/// This method uses a Builder to dynamically access the current Material theme
/// and creates token definitions with concrete values from the theme.
Widget createMaterialMixScope({
  Set<TokenDefinition>? additionalTokens,
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
