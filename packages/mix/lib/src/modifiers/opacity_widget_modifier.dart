// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/spec.dart';
import '../core/utility.dart';

/// A modifier that wraps a widget with the [Opacity] widget.
///
/// The [Opacity] widget is used to make a widget partially transparent.
final class OpacityModifierSpec extends WidgetModifierSpec<OpacityModifierSpec>
    with Diagnosticable {
  /// The [opacity] argument must not be null and
  /// must be between 0.0 and 1.0 (inclusive).
  final double opacity;
  const OpacityModifierSpec([double? opacity]) : opacity = opacity ?? 1.0;

  /// Creates a copy of this [OpacityModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  OpacityModifierSpec copyWith({double? opacity}) {
    return OpacityModifierSpec(opacity ?? this.opacity);
  }

  /// Linearly interpolates between this [OpacityModifierSpec] and another [OpacityModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [OpacityModifierSpec] is returned. When [t] is 1.0, the [other] [OpacityModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [OpacityModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [OpacityModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [OpacityModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [opacity].

  /// This method is typically used in animations to smoothly transition between
  /// different [OpacityModifierSpec] configurations.
  @override
  OpacityModifierSpec lerp(OpacityModifierSpec? other, double t) {
    if (other == null) return this;

    return OpacityModifierSpec(
      MixHelpers.lerpDouble(opacity, other.opacity, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifierSpec] instances for equality.
  @override
  List<Object?> get props => [opacity];

  @override
  Widget build(Widget child) {
    return Opacity(opacity: opacity, child: child);
  }
}

/// Represents the attributes of a [OpacityModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [OpacityModifierSpec].
///
/// Use this class to configure the attributes of a [OpacityModifierSpec] and pass it to
/// the [OpacityModifierSpec] constructor.
class OpacityModifierSpecAttribute
    extends WidgetModifierSpecAttribute<OpacityModifierSpec> {
  final double? opacity;

  const OpacityModifierSpecAttribute({this.opacity});

  /// Resolves to [OpacityModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final opacityModifierSpec = OpacityModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  OpacityModifierSpec resolve(BuildContext context) {
    return OpacityModifierSpec(opacity);
  }

  /// Merges the properties of this [OpacityModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [OpacityModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  OpacityModifierSpecAttribute merge(OpacityModifierSpecAttribute? other) {
    if (other == null) return this;

    return OpacityModifierSpecAttribute(opacity: other.opacity ?? opacity);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [OpacityModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [opacity];
}

/// A tween that interpolates between two [OpacityModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [OpacityModifierSpec] specifications.
class OpacityModifierSpecTween extends Tween<OpacityModifierSpec?> {
  OpacityModifierSpecTween({super.begin, super.end});

  @override
  OpacityModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const OpacityModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class OpacityModifierSpecUtility<T extends SpecAttribute>
    extends MixUtility<T, OpacityModifierSpecAttribute> {
  const OpacityModifierSpecUtility(super.builder);
  T call(double value) => builder(OpacityModifierSpecAttribute(opacity: value));
}
