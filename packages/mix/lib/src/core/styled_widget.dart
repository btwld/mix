import 'package:flutter/widgets.dart';

import 'factory/style_mix.dart';
import 'spec.dart';
import 'style_builder.dart';

/// Base class for widgets that apply [Style] definitions.
///
/// Provides automatic style inheritance from parent [StyleWidget]s and handles
/// style application through the Mix framework. Extend this class to
/// create widgets that can be styled using Mix.
///
/// Generic type [S] must extend [Spec<S>] to ensure type safety.
abstract class StyleWidget<S extends Spec<S>> extends StatefulWidget {
  /// Creates a styled widget.
  const StyleWidget({
    required this.style,
    super.key,
    this.orderOfModifiers,
    this.controller,
  });

  /// The style to apply to this widget.
  final Style<S> style;

  /// The order in which modifiers should be applied.
  final List<Type>? orderOfModifiers;

  /// Optional controller for managing widget state.
  final WidgetStatesController? controller;

  @override
  State<StyleWidget<S>> createState() => _StyleWidgetState<S>();

  Widget build(BuildContext context, ResolvedStyle<S> style);
}

class _StyleWidgetState<S extends Spec<S>> extends State<StyleWidget<S>> {
  @override
  Widget build(BuildContext context) {
    return StyleBuilder<S>(
      style: widget.style,
      builder: widget.build,
      orderOfModifiers: widget.orderOfModifiers,
      controller: widget.controller,
    );
  }
}
