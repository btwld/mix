// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

final class FractionallySizedBoxModifier
    extends Modifier<FractionallySizedBoxModifier>
    with Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  const FractionallySizedBoxModifier({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  /// Creates a copy of this [FractionallySizedBoxModifier] but with the given fields
  /// replaced with the new values.
  @override
  FractionallySizedBoxModifier copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxModifier(
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      alignment: alignment ?? this.alignment,
    );
  }

  /// Linearly interpolates between this [FractionallySizedBoxModifier] and another [FractionallySizedBoxModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FractionallySizedBoxModifier] is returned. When [t] is 1.0, the [other] [FractionallySizedBoxModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FractionallySizedBoxModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [FractionallySizedBoxModifier] instance.
  ///
  /// The interpolation is performed on each property of the [FractionallySizedBoxModifier] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [widthFactor] and [heightFactor].
  /// - [AlignmentGeometry.lerp] for [alignment].

  /// This method is typically used in animations to smoothly transition between
  /// different [FractionallySizedBoxModifier] configurations.
  @override
  FractionallySizedBoxModifier lerp(
    FractionallySizedBoxModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifier(
      widthFactor: MixHelpers.lerpDouble(widthFactor, other.widthFactor, t),
      heightFactor: MixHelpers.lerpDouble(heightFactor, other.heightFactor, t),
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
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

  /// The list of properties that constitute the state of this [FractionallySizedBoxModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FractionallySizedBoxModifier] instances for equality.
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

/// Represents the attributes of a [FractionallySizedBoxModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FractionallySizedBoxModifier].
///
/// Use this class to configure the attributes of a [FractionallySizedBoxModifier] and pass it to
/// the [FractionallySizedBoxModifier] constructor.
class FractionallySizedBoxModifierAttribute
    extends ModifierAttribute<FractionallySizedBoxModifier> {
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;
  final Prop<AlignmentGeometry>? alignment;

  const FractionallySizedBoxModifierAttribute({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  FractionallySizedBoxModifierAttribute.only({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) : this(
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
         alignment: Prop.maybe(alignment),
       );

  /// Resolves to [FractionallySizedBoxModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final fractionallySizedBoxModifierSpec = FractionallySizedBoxModifierAttribute(...).resolve(mix);
  /// ```
  @override
  FractionallySizedBoxModifier resolve(BuildContext context) {
    return FractionallySizedBoxModifier(
      widthFactor: MixHelpers.resolve(context, widthFactor),
      heightFactor: MixHelpers.resolve(context, heightFactor),
      alignment: MixHelpers.resolve(context, alignment),
    );
  }

  /// Merges the properties of this [FractionallySizedBoxModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FractionallySizedBoxModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FractionallySizedBoxModifierAttribute merge(
    FractionallySizedBoxModifierAttribute? other,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifierAttribute(
      widthFactor: MixHelpers.merge(widthFactor, other.widthFactor),
      heightFactor: MixHelpers.merge(heightFactor, other.heightFactor),
      alignment: MixHelpers.merge(alignment, other.alignment),
    );
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];
}

/// A tween that interpolates between two [FractionallySizedBoxModifier] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FractionallySizedBoxModifier] specifications.
class FractionallySizedBoxModifierSpecTween
    extends Tween<FractionallySizedBoxModifier?> {
  FractionallySizedBoxModifierSpecTween({super.begin, super.end});

  @override
  FractionallySizedBoxModifier lerp(double t) {
    if (begin == null && end == null) {
      return const FractionallySizedBoxModifier();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class FractionallySizedBoxModifierUtility<T extends SpecStyle<Object?>>
    extends MixUtility<T, FractionallySizedBoxModifierAttribute> {
  const FractionallySizedBoxModifierUtility(super.builder);

  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      FractionallySizedBoxModifierAttribute(
        widthFactor: Prop.maybe(widthFactor),
        heightFactor: Prop.maybe(heightFactor),
        alignment: Prop.maybe(alignment),
      ),
    );
  }
}
