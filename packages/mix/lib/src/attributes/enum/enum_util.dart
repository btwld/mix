// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/utility.dart';

/// {@template vertical_direction_utility}
/// A utility class for creating [StyleElement] instances from [VerticalDirection] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [VerticalDirection] values.
/// {@endtemplate}
final class VerticalDirectionUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, VerticalDirection> {
  const VerticalDirectionUtility(super.builder);

  /// Creates a [StyleElement] instance with [VerticalDirection.up] value.
  T up() => call(VerticalDirection.up);

  /// Creates a [StyleElement] instance with [VerticalDirection.down] value.
  T down() => call(VerticalDirection.down);
}

/// {@template border_style_utility}
/// A utility class for creating [StyleElement] instances from [BorderStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BorderStyle] values.
/// {@endtemplate}
final class BorderStyleUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, BorderStyle> {
  const BorderStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with [BorderStyle.none] value.
  T none() => call(BorderStyle.none);

  /// Creates a [StyleElement] instance with [BorderStyle.solid] value.
  T solid() => call(BorderStyle.solid);
}

/// {@template clip_utility}
/// A utility class for creating [StyleElement] instances from [Clip] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Clip] values.
/// {@endtemplate}
final class ClipUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Clip> {
  const ClipUtility(super.builder);

  /// Creates a [StyleElement] instance with [Clip.none] value.
  T none() => call(Clip.none);

  /// Creates a [StyleElement] instance with [Clip.hardEdge] value.
  T hardEdge() => call(Clip.hardEdge);

  /// Creates a [StyleElement] instance with [Clip.antiAlias] value.
  T antiAlias() => call(Clip.antiAlias);

  /// Creates a [StyleElement] instance with [Clip.antiAliasWithSaveLayer] value.
  T antiAliasWithSaveLayer() => call(Clip.antiAliasWithSaveLayer);
}

/// {@template axis_utility}
/// A utility class for creating [StyleElement] instances from [Axis] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Axis] values.
/// {@endtemplate}
final class AxisUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Axis> {
  const AxisUtility(super.builder);

  /// Creates a [StyleElement] instance with [Axis.horizontal] value.
  T horizontal() => call(Axis.horizontal);

  /// Creates a [StyleElement] instance with [Axis.vertical] value.
  T vertical() => call(Axis.vertical);
}

/// {@template flex_fit_utility}
/// A utility class for creating [StyleElement] instances from [FlexFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FlexFit] values.
/// {@endtemplate}
final class FlexFitUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, FlexFit> {
  const FlexFitUtility(super.builder);

  /// Creates a [StyleElement] instance with [FlexFit.tight] value.
  T tight() => call(FlexFit.tight);

  /// Creates a [StyleElement] instance with [FlexFit.loose] value.
  T loose() => call(FlexFit.loose);
}

/// {@template stack_fit_utility}
/// A utility class for creating [StyleElement] instances from [StackFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [StackFit] values.
/// {@endtemplate}
final class StackFitUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, StackFit> {
  const StackFitUtility(super.builder);

  /// Creates a [StyleElement] instance with [StackFit.loose] value.
  T loose() => call(StackFit.loose);

  /// Creates a [StyleElement] instance with [StackFit.expand] value.
  T expand() => call(StackFit.expand);

  /// Creates a [StyleElement] instance with [StackFit.passthrough] value.
  T passthrough() => call(StackFit.passthrough);
}

/// {@template image_repeat_utility}
/// A utility class for creating [StyleElement] instances from [ImageRepeat] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [ImageRepeat] values.
/// {@endtemplate}
final class ImageRepeatUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, ImageRepeat> {
  const ImageRepeatUtility(super.builder);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeat] value.
  T repeat() => call(ImageRepeat.repeat);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeatX] value.
  T repeatX() => call(ImageRepeat.repeatX);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeatY] value.
  T repeatY() => call(ImageRepeat.repeatY);

  /// Creates a [StyleElement] instance with [ImageRepeat.noRepeat] value.
  T noRepeat() => call(ImageRepeat.noRepeat);
}

