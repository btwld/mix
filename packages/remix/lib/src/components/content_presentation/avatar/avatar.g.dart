// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [AvatarSpec].
mixin _$AvatarSpec on Spec<AvatarSpec> {
  static AvatarSpec from(MixContext mix) {
    return mix.attributeOf<AvatarSpecAttribute>()?.resolve(mix) ??
        const AvatarSpec();
  }

  /// {@template avatar_spec_of}
  /// Retrieves the [AvatarSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [AvatarSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [AvatarSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final avatarSpec = AvatarSpec.of(context);
  /// ```
  /// {@endtemplate}
  static AvatarSpec of(BuildContext context) {
    return ComputedStyle.specOf<AvatarSpec>(context) ?? const AvatarSpec();
  }

  /// Creates a copy of this [AvatarSpec] but with the given fields
  /// replaced with the new values.
  @override
  AvatarSpec copyWith({
    BoxSpec? container,
    TextStyle? textStyle,
    ImageSpec? image,
    AnimatedData? animated,
  }) {
    return AvatarSpec(
      container: container ?? _$this.container,
      textStyle: textStyle ?? _$this.textStyle,
      image: image ?? _$this.image,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [AvatarSpec] and another [AvatarSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AvatarSpec] is returned. When [t] is 1.0, the [other] [AvatarSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AvatarSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [AvatarSpec] instance.
  ///
  /// The interpolation is performed on each property of the [AvatarSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [MixHelpers.lerpTextStyle] for [textStyle].
  /// - [ImageSpec.lerp] for [image].
  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [AvatarSpec] is used. Otherwise, the value
  /// from the [other] [AvatarSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [AvatarSpec] configurations.
  @override
  AvatarSpec lerp(AvatarSpec? other, double t) {
    if (other == null) return _$this;

    return AvatarSpec(
      container: _$this.container.lerp(other.container, t),
      textStyle:
          MixHelpers.lerpTextStyle(_$this.textStyle, other.textStyle, t)!,
      image: _$this.image.lerp(other.image, t),
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [AvatarSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AvatarSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.textStyle,
        _$this.image,
        _$this.animated,
      ];

  AvatarSpec get _$this => this as AvatarSpec;
}

/// Represents the attributes of a [AvatarSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AvatarSpec].
///
/// Use this class to configure the attributes of a [AvatarSpec] and pass it to
/// the [AvatarSpec] constructor.
class AvatarSpecAttribute extends SpecAttribute<AvatarSpec> {
  final BoxSpecAttribute? container;
  final TextStyleDto? textStyle;
  final ImageSpecAttribute? image;

  const AvatarSpecAttribute({
    this.container,
    this.textStyle,
    this.image,
    super.animated,
  });

  /// Resolves to [AvatarSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final avatarSpec = AvatarSpecAttribute(...).resolve(mix);
  /// ```
  @override
  AvatarSpec resolve(MixContext mix) {
    return AvatarSpec(
      container: container?.resolve(mix),
      textStyle: textStyle?.resolve(mix),
      image: image?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [AvatarSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AvatarSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AvatarSpecAttribute merge(AvatarSpecAttribute? other) {
    if (other == null) return this;

    return AvatarSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      image: image?.merge(other.image) ?? other.image,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [AvatarSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AvatarSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        textStyle,
        image,
        animated,
      ];
}

/// Utility class for configuring [AvatarSpec] properties.
///
/// This class provides methods to set individual properties of a [AvatarSpec].
/// Use the methods of this class to configure specific properties of a [AvatarSpec].
class AvatarSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, AvatarSpecAttribute> {
  /// Utility for defining [AvatarSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [AvatarSpecAttribute.textStyle]
  late final textStyle = TextStyleUtility((v) => only(textStyle: v));

  /// Utility for defining [AvatarSpecAttribute.image]
  late final image = ImageSpecUtility((v) => only(image: v));

  /// Utility for defining [AvatarSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  AvatarSpecUtility(
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
  AvatarSpecUtility<T> get chain => AvatarSpecUtility(attributeBuilder);

  static AvatarSpecUtility<AvatarSpecAttribute> get self =>
      AvatarSpecUtility((v) => v);

  /// Returns a new [AvatarSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    TextStyleDto? textStyle,
    ImageSpecAttribute? image,
    AnimatedDataDto? animated,
  }) {
    return builder(AvatarSpecAttribute(
      container: container,
      textStyle: textStyle,
      image: image,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [AvatarSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [AvatarSpec] specifications.
class AvatarSpecTween extends Tween<AvatarSpec?> {
  AvatarSpecTween({
    super.begin,
    super.end,
  });

  @override
  AvatarSpec lerp(double t) {
    if (begin == null && end == null) {
      return const AvatarSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
