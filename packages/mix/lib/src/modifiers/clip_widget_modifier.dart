// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/border/border_radius_dto.dart';
import '../core/element.dart';
import '../core/factory/mix_context.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'clip_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ClipOvalModifierSpec
    extends WidgetModifierSpec<ClipOvalModifierSpec>
    with _$ClipOvalModifierSpec, Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalModifierSpec({this.clipper, this.clipBehavior});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return ClipOval(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ClipRectModifierSpec
    extends WidgetModifierSpec<ClipRectModifierSpec>
    with _$ClipRectModifierSpec, Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectModifierSpec({this.clipper, this.clipBehavior});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return ClipRect(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ClipRRectModifierSpec
    extends WidgetModifierSpec<ClipRRectModifierSpec>
    with _$ClipRRectModifierSpec, Diagnosticable {
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectModifierSpec({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ClipPathModifierSpec
    extends WidgetModifierSpec<ClipPathModifierSpec>
    with _$ClipPathModifierSpec, Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathModifierSpec({this.clipper, this.clipBehavior});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return ClipPath(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class ClipTriangleModifierSpec
    extends WidgetModifierSpec<ClipTriangleModifierSpec>
    with _$ClipTriangleModifierSpec, Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleModifierSpec({this.clipBehavior});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return ClipPath(
      clipper: const TriangleClipper(),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
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

final class ClipPathModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ClipPathModifierSpecAttribute> {
  const ClipPathModifierSpecUtility(super.builder);

  T call({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipRRectModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ClipRRectModifierSpecAttribute> {
  const ClipRRectModifierSpecUtility(super.builder);
  T call({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectModifierSpecAttribute(
        borderRadius: borderRadius?.toDto(),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipOvalModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ClipOvalModifierSpecAttribute> {
  const ClipOvalModifierSpecUtility(super.builder);
  T call({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipRectModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ClipRectModifierSpecAttribute> {
  const ClipRectModifierSpecUtility(super.builder);
  T call({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipTriangleModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, ClipTriangleModifierSpecAttribute> {
  const ClipTriangleModifierSpecUtility(super.builder);
  T call({Clip? clipBehavior}) {
    return builder(
      ClipTriangleModifierSpecAttribute(clipBehavior: clipBehavior),
    );
  }
}
