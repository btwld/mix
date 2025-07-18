import 'package:flutter/widgets.dart';

import '../widgets/pressable_widget.dart';
import 'factory/style_mix.dart';
import 'internal/experimental/mix_builder.dart';
import 'variant.dart';
import 'widget_state/widget_state_controller.dart';

/// Base class for widgets that apply [Style] definitions.
///
/// Provides style inheritance from parent [StyledWidget]s and handles
/// style application through the Mix framework. Extend this class to
/// create widgets that can be styled using Mix.

abstract class StyledWidget extends StatelessWidget {
  /// Creates a styled widget.
  const StyledWidget({
    StyleElement? style,
    super.key,
    this.inherit = false,
    required this.orderOfModifiers,
  }) : style = style ?? const Style.empty();

  /// The style to apply to this widget.
  final StyleElement style;

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
/// SpecBuilder wraps [MixBuilder] internally and adds interactive state
/// management capabilities. It automatically detects widget state variants
/// and wraps widgets with [Interactable] when needed.
///
/// ## Architecture
///
/// SpecBuilder follows a layered approach:
/// 1. **Core**: Uses [MixBuilder] for style processing and caching
/// 2. **Enhancement**: Adds widget state detection and Interactable wrapping
/// 3. **Optimization**: Smart caching that respects widget state variants
///
/// ## Usage
///
/// Use SpecBuilder for widgets requiring interactive states (hover, press, focus)
/// or custom [WidgetStatesController] management.
///
/// ```dart
/// SpecBuilder(
///   style: Style(
///     $box.color.red(),
///     $on.hover($box.color.blue()),
///   ),
///   builder: (context) => BoxSpec.of(context)(),
/// )
/// ```
class SpecBuilder extends StatefulWidget {
  const SpecBuilder({
    super.key,
    this.inherit = false,
    this.controller,
    this.style = const Style.empty(),
    this.orderOfModifiers = const [],
    required this.builder,
  });

  /// Function that builds the widget content.
  final Widget Function(BuildContext) builder;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  /// Style to apply to the widget.
  final StyleElement style;

  /// Whether to inherit style from parent widgets.
  final bool inherit;

  /// Order in which modifiers should be applied.
  ///
  /// Defaults to an empty list, which uses the default modifier order.
  final List<Type>? orderOfModifiers;

  @override
  State<SpecBuilder> createState() => _SpecBuilderState();
}

class _SpecBuilderState extends State<SpecBuilder> {
  late final WidgetStatesController _controller;

  /// Checks if the style contains widget state variants that require
  /// interactive state management.
  bool get _hasWidgetStateVariant => widget.style.variants.any(
    (variantAttribute) => variantAttribute.variant is WidgetStateVariant,
  );

  /// Determines if we should wrap with Interactable widget.
  bool get _shouldWrapWithInteractable =>
      _hasWidgetStateVariant || widget.controller != null;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  @override
  void dispose() {
    // Only dispose controllers we created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builder = MixBuilder(
      style: widget.style,
      builder: widget.builder,
      inherit: widget.inherit,
      orderOfModifiers: widget.orderOfModifiers ?? [],
    );

    if (_shouldWrapWithInteractable &&
        MixWidgetStateModel.of(context) == null) {
      return Interactable(controller: widget.controller, child: builder);
    }

    return builder;
  }
}
