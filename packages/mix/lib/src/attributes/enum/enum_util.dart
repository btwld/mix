// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/element.dart';
import '../../core/utility.dart';

part 'enum_util.g.dart';

/// {@macro vertical_direction_utility}
@MixableUtility()
final class VerticalDirectionUtility<T extends StyleElement>
    extends MixUtility<T, VerticalDirection> with _$VerticalDirectionUtility {
  const VerticalDirectionUtility(super.builder);
}

/// {@macro border_style_utility}
@MixableUtility()
final class BorderStyleUtility<T extends StyleElement>
    extends MixUtility<T, BorderStyle> with _$BorderStyleUtility {
  const BorderStyleUtility(super.builder);
}

/// {@macro clip_utility}
@MixableUtility()
final class ClipUtility<T extends StyleElement> extends MixUtility<T, Clip>
    with _$ClipUtility {
  const ClipUtility(super.builder);
}

/// {@macro axis_utility}
@MixableUtility()
final class AxisUtility<T extends StyleElement> extends MixUtility<T, Axis>
    with _$AxisUtility {
  const AxisUtility(super.builder);
}

/// {@macro flex_fit_utility}
@MixableUtility()
final class FlexFitUtility<T extends StyleElement>
    extends MixUtility<T, FlexFit> with _$FlexFitUtility {
  const FlexFitUtility(super.builder);
}

/// {@macro stack_fit_utility}
@MixableUtility()
final class StackFitUtility<T extends StyleElement>
    extends MixUtility<T, StackFit> with _$StackFitUtility {
  const StackFitUtility(super.builder);
}

/// {@macro image_repeat_utility}
@MixableUtility(methods: GeneratedUtilityMethods.skipCallMethod)
final class ImageRepeatUtility<T extends StyleElement>
    extends MixUtility<T, ImageRepeat> with _$ImageRepeatUtility {
  const ImageRepeatUtility(super.builder);

  T call([ImageRepeat value = ImageRepeat.repeat]) => builder(value);
}

/// {@macro text_direction_utility}
@MixableUtility()
final class TextDirectionUtility<T extends StyleElement>
    extends MixUtility<T, TextDirection> with _$TextDirectionUtility {
  const TextDirectionUtility(super.builder);
}

/// {@macro text_direction_utility}
@MixableUtility()
final class TextLeadingDistributionUtility<T extends StyleElement>
    extends MixUtility<T, TextLeadingDistribution>
    with _$TextLeadingDistributionUtility {
  const TextLeadingDistributionUtility(super.builder);
}

/// {@macro tile_mode_utility}
@MixableUtility()
final class TileModeUtility<T extends StyleElement>
    extends MixUtility<T, TileMode> with _$TileModeUtility {
  const TileModeUtility(super.builder);
}

/// {@macro main_axis_alignment_utility}
@MixableUtility()
final class MainAxisAlignmentUtility<T extends StyleElement>
    extends MixUtility<T, MainAxisAlignment> with _$MainAxisAlignmentUtility {
  const MainAxisAlignmentUtility(super.builder);
}

/// {@macro cross_axis_alignment_utility}
@MixableUtility()
final class CrossAxisAlignmentUtility<T extends StyleElement>
    extends MixUtility<T, CrossAxisAlignment> with _$CrossAxisAlignmentUtility {
  const CrossAxisAlignmentUtility(super.builder);
}

/// {@macro main_axis_size_utility}
@MixableUtility()
final class MainAxisSizeUtility<T extends StyleElement>
    extends MixUtility<T, MainAxisSize> with _$MainAxisSizeUtility {
  const MainAxisSizeUtility(super.builder);
}

/// {@macro box_fit_utility}
@MixableUtility()
final class BoxFitUtility<T extends StyleElement> extends MixUtility<T, BoxFit>
    with _$BoxFitUtility {
  const BoxFitUtility(super.builder);
}

/// {@macro blend_mode_utility}
@MixableUtility()
final class BlendModeUtility<T extends StyleElement>
    extends MixUtility<T, BlendMode> with _$BlendModeUtility {
  const BlendModeUtility(super.builder);
}

/// {@macro box_shape_utility}
@MixableUtility()
final class BoxShapeUtility<T extends StyleElement>
    extends MixUtility<T, BoxShape> with _$BoxShapeUtility {
  const BoxShapeUtility(super.builder);
}

/// {@macro font_style_utility}
@MixableUtility()
final class FontStyleUtility<T extends StyleElement>
    extends MixUtility<T, FontStyle> with _$FontStyleUtility {
  const FontStyleUtility(super.builder);
}

/// {@macro text_decoration_style_utility}
@MixableUtility()
final class TextDecorationStyleUtility<T extends StyleElement>
    extends MixUtility<T, TextDecorationStyle>
    with _$TextDecorationStyleUtility {
  const TextDecorationStyleUtility(super.builder);
}

/// {@macro text_baseline_utility}
@MixableUtility()
final class TextBaselineUtility<T extends StyleElement>
    extends MixUtility<T, TextBaseline> with _$TextBaselineUtility {
  const TextBaselineUtility(super.builder);
}

/// {@macro text_overflow_utility}
@MixableUtility()
final class TextOverflowUtility<T extends StyleElement>
    extends MixUtility<T, TextOverflow> with _$TextOverflowUtility {
  const TextOverflowUtility(super.builder);
}

/// {@macro text_width_basis_utility}
@MixableUtility()
final class TextWidthBasisUtility<T extends StyleElement>
    extends MixUtility<T, TextWidthBasis> with _$TextWidthBasisUtility {
  const TextWidthBasisUtility(super.builder);
}

/// {@macro text_align_utility}
@MixableUtility()
final class TextAlignUtility<T extends StyleElement>
    extends MixUtility<T, TextAlign> with _$TextAlignUtility {
  const TextAlignUtility(super.builder);
}

/// {@macro filter_quality_utility}
@MixableUtility()
final class FilterQualityUtility<T extends StyleElement>
    extends MixUtility<T, FilterQuality> with _$FilterQualityUtility<T> {
  const FilterQualityUtility(super.builder);
}

/// {@macro wrap_alignment_utility}
@MixableUtility()
final class WrapAlignmentUtility<T extends StyleElement>
    extends MixUtility<T, WrapAlignment> with _$WrapAlignmentUtility {
  const WrapAlignmentUtility(super.builder);
}

@MixableUtility()
class TableCellVerticalAlignmentUtility<T extends StyleElement>
    extends MixUtility<T, TableCellVerticalAlignment>
    with _$TableCellVerticalAlignmentUtility<T> {
  const TableCellVerticalAlignmentUtility(super.builder);
}
