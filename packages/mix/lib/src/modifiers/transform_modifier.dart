import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';

final class TransformWidgetModifier
    extends WidgetModifier<TransformWidgetModifier> {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformWidgetModifier({this.transform, this.alignment});

  @override
  TransformWidgetModifier copyWith({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return TransformWidgetModifier(
      transform: transform ?? this.transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TransformWidgetModifier lerp(TransformWidgetModifier? other, double t) {
    if (other == null) return this;

    return TransformWidgetModifier(
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t),
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

final class TransformWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, TransformWidgetModifierMix> {
  late final rotate = TransformRotateWidgetModifierUtility(
    (value) => builder(
      TransformWidgetModifierMix.create(
        transform: Prop.maybe(value),
        alignment: Prop.value(Alignment.center),
      ),
    ),
  );

  TransformWidgetModifierUtility(super.builder);

  T _flip(bool x, bool y) => builder(
    TransformWidgetModifierMix.create(
      transform: Prop.value(
        Matrix4.diagonal3Values(x ? -1.0 : 1.0, y ? -1.0 : 1.0, 1.0),
      ),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T flipX() => _flip(true, false);
  T flipY() => _flip(false, true);

  T call(Matrix4 value) =>
      builder(TransformWidgetModifierMix.create(transform: Prop.value(value)));

  T scale(double value) => builder(
    TransformWidgetModifierMix.create(
      transform: Prop.value(Matrix4.diagonal3Values(value, value, 1.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T translate(double x, double y) => builder(
    TransformWidgetModifierMix.create(
      transform: Prop.value(Matrix4.translationValues(x, y, 0.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );
}

final class TransformRotateWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, Matrix4> {
  const TransformRotateWidgetModifierUtility(super.builder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => builder(Matrix4.rotationZ(value));
}

class TransformWidgetModifierMix
    extends WidgetModifierMix<TransformWidgetModifier> {
  final Prop<Matrix4>? transform;
  final Prop<Alignment>? alignment;

  const TransformWidgetModifierMix.create({this.transform, this.alignment});

  TransformWidgetModifierMix({Matrix4? transform, Alignment? alignment})
    : this.create(
        transform: Prop.maybe(transform),
        alignment: Prop.maybe(alignment),
      );

  @override
  TransformWidgetModifier resolve(BuildContext context) {
    return TransformWidgetModifier(
      transform: MixOps.resolve(context, transform),
      alignment: MixOps.resolve(context, alignment),
    );
  }

  @override
  TransformWidgetModifierMix merge(TransformWidgetModifierMix? other) {
    if (other == null) return this;

    return TransformWidgetModifierMix.create(
      transform: transform.tryMerge(other.transform),
      alignment: alignment.tryMerge(other.alignment),
    );
  }

  @override
  List<Object?> get props => [transform, alignment];
}
