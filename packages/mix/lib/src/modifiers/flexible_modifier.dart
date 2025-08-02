import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

final class FlexibleWidgetDecorator extends WidgetDecorator<FlexibleWidgetDecorator>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleWidgetDecorator({this.flex, this.fit});

  /// Creates a copy of this [FlexibleWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  FlexibleWidgetDecorator copyWith({int? flex, FlexFit? fit}) {
    return FlexibleWidgetDecorator(flex: flex ?? this.flex, fit: fit ?? this.fit);
  }

  /// Linearly interpolates between this [FlexibleWidgetDecorator] and another [FlexibleWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexibleWidgetDecorator] is returned. When [t] is 1.0, the [other] [FlexibleWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexibleWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexibleWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [FlexibleWidgetDecorator] using the appropriate
  /// interpolation method:
  /// For [flex] and [fit], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexibleWidgetDecorator] is used. Otherwise, the value
  /// from the [other] [FlexibleWidgetDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexibleWidgetDecorator] configurations.
  @override
  FlexibleWidgetDecorator lerp(FlexibleWidgetDecorator? other, double t) {
    if (other == null) return this;

    return FlexibleWidgetDecorator(
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

  /// The list of properties that constitute the state of this [FlexibleWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [flex, fit];

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? FlexFit.loose, child: child);
  }
}

/// Represents the attributes of a [FlexibleWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexibleWidgetDecorator].
///
/// Use this class to configure the attributes of a [FlexibleWidgetDecorator] and pass it to
/// the [FlexibleWidgetDecorator] constructor.
class FlexibleWidgetDecoratorStyle extends WidgetDecoratorStyle<FlexibleWidgetDecorator>
    with Diagnosticable {
  final Prop<int>? flex;
  final Prop<FlexFit>? fit;

  const FlexibleWidgetDecoratorStyle.raw({this.flex, this.fit});

  FlexibleWidgetDecoratorStyle({int? flex, FlexFit? fit})
    : this.raw(flex: Prop.maybe(flex), fit: Prop.maybe(fit));

  /// Resolves to [FlexibleWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexibleModifierSpec = FlexibleWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  FlexibleWidgetDecorator resolve(BuildContext context) {
    return FlexibleWidgetDecorator(
      flex: flex?.resolveProp(context),
      fit: fit?.resolveProp(context),
    );
  }

  /// Merges the properties of this [FlexibleWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexibleWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexibleWidgetDecoratorStyle merge(FlexibleWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return FlexibleWidgetDecoratorStyle.raw(
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

  /// The list of properties that constitute the state of this [FlexibleWidgetDecoratorStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleWidgetDecoratorStyle] instances for equality.
  @override
  List<Object?> get props => [flex, fit];
}

final class FlexibleWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, FlexibleWidgetDecoratorStyle> {
  late final fit = MixUtility<T, FlexFit>(
    (prop) => builder(FlexibleWidgetDecoratorStyle(fit: prop)),
  );
  FlexibleWidgetDecoratorUtility(super.builder);
  T flex(int v) => builder(FlexibleWidgetDecoratorStyle(flex: v));
  T tight({int? flex}) => builder(
    FlexibleWidgetDecoratorStyle.raw(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.tight),
    ),
  );

  T loose({int? flex}) => builder(
    FlexibleWidgetDecoratorStyle.raw(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.loose),
    ),
  );

  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return builder(FlexibleWidgetDecoratorStyle(flex: flex, fit: fit));
  }

  T flexToken(MixToken<int> token) {
    return builder(FlexibleWidgetDecoratorStyle.raw(flex: Prop.token(token)));
  }

  T fitToken(MixToken<FlexFit> token) {
    return builder(FlexibleWidgetDecoratorStyle.raw(fit: Prop.token(token)));
  }
}
