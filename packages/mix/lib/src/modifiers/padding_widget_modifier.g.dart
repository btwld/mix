// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'padding_widget_modifier.dart';

// **************************************************************************
// MixableSpecGenerator
// **************************************************************************

mixin _$PaddingModifierSpec on WidgetModifierSpec<PaddingModifierSpec> {
  /// Creates a copy of this [PaddingModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  PaddingModifierSpec copyWith({
    EdgeInsetsGeometry? padding,
  }) {
    return PaddingModifierSpec(
      padding ?? _$this.padding,
    );
  }

  /// Linearly interpolates between this [PaddingModifierSpec] and another [PaddingModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [PaddingModifierSpec] is returned. When [t] is 1.0, the [other] [PaddingModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [PaddingModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [PaddingModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [PaddingModifierSpec] using the appropriate
  /// interpolation method:
  ///
  /// - [EdgeInsetsGeometry.lerp] for [padding].

  /// For , the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [PaddingModifierSpec] is used. Otherwise, the value
  /// from the [other] [PaddingModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [PaddingModifierSpec] configurations.
  @override
  PaddingModifierSpec lerp(PaddingModifierSpec? other, double t) {
    if (other == null) return _$this;

    return PaddingModifierSpec(
      EdgeInsetsGeometry.lerp(_$this.padding, other.padding, t)!,
    );
  }

  /// The list of properties that constitute the state of this [PaddingModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.padding,
      ];

  PaddingModifierSpec get _$this => this as PaddingModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('padding', _$this.padding, defaultValue: null));
  }
}

/// Represents the attributes of a [PaddingModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [PaddingModifierSpec].
///
/// Use this class to configure the attributes of a [PaddingModifierSpec] and pass it to
/// the [PaddingModifierSpec] constructor.
final class PaddingModifierSpecAttribute
    extends WidgetModifierSpecAttribute<PaddingModifierSpec>
    with Diagnosticable {
  final SpacingDto? padding;

  const PaddingModifierSpecAttribute({
    this.padding,
  });

  /// Resolves to [PaddingModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final paddingModifierSpec = PaddingModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  PaddingModifierSpec resolve(MixData mix) {
    return PaddingModifierSpec(
      padding?.resolve(mix),
    );
  }

  /// Merges the properties of this [PaddingModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [PaddingModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  PaddingModifierSpecAttribute merge(PaddingModifierSpecAttribute? other) {
    if (other == null) return this;

    return PaddingModifierSpecAttribute(
      padding: padding?.merge(other.padding) ?? other.padding,
    );
  }

  /// The list of properties that constitute the state of this [PaddingModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [PaddingModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        padding,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
  }
}

/// Utility class for configuring [PaddingModifierSpecAttribute] properties.
///
/// This class provides methods to set individual properties of a [PaddingModifierSpecAttribute].
/// Use the methods of this class to configure specific properties of a [PaddingModifierSpecAttribute].
class PaddingModifierSpecUtility<T extends Attribute>
    extends SpecUtility<T, PaddingModifierSpecAttribute> {
  /// Utility for defining [PaddingModifierSpecAttribute.padding]
  late final padding = SpacingUtility((v) => only(padding: v));

  PaddingModifierSpecUtility(super.builder);

  static final self = PaddingModifierSpecUtility((v) => v);

  /// Returns a new [PaddingModifierSpecAttribute] with the specified properties.
  @override
  T only({
    SpacingDto? padding,
  }) {
    return builder(PaddingModifierSpecAttribute(
      padding: padding,
    ));
  }
}

/// A tween that interpolates between two [PaddingModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [PaddingModifierSpec] specifications.
class PaddingModifierSpecTween extends Tween<PaddingModifierSpec?> {
  PaddingModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  PaddingModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const PaddingModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
