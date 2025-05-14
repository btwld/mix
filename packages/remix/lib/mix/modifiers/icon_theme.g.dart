// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_theme.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [IconThemeModifierSpec].
mixin _$IconThemeModifierSpec on WidgetModifierSpec<IconThemeModifierSpec> {
  /// Creates a copy of this [IconThemeModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  IconThemeModifierSpec copyWith({
    IconThemeData? data,
  }) {
    return IconThemeModifierSpec(
      data: data ?? _$this.data,
    );
  }

  /// Linearly interpolates between this [IconThemeModifierSpec] and another [IconThemeModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IconThemeModifierSpec] is returned. When [t] is 1.0, the [other] [IconThemeModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IconThemeModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IconThemeModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [IconThemeModifierSpec] using the appropriate
  /// interpolation method:
  /// - [IconThemeData.lerp] for [data].

  /// This method is typically used in animations to smoothly transition between
  /// different [IconThemeModifierSpec] configurations.
  @override
  IconThemeModifierSpec lerp(IconThemeModifierSpec? other, double t) {
    if (other == null) return _$this;

    return IconThemeModifierSpec(
      data: IconThemeData.lerp(_$this.data, other.data, t),
    );
  }

  /// The list of properties that constitute the state of this [IconThemeModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconThemeModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.data,
      ];

  IconThemeModifierSpec get _$this => this as IconThemeModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('data', _$this.data, defaultValue: null));
  }
}

/// Represents the attributes of a [IconThemeModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IconThemeModifierSpec].
///
/// Use this class to configure the attributes of a [IconThemeModifierSpec] and pass it to
/// the [IconThemeModifierSpec] constructor.
class IconThemeModifierSpecAttribute
    extends WidgetModifierSpecAttribute<IconThemeModifierSpec>
    with Diagnosticable {
  final IconThemeDataDto? data;

  const IconThemeModifierSpecAttribute({
    this.data,
  });

  /// Resolves to [IconThemeModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconThemeModifierSpec = IconThemeModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  IconThemeModifierSpec resolve(MixData mix) {
    return IconThemeModifierSpec(
      data: data?.resolve(mix),
    );
  }

  /// Merges the properties of this [IconThemeModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconThemeModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IconThemeModifierSpecAttribute merge(IconThemeModifierSpecAttribute? other) {
    if (other == null) return this;

    return IconThemeModifierSpecAttribute(
      data: data?.merge(other.data) ?? other.data,
    );
  }

  /// The list of properties that constitute the state of this [IconThemeModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconThemeModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        data,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('data', data, defaultValue: null));
  }
}

/// Utility class for configuring [IconThemeModifierSpec] properties.
///
/// This class provides methods to set individual properties of a [IconThemeModifierSpec].
/// Use the methods of this class to configure specific properties of a [IconThemeModifierSpec].
class IconThemeModifierSpecUtility<T extends Attribute>
    extends SpecUtility<T, IconThemeModifierSpecAttribute> {
  /// Utility for defining [IconThemeModifierSpecAttribute.data]
  late final data = IconThemeDataUtility((v) => only(data: v));

  IconThemeModifierSpecUtility(super.builder, {super.mutable});

  IconThemeModifierSpecUtility<T> get chain =>
      IconThemeModifierSpecUtility(attributeBuilder, mutable: true);

  static IconThemeModifierSpecUtility<IconThemeModifierSpecAttribute>
      get self => IconThemeModifierSpecUtility((v) => v);

  /// Returns a new [IconThemeModifierSpecAttribute] with the specified properties.
  @override
  T only({
    IconThemeDataDto? data,
  }) {
    return builder(IconThemeModifierSpecAttribute(
      data: data,
    ));
  }
}

/// A tween that interpolates between two [IconThemeModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IconThemeModifierSpec] specifications.
class IconThemeModifierSpecTween extends Tween<IconThemeModifierSpec?> {
  IconThemeModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  IconThemeModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IconThemeModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
