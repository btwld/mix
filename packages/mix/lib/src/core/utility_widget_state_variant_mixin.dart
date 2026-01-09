import 'package:flutter/material.dart';

import '../variants/variant.dart';
import 'spec.dart';
import 'style.dart';

/// Mixin providing widget state variant methods for utility classes.
///
/// This mixin provides widget state variant methods for styling utilities with
/// a simple delegation approach. All methods return Style types for consistency
/// with other utility methods like animate().
mixin UtilityWidgetStateVariantMixin<T extends Style<S>, S extends Spec<S>> {
  /// Must be implemented by utilities to apply a variant to a style.
  T withVariant(Variant variant, T style);

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

  /// Creates a variant for focused state.
  ///
  /// **Note:** Focus state tracking requires the widget to be wrapped with
  /// [Pressable] or use [PressableBox]. Unlike [onHovered] and [onPressed],
  /// which work automatically with any styled widget, focus handling needs
  /// the [Pressable] widget.
  ///
  /// Example:
  /// ```dart
  /// // Focus variant only activates when wrapped with Pressable
  /// Pressable(
  ///   child: Box(
  ///     style: BoxStyler().onFocused(.new().color(Colors.green))
  ///   ),
  /// )
  ///
  /// // Or use PressableBox directly
  /// PressableBox(
  ///   style: BoxStyler().onFocused(.new().color(Colors.green)),
  ///   child: child,
  /// )
  /// ```
  T onFocused(T style) {
    return withVariant(ContextVariant.widgetState(WidgetState.focused), style);
  }

  /// Creates a variant for disabled state.
  ///
  /// Example:
  /// ```dart
  /// $box.onDisabled($box.color.grey())
  /// ```
  T onDisabled(T style) {
    return withVariant(ContextVariant.widgetState(WidgetState.disabled), style);
  }

  /// Creates a variant for enabled state (opposite of disabled).
  ///
  /// Example:
  /// ```dart
  /// $box.onEnabled($box.color.blue())
  /// ```
  T onEnabled(T style) {
    return withVariant(
      ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
      style,
    );
  }
}
