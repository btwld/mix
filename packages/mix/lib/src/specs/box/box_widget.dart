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
  const Box({super.style = const BoxStyler.create(), super.key, this.child});

  /// Child widget to display inside the box.
  final Widget? child;

  @override
  Widget build(BuildContext context, BoxSpec spec) {
    return _createBoxSpecWidget(spec: spec, child: child);
  }
}

/// Creates a [Container] widget from a [BoxSpec].
Container _createBoxSpecWidget({required BoxSpec spec, Widget? child}) {
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

/// Alias for [Box] widget for backward compatibility.
typedef StyledContainer = Box;

/// Extension to convert [BoxSpec] directly to a [Container] widget.
extension BoxSpecWidget on BoxSpec {
  /// Creates a [Container] widget from this [BoxSpec].
  Container createWidget({Widget? child}) {
    return _createBoxSpecWidget(spec: this, child: child);
  }

  @Deprecated('Use .createWidget() instead')
  Container call({Widget? child}) {
    return createWidget(child: child);
  }
}

extension BoxSpecWrappedWidget on StyleSpec<BoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<BoxSpec>] with context.
  Widget createWidget({Widget? child}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createBoxSpecWidget(spec: spec, child: child);
      },
      styleSpec: this,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({Widget? child}) {
    return createWidget(child: child);
  }
}
