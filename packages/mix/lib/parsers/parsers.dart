/// Mix parsers library
/// 
/// Simple, type-safe parsers for common Flutter types
/// Following YAGNI principle - only essential parsers included
library mix_parsers;

// Base classes
export 'base/parser_base.dart';
export 'base/enum_parser.dart';

// Type parsers (alphabetical order)
export 'alignment_parser.dart';
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

// Import for internal use
import 'package:flutter/material.dart';

import 'base/enum_parser.dart';
import 'alignment_parser.dart';
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

/// Registry of all enum parsers using the generic EnumParser
class MixEnumParsers {
  // Layout enums
  static const EnumParser<Axis> axis = EnumParser(Axis.values);
  static const EnumParser<CrossAxisAlignment> crossAxisAlignment = EnumParser(CrossAxisAlignment.values);
  static const EnumParser<MainAxisAlignment> mainAxisAlignment = EnumParser(MainAxisAlignment.values);
  static const EnumParser<MainAxisSize> mainAxisSize = EnumParser(MainAxisSize.values);
  static const EnumParser<VerticalDirection> verticalDirection = EnumParser(VerticalDirection.values);
  static const EnumParser<TextDirection> textDirection = EnumParser(TextDirection.values);
  
  // Graphics enums
  static const EnumParser<BlendMode> blendMode = EnumParser(BlendMode.values);
  static const EnumParser<BoxFit> boxFit = EnumParser(BoxFit.values);
  static const EnumParser<Clip> clip = EnumParser(Clip.values);
  static const EnumParser<FilterQuality> filterQuality = EnumParser(FilterQuality.values);
  static const EnumParser<ImageRepeat> imageRepeat = EnumParser(ImageRepeat.values);
  static const EnumParser<StackFit> stackFit = EnumParser(StackFit.values);
  
  // Text enums
  static const EnumParser<TextAlign> textAlign = EnumParser(TextAlign.values);
  static const EnumParser<TextBaseline> textBaseline = EnumParser(TextBaseline.values);
  static const EnumParser<TextOverflow> textOverflow = EnumParser(TextOverflow.values);
  static const EnumParser<TextWidthBasis> textWidthBasis = EnumParser(TextWidthBasis.values);
  
  const MixEnumParsers._();
}

// Convenience class for common parsing operations
class MixParsers {
  // Core parsers (alphabetical order)
  static const AlignmentParser alignment = AlignmentParser();
  static const BorderParser border = BorderParser();
  static const BorderRadiusParser borderRadius = BorderRadiusParser();
  static const BorderSideParser borderSide = BorderSideParser();
  static const BoxConstraintsParser boxConstraints = BoxConstraintsParser();
  static const BoxDecorationParser boxDecoration = BoxDecorationParser();
  static const BoxShadowParser boxShadow = BoxShadowParser();
  static const ColorParser color = ColorParser();
  static const CurveParser curve = CurveParser();
  static const DurationParser duration = DurationParser();
  static const EdgeInsetsParser edgeInsets = EdgeInsetsParser();
  static const FontWeightParser fontWeight = FontWeightParser();
  static const GradientParser gradient = GradientParser();
  static const Matrix4Parser matrix4 = Matrix4Parser();
  static const OffsetParser offset = OffsetParser();
  static const RectParser rect = RectParser();
  static const SizeParser size = SizeParser();
  static const StrutStyleParser strutStyle = StrutStyleParser();
  static const TextHeightBehaviorParser textHeightBehavior = TextHeightBehaviorParser();
  static const TextScalerParser textScaler = TextScalerParser();
  static const TextStyleParser textStyle = TextStyleParser();
  
  // Enum parsers (now using generic implementation)
  static const axis = MixEnumParsers.axis;
  static const blendMode = MixEnumParsers.blendMode;
  static const boxFit = MixEnumParsers.boxFit;
  static const clip = MixEnumParsers.clip;
  static const crossAxisAlignment = MixEnumParsers.crossAxisAlignment;
  static const filterQuality = MixEnumParsers.filterQuality;
  static const imageRepeat = MixEnumParsers.imageRepeat;
  static const mainAxisAlignment = MixEnumParsers.mainAxisAlignment;
  static const mainAxisSize = MixEnumParsers.mainAxisSize;
  static const stackFit = MixEnumParsers.stackFit;
  static const textAlign = MixEnumParsers.textAlign;
  static const textBaseline = MixEnumParsers.textBaseline;
  static const textDirection = MixEnumParsers.textDirection;
  static const textOverflow = MixEnumParsers.textOverflow;
  static const textWidthBasis = MixEnumParsers.textWidthBasis;
  static const verticalDirection = MixEnumParsers.verticalDirection;
  
  // Prevent instantiation
  const MixParsers._();
}
