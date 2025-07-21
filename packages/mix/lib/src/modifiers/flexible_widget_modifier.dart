// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class FlexibleModifier extends Modifier<FlexibleModifier>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleModifier({this.flex, this.fit});

  /// Creates a copy of this [FlexibleModifier] but with the given fields
  /// replaced with the new values.
  @override
  FlexibleModifier copyWith({int? flex, FlexFit? fit}) {
    return FlexibleModifier(flex: flex ?? this.flex, fit: fit ?? this.fit);
  }

  /// Linearly interpolates between this [FlexibleModifier] and another [FlexibleModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexibleModifier] is returned. When [t] is 1.0, the [other] [FlexibleModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexibleModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexibleModifier] instance.
  ///
  /// The interpolation is performed on each property of the [FlexibleModifier] using the appropriate
  /// interpolation method:
  /// For [flex] and [fit], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexibleModifier] is used. Otherwise, the value
  /// from the [other] [FlexibleModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexibleModifier] configurations.
  @override
  FlexibleModifier lerp(FlexibleModifier? other, double t) {
    if (other == null) return this;

    return FlexibleModifier(
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

  /// The list of properties that constitute the state of this [FlexibleModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifier] instances for equality.
  @override
  List<Object?> get props => [flex, fit];

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? FlexFit.loose, child: child);
  }
}

/// Represents the attributes of a [FlexibleModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexibleModifier].
///
/// Use this class to configure the attributes of a [FlexibleModifier] and pass it to
/// the [FlexibleModifier] constructor.
class FlexibleModifierAttribute extends ModifierAttribute<FlexibleModifier>
    with Diagnosticable {
  final Prop<int>? flex;
  final Prop<FlexFit>? fit;

  const FlexibleModifierAttribute({this.flex, this.fit});

  /// Resolves to [FlexibleModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexibleModifierSpec = FlexibleModifierAttribute(...).resolve(mix);
  /// ```
  @override
  FlexibleModifier resolve(BuildContext context) {
    return FlexibleModifier(
      flex: flex?.resolve(context),
      fit: fit?.resolve(context),
    );
  }

  /// Merges the properties of this [FlexibleModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexibleModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexibleModifierAttribute merge(FlexibleModifierAttribute? other) {
    if (other == null) return this;

    return FlexibleModifierAttribute(
      flex: flex?.merge(other.flex) ?? other.flex,
      fit: fit?.merge(other.fit) ?? other.fit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexibleModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [flex, fit];
}

final class FlexibleModifierUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, FlexibleModifierAttribute> {
  // TODO: Add flex and fit utilities when IntUtility and FlexFitUtility are available
  // late final flex = IntUtility(
  //   (prop) => builder(FlexibleModifierAttribute(flex: prop)),
  // );
  // late final fit = FlexFitUtility(
  //   (prop) => builder(FlexibleModifierAttribute(fit: prop)),
  // );

  const FlexibleModifierUtility(super.builder);
  T tight({int? flex}) => builder(
    FlexibleModifierAttribute(
      flex: flex != null ? Prop(flex) : null,
      fit: Prop(FlexFit.tight),
    ),
  );

  T loose({int? flex}) => builder(
    FlexibleModifierAttribute(
      flex: flex != null ? Prop(flex) : null,
      fit: Prop(FlexFit.loose),
    ),
  );

  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return builder(
      FlexibleModifierAttribute(
        flex: flex != null ? Prop(flex) : null,
        fit: fit != null ? Prop(fit) : null,
      ),
    );
  }

  T flexToken(MixToken<int> token) {
    return builder(FlexibleModifierAttribute(flex: Prop.token(token)));
  }

  T fitToken(MixToken<FlexFit> token) {
    return builder(FlexibleModifierAttribute(fit: Prop.token(token)));
  }
}
