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
final class VerticalDirectionUtility<T extends Attribute>
    extends MixUtility<T, VerticalDirection> {
  const VerticalDirectionUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified VerticalDirection value.
  T call(VerticalDirection value) => builder(value);

  /// Creates a [StyleElement] instance with [VerticalDirection.up] value.
  T up() => builder(VerticalDirection.up);

  /// Creates a [StyleElement] instance with [VerticalDirection.down] value.
  T down() => builder(VerticalDirection.down);
}

/// {@template border_style_utility}
/// A utility class for creating [StyleElement] instances from [BorderStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BorderStyle] values.
/// {@endtemplate}
final class BorderStyleUtility<T extends Attribute>
    extends MixUtility<T, BorderStyle> {
  const BorderStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified BorderStyle value.
  T call(BorderStyle value) => builder(value);

  /// Creates a [StyleElement] instance with [BorderStyle.none] value.
  T none() => builder(BorderStyle.none);

  /// Creates a [StyleElement] instance with [BorderStyle.solid] value.
  T solid() => builder(BorderStyle.solid);
}

/// {@template clip_utility}
/// A utility class for creating [StyleElement] instances from [Clip] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Clip] values.
/// {@endtemplate}
final class ClipUtility<T extends Attribute> extends MixUtility<T, Clip> {
  const ClipUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified Clip value.
  T call(Clip value) => builder(value);

  /// Creates a [StyleElement] instance with [Clip.none] value.
  T none() => builder(Clip.none);

  /// Creates a [StyleElement] instance with [Clip.hardEdge] value.
  T hardEdge() => builder(Clip.hardEdge);

  /// Creates a [StyleElement] instance with [Clip.antiAlias] value.
  T antiAlias() => builder(Clip.antiAlias);

  /// Creates a [StyleElement] instance with [Clip.antiAliasWithSaveLayer] value.
  T antiAliasWithSaveLayer() => builder(Clip.antiAliasWithSaveLayer);
}

/// {@template axis_utility}
/// A utility class for creating [StyleElement] instances from [Axis] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Axis] values.
/// {@endtemplate}
final class AxisUtility<T extends Attribute> extends MixUtility<T, Axis> {
  const AxisUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified Axis value.
  T call(Axis value) => builder(value);

  /// Creates a [StyleElement] instance with [Axis.horizontal] value.
  T horizontal() => builder(Axis.horizontal);

  /// Creates a [StyleElement] instance with [Axis.vertical] value.
  T vertical() => builder(Axis.vertical);
}

/// {@template flex_fit_utility}
/// A utility class for creating [StyleElement] instances from [FlexFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FlexFit] values.
/// {@endtemplate}
final class FlexFitUtility<T extends Attribute> extends MixUtility<T, FlexFit> {
  const FlexFitUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified FlexFit value.
  T call(FlexFit value) => builder(value);

  /// Creates a [StyleElement] instance with [FlexFit.tight] value.
  T tight() => builder(FlexFit.tight);

  /// Creates a [StyleElement] instance with [FlexFit.loose] value.
  T loose() => builder(FlexFit.loose);
}

/// {@template stack_fit_utility}
/// A utility class for creating [StyleElement] instances from [StackFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [StackFit] values.
/// {@endtemplate}
final class StackFitUtility<T extends Attribute>
    extends MixUtility<T, StackFit> {
  const StackFitUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified StackFit value.
  T call(StackFit value) => builder(value);

  /// Creates a [StyleElement] instance with [StackFit.loose] value.
  T loose() => builder(StackFit.loose);

  /// Creates a [StyleElement] instance with [StackFit.expand] value.
  T expand() => builder(StackFit.expand);

  /// Creates a [StyleElement] instance with [StackFit.passthrough] value.
  T passthrough() => builder(StackFit.passthrough);
}

