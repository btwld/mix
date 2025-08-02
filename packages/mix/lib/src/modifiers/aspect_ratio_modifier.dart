import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class AspectRatioModifier extends Modifier<AspectRatioModifier>
    with Diagnosticable {
  final double aspectRatio;

  const AspectRatioModifier([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  /// Creates a copy of this [AspectRatioModifier] but with the given fields
  /// replaced with the new values.
  @override
  AspectRatioModifier copyWith({double? aspectRatio}) {
    return AspectRatioModifier(aspectRatio ?? this.aspectRatio);
  }

  /// Linearly interpolates between this [AspectRatioModifier] and another [AspectRatioModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AspectRatioModifier] is returned. When [t] is 1.0, the [other] [AspectRatioModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AspectRatioModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [AspectRatioModifier] instance.
  ///
  /// The interpolation is performed on each property of the [AspectRatioModifier] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [aspectRatio].

  /// This method is typically used in animations to smoothly transition between
  /// different [AspectRatioModifier] configurations.
  @override
  AspectRatioModifier lerp(AspectRatioModifier? other, double t) {
    if (other == null) return this;

    return AspectRatioModifier(
      MixHelpers.lerpDouble(aspectRatio, other.aspectRatio, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifier] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Represents the attributes of a [AspectRatioModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AspectRatioModifier].
///
/// Use this class to configure the attributes of a [AspectRatioModifier] and pass it to
/// the [AspectRatioModifier] constructor.
class AspectRatioModifierAttribute
    extends ModifierAttribute<AspectRatioModifier>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioModifierAttribute.raw({this.aspectRatio});

  AspectRatioModifierAttribute({double? aspectRatio})
    : this.raw(aspectRatio: Prop.maybe(aspectRatio));

  /// Resolves to [AspectRatioModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final aspectRatioModifierSpec = AspectRatioModifierAttribute(...).resolve(mix);
  /// ```
  @override
  AspectRatioModifier resolve(BuildContext context) {
    return AspectRatioModifier(aspectRatio?.resolve(context));
  }

  /// Merges the properties of this [AspectRatioModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AspectRatioModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AspectRatioModifierAttribute merge(AspectRatioModifierAttribute? other) {
    if (other == null) return this;

    return AspectRatioModifierAttribute.raw(
      aspectRatio: MixHelpers.merge(aspectRatio, other.aspectRatio),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];
}

final class AspectRatioModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AspectRatioModifierAttribute> {
  const AspectRatioModifierUtility(super.builder);

  T call(double value) {
    return builder(
      AspectRatioModifierAttribute.raw(aspectRatio: Prop.value(value)),
    );
  }

  T token(MixToken<double> token) {
    return builder(
      AspectRatioModifierAttribute.raw(aspectRatio: Prop.token(token)),
    );
  }
}
