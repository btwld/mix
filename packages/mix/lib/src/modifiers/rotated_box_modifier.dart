import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class RotatedBoxModifier extends Modifier<RotatedBoxModifier> {
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
      MixHelpers.lerpInt(quarterTurns, other.quarterTurns, t),
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
class RotatedBoxModifierAttribute
    extends ModifierAttribute<RotatedBoxModifier> {
  final Prop<int>? quarterTurns;

  const RotatedBoxModifierAttribute.raw({this.quarterTurns});

  RotatedBoxModifierAttribute({int? quarterTurns})
    : this.raw(quarterTurns: Prop.maybe(quarterTurns));

  /// Resolves to [RotatedBoxModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final rotatedBoxModifierSpec = RotatedBoxModifierAttribute(...).resolve(mix);
  /// ```
  @override
  RotatedBoxModifier resolve(BuildContext context) {
    return RotatedBoxModifier(MixHelpers.resolve(context, quarterTurns));
  }

  /// Merges the properties of this [RotatedBoxModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RotatedBoxModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RotatedBoxModifierAttribute merge(RotatedBoxModifierAttribute? other) {
    if (other == null) return this;

    return RotatedBoxModifierAttribute.raw(
      quarterTurns: quarterTurns.tryMerge(other.quarterTurns),
    );
  }

  @override
  List<Object?> get props => [quarterTurns];
}

final class RotatedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxModifierAttribute> {
  const RotatedBoxModifierUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) =>
      builder(RotatedBoxModifierAttribute.raw(quarterTurns: Prop.value(value)));
}
