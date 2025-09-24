import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'box_spec.dart';
import 'box_style.dart';

/// A styled box widget using Mix framework.
///
/// Applies [BoxSpec] styling to create a customized [Container].
class Box extends StyleWidget<BoxSpec> {
  const Box({
    super.style = const BoxStyler.create(),
    super.spec,
    super.key,
    this.child,
  });


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

/// Extension to convert [BoxSpec] directly to a [Box] widget.
extension BoxSpecWidget on BoxSpec {
  /// Creates a [Box] widget from this [BoxSpec].
  @Deprecated('Use Box(spec: this, child: child) instead')
  Widget createWidget({Widget? child}) {
    return Box(spec: this, child: child);
  }

  @Deprecated('Use Box(spec: this, child: child) instead')
  Widget call({Widget? child}) {
    return Box(spec: this, child: child);
  }
}

extension BoxSpecWrappedWidget on StyleSpec<BoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<BoxSpec>] with context.
  @Deprecated(
    'Use StyleSpecBuilder directly for custom logic, or styleSpec(child: child) for simple cases',
  )
  Widget createWidget({Widget? child}) {
    return StyleSpecBuilder<BoxSpec>(builder: (context, spec) {
      return Box(spec: spec, child: child);
    }, styleSpec: this);
  }

  /// Convenient shorthand for creating a Box widget with this StyleSpec.
  Widget call({Widget? child}) {
    return StyleSpecBuilder<BoxSpec>(builder: (context, spec) {
      return Box(spec: spec, child: child);
    }, styleSpec: this);
  }
}
