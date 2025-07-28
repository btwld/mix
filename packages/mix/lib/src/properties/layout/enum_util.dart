// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Extension for creating [VerticalDirection] values with predefined options.
extension VerticalDirectionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, VerticalDirection> {
  /// Creates a style with [VerticalDirection.up] value.
  T up() => call(VerticalDirection.up);

  /// Creates a style with [VerticalDirection.down] value.
  T down() => call(VerticalDirection.down);
}

/// Extension for creating [BorderStyle] values with predefined options.
extension BorderStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BorderStyle> {
  /// Creates a style with [BorderStyle.none] value.
  T none() => call(BorderStyle.none);

  /// Creates a style with [BorderStyle.solid] value.
  T solid() => call(BorderStyle.solid);
}

/// Extension for creating [Clip] values with predefined options.
extension ClipPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Clip> {
  /// Creates a [StyleAttribute] instance with [Clip.none] value.
  T none() => call(Clip.none);

  /// Creates a [StyleAttribute] instance with [Clip.hardEdge] value.
  T hardEdge() => call(Clip.hardEdge);

  /// Creates a [StyleAttribute] instance with [Clip.antiAlias] value.
  T antiAlias() => call(Clip.antiAlias);

  /// Creates a [StyleAttribute] instance with [Clip.antiAliasWithSaveLayer] value.
  T antiAliasWithSaveLayer() => call(Clip.antiAliasWithSaveLayer);
}

/// Extension for creating [Axis] values with predefined options.
extension AxisPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Axis> {
  /// Creates a [StyleAttribute] instance with [Axis.horizontal] value.
  T horizontal() => call(Axis.horizontal);

  /// Creates a [StyleAttribute] instance with [Axis.vertical] value.
  T vertical() => call(Axis.vertical);
}

/// Extension for creating [FlexFit] values with predefined options.
extension FlexFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FlexFit> {
  /// Creates a [StyleAttribute] instance with [FlexFit.tight] value.
  T tight() => call(FlexFit.tight);

  /// Creates a [StyleAttribute] instance with [FlexFit.loose] value.
  T loose() => call(FlexFit.loose);
}

/// Extension for creating [StackFit] values with predefined options.
extension StackFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, StackFit> {
  /// Creates a [StyleAttribute] instance with [StackFit.loose] value.
  T loose() => call(StackFit.loose);

  /// Creates a [StyleAttribute] instance with [StackFit.expand] value.
  T expand() => call(StackFit.expand);

  /// Creates a [StyleAttribute] instance with [StackFit.passthrough] value.
  T passthrough() => call(StackFit.passthrough);
}

/// Extension for creating [ImageRepeat] values with predefined options.
extension ImageRepeatPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, ImageRepeat> {
  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeat] value.
  T repeat() => call(ImageRepeat.repeat);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeatX] value.
  T repeatX() => call(ImageRepeat.repeatX);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeatY] value.
  T repeatY() => call(ImageRepeat.repeatY);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.noRepeat] value.
  T noRepeat() => call(ImageRepeat.noRepeat);
}

/// Extension for creating [TextDirection] values with predefined options.
extension TextDirectionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextDirection> {
  /// Creates a [StyleAttribute] instance with [TextDirection.rtl] value.
  T rtl() => call(TextDirection.rtl);

  /// Creates a [StyleAttribute] instance with [TextDirection.ltr] value.
  T ltr() => call(TextDirection.ltr);
}

/// Extension for creating [TextLeadingDistribution] values with predefined options.
extension TextLeadingDistributionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextLeadingDistribution> {
  /// Creates a [StyleAttribute] instance with [TextLeadingDistribution.proportional] value.
  T proportional() => call(TextLeadingDistribution.proportional);

  /// Creates a [StyleAttribute] instance with [TextLeadingDistribution.even] value.
  T even() => call(TextLeadingDistribution.even);
}

/// Extension for creating [TileMode] values with predefined options.
extension TileModePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TileMode> {
  /// Creates a [StyleAttribute] instance with [TileMode.clamp] value.
  T clamp() => call(TileMode.clamp);

