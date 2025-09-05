import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../../variants/variant.dart';

/// Mixin that provides convenient variant styling methods for spec attributes.
///
/// This mixin follows the same pattern as ModifierMixin, providing
/// a fluent API for applying context variants to spec attributes.
mixin VariantStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  T variant(Variant variant, T style) {
    return variants([VariantStyle<S>(variant, style)]);
  }

  /// Must be implemented by the class using this mixin
  T variants(List<VariantStyle<S>> value);

  /// Creates a variant for dark mode
  T onDark(T style) {
    return variant(ContextVariant.brightness(Brightness.dark), style);
  }

  T onNot(ContextVariant contextVariant, T style) {
    return variant(ContextVariant.not(contextVariant), style);
  }

  /// Creates a variant for light mode
  T onLight(T style) {
    return variant(ContextVariant.brightness(Brightness.light), style);
  }

  /// Creates a variant for hover state
  T onHovered(T style) {
    return variant(ContextVariant.widgetState(WidgetState.hovered), style);
  }

  /// Creates a variant that applies styling based on the build context.
  ///
  /// The provided builder function receives a [BuildContext] and should return
  /// a style that will be applied when this variant is active.
  ///
  /// Example:
  /// ```dart
  /// BoxStyle().builder((context) {
  ///   final theme = Theme.of(context);
  ///   return BoxStyle().decoration.color(theme.primaryColor);
  /// })
  /// ```
  T builder(T Function(BuildContext context) fn) {
    // Create a VariantStyle with ContextVariantBuilder that will be resolved at runtime
    // Use this style as a placeholder; the actual style comes from the builder function
    return variants([VariantStyle<S>(ContextVariantBuilder<T>(fn), this)]);
  }

  /// Creates a variant for pressed state
  T onPressed(T style) {
    return variant(ContextVariant.widgetState(WidgetState.pressed), style);
  }

  /// Creates a variant for focused state
  T onFocused(T style) {
    return variant(ContextVariant.widgetState(WidgetState.focused), style);
  }

  /// Creates a variant for disabled state
  T onDisabled(T style) {
    return variant(ContextVariant.widgetState(WidgetState.disabled), style);
  }

  /// Creates a variant for selected state
  T onSelected(T style) {
    return variant(ContextVariant.widgetState(WidgetState.selected), style);
  }

  /// Creates a variant based on breakpoint
  T onBreakpoint(Breakpoint breakpoint, T style) {
    return variant(ContextVariant.breakpoint(breakpoint), style);
  }
}