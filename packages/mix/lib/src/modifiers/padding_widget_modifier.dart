// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/edge_insets_geometry_mix.dart';
import '../attributes/edge_insets_geometry_util.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class PaddingModifier extends Modifier<PaddingModifier>
    with Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingModifier([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  /// Creates a copy of this [PaddingModifier] but with the given fields
  /// replaced with the new values.
  @override
  PaddingModifier copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingModifier(padding ?? this.padding);
  }

  /// Linearly interpolates between this [PaddingModifier] and another [PaddingModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaddingModifier] is returned. When [t] is 1.0, the [other] [PaddingModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaddingModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [PaddingModifier] instance.
  ///
  /// The interpolation is performed on each property of the [PaddingModifier] using the appropriate
  /// interpolation method:
  /// - [EdgeInsetsGeometry.lerp] for [padding].

  /// This method is typically used in animations to smoothly transition between
  /// different [PaddingModifier] configurations.
  @override
  PaddingModifier lerp(PaddingModifier? other, double t) {
    if (other == null) return this;

    return PaddingModifier(EdgeInsetsGeometry.lerp(padding, other.padding, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifier] instances for equality.
  @override
  List<Object?> get props => [padding];

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}

/// Represents the attributes of a [PaddingModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [PaddingModifier].
///
/// Use this class to configure the attributes of a [PaddingModifier] and pass it to
/// the [PaddingModifier] constructor.
class PaddingModifierAttribute extends ModifierAttribute<PaddingModifier>
    with Diagnosticable {
  final MixProp<EdgeInsetsGeometry>? padding;

  const PaddingModifierAttribute({this.padding});

  PaddingModifierAttribute.only({EdgeInsetsGeometryMix? padding})
    : this(padding: Prop.maybe(padding));

  /// Resolves to [PaddingModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paddingModifierSpec = PaddingModifierAttribute(...).resolve(mix);
  /// ```
  @override
  PaddingModifier resolve(BuildContext context) {
    return PaddingModifier(MixHelpers.resolveMix(context, padding));
  }

  /// Merges the properties of this [PaddingModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaddingModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaddingModifierAttribute merge(PaddingModifierAttribute? other) {
    if (other == null) return this;

    return PaddingModifierAttribute(
      padding: MixHelpers.merge(padding, other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [padding];
}

/// Utility class for configuring [PaddingModifier] properties.
///
/// This class provides methods to set individual properties of a [PaddingModifier].
/// Use the methods of this class to configure specific properties of a [PaddingModifier].
class PaddingModifierUtility<T extends SpecStyle<Object?>>
    extends MixUtility<T, PaddingModifierAttribute> {
  /// Utility for defining [PaddingModifierAttribute.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => builder(PaddingModifierAttribute(padding: v)),
  );

  PaddingModifierUtility(super.builder);

  /// Returns a new [PaddingModifierAttribute] with the specified properties.
  T call({EdgeInsetsGeometryMix? padding}) {
    return builder(PaddingModifierAttribute(padding: Prop.maybe(padding)));
  }
}