  /// Creates a [StyleAttribute] instance with [TileMode.repeated] value.
  T repeated() => call(TileMode.repeated);

  /// Creates a [StyleAttribute] instance with [TileMode.mirror] value.
  T mirror() => call(TileMode.mirror);

  /// Creates a [StyleAttribute] instance with [TileMode.decal] value.
  T decal() => call(TileMode.decal);
}

/// Extension for creating [MainAxisAlignment] values with predefined options.
extension MainAxisAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, MainAxisAlignment> {
  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.start] value.
  T start() => call(MainAxisAlignment.start);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.end] value.
  T end() => call(MainAxisAlignment.end);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.center] value.
  T center() => call(MainAxisAlignment.center);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceBetween] value.
  T spaceBetween() => call(MainAxisAlignment.spaceBetween);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceAround] value.
  T spaceAround() => call(MainAxisAlignment.spaceAround);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceEvenly] value.
  T spaceEvenly() => call(MainAxisAlignment.spaceEvenly);
}

/// Extension for creating [CrossAxisAlignment] values with predefined options.
extension CrossAxisAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, CrossAxisAlignment> {
  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.start] value.
  T start() => call(CrossAxisAlignment.start);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.end] value.
  T end() => call(CrossAxisAlignment.end);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.center] value.
  T center() => call(CrossAxisAlignment.center);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.stretch] value.
  T stretch() => call(CrossAxisAlignment.stretch);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.baseline] value.
  T baseline() => call(CrossAxisAlignment.baseline);
}

/// Extension for creating [MainAxisSize] values with predefined options.
extension MainAxisSizePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, MainAxisSize> {
  /// Creates a [StyleAttribute] instance with [MainAxisSize.min] value.
  T min() => call(MainAxisSize.min);

  /// Creates a [StyleAttribute] instance with [MainAxisSize.max] value.
  T max() => call(MainAxisSize.max);
}

/// Extension for creating [BoxFit] values with predefined options.
extension BoxFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BoxFit> {
  /// Creates a [StyleAttribute] instance with [BoxFit.fill] value.
  T fill() => call(BoxFit.fill);

  /// Creates a [StyleAttribute] instance with [BoxFit.contain] value.
  T contain() => call(BoxFit.contain);

  /// Creates a [StyleAttribute] instance with [BoxFit.cover] value.
  T cover() => call(BoxFit.cover);

  /// Creates a [StyleAttribute] instance with [BoxFit.fitWidth] value.
  T fitWidth() => call(BoxFit.fitWidth);

  /// Creates a [StyleAttribute] instance with [BoxFit.fitHeight] value.
  T fitHeight() => call(BoxFit.fitHeight);

  /// Creates a [StyleAttribute] instance with [BoxFit.none] value.
  T none() => call(BoxFit.none);

  /// Creates a [StyleAttribute] instance with [BoxFit.scaleDown] value.
  T scaleDown() => call(BoxFit.scaleDown);
}

/// Extension for creating [BlendMode] values with predefined options.
extension BlendModePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BlendMode> {
  /// Creates a [StyleAttribute] instance with [BlendMode.clear] value.
  T clear() => call(BlendMode.clear);

  /// Creates a [StyleAttribute] instance with [BlendMode.src] value.
  T src() => call(BlendMode.src);

