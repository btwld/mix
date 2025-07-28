import 'package:flutter/widgets.dart';

import 'spec.dart';
import 'style.dart';
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
  const StyleWidget({required this.style, super.key});

  /// The style to apply to this widget.
  final Style<S>? style;

  @override
  State<StyleWidget<S>> createState() => _StyleWidgetState<S>();

  Widget build(BuildContext context, S? spec);
}

class _StyleWidgetState<S extends Spec<S>> extends State<StyleWidget<S>> {
  @override
  Widget build(BuildContext context) {
    return StyleBuilder<S>(style: widget.style, builder: widget.build);
  }
}
