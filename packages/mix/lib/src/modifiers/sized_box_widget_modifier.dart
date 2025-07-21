// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class SizedBoxModifierSpec extends Modifier<SizedBoxModifierSpec>
    with Diagnosticable {
  final double? width;
  final double? height;

  const SizedBoxModifierSpec({this.width, this.height});

  /// Creates a copy of this [SizedBoxModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  SizedBoxModifierSpec copyWith({double? width, double? height}) {
    return SizedBoxModifierSpec(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Linearly interpolates between this [SizedBoxModifierSpec] and another [SizedBoxModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SizedBoxModifierSpec] is returned. When [t] is 1.0, the [other] [SizedBoxModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SizedBoxModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SizedBoxModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SizedBoxModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [width] and [height].

  /// This method is typically used in animations to smoothly transition between
  /// different [SizedBoxModifierSpec] configurations.
  @override
  SizedBoxModifierSpec lerp(SizedBoxModifierSpec? other, double t) {
    if (other == null) return this;

    return SizedBoxModifierSpec(
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [SizedBoxModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifierSpec] instances for equality.
  @override
  List<Object?> get props => [width, height];

  @override
  Widget build(Widget child) {
    return SizedBox(width: width, height: height, child: child);
  }
}

/// Represents the attributes of a [SizedBoxModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SizedBoxModifierSpec].
///
/// Use this class to configure the attributes of a [SizedBoxModifierSpec] and pass it to
/// the [SizedBoxModifierSpec] constructor.
class SizedBoxModifierSpecAttribute
    extends ModifierSpecAttribute<SizedBoxModifierSpec>
    with Diagnosticable {
  final Prop<double>? width;
  final Prop<double>? height;

  const SizedBoxModifierSpecAttribute({this.width, this.height});

  /// Resolves to [SizedBoxModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sizedBoxModifierSpec = SizedBoxModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SizedBoxModifierSpec resolve(BuildContext context) {
    return SizedBoxModifierSpec(
      width: width?.resolve(context),
      height: height?.resolve(context),
    );
  }

  /// Merges the properties of this [SizedBoxModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SizedBoxModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SizedBoxModifierSpecAttribute merge(SizedBoxModifierSpecAttribute? other) {
    if (other == null) return this;

    return SizedBoxModifierSpecAttribute(
      width: width?.merge(other.width) ?? other.width,
      height: height?.merge(other.height) ?? other.height,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [SizedBoxModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [width, height];
}

final class SizedBoxModifierSpecUtility<T extends SpecUtility<Object?>>
    extends MixUtility<T, SizedBoxModifierSpecAttribute> {
  // TODO: Add width, height and square utilities when DoubleUtility is available
  // late final width = DoubleUtility(
  //   (prop) => builder(SizedBoxModifierSpecAttribute(width: prop)),
  // );
  // late final height = DoubleUtility(
  //   (prop) => builder(SizedBoxModifierSpecAttribute(height: prop)),
  // );
  // late final square = DoubleUtility(
  //   (prop) => builder(SizedBoxModifierSpecAttribute(width: prop, height: prop)),
  // );

  const SizedBoxModifierSpecUtility(super.builder);

  T call({double? width, double? height}) {
    return builder(
      SizedBoxModifierSpecAttribute(
        width: width != null ? Prop(width) : null,
        height: height != null ? Prop(height) : null,
      ),
    );
  }

  T widthToken(MixToken<double> token) =>
      builder(SizedBoxModifierSpecAttribute(width: Prop.token(token)));
  T heightToken(MixToken<double> token) =>
      builder(SizedBoxModifierSpecAttribute(height: Prop.token(token)));

  /// Utility for defining [SizedBoxModifierSpecAttribute.width] and [SizedBoxModifierSpecAttribute.height]
  /// from [Size]
  T as(Size size) => call(width: size.width, height: size.height);
}
