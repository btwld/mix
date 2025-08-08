import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// A modifier that wraps a widget with the [Opacity] widget.
///
/// The [Opacity] widget is used to make a widget partially transparent.
final class OpacityModifier extends Modifier<OpacityModifier>
    with Diagnosticable {
  /// The [opacity] argument must not be null and
  /// must be between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;

  /// Creates a copy of this [OpacityModifier] but with the given fields
  /// replaced with the new values.
  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity ?? this.opacity);
  }

  /// Linearly interpolates between this [OpacityModifier] and another [OpacityModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [OpacityModifier] is returned. When [t] is 1.0, the [other] [OpacityModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [OpacityModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [OpacityModifier] instance.
  ///
  /// The interpolation is performed on each property of the [OpacityModifier] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [opacity].

  /// This method is typically used in animations to smoothly transition between
  /// different [OpacityModifier] configurations.
  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    if (other == null) return this;

    return OpacityModifier(MixOps.lerp(opacity, other.opacity, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifier] instances for equality.
  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Represents the attributes of a [OpacityModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [OpacityModifier].
///
/// Use this class to configure the attributes of a [OpacityModifier] and pass it to
/// the [OpacityModifier] constructor.
class OpacityModifierMix extends ModifierMix<OpacityModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityModifierMix.create({this.opacity});

  OpacityModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  /// Resolves to [OpacityModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final opacityModifier = OpacityModifierMix(...).resolve(mix);
  /// ```
  @override
  OpacityModifier resolve(BuildContext context) {
    return OpacityModifier(opacity?.resolveProp(context));
  }

  /// Merges the properties of this [OpacityModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [OpacityModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  OpacityModifierMix merge(OpacityModifierMix? other) {
    if (other == null) return this;

    return OpacityModifierMix.create(
      opacity: MixOps.merge(opacity, other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifierMix] instances for equality.
  @override
  List<Object?> get props => [opacity];
}

final class OpacityModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, OpacityModifierMix> {
  const OpacityModifierUtility(super.builder);

  T call(double value) =>
      builder(OpacityModifierMix.create(opacity: Prop.value(value)));

  T token(MixToken<double> token) =>
      builder(OpacityModifierMix.create(opacity: Prop.token(token)));
}
