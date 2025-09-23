import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'box_spec.dart';

/// A styled box widget using Mix framework.
///
/// Applies [BoxSpec] styling to create a customized [Container].
class Box extends StyleWidget<BoxSpec> {
  /// Child widget to display inside the box.
  final Widget? child;

  const Box({super.style, super.spec, super.key, this.child});

  /// Builder pattern for StyleSpec<BoxSpec> with custom builder function.
  static Widget builder(
    StyleSpec<BoxSpec> styleSpec,
    Widget Function(BuildContext context, BoxSpec spec) builder,
  ) {
    return StyleSpecBuilder<BoxSpec>(builder: builder, styleSpec: styleSpec);
  }

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

/// Extension to convert [BoxSpec] directly to a [Box] widget.
extension BoxSpecWidget on BoxSpec {
  /// Creates a [Box] widget from this [BoxSpec].
  @Deprecated('Use Box(spec: this, child: child) instead')
  Widget createWidget({Widget? child}) {
    return Box(spec: this, child: child);
  }

  @Deprecated('Use Box(spec: this, child: child) instead')
  Widget call({Widget? child}) {
    return createWidget(child: child);
  }
}

extension BoxSpecWrappedWidget on StyleSpec<BoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<BoxSpec>] with context.
  @Deprecated(
    'Use Box.builder(styleSpec, builder) for custom logic, or styleSpec(child: child) for simple cases',
  )
  Widget createWidget({Widget? child}) {
    return Box.builder(this, (context, spec) {
      return Box(spec: spec, child: child);
    });
  }

  /// Convenient shorthand for creating a Box widget with this StyleSpec.
  Widget call({Widget? child}) {
    return createWidget(child: child);
  }
}
