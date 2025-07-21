// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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

final class AlignmentUtility<S extends SpecAttribute<Object?>>
    extends PropUtility<S, AlignmentGeometry> {
  const AlignmentUtility(super.builder);

  /// Creates a [StyleBase] instance with a custom [Alignment] or [AlignmentDirectional] value.
  ///
  /// If [start] is provided, an [AlignmentDirectional] is created. Otherwise, an [Alignment] is created.
  /// Throws an [AssertionError] if both [x] and [start] are provided.
  S only({double? x, double? y, double? start}) {
    assert(
      x == null || start == null,
      'Cannot provide both an x and a start parameter.',
    );

    return start == null
        ? call(Alignment(x ?? 0, y ?? 0))
        : call(AlignmentDirectional(start, y ?? 0));
  }

  /// Creates a [StyleBase] instance with [Alignment.topLeft] value.
  S topLeft() => call(Alignment.topLeft);

  /// Creates a [StyleBase] instance with [Alignment.topCenter] value.
  S topCenter() => call(Alignment.topCenter);

  /// Creates a [StyleBase] instance with [Alignment.topRight] value.
  S topRight() => call(Alignment.topRight);

  /// Creates a [StyleBase] instance with [Alignment.centerLeft] value.
  S centerLeft() => call(Alignment.centerLeft);

  /// Creates a [StyleBase] instance with [Alignment.center] value.
  S center() => call(Alignment.center);

  /// Creates a [StyleBase] instance with [Alignment.centerRight] value.
  S centerRight() => call(Alignment.centerRight);

  /// Creates a [StyleBase] instance with [Alignment.bottomLeft] value.
  S bottomLeft() => call(Alignment.bottomLeft);

  /// Creates a [StyleBase] instance with [Alignment.bottomCenter] value.
  S bottomCenter() => call(Alignment.bottomCenter);

  /// Creates a [StyleBase] instance with [Alignment.bottomRight] value.
  S bottomRight() => call(Alignment.bottomRight);
}

final class AlignmentGeometryUtility<S extends SpecAttribute<Object?>>
    extends AlignmentUtility<S> {
  late final directional = AlignmentDirectionalUtility<S>(builder);
  AlignmentGeometryUtility(super.builder);
}

final class AlignmentDirectionalUtility<S extends SpecAttribute<Object?>>
    extends PropUtility<S, AlignmentDirectional> {
  const AlignmentDirectionalUtility(super.builder);

  S only({double? y, double? start}) {
    return call(AlignmentDirectional(start ?? 0, y ?? 0));
  }

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topStart] value.
  S topStart() => call(AlignmentDirectional.topStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topCenter] value.
  S topCenter() => call(AlignmentDirectional.topCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topEnd] value.
  S topEnd() => call(AlignmentDirectional.topEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerStart] value.
  S centerStart() => call(AlignmentDirectional.centerStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.center] value.
  S center() => call(AlignmentDirectional.center);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerEnd] value.
  S centerEnd() => call(AlignmentDirectional.centerEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomStart] value.
  S bottomStart() => call(AlignmentDirectional.bottomStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomCenter] value.
  S bottomCenter() => call(AlignmentDirectional.bottomCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomEnd] value.
  S bottomEnd() => call(AlignmentDirectional.bottomEnd);
}

final class FontFeatureUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, FontFeature> {
  const FontFeatureUtility(super.builder);

  /// Creates a [Style] instance using the [FontFeature.enable] constructor.
  T enable(String feature) => call(FontFeature.enable(feature));

  /// Creates a [Style] instance using the [FontFeature.disable] constructor.
  T disable(String feature) => call(FontFeature.disable(feature));

  /// Creates a [Style] instance using the [FontFeature.alternative] constructor.
  T alternative(int value) => call(FontFeature.alternative(value));

  /// Creates a [Style] instance using the [FontFeature.alternativeFractions] constructor.
  T alternativeFractions() => call(const FontFeature.alternativeFractions());

  /// Creates a [Style] instance using the [FontFeature.contextualAlternates] constructor.
  T contextualAlternates() => call(const FontFeature.contextualAlternates());

  /// Creates a [Style] instance using the [FontFeature.caseSensitiveForms] constructor.
  T caseSensitiveForms() => call(const FontFeature.caseSensitiveForms());

  /// Creates a [Style] instance using the [FontFeature.characterVariant] constructor.
  T characterVariant(int value) => call(FontFeature.characterVariant(value));

  /// Creates a [Style] instance using the [FontFeature.denominator] constructor.
  T denominator() => call(const FontFeature.denominator());

