import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

/// Modifier that applies scroll view properties to its child.
///
/// Wraps the child in a scrollable widget with the specified properties.
final class ScrollViewModifier extends WidgetModifier<ScrollViewModifier>
    with Diagnosticable {
  final Axis? scrollDirection;
  final bool? reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Clip? clipBehavior;

  const ScrollViewModifier({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  @override
  ScrollViewModifier copyWith({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) {
    return ScrollViewModifier(
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      padding: padding ?? this.padding,
      physics: physics ?? this.physics,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ScrollViewModifier lerp(ScrollViewModifier? other, double t) {
    if (other == null) return this;

    return ScrollViewModifier(
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('physics', physics))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
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

class ScrollViewModifierMix extends ModifierMix<ScrollViewModifier>
    with Diagnosticable {
  final Prop<Axis>? scrollDirection;
  final Prop<bool>? reverse;
  final Prop<EdgeInsetsGeometry>? padding;
  final Prop<ScrollPhysics>? physics;
  final Prop<Clip>? clipBehavior;

  const ScrollViewModifierMix.create({
    this.scrollDirection,
    this.reverse,
    this.padding,
    this.physics,
    this.clipBehavior,
  });

  ScrollViewModifierMix({
    Axis? scrollDirection,
    bool? reverse,
    EdgeInsetsGeometryMix? padding,
    ScrollPhysics? physics,
    Clip? clipBehavior,
  }) : this.create(
         scrollDirection: Prop.maybe(scrollDirection),
         reverse: Prop.maybe(reverse),
         padding: Prop.maybeMix(padding),
         physics: Prop.maybe(physics),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  @override
  ScrollViewModifier resolve(BuildContext context) {
    return ScrollViewModifier(
      scrollDirection: MixOps.resolve(context, scrollDirection),
      reverse: MixOps.resolve(context, reverse),
      padding: MixOps.resolve(context, padding),
      physics: MixOps.resolve(context, physics),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ScrollViewModifierMix merge(ScrollViewModifierMix? other) {
    if (other == null) return this;

    return ScrollViewModifierMix.create(
      scrollDirection: MixOps.merge(scrollDirection, other.scrollDirection),
      reverse: MixOps.merge(reverse, other.reverse),
      padding: MixOps.merge(padding, other.padding),
      physics: MixOps.merge(physics, other.physics),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('scrollDirection', scrollDirection))
      ..add(DiagnosticsProperty('reverse', reverse))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('physics', physics))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior));
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