/// {@template image_repeat_utility}
/// A utility class for creating [StyleElement] instances from [ImageRepeat] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [ImageRepeat] values.
/// {@endtemplate}
final class ImageRepeatUtility<T extends Attribute>
    extends MixUtility<T, ImageRepeat> {
  const ImageRepeatUtility(super.builder);

  T call([ImageRepeat value = ImageRepeat.repeat]) => builder(value);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeat] value.
  T repeat() => builder(ImageRepeat.repeat);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeatX] value.
  T repeatX() => builder(ImageRepeat.repeatX);

  /// Creates a [StyleElement] instance with [ImageRepeat.repeatY] value.
  T repeatY() => builder(ImageRepeat.repeatY);

  /// Creates a [StyleElement] instance with [ImageRepeat.noRepeat] value.
  T noRepeat() => builder(ImageRepeat.noRepeat);
}

/// {@template text_direction_utility}
/// A utility class for creating [StyleElement] instances from [TextDirection] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextDirection] values.
/// {@endtemplate}
final class TextDirectionUtility<T extends Attribute>
    extends MixUtility<T, TextDirection> {
  const TextDirectionUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextDirection value.
  T call(TextDirection value) => builder(value);

  /// Creates a [StyleElement] instance with [TextDirection.rtl] value.
  T rtl() => builder(TextDirection.rtl);

  /// Creates a [StyleElement] instance with [TextDirection.ltr] value.
  T ltr() => builder(TextDirection.ltr);
}

/// {@template text_leading_distribution_utility}
/// A utility class for creating [StyleElement] instances from [TextLeadingDistribution] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextLeadingDistribution] values.
/// {@endtemplate}
final class TextLeadingDistributionUtility<T extends Attribute>
    extends MixUtility<T, TextLeadingDistribution> {
  const TextLeadingDistributionUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextLeadingDistribution value.
  T call(TextLeadingDistribution value) => builder(value);

  /// Creates a [StyleElement] instance with [TextLeadingDistribution.proportional] value.
  T proportional() => builder(TextLeadingDistribution.proportional);

  /// Creates a [StyleElement] instance with [TextLeadingDistribution.even] value.
  T even() => builder(TextLeadingDistribution.even);
}

/// {@template tile_mode_utility}
/// A utility class for creating [StyleElement] instances from [TileMode] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TileMode] values.
/// {@endtemplate}
final class TileModeUtility<T extends Attribute>
    extends MixUtility<T, TileMode> {
  const TileModeUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TileMode value.
  T call(TileMode value) => builder(value);

  /// Creates a [StyleElement] instance with [TileMode.clamp] value.
  T clamp() => builder(TileMode.clamp);

  /// Creates a [StyleElement] instance with [TileMode.repeated] value.
  T repeated() => builder(TileMode.repeated);

  /// Creates a [StyleElement] instance with [TileMode.mirror] value.
  T mirror() => builder(TileMode.mirror);

  /// Creates a [StyleElement] instance with [TileMode.decal] value.
  T decal() => builder(TileMode.decal);
}

/// {@template main_axis_alignment_utility}
/// A utility class for creating [StyleElement] instances from [MainAxisAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [MainAxisAlignment] values.
/// {@endtemplate}
final class MainAxisAlignmentUtility<T extends Attribute>
    extends MixUtility<T, MainAxisAlignment> {
  const MainAxisAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified MainAxisAlignment value.
  T call(MainAxisAlignment value) => builder(value);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.start] value.
  T start() => builder(MainAxisAlignment.start);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.end] value.
  T end() => builder(MainAxisAlignment.end);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.center] value.
  T center() => builder(MainAxisAlignment.center);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceBetween] value.
  T spaceBetween() => builder(MainAxisAlignment.spaceBetween);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceAround] value.
  T spaceAround() => builder(MainAxisAlignment.spaceAround);

  /// Creates a [StyleElement] instance with [MainAxisAlignment.spaceEvenly] value.
  T spaceEvenly() => builder(MainAxisAlignment.spaceEvenly);
}

