import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';
import '../theme/tokens/mix_token.dart';

final class AspectRatioWidgetDecorator
    extends WidgetDecorator<AspectRatioWidgetDecorator>
    with Diagnosticable {
  final double aspectRatio;

  const AspectRatioWidgetDecorator([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  /// Creates a copy of this [AspectRatioWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  AspectRatioWidgetDecorator copyWith({double? aspectRatio}) {
    return AspectRatioWidgetDecorator(aspectRatio ?? this.aspectRatio);
  }

  /// Linearly interpolates between this [AspectRatioWidgetDecorator] and another [AspectRatioWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AspectRatioWidgetDecorator] is returned. When [t] is 1.0, the [other] [AspectRatioWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AspectRatioWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [AspectRatioWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [AspectRatioWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [aspectRatio].

  /// This method is typically used in animations to smoothly transition between
  /// different [AspectRatioWidgetDecorator] configurations.
  @override
  AspectRatioWidgetDecorator lerp(AspectRatioWidgetDecorator? other, double t) {
    if (other == null) return this;

    return AspectRatioWidgetDecorator(
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

  /// The list of properties that constitute the state of this [AspectRatioWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Represents the attributes of a [AspectRatioWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AspectRatioWidgetDecorator].
///
/// Use this class to configure the attributes of a [AspectRatioWidgetDecorator] and pass it to
/// the [AspectRatioWidgetDecorator] constructor.
class AspectRatioWidgetDecoratorMix
    extends WidgetDecoratorMix<AspectRatioWidgetDecorator>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioWidgetDecoratorMix.create({this.aspectRatio});

  AspectRatioWidgetDecoratorMix({double? aspectRatio})
    : this.create(aspectRatio: Prop.maybe(aspectRatio));

  /// Resolves to [AspectRatioWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final aspectRatioWidgetDecorator = AspectRatioWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  AspectRatioWidgetDecorator resolve(BuildContext context) {
    return AspectRatioWidgetDecorator(aspectRatio?.resolveProp(context));
  }

  /// Merges the properties of this [AspectRatioWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AspectRatioWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AspectRatioWidgetDecoratorMix merge(AspectRatioWidgetDecoratorMix? other) {
    if (other == null) return this;

    return AspectRatioWidgetDecoratorMix.create(
      aspectRatio: aspectRatio.tryMerge(other.aspectRatio),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioWidgetDecoratorMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioWidgetDecoratorMix] instances for equality.
  @override
  List<Object?> get props => [aspectRatio];
}

final class AspectRatioWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, AspectRatioWidgetDecoratorMix> {
  const AspectRatioWidgetDecoratorUtility(super.builder);

  T call(double value) {
    return builder(
      AspectRatioWidgetDecoratorMix.create(aspectRatio: Prop.value(value)),
    );
  }

  T token(MixToken<double> token) {
    return builder(
      AspectRatioWidgetDecoratorMix.create(aspectRatio: Prop.token(token)),
    );
  }
}
