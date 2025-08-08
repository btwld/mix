import 'package:flutter/widgets.dart';

import 'spec.dart';
import 'style.dart';
import 'style_builder.dart';

/// Base widget for applying Mix styles to Flutter widgets.
/// 
/// Provides style application and inheritance through the Mix framework.
/// Type [S] must extend [Spec<S>] for type-safe styling.
abstract class StyleWidget<S extends Spec<S>> extends StatefulWidget {
  /// Creates a [StyleWidget] with optional [style].
  const StyleWidget({required this.style, super.key});

  /// Style to apply to this widget.
  final Style<S>? style;

  @override
  State<StyleWidget<S>> createState() => _StyleWidgetState<S>();

  /// Builds the widget with the resolved [spec].
  Widget build(BuildContext context, S? spec);
}

class _StyleWidgetState<S extends Spec<S>> extends State<StyleWidget<S>> {
  @override
  Widget build(BuildContext context) {
    return StyleBuilder<S>(style: widget.style, builder: widget.build);
  }
}
