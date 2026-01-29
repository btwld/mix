import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import 'image_mutable_style.dart';
import 'image_spec.dart';
import 'image_widget.dart';

part 'image_style.g.dart';

@Deprecated('Use ImageStyler instead')
typedef ImageMix = ImageStyler;

@MixableStyler()
class ImageStyler extends Style<ImageSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<ImageStyler, ImageSpec>,
        VariantStyleMixin<ImageStyler, ImageSpec>,
        WidgetStateVariantMixin<ImageStyler, ImageSpec>,
        AnimationStyleMixin<ImageStyler, ImageSpec>,
        _$ImageStylerMixin {
  @override
  final Prop<ImageProvider<Object>>? $image;
  @override
  final Prop<double>? $width;
  @override
  final Prop<double>? $height;
  @override
  final Prop<Color>? $color;
  @override
  final Prop<ImageRepeat>? $repeat;
  @override
  final Prop<BoxFit>? $fit;
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<Rect>? $centerSlice;
  @override
  final Prop<FilterQuality>? $filterQuality;
  @override
  final Prop<BlendMode>? $colorBlendMode;
  @override
  final Prop<String>? $semanticLabel;
  @override
  final Prop<bool>? $excludeFromSemantics;
  @override
  final Prop<bool>? $gaplessPlayback;
  @override
  final Prop<bool>? $isAntiAlias;
  @override
  final Prop<bool>? $matchTextDirection;

  const ImageStyler.create({
    Prop<ImageProvider<Object>>? image,
    Prop<double>? width,
    Prop<double>? height,
    Prop<Color>? color,
    Prop<ImageRepeat>? repeat,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<FilterQuality>? filterQuality,
    Prop<BlendMode>? colorBlendMode,
    Prop<String>? semanticLabel,
    Prop<bool>? excludeFromSemantics,
    Prop<bool>? gaplessPlayback,
    Prop<bool>? isAntiAlias,
    Prop<bool>? matchTextDirection,
    super.animation,
    super.modifier,
    super.variants,
  }) : $image = image,
       $width = width,
       $height = height,
       $color = color,
       $repeat = repeat,
       $fit = fit,
       $alignment = alignment,
       $centerSlice = centerSlice,
       $filterQuality = filterQuality,
       $colorBlendMode = colorBlendMode,
       $semanticLabel = semanticLabel,
       $excludeFromSemantics = excludeFromSemantics,
       $gaplessPlayback = gaplessPlayback,
       $isAntiAlias = isAntiAlias,
       $matchTextDirection = matchTextDirection;

  ImageStyler({
    ImageProvider<Object>? image,
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    bool? excludeFromSemantics,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    bool? matchTextDirection,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ImageSpec>>? variants,
  }) : this.create(
         image: Prop.maybe(image),
         width: Prop.maybe(width),
         height: Prop.maybe(height),
         color: Prop.maybe(color),
         repeat: Prop.maybe(repeat),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         filterQuality: Prop.maybe(filterQuality),
         colorBlendMode: Prop.maybe(colorBlendMode),
         semanticLabel: Prop.maybe(semanticLabel),
         excludeFromSemantics: Prop.maybe(excludeFromSemantics),
         gaplessPlayback: Prop.maybe(gaplessPlayback),
         isAntiAlias: Prop.maybe(isAntiAlias),
         matchTextDirection: Prop.maybe(matchTextDirection),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  static ImageMutableStyler get chain => ImageMutableStyler(ImageStyler());

  StyledImage call({
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      style: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      image: image,
      opacity: opacity,
    );
  }

  /// Sets the widget modifier.
  ImageStyler modifier(WidgetModifierConfig value) {
    return merge(ImageStyler(modifier: value));
  }
}
