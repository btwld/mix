// ignore_for_file: avoid-importing-entrypoint-exports, avoid-unused-ignores, prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:mix/annotations.dart';

import '../../../mix.dart';

part 'strut_style_dto.g.dart';

@MixableDto()
final class StrutStyleDto extends Dto<StrutStyle> with _$StrutStyleDto {
  @MixableProperty(utilities: [MixableUtility(type: FontFamilyUtility)])
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  @MixableProperty(utilities: [MixableUtility(type: FontSizeUtility)])
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? height;
  final double? leading;
  final bool? forceStrutHeight;

  const StrutStyleDto({
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.height,
    this.leading,
    this.forceStrutHeight,
  });

  @override
  StrutStyle get defaultValue => const StrutStyle();
}