  /// Creates a [Style] instance using the [FontFeature.fractions] constructor.
  T fractions() => call(const FontFeature.fractions());

  /// Creates a [Style] instance using the [FontFeature.historicalForms] constructor.
  T historicalForms() => call(const FontFeature.historicalForms());

  /// Creates a [Style] instance using the [FontFeature.historicalLigatures] constructor.
  T historicalLigatures() => call(const FontFeature.historicalLigatures());

  /// Creates a [Style] instance using the [FontFeature.liningFigures] constructor.
  T liningFigures() => call(const FontFeature.liningFigures());

  /// Creates a [Style] instance using the [FontFeature.localeAware] constructor.
  T localeAware({bool enable = true}) {
    return call(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [Style] instance using the [FontFeature.notationalForms] constructor.
  T notationalForms([int value = 1]) =>
      call(FontFeature.notationalForms(value));

  /// Creates a [Style] instance using the [FontFeature.numerators] constructor.
  T numerators() => call(const FontFeature.numerators());

  /// Creates a [Style] instance using the [FontFeature.oldstyleFigures] constructor.
  T oldstyleFigures() => call(const FontFeature.oldstyleFigures());

  /// Creates a [Style] instance using the [FontFeature.ordinalForms] constructor.
  T ordinalForms() => call(const FontFeature.ordinalForms());

  /// Creates a [Style] instance using the [FontFeature.proportionalFigures] constructor.
  T proportionalFigures() => call(const FontFeature.proportionalFigures());

  /// Creates a [Style] instance using the [FontFeature.randomize] constructor.
  T randomize() => call(const FontFeature.randomize());

  /// Creates a [Style] instance using the [FontFeature.stylisticAlternates] constructor.
  T stylisticAlternates() => call(const FontFeature.stylisticAlternates());

  /// Creates a [Style] instance using the [FontFeature.scientificInferiors] constructor.
  T scientificInferiors() => call(const FontFeature.scientificInferiors());

  /// Creates a [Style] instance using the [FontFeature.stylisticSet] constructor.
  T stylisticSet(int value) => call(FontFeature.stylisticSet(value));

  /// Creates a [Style] instance using the [FontFeature.subscripts] constructor.
  T subscripts() => call(const FontFeature.subscripts());

  /// Creates a [Style] instance using the [FontFeature.superscripts] constructor.
  T superscripts() => call(const FontFeature.superscripts());

  /// Creates a [Style] instance using the [FontFeature.swash] constructor.
  T swash([int value = 1]) => call(FontFeature.swash(value));

  /// Creates a [Style] instance using the [FontFeature.tabularFigures] constructor.
  T tabularFigures() => call(const FontFeature.tabularFigures());

  /// Creates a [Style] instance using the [FontFeature.slashedZero] constructor.
  T slashedZero() => call(const FontFeature.slashedZero());
}

final class DurationUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Duration> {
  const DurationUtility(super.builder);

  T microseconds(int microseconds) =>
      call(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      call(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => call(Duration(seconds: seconds));

  T minutes(int minutes) => call(Duration(minutes: minutes));

  /// Creates a [Style] instance with [Duration.zero] value.
  T zero() => call(Duration.zero);
}

final class FontSizeUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, double> {
  const FontSizeUtility(super.builder);
}

final class FontWeightUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, FontWeight> {
  const FontWeightUtility(super.builder);

  /// Creates a [Style] instance with [FontWeight.w100] value.
  T w100() => call(FontWeight.w100);

  /// Creates a [Style] instance with [FontWeight.w200] value.
  T w200() => call(FontWeight.w200);

  /// Creates a [Style] instance with [FontWeight.w300] value.
  T w300() => call(FontWeight.w300);

  /// Creates a [Style] instance with [FontWeight.w400] value.
  T w400() => call(FontWeight.w400);

  /// Creates a [Style] instance with [FontWeight.w500] value.
  T w500() => call(FontWeight.w500);

  /// Creates a [Style] instance with [FontWeight.w600] value.
  T w600() => call(FontWeight.w600);

  /// Creates a [Style] instance with [FontWeight.w700] value.
  T w700() => call(FontWeight.w700);

  /// Creates a [Style] instance with [FontWeight.w800] value.
  T w800() => call(FontWeight.w800);

  /// Creates a [Style] instance with [FontWeight.w900] value.
  T w900() => call(FontWeight.w900);

  /// Creates a [Style] instance with [FontWeight.normal] value.
  T normal() => call(FontWeight.normal);

  /// Creates a [Style] instance with [FontWeight.bold] value.
  T bold() => call(FontWeight.bold);
}

final class TextDecorationUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextDecoration> {
  const TextDecorationUtility(super.builder);

  /// Creates a [Style] instance with [TextDecoration.none] value.
  T none() => call(TextDecoration.none);

  /// Creates a [Style] instance with [TextDecoration.underline] value.
  T underline() => call(TextDecoration.underline);

  /// Creates a [Style] instance with [TextDecoration.overline] value.
  T overline() => call(TextDecoration.overline);

  /// Creates a [Style] instance with [TextDecoration.lineThrough] value.
  T lineThrough() => call(TextDecoration.lineThrough);

  /// Creates a [Style] instance using the [TextDecoration.combine] constructor.
  T combine(List<TextDecoration> decorations) {
    return call(TextDecoration.combine(decorations));
  }
}

final class CurveUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Curve> {
  const CurveUtility(super.builder);

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) => call(
    SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass),
  );

  /// Creates a [Style] instance with [Curves.linear] value.
  T linear() => call(Curves.linear);

  /// Creates a [Style] instance with [Curves.decelerate] value.
  T decelerate() => call(Curves.decelerate);

  /// Creates a [Style] instance with [Curves.fastLinearToSlowEaseIn] value.
  T fastLinearToSlowEaseIn() => call(Curves.fastLinearToSlowEaseIn);

  /// Creates a [Style] instance with [Curves.fastEaseInToSlowEaseOut] value.
  T fastEaseInToSlowEaseOut() => call(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [Style] instance with [Curves.ease] value.
  T ease() => call(Curves.ease);

  /// Creates a [Style] instance with [Curves.easeIn] value.
  T easeIn() => call(Curves.easeIn);

  /// Creates a [Style] instance with [Curves.easeInToLinear] value.
  T easeInToLinear() => call(Curves.easeInToLinear);

  /// Creates a [Style] instance with [Curves.easeInSine] value.
  T easeInSine() => call(Curves.easeInSine);

  /// Creates a [Style] instance with [Curves.easeInQuad] value.
  T easeInQuad() => call(Curves.easeInQuad);

  /// Creates a [Style] instance with [Curves.easeInCubic] value.
  T easeInCubic() => call(Curves.easeInCubic);

  /// Creates a [Style] instance with [Curves.easeInQuart] value.
  T easeInQuart() => call(Curves.easeInQuart);

  /// Creates a [Style] instance with [Curves.easeInQuint] value.
  T easeInQuint() => call(Curves.easeInQuint);

  /// Creates a [Style] instance with [Curves.easeInExpo] value.
  T easeInExpo() => call(Curves.easeInExpo);

  /// Creates a [Style] instance with [Curves.easeInCirc] value.
  T easeInCirc() => call(Curves.easeInCirc);

  /// Creates a [Style] instance with [Curves.easeInBack] value.
  T easeInBack() => call(Curves.easeInBack);

  /// Creates a [Style] instance with [Curves.easeOut] value.
  T easeOut() => call(Curves.easeOut);

  /// Creates a [Style] instance with [Curves.linearToEaseOut] value.
  T linearToEaseOut() => call(Curves.linearToEaseOut);

  /// Creates a [Style] instance with [Curves.easeOutSine] value.
  T easeOutSine() => call(Curves.easeOutSine);

  /// Creates a [Style] instance with [Curves.easeOutQuad] value.
  T easeOutQuad() => call(Curves.easeOutQuad);

  /// Creates a [Style] instance with [Curves.easeOutCubic] value.
  T easeOutCubic() => call(Curves.easeOutCubic);

  /// Creates a [Style] instance with [Curves.easeOutQuart] value.
  T easeOutQuart() => call(Curves.easeOutQuart);

  /// Creates a [Style] instance with [Curves.easeOutQuint] value.
  T easeOutQuint() => call(Curves.easeOutQuint);

  /// Creates a [Style] instance with [Curves.easeOutExpo] value.
  T easeOutExpo() => call(Curves.easeOutExpo);

  /// Creates a [Style] instance with [Curves.easeOutCirc] value.
  T easeOutCirc() => call(Curves.easeOutCirc);

  /// Creates a [Style] instance with [Curves.easeOutBack] value.
  T easeOutBack() => call(Curves.easeOutBack);

  /// Creates a [Style] instance with [Curves.easeInOut] value.
  T easeInOut() => call(Curves.easeInOut);

  /// Creates a [Style] instance with [Curves.easeInOutSine] value.
  T easeInOutSine() => call(Curves.easeInOutSine);

  /// Creates a [Style] instance with [Curves.easeInOutQuad] value.
  T easeInOutQuad() => call(Curves.easeInOutQuad);

  /// Creates a [Style] instance with [Curves.easeInOutCubic] value.
  T easeInOutCubic() => call(Curves.easeInOutCubic);

  /// Creates a [Style] instance with [Curves.easeInOutCubicEmphasized] value.
  T easeInOutCubicEmphasized() => call(Curves.easeInOutCubicEmphasized);

  /// Creates a [Style] instance with [Curves.easeInOutQuart] value.
  T easeInOutQuart() => call(Curves.easeInOutQuart);

  /// Creates a [Style] instance with [Curves.easeInOutQuint] value.
  T easeInOutQuint() => call(Curves.easeInOutQuint);

  /// Creates a [Style] instance with [Curves.easeInOutExpo] value.
  T easeInOutExpo() => call(Curves.easeInOutExpo);

  /// Creates a [Style] instance with [Curves.easeInOutCirc] value.
  T easeInOutCirc() => call(Curves.easeInOutCirc);

  /// Creates a [Style] instance with [Curves.easeInOutBack] value.
  T easeInOutBack() => call(Curves.easeInOutBack);

  /// Creates a [Style] instance with [Curves.fastOutSlowIn] value.
  T fastOutSlowIn() => call(Curves.fastOutSlowIn);

  /// Creates a [Style] instance with [Curves.slowMiddle] value.
  T slowMiddle() => call(Curves.slowMiddle);

  /// Creates a [Style] instance with [Curves.bounceIn] value.
  T bounceIn() => call(Curves.bounceIn);

  /// Creates a [Style] instance with [Curves.bounceOut] value.
  T bounceOut() => call(Curves.bounceOut);

  /// Creates a [Style] instance with [Curves.bounceInOut] value.
  T bounceInOut() => call(Curves.bounceInOut);

  /// Creates a [Style] instance with [Curves.elasticIn] value.
  T elasticIn() => call(Curves.elasticIn);

  /// Creates a [Style] instance with [Curves.elasticOut] value.
  T elasticOut() => call(Curves.elasticOut);

  /// Creates a [Style] instance with [Curves.elasticInOut] value.
  T elasticInOut() => call(Curves.elasticInOut);
}

final class OffsetUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Offset> {
  const OffsetUtility(super.builder);

  /// Creates a [Style] instance with [Offset.zero] value.
  T zero() => call(Offset.zero);

  /// Creates a [Style] instance with [Offset.infinite] value.
  T infinite() => call(Offset.infinite);

  /// Creates a [Style] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return call(Offset.fromDirection(direction, distance));
  }
}

final class RadiusUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Radius> {
  const RadiusUtility(super.builder);

  // TODO: Update to use MixableToken<Radius> when RadiusMix integration is complete

  /// Creates a [Style] instance with [Radius.zero] value.
  T zero() => call(Radius.zero);

  /// Creates a [Style] instance using the [Radius.circular] constructor.
  T circular(double radius) => call(Radius.circular(radius));

  /// Creates a [Style] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => call(Radius.elliptical(x, y));
}

final class RectUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Rect> {
  const RectUtility(super.builder);

  /// Creates a [Style] instance with [Rect.zero] value.
  T zero() => call(Rect.zero);

  /// Creates a [Style] instance with [Rect.largest] value.
  T largest() => call(Rect.largest);

  /// Creates a [Style] instance using the [Rect.fromLTRB] constructor.
  T fromLTRB(double left, double top, double right, double bottom) {
    return call(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [Style] instance using the [Rect.fromLTWH] constructor.
  T fromLTWH(double left, double top, double width, double height) {
    return call(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [Style] instance using the [Rect.fromCircle] constructor.
  T fromCircle({required Offset center, required double radius}) {
    return call(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [Style] instance using the [Rect.fromCenter] constructor.
  T fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return call(Rect.fromCenter(center: center, width: width, height: height));
  }

  /// Creates a [Style] instance using the [Rect.fromPoints] constructor.
  T fromPoints(Offset a, Offset b) => call(Rect.fromPoints(a, b));
}

final class PaintUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Paint> {
  const PaintUtility(super.builder);
}

final class LocaleUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Locale> {
  const LocaleUtility(super.builder);
}

final class ImageProviderUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, ImageProvider> {
  const ImageProviderUtility(super.builder);

  /// Creates an [Style] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => call(NetworkImage(url));
  T file(File file) => call(FileImage(file));
  T asset(String asset) => call(AssetImage(asset));
  T memory(Uint8List bytes) => call(MemoryImage(bytes));
}

final class GradientTransformUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, GradientTransform> {
  const GradientTransformUtility(super.builder);

  /// Creates an [Style] instance with a [GradientRotation] value.
  T rotate(double radians) => call(GradientRotation(radians));
}

final class Matrix4Utility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, Matrix4> {
  const Matrix4Utility(super.builder);

  /// Creates a [Style] instance using the [Matrix4.fromList] constructor.
  T fromList(List<double> values) => call(Matrix4.fromList(values));

  /// Creates a [Style] instance using the [Matrix4.zero] constructor.
  T zero() => call(Matrix4.zero());

  /// Creates a [Style] instance using the [Matrix4.identity] constructor.
  T identity() => call(Matrix4.identity());

  /// Creates a [Style] instance using the [Matrix4.rotationX] constructor.
  T rotationX(double radians) => call(Matrix4.rotationX(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationY] constructor.
  T rotationY(double radians) => call(Matrix4.rotationY(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationZ] constructor.
  T rotationZ(double radians) => call(Matrix4.rotationZ(radians));

  /// Creates a [Style] instance using the [Matrix4.translationValues] constructor.
  T translationValues(double x, double y, double z) {
    return call(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.diagonal3Values] constructor.
  T diagonal3Values(double x, double y, double z) {
    return call(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.skewX] constructor.
  T skewX(double alpha) => call(Matrix4.skewX(alpha));

  /// Creates a [Style] instance using the [Matrix4.skewY] constructor.
  T skewY(double beta) => call(Matrix4.skewY(beta));

  /// Creates a [Style] instance using the [Matrix4.skew] constructor.
  T skew(double alpha, double beta) => call(Matrix4.skew(alpha, beta));

  /// Creates a [Style] instance using the [Matrix4.fromBuffer] constructor.
  T fromBuffer(ByteBuffer buffer, int offset) {
    return call(Matrix4.fromBuffer(buffer, offset));
  }
}

final class FontFamilyUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, String> {
  const FontFamilyUtility(super.builder);

  /// Creates a [Style] instance using the [String.fromCharCodes] constructor.
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return call(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [Style] instance using the [String.fromCharCode] constructor.
  T fromCharCode(int charCode) => call(String.fromCharCode(charCode));

  /// Creates a [Style] instance using the [String.fromEnvironment] constructor.
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return call(String.fromEnvironment(name, defaultValue: defaultValue));
  }
}

final class TextScalerUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TextScaler> {
  const TextScalerUtility(super.builder);

  /// Creates a [Style] instance with [TextScaler.noScaling] value.
  T noScaling() => call(TextScaler.noScaling);

  /// Creates a [Style] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) => call(TextScaler.linear(textScaleFactor));
}

final class TableColumnWidthUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TableColumnWidth> {
  const TableColumnWidthUtility(super.builder);
}

class TableBorderUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, TableBorder> {
  const TableBorderUtility(super.builder);

  /// Creates a [Style] instance using the [TableBorder.all] constructor.
  T all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return call(
      TableBorder.all(
        color: color,
        width: width,
        style: style,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Creates a [Style] instance using the [TableBorder.symmetric] constructor.
  T symmetric({
    BorderSide inside = BorderSide.none,
    BorderSide outside = BorderSide.none,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return call(
      TableBorder.symmetric(
        inside: inside,
        outside: outside,
        borderRadius: borderRadius,
      ),
    );
  }
}

final class StrokeAlignUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, double> {
  const StrokeAlignUtility(super.builder);

  T center() => call(0);
  T inside() => call(-1);
  T outside() => call(1);
}

final class StringUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, String> {
  const StringUtility(super.builder);
}

/// A utility class for creating [StyleElement] instances from [double] values.
///
/// This class extends [PropUtility] and provides methods to create [StyleElement] instances
/// from predefined [double] values or custom [double] values.
final class DoubleUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, double> {
  const DoubleUtility(super.builder);

  /// Creates an [StyleElement] instance with a value of 0.
  T zero() => call(0);

  /// Creates an [StyleElement] instance with a value of [double.infinity].
  T infinity() => call(double.infinity);
}

/// A utility class for creating [StyleElement] instances from [int] values.
///
/// This class extends [PropUtility] and provides methods to create [StyleElement] instances
/// from predefined [int] values or custom [int] values.
final class IntUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, int> {
  const IntUtility(super.builder);

  /// Creates an [StyleElement] instance with a value of 0.
  T zero() => call(0);
}

/// A utility class for creating [StyleElement] instances from [bool] values.
///
/// This class extends [PropUtility] and provides methods to create [StyleElement] instances
/// from predefined [bool] values or custom [bool] values.
final class BoolUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, bool> {
  const BoolUtility(super.builder);

  /// Creates an [StyleElement] instance with a value of `true`.
  T on() => call(true);

  /// Creates an [StyleElement] instance with a value of `false`.
  T off() => call(false);
}
