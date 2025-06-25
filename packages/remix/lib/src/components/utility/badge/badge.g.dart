// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [BadgeSpec].
mixin _$BadgeSpec on Spec<BadgeSpec> {
  static BadgeSpec from(MixContext mix) {
    return mix.attributeOf<BadgeSpecAttribute>()?.resolve(mix) ??
        const BadgeSpec();
  }

  /// {@template badge_spec_of}
  /// Retrieves the [BadgeSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [BadgeSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [BadgeSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final badgeSpec = BadgeSpec.of(context);
  /// ```
  /// {@endtemplate}
  static BadgeSpec of(BuildContext context) {
    return ComputedStyle.specOf<BadgeSpec>(context) ?? const BadgeSpec();
  }

  /// Creates a copy of this [BadgeSpec] but with the given fields
  /// replaced with the new values.
  @override
  BadgeSpec copyWith({
    BoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    AnimatedData? animated,
  }) {
    return BadgeSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      textStyle: textStyle ?? _$this.textStyle,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [BadgeSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BadgeSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.textStyle,
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
  final IconThemeDataDto? icon;
  final TextStyleDto? textStyle;

  const BadgeSpecAttribute({
    this.container,
    this.icon,
    this.textStyle,
    super.animated,
  });

  /// Resolves to [BadgeSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final badgeSpec = BadgeSpecAttribute(...).resolve(mix);
  /// ```
  @override
  BadgeSpec resolve(MixContext mix) {
    return BadgeSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      textStyle: textStyle?.resolve(mix),
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
      icon: icon?.merge(other.icon) ?? other.icon,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
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
        icon,
        textStyle,
        animated,
      ];
}

/// Utility class for configuring [BadgeSpec] properties.
///
/// This class provides methods to set individual properties of a [BadgeSpec].
/// Use the methods of this class to configure specific properties of a [BadgeSpec].
class BadgeSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, BadgeSpecAttribute> {
  /// Utility for defining [BadgeSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [BadgeSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

  /// Utility for defining [BadgeSpecAttribute.textStyle]
  late final textStyle = TextStyleUtility((v) => only(textStyle: v));

  /// Utility for defining [BadgeSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  BadgeSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  BadgeSpecUtility<T> get chain => BadgeSpecUtility(attributeBuilder);

  static BadgeSpecUtility<BadgeSpecAttribute> get self =>
      BadgeSpecUtility((v) => v);

  /// Returns a new [BadgeSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    IconThemeDataDto? icon,
    TextStyleDto? textStyle,
    AnimatedDataDto? animated,
  }) {
    return builder(BadgeSpecAttribute(
      container: container,
      icon: icon,
      textStyle: textStyle,
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
