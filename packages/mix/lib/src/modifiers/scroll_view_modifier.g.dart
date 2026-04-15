// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_view_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$ScrollViewModifierMethods
    on WidgetModifier<ScrollViewModifier>, Diagnosticable {
  Clip? get clipBehavior;
  EdgeInsetsGeometry? get padding;
  ScrollPhysics? get physics;
  bool? get reverse;
  Axis? get scrollDirection;

  @override
  ScrollViewModifier copyWith({
    Clip? clipBehavior,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool? reverse,
    Axis? scrollDirection,
  }) {
    return ScrollViewModifier(
      clipBehavior: clipBehavior ?? this.clipBehavior,
      padding: padding ?? this.padding,
      physics: physics ?? this.physics,
      reverse: reverse ?? this.reverse,
      scrollDirection: scrollDirection ?? this.scrollDirection,
    );
  }

  @override
  ScrollViewModifier lerp(ScrollViewModifier? other, double t) {
    if (other == null) return this as ScrollViewModifier;

    return ScrollViewModifier(
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
      padding: MixOps.lerp(padding, other.padding, t),
      physics: MixOps.lerpSnap(physics, other.physics, t),
      reverse: MixOps.lerpSnap(reverse, other.reverse, t),
      scrollDirection: MixOps.lerpSnap(
        scrollDirection,
        other.scrollDirection,
        t,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('physics', physics))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection));
  }

  @override
  List<Object?> get props => [
    clipBehavior,
    padding,
    physics,
    reverse,
    scrollDirection,
  ];
}

class ScrollViewModifierMix extends ModifierMix<ScrollViewModifier>
    with Diagnosticable {
  final Prop<Clip>? clipBehavior;
  final Prop<EdgeInsetsGeometry>? padding;
  final Prop<ScrollPhysics>? physics;
  final Prop<bool>? reverse;
  final Prop<Axis>? scrollDirection;

  const ScrollViewModifierMix.create({
    this.clipBehavior,
    this.padding,
    this.physics,
    this.reverse,
    this.scrollDirection,
  });

  ScrollViewModifierMix({
    Clip? clipBehavior,
    EdgeInsetsGeometryMix? padding,
    ScrollPhysics? physics,
    bool? reverse,
    Axis? scrollDirection,
  }) : this.create(
         clipBehavior: Prop.maybe(clipBehavior),
         padding: Prop.maybeMix(padding),
         physics: Prop.maybe(physics),
         reverse: Prop.maybe(reverse),
         scrollDirection: Prop.maybe(scrollDirection),
       );

  @override
  ScrollViewModifier resolve(BuildContext context) {
    return ScrollViewModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
      padding: MixOps.resolve(context, padding),
      physics: MixOps.resolve(context, physics),
      reverse: MixOps.resolve(context, reverse),
      scrollDirection: MixOps.resolve(context, scrollDirection),
    );
  }

  @override
  ScrollViewModifierMix merge(ScrollViewModifierMix? other) {
    if (other == null) return this;

    return ScrollViewModifierMix.create(
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
      padding: MixOps.merge(padding, other.padding),
      physics: MixOps.merge(physics, other.physics),
      reverse: MixOps.merge(reverse, other.reverse),
      scrollDirection: MixOps.merge(scrollDirection, other.scrollDirection),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('physics', physics))
      ..add(DiagnosticsProperty('reverse', reverse))
      ..add(DiagnosticsProperty('scrollDirection', scrollDirection));
  }

  @override
  List<Object?> get props => [
    clipBehavior,
    padding,
    physics,
    reverse,
    scrollDirection,
  ];
}
