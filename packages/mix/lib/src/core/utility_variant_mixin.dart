import 'package:flutter/material.dart';

import '../variants/variant.dart';
import 'spec.dart';
import 'style.dart';

/// Mixin providing variant methods for utility classes.
///
/// This mixin provides variant methods for styling utilities with a simple
/// delegation approach. All methods return Style types for consistency
/// with other utility methods like animate().
mixin UtilityVariantMixin<T extends Style<S>, S extends Spec<S>> {
  /// Must be implemented by utilities to apply a variant to a style.
  T withVariant(Variant variant, T style);

  /// Must be implemented by utilities to apply multiple variants to a style.
  T withVariants(List<VariantStyle<S>> variants);

  /// Gets the current utility value as a style.
  T get currentValue;

  /// Creates a variant for dark mode.
  ///
  /// Example:
  /// ```dart
  /// $box.onDark($box.color.white())
  /// ```
  T onDark(T style) {
    return withVariant(ContextVariant.brightness(Brightness.dark), style);
  }

  /// Creates a variant for light mode.
  ///
  /// Example:
  /// ```dart
  /// $box.onLight($box.color.black())
  /// ```
  T onLight(T style) {
    return withVariant(ContextVariant.brightness(Brightness.light), style);
  }

  /// Creates a variant that applies styling based on the build context.
  ///
  /// The provided builder function receives a [BuildContext] and should return
  /// a style that will be applied when this variant is active.
  ///
  /// Example:
  /// ```dart
  /// $box.onBuilder((context) {
  ///   final theme = Theme.of(context);
  ///   return $box.color(theme.primaryColor);
  /// })
  /// ```
  T onBuilder(T Function(BuildContext context) fn) {
    return withVariants([
      VariantStyle<S>(ContextVariantBuilder<T>(fn), currentValue),
    ]);
  }

  @Deprecated(
    'Use onBuilder instead. This method will be removed in a future version.',
  )
  T builder(T Function(BuildContext context) fn) {
    return onBuilder(fn);
  }
}
