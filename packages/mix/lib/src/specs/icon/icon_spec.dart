import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'icon_spec.g.dart';

/// Specification for icon styling properties.
///
/// Provides comprehensive icon styling including color, size, weight, optical properties,
/// text direction, scaling behavior, and shadow effects.
@MixableSpec()
@immutable
final class IconSpec extends Spec<IconSpec>
    with Diagnosticable, _$IconSpecMethods {
  /// The color to use when drawing the icon.
  @override
  final Color? color;

  /// The size of the icon in logical pixels.
  @override
  final double? size;

  /// The font weight variant (100-900) for supported icon fonts.
  @override
  final double? weight;

  /// The grade variant (-25 to 200) for supported icon fonts.
  @override
  final double? grade;

  /// The optical size variant (20-48) for supported icon fonts.
  @override
  final double? opticalSize;

  /// The text direction to use for rendering the icon.
  @override
  final TextDirection? textDirection;

  /// Whether to scale the icon according to the textScaleFactor.
  @override
  final bool? applyTextScaling;

  /// A list of shadows to paint behind the icon.
  @override
  final List<Shadow>? shadows;

  /// The fill variant (0.0-1.0) for supported icon fonts.
  @override
  final double? fill;

  /// Semantic description for accessibility.
  @override
  final String? semanticsLabel;

  /// The opacity to apply to the icon.
  @override
  final double? opacity;

  /// The blend mode to apply when drawing the icon.
  @override
  final BlendMode? blendMode;

  /// The icon data to display.
  @override
  final IconData? icon;

  const IconSpec({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    this.semanticsLabel,
    this.opacity,
    this.blendMode,
    this.icon,
  });
}
