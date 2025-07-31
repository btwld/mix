// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';

/// Extension for creating [VerticalDirection] values with predefined options.
extension VerticalDirectionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, VerticalDirection> {
  T call(VerticalDirection value) => builder(value);

  /// Creates a style with [VerticalDirection.up] value.
  T up() => call(VerticalDirection.up);

  /// Creates a style with [VerticalDirection.down] value.
  T down() => call(VerticalDirection.down);
}

/// Extension for creating [BorderStyle] values with predefined options.
extension BorderStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BorderStyle> {
  T call(BorderStyle value) => builder(value);

  /// Creates a style with [BorderStyle.none] value.
  T none() => call(BorderStyle.none);

  /// Creates a style with [BorderStyle.solid] value.
  T solid() => call(BorderStyle.solid);
}

/// Extension for creating [Clip] values with predefined options.
extension ClipPropUtilityExt<T extends Style<Object?>> on MixUtility<T, Clip> {
  T call(Clip value) => builder(value);

  /// Creates a [Style] instance with [Clip.none] value.
  T none() => call(Clip.none);

  /// Creates a [Style] instance with [Clip.hardEdge] value.
  T hardEdge() => call(Clip.hardEdge);

  /// Creates a [Style] instance with [Clip.antiAlias] value.
  T antiAlias() => call(Clip.antiAlias);

  /// Creates a [Style] instance with [Clip.antiAliasWithSaveLayer] value.
  T antiAliasWithSaveLayer() => call(Clip.antiAliasWithSaveLayer);
}

/// Extension for creating [Axis] values with predefined options.
extension AxisPropUtilityExt<T extends Style<Object?>> on MixUtility<T, Axis> {
  T call(Axis value) => builder(value);

  /// Creates a [Style] instance with [Axis.horizontal] value.
  T horizontal() => call(Axis.horizontal);

  /// Creates a [Style] instance with [Axis.vertical] value.
  T vertical() => call(Axis.vertical);
}

/// Extension for creating [FlexFit] values with predefined options.
extension FlexFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FlexFit> {
  T call(FlexFit value) => builder(value);

  /// Creates a [Style] instance with [FlexFit.tight] value.
  T tight() => call(FlexFit.tight);

  /// Creates a [Style] instance with [FlexFit.loose] value.
  T loose() => call(FlexFit.loose);
}

/// Extension for creating [StackFit] values with predefined options.
extension StackFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, StackFit> {
  T call(StackFit value) => builder(value);

  /// Creates a [Style] instance with [StackFit.loose] value.
  T loose() => call(StackFit.loose);

  /// Creates a [Style] instance with [StackFit.expand] value.
  T expand() => call(StackFit.expand);

  /// Creates a [Style] instance with [StackFit.passthrough] value.
  T passthrough() => call(StackFit.passthrough);
}

/// Extension for creating [ImageRepeat] values with predefined options.
extension ImageRepeatPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, ImageRepeat> {
  T call(ImageRepeat value) => builder(value);

  /// Creates a [Style] instance with [ImageRepeat.repeat] value.
  T repeat() => call(ImageRepeat.repeat);

  /// Creates a [Style] instance with [ImageRepeat.repeatX] value.
  T repeatX() => call(ImageRepeat.repeatX);

  /// Creates a [Style] instance with [ImageRepeat.repeatY] value.
  T repeatY() => call(ImageRepeat.repeatY);

  /// Creates a [Style] instance with [ImageRepeat.noRepeat] value.
  T noRepeat() => call(ImageRepeat.noRepeat);
}

/// Extension for creating [TextDirection] values with predefined options.
extension TextDirectionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextDirection> {
  T call(TextDirection value) => builder(value);

  /// Creates a [Style] instance with [TextDirection.rtl] value.
  T rtl() => call(TextDirection.rtl);

  /// Creates a [Style] instance with [TextDirection.ltr] value.
  T ltr() => call(TextDirection.ltr);
}

/// Extension for creating [TextLeadingDistribution] values with predefined options.
extension TextLeadingDistributionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextLeadingDistribution> {
  T call(TextLeadingDistribution value) => builder(value);

  /// Creates a [Style] instance with [TextLeadingDistribution.proportional] value.
  T proportional() => call(TextLeadingDistribution.proportional);

  /// Creates a [Style] instance with [TextLeadingDistribution.even] value.
  T even() => call(TextLeadingDistribution.even);
}

/// Extension for creating [TileMode] values with predefined options.
extension TileModePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TileMode> {
  T call(TileMode value) => builder(value);

