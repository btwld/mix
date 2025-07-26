import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/color_util.dart';
import '../../attributes/scalar_util.dart';
import '../../core/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import 'image_spec.dart';

class ImageSpecAttribute extends StyleAttribute<ImageSpec> with Diagnosticable {
  final Prop<double>? $width;
  final Prop<double>? $height;
  final Prop<Color>? $color;
  final Prop<ImageRepeat>? $repeat;
  final Prop<BoxFit>? $fit;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Rect>? $centerSlice;
  final Prop<FilterQuality>? $filterQuality;
  final Prop<BlendMode>? $colorBlendMode;

  /// Utility for defining [ImageSpecAttribute.width]
  late final width = DoubleUtility(
    (prop) => merge(ImageSpecAttribute(width: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.height]
  late final height = DoubleUtility(
    (prop) => merge(ImageSpecAttribute(height: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.color]
  late final color = ColorUtility(
    (prop) => merge(ImageSpecAttribute(color: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.repeat]
  late final repeat = ImageRepeatUtility(
    (prop) => merge(ImageSpecAttribute(repeat: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.fit]
  late final fit = BoxFitUtility(
    (prop) => merge(ImageSpecAttribute(fit: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility(
    (prop) => merge(ImageSpecAttribute(alignment: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.centerSlice]
  late final centerSlice = RectUtility(
    (prop) => merge(ImageSpecAttribute(centerSlice: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.filterQuality]
  late final filterQuality = FilterQualityUtility(
    (prop) => merge(ImageSpecAttribute(filterQuality: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.colorBlendMode]
  late final colorBlendMode = BlendModeUtility(
    (prop) => merge(ImageSpecAttribute(colorBlendMode: prop)),
  );

  ImageSpecAttribute({
    Prop<double>? width,
    Prop<double>? height,
    Prop<Color>? color,
    Prop<ImageRepeat>? repeat,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<FilterQuality>? filterQuality,
    Prop<BlendMode>? colorBlendMode,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $width = width,
       $height = height,
       $color = color,
       $repeat = repeat,
       $fit = fit,
       $alignment = alignment,
       $centerSlice = centerSlice,
       $filterQuality = filterQuality,
       $colorBlendMode = colorBlendMode;

  ImageSpecAttribute.only({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<ImageSpec>>? variants,
  }) : this(
         width: Prop.maybe(width),
         height: Prop.maybe(height),
         color: Prop.maybe(color),
         repeat: Prop.maybe(repeat),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         filterQuality: Prop.maybe(filterQuality),
         colorBlendMode: Prop.maybe(colorBlendMode),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts an [ImageSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageSpec] instances to [ImageSpecAttribute].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.value(spec);
  /// ```
  ImageSpecAttribute.value(ImageSpec spec)
    : this.only(
        width: spec.width,
        height: spec.height,
        color: spec.color,
        repeat: spec.repeat,
        fit: spec.fit,
        alignment: spec.alignment,
        centerSlice: spec.centerSlice,
        filterQuality: spec.filterQuality,
        colorBlendMode: spec.colorBlendMode,
      );

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

  /// Convenience method for animating the ImageSpec
  ImageSpecAttribute animate(AnimationConfig animation) {
    return ImageSpecAttribute.only(animation: animation);
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return ImageSpec(
      width: MixHelpers.resolve(context, $width),
      height: MixHelpers.resolve(context, $height),
      color: MixHelpers.resolve(context, $color),
      repeat: MixHelpers.resolve(context, $repeat),
      fit: MixHelpers.resolve(context, $fit),
      alignment: MixHelpers.resolve(context, $alignment),
      centerSlice: MixHelpers.resolve(context, $centerSlice),
      filterQuality: MixHelpers.resolve(context, $filterQuality),
      colorBlendMode: MixHelpers.resolve(context, $colorBlendMode),
    );
  }

  @override
  ImageSpecAttribute merge(ImageSpecAttribute? other) {
    if (other == null) return this;

    return ImageSpecAttribute(
      width: MixHelpers.merge($width, other.$width),
      height: MixHelpers.merge($height, other.$height),
      color: MixHelpers.merge($color, other.$color),
      repeat: MixHelpers.merge($repeat, other.$repeat),
      fit: MixHelpers.merge($fit, other.$fit),
      alignment: MixHelpers.merge($alignment, other.$alignment),
      centerSlice: MixHelpers.merge($centerSlice, other.$centerSlice),
      filterQuality: MixHelpers.merge($filterQuality, other.$filterQuality),
      colorBlendMode: MixHelpers.merge($colorBlendMode, other.$colorBlendMode),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', $width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', $height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', $color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', $repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', $fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', $centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', $filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'colorBlendMode',
        $colorBlendMode,
        defaultValue: null,
      ),
    );
  }

  @override
  List<Object?> get props => [
    $width,
    $height,
    $color,
    $repeat,
    $fit,
    $alignment,
    $centerSlice,
    $filterQuality,
    $colorBlendMode,
  ];
}
