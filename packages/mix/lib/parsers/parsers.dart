/// Mix parsers library
///
/// Simple, type-safe parsers for common Flutter types
/// Following YAGNI principle - only essential parsers included
library mix_parsers;

// Import for internal use
import 'package:flutter/material.dart';

import 'alignment_parser.dart';
import 'base/enum_parser.dart';
import 'base/parser_base.dart';
import 'border_parser.dart';
import 'border_radius_parser.dart';
import 'border_side_parser.dart';
import 'box_constraints_parser.dart';
import 'box_decoration_parser.dart';
import 'box_shadow_parser.dart';
import 'color_parser.dart';
import 'curve_parser.dart';
import 'duration_parser.dart';
import 'edge_insets_parser.dart';
import 'font_weight_parser.dart';
import 'gradient_parser.dart';
import 'matrix4_parser.dart';
import 'offset_parser.dart';
import 'rect_parser.dart';
import 'size_parser.dart';
import 'strut_style_parser.dart';
import 'text_height_behavior_parser.dart';
import 'text_scaler_parser.dart';
import 'text_style_parser.dart';

// Type parsers (alphabetical order)
export 'alignment_parser.dart';
export 'base/enum_parser.dart';
// Base classes
export 'base/parser_base.dart';
export 'border_parser.dart';
export 'border_radius_parser.dart';
export 'border_side_parser.dart';
export 'box_constraints_parser.dart';
export 'box_decoration_parser.dart';
export 'box_shadow_parser.dart';
export 'color_parser.dart';
export 'curve_parser.dart';
export 'duration_parser.dart';
export 'edge_insets_parser.dart';
export 'font_weight_parser.dart';
export 'gradient_parser.dart';
export 'matrix4_parser.dart';
export 'offset_parser.dart';
export 'rect_parser.dart';
export 'size_parser.dart';
export 'strut_style_parser.dart';
export 'text_height_behavior_parser.dart';
export 'text_scaler_parser.dart';
export 'text_style_parser.dart';

// Convenience class for common parsing operations
class MixParsers {
  static final _parsers = <Type, Parser>{
    AlignmentGeometry: const AlignmentParser(),
    Axis: const AxisParser(),
    CrossAxisAlignment: const CrossAxisAlignmentParser(),
    MainAxisAlignment: const MainAxisAlignmentParser(),
    MainAxisSize: const MainAxisSizeParser(),
    VerticalDirection: const VerticalDirectionParser(),
    TextDirection: const TextDirectionParser(),
    BlendMode: const BlendModeParser(),
    BoxFit: const BoxFitParser(),
    Clip: const ClipParser(),
    FilterQuality: const FilterQualityParser(),
    ImageRepeat: const ImageRepeatParser(),
    StackFit: const StackFitParser(),
    TextAlign: const TextAlignParser(),
    TextBaseline: const TextBaselineParser(),
    TextOverflow: const TextOverflowParser(),
    TextWidthBasis: const TextWidthBasisParser(),
    FontStyle: const FontStyleParser(),
    TextDecorationStyle: const TextDecorationStyleParser(),
    TextLeadingDistribution: const TextLeadingDistributionParser(),
    Border: const BorderParser(),
    BorderRadius: const BorderRadiusParser(),
    BorderSide: const BorderSideParser(),
    BorderStyle: const BorderStyleParser(),
    BoxConstraints: const BoxConstraintsParser(),
    BoxDecoration: const BoxDecorationParser(),
    BoxShadow: const BoxShadowParser(),
    Color: const ColorParser(),
    Curve: const CurveParser(),
    Duration: const DurationParser(),
    EdgeInsets: const EdgeInsetsParser(),
    FontWeight: const FontWeightParser(),
    Gradient: const GradientParser(),
    Matrix4: const Matrix4Parser(),
    Offset: const OffsetParser(),
    Rect: const RectParser(),
    Size: const SizeParser(),
    StrutStyle: const StrutStyleParser(),
    TextHeightBehavior: const TextHeightBehaviorParser(),
    TextScaler: const TextScalerParser(),
    TextStyle: const TextStyleParser(),
  };

  /// Get a parser for a specific type
  static Parser<T>? get<T extends Object>() {
    return _parsers[T] as Parser<T>?;
  }
}
