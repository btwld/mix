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

  late final width = MixUtility(style.width);

  late final height = MixUtility(style.height);

  late final color = ColorUtility(
    (prop) => style.merge(ImageMix.raw(color: prop)),
  );

  late final repeat = MixUtility(style.repeat);

  late final fit = MixUtility(style.fit);

  late final alignment = MixUtility(style.alignment);

  late final centerSlice = MixUtility(style.centerSlice);

  late final filterQuality = MixUtility(style.filterQuality);

  late final colorBlendMode = MixUtility(style.colorBlendMode);

  late final semanticLabel = MixUtility(style.semanticLabel);

  late final excludeFromSemantics = MixUtility(style.excludeFromSemantics);

  late final gaplessPlayback = MixUtility(style.gaplessPlayback);

  late final isAntiAlias = MixUtility(style.isAntiAlias);

  late final matchTextDirection = MixUtility(style.matchTextDirection);

  late final on = OnContextVariantUtility<ImageSpec, ImageMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  ImageMix style;

  ImageSpecUtility([ImageMix? attribute]) : style = attribute ?? ImageMix.raw();

  /// Animation
  ImageMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(style.merge(other.style));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}
