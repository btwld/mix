import '../../core/spec.dart';
import '../../core/style.dart';
import '../../variants/variant.dart';

/// Mixin that provides widget state variant styling methods for spec attributes.
///
/// This mixin provides convenient methods for applying widget state variants
/// (hover, press, focus, disabled/enabled) to style attributes.
mixin WidgetStateVariantMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  /// Must be implemented by the class using this mixin
  T variant(Variant variant, T style);

  /// Creates a variant for hover state
  T onHovered(T style) {
    return variant(ContextVariant.widgetState(.hovered), style);
  }

  /// Creates a variant for pressed state
  T onPressed(T style) {
    return variant(ContextVariant.widgetState(.pressed), style);
  }

  /// Creates a variant for focused state.
  ///
  /// **Note:** Focus state tracking requires the widget to be wrapped with
  /// [Pressable] or use [PressableBox]. Unlike [onHovered] and [onPressed],
  /// which work automatically with any styled widget, focus handling needs
  /// the [Pressable] widget.
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
    return variant(ContextVariant.widgetState(.focused), style);
  }

  /// Creates a variant for disabled state
  T onDisabled(T style) {
    return variant(ContextVariant.widgetState(.disabled), style);
  }

  /// Creates a variant for enabled state (opposite of disabled)
  T onEnabled(T style) {
    return variant(
      ContextVariant.not(ContextVariant.widgetState(.disabled)),
      style,
    );
  }
}