/// {@template cross_axis_alignment_utility}
/// A utility class for creating [StyleElement] instances from [CrossAxisAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [CrossAxisAlignment] values.
/// {@endtemplate}
final class CrossAxisAlignmentUtility<T extends Attribute>
    extends MixUtility<T, CrossAxisAlignment> {
  const CrossAxisAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified CrossAxisAlignment value.
  T call(CrossAxisAlignment value) => builder(value);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.start] value.
  T start() => builder(CrossAxisAlignment.start);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.end] value.
  T end() => builder(CrossAxisAlignment.end);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.center] value.
  T center() => builder(CrossAxisAlignment.center);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.stretch] value.
  T stretch() => builder(CrossAxisAlignment.stretch);

  /// Creates a [StyleElement] instance with [CrossAxisAlignment.baseline] value.
  T baseline() => builder(CrossAxisAlignment.baseline);
}

/// {@template main_axis_size_utility}
/// A utility class for creating [StyleElement] instances from [MainAxisSize] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [MainAxisSize] values.
/// {@endtemplate}
final class MainAxisSizeUtility<T extends Attribute>
    extends MixUtility<T, MainAxisSize> {
  const MainAxisSizeUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified MainAxisSize value.
  T call(MainAxisSize value) => builder(value);

  /// Creates a [StyleElement] instance with [MainAxisSize.min] value.
  T min() => builder(MainAxisSize.min);

  /// Creates a [StyleElement] instance with [MainAxisSize.max] value.
  T max() => builder(MainAxisSize.max);
}

/// {@template box_fit_utility}
/// A utility class for creating [StyleElement] instances from [BoxFit] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BoxFit] values.
/// {@endtemplate}
final class BoxFitUtility<T extends Attribute> extends MixUtility<T, BoxFit> {
  const BoxFitUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified BoxFit value.
  T call(BoxFit value) => builder(value);

  /// Creates a [StyleElement] instance with [BoxFit.fill] value.
  T fill() => builder(BoxFit.fill);

  /// Creates a [StyleElement] instance with [BoxFit.contain] value.
  T contain() => builder(BoxFit.contain);

  /// Creates a [StyleElement] instance with [BoxFit.cover] value.
  T cover() => builder(BoxFit.cover);

  /// Creates a [StyleElement] instance with [BoxFit.fitWidth] value.
  T fitWidth() => builder(BoxFit.fitWidth);

  /// Creates a [StyleElement] instance with [BoxFit.fitHeight] value.
  T fitHeight() => builder(BoxFit.fitHeight);

  /// Creates a [StyleElement] instance with [BoxFit.none] value.
  T none() => builder(BoxFit.none);

  /// Creates a [StyleElement] instance with [BoxFit.scaleDown] value.
  T scaleDown() => builder(BoxFit.scaleDown);
}