  /// Creates a [Style] instance with [TileMode.clamp] value.
  T clamp() => call(TileMode.clamp);

  /// Creates a [Style] instance with [TileMode.repeated] value.
  T repeated() => call(TileMode.repeated);

  /// Creates a [Style] instance with [TileMode.mirror] value.
  T mirror() => call(TileMode.mirror);

  /// Creates a [Style] instance with [TileMode.decal] value.
  T decal() => call(TileMode.decal);
}

/// Extension for creating [MainAxisAlignment] values with predefined options.
extension MainAxisAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, MainAxisAlignment> {
  T call(MainAxisAlignment value) => builder(value);

  /// Creates a [Style] instance with [MainAxisAlignment.start] value.
  T start() => call(MainAxisAlignment.start);

  /// Creates a [Style] instance with [MainAxisAlignment.end] value.
  T end() => call(MainAxisAlignment.end);

  /// Creates a [Style] instance with [MainAxisAlignment.center] value.
  T center() => call(MainAxisAlignment.center);

  /// Creates a [Style] instance with [MainAxisAlignment.spaceBetween] value.
  T spaceBetween() => call(MainAxisAlignment.spaceBetween);

  /// Creates a [Style] instance with [MainAxisAlignment.spaceAround] value.
  T spaceAround() => call(MainAxisAlignment.spaceAround);

  /// Creates a [Style] instance with [MainAxisAlignment.spaceEvenly] value.
  T spaceEvenly() => call(MainAxisAlignment.spaceEvenly);
}

/// Extension for creating [CrossAxisAlignment] values with predefined options.
extension CrossAxisAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, CrossAxisAlignment> {
  T call(CrossAxisAlignment value) => builder(value);

  /// Creates a [Style] instance with [CrossAxisAlignment.start] value.
  T start() => call(CrossAxisAlignment.start);

  /// Creates a [Style] instance with [CrossAxisAlignment.end] value.
  T end() => call(CrossAxisAlignment.end);

  /// Creates a [Style] instance with [CrossAxisAlignment.center] value.
  T center() => call(CrossAxisAlignment.center);

  /// Creates a [Style] instance with [CrossAxisAlignment.stretch] value.
  T stretch() => call(CrossAxisAlignment.stretch);

  /// Creates a [Style] instance with [CrossAxisAlignment.baseline] value.
  T baseline() => call(CrossAxisAlignment.baseline);
}

/// Extension for creating [MainAxisSize] values with predefined options.
extension MainAxisSizePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, MainAxisSize> {
  T call(MainAxisSize value) => builder(value);

  /// Creates a [Style] instance with [MainAxisSize.min] value.
  T min() => call(MainAxisSize.min);

  /// Creates a [Style] instance with [MainAxisSize.max] value.
  T max() => call(MainAxisSize.max);
}

/// Extension for creating [BoxFit] values with predefined options.
extension BoxFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BoxFit> {
  T call(BoxFit value) => builder(value);

  /// Creates a [Style] instance with [BoxFit.fill] value.
  T fill() => call(BoxFit.fill);

  /// Creates a [Style] instance with [BoxFit.contain] value.
  T contain() => call(BoxFit.contain);

  /// Creates a [Style] instance with [BoxFit.cover] value.
  T cover() => call(BoxFit.cover);

  /// Creates a [Style] instance with [BoxFit.fitWidth] value.
  T fitWidth() => call(BoxFit.fitWidth);

  /// Creates a [Style] instance with [BoxFit.fitHeight] value.
  T fitHeight() => call(BoxFit.fitHeight);

  /// Creates a [Style] instance with [BoxFit.none] value.
  T none() => call(BoxFit.none);

  /// Creates a [Style] instance with [BoxFit.scaleDown] value.
  T scaleDown() => call(BoxFit.scaleDown);
}

/// Extension for creating [BlendMode] values with predefined options.
extension BlendModePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BlendMode> {
  T call(BlendMode value) => builder(value);

  /// Creates a [Style] instance with [BlendMode.clear] value.
  T clear() => call(BlendMode.clear);

  /// Creates a [Style] instance with [BlendMode.src] value.
  T src() => call(BlendMode.src);

  /// Creates a [Style] instance with [BlendMode.dst] value.
  T dst() => call(BlendMode.dst);

  /// Creates a [Style] instance with [BlendMode.srcOver] value.
  T srcOver() => call(BlendMode.srcOver);

  /// Creates a [Style] instance with [BlendMode.dstOver] value.
  T dstOver() => call(BlendMode.dstOver);

  /// Creates a [Style] instance with [BlendMode.srcIn] value.
  T srcIn() => call(BlendMode.srcIn);

