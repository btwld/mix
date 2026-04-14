import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/painting/border_radius_mix.dart';

part 'clip_modifier.g.dart';

/// Modifier that clips its child to an oval shape.
///
/// Wraps the child in a [ClipOval] widget with the specified clipper and clip behavior.
@MixableModifier()
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

/// Modifier that clips its child to a rectangular shape.
///
/// Wraps the child in a [ClipRect] widget with the specified clipper and clip behavior.
@MixableModifier()
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

/// Modifier that clips its child to a rounded rectangular shape.
///
/// Wraps the child in a [ClipRRect] widget with the specified border radius.
@MixableModifier()
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

/// Modifier that clips its child using a custom path.
///
/// Wraps the child in a [ClipPath] widget with the specified clipper.
@MixableModifier()
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

/// Modifier that clips its child to a triangle shape.
///
/// Wraps the child in a [ClipPath] widget using a triangle clipper.
@MixableModifier()
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
