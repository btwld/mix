import 'package:flutter/material.dart';

import 'parser_base.dart';

/// Generic parser for all enum types following KISS principle
/// Reduces code duplication by handling all enum parsing in one place
abstract class EnumParser<T extends Enum> extends Parser<T> {
  /// The list of all enum values for type T
  final List<T> values;

  /// Optional custom name encoder (defaults to using .name property)
  final String Function(T)? customEncoder;

  const EnumParser(this.values, {this.customEncoder});

  @override
  Object? encode(T? value) {
    if (value == null) return null;

    // Use custom encoder if provided, otherwise use .name
    return customEncoder?.call(value) ?? value.name;
  }

  @override
  T? decode(Object? json) {
    if (json == null) return null;
    if (json is! String) return null;

    // Find enum by name/custom encoding
    try {
      return values.firstWhere(
        (e) => (customEncoder?.call(e) ?? e.name) == json,
      );
    } catch (_) {
      return null;
    }
  }
}

class AxisParser extends EnumParser<Axis> {
  const AxisParser() : super(Axis.values);
}

class CrossAxisAlignmentParser extends EnumParser<CrossAxisAlignment> {
  const CrossAxisAlignmentParser() : super(CrossAxisAlignment.values);
}

class MainAxisAlignmentParser extends EnumParser<MainAxisAlignment> {
  const MainAxisAlignmentParser() : super(MainAxisAlignment.values);
}

class MainAxisSizeParser extends EnumParser<MainAxisSize> {
  const MainAxisSizeParser() : super(MainAxisSize.values);
}

class VerticalDirectionParser extends EnumParser<VerticalDirection> {
  const VerticalDirectionParser() : super(VerticalDirection.values);
}

class TextDirectionParser extends EnumParser<TextDirection> {
  const TextDirectionParser() : super(TextDirection.values);
}

class BlendModeParser extends EnumParser<BlendMode> {
  const BlendModeParser() : super(BlendMode.values);
}

class BoxFitParser extends EnumParser<BoxFit> {
  const BoxFitParser() : super(BoxFit.values);
}

class ClipParser extends EnumParser<Clip> {
  const ClipParser() : super(Clip.values);
}

class FilterQualityParser extends EnumParser<FilterQuality> {
  const FilterQualityParser() : super(FilterQuality.values);
}

class ImageRepeatParser extends EnumParser<ImageRepeat> {
  const ImageRepeatParser() : super(ImageRepeat.values);
}

class StackFitParser extends EnumParser<StackFit> {
  const StackFitParser() : super(StackFit.values);
}

class TextAlignParser extends EnumParser<TextAlign> {
  const TextAlignParser() : super(TextAlign.values);
}

class TextBaselineParser extends EnumParser<TextBaseline> {
  const TextBaselineParser() : super(TextBaseline.values);
}

class TextOverflowParser extends EnumParser<TextOverflow> {
  const TextOverflowParser() : super(TextOverflow.values);
}

class TextWidthBasisParser extends EnumParser<TextWidthBasis> {
  const TextWidthBasisParser() : super(TextWidthBasis.values);
}

class FontStyleParser extends EnumParser<FontStyle> {
  const FontStyleParser() : super(FontStyle.values);
}

class TextDecorationStyleParser extends EnumParser<TextDecorationStyle> {
  const TextDecorationStyleParser() : super(TextDecorationStyle.values);
}

class TextLeadingDistributionParser
    extends EnumParser<TextLeadingDistribution> {
  const TextLeadingDistributionParser() : super(TextLeadingDistribution.values);
}

class BorderStyleParser extends EnumParser<BorderStyle> {
  const BorderStyleParser() : super(BorderStyle.values);
}