  /// Creates a [Style] instance with [BlendMode.dstIn] value.
  T dstIn() => call(BlendMode.dstIn);

  /// Creates a [Style] instance with [BlendMode.srcOut] value.
  T srcOut() => call(BlendMode.srcOut);

  /// Creates a [Style] instance with [BlendMode.dstOut] value.
  T dstOut() => call(BlendMode.dstOut);

  /// Creates a [Style] instance with [BlendMode.srcATop] value.
  T srcATop() => call(BlendMode.srcATop);

  /// Creates a [Style] instance with [BlendMode.dstATop] value.
  T dstATop() => call(BlendMode.dstATop);

  /// Creates a [Style] instance with [BlendMode.xor] value.
  T xor() => call(BlendMode.xor);

  /// Creates a [Style] instance with [BlendMode.plus] value.
  T plus() => call(BlendMode.plus);

  /// Creates a [Style] instance with [BlendMode.modulate] value.
  T modulate() => call(BlendMode.modulate);

  /// Creates a [Style] instance with [BlendMode.screen] value.
  T screen() => call(BlendMode.screen);

  /// Creates a [Style] instance with [BlendMode.overlay] value.
  T overlay() => call(BlendMode.overlay);

  /// Creates a [Style] instance with [BlendMode.darken] value.
  T darken() => call(BlendMode.darken);

  /// Creates a [Style] instance with [BlendMode.lighten] value.
  T lighten() => call(BlendMode.lighten);

  /// Creates a [Style] instance with [BlendMode.colorDodge] value.
  T colorDodge() => call(BlendMode.colorDodge);

  /// Creates a [Style] instance with [BlendMode.colorBurn] value.
  T colorBurn() => call(BlendMode.colorBurn);

  /// Creates a [Style] instance with [BlendMode.hardLight] value.
  T hardLight() => call(BlendMode.hardLight);

  /// Creates a [Style] instance with [BlendMode.softLight] value.
  T softLight() => call(BlendMode.softLight);

  /// Creates a [Style] instance with [BlendMode.difference] value.
  T difference() => call(BlendMode.difference);

  /// Creates a [Style] instance with [BlendMode.exclusion] value.
  T exclusion() => call(BlendMode.exclusion);

  /// Creates a [Style] instance with [BlendMode.multiply] value.
  T multiply() => call(BlendMode.multiply);

  /// Creates a [Style] instance with [BlendMode.hue] value.
  T hue() => call(BlendMode.hue);

  /// Creates a [Style] instance with [BlendMode.saturation] value.
  T saturation() => call(BlendMode.saturation);

  /// Creates a [Style] instance with [BlendMode.color] value.
  T color() => call(BlendMode.color);

  /// Creates a [Style] instance with [BlendMode.luminosity] value.
  T luminosity() => call(BlendMode.luminosity);
}

/// Extension for creating [BoxShape] values with predefined options.
extension BoxShapePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BoxShape> {
  T call(BoxShape value) => builder(value);

  /// Creates a [Style] instance with [BoxShape.rectangle] value.
  T rectangle() => call(BoxShape.rectangle);

  /// Creates a [Style] instance with [BoxShape.circle] value.
  T circle() => call(BoxShape.circle);
}

/// Extension for creating [FontStyle] values with predefined options.
extension FontStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FontStyle> {
  T call(FontStyle value) => builder(value);

  /// Creates a [Style] instance with [FontStyle.normal] value.
  T normal() => call(FontStyle.normal);

  /// Creates a [Style] instance with [FontStyle.italic] value.
  T italic() => call(FontStyle.italic);
}

/// Extension for creating [TextDecorationStyle] values with predefined options.
extension TextDecorationStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextDecorationStyle> {
  T call(TextDecorationStyle value) => builder(value);

  /// Creates a [Style] instance with [TextDecorationStyle.solid] value.
  T solid() => call(TextDecorationStyle.solid);

  /// Creates a [Style] instance with [TextDecorationStyle.double] value.
  T double() => call(TextDecorationStyle.double);

  /// Creates a [Style] instance with [TextDecorationStyle.dotted] value.
  T dotted() => call(TextDecorationStyle.dotted);

  /// Creates a [Style] instance with [TextDecorationStyle.dashed] value.
  T dashed() => call(TextDecorationStyle.dashed);

  /// Creates a [Style] instance with [TextDecorationStyle.wavy] value.
  T wavy() => call(TextDecorationStyle.wavy);
}

/// Extension for creating [TextBaseline] values with predefined options.
extension TextBaselinePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextBaseline> {
  T call(TextBaseline value) => builder(value);

