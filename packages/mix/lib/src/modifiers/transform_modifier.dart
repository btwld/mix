import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that applies matrix transformations to its child.
///
/// Wraps the child in a [Transform] widget with the specified matrix and alignment.
final class TransformModifier extends WidgetModifier<TransformModifier>
    with Diagnosticable {
  final Matrix4 transform;
  final Alignment? alignment;

  TransformModifier({Matrix4? transform, this.alignment = Alignment.center})
    : transform = transform ?? Matrix4.identity();

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
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  List<Object?> get props => [transform, alignment];

  @override
  Widget build(Widget child) {
    return Transform(transform: transform, alignment: alignment, child: child);
  }
}

/// Utility class for applying transform modifications.
///
/// Provides convenient methods for creating TransformModifierMix instances.
final class TransformModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, TransformModifierMix> {
  late final rotate = TransformRotateModifierUtility(
    (value) => utilityBuilder(
      TransformModifierMix.create(
        transform: Prop.maybe(value),
        alignment: Prop.value(Alignment.center),
      ),
    ),
  );

  TransformModifierUtility(super.utilityBuilder);

  T _flip(bool x, bool y) => utilityBuilder(
    TransformModifierMix.create(
      transform: Prop.value(
        Matrix4.diagonal3Values(x ? -1.0 : 1.0, y ? -1.0 : 1.0, 1.0),
      ),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T flipX() => _flip(true, false);
  T flipY() => _flip(false, true);

  T call(Matrix4 value) =>
      utilityBuilder(TransformModifierMix.create(transform: Prop.value(value)));

  T scale(double value) => utilityBuilder(
    TransformModifierMix.create(
      transform: Prop.value(Matrix4.diagonal3Values(value, value, 1.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );

  T translate(double x, double y) => utilityBuilder(
    TransformModifierMix.create(
      transform: Prop.value(Matrix4.translationValues(x, y, 0.0)),
      alignment: Prop.value(Alignment.center),
    ),
  );
}

final class TransformRotateModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, Matrix4> {
  const TransformRotateModifierUtility(super.utilityBuilder);
  T d90() => call(math.pi / 2);
  T d180() => call(math.pi);
  T d270() => call(3 * math.pi / 2);

  T call(double value) => utilityBuilder(Matrix4.rotationZ(value));
}

/// Mix class for applying transform modifications.
///
/// This class allows for mixing and resolving transform properties.
class TransformModifierMix extends WidgetModifierMix<TransformModifier>
    with Diagnosticable {
  final Prop<Matrix4>? transform;
  final Prop<Alignment>? alignment;

  const TransformModifierMix.create({this.transform, this.alignment});

  TransformModifierMix({Matrix4? transform, Alignment? alignment})
    : this.create(
        transform: Prop.maybe(transform),
        alignment: Prop.maybe(alignment),
      );

  @override
  TransformModifier resolve(BuildContext context) {
    return TransformModifier(
      transform: MixOps.resolve(context, transform),
      alignment: MixOps.resolve(context, alignment)!,
    );
  }

  @override
  TransformModifierMix merge(TransformModifierMix? other) {
    if (other == null) return this;

    return TransformModifierMix.create(
      transform: MixOps.merge(transform, other.transform),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  List<Object?> get props => [transform, alignment];
}
