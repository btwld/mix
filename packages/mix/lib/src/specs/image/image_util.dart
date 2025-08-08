import 'package:flutter/material.dart';

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
    (prop) => mutable.merge(ImageMix.create(color: prop)),
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
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating image styling properties.
  @override
  @protected
  late final MutableImageMix mutable;

  late final image = mutable.image;

  late final width = mutable.width;

  late final height = mutable.height;

  late final semanticLabel = mutable.semanticLabel;

  late final excludeFromSemantics = mutable.excludeFromSemantics;

  late final gaplessPlayback = mutable.gaplessPlayback;
  late final isAntiAlias = mutable.isAntiAlias;
  late final matchTextDirection = mutable.matchTextDirection;
  late final animate = mutable.animate;
  late final variants = mutable.variants;
  ImageSpecUtility([ImageMix? attribute]) {
    mutable = MutableImageMix(attribute ?? ImageMix());
  }

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
