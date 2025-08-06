import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/widget_decorator.dart';

final class FractionallySizedBoxWidgetDecorator
    extends WidgetDecorator<FractionallySizedBoxWidgetDecorator>
    with Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  const FractionallySizedBoxWidgetDecorator({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  /// Creates a copy of this [FractionallySizedBoxWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  FractionallySizedBoxWidgetDecorator copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxWidgetDecorator(
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      alignment: alignment ?? this.alignment,
    );
  }

  /// Linearly interpolates between this [FractionallySizedBoxWidgetDecorator] and another [FractionallySizedBoxWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FractionallySizedBoxWidgetDecorator] is returned. When [t] is 1.0, the [other] [FractionallySizedBoxWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FractionallySizedBoxWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [FractionallySizedBoxWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [FractionallySizedBoxWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [MixOps.lerp] for [widthFactor] and [heightFactor].
  /// - [AlignmentGeometry.lerp] for [alignment].

  /// This method is typically used in animations to smoothly transition between
  /// different [FractionallySizedBoxWidgetDecorator] configurations.
  @override
  FractionallySizedBoxWidgetDecorator lerp(
    FractionallySizedBoxWidgetDecorator? other,
    double t,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxWidgetDecorator(
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
      alignment: MixOps.lerp(alignment, other.alignment, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('widthFactor', widthFactor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('heightFactor', heightFactor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [FractionallySizedBoxWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FractionallySizedBoxWidgetDecorator] instances for equality.
  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];

  @override
  Widget build(Widget child) {
    return FractionallySizedBox(
      alignment: alignment ?? Alignment.center,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

/// Represents the attributes of a [FractionallySizedBoxWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FractionallySizedBoxWidgetDecorator].
///
/// Use this class to configure the attributes of a [FractionallySizedBoxWidgetDecorator] and pass it to
/// the [FractionallySizedBoxWidgetDecorator] constructor.
class FractionallySizedBoxWidgetDecoratorMix
    extends WidgetDecoratorMix<FractionallySizedBoxWidgetDecorator> {
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;
  final Prop<AlignmentGeometry>? alignment;

  const FractionallySizedBoxWidgetDecoratorMix.create({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  FractionallySizedBoxWidgetDecoratorMix({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) : this.create(
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
         alignment: Prop.maybe(alignment),
       );

  /// Resolves to [FractionallySizedBoxWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final fractionallySizedBoxWidgetDecorator = FractionallySizedBoxWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  FractionallySizedBoxWidgetDecorator resolve(BuildContext context) {
    return FractionallySizedBoxWidgetDecorator(
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
      alignment: MixOps.resolve(context, alignment),
    );
  }

  /// Merges the properties of this [FractionallySizedBoxWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FractionallySizedBoxWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FractionallySizedBoxWidgetDecoratorMix merge(
    FractionallySizedBoxWidgetDecoratorMix? other,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxWidgetDecoratorMix.create(
      widthFactor: widthFactor.tryMerge(other.widthFactor),
      heightFactor: heightFactor.tryMerge(other.heightFactor),
      alignment: alignment.tryMerge(other.alignment),
    );
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];
}

final class FractionallySizedBoxWidgetDecoratorUtility<T extends Style<Object?>>
    extends MixUtility<T, FractionallySizedBoxWidgetDecoratorMix> {
  const FractionallySizedBoxWidgetDecoratorUtility(super.builder);

  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      FractionallySizedBoxWidgetDecoratorMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }
}