  /// Creates a [StyleAttribute] instance with [BlendMode.dst] value.
  T dst() => call(BlendMode.dst);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcOver] value.
  T srcOver() => call(BlendMode.srcOver);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstOver] value.
  T dstOver() => call(BlendMode.dstOver);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcIn] value.
  T srcIn() => call(BlendMode.srcIn);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstIn] value.
  T dstIn() => call(BlendMode.dstIn);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcOut] value.
  T srcOut() => call(BlendMode.srcOut);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstOut] value.
  T dstOut() => call(BlendMode.dstOut);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcATop] value.
  T srcATop() => call(BlendMode.srcATop);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstATop] value.
  T dstATop() => call(BlendMode.dstATop);

  /// Creates a [StyleAttribute] instance with [BlendMode.xor] value.
  T xor() => call(BlendMode.xor);

  /// Creates a [StyleAttribute] instance with [BlendMode.plus] value.
  T plus() => call(BlendMode.plus);

  /// Creates a [StyleAttribute] instance with [BlendMode.modulate] value.
  T modulate() => call(BlendMode.modulate);

  /// Creates a [StyleAttribute] instance with [BlendMode.screen] value.
  T screen() => call(BlendMode.screen);

  /// Creates a [StyleAttribute] instance with [BlendMode.overlay] value.
  T overlay() => call(BlendMode.overlay);

  /// Creates a [StyleAttribute] instance with [BlendMode.darken] value.
  T darken() => call(BlendMode.darken);

  /// Creates a [StyleAttribute] instance with [BlendMode.lighten] value.
  T lighten() => call(BlendMode.lighten);

  /// Creates a [StyleAttribute] instance with [BlendMode.colorDodge] value.
  T colorDodge() => call(BlendMode.colorDodge);

  /// Creates a [StyleAttribute] instance with [BlendMode.colorBurn] value.
  T colorBurn() => call(BlendMode.colorBurn);

  /// Creates a [StyleAttribute] instance with [BlendMode.hardLight] value.
  T hardLight() => call(BlendMode.hardLight);

  /// Creates a [StyleAttribute] instance with [BlendMode.softLight] value.
  T softLight() => call(BlendMode.softLight);

  /// Creates a [StyleAttribute] instance with [BlendMode.difference] value.
  T difference() => call(BlendMode.difference);

  /// Creates a [StyleAttribute] instance with [BlendMode.exclusion] value.
  T exclusion() => call(BlendMode.exclusion);

  /// Creates a [StyleAttribute] instance with [BlendMode.multiply] value.
  T multiply() => call(BlendMode.multiply);

  /// Creates a [StyleAttribute] instance with [BlendMode.hue] value.
  T hue() => call(BlendMode.hue);

  /// Creates a [StyleAttribute] instance with [BlendMode.saturation] value.
  T saturation() => call(BlendMode.saturation);

  /// Creates a [StyleAttribute] instance with [BlendMode.color] value.
  T color() => call(BlendMode.color);

  /// Creates a [StyleAttribute] instance with [BlendMode.luminosity] value.
  T luminosity() => call(BlendMode.luminosity);
}

/// Extension for creating [BoxShape] values with predefined options.
extension BoxShapePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BoxShape> {
  /// Creates a [StyleAttribute] instance with [BoxShape.rectangle] value.
  T rectangle() => call(BoxShape.rectangle);

  /// Creates a [StyleAttribute] instance with [BoxShape.circle] value.
  T circle() => call(BoxShape.circle);
}

/// Extension for creating [FontStyle] values with predefined options.
extension FontStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FontStyle> {
  /// Creates a [StyleAttribute] instance with [FontStyle.normal] value.
  T normal() => call(FontStyle.normal);

  /// Creates a [StyleAttribute] instance with [FontStyle.italic] value.
  T italic() => call(FontStyle.italic);
}

/// Extension for creating [TextDecorationStyle] values with predefined options.
extension TextDecorationStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextDecorationStyle> {
  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.solid] value.
  T solid() => call(TextDecorationStyle.solid);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.double] value.
  T double() => call(TextDecorationStyle.double);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.dotted] value.
  T dotted() => call(TextDecorationStyle.dotted);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.dashed] value.
  T dashed() => call(TextDecorationStyle.dashed);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.wavy] value.
  T wavy() => call(TextDecorationStyle.wavy);
}

/// Extension for creating [TextBaseline] values with predefined options.
extension TextBaselinePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextBaseline> {
  /// Creates a [StyleAttribute] instance with [TextBaseline.alphabetic] value.
  T alphabetic() => call(TextBaseline.alphabetic);

