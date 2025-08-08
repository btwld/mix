import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

final class PaddingWidgetModifier extends Modifier<PaddingWidgetModifier>
    with Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingWidgetModifier([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  /// Creates a copy of this [PaddingWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  PaddingWidgetModifier copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingWidgetModifier(padding ?? this.padding);
  }

  /// Linearly interpolates between this [PaddingWidgetModifier] and another [PaddingWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaddingWidgetModifier] is returned. When [t] is 1.0, the [other] [PaddingWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaddingWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [PaddingWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [PaddingWidgetModifier] using the appropriate
  /// interpolation method:
  /// - [EdgeInsetsGeometry.lerp] for [padding].

  /// This method is typically used in animations to smoothly transition between
  /// different [PaddingWidgetModifier] configurations.
  @override
  PaddingWidgetModifier lerp(PaddingWidgetModifier? other, double t) {
    if (other == null) return this;

    return PaddingWidgetModifier(MixOps.lerp(padding, other.padding, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingWidgetModifier] instances for equality.
  @override
  List<Object?> get props => [padding];

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}

/// Attribute class for configuring [PaddingWidgetModifier] properties.
///
/// Encapsulates padding values for widget spacing and layout.
class PaddingWidgetModifierMix extends WidgetModifierMix<PaddingWidgetModifier>
    with Diagnosticable {
  final MixProp<EdgeInsetsGeometry>? padding;

  const PaddingWidgetModifierMix.create({this.padding});

  PaddingWidgetModifierMix({EdgeInsetsGeometryMix? padding})
    : this.create(padding: MixProp.maybe(padding));

  /// Resolves to [PaddingWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paddingWidgetModifier = PaddingWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  PaddingWidgetModifier resolve(BuildContext context) {
    return PaddingWidgetModifier(MixOps.resolve(context, padding));
  }

  /// Merges the properties of this [PaddingWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaddingWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaddingWidgetModifierMix merge(PaddingWidgetModifierMix? other) {
    if (other == null) return this;

    return PaddingWidgetModifierMix.create(
      padding: MixOps.merge(padding, other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [padding];
}

/// Utility class for configuring [PaddingWidgetModifier] properties.
///
/// This class provides methods to set individual properties of a [PaddingWidgetModifier].
/// Use the methods of this class to configure specific properties of a [PaddingWidgetModifier].
class PaddingWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, PaddingWidgetModifierMix> {
  /// Utility for defining [PaddingWidgetModifierMix.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => builder(PaddingWidgetModifierMix(padding: v)),
  );

  PaddingWidgetModifierUtility(super.builder);

  /// Returns a new [PaddingWidgetModifierMix] with the specified properties.
  T call({EdgeInsetsGeometryMix? padding}) {
    return builder(
      PaddingWidgetModifierMix.create(padding: MixProp.maybe(padding)),
    );
  }
}
