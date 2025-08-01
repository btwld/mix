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

/// Provides mutable utility for image styling with cascade notation support.
///
/// Supports the same API as [ImageMix] but maintains mutable internal state
/// enabling fluid styling: `$image..width(100)..height(100)..fit(BoxFit.cover)`.
class ImageSpecUtility extends StyleMutableBuilder<ImageSpec> {
  late final color = ColorUtility(
    (prop) => mutable.merge(ImageMix.raw(color: prop)),
  );

  late final repeat = MixUtility(mutable.repeat);

  late final fit = MixUtility(mutable.fit);

  late final alignment = MixUtility(mutable.alignment);

  late final centerSlice = MixUtility(mutable.centerSlice);

  late final filterQuality = MixUtility(mutable.filterQuality);

  late final colorBlendMode = MixUtility(mutable.colorBlendMode);

  late final on = OnContextVariantUtility<ImageSpec, ImageMix>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.modifier(ModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating image styling properties.
  @override
  @protected
  late final MutableImageMix mutable;

  ImageSpecUtility([ImageMix? attribute]) {
    mutable = MutableImageMix(attribute ?? ImageMix());
  }

  ImageMix width(double v) => mutable.width(v);

  ImageMix height(double v) => mutable.height(v);

  ImageMix semanticLabel(String v) => mutable.semanticLabel(v);

  ImageMix excludeFromSemantics(bool v) => mutable.excludeFromSemantics(v);

  ImageMix gaplessPlayback(bool v) => mutable.gaplessPlayback(v);

  ImageMix isAntiAlias(bool v) => mutable.isAntiAlias(v);

  ImageMix matchTextDirection(bool v) => mutable.matchTextDirection(v);

  /// Applies animation configuration to the image styling.
  ImageMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [ImageMix] with all applied styling properties.
  @override
  ImageMix get value => mutable.value;
}

class MutableImageMix extends ImageMix with Mutable<ImageSpec, ImageMix> {
  MutableImageMix(ImageMix style) {
    value = style;
  }
}
