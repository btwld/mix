// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ImageSpec].
mixin _$ImageSpec on Spec<ImageSpec> {
  static ImageSpec from(MixContext mix) {
    return mix.attributeOf<ImageSpecAttribute>()?.resolve(mix) ??
        const ImageSpec();
  }

  /// {@template image_spec_of}
  /// Retrieves the [ImageSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [ImageSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [ImageSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final imageSpec = ImageSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ImageSpec of(BuildContext context) {
    return ComputedStyle.specOf<ImageSpec>(context) ?? const ImageSpec();
  }

  /// Creates a copy of this [ImageSpec] but with the given fields
  /// replaced with the new values.
  @override
  ImageSpec copyWith({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfig? animated,
    WidgetModifiersConfig? modifiers,
  }) {
    return ImageSpec(
      width: width ?? _$this.width,
      height: height ?? _$this.height,
      color: color ?? _$this.color,
      repeat: repeat ?? _$this.repeat,
      fit: fit ?? _$this.fit,
      alignment: alignment ?? _$this.alignment,
      centerSlice: centerSlice ?? _$this.centerSlice,
      filterQuality: filterQuality ?? _$this.filterQuality,
      colorBlendMode: colorBlendMode ?? _$this.colorBlendMode,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [ImageSpec] and another [ImageSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ImageSpec] is returned. When [t] is 1.0, the [other] [ImageSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ImageSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ImageSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ImageSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [width] and [height].
  /// - [Color.lerp] for [color].
  /// - [AlignmentGeometry.lerp] for [alignment].
  /// - [Rect.lerp] for [centerSlice].
  /// For [repeat] and [fit] and [filterQuality] and [colorBlendMode] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ImageSpec] is used. Otherwise, the value
  /// from the [other] [ImageSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ImageSpec] configurations.
  @override
  ImageSpec lerp(ImageSpec? other, double t) {
    if (other == null) return _$this;

    return ImageSpec(
      width: MixHelpers.lerpDouble(_$this.width, other.width, t),
      height: MixHelpers.lerpDouble(_$this.height, other.height, t),
      color: Color.lerp(_$this.color, other.color, t),
      repeat: t < 0.5 ? _$this.repeat : other.repeat,
      fit: t < 0.5 ? _$this.fit : other.fit,
      alignment: AlignmentGeometry.lerp(_$this.alignment, other.alignment, t),
      centerSlice: Rect.lerp(_$this.centerSlice, other.centerSlice, t),
      filterQuality: t < 0.5 ? _$this.filterQuality : other.filterQuality,
      colorBlendMode: t < 0.5 ? _$this.colorBlendMode : other.colorBlendMode,
      animated: _$this.animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ImageSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ImageSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.width,
        _$this.height,
        _$this.color,
        _$this.repeat,
        _$this.fit,
        _$this.alignment,
        _$this.centerSlice,
        _$this.filterQuality,
        _$this.colorBlendMode,
        _$this.animated,
        _$this.modifiers,
      ];

  ImageSpec get _$this => this as ImageSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('width', _$this.width, defaultValue: null));
    properties
        .add(DiagnosticsProperty('height', _$this.height, defaultValue: null));
    properties
        .add(DiagnosticsProperty('color', _$this.color, defaultValue: null));
    properties
        .add(DiagnosticsProperty('repeat', _$this.repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', _$this.fit, defaultValue: null));
    properties.add(
        DiagnosticsProperty('alignment', _$this.alignment, defaultValue: null));
    properties.add(DiagnosticsProperty('centerSlice', _$this.centerSlice,
        defaultValue: null));
    properties.add(DiagnosticsProperty('filterQuality', _$this.filterQuality,
        defaultValue: null));
    properties.add(DiagnosticsProperty('colorBlendMode', _$this.colorBlendMode,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [ImageSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ImageSpec].
///
/// Use this class to configure the attributes of a [ImageSpec] and pass it to
/// the [ImageSpec] constructor.
class ImageSpecAttribute extends SpecAttribute<ImageSpec> with Diagnosticable {
  final SpaceDto? width;
  final SpaceDto? height;
  final ColorDto? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;
  final BlendMode? colorBlendMode;

  const ImageSpecAttribute({
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [ImageSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final imageSpec = ImageSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ImageSpec resolve(MixContext mix) {
    return ImageSpec(
      width: width?.resolve(mix),
      height: height?.resolve(mix),
      color: color?.resolve(mix),
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      animated: animated?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [ImageSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ImageSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ImageSpecAttribute merge(ImageSpecAttribute? other) {
    if (other == null) return this;

    return ImageSpecAttribute(
      width: width?.merge(other.width) ?? other.width,
      height: height?.merge(other.height) ?? other.height,
      color: color?.merge(other.color) ?? other.color,
      repeat: other.repeat ?? repeat,
      fit: other.fit ?? fit,
      alignment: other.alignment ?? alignment,
      centerSlice: other.centerSlice ?? centerSlice,
      filterQuality: other.filterQuality ?? filterQuality,
      colorBlendMode: other.colorBlendMode ?? colorBlendMode,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [ImageSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ImageSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        width,
        height,
        color,
        repeat,
        fit,
        alignment,
        centerSlice,
        filterQuality,
        colorBlendMode,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties
        .add(DiagnosticsProperty('alignment', alignment, defaultValue: null));
    properties.add(
        DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null));
    properties.add(DiagnosticsProperty('filterQuality', filterQuality,
        defaultValue: null));
    properties.add(DiagnosticsProperty('colorBlendMode', colorBlendMode,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [ImageSpec] properties.
///
/// This class provides methods to set individual properties of a [ImageSpec].
/// Use the methods of this class to configure specific properties of a [ImageSpec].
class ImageSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, ImageSpecAttribute> {
  /// Utility for defining [ImageSpecAttribute.width]
  late final width = DoubleUtility((v) => only(width: v));

  /// Utility for defining [ImageSpecAttribute.height]
  late final height = DoubleUtility((v) => only(height: v));

  /// Utility for defining [ImageSpecAttribute.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [ImageSpecAttribute.repeat]
  late final repeat = ImageRepeatUtility((v) => only(repeat: v));

  /// Utility for defining [ImageSpecAttribute.fit]
  late final fit = BoxFitUtility((v) => only(fit: v));

  /// Utility for defining [ImageSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [ImageSpecAttribute.centerSlice]
  late final centerSlice = RectUtility((v) => only(centerSlice: v));

  /// Utility for defining [ImageSpecAttribute.filterQuality]
  late final filterQuality =
      FilterQualityUtility((v) => only(filterQuality: v));

  /// Utility for defining [ImageSpecAttribute.colorBlendMode]
  late final colorBlendMode = BlendModeUtility((v) => only(colorBlendMode: v));

  /// Utility for defining [ImageSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [ImageSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  ImageSpecUtility(
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
  ImageSpecUtility<T> get chain => ImageSpecUtility(attributeBuilder);

  static ImageSpecUtility<ImageSpecAttribute> get self =>
      ImageSpecUtility((v) => v);

  /// Returns a new [ImageSpecAttribute] with the specified properties.
  @override
  T only({
    SpaceDto? width,
    SpaceDto? height,
    ColorDto? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfigDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(ImageSpecAttribute(
      width: width,
      height: height,
      color: color,
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [ImageSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ImageSpec] specifications.
class ImageSpecTween extends Tween<ImageSpec?> {
  ImageSpecTween({
    super.begin,
    super.end,
  });

  @override
  ImageSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ImageSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
