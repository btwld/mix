import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'image_spec.g.dart';

/// Specification for image styling properties.
///
/// Provides comprehensive image styling including dimensions, color, fit,
/// alignment, filtering, and semantic properties.
@MixableSpec()
@immutable
final class ImageSpec extends Spec<ImageSpec>
    with Diagnosticable, _$ImageSpecMethods {
  /// The image to display.
  @override
  final ImageProvider<Object>? image;

  /// The width of the image.
  @override
  final double? width;

  /// The height of the image.
  @override
  final double? height;

  /// The color to blend with the image.
  @override
  final Color? color;

  /// How to repeat the image if it doesn't fill the box.
  @override
  final ImageRepeat? repeat;

  /// How to inscribe the image into the space.
  @override
  final BoxFit? fit;

  /// How to align the image within its bounds.
  @override
  final AlignmentGeometry? alignment;

  /// The center slice for nine-patch images.
  @override
  final Rect? centerSlice;

  /// The rendering quality of the image.
  @override
  final FilterQuality? filterQuality;

  /// The blend mode to use when drawing the image.
  @override
  final BlendMode? colorBlendMode;

  /// A semantic description of the image.
  @override
  final String? semanticLabel;

  /// Whether to exclude the image from semantics.
  @override
  final bool? excludeFromSemantics;

  /// Whether to continue showing the old image when the image provider changes.
  @override
  final bool? gaplessPlayback;

  /// Whether to paint the image with anti-aliasing.
  @override
  final bool? isAntiAlias;

  /// Whether to paint the image in the direction of the text.
  @override
  final bool? matchTextDirection;

  const ImageSpec({
    this.image,
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
    this.semanticLabel,
    this.excludeFromSemantics,
    this.gaplessPlayback,
    this.isAntiAlias,
    this.matchTextDirection,
  });
}
