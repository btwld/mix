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

  late final width = PropUtility<ImageSpecUtility, double>(
    (prop) => _build(ImageMix.raw(width: prop)),
  );

  late final height = PropUtility<ImageSpecUtility, double>(
    (prop) => _build(ImageMix.raw(height: prop)),
  );

  late final color = ColorUtility<ImageSpecUtility>(
    (prop) => _build(ImageMix.raw(color: prop)),
  );

  late final repeat = PropUtility<ImageSpecUtility, ImageRepeat>(
    (prop) => _build(ImageMix.raw(repeat: prop)),
  );

  late final fit = PropUtility<ImageSpecUtility, BoxFit>(
    (prop) => _build(ImageMix.raw(fit: prop)),
  );

  late final alignment = PropUtility<ImageSpecUtility, AlignmentGeometry>(
    (prop) => _build(ImageMix.raw(alignment: prop)),
  );

  late final centerSlice = PropUtility<ImageSpecUtility, Rect>(
    (prop) => _build(ImageMix.raw(centerSlice: prop)),
  );

  late final filterQuality = PropUtility<ImageSpecUtility, FilterQuality>(
    (prop) => _build(ImageMix.raw(filterQuality: prop)),
  );

  late final colorBlendMode = PropUtility<ImageSpecUtility, BlendMode>(
    (prop) => _build(ImageMix.raw(colorBlendMode: prop)),
  );

  late final on = OnContextVariantUtility<ImageSpec, ImageSpecUtility>(
    (v) => _build(ImageMix.raw(variants: [v])),
  );

  late final wrap = ModifierUtility<ImageSpecUtility>(
    (prop) =>
        _build(ImageMix.raw(modifierConfig: ModifierConfig.modifier(prop))),
  );

  ImageMix _baseAttribute;

  ImageSpecUtility([ImageMix? attribute])
    : _baseAttribute = attribute ?? ImageMix.raw();

  /// Mutable builder - updates internal state and returns this for cascade
  ImageSpecUtility _build(ImageMix newAttribute) {
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  ImageSpecUtility animate(AnimationConfig animation) =>
      _build(ImageMix(animation: animation));

  // StyleAttribute interface implementation

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(_baseAttribute.merge(other));
    }

    return ImageSpecUtility(_baseAttribute);
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  ImageMix get attribute => _baseAttribute;
}
