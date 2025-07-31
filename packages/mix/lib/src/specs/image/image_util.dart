import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
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
class ImageSpecUtility extends StyleMutableBuilder<ImageSpec> {
  // IMAGE UTILITIES - Same as ImageMix but return ImageSpecUtility for cascade
  @override
  @protected
  late final MutableImageMix value;

  late final width = MixUtility(value.width);

  late final height = MixUtility(value.height);

  late final color = ColorUtility(
    (prop) => value.merge(ImageMix.raw(color: prop)),
  );

  late final repeat = MixUtility(value.repeat);

  late final fit = MixUtility(value.fit);

  late final alignment = MixUtility(value.alignment);

  late final centerSlice = MixUtility(value.centerSlice);

  late final filterQuality = MixUtility(value.filterQuality);

  late final colorBlendMode = MixUtility(value.colorBlendMode);

  late final semanticLabel = MixUtility(value.semanticLabel);

  late final excludeFromSemantics = MixUtility(value.excludeFromSemantics);

  late final gaplessPlayback = MixUtility(value.gaplessPlayback);

  late final isAntiAlias = MixUtility(value.isAntiAlias);

  late final matchTextDirection = MixUtility(value.matchTextDirection);

  late final on = OnContextVariantUtility<ImageSpec, ImageMix>(
    (v) => value.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => value.modifier(ModifierConfig(modifiers: [prop])),
  );

  ImageSpecUtility([ImageMix? attribute]) {
    value = MutableImageMix(attribute ?? ImageMix.raw());
  }

  /// Animation
  ImageMix animate(AnimationConfig animation) => value.animate(animation);

  // StyleAttribute interface implementation

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(value.merge(other.value));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return value.resolve(context);
  }
}

class MutableImageMix extends ImageMix with Mutable<ImageSpec, ImageMix> {
  MutableImageMix([ImageMix? attribute]) {
    merge(attribute);
  }
}
