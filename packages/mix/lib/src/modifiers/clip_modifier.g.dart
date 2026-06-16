// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$ClipOvalModifier
    implements WidgetModifier<ClipOvalModifier>, Diagnosticable {
  CustomClipper<Rect>? get clipper;
  Clip get clipBehavior;

  @override
  Type get type => ClipOvalModifier;

  @override
  ClipOvalModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipOvalModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipOvalModifier lerp(ClipOvalModifier? other, double t) {
    return ClipOvalModifier(
      clipper: MixOps.lerpSnap(clipper, other?.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipOvalModifier &&
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
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class ClipOvalModifierMix extends ModifierMix<ClipOvalModifier>
    with Diagnosticable {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipOvalModifierMix.create({this.clipper, this.clipBehavior});

  ClipOvalModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  @override
  ClipOvalModifier resolve(BuildContext context) {
    return ClipOvalModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ClipOvalModifierMix merge(ClipOvalModifierMix? other) {
    if (other == null) return this;

    return ClipOvalModifierMix.create(
      clipper: MixOps.merge(clipper, other.clipper),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

mixin _$ClipRectModifier
    implements WidgetModifier<ClipRectModifier>, Diagnosticable {
  CustomClipper<Rect>? get clipper;
  Clip get clipBehavior;

  @override
  Type get type => ClipRectModifier;

  @override
  ClipRectModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRectModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipRectModifier lerp(ClipRectModifier? other, double t) {
    return ClipRectModifier(
      clipper: MixOps.lerpSnap(clipper, other?.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipRectModifier &&
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
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class ClipRectModifierMix extends ModifierMix<ClipRectModifier>
    with Diagnosticable {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRectModifierMix.create({this.clipper, this.clipBehavior});

  ClipRectModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  @override
  ClipRectModifier resolve(BuildContext context) {
    return ClipRectModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ClipRectModifierMix merge(ClipRectModifierMix? other) {
    if (other == null) return this;

    return ClipRectModifierMix.create(
      clipper: MixOps.merge(clipper, other.clipper),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

mixin _$ClipRRectModifier
    implements WidgetModifier<ClipRRectModifier>, Diagnosticable {
  BorderRadiusGeometry get borderRadius;
  CustomClipper<RRect>? get clipper;
  Clip get clipBehavior;

  @override
  Type get type => ClipRRectModifier;

  @override
  ClipRRectModifier copyWith({
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRRectModifier(
      borderRadius: borderRadius ?? this.borderRadius,
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipRRectModifier lerp(ClipRRectModifier? other, double t) {
    return ClipRRectModifier(
      borderRadius: MixOps.lerp(borderRadius, other?.borderRadius, t),
      clipper: MixOps.lerpSnap(clipper, other?.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipRRectModifier &&
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
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class ClipRRectModifierMix extends ModifierMix<ClipRRectModifier>
    with Diagnosticable {
  final Prop<BorderRadiusGeometry>? borderRadius;
  final Prop<CustomClipper<RRect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRRectModifierMix.create({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  ClipRRectModifierMix({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         clipper: Prop.maybe(clipper),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  @override
  ClipRRectModifier resolve(BuildContext context) {
    return ClipRRectModifier(
      borderRadius: MixOps.resolve(context, borderRadius),
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ClipRRectModifierMix merge(ClipRRectModifierMix? other) {
    if (other == null) return this;

    return ClipRRectModifierMix.create(
      borderRadius: MixOps.merge(borderRadius, other.borderRadius),
      clipper: MixOps.merge(clipper, other.clipper),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

mixin _$ClipPathModifier
    implements WidgetModifier<ClipPathModifier>, Diagnosticable {
  CustomClipper<Path>? get clipper;
  Clip get clipBehavior;

  @override
  Type get type => ClipPathModifier;

  @override
  ClipPathModifier copyWith({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipPathModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipPathModifier lerp(ClipPathModifier? other, double t) {
    return ClipPathModifier(
      clipper: MixOps.lerpSnap(clipper, other?.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipPathModifier &&
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
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class ClipPathModifierMix extends ModifierMix<ClipPathModifier>
    with Diagnosticable {
  final Prop<CustomClipper<Path>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipPathModifierMix.create({this.clipper, this.clipBehavior});

  ClipPathModifierMix({CustomClipper<Path>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  @override
  ClipPathModifier resolve(BuildContext context) {
    return ClipPathModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ClipPathModifierMix merge(ClipPathModifierMix? other) {
    if (other == null) return this;

    return ClipPathModifierMix.create(
      clipper: MixOps.merge(clipper, other.clipper),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

mixin _$ClipTriangleModifier
    implements WidgetModifier<ClipTriangleModifier>, Diagnosticable {
  Clip get clipBehavior;

  @override
  Type get type => ClipTriangleModifier;

  @override
  ClipTriangleModifier copyWith({Clip? clipBehavior}) {
    return ClipTriangleModifier(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipTriangleModifier lerp(ClipTriangleModifier? other, double t) {
    return ClipTriangleModifier(
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipTriangleModifier &&
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
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

class ClipTriangleModifierMix extends ModifierMix<ClipTriangleModifier>
    with Diagnosticable {
  final Prop<Clip>? clipBehavior;

  const ClipTriangleModifierMix.create({this.clipBehavior});

  ClipTriangleModifierMix({Clip? clipBehavior})
    : this.create(clipBehavior: Prop.maybe(clipBehavior));

  @override
  ClipTriangleModifier resolve(BuildContext context) {
    return ClipTriangleModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  @override
  ClipTriangleModifierMix merge(ClipTriangleModifierMix? other) {
    if (other == null) return this;

    return ClipTriangleModifierMix.create(
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipBehavior];
}
