import 'package:flutter/widgets.dart';

import '../variants/widget_state_variant.dart';
import '../widgets/pressable_widget.dart';
import 'factory/style_mix.dart';
import 'internal/experimental/mix_builder.dart';
import 'widget_state/widget_state_controller.dart';

/// Base class for widgets that apply [Style] definitions.
///
/// Provides style inheritance from parent [StyledWidget]s and handles
/// style application through the Mix framework. Extend this class to
/// create widgets that can be styled using Mix.

abstract class StyledWidget extends StatelessWidget {
  /// Creates a styled widget.
  const StyledWidget({
    Style? style,
    super.key,
    this.inherit = false,
    required this.orderOfModifiers,
  }) : style = style ?? const Style.empty();

  /// The style to apply to this widget.
  final Style style;

  /// Whether to inherit style from the nearest [StyledWidget] ancestor.
  final bool inherit;

  /// The order in which modifiers should be applied.
  final List<Type> orderOfModifiers;

  /// Applies styling to [builder] with inheritance and state management.
  ///
  /// Merges inherited and local styles before applying them to the widget
  /// built by [builder]. Handles widget state variants automatically.
  @Deprecated('Use SpecBuilder directly for better clarity')
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

/// Builds widgets with styling and interactive state management.
///
/// Processes styles through [MixBuilder] and automatically wraps widgets
/// with [Interactable] when interactive variants are present. Use this for
/// widgets requiring interactive states (hover, press, focus) or custom
/// [WidgetStatesController] management.
class SpecBuilder extends StatelessWidget {
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

  /// Function that builds the widget content.
  final Widget Function(BuildContext) builder;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  /// Style to apply to the widget.
  final Style style;

  /// Whether to inherit style from parent widgets.
  final bool inherit;

  /// Order in which modifiers should be applied.
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    Widget current = MixBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: builder,
    );

    final needsWidgetState =
        _hasWidgetStateVariant && MixWidgetState.of(context) == null;

    if (needsWidgetState || controller != null) {
      current = Interactable(controller: controller, child: current);
    }

    return current;
  }
}
