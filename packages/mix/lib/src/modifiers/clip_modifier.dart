import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/painting/border_radius_mix.dart';

/// Modifier that clips its child to an oval shape.
///
/// Wraps the child in a [ClipOval] widget with the specified clipper and clip behavior.
final class ClipOvalModifier extends WidgetModifier<ClipOvalModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip clipBehavior;

  const ClipOvalModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

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
    if (other == null) return this;

    return ClipOvalModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipOval(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Mix class for applying clip oval modifications.
///
/// This class allows for mixing and resolving clip oval properties.
class ClipOvalModifierMix extends ModifierMix<ClipOvalModifier> {
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
  List<Object?> get props => [clipper, clipBehavior];
}

/// Modifier that clips its child to a rectangular shape.
///
/// Wraps the child in a [ClipRect] widget with the specified clipper and clip behavior.
final class ClipRectModifier extends WidgetModifier<ClipRectModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip clipBehavior;

  const ClipRectModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .hardEdge;

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
    if (other == null) return this;

    return ClipRectModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipRect(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Mix class for applying clip rect modifications.
///
/// This class allows for mixing and resolving clip rect properties.
class ClipRectModifierMix extends ModifierMix<ClipRectModifier> {
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
  List<Object?> get props => [clipper, clipBehavior];
}

/// Modifier that clips its child to a rounded rectangular shape.
///
/// Wraps the child in a [ClipRRect] widget with the specified border radius.
final class ClipRRectModifier extends WidgetModifier<ClipRRectModifier>
    with Diagnosticable {
  final BorderRadiusGeometry borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;

  const ClipRRectModifier({
    BorderRadiusGeometry? borderRadius,
    this.clipper,
    Clip? clipBehavior,
  }) : borderRadius = borderRadius ?? BorderRadius.zero,
       clipBehavior = clipBehavior ?? .antiAlias;

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
    if (other == null) return this;

    return ClipRRectModifier(
      borderRadius: MixOps.lerp(borderRadius, other.borderRadius, t)!,
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// Mix class for applying clip rounded rect modifications.
///
/// This class allows for mixing and resolving clip rounded rect properties.
class ClipRRectModifierMix extends ModifierMix<ClipRRectModifier> {
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
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

/// Modifier that clips its child using a custom path.
///
/// Wraps the child in a [ClipPath] widget with the specified clipper.
final class ClipPathModifier extends WidgetModifier<ClipPathModifier>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip clipBehavior;

  const ClipPathModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

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
    if (other == null) return this;

    return ClipPathModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('clipper', clipper))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipPath(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Mix class for applying clip path modifications.
///
/// This class allows for mixing and resolving clip path properties.
class ClipPathModifierMix extends ModifierMix<ClipPathModifier> {
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
  List<Object?> get props => [clipper, clipBehavior];
}

/// Modifier that clips its child to a triangle shape.
///
/// Wraps the child in a [ClipPath] widget using a triangle clipper.
final class ClipTriangleModifier extends WidgetModifier<ClipTriangleModifier>
    with Diagnosticable {
  final Clip clipBehavior;

  const ClipTriangleModifier({Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

  @override
  ClipTriangleModifier copyWith({Clip? clipBehavior}) {
    return ClipTriangleModifier(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ClipTriangleModifier lerp(ClipTriangleModifier? other, double t) {
    if (other == null) return this;

    return ClipTriangleModifier(
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipBehavior', clipBehavior));
  }

  @override
  List<Object?> get props => [clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipPath(
      clipper: const TriangleClipper(),
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

/// Mix class for applying clip triangle modifications.
///
/// This class allows for mixing and resolving clip triangle properties.
class ClipTriangleModifierMix extends ModifierMix<ClipTriangleModifier> {
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
  List<Object?> get props => [clipBehavior];
}

class TriangleClipper extends CustomClipper<Path> {
  const TriangleClipper();
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
