// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class RotatedBoxModifierSpec extends ModifierSpec<RotatedBoxModifierSpec>
    with Diagnosticable {
  final int quarterTurns;
  const RotatedBoxModifierSpec([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  /// Creates a copy of this [RotatedBoxModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  RotatedBoxModifierSpec copyWith({int? quarterTurns}) {
    return RotatedBoxModifierSpec(quarterTurns ?? this.quarterTurns);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('quarterTurns', quarterTurns, defaultValue: null),
    );
  }

  @override
  RotatedBoxModifierSpec lerp(RotatedBoxModifierSpec? other, double t) {
    if (other == null) return this;

    return RotatedBoxModifierSpec(
      MixHelpers.lerpInt(quarterTurns, other.quarterTurns, t),
    );
  }

  /// The list of properties that constitute the state of this [RotatedBoxModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RotatedBoxModifierSpec] instances for equality.
  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

/// Represents the attributes of a [RotatedBoxModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [RotatedBoxModifierSpec].
///
/// Use this class to configure the attributes of a [RotatedBoxModifierSpec] and pass it to
/// the [RotatedBoxModifierSpec] constructor.
class RotatedBoxModifierSpecAttribute
    extends ModifierSpecAttribute<RotatedBoxModifierSpec>
    with Diagnosticable {
  final int? quarterTurns;

  const RotatedBoxModifierSpecAttribute({this.quarterTurns});

  /// Resolves to [RotatedBoxModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final rotatedBoxModifierSpec = RotatedBoxModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  RotatedBoxModifierSpec resolve(BuildContext context) {
    return RotatedBoxModifierSpec(quarterTurns);
  }

  /// Merges the properties of this [RotatedBoxModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RotatedBoxModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RotatedBoxModifierSpecAttribute merge(
    RotatedBoxModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return RotatedBoxModifierSpecAttribute(
      quarterTurns: other.quarterTurns ?? quarterTurns,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('quarterTurns', quarterTurns, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [RotatedBoxModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RotatedBoxModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [quarterTurns];
}


final class RotatedBoxModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, RotatedBoxModifierSpecAttribute> {
  const RotatedBoxModifierSpecUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) =>
      builder(RotatedBoxModifierSpecAttribute(quarterTurns: value));
}
