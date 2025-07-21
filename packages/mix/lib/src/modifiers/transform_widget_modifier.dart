// ignore_for_file: prefer-named-boolean-parameters

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';

final class TransformModifier extends Modifier<TransformModifier> {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformModifier({this.transform, this.alignment});

  @override
  TransformModifier copyWith({Matrix4? transform, Alignment? alignment}) {
    return TransformModifier(
      transform: transform ?? this.transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TransformModifier lerp(TransformModifier? other, double t) {
    if (other == null) return this;

    return TransformModifier(
      transform: MixHelpers.lerpMatrix4(transform, other.transform, t),
      alignment: Alignment.lerp(alignment, other.alignment, t),
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

final class TransformModifierSpecUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, TransformModifierSpecAttribute> {
  late final rotate = TransformRotateModifierSpecUtility(
    (value) => builder(
      TransformModifierSpecAttribute(
        transform: Prop.maybe(value),
        alignment: Prop(Alignment.center),
      ),
    ),
  );

  TransformModifierSpecUtility(super.builder);

  T _flip(bool x, bool y) => builder(
    TransformModifierSpecAttribute(
      transform: Prop(
        Matrix4.diagonal3Values(x ? -1.0 : 1.0, y ? -1.0 : 1.0, 1.0),
      ),
      alignment: Prop(Alignment.center),
    ),
  );

  T flipX() => _flip(true, false);
  T flipY() => _flip(false, true);

  T call(Matrix4 value) =>
      builder(TransformModifierSpecAttribute(transform: Prop(value)));

  T scale(double value) => builder(
    TransformModifierSpecAttribute(
      transform: Prop(Matrix4.diagonal3Values(value, value, 1.0)),
      alignment: Prop(Alignment.center),
    ),
  );

  T translate(double x, double y) => builder(
    TransformModifierSpecAttribute(
      transform: Prop(Matrix4.translationValues(x, y, 0.0)),
      alignment: Prop(Alignment.center),
    ),
  );
}

final class TransformRotateModifierSpecUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, Matrix4> {
  const TransformRotateModifierSpecUtility(super.builder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => builder(Matrix4.rotationZ(value));
}

class TransformModifierSpecAttribute
    extends ModifierAttribute<TransformModifier> {
  final Prop<Matrix4>? transform;
  final Prop<Alignment>? alignment;

  const TransformModifierSpecAttribute({this.transform, this.alignment});

  @override
  TransformModifier resolve(BuildContext context) {
    return TransformModifier(
      transform: MixHelpers.resolve(context, transform),
      alignment: MixHelpers.resolve(context, alignment),
    );
  }

  @override
  TransformModifierSpecAttribute merge(TransformModifierSpecAttribute? other) {
    if (other == null) return this;

    return TransformModifierSpecAttribute(
      transform: MixHelpers.merge(transform, other.transform),
      alignment: MixHelpers.merge(alignment, other.alignment),
    );
  }

  @override
  List<Object?> get props => [transform, alignment];
}
