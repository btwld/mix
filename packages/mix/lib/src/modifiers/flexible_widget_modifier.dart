// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/enum/enum_util.dart';
import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class FlexibleModifierSpec extends ModifierSpec<FlexibleModifierSpec>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleModifierSpec({this.flex, this.fit});

  /// Creates a copy of this [FlexibleModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexibleModifierSpec copyWith({int? flex, FlexFit? fit}) {
    return FlexibleModifierSpec(flex: flex ?? this.flex, fit: fit ?? this.fit);
  }

  /// Linearly interpolates between this [FlexibleModifierSpec] and another [FlexibleModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexibleModifierSpec] is returned. When [t] is 1.0, the [other] [FlexibleModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexibleModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexibleModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexibleModifierSpec] using the appropriate
  /// interpolation method:
  /// For [flex] and [fit], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexibleModifierSpec] is used. Otherwise, the value
  /// from the [other] [FlexibleModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexibleModifierSpec] configurations.
  @override
  FlexibleModifierSpec lerp(FlexibleModifierSpec? other, double t) {
    if (other == null) return this;

    return FlexibleModifierSpec(
      flex: t < 0.5 ? flex : other.flex,
      fit: t < 0.5 ? fit : other.fit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexibleModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifierSpec] instances for equality.
  @override
  List<Object?> get props => [flex, fit];

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? FlexFit.loose, child: child);
  }
}

/// Represents the attributes of a [FlexibleModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexibleModifierSpec].
///
/// Use this class to configure the attributes of a [FlexibleModifierSpec] and pass it to
/// the [FlexibleModifierSpec] constructor.
class FlexibleModifierSpecAttribute
    extends ModifierSpecAttribute<FlexibleModifierSpec>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;

  const FlexibleModifierSpecAttribute({this.flex, this.fit});

  /// Resolves to [FlexibleModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexibleModifierSpec = FlexibleModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexibleModifierSpec resolve(BuildContext context) {
    return FlexibleModifierSpec(flex: flex, fit: fit);
  }

  /// Merges the properties of this [FlexibleModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexibleModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexibleModifierSpecAttribute merge(FlexibleModifierSpecAttribute? other) {
    if (other == null) return this;

    return FlexibleModifierSpecAttribute(
      flex: other.flex ?? flex,
      fit: other.fit ?? fit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexibleModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [flex, fit];
}


final class FlexibleModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, FlexibleModifierSpecAttribute> {
  const FlexibleModifierSpecUtility(super.builder);
  FlexFitUtility<T> get fit => FlexFitUtility((fit) => call(fit: fit));
  IntUtility<T> get flex => IntUtility((prop) => call(flex: prop.getValue()));
  T tight({int? flex}) =>
      builder(FlexibleModifierSpecAttribute(flex: flex, fit: FlexFit.tight));
  T loose({int? flex}) =>
      builder(FlexibleModifierSpecAttribute(flex: flex, fit: FlexFit.loose));
  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return builder(FlexibleModifierSpecAttribute(flex: flex, fit: fit));
  }
}
