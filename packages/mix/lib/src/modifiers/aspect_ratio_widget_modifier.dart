// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class AspectRatioModifierSpec extends Modifier<AspectRatioModifierSpec>
    with Diagnosticable {
  final double aspectRatio;

  const AspectRatioModifierSpec([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  /// Creates a copy of this [AspectRatioModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  AspectRatioModifierSpec copyWith({double? aspectRatio}) {
    return AspectRatioModifierSpec(aspectRatio ?? this.aspectRatio);
  }

  /// Linearly interpolates between this [AspectRatioModifierSpec] and another [AspectRatioModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AspectRatioModifierSpec] is returned. When [t] is 1.0, the [other] [AspectRatioModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AspectRatioModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [AspectRatioModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [AspectRatioModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [aspectRatio].

  /// This method is typically used in animations to smoothly transition between
  /// different [AspectRatioModifierSpec] configurations.
  @override
  AspectRatioModifierSpec lerp(AspectRatioModifierSpec? other, double t) {
    if (other == null) return this;

    return AspectRatioModifierSpec(
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

  /// The list of properties that constitute the state of this [AspectRatioModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifierSpec] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Represents the attributes of a [AspectRatioModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AspectRatioModifierSpec].
///
/// Use this class to configure the attributes of a [AspectRatioModifierSpec] and pass it to
/// the [AspectRatioModifierSpec] constructor.
class AspectRatioModifierSpecAttribute
    extends ModifierSpecAttribute<AspectRatioModifierSpec>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioModifierSpecAttribute({this.aspectRatio});

  /// Resolves to [AspectRatioModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final aspectRatioModifierSpec = AspectRatioModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  AspectRatioModifierSpec resolve(BuildContext context) {
    return AspectRatioModifierSpec(aspectRatio?.resolve(context));
  }

  /// Merges the properties of this [AspectRatioModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AspectRatioModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AspectRatioModifierSpecAttribute merge(
    AspectRatioModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return AspectRatioModifierSpecAttribute(
      aspectRatio: aspectRatio?.merge(other.aspectRatio) ?? other.aspectRatio,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];
}

final class AspectRatioModifierSpecUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, AspectRatioModifierSpecAttribute> {
  const AspectRatioModifierSpecUtility(super.builder);

  T call(double value) {
    return builder(AspectRatioModifierSpecAttribute(aspectRatio: Prop(value)));
  }

  T token(MixToken<double> token) {
    return builder(
      AspectRatioModifierSpecAttribute(aspectRatio: Prop.token(token)),
    );
  }
}
