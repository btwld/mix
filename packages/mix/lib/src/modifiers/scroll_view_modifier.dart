import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

final class ScrollViewWidgetModifier
    extends WidgetModifier<ScrollViewWidgetModifier> {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  const ScrollViewWidgetModifier({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  ScrollViewWidgetModifier copyWith({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) {
    return ScrollViewWidgetModifier(
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      padding: padding ?? this.padding,
      physics: physics ?? this.physics,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ScrollViewWidgetModifier lerp(ScrollViewWidgetModifier? other, double t) {
    if (other == null) return this;

    return ScrollViewWidgetModifier(
      scrollDirection: MixOps.lerpSnap(
        scrollDirection,
        other.scrollDirection,
        t,
      ),
      reverse: MixOps.lerpSnap(reverse, other.reverse, t),
      padding: MixOps.lerp(padding, other.padding, t),
      physics: MixOps.lerpSnap(physics, other.physics, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [
    scrollDirection,
    reverse,
    padding,
    physics,
    clipBehavior,
  ];

  @override
  Widget build(Widget child) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection ?? Axis.vertical,
      reverse: reverse ?? false,
      padding: padding,
      physics: physics,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}

final class ScrollViewWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, ScrollViewWidgetModifierMix> {
  /// Set the padding of the scroll view.
  late final padding = EdgeInsetsGeometryUtility(
    (padding) => only(padding: padding),
  );

  /// Set the clip behavior of the scroll view.
  late final clipBehavior = MixUtility<T, Clip>(
    (clip) => only(clipBehavior: clip),
  );

  ScrollViewWidgetModifierUtility(super.builder);

  /// Make the scroll view reverse or not.
  T reverse(bool v) => only(reverse: v);

  /// Set the scroll direction of the scroll view.
  T direction(Axis axis) => only(scrollDirection: axis);

  /// Set the scroll direction of the scroll view to horizontal.
  T horizontal() => only(scrollDirection: Axis.horizontal);

  /// Set the scroll direction of the scroll view to vertical.
  T vertical() => only(scrollDirection: Axis.vertical);

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
  }) => builder(
    ScrollViewWidgetModifierMix(
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

class ScrollViewWidgetModifierMix
    extends WidgetModifierMix<ScrollViewWidgetModifier> {
  final Prop<Axis>? scrollDirection;
  final Prop<bool>? reverse;
  final MixProp<EdgeInsetsGeometry>? padding;
  final Prop<ScrollPhysics>? physics;
  final Prop<Clip>? clipBehavior;

  const ScrollViewWidgetModifierMix.create({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  ScrollViewWidgetModifierMix({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometryMix? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) : this.create(
         scrollDirection: Prop.maybe(scrollDirection),
         reverse: Prop.maybe(reverse),
         padding: MixProp.maybe(padding),
         physics: Prop.maybe(physics),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  @override
  ScrollViewWidgetModifier resolve(BuildContext context) {
    return ScrollViewWidgetModifier(
      scrollDirection: MixOps.resolve(context, scrollDirection),
      reverse: MixOps.resolve(context, reverse),
      padding: MixOps.resolve(context, padding),
      physics: MixOps.resolve(context, physics),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ScrollViewWidgetModifierMix merge(ScrollViewWidgetModifierMix? other) {
    if (other == null) return this;

    return ScrollViewWidgetModifierMix.create(
      scrollDirection: scrollDirection.tryMerge(other.scrollDirection),
      reverse: reverse.tryMerge(other.reverse),
      padding: padding.tryMerge(other.padding),
      physics: physics.tryMerge(other.physics),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [
    scrollDirection,
    reverse,
    padding,
    physics,
    clipBehavior,
  ];
}