  /// Creates a [StyleAttribute] instance with [TextBaseline.ideographic] value.
  T ideographic() => call(TextBaseline.ideographic);
}

/// Extension for creating [TextOverflow] values with predefined options.
extension TextOverflowPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextOverflow> {
  /// Creates a [StyleAttribute] instance with [TextOverflow.clip] value.
  T clip() => call(TextOverflow.clip);

  /// Creates a [StyleAttribute] instance with [TextOverflow.fade] value.
  T fade() => call(TextOverflow.fade);

  /// Creates a [StyleAttribute] instance with [TextOverflow.ellipsis] value.
  T ellipsis() => call(TextOverflow.ellipsis);

  /// Creates a [StyleAttribute] instance with [TextOverflow.visible] value.
  T visible() => call(TextOverflow.visible);
}

/// Extension for creating [TextWidthBasis] values with predefined options.
extension TextWidthBasisPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextWidthBasis> {
  /// Creates a [StyleAttribute] instance with [TextWidthBasis.parent] value.
  T parent() => call(TextWidthBasis.parent);

  /// Creates a [StyleAttribute] instance with [TextWidthBasis.longestLine] value.
  T longestLine() => call(TextWidthBasis.longestLine);
}

/// Extension for creating [TextAlign] values with predefined options.
extension TextAlignPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextAlign> {
  /// Creates a [StyleAttribute] instance with [TextAlign.left] value.
  T left() => call(TextAlign.left);

  /// Creates a [StyleAttribute] instance with [TextAlign.right] value.
  T right() => call(TextAlign.right);

  /// Creates a [StyleAttribute] instance with [TextAlign.center] value.
  T center() => call(TextAlign.center);

  /// Creates a [StyleAttribute] instance with [TextAlign.justify] value.
  T justify() => call(TextAlign.justify);

  /// Creates a [StyleAttribute] instance with [TextAlign.start] value.
  T start() => call(TextAlign.start);

  /// Creates a [StyleAttribute] instance with [TextAlign.end] value.
  T end() => call(TextAlign.end);
}

/// Extension for creating [FilterQuality] values with predefined options.
extension FilterQualityPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FilterQuality> {
  /// Creates a [StyleAttribute] instance with [FilterQuality.none] value.
  T none() => call(FilterQuality.none);

  /// Creates a [StyleAttribute] instance with [FilterQuality.low] value.
  T low() => call(FilterQuality.low);

  /// Creates a [StyleAttribute] instance with [FilterQuality.medium] value.
  T medium() => call(FilterQuality.medium);

  /// Creates a [StyleAttribute] instance with [FilterQuality.high] value.
  T high() => call(FilterQuality.high);
}

/// Extension for creating [WrapAlignment] values with predefined options.
extension WrapAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, WrapAlignment> {
  /// Creates a [StyleAttribute] instance with [WrapAlignment.start] value.
  T start() => call(WrapAlignment.start);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.end] value.
  T end() => call(WrapAlignment.end);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.center] value.
  T center() => call(WrapAlignment.center);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceBetween] value.
  T spaceBetween() => call(WrapAlignment.spaceBetween);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceAround] value.
  T spaceAround() => call(WrapAlignment.spaceAround);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceEvenly] value.
  T spaceEvenly() => call(WrapAlignment.spaceEvenly);
}

/// Extension for creating [TableCellVerticalAlignment] values with predefined options.
extension TableCellVerticalAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TableCellVerticalAlignment> {
  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.top] value.
  T top() => call(TableCellVerticalAlignment.top);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.middle] value.
  T middle() => call(TableCellVerticalAlignment.middle);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.bottom] value.
  T bottom() => call(TableCellVerticalAlignment.bottom);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.baseline] value.
  T baseline() => call(TableCellVerticalAlignment.baseline);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.fill] value.
  T fill() => call(TableCellVerticalAlignment.fill);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  T intrinsicHeight() => call(TableCellVerticalAlignment.intrinsicHeight);
}