/// {@template text_direction_utility}
/// A utility class for creating [StyleElement] instances from [TextDirection] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextDirection] values.
/// {@endtemplate}
final class TextDirectionUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextDirection> {
  const TextDirectionUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextDirection.rtl] value.
  T rtl() => call(TextDirection.rtl);

  /// Creates a [StyleElement] instance with [TextDirection.ltr] value.
  T ltr() => call(TextDirection.ltr);
}

/// {@template text_leading_distribution_utility}
/// A utility class for creating [StyleElement] instances from [TextLeadingDistribution] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextLeadingDistribution] values.
/// {@endtemplate}
final class TextLeadingDistributionUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextLeadingDistribution> {
  const TextLeadingDistributionUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextLeadingDistribution.proportional] value.
  T proportional() => call(TextLeadingDistribution.proportional);

  /// Creates a [StyleElement] instance with [TextLeadingDistribution.even] value.
  T even() => call(TextLeadingDistribution.even);
}

/// {@template tile_mode_utility}
/// A utility class for creating [StyleElement] instances from [TileMode] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TileMode] values.
/// {@endtemplate}
final class TileModeUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TileMode> {
  const TileModeUtility(super.builder);

  /// Creates a [StyleElement] instance with [TileMode.clamp] value.
  T clamp() => call(TileMode.clamp);

  /// Creates a [StyleElement] instance with [TileMode.repeated] value.
  T repeated() => call(TileMode.repeated);

  /// Creates a [StyleElement] instance with [TileMode.mirror] value.
  T mirror() => call(TileMode.mirror);

  /// Creates a [StyleElement] instance with [TileMode.decal] value.
  T decal() => call(TileMode.decal);
}

/// {@template main_axis_alignment_utility}
/// A utility class for creating [StyleElement] instances from [MainAxisAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [MainAxisAlignment] values.
/// {@endtemplate}
final class MainAxisAlignmentUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, MainAxisAlignment> {
  const MainAxisAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.start] value.
  T start() => call(MainAxisAlignment.start);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.end] value.
  T end() => call(MainAxisAlignment.end);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.center] value.
  T center() => call(MainAxisAlignment.center);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceBetween] value.
  T spaceBetween() => call(MainAxisAlignment.spaceBetween);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceAround] value.
  T spaceAround() => call(MainAxisAlignment.spaceAround);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceEvenly] value.
  T spaceEvenly() => call(MainAxisAlignment.spaceEvenly);
}

/// {@template cross_axis_alignment_utility}
/// A utility class for creating [StyleElement] instances from [CrossAxisAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [CrossAxisAlignment] values.
/// {@endtemplate}
final class CrossAxisAlignmentUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, CrossAxisAlignment> {
  const CrossAxisAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.start] value.
  T start() => call(CrossAxisAlignment.start);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.end] value.
  T end() => call(CrossAxisAlignment.end);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.center] value.
  T center() => call(CrossAxisAlignment.center);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.stretch] value.
  T stretch() => call(CrossAxisAlignment.stretch);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.baseline] value.
  T baseline() => call(CrossAxisAlignment.baseline);
}

/// {@template main_axis_size_utility}
/// A utility class for creating [StyleElement] instances from [MainAxisSize] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [MainAxisSize] values.
/// {@endtemplate}
final class MainAxisSizeUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, MainAxisSize> {
  const MainAxisSizeUtility(super.builder);

  /// Creates a [StyleElement] instance with [MainAxisSize.min] value.
  T min() => call(MainAxisSize.min);

  /// Creates a [StyleElement] instance with [MainAxisSize.max] value.
  T max() => call(MainAxisSize.max);
}

