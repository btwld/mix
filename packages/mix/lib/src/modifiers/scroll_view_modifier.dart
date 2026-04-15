import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

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

final class ScrollViewModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, ScrollViewModifierMix> {
  /// Set the padding of the scroll view.
  late final padding = EdgeInsetsGeometryUtility(
    (padding) => only(padding: padding),
  );

  /// Set the clip behavior of the scroll view.
  late final clipBehavior = MixUtility<T, Clip>(
    (clip) => only(clipBehavior: clip),
  );

  ScrollViewModifierUtility(super.utilityBuilder);

  /// Make the scroll view reverse or not.
  T reverse(bool v) => only(reverse: v);

  /// Set the scroll direction of the scroll view.
  T direction(Axis axis) => only(scrollDirection: axis);

  /// Set the scroll direction of the scroll view to horizontal.
  T horizontal() => only(scrollDirection: .horizontal);

  /// Set the scroll direction of the scroll view to vertical.
  T vertical() => only(scrollDirection: .vertical);

  /// Set the physics of the scroll view.
  T physics(ScrollPhysics physics) => only(physics: physics);

  /// Disable the scroll physics of the scroll view.
  T neverScrollableScrollPhysics() =>
      physics(const NeverScrollableScrollPhysics());

  /// Set the iOS-style scroll physics of the scroll view.
  T bouncingScrollPhysics() => physics(const BouncingScrollPhysics());

  /// Set the Android-style scroll physics of the scroll view.
  T clampingScrollPhysics() => physics(const ClampingScrollPhysics());

  T only({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometryMix? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) => utilityBuilder(
    ScrollViewModifierMix(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      physics: physics,
      clipBehavior: clipBehavior,
    ),
  );

  T call({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) {
    return only(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: EdgeInsetsGeometryMix.maybeValue(padding),
      physics: physics,
      clipBehavior: clipBehavior,
    );
  }
}
