import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class SizedBoxModifier extends Modifier<SizedBoxModifier>
    with Diagnosticable {
  final double? width;
  final double? height;

  const SizedBoxModifier({this.width, this.height});

  /// Creates a copy of this [SizedBoxModifier] but with the given fields
  /// replaced with the new values.
  @override
  SizedBoxModifier copyWith({double? width, double? height}) {
    return SizedBoxModifier(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Linearly interpolates between this [SizedBoxModifier] and another [SizedBoxModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SizedBoxModifier] is returned. When [t] is 1.0, the [other] [SizedBoxModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SizedBoxModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [SizedBoxModifier] instance.
  ///
  /// The interpolation is performed on each property of the [SizedBoxModifier] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [width] and [height].

  /// This method is typically used in animations to smoothly transition between
  /// different [SizedBoxModifier] configurations.
  @override
  SizedBoxModifier lerp(SizedBoxModifier? other, double t) {
    if (other == null) return this;

    return SizedBoxModifier(
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

  /// The list of properties that constitute the state of this [SizedBoxModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifier] instances for equality.
  @override
  List<Object?> get props => [width, height];

  @override
  Widget build(Widget child) {
    return SizedBox(width: width, height: height, child: child);
  }
}

/// Represents the attributes of a [SizedBoxModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SizedBoxModifier].
///
/// Use this class to configure the attributes of a [SizedBoxModifier] and pass it to
/// the [SizedBoxModifier] constructor.
class SizedBoxModifierAttribute extends ModifierAttribute<SizedBoxModifier>
    with Diagnosticable {
  final Prop<double>? width;
  final Prop<double>? height;

  const SizedBoxModifierAttribute.raw({this.width, this.height});

  SizedBoxModifierAttribute({double? width, double? height})
    : this.raw(width: Prop.maybe(width), height: Prop.maybe(height));

  /// Resolves to [SizedBoxModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sizedBoxModifierSpec = SizedBoxModifierAttribute(...).resolve(mix);
  /// ```
  @override
  SizedBoxModifier resolve(BuildContext context) {
    return SizedBoxModifier(
      width: width?.resolve(context),
      height: height?.resolve(context),
    );
  }

  /// Merges the properties of this [SizedBoxModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SizedBoxModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SizedBoxModifierAttribute merge(SizedBoxModifierAttribute? other) {
    if (other == null) return this;

    return SizedBoxModifierAttribute.raw(
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

  /// The list of properties that constitute the state of this [SizedBoxModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [width, height];
}

final class SizedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, SizedBoxModifierAttribute> {
  late final width = PropUtility<T, double>(
    (prop) => builder(SizedBoxModifierAttribute.raw(width: prop)),
  );
  late final height = PropUtility<T, double>(
    (prop) => builder(SizedBoxModifierAttribute.raw(height: prop)),
  );

  SizedBoxModifierUtility(super.builder);

  /// Creates a square-sized box with the same width and height
  T square(double size) => builder(
    SizedBoxModifierAttribute.raw(width: Prop(size), height: Prop(size)),
  );

  T call({double? width, double? height}) {
    return builder(
      SizedBoxModifierAttribute.raw(
        width: width != null ? Prop(width) : null,
        height: height != null ? Prop(height) : null,
      ),
    );
  }

  T widthToken(MixToken<double> token) =>
      builder(SizedBoxModifierAttribute.raw(width: Prop.token(token)));
  T heightToken(MixToken<double> token) =>
      builder(SizedBoxModifierAttribute.raw(height: Prop.token(token)));

  /// Utility for defining [SizedBoxModifierAttribute.width] and [SizedBoxModifierAttribute.height]
  /// from [Size]
  T as(Size size) => call(width: size.width, height: size.height);
}
