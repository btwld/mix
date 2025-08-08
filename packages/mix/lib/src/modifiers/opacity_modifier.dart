import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';
import '../theme/tokens/mix_token.dart';

/// A modifier that wraps a widget with the [Opacity] widget.
///
/// The [Opacity] widget is used to make a widget partially transparent.
final class OpacityWidgetModifier
    extends WidgetModifier<OpacityWidgetModifier>
    with Diagnosticable {
  /// The [opacity] argument must not be null and
  /// must be between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityWidgetModifier([double? opacity]) : opacity = opacity ?? 1.0;

  /// Creates a copy of this [OpacityWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  OpacityWidgetModifier copyWith({double? opacity}) {
    return OpacityWidgetModifier(opacity ?? this.opacity);
  }

  /// Linearly interpolates between this [OpacityWidgetModifier] and another [OpacityWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [OpacityWidgetModifier] is returned. When [t] is 1.0, the [other] [OpacityWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [OpacityWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [OpacityWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [OpacityWidgetModifier] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [opacity].

  /// This method is typically used in animations to smoothly transition between
  /// different [OpacityWidgetModifier] configurations.
  @override
  OpacityWidgetModifier lerp(OpacityWidgetModifier? other, double t) {
    if (other == null) return this;

    return OpacityWidgetModifier(MixOps.lerp(opacity, other.opacity, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityWidgetModifier] instances for equality.
  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Represents the attributes of a [OpacityWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [OpacityWidgetModifier].
///
/// Use this class to configure the attributes of a [OpacityWidgetModifier] and pass it to
/// the [OpacityWidgetModifier] constructor.
class OpacityWidgetModifierMix
    extends WidgetModifierMix<OpacityWidgetModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityWidgetModifierMix.create({this.opacity});

  OpacityWidgetModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  /// Resolves to [OpacityWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final opacityWidgetModifier = OpacityWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  OpacityWidgetModifier resolve(BuildContext context) {
    return OpacityWidgetModifier(opacity?.resolveProp(context));
  }

  /// Merges the properties of this [OpacityWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [OpacityWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  OpacityWidgetModifierMix merge(OpacityWidgetModifierMix? other) {
    if (other == null) return this;

    return OpacityWidgetModifierMix.create(
      opacity: MixOps.merge(opacity, other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [opacity];
}

final class OpacityWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, OpacityWidgetModifierMix> {
  const OpacityWidgetModifierUtility(super.builder);

  T call(double value) =>
      builder(OpacityWidgetModifierMix.create(opacity: Prop.value(value)));

  T token(MixToken<double> token) =>
      builder(OpacityWidgetModifierMix.create(opacity: Prop.token(token)));
}