/// {@template box_fit_utility}
/// A utility class for creating [StyleElement] instances from [BoxFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BoxFit] values.
/// {@endtemplate}
final class BoxFitUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, BoxFit> {
  const BoxFitUtility(super.builder);

  /// Creates a [StyleElement] instance with [BoxFit.fill] value.
  T fill() => call(BoxFit.fill);

  /// Creates a [StyleElement] instance with [BoxFit.contain] value.
  T contain() => call(BoxFit.contain);

  /// Creates a [StyleElement] instance with [BoxFit.cover] value.
  T cover() => call(BoxFit.cover);

  /// Creates a [StyleElement] instance with [BoxFit.fitWidth] value.
  T fitWidth() => call(BoxFit.fitWidth);

  /// Creates a [StyleElement] instance with [BoxFit.fitHeight] value.
  T fitHeight() => call(BoxFit.fitHeight);

  /// Creates a [StyleElement] instance with [BoxFit.none] value.
  T none() => call(BoxFit.none);

  /// Creates a [StyleElement] instance with [BoxFit.scaleDown] value.
  T scaleDown() => call(BoxFit.scaleDown);
}

/// {@template blend_mode_utility}
/// A utility class for creating [StyleElement] instances from [BlendMode] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BlendMode] values.
/// {@endtemplate}
final class BlendModeUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, BlendMode> {
  const BlendModeUtility(super.builder);

  /// Creates a [StyleElement] instance with [BlendMode.clear] value.
  T clear() => call(BlendMode.clear);

  /// Creates a [StyleElement] instance with [BlendMode.src] value.
  T src() => call(BlendMode.src);

  /// Creates a [StyleElement] instance with [BlendMode.dst] value.
  T dst() => call(BlendMode.dst);

  /// Creates a [StyleElement] instance with [BlendMode.srcOver] value.
  T srcOver() => call(BlendMode.srcOver);

  /// Creates a [StyleElement] instance with [BlendMode.dstOver] value.
  T dstOver() => call(BlendMode.dstOver);

  /// Creates a [StyleElement] instance with [BlendMode.srcIn] value.
  T srcIn() => call(BlendMode.srcIn);

  /// Creates a [StyleElement] instance with [BlendMode.dstIn] value.
  T dstIn() => call(BlendMode.dstIn);

  /// Creates a [StyleElement] instance with [BlendMode.srcOut] value.
  T srcOut() => call(BlendMode.srcOut);

  /// Creates a [StyleElement] instance with [BlendMode.dstOut] value.
  T dstOut() => call(BlendMode.dstOut);

  /// Creates a [StyleElement] instance with [BlendMode.srcATop] value.
  T srcATop() => call(BlendMode.srcATop);

  /// Creates a [StyleElement] instance with [BlendMode.dstATop] value.
  T dstATop() => call(BlendMode.dstATop);

  /// Creates a [StyleElement] instance with [BlendMode.xor] value.
  T xor() => call(BlendMode.xor);

  /// Creates a [StyleElement] instance with [BlendMode.plus] value.
  T plus() => call(BlendMode.plus);

  /// Creates a [StyleElement] instance with [BlendMode.modulate] value.
  T modulate() => call(BlendMode.modulate);

  /// Creates a [StyleElement] instance with [BlendMode.screen] value.
  T screen() => call(BlendMode.screen);

  /// Creates a [StyleElement] instance with [BlendMode.overlay] value.
  T overlay() => call(BlendMode.overlay);

  /// Creates a [StyleElement] instance with [BlendMode.darken] value.
  T darken() => call(BlendMode.darken);

  /// Creates a [StyleElement] instance with [BlendMode.lighten] value.
  T lighten() => call(BlendMode.lighten);

  /// Creates a [StyleElement] instance with [BlendMode.colorDodge] value.
  T colorDodge() => call(BlendMode.colorDodge);

  /// Creates a [StyleElement] instance with [BlendMode.colorBurn] value.
  T colorBurn() => call(BlendMode.colorBurn);

