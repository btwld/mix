// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class ClipOvalModifierMix extends ModifierMix<ClipOvalModifier>
    with Diagnosticable {
  final Prop<Clip>? clipBehavior;
  final Prop<CustomClipper<Rect>>? clipper;

  const ClipOvalModifierMix.create({this.clipBehavior, this.clipper});

  ClipOvalModifierMix({Clip? clipBehavior, CustomClipper<Rect>? clipper})
    : this.create(
        clipBehavior: Prop.maybe(clipBehavior),
        clipper: Prop.maybe(clipper),
      );

  @override
  ClipOvalModifier resolve(BuildContext context) {
    return ClipOvalModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
      clipper: MixOps.resolve(context, clipper),
    );
  }

  @override
  ClipOvalModifierMix merge(ClipOvalModifierMix? other) {
    if (other == null) return this;

    return ClipOvalModifierMix.create(
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
      clipper: MixOps.merge(clipper, other.clipper),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('clipper', clipper));
  }

  @override
  List<Object?> get props => [clipBehavior, clipper];
}

class ClipRectModifierMix extends ModifierMix<ClipRectModifier>
    with Diagnosticable {
  final Prop<Clip>? clipBehavior;
  final Prop<CustomClipper<Rect>>? clipper;

  const ClipRectModifierMix.create({this.clipBehavior, this.clipper});

  ClipRectModifierMix({Clip? clipBehavior, CustomClipper<Rect>? clipper})
    : this.create(
        clipBehavior: Prop.maybe(clipBehavior),
        clipper: Prop.maybe(clipper),
      );

  @override
  ClipRectModifier resolve(BuildContext context) {
    return ClipRectModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
      clipper: MixOps.resolve(context, clipper),
    );
  }

  @override
  ClipRectModifierMix merge(ClipRectModifierMix? other) {
    if (other == null) return this;

    return ClipRectModifierMix.create(
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
      clipper: MixOps.merge(clipper, other.clipper),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('clipper', clipper));
  }

  @override
  List<Object?> get props => [clipBehavior, clipper];
}

class ClipRRectModifierMix extends ModifierMix<ClipRRectModifier>
    with Diagnosticable {
  final Prop<BorderRadiusGeometry>? borderRadius;
  final Prop<Clip>? clipBehavior;
  final Prop<CustomClipper<RRect>>? clipper;

  const ClipRRectModifierMix.create({
    this.borderRadius,
    this.clipBehavior,
    this.clipper,
  });

  ClipRRectModifierMix({
    BorderRadiusGeometryMix? borderRadius,
    Clip? clipBehavior,
    CustomClipper<RRect>? clipper,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         clipBehavior: Prop.maybe(clipBehavior),
         clipper: Prop.maybe(clipper),
       );

  @override
  ClipRRectModifier resolve(BuildContext context) {
    return ClipRRectModifier(
      borderRadius: MixOps.resolve(context, borderRadius),
      clipBehavior: MixOps.resolve(context, clipBehavior),
      clipper: MixOps.resolve(context, clipper),
    );
  }

  @override
  ClipRRectModifierMix merge(ClipRRectModifierMix? other) {
    if (other == null) return this;

    return ClipRRectModifierMix.create(
      borderRadius: MixOps.merge(borderRadius, other.borderRadius),
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
      clipper: MixOps.merge(clipper, other.clipper),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('clipper', clipper));
  }

  @override
  List<Object?> get props => [borderRadius, clipBehavior, clipper];
}

class ClipPathModifierMix extends ModifierMix<ClipPathModifier>
    with Diagnosticable {
  final Prop<Clip>? clipBehavior;
  final Prop<CustomClipper<Path>>? clipper;

  const ClipPathModifierMix.create({this.clipBehavior, this.clipper});

  ClipPathModifierMix({Clip? clipBehavior, CustomClipper<Path>? clipper})
    : this.create(
        clipBehavior: Prop.maybe(clipBehavior),
        clipper: Prop.maybe(clipper),
      );

  @override
  ClipPathModifier resolve(BuildContext context) {
    return ClipPathModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
      clipper: MixOps.resolve(context, clipper),
    );
  }

  @override
  ClipPathModifierMix merge(ClipPathModifierMix? other) {
    if (other == null) return this;

    return ClipPathModifierMix.create(
      clipBehavior: MixOps.merge(clipBehavior, other.clipBehavior),
      clipper: MixOps.merge(clipper, other.clipper),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipBehavior', clipBehavior))
      ..add(DiagnosticsProperty('clipper', clipper));
  }

  @override
  List<Object?> get props => [clipBehavior, clipper];
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
