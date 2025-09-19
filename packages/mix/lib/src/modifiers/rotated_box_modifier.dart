import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that rotates its child by quarter turns.
///
/// Wraps the child in a [RotatedBox] widget with the specified quarter turns.
final class RotatedBoxModifier extends WidgetModifier<RotatedBoxModifier>
    with Diagnosticable {
  final int quarterTurns;
  const RotatedBoxModifier([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  @override
  RotatedBoxModifier copyWith({int? quarterTurns}) {
    return RotatedBoxModifier(quarterTurns ?? this.quarterTurns);
  }

  @override
  RotatedBoxModifier lerp(RotatedBoxModifier? other, double t) {
    if (other == null) return this;

    return RotatedBoxModifier(MixOps.lerp(quarterTurns, other.quarterTurns, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('quarterTurns', quarterTurns));
  }

  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

/// Mix class for applying rotated box modifications.
///
/// This class allows for mixing and resolving rotated box properties.
class RotatedBoxModifierMix extends ModifierMix<RotatedBoxModifier>
    with Diagnosticable {
  final Prop<int>? quarterTurns;

  const RotatedBoxModifierMix.create({this.quarterTurns});

  RotatedBoxModifierMix({int? quarterTurns})
    : this.create(quarterTurns: Prop.maybe(quarterTurns));

  /// Resolves to [RotatedBoxModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final rotatedBoxModifier = RotatedBoxModifierMix(...).resolve(mix);
  /// ```
  @override
  RotatedBoxModifier resolve(BuildContext context) {
    return RotatedBoxModifier(MixOps.resolve(context, quarterTurns));
  }

  /// Merges the properties of this [RotatedBoxModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RotatedBoxModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RotatedBoxModifierMix merge(RotatedBoxModifierMix? other) {
    if (other == null) return this;

    return RotatedBoxModifierMix.create(
      quarterTurns: MixOps.merge(quarterTurns, other.quarterTurns),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('quarterTurns', quarterTurns));
  }

  @override
  List<Object?> get props => [quarterTurns];
}

final class RotatedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxModifierMix> {
  const RotatedBoxModifierUtility(super.utilityBuilder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) => utilityBuilder(
    RotatedBoxModifierMix.create(quarterTurns: Prop.value(value)),
  );
}
