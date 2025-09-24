import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'box_spec.dart';

/// A styled box widget using Mix framework.
///
/// Applies [BoxSpec] styling to create a customized [Container].
class Box extends StyleWidget<BoxSpec> {
  const Box({super.style, super.styleSpec, super.key, this.child});

  /// Builder pattern for `StyleSpec<BoxSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<BoxSpec> styleSpec,
    Widget Function(BuildContext context, BoxSpec spec) builder,
  ) {
    return StyleSpecBuilder<BoxSpec>(builder: builder, styleSpec: styleSpec);
  }

  /// Child widget to display inside the box.
  final Widget? child;

  @override
  Widget build(BuildContext context, BoxSpec spec) {
    return Container(
      alignment: spec.alignment,
      padding: spec.padding,
      decoration: spec.decoration,
      foregroundDecoration: spec.foregroundDecoration,
      constraints: spec.constraints,
      margin: spec.margin,
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior ?? Clip.none,
      child: child,
    );
  }
}

/// Alias for [Box] widget for backward compatibility.
typedef StyledContainer = Box;


extension BoxSpecWrappedWidget on StyleSpec<BoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<BoxSpec>] with context.
  @Deprecated(
    'Use Box.builder(styleSpec, builder) for custom logic, or styleSpec(child: child) for simple cases',
  )
  Widget createWidget({Widget? child}) {
    return Box.builder(this, (context, spec) {
      return Box(styleSpec: StyleSpec(spec: spec), child: child);
    });
  }

  /// Convenient shorthand for creating a Box widget with this StyleSpec.
  Widget call({Widget? child}) {
    return Box(styleSpec: this, child: child);
  }
}
