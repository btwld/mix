import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';
import '../theme/tokens/mix_token.dart';

final class AspectRatioWidgetModifier
    extends WidgetModifier<AspectRatioWidgetModifier>
    with Diagnosticable {
  final double aspectRatio;

  const AspectRatioWidgetModifier([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  /// Creates a copy of this [AspectRatioWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  AspectRatioWidgetModifier copyWith({double? aspectRatio}) {
    return AspectRatioWidgetModifier(aspectRatio ?? this.aspectRatio);
  }

  /// Linearly interpolates between this [AspectRatioWidgetModifier] and another [AspectRatioWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AspectRatioWidgetModifier] is returned. When [t] is 1.0, the [other] [AspectRatioWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AspectRatioWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [AspectRatioWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [AspectRatioWidgetModifier] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [aspectRatio].

  /// This method is typically used in animations to smoothly transition between
  /// different [AspectRatioWidgetModifier] configurations.
  @override
  AspectRatioWidgetModifier lerp(AspectRatioWidgetModifier? other, double t) {
    if (other == null) return this;

    return AspectRatioWidgetModifier(
      MixOps.lerp(aspectRatio, other.aspectRatio, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioWidgetModifier] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Represents the attributes of a [AspectRatioWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AspectRatioWidgetModifier].
///
/// Use this class to configure the attributes of a [AspectRatioWidgetModifier] and pass it to
/// the [AspectRatioWidgetModifier] constructor.
class AspectRatioWidgetModifierMix
    extends WidgetModifierMix<AspectRatioWidgetModifier>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioWidgetModifierMix.create({this.aspectRatio});

  AspectRatioWidgetModifierMix({double? aspectRatio})
    : this.create(aspectRatio: Prop.maybe(aspectRatio));

  /// Resolves to [AspectRatioWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final aspectRatioWidgetModifier = AspectRatioWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  AspectRatioWidgetModifier resolve(BuildContext context) {
    return AspectRatioWidgetModifier(aspectRatio?.resolveProp(context));
  }

  /// Merges the properties of this [AspectRatioWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AspectRatioWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AspectRatioWidgetModifierMix merge(AspectRatioWidgetModifierMix? other) {
    if (other == null) return this;

    return AspectRatioWidgetModifierMix.create(
      aspectRatio: MixOps.merge(aspectRatio, other.aspectRatio),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];
}

final class AspectRatioWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AspectRatioWidgetModifierMix> {
  const AspectRatioWidgetModifierUtility(super.builder);

  T call(double value) {
    return builder(
      AspectRatioWidgetModifierMix.create(aspectRatio: Prop.value(value)),
    );
  }

  T token(MixToken<double> token) {
    return builder(
      AspectRatioWidgetModifierMix.create(aspectRatio: Prop.token(token)),
    );
  }
}
