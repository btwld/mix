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

/// Pre-configured Material Design tokens for Mix scope.
///
/// Maps Material Design color and typography tokens to Flutter's theme values,
/// providing automatic theme integration for Mix-styled widgets.
final materialTokens = {
  // Color tokens
  _md.colorScheme.primary.defineBuilder((c) => c.colorScheme.primary),
  _md.colorScheme.secondary.defineBuilder((c) => c.colorScheme.secondary),
  _md.colorScheme.tertiary.defineBuilder((c) => c.colorScheme.tertiary),
  _md.colorScheme.surface.defineBuilder((c) => c.colorScheme.surface),
  _md.colorScheme.background.defineBuilder((c) => c.colorScheme.surface),
  _md.colorScheme.error.defineBuilder((c) => c.colorScheme.error),
  _md.colorScheme.onPrimary.defineBuilder((c) => c.colorScheme.onPrimary),
  _md.colorScheme.onSecondary.defineBuilder((c) => c.colorScheme.onSecondary),
  _md.colorScheme.onTertiary.defineBuilder((c) => c.colorScheme.onTertiary),
  _md.colorScheme.onSurface.defineBuilder((c) => c.colorScheme.onSurface),
  _md.colorScheme.onBackground.defineBuilder((c) => c.colorScheme.onSurface),
  _md.colorScheme.onError.defineBuilder((c) => c.colorScheme.onError),

  // Text style tokens
  _md.textTheme.displayLarge.defineBuilder((c) => c.textTheme.displayLarge!),
  _md.textTheme.displayMedium.defineBuilder((c) => c.textTheme.displayMedium!),
  _md.textTheme.displaySmall.defineBuilder((c) => c.textTheme.displaySmall!),
  _md.textTheme.headlineLarge.defineBuilder((c) => c.textTheme.headlineLarge!),
  _md.textTheme.headlineMedium.defineBuilder(
    (c) => c.textTheme.headlineMedium!,
  ),
  _md.textTheme.headlineSmall.defineBuilder((c) => c.textTheme.headlineSmall!),
  _md.textTheme.titleLarge.defineBuilder((c) => c.textTheme.titleLarge!),
  _md.textTheme.titleMedium.defineBuilder((c) => c.textTheme.titleMedium!),
  _md.textTheme.titleSmall.defineBuilder((c) => c.textTheme.titleSmall!),
  _md.textTheme.bodyLarge.defineBuilder((c) => c.textTheme.bodyLarge!),
  _md.textTheme.bodyMedium.defineBuilder((c) => c.textTheme.bodyMedium!),
  _md.textTheme.bodySmall.defineBuilder((c) => c.textTheme.bodySmall!),
  _md.textTheme.labelLarge.defineBuilder((c) => c.textTheme.labelLarge!),
  _md.textTheme.labelMedium.defineBuilder((c) => c.textTheme.labelMedium!),
  _md.textTheme.labelSmall.defineBuilder((c) => c.textTheme.labelSmall!),
  _md.textTheme.headline1.defineBuilder((c) => c.textTheme.displayLarge!),
  _md.textTheme.headline2.defineBuilder((c) => c.textTheme.displayMedium!),
  _md.textTheme.headline3.defineBuilder((c) => c.textTheme.displaySmall!),
  _md.textTheme.headline4.defineBuilder((c) => c.textTheme.headlineMedium!),
  _md.textTheme.headline5.defineBuilder((c) => c.textTheme.headlineSmall!),
  _md.textTheme.headline6.defineBuilder((c) => c.textTheme.titleLarge!),
  _md.textTheme.subtitle1.defineBuilder((c) => c.textTheme.titleMedium!),
  _md.textTheme.subtitle2.defineBuilder((c) => c.textTheme.titleSmall!),
  _md.textTheme.bodyText1.defineBuilder((c) => c.textTheme.bodyLarge!),
  _md.textTheme.bodyText2.defineBuilder((c) => c.textTheme.bodyMedium!),
  _md.textTheme.caption.defineBuilder((c) => c.textTheme.bodySmall!),
  _md.textTheme.button.defineBuilder((c) => c.textTheme.labelLarge!),
  _md.textTheme.overline.defineBuilder((c) => c.textTheme.labelSmall!),
};


/// Creates a MixScope with Material Design tokens pre-configured.
///
/// This is a helper method that creates a MixScope with Material tokens.
/// Material Design tokens automatically adapt to light and dark themes
/// through Flutter's built-in theming system.
MixScope createMaterialMixScope({
  Set<TokenDefinition>? additionalTokens,
  List<Type>? orderOfModifiers,
  required Widget child,
  Key? key,
}) {
  final tokens = {...materialTokens, ...?additionalTokens};

  return MixScope(
    key: key,
    tokens: tokens,
    orderOfModifiers: orderOfModifiers,
    child: child,
  );
}
