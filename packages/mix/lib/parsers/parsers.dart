/// Mix parsers library
/// 
/// Simple, type-safe parsers for common Flutter types
/// Following YAGNI principle - only essential parsers included
library mix_parsers;

// Base classes
export 'base/parser_base.dart';

// Type parsers (alphabetical order)
export 'alignment_parser.dart';
export 'axis_parser.dart';
export 'blend_mode_parser.dart';
export 'border_parser.dart';
export 'border_radius_parser.dart';
export 'border_side_parser.dart';
export 'box_constraints_parser.dart';
export 'box_decoration_parser.dart';
export 'box_fit_parser.dart';
export 'box_shadow_parser.dart';
export 'clip_parser.dart';
export 'color_parser.dart';
export 'cross_axis_alignment_parser.dart';
export 'curve_parser.dart';
export 'duration_parser.dart';
export 'edge_insets_parser.dart';
export 'filter_quality_parser.dart';
export 'font_weight_parser.dart';
export 'gradient_parser.dart';
export 'image_repeat_parser.dart';
export 'main_axis_alignment_parser.dart';
export 'main_axis_size_parser.dart';
export 'matrix4_parser.dart';
export 'offset_parser.dart';
export 'rect_parser.dart';
export 'size_parser.dart';
export 'stack_fit_parser.dart';
export 'strut_style_parser.dart';
export 'text_align_parser.dart';
export 'text_baseline_parser.dart';
export 'text_direction_parser.dart';
export 'text_height_behavior_parser.dart';
export 'text_overflow_parser.dart';
export 'text_scaler_parser.dart';
export 'text_style_parser.dart';
export 'text_width_basis_parser.dart';
export 'vertical_direction_parser.dart';

// Import for internal use
import 'alignment_parser.dart';
import 'axis_parser.dart';
import 'blend_mode_parser.dart';
import 'border_parser.dart';
import 'border_radius_parser.dart';
import 'border_side_parser.dart';
import 'box_constraints_parser.dart';
import 'box_decoration_parser.dart';
import 'box_fit_parser.dart';
import 'box_shadow_parser.dart';
import 'clip_parser.dart';
import 'color_parser.dart';
import 'cross_axis_alignment_parser.dart';
import 'curve_parser.dart';
import 'duration_parser.dart';
import 'edge_insets_parser.dart';
import 'filter_quality_parser.dart';
import 'font_weight_parser.dart';
import 'gradient_parser.dart';
import 'image_repeat_parser.dart';
import 'main_axis_alignment_parser.dart';
import 'main_axis_size_parser.dart';
import 'matrix4_parser.dart';
import 'offset_parser.dart';
import 'rect_parser.dart';
import 'size_parser.dart';
import 'stack_fit_parser.dart';
import 'strut_style_parser.dart';
import 'text_align_parser.dart';
import 'text_baseline_parser.dart';
import 'text_direction_parser.dart';
import 'text_height_behavior_parser.dart';
import 'text_overflow_parser.dart';
import 'text_scaler_parser.dart';
import 'text_style_parser.dart';
import 'text_width_basis_parser.dart';
import 'vertical_direction_parser.dart';

// Convenience class for common parsing operations
class MixParsers {
  // Core parsers (alphabetical order)
  static const AlignmentParser alignment = AlignmentParser();
  static const AxisParser axis = AxisParser();
  static const BlendModeParser blendMode = BlendModeParser();
  static const BorderParser border = BorderParser();
  static const BorderRadiusParser borderRadius = BorderRadiusParser();
  static const BorderSideParser borderSide = BorderSideParser();
  static const BoxConstraintsParser boxConstraints = BoxConstraintsParser();
  static const BoxDecorationParser boxDecoration = BoxDecorationParser();
  static const BoxFitParser boxFit = BoxFitParser();
  static const BoxShadowParser boxShadow = BoxShadowParser();
  static const ClipParser clip = ClipParser();
  static const ColorParser color = ColorParser();
  static const CrossAxisAlignmentParser crossAxisAlignment = CrossAxisAlignmentParser();
  static const CurveParser curve = CurveParser();
  static const DurationParser duration = DurationParser();
  static const EdgeInsetsParser edgeInsets = EdgeInsetsParser();
  static const FilterQualityParser filterQuality = FilterQualityParser();
  static const FontWeightParser fontWeight = FontWeightParser();
  static const GradientParser gradient = GradientParser();
  static const ImageRepeatParser imageRepeat = ImageRepeatParser();
  static const MainAxisAlignmentParser mainAxisAlignment = MainAxisAlignmentParser();
  static const MainAxisSizeParser mainAxisSize = MainAxisSizeParser();
  static const Matrix4Parser matrix4 = Matrix4Parser();
  static const OffsetParser offset = OffsetParser();
  static const RectParser rect = RectParser();
  static const SizeParser size = SizeParser();
  static const StackFitParser stackFit = StackFitParser();
  static const StrutStyleParser strutStyle = StrutStyleParser();
  static const TextAlignParser textAlign = TextAlignParser();
  static const TextBaselineParser textBaseline = TextBaselineParser();
  static const TextDirectionParser textDirection = TextDirectionParser();
  static const TextHeightBehaviorParser textHeightBehavior = TextHeightBehaviorParser();
  static const TextOverflowParser textOverflow = TextOverflowParser();
  static const TextScalerParser textScaler = TextScalerParser();
  static const TextStyleParser textStyle = TextStyleParser();
  static const TextWidthBasisParser textWidthBasis = TextWidthBasisParser();
  static const VerticalDirectionParser verticalDirection = VerticalDirectionParser();
  
  // Prevent instantiation
  const MixParsers._();
}