  /// Creates a [StyleElement] instance with [BlendMode.hardLight] value.
  T hardLight() => call(BlendMode.hardLight);

  /// Creates a [StyleElement] instance with [BlendMode.softLight] value.
  T softLight() => call(BlendMode.softLight);

  /// Creates a [StyleElement] instance with [BlendMode.difference] value.
  T difference() => call(BlendMode.difference);

  /// Creates a [StyleElement] instance with [BlendMode.exclusion] value.
  T exclusion() => call(BlendMode.exclusion);

  /// Creates a [StyleElement] instance with [BlendMode.multiply] value.
  T multiply() => call(BlendMode.multiply);

  /// Creates a [StyleElement] instance with [BlendMode.hue] value.
  T hue() => call(BlendMode.hue);

  /// Creates a [StyleElement] instance with [BlendMode.saturation] value.
  T saturation() => call(BlendMode.saturation);

  /// Creates a [StyleElement] instance with [BlendMode.color] value.
  T color() => call(BlendMode.color);

  /// Creates a [StyleElement] instance with [BlendMode.luminosity] value.
  T luminosity() => call(BlendMode.luminosity);
}

/// {@template box_shape_utility}
/// A utility class for creating [StyleElement] instances from [BoxShape] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BoxShape] values.
/// {@endtemplate}
final class BoxShapeUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, BoxShape> {
  const BoxShapeUtility(super.builder);

  /// Creates a [StyleElement] instance with [BoxShape.rectangle] value.
  T rectangle() => call(BoxShape.rectangle);

  /// Creates a [StyleElement] instance with [BoxShape.circle] value.
  T circle() => call(BoxShape.circle);
}

/// {@template font_style_utility}
/// A utility class for creating [StyleElement] instances from [FontStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FontStyle] values.
/// {@endtemplate}
final class FontStyleUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, FontStyle> {
  const FontStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with [FontStyle.normal] value.
  T normal() => call(FontStyle.normal);

  /// Creates a [StyleElement] instance with [FontStyle.italic] value.
  T italic() => call(FontStyle.italic);
}

/// {@template text_decoration_style_utility}
/// A utility class for creating [StyleElement] instances from [TextDecorationStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextDecorationStyle] values.
/// {@endtemplate}
final class TextDecorationStyleUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextDecorationStyle> {
  const TextDecorationStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.solid] value.
  T solid() => call(TextDecorationStyle.solid);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.double] value.
  T double() => call(TextDecorationStyle.double);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.dotted] value.
  T dotted() => call(TextDecorationStyle.dotted);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.dashed] value.
  T dashed() => call(TextDecorationStyle.dashed);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.wavy] value.
  T wavy() => call(TextDecorationStyle.wavy);
}

/// {@template text_baseline_utility}
/// A utility class for creating [StyleElement] instances from [TextBaseline] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextBaseline] values.
/// {@endtemplate}
final class TextBaselineUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextBaseline> {
  const TextBaselineUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextBaseline.alphabetic] value.
  T alphabetic() => call(TextBaseline.alphabetic);

  /// Creates a [StyleElement] instance with [TextBaseline.ideographic] value.
  T ideographic() => call(TextBaseline.ideographic);
}

/// {@template text_overflow_utility}
/// A utility class for creating [StyleElement] instances from [TextOverflow] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextOverflow] values.
/// {@endtemplate}
final class TextOverflowUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextOverflow> {
  const TextOverflowUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextOverflow.clip] value.
  T clip() => call(TextOverflow.clip);

  /// Creates a [StyleElement] instance with [TextOverflow.fade] value.
  T fade() => call(TextOverflow.fade);

  /// Creates a [StyleElement] instance with [TextOverflow.ellipsis] value.
  T ellipsis() => call(TextOverflow.ellipsis);

  /// Creates a [StyleElement] instance with [TextOverflow.visible] value.
  T visible() => call(TextOverflow.visible);
}