/// {@template blend_mode_utility}
/// A utility class for creating [StyleElement] instances from [BlendMode] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BlendMode] values.
/// {@endtemplate}
final class BlendModeUtility<T extends Attribute>
    extends MixUtility<T, BlendMode> {
  const BlendModeUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified BlendMode value.
  T call(BlendMode value) => builder(value);

  /// Creates a [StyleElement] instance with [BlendMode.clear] value.
  T clear() => builder(BlendMode.clear);

  /// Creates a [StyleElement] instance with [BlendMode.src] value.
  T src() => builder(BlendMode.src);

  /// Creates a [StyleElement] instance with [BlendMode.dst] value.
  T dst() => builder(BlendMode.dst);

  /// Creates a [StyleElement] instance with [BlendMode.srcOver] value.
  T srcOver() => builder(BlendMode.srcOver);

  /// Creates a [StyleElement] instance with [BlendMode.dstOver] value.
  T dstOver() => builder(BlendMode.dstOver);

  /// Creates a [StyleElement] instance with [BlendMode.srcIn] value.
  T srcIn() => builder(BlendMode.srcIn);

  /// Creates a [StyleElement] instance with [BlendMode.dstIn] value.
  T dstIn() => builder(BlendMode.dstIn);

  /// Creates a [StyleElement] instance with [BlendMode.srcOut] value.
  T srcOut() => builder(BlendMode.srcOut);

  /// Creates a [StyleElement] instance with [BlendMode.dstOut] value.
  T dstOut() => builder(BlendMode.dstOut);

  /// Creates a [StyleElement] instance with [BlendMode.srcATop] value.
  T srcATop() => builder(BlendMode.srcATop);

  /// Creates a [StyleElement] instance with [BlendMode.dstATop] value.
  T dstATop() => builder(BlendMode.dstATop);

  /// Creates a [StyleElement] instance with [BlendMode.xor] value.
  T xor() => builder(BlendMode.xor);

  /// Creates a [StyleElement] instance with [BlendMode.plus] value.
  T plus() => builder(BlendMode.plus);

  /// Creates a [StyleElement] instance with [BlendMode.modulate] value.
  T modulate() => builder(BlendMode.modulate);

  /// Creates a [StyleElement] instance with [BlendMode.screen] value.
  T screen() => builder(BlendMode.screen);

  /// Creates a [StyleElement] instance with [BlendMode.overlay] value.
  T overlay() => builder(BlendMode.overlay);

  /// Creates a [StyleElement] instance with [BlendMode.darken] value.
  T darken() => builder(BlendMode.darken);

  /// Creates a [StyleElement] instance with [BlendMode.lighten] value.
  T lighten() => builder(BlendMode.lighten);

  /// Creates a [StyleElement] instance with [BlendMode.colorDodge] value.
  T colorDodge() => builder(BlendMode.colorDodge);

  /// Creates a [StyleElement] instance with [BlendMode.colorBurn] value.
  T colorBurn() => builder(BlendMode.colorBurn);

  /// Creates a [StyleElement] instance with [BlendMode.hardLight] value.
  T hardLight() => builder(BlendMode.hardLight);

  /// Creates a [StyleElement] instance with [BlendMode.softLight] value.
  T softLight() => builder(BlendMode.softLight);

  /// Creates a [StyleElement] instance with [BlendMode.difference] value.
  T difference() => builder(BlendMode.difference);

  /// Creates a [StyleElement] instance with [BlendMode.exclusion] value.
  T exclusion() => builder(BlendMode.exclusion);

  /// Creates a [StyleElement] instance with [BlendMode.multiply] value.
  T multiply() => builder(BlendMode.multiply);

  /// Creates a [StyleElement] instance with [BlendMode.hue] value.
  T hue() => builder(BlendMode.hue);

  /// Creates a [StyleElement] instance with [BlendMode.saturation] value.
  T saturation() => builder(BlendMode.saturation);

  /// Creates a [StyleElement] instance with [BlendMode.color] value.
  T color() => builder(BlendMode.color);

  /// Creates a [StyleElement] instance with [BlendMode.luminosity] value.
  T luminosity() => builder(BlendMode.luminosity);
}

/// {@template box_shape_utility}
/// A utility class for creating [StyleElement] instances from [BoxShape] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [BoxShape] values.
/// {@endtemplate}
final class BoxShapeUtility<T extends Attribute>
    extends MixUtility<T, BoxShape> {
  const BoxShapeUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified BoxShape value.
  T call(BoxShape value) => builder(value);

  /// Creates a [StyleElement] instance with [BoxShape.rectangle] value.
  T rectangle() => builder(BoxShape.rectangle);

  /// Creates a [StyleElement] instance with [BoxShape.circle] value.
  T circle() => builder(BoxShape.circle);
}