  /// Creates a [Style] instance with [TextBaseline.alphabetic] value.
  T alphabetic() => call(TextBaseline.alphabetic);

  /// Creates a [Style] instance with [TextBaseline.ideographic] value.
  T ideographic() => call(TextBaseline.ideographic);
}

/// Extension for creating [TextOverflow] values with predefined options.
extension TextOverflowPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextOverflow> {
  T call(TextOverflow value) => builder(value);

  /// Creates a [Style] instance with [TextOverflow.clip] value.
  T clip() => call(TextOverflow.clip);

  /// Creates a [Style] instance with [TextOverflow.fade] value.
  T fade() => call(TextOverflow.fade);

  /// Creates a [Style] instance with [TextOverflow.ellipsis] value.
  T ellipsis() => call(TextOverflow.ellipsis);

  /// Creates a [Style] instance with [TextOverflow.visible] value.
  T visible() => call(TextOverflow.visible);
}

/// Extension for creating [TextWidthBasis] values with predefined options.
extension TextWidthBasisPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextWidthBasis> {
  T call(TextWidthBasis value) => builder(value);

  /// Creates a [Style] instance with [TextWidthBasis.parent] value.
  T parent() => call(TextWidthBasis.parent);

  /// Creates a [Style] instance with [TextWidthBasis.longestLine] value.
  T longestLine() => call(TextWidthBasis.longestLine);
}

/// Extension for creating [TextAlign] values with predefined options.
extension TextAlignPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextAlign> {
  T call(TextAlign value) => builder(value);

  /// Creates a [Style] instance with [TextAlign.left] value.
  T left() => call(TextAlign.left);

  /// Creates a [Style] instance with [TextAlign.right] value.
  T right() => call(TextAlign.right);

  /// Creates a [Style] instance with [TextAlign.center] value.
  T center() => call(TextAlign.center);

  /// Creates a [Style] instance with [TextAlign.justify] value.
  T justify() => call(TextAlign.justify);

  /// Creates a [Style] instance with [TextAlign.start] value.
  T start() => call(TextAlign.start);

  /// Creates a [Style] instance with [TextAlign.end] value.
  T end() => call(TextAlign.end);
}

/// Extension for creating [FilterQuality] values with predefined options.
extension FilterQualityPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FilterQuality> {
  T call(FilterQuality value) => builder(value);

  /// Creates a [Style] instance with [FilterQuality.none] value.
  T none() => call(FilterQuality.none);

  /// Creates a [Style] instance with [FilterQuality.low] value.
  T low() => call(FilterQuality.low);

  /// Creates a [Style] instance with [FilterQuality.medium] value.
  T medium() => call(FilterQuality.medium);

  /// Creates a [Style] instance with [FilterQuality.high] value.
  T high() => call(FilterQuality.high);
}

/// Extension for creating [WrapAlignment] values with predefined options.
extension WrapAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, WrapAlignment> {
  T call(WrapAlignment value) => builder(value);

  /// Creates a [Style] instance with [WrapAlignment.start] value.
  T start() => call(WrapAlignment.start);

  /// Creates a [Style] instance with [WrapAlignment.end] value.
  T end() => call(WrapAlignment.end);

  /// Creates a [Style] instance with [WrapAlignment.center] value.
  T center() => call(WrapAlignment.center);

  /// Creates a [Style] instance with [WrapAlignment.spaceBetween] value.
  T spaceBetween() => call(WrapAlignment.spaceBetween);

  /// Creates a [Style] instance with [WrapAlignment.spaceAround] value.
  T spaceAround() => call(WrapAlignment.spaceAround);

  /// Creates a [Style] instance with [WrapAlignment.spaceEvenly] value.
  T spaceEvenly() => call(WrapAlignment.spaceEvenly);
}

/// Extension for creating [TableCellVerticalAlignment] values with predefined options.
extension TableCellVerticalAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TableCellVerticalAlignment> {
  T call(TableCellVerticalAlignment value) => builder(value);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.top] value.
  T top() => call(TableCellVerticalAlignment.top);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.middle] value.
  T middle() => call(TableCellVerticalAlignment.middle);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.bottom] value.
  T bottom() => call(TableCellVerticalAlignment.bottom);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.baseline] value.
  T baseline() => call(TableCellVerticalAlignment.baseline);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.fill] value.
  T fill() => call(TableCellVerticalAlignment.fill);

  /// Creates a [Style] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  T intrinsicHeight() => call(TableCellVerticalAlignment.intrinsicHeight);
}
