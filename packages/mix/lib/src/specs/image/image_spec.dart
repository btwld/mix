import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/animation/animated_config_dto.dart';
import '../../attributes/animation/animated_util.dart';
import '../../attributes/animation/animation_config.dart';
import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'image_widget.dart';

final class ImageSpec extends Spec<ImageSpec> with Diagnosticable {
  final double? width, height;
  final Color? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;

  final BlendMode? colorBlendMode;

  const ImageSpec({
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

  static ImageSpec from(MixContext mix) {
    return mix.attributeOf<ImageSpecAttribute>()?.resolve(mix) ??
        const ImageSpec();
  }

  static ImageSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const ImageSpec();
  }

  Widget call({
    required ImageProvider<Object> image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    bool matchTextDirection = false,
    Animation<double>? opacity,
    List<Type> orderOfModifiers = const [],
  }) {
    return isAnimated
        ? AnimatedImageSpecWidget(
            spec: this,
            image: image,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            duration: animated!.duration,
            curve: animated!.curve,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            matchTextDirection: matchTextDirection,
            orderOfModifiers: orderOfModifiers,
            opacity: opacity,
          )
        : ImageSpecWidget(
            spec: this,
            orderOfModifiers: orderOfModifiers,
            image: image,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            gaplessPlayback: gaplessPlayback,
            isAntiAlias: isAntiAlias,
            opacity: opacity,
            matchTextDirection: matchTextDirection,
          );
  }

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
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      repeat: repeat ?? this.repeat,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      centerSlice: centerSlice ?? this.centerSlice,
      filterQuality: filterQuality ?? this.filterQuality,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      animated: animated ?? this.animated,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  ImageSpec lerp(ImageSpec? other, double t) {
    if (other == null) return this;

    return ImageSpec(
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
      color: Color.lerp(color, other.color, t),
      repeat: t < 0.5 ? repeat : other.repeat,
      fit: t < 0.5 ? fit : other.fit,
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      filterQuality: t < 0.5 ? filterQuality : other.filterQuality,
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
      animated: animated ?? other.animated,
      modifiers: other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('colorBlendMode', colorBlendMode, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

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
}

class ImageSpecAttribute extends SpecAttribute<ImageSpec> with Diagnosticable {
  final double? width;
  final double? height;
  final Prop<Color>? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;
  final BlendMode? colorBlendMode;

  /// Constructor that accepts Prop values directly
  const ImageSpecAttribute.props({
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

  // Factory constructor accepts raw values
  factory ImageSpecAttribute({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfigDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return ImageSpecAttribute.props(
      width: width,
      height: height,
      color: Prop.maybeValue(color),
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      animated: animated,
      modifiers: modifiers,
    );
  }

  /// Constructor that accepts an [ImageSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageSpec] instances to [ImageSpecAttribute].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.value(spec);
  /// ```
  static ImageSpecAttribute value(ImageSpec spec) {
    return ImageSpecAttribute.props(
      width: spec.width,
      height: spec.height,
      color: Prop.maybeValue(spec.color),
      repeat: spec.repeat,
      fit: spec.fit,
      alignment: spec.alignment,
      centerSlice: spec.centerSlice,
      filterQuality: spec.filterQuality,
      colorBlendMode: spec.colorBlendMode,
      animated: AnimationConfigDto.maybeValue(spec.animated),
      modifiers: WidgetModifiersConfigDto.maybeValue(spec.modifiers),
    );
  }

  /// Constructor that accepts a nullable [ImageSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ImageSpecAttribute.value].
  ///
  /// ```dart
  /// const ImageSpec? spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.maybeValue(spec); // Returns ImageSpecAttribute or null
  /// ```
  static ImageSpecAttribute? maybeValue(ImageSpec? spec) {
    return spec != null ? ImageSpecAttribute.value(spec) : null;
  }

  @override
  ImageSpec resolve(MixContext context) {
    return ImageSpec(
      width: width,
      height: height,
      color: color?.resolve(context),
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      animated: animated?.resolve(context),
      modifiers: modifiers?.resolve(context),
    );
  }

  @override
  ImageSpecAttribute merge(ImageSpecAttribute? other) {
    if (other == null) return this;

    return ImageSpecAttribute.props(
      width: other.width ?? width,
      height: other.height ?? height,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('colorBlendMode', colorBlendMode, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

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
}

class ImageSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, ImageSpecAttribute> {
  late final width = DoubleUtility((v) => only(width: v));
  late final height = DoubleUtility((v) => only(height: v));
  late final color = ColorUtility((prop) => builder(ImageSpecAttribute.props(color: prop)));
  late final repeat = ImageRepeatUtility((v) => only(repeat: v));
  late final fit = BoxFitUtility((v) => only(fit: v));
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));
  late final centerSlice = RectUtility((v) => only(centerSlice: v));
  late final filterQuality = FilterQualityUtility(
    (v) => only(filterQuality: v),
  );
  late final colorBlendMode = BlendModeUtility((v) => only(colorBlendMode: v));
  late final animated = AnimatedUtility((v) => only(animated: v));
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  ImageSpecUtility(super.builder);

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  ImageSpecUtility<T> get chain => ImageSpecUtility(attributeBuilder);

  static ImageSpecUtility<ImageSpecAttribute> get self =>
      ImageSpecUtility((v) => v);

  @override
  T only({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfigDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(
      ImageSpecAttribute(
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
      ),
    );
  }
}

/// A tween that interpolates between two [ImageSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ImageSpec] specifications.
class ImageSpecTween extends Tween<ImageSpec?> {
  ImageSpecTween({super.begin, super.end});

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