/// {@template font_style_utility}
/// A utility class for creating [StyleElement] instances from [FontStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FontStyle] values.
/// {@endtemplate}
final class FontStyleUtility<T extends Attribute>
    extends MixUtility<T, FontStyle> {
  const FontStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified FontStyle value.
  T call(FontStyle value) => builder(value);

  /// Creates a [StyleElement] instance with [FontStyle.normal] value.
  T normal() => builder(FontStyle.normal);

  /// Creates a [StyleElement] instance with [FontStyle.italic] value.
  T italic() => builder(FontStyle.italic);
}

/// {@template text_decoration_style_utility}
/// A utility class for creating [StyleElement] instances from [TextDecorationStyle] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextDecorationStyle] values.
/// {@endtemplate}
final class TextDecorationStyleUtility<T extends Attribute>
    extends MixUtility<T, TextDecorationStyle> {
  const TextDecorationStyleUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextDecorationStyle value.
  T call(TextDecorationStyle value) => builder(value);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.solid] value.
  T solid() => builder(TextDecorationStyle.solid);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.double] value.
  T double() => builder(TextDecorationStyle.double);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.dotted] value.
  T dotted() => builder(TextDecorationStyle.dotted);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.dashed] value.
  T dashed() => builder(TextDecorationStyle.dashed);

  /// Creates a [StyleElement] instance with [TextDecorationStyle.wavy] value.
  T wavy() => builder(TextDecorationStyle.wavy);
}

/// {@template text_baseline_utility}
/// A utility class for creating [StyleElement] instances from [TextBaseline] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextBaseline] values.
/// {@endtemplate}
final class TextBaselineUtility<T extends Attribute>
    extends MixUtility<T, TextBaseline> {
  const TextBaselineUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextBaseline value.
  T call(TextBaseline value) => builder(value);

  /// Creates a [StyleElement] instance with [TextBaseline.alphabetic] value.
  T alphabetic() => builder(TextBaseline.alphabetic);

  /// Creates a [StyleElement] instance with [TextBaseline.ideographic] value.
  T ideographic() => builder(TextBaseline.ideographic);
}

/// {@template text_overflow_utility}
/// A utility class for creating [StyleElement] instances from [TextOverflow] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextOverflow] values.
/// {@endtemplate}
final class TextOverflowUtility<T extends Attribute>
    extends MixUtility<T, TextOverflow> {
  const TextOverflowUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextOverflow value.
  T call(TextOverflow value) => builder(value);

  /// Creates a [StyleElement] instance with [TextOverflow.clip] value.
  T clip() => builder(TextOverflow.clip);

  /// Creates a [StyleElement] instance with [TextOverflow.fade] value.
  T fade() => builder(TextOverflow.fade);

  /// Creates a [StyleElement] instance with [TextOverflow.ellipsis] value.
  T ellipsis() => builder(TextOverflow.ellipsis);

  /// Creates a [StyleElement] instance with [TextOverflow.visible] value.
  T visible() => builder(TextOverflow.visible);
}

/// {@template text_width_basis_utility}
/// A utility class for creating [StyleElement] instances from [TextWidthBasis] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextWidthBasis] values.
/// {@endtemplate}
final class TextWidthBasisUtility<T extends Attribute>
    extends MixUtility<T, TextWidthBasis> {
  const TextWidthBasisUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextWidthBasis value.
  T call(TextWidthBasis value) => builder(value);

  /// Creates a [StyleElement] instance with [TextWidthBasis.parent] value.
  T parent() => builder(TextWidthBasis.parent);

  /// Creates a [StyleElement] instance with [TextWidthBasis.longestLine] value.
  T longestLine() => builder(TextWidthBasis.longestLine);
}

