// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_view_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$ScrollViewModifier
    implements WidgetModifier<ScrollViewModifier>, Diagnosticable {
  Axis? get scrollDirection;
  bool? get reverse;
  EdgeInsetsGeometry? get padding;
  ScrollPhysics? get physics;
  Clip? get clipBehavior;

  @override
  Type get type => ScrollViewModifier;

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
    return ScrollViewModifier(
      scrollDirection: MixOps.lerpSnap(
        scrollDirection,
        other?.scrollDirection,
        t,
      ),
      reverse: MixOps.lerpSnap(reverse, other?.reverse, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      physics: MixOps.lerpSnap(physics, other?.physics, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
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
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ScrollViewModifier &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  Widget build(Widget child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(EnumProperty<Axis>('scrollDirection', scrollDirection))
      ..add(FlagProperty('reverse', value: reverse, ifTrue: 'reversed'))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('physics', physics))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
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
