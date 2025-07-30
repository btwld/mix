import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
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
    (prop) => buildProps(width: prop),
  );

  late final height = PropUtility<ImageSpecUtility, double>(
    (prop) => buildProps(height: prop),
  );

  late final color = ColorUtility<ImageSpecUtility>(
    (prop) => buildProps(color: prop),
  );

  late final repeat = PropUtility<ImageSpecUtility, ImageRepeat>(
    (prop) => buildProps(repeat: prop),
  );

  late final fit = PropUtility<ImageSpecUtility, BoxFit>(
    (prop) => buildProps(fit: prop),
  );

  late final alignment = PropUtility<ImageSpecUtility, AlignmentGeometry>(
    (prop) => buildProps(alignment: prop),
  );

  late final centerSlice = PropUtility<ImageSpecUtility, Rect>(
    (prop) => buildProps(centerSlice: prop),
  );

  late final filterQuality = PropUtility<ImageSpecUtility, FilterQuality>(
    (prop) => buildProps(filterQuality: prop),
  );

  late final colorBlendMode = PropUtility<ImageSpecUtility, BlendMode>(
    (prop) => buildProps(colorBlendMode: prop),
  );

  late final on = OnContextVariantUtility<ImageSpec, ImageSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<ImageSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
  );

  ImageMix _baseAttribute;

  ImageSpecUtility([ImageMix? attribute])
    : _baseAttribute = attribute ?? ImageMix.raw();

  @protected
  ImageSpecUtility buildProps({
    Prop<double>? width,
    Prop<double>? height,
    Prop<Color>? color,
    Prop<ImageRepeat>? repeat,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<FilterQuality>? filterQuality,
    Prop<BlendMode>? colorBlendMode,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<ImageSpec>>? variants,
  }) {
    final newAttribute = ImageMix.raw(
      width: width,
      height: height,
      color: color,
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  ImageSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  ImageSpecUtility merge(Style<ImageSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is ImageSpecUtility) {
      return ImageSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is ImageMix) {
      return ImageSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  ImageMix get mix => _baseAttribute;
}