/// {@template text_width_basis_utility}
/// A utility class for creating [StyleElement] instances from [TextWidthBasis] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextWidthBasis] values.
/// {@endtemplate}
final class TextWidthBasisUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextWidthBasis> {
  const TextWidthBasisUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextWidthBasis.parent] value.
  T parent() => call(TextWidthBasis.parent);

  /// Creates a [StyleElement] instance with [TextWidthBasis.longestLine] value.
  T longestLine() => call(TextWidthBasis.longestLine);
}

/// {@template text_align_utility}
/// A utility class for creating [StyleElement] instances from [TextAlign] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextAlign] values.
/// {@endtemplate}
final class TextAlignUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextAlign> {
  const TextAlignUtility(super.builder);

  /// Creates a [StyleElement] instance with [TextAlign.left] value.
  T left() => call(TextAlign.left);

  /// Creates a [StyleElement] instance with [TextAlign.right] value.
  T right() => call(TextAlign.right);

  /// Creates a [StyleElement] instance with [TextAlign.center] value.
  T center() => call(TextAlign.center);

  /// Creates a [StyleElement] instance with [TextAlign.justify] value.
  T justify() => call(TextAlign.justify);

  /// Creates a [StyleElement] instance with [TextAlign.start] value.
  T start() => call(TextAlign.start);

  /// Creates a [StyleElement] instance with [TextAlign.end] value.
  T end() => call(TextAlign.end);
}

/// {@template filter_quality_utility}
/// A utility class for creating [StyleElement] instances from [FilterQuality] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FilterQuality] values.
/// {@endtemplate}
final class FilterQualityUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, FilterQuality> {
  const FilterQualityUtility(super.builder);

  /// Creates a [StyleElement] instance with [FilterQuality.none] value.
  T none() => call(FilterQuality.none);

  /// Creates a [StyleElement] instance with [FilterQuality.low] value.
  T low() => call(FilterQuality.low);

  /// Creates a [StyleElement] instance with [FilterQuality.medium] value.
  T medium() => call(FilterQuality.medium);

  /// Creates a [StyleElement] instance with [FilterQuality.high] value.
  T high() => call(FilterQuality.high);
}

/// {@template wrap_alignment_utility}
/// A utility class for creating [StyleElement] instances from [WrapAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [WrapAlignment] values.
/// {@endtemplate}
final class WrapAlignmentUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, WrapAlignment> {
  const WrapAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with [WrapAlignment.start] value.
  T start() => call(WrapAlignment.start);

  /// Creates a [StyleElement] instance with [WrapAlignment.end] value.
  T end() => call(WrapAlignment.end);

  /// Creates a [StyleElement] instance with [WrapAlignment.center] value.
  T center() => call(WrapAlignment.center);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceBetween] value.
  T spaceBetween() => call(WrapAlignment.spaceBetween);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceAround] value.
  T spaceAround() => call(WrapAlignment.spaceAround);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceEvenly] value.
  T spaceEvenly() => call(WrapAlignment.spaceEvenly);
}

/// {@template table_cell_vertical_alignment_utility}
/// A utility class for creating [StyleElement] instances from [TableCellVerticalAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TableCellVerticalAlignment] values.
/// {@endtemplate}
class TableCellVerticalAlignmentUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TableCellVerticalAlignment> {
  const TableCellVerticalAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.top] value.
  T top() => call(TableCellVerticalAlignment.top);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.middle] value.
  T middle() => call(TableCellVerticalAlignment.middle);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.bottom] value.
  T bottom() => call(TableCellVerticalAlignment.bottom);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.baseline] value.
  T baseline() => call(TableCellVerticalAlignment.baseline);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.fill] value.
  T fill() => call(TableCellVerticalAlignment.fill);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  T intrinsicHeight() => call(TableCellVerticalAlignment.intrinsicHeight);
}
