import 'package:flutter/widgets.dart';

import '../variants/widget_state_variant.dart';
import '../widgets/pressable_widget.dart';
import 'factory/mix_data.dart';
import 'factory/style_mix.dart';
import 'internal/experimental/mix_builder.dart';
import 'widget_state/widget_state_controller.dart';

/// An abstract widget for applying custom styles.
///
/// `StyledWidget` serves as a base class for widgets that need custom styling.
/// It facilitates the application of a `Style` object to the widget and optionally
/// allows this style to be inherited from its parent. This class is intended to be
/// extended by more concrete widgets that implement specific styled behavior.

abstract class StyledWidget extends StatelessWidget {
  /// Constructor for a styled widget.
  ///
  /// Takes a [Style] object and an optional [inherit] flag.
  const StyledWidget({
    Style? style,
    super.key,
    this.inherit = false,
    required this.orderOfModifiers,
  }) : style = style ?? const Style.empty();

  /// The style to apply to the widget.
  ///
  /// Defines the appearance of the widget using a [Style] object. If null, defaults
  /// to an empty [Style], meaning no style is applied.
  final Style style;

  /// Whether the widget should inherit its style from its parent.
  ///
  /// If set to true, the widget will merge its style with the style from the nearest
  /// [StyledWidget] ancestor in the widget tree. Defaults to false.
  final bool inherit;

  final List<Type> orderOfModifiers;

  /// Applies a mix of inherited and local styles to the widget.
  ///
  /// Accepts a [BuildContext] and a [MixData] builder. It computes the final style by
  /// merging the inherited style with the local style, then applies it to the widget.
  /// This method is typically used in the `build` method of widgets extending
  /// [StyledWidget] to provide the actual styled widget.
  Widget withMix(
    BuildContext context,
    Widget Function(BuildContext context) builder,
  ) {
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: builder,
    );
  }
}

/// A styled widget that builds its child using a [MixData] object.
///
/// `SpecBuilder` is a concrete implementation of [StyledWidget] that
/// builds its child using a [withMix] method from [StyledWidget].
/// This widget is useful for creating custom styled widgets.
class SpecBuilder extends StatelessWidget {
  // Requires a builder function and accepts optional parameters
  const SpecBuilder({
    super.key,
    this.inherit = false,
    this.controller,
    this.style = const Style.empty(),
    List<Type>? orderOfModifiers,
    required this.builder,
  }) : orderOfModifiers = orderOfModifiers ?? const [];

  bool get _hasWidgetStateVariant => style.variants.values
      .any((attr) => attr.variant is MixWidgetStateVariant);

  // Required builder function
  final Widget Function(BuildContext) builder;
  // Optional controller for managing widget state
  final WidgetStatesController? controller;
  // Style to be applied to the widget
  final Style style;
  // Flag to determine if the style should be inherited
  final bool inherit;
  // List of modifier types in the desired order
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    Widget current = Builder(
      builder: (_) => MixBuilder(
        inherit: inherit,
        style: style,
        orderOfModifiers: orderOfModifiers,
        builder: builder,
      ),
    );
    // Check if the widget needs widget state and if it's not available in the context
    final needsWidgetState =
        _hasWidgetStateVariant && MixWidgetState.of(context) == null;

    if (needsWidgetState || controller != null) {
      current = Interactable(controller: controller, child: current);
    }

    // Otherwise, directly build the mixed child widget
    return current;
  }
}
