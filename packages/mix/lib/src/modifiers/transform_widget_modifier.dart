// ignore_for_file: prefer-named-boolean-parameters

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'transform_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class TransformModifierSpec
    extends WidgetModifierSpec<TransformModifierSpec>
    with _$TransformModifierSpec, Diagnosticable {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformModifierSpec({this.transform, this.alignment});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  Widget build(Widget child) {
    return Transform(
      transform: transform ?? Matrix4.identity(),
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }
}

final class TransformModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, TransformModifierSpecAttribute> {
  late final rotate = TransformRotateModifierSpecUtility(
    (value) => builder(
      TransformModifierSpecAttribute(
        transform: value,
        alignment: Alignment.center,
      ),
    ),
  );

  TransformModifierSpecUtility(super.builder);

  T _flip(bool x, bool y) => builder(
        TransformModifierSpecAttribute(
          transform: Matrix4.diagonal3Values(
            x ? -1.0 : 1.0,
            y ? -1.0 : 1.0,
            1.0,
          ),
          alignment: Alignment.center,
        ),
      );

  T flipX() => _flip(true, false);
  T flipY() => _flip(false, true);

  T call(Matrix4 value) =>
      builder(TransformModifierSpecAttribute(transform: value));

  T scale(double value) => builder(
        TransformModifierSpecAttribute(
          transform: Matrix4.diagonal3Values(value, value, 1.0),
          alignment: Alignment.center,
        ),
      );

  T translate(double x, double y) => builder(
        TransformModifierSpecAttribute(
          transform: Matrix4.translationValues(x, y, 0.0),
          alignment: Alignment.center,
        ),
      );
}

final class TransformRotateModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, Matrix4> {
  const TransformRotateModifierSpecUtility(super.builder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => builder(Matrix4.rotationZ(value));
}
