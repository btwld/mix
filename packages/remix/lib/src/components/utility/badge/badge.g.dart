// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [BadgeSpec].
mixin _$BadgeSpec on Spec<BadgeSpec> {
  static BadgeSpec from(MixData mix) {
    return mix.attributeOf<BadgeSpecAttribute>()?.resolve(mix) ??
        const BadgeSpec();
  }

  /// {@template badge_spec_of}
  /// Retrieves the [BadgeSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [BadgeSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [BadgeSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final badgeSpec = BadgeSpec.of(context);
  /// ```
  /// {@endtemplate}
  static BadgeSpec of(BuildContext context) {
    return _$BadgeSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [BadgeSpec] but with the given fields
  /// replaced with the new values.
  @override
  BadgeSpec copyWith({
    BoxSpec? container,
    TextSpec? label,
    AnimatedData? animated,
  }) {
    return BadgeSpec(
      container: container ?? _$this.container,
      label: label ?? _$this.label,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [BadgeSpec] and another [BadgeSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [BadgeSpec] is returned. When [t] is 1.0, the [other] [BadgeSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [BadgeSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [BadgeSpec] instance.
  ///
  /// The interpolation is performed on each property of the [BadgeSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [TextSpec.lerp] for [label].
  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [BadgeSpec] is used. Otherwise, the value
  /// from the [other] [BadgeSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [BadgeSpec] configurations.
  @override
  BadgeSpec lerp(BadgeSpec? other, double t) {
    if (other == null) return _$this;

    return BadgeSpec(
      container: _$this.container.lerp(other.container, t),
      label: _$this.label.lerp(other.label, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [BadgeSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BadgeSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.label,
        _$this.animated,
      ];

  BadgeSpec get _$this => this as BadgeSpec;
}

/// Represents the attributes of a [BadgeSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [BadgeSpec].
///
/// Use this class to configure the attributes of a [BadgeSpec] and pass it to
/// the [BadgeSpec] constructor.
class BadgeSpecAttribute extends SpecAttribute<BadgeSpec> {
  final BoxSpecAttribute? container;
  final TextSpecAttribute? label;

  const BadgeSpecAttribute({
    this.container,
    this.label,
    super.animated,
  });

  /// Resolves to [BadgeSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final badgeSpec = BadgeSpecAttribute(...).resolve(mix);
  /// ```
  @override
  BadgeSpec resolve(MixData mix) {
    return BadgeSpec(
      container: container?.resolve(mix),
      label: label?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [BadgeSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BadgeSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BadgeSpecAttribute merge(BadgeSpecAttribute? other) {
    if (other == null) return this;

    return BadgeSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      label: label?.merge(other.label) ?? other.label,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [BadgeSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BadgeSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        label,
        animated,
      ];
}

/// Utility class for configuring [BadgeSpec] properties.
///
/// This class provides methods to set individual properties of a [BadgeSpec].
/// Use the methods of this class to configure specific properties of a [BadgeSpec].
class BadgeSpecUtility<T extends Attribute>
    extends SpecUtility<T, BadgeSpecAttribute> {
  /// Utility for defining [BadgeSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [BadgeSpecAttribute.label]
  late final label = TextSpecUtility((v) => only(label: v));

  /// Utility for defining [BadgeSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  BadgeSpecUtility(super.builder, {super.mutable});

  BadgeSpecUtility<T> get chain =>
      BadgeSpecUtility(attributeBuilder, mutable: true);

  static BadgeSpecUtility<BadgeSpecAttribute> get self =>
      BadgeSpecUtility((v) => v);

  /// Returns a new [BadgeSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    TextSpecAttribute? label,
    AnimatedDataDto? animated,
  }) {
    return builder(BadgeSpecAttribute(
      container: container,
      label: label,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [BadgeSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [BadgeSpec] specifications.
class BadgeSpecTween extends Tween<BadgeSpec?> {
  BadgeSpecTween({
    super.begin,
    super.end,
  });

  @override
  BadgeSpec lerp(double t) {
    if (begin == null && end == null) {
      return const BadgeSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
