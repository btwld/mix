import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class RotatedBoxModifier
    extends Modifier<RotatedBoxModifier> {
  final int quarterTurns;
  const RotatedBoxModifier([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  /// Creates a copy of this [RotatedBoxModifier] but with the given fields
  /// replaced with the new values.
  @override
  RotatedBoxModifier copyWith({int? quarterTurns}) {
    return RotatedBoxModifier(quarterTurns ?? this.quarterTurns);
  }

  @override
  RotatedBoxModifier lerp(RotatedBoxModifier? other, double t) {
    if (other == null) return this;

    return RotatedBoxModifier(
      MixOps.lerp(quarterTurns, other.quarterTurns, t),
    );
  }

  /// The list of properties that constitute the state of this [RotatedBoxModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RotatedBoxModifier] instances for equality.
  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

/// Represents the attributes of a [RotatedBoxModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [RotatedBoxModifier].
///
/// Use this class to configure the attributes of a [RotatedBoxModifier] and pass it to
/// the [RotatedBoxModifier] constructor.
class RotatedBoxModifierMix
    extends ModifierMix<RotatedBoxModifier> {
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
  List<Object?> get props => [quarterTurns];
}

final class RotatedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxModifierMix> {
  const RotatedBoxModifierUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) => builder(
    RotatedBoxModifierMix.create(quarterTurns: Prop.value(value)),
  );
}
