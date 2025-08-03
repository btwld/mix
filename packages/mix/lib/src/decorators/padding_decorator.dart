import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/layout/edge_insets_geometry_util.dart';

final class PaddingWidgetDecorator
    extends WidgetDecorator<PaddingWidgetDecorator>
    with Diagnosticable {
  final EdgeInsetsGeometry padding;

  const PaddingWidgetDecorator([EdgeInsetsGeometry? padding])
    : padding = padding ?? EdgeInsets.zero;

  /// Creates a copy of this [PaddingWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  PaddingWidgetDecorator copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingWidgetDecorator(padding ?? this.padding);
  }

  /// Linearly interpolates between this [PaddingWidgetDecorator] and another [PaddingWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaddingWidgetDecorator] is returned. When [t] is 1.0, the [other] [PaddingWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaddingWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [PaddingWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [PaddingWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [EdgeInsetsGeometry.lerp] for [padding].

  /// This method is typically used in animations to smoothly transition between
  /// different [PaddingWidgetDecorator] configurations.
  @override
  PaddingWidgetDecorator lerp(PaddingWidgetDecorator? other, double t) {
    if (other == null) return this;

    return PaddingWidgetDecorator(
      EdgeInsetsGeometry.lerp(padding, other.padding, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [padding];

  @override
  Widget build(Widget child) {
    return Padding(padding: padding, child: child);
  }
}

/// Attribute class for configuring [PaddingWidgetDecorator] properties.
///
/// Encapsulates padding values for widget spacing and layout.
class PaddingWidgetDecoratorMix
    extends WidgetDecoratorMix<PaddingWidgetDecorator>
    with Diagnosticable {
  final MixProp<EdgeInsetsGeometry>? padding;

  const PaddingWidgetDecoratorMix.raw({this.padding});

  PaddingWidgetDecoratorMix({EdgeInsetsGeometryMix? padding})
    : this.raw(padding: MixProp.maybe(padding));

  /// Resolves to [PaddingWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paddingDecorator = PaddingWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  PaddingWidgetDecorator resolve(BuildContext context) {
    return PaddingWidgetDecorator(MixHelpers.resolve(context, padding));
  }

  /// Merges the properties of this [PaddingWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaddingWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaddingWidgetDecoratorMix merge(PaddingWidgetDecoratorMix? other) {
    if (other == null) return this;

    return PaddingWidgetDecoratorMix.raw(
      padding: padding.tryMerge(other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [PaddingWidgetDecoratorMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingWidgetDecoratorMix] instances for equality.
  @override
  List<Object?> get props => [padding];
}

/// Utility class for configuring [PaddingWidgetDecorator] properties.
///
/// This class provides methods to set individual properties of a [PaddingWidgetDecorator].
/// Use the methods of this class to configure specific properties of a [PaddingWidgetDecorator].
class PaddingWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, PaddingWidgetDecoratorMix> {
  /// Utility for defining [PaddingWidgetDecoratorMix.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => builder(PaddingWidgetDecoratorMix(padding: v)),
  );

  PaddingWidgetDecoratorUtility(super.builder);

  /// Returns a new [PaddingWidgetDecoratorMix] with the specified properties.
  T call({EdgeInsetsGeometryMix? padding}) {
    return builder(
      PaddingWidgetDecoratorMix.raw(padding: MixProp.maybe(padding)),
    );
  }
}
