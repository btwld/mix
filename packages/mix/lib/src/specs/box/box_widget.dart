import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import 'box_attribute.dart';
import 'box_spec.dart';

/// A styled container widget using Mix framework.
///
/// Applies [BoxWidgetSpec] styling to create a customized [Container].
class Box extends StyleWidget<BoxWidgetSpec> {
  const Box({super.style = const BoxStyle.create(), super.key, this.child});

  /// Child widget to display inside the box.
  final Widget? child;

  @override
  Widget build(BuildContext context, BoxWidgetSpec spec) {
    return createBoxSpecWidget(spec: spec, child: child);
  }
}

/// Creates a [Container] widget from a [BoxWidgetSpec].
Container createBoxSpecWidget({required BoxWidgetSpec spec, Widget? child}) {
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

/// Extension to convert [BoxWidgetSpec] directly to a [Container] widget.
extension BoxSpecWidget on BoxWidgetSpec {
  Container call({Widget? child}) {
    return createBoxSpecWidget(spec: this, child: child);
  }
}
