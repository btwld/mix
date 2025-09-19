import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';

abstract class _TransformModifier<T extends _TransformModifier<T>>
    extends WidgetModifier<T>
    with Diagnosticable {
  final Matrix4 transform;
  final Alignment? alignment;

  _TransformModifier({Matrix4? transform, this.alignment = Alignment.center})
    : transform = transform ?? Matrix4.identity();

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

/// Modifier that applies matrix transformations to its child.
///
/// Wraps the child in a [Transform] widget with the specified matrix and alignment.
class TransformModifier extends _TransformModifier<TransformModifier> {
  TransformModifier({Matrix4? transform, super.alignment})
    : super(transform: transform ?? Matrix4.identity());

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
class TransformModifierMix extends ModifierMix<TransformModifier>
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

class ScaleModifier extends _TransformModifier<ScaleModifier> {
  ScaleModifier({double x = 1.0, double y = 1.0, super.alignment})
    : super(transform: Matrix4.diagonal3Values(x, y, 1.0));

  ScaleModifier._({super.transform, super.alignment});

  @override
  // ignore: avoid-incomplete-copy-with
  ScaleModifier copyWith({double? x, double? y, Alignment? alignment}) {
    final matrix = Matrix4.diagonal3Values(x ?? 1, y ?? 1, 1.0);

    return ScaleModifier._(
      transform: x != null || y != null ? matrix : transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  ScaleModifier lerp(ScaleModifier? other, double t) {
    if (other == null) return this;

    return ScaleModifier._(
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }
}

/// Mix class for applying scale transform modifications.
///
/// This class allows for mixing and resolving scale transform properties.
class ScaleModifierMix extends ModifierMix<ScaleModifier> with Diagnosticable {
  final Prop<double>? x;
  final Prop<double>? y;
  final Prop<Alignment>? alignment;

  const ScaleModifierMix.create({this.x, this.y, this.alignment});

  ScaleModifierMix({
    double? x,
    double? y,
    Alignment? alignment,
    double? scale, // for backward compatibility
  }) : this.create(
         x: x != null
             ? Prop.value(x)
             : (scale != null ? Prop.value(scale) : null),
         y: y != null
             ? Prop.value(y)
             : (scale != null ? Prop.value(scale) : null),
         alignment: Prop.maybe(alignment),
       );

  @override
  ScaleModifier resolve(BuildContext context) {
    final resolvedx = MixOps.resolve(context, x) ?? 1.0;
    final resolvedy = MixOps.resolve(context, y) ?? 1.0;
    final resolvedAlignment =
        MixOps.resolve(context, alignment) ?? Alignment.center;

    return ScaleModifier(
      x: resolvedx,
      y: resolvedy,
      alignment: resolvedAlignment,
    );
  }

  @override
  ScaleModifierMix merge(ScaleModifierMix? other) {
    if (other == null) return this;

    return ScaleModifierMix.create(
      x: MixOps.merge(x, other.x),
      y: MixOps.merge(y, other.y),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('x', x))
      ..add(DiagnosticsProperty('y', y))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  Type get mergeKey => ScaleModifierMix;

  @override
  List<Object?> get props => [x, y, alignment];
}

class TranslateModifier extends _TransformModifier<TranslateModifier> {
  TranslateModifier({double x = 0.0, double y = 0.0})
    : super(transform: Matrix4.translationValues(x, y, 0.0));

  TranslateModifier._({super.transform, super.alignment});

  @override
  // ignore: avoid-incomplete-copy-with
  TranslateModifier copyWith({double? x, double? y, Alignment? alignment}) {
    final matrix = Matrix4.translationValues(x ?? 0.0, y ?? 0.0, 0.0);

    return TranslateModifier._(
      transform: x != null || y != null ? matrix : transform,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TranslateModifier lerp(TranslateModifier? other, double t) {
    if (other == null) return this;

    return TranslateModifier._(
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }
}

/// ModifierMix for translation transform.
class TranslateModifierMix extends ModifierMix<TranslateModifier>
    with Diagnosticable {
  final Prop<double>? x;
  final Prop<double>? y;

  const TranslateModifierMix.create({this.x, this.y});

  TranslateModifierMix({double? x, double? y})
    : this.create(x: Prop.maybe(x), y: Prop.maybe(y));

  @override
  TranslateModifier resolve(BuildContext context) {
    final resolvedX = MixOps.resolve(context, x) ?? 0.0;
    final resolvedY = MixOps.resolve(context, y) ?? 0.0;

    return TranslateModifier(x: resolvedX, y: resolvedY);
  }

  @override
  TranslateModifierMix merge(TranslateModifierMix? other) {
    if (other == null) return this;

    return TranslateModifierMix.create(
      x: MixOps.merge(x, other.x),
      y: MixOps.merge(y, other.y),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('x', x))
      ..add(DiagnosticsProperty('y', y));
  }

  @override
  Type get mergeKey => TranslateModifierMix;

  @override
  List<Object?> get props => [x, y];
}

class RotateModifier extends _TransformModifier<RotateModifier> {
  RotateModifier({double radians = 0.0, super.alignment})
    : super(transform: Matrix4.rotationZ(radians));

  RotateModifier._({super.transform, super.alignment});

  @override
  RotateModifier lerp(RotateModifier? other, double t) {
    if (other == null) return this;

    return RotateModifier._(
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }

  @override
  // ignore: avoid-incomplete-copy-with
  RotateModifier copyWith({double? radians, Alignment? alignment}) {
    return RotateModifier._(
      transform: radians != null ? Matrix4.rotationZ(radians) : transform,
      alignment: alignment ?? this.alignment,
    );
  }
}

/// ModifierMix for rotation transform (around Z axis).
class RotateModifierMix extends ModifierMix<RotateModifier>
    with Diagnosticable {
  final Prop<double>? radians;
  final Prop<Alignment>? alignment;

  const RotateModifierMix.create({this.radians, this.alignment});

  RotateModifierMix({double? radians, Alignment? alignment})
    : this.create(
        radians: Prop.maybe(radians),
        alignment: Prop.maybe(alignment),
      );

  @override
  RotateModifier resolve(BuildContext context) {
    final resolvedRadians = MixOps.resolve(context, radians) ?? 0.0;
    final resolvedAlignment =
        MixOps.resolve(context, alignment) ?? Alignment.center;

    return RotateModifier(
      radians: resolvedRadians,
      alignment: resolvedAlignment,
    );
  }

  @override
  RotateModifierMix merge(RotateModifierMix? other) {
    if (other == null) return this;

    return RotateModifierMix.create(
      radians: MixOps.merge(radians, other.radians),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('radians', radians))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  Type get mergeKey => RotateModifierMix;

  @override
  List<Object?> get props => [radians, alignment];
}

class SkewModifier extends _TransformModifier<SkewModifier> {
  SkewModifier({double skewX = 0.0, double skewY = 0.0, super.alignment})
    : super(transform: Matrix4.skew(skewX, skewY));

  SkewModifier._({super.transform, super.alignment});

  @override
  SkewModifier lerp(SkewModifier? other, double t) {
    if (other == null) return this;

    return SkewModifier._(
      transform: MixOps.lerp(transform, other.transform, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }

  @override
  // ignore: avoid-incomplete-copy-with
  SkewModifier copyWith({double? skewX, double? skewY, Alignment? alignment}) {
    return SkewModifier._(
      transform: skewX != null || skewY != null
          ? Matrix4.skew(skewX ?? 0.0, skewY ?? 0.0)
          : transform,
      alignment: alignment ?? this.alignment,
    );
  }
}

/// ModifierMix for skew transform.
class SkewModifierMix extends ModifierMix<SkewModifier> with Diagnosticable {
  final Prop<double>? skewX;
  final Prop<double>? skewY;
  final Prop<Alignment>? alignment;

  const SkewModifierMix.create({this.skewX, this.skewY, this.alignment});

  SkewModifierMix({double? skewX, double? skewY, Alignment? alignment})
    : this.create(
        skewX: Prop.maybe(skewX),
        skewY: Prop.maybe(skewY),
        alignment: Prop.maybe(alignment),
      );

  @override
  SkewModifier resolve(BuildContext context) {
    final resolvedSkewX = MixOps.resolve(context, skewX) ?? 0.0;
    final resolvedSkewY = MixOps.resolve(context, skewY) ?? 0.0;
    final resolvedAlignment =
        MixOps.resolve(context, alignment) ?? Alignment.center;

    return SkewModifier(
      skewX: resolvedSkewX,
      skewY: resolvedSkewY,
      alignment: resolvedAlignment,
    );
  }

  @override
  SkewModifierMix merge(SkewModifierMix? other) {
    if (other == null) return this;

    return SkewModifierMix.create(
      skewX: MixOps.merge(skewX, other.skewX),
      skewY: MixOps.merge(skewY, other.skewY),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('skewX', skewX))
      ..add(DiagnosticsProperty('skewY', skewY))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  Type get mergeKey => SkewModifierMix;

  @override
  List<Object?> get props => [skewX, skewY, alignment];
}
