import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';

part 'scroll_view_modifier.g.dart';

/// Modifier that applies scroll view properties to its child.
///
/// Wraps the child in a scrollable widget with the specified properties.
@MixableModifier()
final class ScrollViewModifier extends WidgetModifier<ScrollViewModifier>
    with Diagnosticable, _$ScrollViewModifierMethods {
  @override
  final Axis? scrollDirection;
  @override
  final bool? reverse;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final ScrollPhysics? physics;
  @override
  final Clip? clipBehavior;

  const ScrollViewModifier({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  Widget build(Widget child) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection ?? .vertical,
      reverse: reverse ?? false,
      padding: padding,
      physics: physics,
      clipBehavior: clipBehavior ?? .hardEdge,
      child: child,
    );
  }
}