/// {@template text_align_utility}
/// A utility class for creating [StyleElement] instances from [TextAlign] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextAlign] values.
/// {@endtemplate}
final class TextAlignUtility<T extends Attribute>
    extends MixUtility<T, TextAlign> {
  const TextAlignUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TextAlign value.
  T call(TextAlign value) => builder(value);

  /// Creates a [StyleElement] instance with [TextAlign.left] value.
  T left() => builder(TextAlign.left);

  /// Creates a [StyleElement] instance with [TextAlign.right] value.
  T right() => builder(TextAlign.right);

  /// Creates a [StyleElement] instance with [TextAlign.center] value.
  T center() => builder(TextAlign.center);

  /// Creates a [StyleElement] instance with [TextAlign.justify] value.
  T justify() => builder(TextAlign.justify);

  /// Creates a [StyleElement] instance with [TextAlign.start] value.
  T start() => builder(TextAlign.start);

  /// Creates a [StyleElement] instance with [TextAlign.end] value.
  T end() => builder(TextAlign.end);
}

/// {@template filter_quality_utility}
/// A utility class for creating [StyleElement] instances from [FilterQuality] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FilterQuality] values.
/// {@endtemplate}
final class FilterQualityUtility<T extends Attribute>
    extends MixUtility<T, FilterQuality> {
  const FilterQualityUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified FilterQuality value.
  T call(FilterQuality value) => builder(value);

  /// Creates a [StyleElement] instance with [FilterQuality.none] value.
  T none() => builder(FilterQuality.none);

  /// Creates a [StyleElement] instance with [FilterQuality.low] value.
  T low() => builder(FilterQuality.low);

  /// Creates a [StyleElement] instance with [FilterQuality.medium] value.
  T medium() => builder(FilterQuality.medium);

  /// Creates a [StyleElement] instance with [FilterQuality.high] value.
  T high() => builder(FilterQuality.high);
}

/// {@template wrap_alignment_utility}
/// A utility class for creating [StyleElement] instances from [WrapAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [WrapAlignment] values.
/// {@endtemplate}
final class WrapAlignmentUtility<T extends Attribute>
    extends MixUtility<T, WrapAlignment> {
  const WrapAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified WrapAlignment value.
  T call(WrapAlignment value) => builder(value);

  /// Creates a [StyleElement] instance with [WrapAlignment.start] value.
  T start() => builder(WrapAlignment.start);

  /// Creates a [StyleElement] instance with [WrapAlignment.end] value.
  T end() => builder(WrapAlignment.end);

  /// Creates a [StyleElement] instance with [WrapAlignment.center] value.
  T center() => builder(WrapAlignment.center);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceBetween] value.
  T spaceBetween() => builder(WrapAlignment.spaceBetween);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceAround] value.
  T spaceAround() => builder(WrapAlignment.spaceAround);

  /// Creates a [StyleElement] instance with [WrapAlignment.spaceEvenly] value.
  T spaceEvenly() => builder(WrapAlignment.spaceEvenly);
}

/// {@template table_cell_vertical_alignment_utility}
/// A utility class for creating [StyleElement] instances from [TableCellVerticalAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TableCellVerticalAlignment] values.
/// {@endtemplate}
class TableCellVerticalAlignmentUtility<T extends Attribute>
    extends MixUtility<T, TableCellVerticalAlignment> {
  const TableCellVerticalAlignmentUtility(super.builder);

  /// Creates a [StyleElement] instance with the specified TableCellVerticalAlignment value.
  T call(TableCellVerticalAlignment value) => builder(value);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.top] value.
  T top() => builder(TableCellVerticalAlignment.top);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.middle] value.
  T middle() => builder(TableCellVerticalAlignment.middle);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.bottom] value.
  T bottom() => builder(TableCellVerticalAlignment.bottom);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.baseline] value.
  T baseline() => builder(TableCellVerticalAlignment.baseline);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.fill] value.
  T fill() => builder(TableCellVerticalAlignment.fill);

  /// Creates a [StyleElement] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  T intrinsicHeight() => builder(TableCellVerticalAlignment.intrinsicHeight);
}
