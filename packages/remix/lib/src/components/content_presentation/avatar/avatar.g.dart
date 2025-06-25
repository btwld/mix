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
    IconThemeData? icon,
    AnimatedData? animated,
  }) {
    return AvatarSpec(
      container: container ?? _$this.container,
      textStyle: textStyle ?? _$this.textStyle,
      icon: icon ?? _$this.icon,
      animated: animated ?? _$this.animated,
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
        _$this.icon,
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
  final IconThemeDataDto? icon;

  const AvatarSpecAttribute({
    this.container,
    this.textStyle,
    this.icon,
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
      icon: icon?.resolve(mix),
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
      icon: icon?.merge(other.icon) ?? other.icon,
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
        icon,
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

  /// Utility for defining [AvatarSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

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
    IconThemeDataDto? icon,
    AnimatedDataDto? animated,
  }) {
    return builder(AvatarSpecAttribute(
      container: container,
      textStyle: textStyle,
      icon: icon,
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
