import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';
import '../theme/tokens/mix_token.dart';

/// A decorator that wraps a widget with the [Opacity] widget.
///
/// The [Opacity] widget is used to make a widget partially transparent.
final class OpacityWidgetDecorator
    extends WidgetDecorator<OpacityWidgetDecorator>
    with Diagnosticable {
  /// The [opacity] argument must not be null and
  /// must be between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityWidgetDecorator([double? opacity]) : opacity = opacity ?? 1.0;

  /// Creates a copy of this [OpacityWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  OpacityWidgetDecorator copyWith({double? opacity}) {
    return OpacityWidgetDecorator(opacity ?? this.opacity);
  }

  /// Linearly interpolates between this [OpacityWidgetDecorator] and another [OpacityWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [OpacityWidgetDecorator] is returned. When [t] is 1.0, the [other] [OpacityWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [OpacityWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [OpacityWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [OpacityWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [opacity].

  /// This method is typically used in animations to smoothly transition between
  /// different [OpacityWidgetDecorator] configurations.
  @override
  OpacityWidgetDecorator lerp(OpacityWidgetDecorator? other, double t) {
    if (other == null) return this;

    return OpacityWidgetDecorator(MixOps.lerp(opacity, other.opacity, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Represents the attributes of a [OpacityWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [OpacityWidgetDecorator].
///
/// Use this class to configure the attributes of a [OpacityWidgetDecorator] and pass it to
/// the [OpacityWidgetDecorator] constructor.
class OpacityWidgetDecoratorMix
    extends WidgetDecoratorMix<OpacityWidgetDecorator>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityWidgetDecoratorMix.raw({this.opacity});

  OpacityWidgetDecoratorMix({double? opacity})
    : this.raw(opacity: Prop.maybe(opacity));

  /// Resolves to [OpacityWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final opacityWidgetDecorator = OpacityWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  OpacityWidgetDecorator resolve(BuildContext context) {
    return OpacityWidgetDecorator(opacity?.resolveProp(context));
  }

  /// Merges the properties of this [OpacityWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [OpacityWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  OpacityWidgetDecoratorMix merge(OpacityWidgetDecoratorMix? other) {
    if (other == null) return this;

    return OpacityWidgetDecoratorMix.raw(
      opacity: opacity.tryMerge(other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityWidgetDecoratorMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityWidgetDecoratorMix] instances for equality.
  @override
  List<Object?> get props => [opacity];
}

final class OpacityWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, OpacityWidgetDecoratorMix> {
  const OpacityWidgetDecoratorUtility(super.builder);

  T call(double value) =>
      builder(OpacityWidgetDecoratorMix.raw(opacity: Prop.value(value)));

  T token(MixToken<double> token) =>
      builder(OpacityWidgetDecoratorMix.raw(opacity: Prop.token(token)));
}
