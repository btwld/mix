// ignore_for_file: prefer-named-boolean-parameters

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/factory/mix_context.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/spec.dart';
import '../core/utility.dart';

final class TransformModifierSpec
    extends WidgetModifierSpec<TransformModifierSpec>
    with Diagnosticable {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformModifierSpec({this.transform, this.alignment});

  @override
  TransformModifierSpec copyWith({Matrix4? transform, Alignment? alignment}) {
    return TransformModifierSpec(
      transform: transform ?? this.transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TransformModifierSpec lerp(TransformModifierSpec? other, double t) {
    if (other == null) return this;

    return TransformModifierSpec(
      transform: MixHelpers.lerpMatrix4(transform, other.transform, t),
      alignment: Alignment.lerp(alignment, other.alignment, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [transform, alignment];

  @override
  Widget build(Widget child) {
    return Transform(
      transform: transform ?? Matrix4.identity(),
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }
}

final class TransformModifierSpecUtility<T extends SpecAttribute>
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
      transform: Matrix4.diagonal3Values(x ? -1.0 : 1.0, y ? -1.0 : 1.0, 1.0),
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

final class TransformRotateModifierSpecUtility<T extends SpecAttribute>
    extends MixUtility<T, Matrix4> {
  const TransformRotateModifierSpecUtility(super.builder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => builder(Matrix4.rotationZ(value));
}

class TransformModifierSpecAttribute
    extends WidgetModifierSpecAttribute<TransformModifierSpec> {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformModifierSpecAttribute({this.transform, this.alignment});

  @override
  TransformModifierSpec resolve(MixContext context) {
    return TransformModifierSpec(transform: transform, alignment: alignment);
  }

  @override
  TransformModifierSpecAttribute merge(TransformModifierSpecAttribute? other) {
    if (other == null) return this;

    return TransformModifierSpecAttribute(
      transform: other.transform ?? transform,
      alignment: other.alignment ?? alignment,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [transform, alignment];
}

class TransformModifierSpecTween extends Tween<TransformModifierSpec?> {
  TransformModifierSpecTween({super.begin, super.end});

  @override
  TransformModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const TransformModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
