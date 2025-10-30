import 'package:flutter/widgets.dart';

import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'box_spec.dart';
import 'box_style.dart';

/// [Box] is equivalent to Flutter's [Container], it provides
/// styling capabilities through the Mix framework. It can be used to
/// create visually styled boxes with decoration, padding, margins, transforms,
/// and constraints.
///
///
/// You can use [BoxStyler] to create styles with a fluent API. Example:
///
/// ```dart
/// final style = BoxStyler()
///   .width(200)
///   .height(100)
///   .color(Colors.blue)
///   .borderRounded(12)
///   .padding(16);
///
/// Box(style: style, child: Text('Hello Mix'))
/// ```
///
class Box extends StyleWidget<BoxSpec> {
  const Box({
    super.style = const BoxStyler.create(),
    super.styleSpec,
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

extension BoxSpecWrappedWidget on StyleSpec<BoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<BoxSpec>] with context.
  @Deprecated('Use Box(styleSpec: styleSpec, child: child) instead')
  Widget createWidget({Widget? child}) {
    return call(child: child);
  }

  /// Convenient shorthand for creating a Box widget with this StyleSpec.
  @Deprecated('Use Box(styleSpec: styleSpec, child: child) instead')
  Widget call({Widget? child}) {
    return Box(styleSpec: this, child: child);
  }
}
