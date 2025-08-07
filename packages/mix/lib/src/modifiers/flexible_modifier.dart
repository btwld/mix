import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_modifier.dart';
import '../theme/tokens/mix_token.dart';

final class FlexibleWidgetModifier
    extends WidgetModifier<FlexibleWidgetModifier>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleWidgetModifier({this.flex, this.fit});

  /// Creates a copy of this [FlexibleWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  FlexibleWidgetModifier copyWith({int? flex, FlexFit? fit}) {
    return FlexibleWidgetModifier(
      flex: flex ?? this.flex,
      fit: fit ?? this.fit,
    );
  }

  /// Linearly interpolates between this [FlexibleWidgetModifier] and another [FlexibleWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexibleWidgetModifier] is returned. When [t] is 1.0, the [other] [FlexibleWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexibleWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexibleWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [FlexibleWidgetModifier] using the appropriate
  /// interpolation method:
  /// For [flex] and [fit], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexibleWidgetModifier] is used. Otherwise, the value
  /// from the [other] [FlexibleWidgetModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexibleWidgetModifier] configurations.
  @override
  FlexibleWidgetModifier lerp(FlexibleWidgetModifier? other, double t) {
    if (other == null) return this;

    return FlexibleWidgetModifier(
      flex: MixOps.lerpSnap(flex, other.flex, t),
      fit: MixOps.lerpSnap(fit, other.fit, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexibleWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleWidgetModifier] instances for equality.
  @override
  List<Object?> get props => [flex, fit];

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? FlexFit.loose, child: child);
  }
}

/// Represents the attributes of a [FlexibleWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexibleWidgetModifier].
///
/// Use this class to configure the attributes of a [FlexibleWidgetModifier] and pass it to
/// the [FlexibleWidgetModifier] constructor.
class FlexibleWidgetModifierMix
    extends WidgetModifierMix<FlexibleWidgetModifier>
    with Diagnosticable {
  final Prop<int>? flex;
  final Prop<FlexFit>? fit;

  const FlexibleWidgetModifierMix.create({this.flex, this.fit});

  FlexibleWidgetModifierMix({int? flex, FlexFit? fit})
    : this.create(flex: Prop.maybe(flex), fit: Prop.maybe(fit));

  /// Resolves to [FlexibleWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexibleWidgetModifier = FlexibleWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  FlexibleWidgetModifier resolve(BuildContext context) {
    return FlexibleWidgetModifier(
      flex: flex?.resolveProp(context),
      fit: fit?.resolveProp(context),
    );
  }

  /// Merges the properties of this [FlexibleWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexibleWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexibleWidgetModifierMix merge(FlexibleWidgetModifierMix? other) {
    if (other == null) return this;

    return FlexibleWidgetModifierMix.create(
      flex: flex?.mergeProp(other.flex) ?? other.flex,
      fit: fit?.mergeProp(other.fit) ?? other.fit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexibleWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [flex, fit];
}

final class FlexibleWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, FlexibleWidgetModifierMix> {
  late final fit = MixUtility<T, FlexFit>(
    (prop) => builder(FlexibleWidgetModifierMix(fit: prop)),
  );
  FlexibleWidgetModifierUtility(super.builder);
  T flex(int v) => builder(FlexibleWidgetModifierMix(flex: v));
  T tight({int? flex}) => builder(
    FlexibleWidgetModifierMix.create(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.tight),
    ),
  );

  T loose({int? flex}) => builder(
    FlexibleWidgetModifierMix.create(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.loose),
    ),
  );

  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return builder(FlexibleWidgetModifierMix(flex: flex, fit: fit));
  }

  T flexToken(MixToken<int> token) {
    return builder(FlexibleWidgetModifierMix.create(flex: Prop.token(token)));
  }

  T fitToken(MixToken<FlexFit> token) {
    return builder(FlexibleWidgetModifierMix.create(fit: Prop.token(token)));
  }
}
