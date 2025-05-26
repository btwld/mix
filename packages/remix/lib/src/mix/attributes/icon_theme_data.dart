import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'icon_theme_data.g.dart';

@MixableType()
final class IconThemeDataDto extends Mixable<IconThemeData>
    with _$IconThemeDataDto, Diagnosticable {
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final ColorDto? color;
  final double? opacity;
  final List<ShadowDto>? shadows;
  final bool? applyTextScaling;

  const IconThemeDataDto({
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.opacity,
    this.shadows,
    this.applyTextScaling,
  });
}
