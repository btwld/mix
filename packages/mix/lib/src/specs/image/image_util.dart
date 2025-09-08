import 'package:flutter/material.dart';

import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/style.dart' show VariantStyle;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'image_spec.dart';
import 'image_style.dart';

/// Provides mutable utility for image styling with cascade notation support.
///
/// Supports the same API as [ImageStyler] but maintains mutable internal state
/// enabling fluid styling: `$image..width(100)..height(100)..fit(BoxFit.cover)`.
class ImageSpecUtility extends StyleMutableBuilder<ImageSpec>
    with UtilityVariantMixin<ImageSpec, ImageStyler> {
  late final color = ColorUtility(
    (prop) => mutable.merge(ImageStyler.create(color: prop)),
  );

  late final repeat = MixUtility(mutable.repeat);

  late final fit = MixUtility(mutable.fit);

  late final alignment = MixUtility(mutable.alignment);

  late final centerSlice = MixUtility(mutable.centerSlice);

  late final filterQuality = MixUtility(mutable.filterQuality);

  late final colorBlendMode = MixUtility(mutable.colorBlendMode);

  @Deprecated(
    'Use direct methods like \$image.onHovered() instead. '
    'Note: Returns ImageStyle for consistency with other utility methods like animate().',
  )
  late final on = OnContextVariantUtility<ImageSpec, ImageStyler>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating image styling properties.
  @override
  @protected
  late final MutableImageStyle mutable;

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
  ImageSpecUtility([ImageStyler? attribute]) {
    mutable = MutableImageStyle(attribute ?? ImageStyler());
  }

  @override
  ImageStyler withVariant(Variant variant, ImageStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  ImageStyler withVariants(List<VariantStyle<ImageSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is ImageStyler) {
      return ImageSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<ImageSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  ImageStyler get currentValue => mutable.value;

  /// The accumulated [ImageStyler] with all applied styling properties.
  @override
  ImageStyler get value => mutable.value;
}

class MutableImageStyle extends ImageStyler
    with Mutable<ImageSpec, ImageStyler> {
  MutableImageStyle(ImageStyler style) {
    value = style;
  }
}
