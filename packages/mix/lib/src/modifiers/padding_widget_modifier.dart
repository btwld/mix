// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class PaddingModifierSpec extends ModifierSpec<PaddingModifierSpec>
    with Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingModifierSpec([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  /// Creates a copy of this [PaddingModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  PaddingModifierSpec copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingModifierSpec(padding ?? this.padding);
  }

  /// Linearly interpolates between this [PaddingModifierSpec] and another [PaddingModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaddingModifierSpec] is returned. When [t] is 1.0, the [other] [PaddingModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaddingModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [PaddingModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [PaddingModifierSpec] using the appropriate
  /// interpolation method:
  /// - [EdgeInsetsGeometry.lerp] for [padding].

  /// This method is typically used in animations to smoothly transition between
  /// different [PaddingModifierSpec] configurations.
  @override
  PaddingModifierSpec lerp(PaddingModifierSpec? other, double t) {
    if (other == null) return this;

    return PaddingModifierSpec(
      EdgeInsetsGeometry.lerp(padding, other.padding, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifierSpec] instances for equality.
  @override
  List<Object?> get props => [padding];

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}

/// Represents the attributes of a [PaddingModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [PaddingModifierSpec].
///
/// Use this class to configure the attributes of a [PaddingModifierSpec] and pass it to
/// the [PaddingModifierSpec] constructor.
class PaddingModifierSpecAttribute
    extends ModifierSpecAttribute<PaddingModifierSpec>
    with Diagnosticable {
  final EdgeInsetsGeometryDto? padding;

  const PaddingModifierSpecAttribute({this.padding});

  /// Resolves to [PaddingModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paddingModifierSpec = PaddingModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  PaddingModifierSpec resolve(BuildContext context) {
    return PaddingModifierSpec(padding?.resolve(context));
  }

  /// Merges the properties of this [PaddingModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaddingModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaddingModifierSpecAttribute merge(PaddingModifierSpecAttribute? other) {
    if (other == null) return this;

    return PaddingModifierSpecAttribute(
      padding:
          padding?.merge(other.padding as MixProp<EdgeInsetsGeometry>?) ??
          other.padding,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [padding];
}

/// Utility class for configuring [PaddingModifierSpec] properties.
///
/// This class provides methods to set individual properties of a [PaddingModifierSpec].
/// Use the methods of this class to configure specific properties of a [PaddingModifierSpec].
class PaddingModifierSpecUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, PaddingModifierSpecAttribute> {
  /// Utility for defining [PaddingModifierSpecAttribute.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => builder(PaddingModifierSpecAttribute(padding: v)),
  );

  PaddingModifierSpecUtility(super.builder);

  /// Returns a new [PaddingModifierSpecAttribute] with the specified properties.
  T call({EdgeInsetsGeometryDto? padding}) {
    return builder(PaddingModifierSpecAttribute(padding: padding));
  }
}
