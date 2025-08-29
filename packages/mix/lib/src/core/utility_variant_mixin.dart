import 'package:flutter/material.dart';

import '../variants/variant.dart';
import 'spec.dart';
import 'style.dart';

/// Mixin providing variant methods for utility classes.
///
/// This mixin provides variant methods for styling utilities with a simple
/// delegation approach. All methods return Style types for consistency
/// with other utility methods like animate().
mixin UtilityVariantMixin<S extends Spec<S>, T extends Style<S>> {
  /// Must be implemented by utilities to apply a variant to a style.
  T withVariant(Variant variant, T style);

  /// Must be implemented by utilities to apply multiple variants to a style.
  T withVariants(List<VariantStyle<S>> variants);

  /// Gets the current utility value as a style.
  T get currentValue;

  /// Creates a variant for hover state.
  ///
  /// Example:
  /// ```dart
  /// $box.onHovered($box.color.red())
  /// ```
  T onHovered(T style) {
    return withVariant(ContextVariant.widgetState(WidgetState.hovered), style);
  }

  /// Creates a variant for pressed state.
  ///
  /// Example:
  /// ```dart
  /// $box.onPressed($box.color.blue())
  /// ```
  T onPressed(T style) {
    return withVariant(ContextVariant.widgetState(WidgetState.pressed), style);
  }

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
  /// $box.builder((context) {
  ///   final theme = Theme.of(context);
  ///   return $box.color(theme.primaryColor);
  /// })
  /// ```
  T builder(T Function(BuildContext context) fn) {
    return withVariants([
      VariantStyle<S>(ContextVariantBuilder<T>(fn), currentValue),
    ]);
  }
}
