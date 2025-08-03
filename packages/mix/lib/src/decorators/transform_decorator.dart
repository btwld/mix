import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class TransformWidgetDecorator
    extends WidgetDecorator<TransformWidgetDecorator> {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformWidgetDecorator({this.transform, this.alignment});

  @override
  TransformWidgetDecorator copyWith({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return TransformWidgetDecorator(
      transform: transform ?? this.transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TransformWidgetDecorator lerp(TransformWidgetDecorator? other, double t) {
    if (other == null) return this;

    return TransformWidgetDecorator(
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

final class TransformWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, TransformWidgetDecoratorMix> {
  late final rotate = TransformRotateWidgetDecoratorUtility(
    (value) => builder(
      TransformWidgetDecoratorMix.raw(
        transform: Prop.maybe(value),
        alignment: Prop.value(Alignment.center),
      ),
    ),
  );

  TransformWidgetDecoratorUtility(super.builder);

  T _flip(bool x, bool y) => builder(
    TransformWidgetDecoratorMix.raw(
      transform: Prop.value(
        Matrix4.diagonal3Values(x ? -1.0 : 1.0, y ? -1.0 : 1.0, 1.0),
      ),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T flipX() => _flip(true, false);
  T flipY() => _flip(false, true);

  T call(Matrix4 value) =>
      builder(TransformWidgetDecoratorMix.raw(transform: Prop.value(value)));

  T scale(double value) => builder(
    TransformWidgetDecoratorMix.raw(
      transform: Prop.value(Matrix4.diagonal3Values(value, value, 1.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T translate(double x, double y) => builder(
    TransformWidgetDecoratorMix.raw(
      transform: Prop.value(Matrix4.translationValues(x, y, 0.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );
}

final class TransformRotateWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, Matrix4> {
  const TransformRotateWidgetDecoratorUtility(super.builder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => builder(Matrix4.rotationZ(value));
}

class TransformWidgetDecoratorMix
    extends WidgetDecoratorMix<TransformWidgetDecorator> {
  final Prop<Matrix4>? transform;
  final Prop<Alignment>? alignment;

  const TransformWidgetDecoratorMix.raw({this.transform, this.alignment});

  TransformWidgetDecoratorMix({Matrix4? transform, Alignment? alignment})
    : this.raw(
        transform: Prop.maybe(transform),
        alignment: Prop.maybe(alignment),
      );

  @override
  TransformWidgetDecorator resolve(BuildContext context) {
    return TransformWidgetDecorator(
      transform: MixHelpers.resolve(context, transform),
      alignment: MixHelpers.resolve(context, alignment),
    );
  }

  @override
  TransformWidgetDecoratorMix merge(TransformWidgetDecoratorMix? other) {
    if (other == null) return this;

    return TransformWidgetDecoratorMix.raw(
      transform: transform.tryMerge(other.transform),
      alignment: alignment.tryMerge(other.alignment),
    );
  }

  @override
  List<Object?> get props => [transform, alignment];
}
