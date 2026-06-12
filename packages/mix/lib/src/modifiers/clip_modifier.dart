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
final class ClipOvalModifier with _$ClipOvalModifier {
  @override
  final CustomClipper<Rect>? clipper;
  @override
  final Clip clipBehavior;

  const ClipOvalModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

  @override
  Widget build(Widget child) {
    return ClipOval(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Modifier that clips its child to a rectangular shape.
///
/// Wraps the child in a [ClipRect] widget with the specified clipper and clip behavior.
@MixableModifier()
final class ClipRectModifier with _$ClipRectModifier {
  @override
  final CustomClipper<Rect>? clipper;
  @override
  final Clip clipBehavior;

  const ClipRectModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .hardEdge;

  @override
  Widget build(Widget child) {
    return ClipRect(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Modifier that clips its child to a rounded rectangular shape.
///
/// Wraps the child in a [ClipRRect] widget with the specified border radius.
@MixableModifier()
final class ClipRRectModifier with _$ClipRRectModifier {
  @override
  final BorderRadiusGeometry borderRadius;
  @override
  final CustomClipper<RRect>? clipper;
  @override
  final Clip clipBehavior;

  const ClipRRectModifier({
    BorderRadiusGeometry? borderRadius,
    this.clipper,
    Clip? clipBehavior,
  }) : borderRadius = borderRadius ?? BorderRadius.zero,
       clipBehavior = clipBehavior ?? .antiAlias;

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
final class ClipPathModifier with _$ClipPathModifier {
  @override
  final CustomClipper<Path>? clipper;
  @override
  final Clip clipBehavior;

  const ClipPathModifier({this.clipper, Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

  @override
  Widget build(Widget child) {
    return ClipPath(clipper: clipper, clipBehavior: clipBehavior, child: child);
  }
}

/// Modifier that clips its child to a triangle shape.
///
/// Wraps the child in a [ClipPath] widget using a triangle clipper.
@MixableModifier()
final class ClipTriangleModifier with _$ClipTriangleModifier {
  @override
  final Clip clipBehavior;

  const ClipTriangleModifier({Clip? clipBehavior})
    : clipBehavior = clipBehavior ?? .antiAlias;

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
