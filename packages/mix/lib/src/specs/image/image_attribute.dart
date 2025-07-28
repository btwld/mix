import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'image_spec.dart';

class ImageSpecAttribute extends Style<ImageSpec>
    with
        Diagnosticable,
        ModifierMixin<ImageSpecAttribute, ImageSpec>,
        VariantMixin<ImageSpecAttribute, ImageSpec> {
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
  late final width = PropUtility<ImageSpecAttribute, double>(
    (prop) => merge(ImageSpecAttribute.raw(width: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.height]
  late final height = PropUtility<ImageSpecAttribute, double>(
    (prop) => merge(ImageSpecAttribute.raw(height: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.color]
  late final color = ColorUtility(
    (prop) => merge(ImageSpecAttribute.raw(color: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.repeat]
  late final repeat = PropUtility<ImageSpecAttribute, ImageRepeat>(
    (prop) => merge(ImageSpecAttribute.raw(repeat: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.fit]
  late final fit = PropUtility<ImageSpecAttribute, BoxFit>(
    (prop) => merge(ImageSpecAttribute.raw(fit: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.alignment]
  late final alignment = PropUtility<ImageSpecAttribute, AlignmentGeometry>(
    (prop) => merge(ImageSpecAttribute.raw(alignment: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.centerSlice]
  late final centerSlice = PropUtility<ImageSpecAttribute, Rect>(
    (prop) => merge(ImageSpecAttribute.raw(centerSlice: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.filterQuality]
  late final filterQuality = PropUtility<ImageSpecAttribute, FilterQuality>(
    (prop) => merge(ImageSpecAttribute.raw(filterQuality: prop)),
  );

  /// Utility for defining [ImageSpecAttribute.colorBlendMode]
  late final colorBlendMode = PropUtility<ImageSpecAttribute, BlendMode>(
    (prop) => merge(ImageSpecAttribute.raw(colorBlendMode: prop)),
  );

  ImageSpecAttribute.raw({
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

  ImageSpecAttribute({
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
  }) : this.raw(
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
    : this(
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
    return ImageSpecAttribute(animation: animation);
  }

  @override
  ImageSpecAttribute variants(List<VariantStyleAttribute<ImageSpec>> variants) {
    return merge(ImageSpecAttribute(variants: variants));
  }

  @override
  ImageSpecAttribute modifiers(List<ModifierAttribute> modifiers) {
    return merge(ImageSpecAttribute(modifiers: modifiers));
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

    return ImageSpecAttribute.raw(
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
  ImageSpecAttribute variant(Variant variant, ImageSpecAttribute style) {
    return merge(
      ImageSpecAttribute(variants: [VariantStyleAttribute(variant, style)]),
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
    $animation,
    $modifiers,
    $variants,
  ];
}
