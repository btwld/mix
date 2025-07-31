import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../variants/variant_util.dart';
import 'image_attribute.dart';
import 'image_spec.dart';

/// Mutable utility class for image styling using composition over inheritance.
///
/// Same API as ImageMix but with mutable internal state
/// for cascade notation support: `$image..width(100)..height(100)..fit(BoxFit.cover)`
class ImageSpecUtility extends StyleAttributeBuilder<ImageSpec> {
  // IMAGE UTILITIES - Same as ImageMix but return ImageSpecUtility for cascade

  late final width = MixUtility(mix.width);

  late final height = MixUtility(mix.height);

  late final color = ColorUtility(
    (prop) => mix.merge(ImageMix.raw(color: prop)),
  );

  late final repeat = MixUtility(mix.repeat);

  late final fit = MixUtility(mix.fit);

  late final alignment = MixUtility(mix.alignment);

  late final centerSlice = MixUtility(mix.centerSlice);

  late final filterQuality = MixUtility(mix.filterQuality);

  late final colorBlendMode = MixUtility(mix.colorBlendMode);

  late final on = OnContextVariantUtility<ImageSpec, ImageMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  ImageMix mix;

  ImageSpecUtility([ImageMix? attribute]) : mix = attribute ?? ImageMix.raw();

  /// Animation
  ImageMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(mix.merge(other.mix));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}
