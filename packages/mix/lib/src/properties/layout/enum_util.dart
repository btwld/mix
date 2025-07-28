// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Extension for creating [VerticalDirection] values with predefined options.
extension VerticalDirectionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, VerticalDirection> {
  /// Creates a style with [VerticalDirection.up] value.
  @Deprecated('Use call(VerticalDirection.up) instead')
  T up() => call(VerticalDirection.up);

  /// Creates a style with [VerticalDirection.down] value.
  @Deprecated('Use call(VerticalDirection.down) instead')
  T down() => call(VerticalDirection.down);
}

/// Extension for creating [BorderStyle] values with predefined options.
extension BorderStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BorderStyle> {
  /// Creates a style with [BorderStyle.none] value.
  @Deprecated('Use call(BorderStyle.none) instead')
  T none() => call(BorderStyle.none);

  /// Creates a style with [BorderStyle.solid] value.
  @Deprecated('Use call(BorderStyle.solid) instead')
  T solid() => call(BorderStyle.solid);
}

/// Extension for creating [Clip] values with predefined options.
extension ClipPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Clip> {
  /// Creates a [StyleAttribute] instance with [Clip.none] value.
  @Deprecated('Use call(Clip.none) instead')
  T none() => call(Clip.none);

  /// Creates a [StyleAttribute] instance with [Clip.hardEdge] value.
  @Deprecated('Use call(Clip.hardEdge) instead')
  T hardEdge() => call(Clip.hardEdge);

  /// Creates a [StyleAttribute] instance with [Clip.antiAlias] value.
  @Deprecated('Use call(Clip.antiAlias) instead')
  T antiAlias() => call(Clip.antiAlias);

  /// Creates a [StyleAttribute] instance with [Clip.antiAliasWithSaveLayer] value.
  @Deprecated('Use call(Clip.antiAliasWithSaveLayer) instead')
  T antiAliasWithSaveLayer() => call(Clip.antiAliasWithSaveLayer);
}

/// Extension for creating [Axis] values with predefined options.
extension AxisPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Axis> {
  /// Creates a [StyleAttribute] instance with [Axis.horizontal] value.
  @Deprecated('Use call(Axis.horizontal) instead')
  T horizontal() => call(Axis.horizontal);

  /// Creates a [StyleAttribute] instance with [Axis.vertical] value.
  @Deprecated('Use call(Axis.vertical) instead')
  T vertical() => call(Axis.vertical);
}

/// Extension for creating [FlexFit] values with predefined options.
extension FlexFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FlexFit> {
  /// Creates a [StyleAttribute] instance with [FlexFit.tight] value.
  @Deprecated('Use call(FlexFit.tight) instead')
  T tight() => call(FlexFit.tight);

  /// Creates a [StyleAttribute] instance with [FlexFit.loose] value.
  @Deprecated('Use call(FlexFit.loose) instead')
  T loose() => call(FlexFit.loose);
}

/// Extension for creating [StackFit] values with predefined options.
extension StackFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, StackFit> {
  /// Creates a [StyleAttribute] instance with [StackFit.loose] value.
  @Deprecated('Use call(StackFit.loose) instead')
  T loose() => call(StackFit.loose);

  /// Creates a [StyleAttribute] instance with [StackFit.expand] value.
  @Deprecated('Use call(StackFit.expand) instead')
  T expand() => call(StackFit.expand);

  /// Creates a [StyleAttribute] instance with [StackFit.passthrough] value.
  @Deprecated('Use call(StackFit.passthrough) instead')
  T passthrough() => call(StackFit.passthrough);
}

/// Extension for creating [ImageRepeat] values with predefined options.
extension ImageRepeatPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, ImageRepeat> {
  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeat] value.
  @Deprecated('Use call(ImageRepeat.repeat) instead')
  T repeat() => call(ImageRepeat.repeat);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeatX] value.
  @Deprecated('Use call(ImageRepeat.repeatX) instead')
  T repeatX() => call(ImageRepeat.repeatX);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.repeatY] value.
  @Deprecated('Use call(ImageRepeat.repeatY) instead')
  T repeatY() => call(ImageRepeat.repeatY);

  /// Creates a [StyleAttribute] instance with [ImageRepeat.noRepeat] value.
  @Deprecated('Use call(ImageRepeat.noRepeat) instead')
  T noRepeat() => call(ImageRepeat.noRepeat);
}

/// Extension for creating [TextDirection] values with predefined options.
extension TextDirectionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextDirection> {
  /// Creates a [StyleAttribute] instance with [TextDirection.rtl] value.
  @Deprecated('Use call(TextDirection.rtl) instead')
  T rtl() => call(TextDirection.rtl);

  /// Creates a [StyleAttribute] instance with [TextDirection.ltr] value.
  @Deprecated('Use call(TextDirection.ltr) instead')
  T ltr() => call(TextDirection.ltr);
}

/// Extension for creating [TextLeadingDistribution] values with predefined options.
extension TextLeadingDistributionPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextLeadingDistribution> {
  /// Creates a [StyleAttribute] instance with [TextLeadingDistribution.proportional] value.
  @Deprecated('Use call(TextLeadingDistribution.proportional) instead')
  T proportional() => call(TextLeadingDistribution.proportional);

  /// Creates a [StyleAttribute] instance with [TextLeadingDistribution.even] value.
  @Deprecated('Use call(TextLeadingDistribution.even) instead')
  T even() => call(TextLeadingDistribution.even);
}

/// Extension for creating [TileMode] values with predefined options.
extension TileModePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TileMode> {
  /// Creates a [StyleAttribute] instance with [TileMode.clamp] value.
  @Deprecated('Use call(TileMode.clamp) instead')
  T clamp() => call(TileMode.clamp);

  /// Creates a [StyleAttribute] instance with [TileMode.repeated] value.
  @Deprecated('Use call(TileMode.repeated) instead')
  T repeated() => call(TileMode.repeated);

  /// Creates a [StyleAttribute] instance with [TileMode.mirror] value.
  @Deprecated('Use call(TileMode.mirror) instead')
  T mirror() => call(TileMode.mirror);

  /// Creates a [StyleAttribute] instance with [TileMode.decal] value.
  @Deprecated('Use call(TileMode.decal) instead')
  T decal() => call(TileMode.decal);
}

/// Extension for creating [MainAxisAlignment] values with predefined options.
extension MainAxisAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, MainAxisAlignment> {
  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.start] value.
  @Deprecated('Use call(MainAxisAlignment.start) instead')
  T start() => call(MainAxisAlignment.start);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.end] value.
  @Deprecated('Use call(MainAxisAlignment.end) instead')
  T end() => call(MainAxisAlignment.end);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.center] value.
  @Deprecated('Use call(MainAxisAlignment.center) instead')
  T center() => call(MainAxisAlignment.center);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceBetween] value.
  @Deprecated('Use call(MainAxisAlignment.spaceBetween) instead')
  T spaceBetween() => call(MainAxisAlignment.spaceBetween);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceAround] value.
  @Deprecated('Use call(MainAxisAlignment.spaceAround) instead')
  T spaceAround() => call(MainAxisAlignment.spaceAround);

  /// Creates a [StyleAttribute] instance with [MainAxisAlignment.spaceEvenly] value.
  @Deprecated('Use call(MainAxisAlignment.spaceEvenly) instead')
  T spaceEvenly() => call(MainAxisAlignment.spaceEvenly);
}

/// Extension for creating [CrossAxisAlignment] values with predefined options.
extension CrossAxisAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, CrossAxisAlignment> {
  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.start] value.
  @Deprecated('Use call(CrossAxisAlignment.start) instead')
  T start() => call(CrossAxisAlignment.start);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.end] value.
  @Deprecated('Use call(CrossAxisAlignment.end) instead')
  T end() => call(CrossAxisAlignment.end);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.center] value.
  @Deprecated('Use call(CrossAxisAlignment.center) instead')
  T center() => call(CrossAxisAlignment.center);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.stretch] value.
  @Deprecated('Use call(CrossAxisAlignment.stretch) instead')
  T stretch() => call(CrossAxisAlignment.stretch);

  /// Creates a [StyleAttribute] instance with [CrossAxisAlignment.baseline] value.
  @Deprecated('Use call(CrossAxisAlignment.baseline) instead')
  T baseline() => call(CrossAxisAlignment.baseline);
}

/// Extension for creating [MainAxisSize] values with predefined options.
extension MainAxisSizePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, MainAxisSize> {
  /// Creates a [StyleAttribute] instance with [MainAxisSize.min] value.
  @Deprecated('Use call(MainAxisSize.min) instead')
  T min() => call(MainAxisSize.min);

  /// Creates a [StyleAttribute] instance with [MainAxisSize.max] value.
  @Deprecated('Use call(MainAxisSize.max) instead')
  T max() => call(MainAxisSize.max);
}

/// Extension for creating [BoxFit] values with predefined options.
extension BoxFitPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BoxFit> {
  /// Creates a [StyleAttribute] instance with [BoxFit.fill] value.
  @Deprecated('Use call(BoxFit.fill) instead')
  T fill() => call(BoxFit.fill);

  /// Creates a [StyleAttribute] instance with [BoxFit.contain] value.
  @Deprecated('Use call(BoxFit.contain) instead')
  T contain() => call(BoxFit.contain);

  /// Creates a [StyleAttribute] instance with [BoxFit.cover] value.
  @Deprecated('Use call(BoxFit.cover) instead')
  T cover() => call(BoxFit.cover);

  /// Creates a [StyleAttribute] instance with [BoxFit.fitWidth] value.
  @Deprecated('Use call(BoxFit.fitWidth) instead')
  T fitWidth() => call(BoxFit.fitWidth);

  /// Creates a [StyleAttribute] instance with [BoxFit.fitHeight] value.
  @Deprecated('Use call(BoxFit.fitHeight) instead')
  T fitHeight() => call(BoxFit.fitHeight);

  /// Creates a [StyleAttribute] instance with [BoxFit.none] value.
  @Deprecated('Use call(BoxFit.none) instead')
  T none() => call(BoxFit.none);

  /// Creates a [StyleAttribute] instance with [BoxFit.scaleDown] value.
  @Deprecated('Use call(BoxFit.scaleDown) instead')
  T scaleDown() => call(BoxFit.scaleDown);
}

/// Extension for creating [BlendMode] values with predefined options.
extension BlendModePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BlendMode> {
  /// Creates a [StyleAttribute] instance with [BlendMode.clear] value.
  @Deprecated('Use call(BlendMode.clear) instead')
  T clear() => call(BlendMode.clear);

  /// Creates a [StyleAttribute] instance with [BlendMode.src] value.
  @Deprecated('Use call(BlendMode.src) instead')
  T src() => call(BlendMode.src);

  /// Creates a [StyleAttribute] instance with [BlendMode.dst] value.
  @Deprecated('Use call(BlendMode.dst) instead')
  T dst() => call(BlendMode.dst);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcOver] value.
  @Deprecated('Use call(BlendMode.srcOver) instead')
  T srcOver() => call(BlendMode.srcOver);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstOver] value.
  @Deprecated('Use call(BlendMode.dstOver) instead')
  T dstOver() => call(BlendMode.dstOver);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcIn] value.
  @Deprecated('Use call(BlendMode.srcIn) instead')
  T srcIn() => call(BlendMode.srcIn);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstIn] value.
  @Deprecated('Use call(BlendMode.dstIn) instead')
  T dstIn() => call(BlendMode.dstIn);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcOut] value.
  @Deprecated('Use call(BlendMode.srcOut) instead')
  T srcOut() => call(BlendMode.srcOut);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstOut] value.
  @Deprecated('Use call(BlendMode.dstOut) instead')
  T dstOut() => call(BlendMode.dstOut);

  /// Creates a [StyleAttribute] instance with [BlendMode.srcATop] value.
  @Deprecated('Use call(BlendMode.srcATop) instead')
  T srcATop() => call(BlendMode.srcATop);

  /// Creates a [StyleAttribute] instance with [BlendMode.dstATop] value.
  @Deprecated('Use call(BlendMode.dstATop) instead')
  T dstATop() => call(BlendMode.dstATop);

  /// Creates a [StyleAttribute] instance with [BlendMode.xor] value.
  @Deprecated('Use call(BlendMode.xor) instead')
  T xor() => call(BlendMode.xor);

  /// Creates a [StyleAttribute] instance with [BlendMode.plus] value.
  @Deprecated('Use call(BlendMode.plus) instead')
  T plus() => call(BlendMode.plus);

  /// Creates a [StyleAttribute] instance with [BlendMode.modulate] value.
  @Deprecated('Use call(BlendMode.modulate) instead')
  T modulate() => call(BlendMode.modulate);

  /// Creates a [StyleAttribute] instance with [BlendMode.screen] value.
  @Deprecated('Use call(BlendMode.screen) instead')
  T screen() => call(BlendMode.screen);

  /// Creates a [StyleAttribute] instance with [BlendMode.overlay] value.
  @Deprecated('Use call(BlendMode.overlay) instead')
  T overlay() => call(BlendMode.overlay);

  /// Creates a [StyleAttribute] instance with [BlendMode.darken] value.
  @Deprecated('Use call(BlendMode.darken) instead')
  T darken() => call(BlendMode.darken);

  /// Creates a [StyleAttribute] instance with [BlendMode.lighten] value.
  @Deprecated('Use call(BlendMode.lighten) instead')
  T lighten() => call(BlendMode.lighten);

  /// Creates a [StyleAttribute] instance with [BlendMode.colorDodge] value.
  @Deprecated('Use call(BlendMode.colorDodge) instead')
  T colorDodge() => call(BlendMode.colorDodge);

  /// Creates a [StyleAttribute] instance with [BlendMode.colorBurn] value.
  @Deprecated('Use call(BlendMode.colorBurn) instead')
  T colorBurn() => call(BlendMode.colorBurn);

  /// Creates a [StyleAttribute] instance with [BlendMode.hardLight] value.
  @Deprecated('Use call(BlendMode.hardLight) instead')
  T hardLight() => call(BlendMode.hardLight);

  /// Creates a [StyleAttribute] instance with [BlendMode.softLight] value.
  @Deprecated('Use call(BlendMode.softLight) instead')
  T softLight() => call(BlendMode.softLight);

  /// Creates a [StyleAttribute] instance with [BlendMode.difference] value.
  @Deprecated('Use call(BlendMode.difference) instead')
  T difference() => call(BlendMode.difference);

  /// Creates a [StyleAttribute] instance with [BlendMode.exclusion] value.
  @Deprecated('Use call(BlendMode.exclusion) instead')
  T exclusion() => call(BlendMode.exclusion);

  /// Creates a [StyleAttribute] instance with [BlendMode.multiply] value.
  @Deprecated('Use call(BlendMode.multiply) instead')
  T multiply() => call(BlendMode.multiply);

  /// Creates a [StyleAttribute] instance with [BlendMode.hue] value.
  @Deprecated('Use call(BlendMode.hue) instead')
  T hue() => call(BlendMode.hue);

  /// Creates a [StyleAttribute] instance with [BlendMode.saturation] value.
  @Deprecated('Use call(BlendMode.saturation) instead')
  T saturation() => call(BlendMode.saturation);

  /// Creates a [StyleAttribute] instance with [BlendMode.color] value.
  @Deprecated('Use call(BlendMode.color) instead')
  T color() => call(BlendMode.color);

  /// Creates a [StyleAttribute] instance with [BlendMode.luminosity] value.
  @Deprecated('Use call(BlendMode.luminosity) instead')
  T luminosity() => call(BlendMode.luminosity);
}

/// Extension for creating [BoxShape] values with predefined options.
extension BoxShapePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, BoxShape> {
  /// Creates a [StyleAttribute] instance with [BoxShape.rectangle] value.
  @Deprecated('Use call(BoxShape.rectangle) instead')
  T rectangle() => call(BoxShape.rectangle);

  /// Creates a [StyleAttribute] instance with [BoxShape.circle] value.
  @Deprecated('Use call(BoxShape.circle) instead')
  T circle() => call(BoxShape.circle);
}

/// Extension for creating [FontStyle] values with predefined options.
extension FontStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FontStyle> {
  /// Creates a [StyleAttribute] instance with [FontStyle.normal] value.
  @Deprecated('Use call(FontStyle.normal) instead')
  T normal() => call(FontStyle.normal);

  /// Creates a [StyleAttribute] instance with [FontStyle.italic] value.
  @Deprecated('Use call(FontStyle.italic) instead')
  T italic() => call(FontStyle.italic);
}

/// Extension for creating [TextDecorationStyle] values with predefined options.
extension TextDecorationStylePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextDecorationStyle> {
  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.solid] value.
  @Deprecated('Use call(TextDecorationStyle.solid) instead')
  T solid() => call(TextDecorationStyle.solid);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.double] value.
  @Deprecated('Use call(TextDecorationStyle.double) instead')
  T double() => call(TextDecorationStyle.double);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.dotted] value.
  @Deprecated('Use call(TextDecorationStyle.dotted) instead')
  T dotted() => call(TextDecorationStyle.dotted);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.dashed] value.
  @Deprecated('Use call(TextDecorationStyle.dashed) instead')
  T dashed() => call(TextDecorationStyle.dashed);

  /// Creates a [StyleAttribute] instance with [TextDecorationStyle.wavy] value.
  @Deprecated('Use call(TextDecorationStyle.wavy) instead')
  T wavy() => call(TextDecorationStyle.wavy);
}

/// Extension for creating [TextBaseline] values with predefined options.
extension TextBaselinePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextBaseline> {
  /// Creates a [StyleAttribute] instance with [TextBaseline.alphabetic] value.
  @Deprecated('Use call(TextBaseline.alphabetic) instead')
  T alphabetic() => call(TextBaseline.alphabetic);

  /// Creates a [StyleAttribute] instance with [TextBaseline.ideographic] value.
  @Deprecated('Use call(TextBaseline.ideographic) instead')
  T ideographic() => call(TextBaseline.ideographic);
}

/// Extension for creating [TextOverflow] values with predefined options.
extension TextOverflowPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextOverflow> {
  /// Creates a [StyleAttribute] instance with [TextOverflow.clip] value.
  @Deprecated('Use call(TextOverflow.clip) instead')
  T clip() => call(TextOverflow.clip);

  /// Creates a [StyleAttribute] instance with [TextOverflow.fade] value.
  @Deprecated('Use call(TextOverflow.fade) instead')
  T fade() => call(TextOverflow.fade);

  /// Creates a [StyleAttribute] instance with [TextOverflow.ellipsis] value.
  @Deprecated('Use call(TextOverflow.ellipsis) instead')
  T ellipsis() => call(TextOverflow.ellipsis);

  /// Creates a [StyleAttribute] instance with [TextOverflow.visible] value.
  @Deprecated('Use call(TextOverflow.visible) instead')
  T visible() => call(TextOverflow.visible);
}

/// Extension for creating [TextWidthBasis] values with predefined options.
extension TextWidthBasisPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextWidthBasis> {
  /// Creates a [StyleAttribute] instance with [TextWidthBasis.parent] value.
  @Deprecated('Use call(TextWidthBasis.parent) instead')
  T parent() => call(TextWidthBasis.parent);

  /// Creates a [StyleAttribute] instance with [TextWidthBasis.longestLine] value.
  @Deprecated('Use call(TextWidthBasis.longestLine) instead')
  T longestLine() => call(TextWidthBasis.longestLine);
}

/// Extension for creating [TextAlign] values with predefined options.
extension TextAlignPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextAlign> {
  /// Creates a [StyleAttribute] instance with [TextAlign.left] value.
  @Deprecated('Use call(TextAlign.left) instead')
  T left() => call(TextAlign.left);

  /// Creates a [StyleAttribute] instance with [TextAlign.right] value.
  @Deprecated('Use call(TextAlign.right) instead')
  T right() => call(TextAlign.right);

  /// Creates a [StyleAttribute] instance with [TextAlign.center] value.
  @Deprecated('Use call(TextAlign.center) instead')
  T center() => call(TextAlign.center);

  /// Creates a [StyleAttribute] instance with [TextAlign.justify] value.
  @Deprecated('Use call(TextAlign.justify) instead')
  T justify() => call(TextAlign.justify);

  /// Creates a [StyleAttribute] instance with [TextAlign.start] value.
  @Deprecated('Use call(TextAlign.start) instead')
  T start() => call(TextAlign.start);

  /// Creates a [StyleAttribute] instance with [TextAlign.end] value.
  @Deprecated('Use call(TextAlign.end) instead')
  T end() => call(TextAlign.end);
}

/// Extension for creating [FilterQuality] values with predefined options.
extension FilterQualityPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FilterQuality> {
  /// Creates a [StyleAttribute] instance with [FilterQuality.none] value.
  @Deprecated('Use call(FilterQuality.none) instead')
  T none() => call(FilterQuality.none);

  /// Creates a [StyleAttribute] instance with [FilterQuality.low] value.
  @Deprecated('Use call(FilterQuality.low) instead')
  T low() => call(FilterQuality.low);

  /// Creates a [StyleAttribute] instance with [FilterQuality.medium] value.
  @Deprecated('Use call(FilterQuality.medium) instead')
  T medium() => call(FilterQuality.medium);

  /// Creates a [StyleAttribute] instance with [FilterQuality.high] value.
  @Deprecated('Use call(FilterQuality.high) instead')
  T high() => call(FilterQuality.high);
}

/// Extension for creating [WrapAlignment] values with predefined options.
extension WrapAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, WrapAlignment> {
  /// Creates a [StyleAttribute] instance with [WrapAlignment.start] value.
  @Deprecated('Use call(WrapAlignment.start) instead')
  T start() => call(WrapAlignment.start);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.end] value.
  @Deprecated('Use call(WrapAlignment.end) instead')
  T end() => call(WrapAlignment.end);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.center] value.
  @Deprecated('Use call(WrapAlignment.center) instead')
  T center() => call(WrapAlignment.center);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceBetween] value.
  @Deprecated('Use call(WrapAlignment.spaceBetween) instead')
  T spaceBetween() => call(WrapAlignment.spaceBetween);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceAround] value.
  @Deprecated('Use call(WrapAlignment.spaceAround) instead')
  T spaceAround() => call(WrapAlignment.spaceAround);

  /// Creates a [StyleAttribute] instance with [WrapAlignment.spaceEvenly] value.
  @Deprecated('Use call(WrapAlignment.spaceEvenly) instead')
  T spaceEvenly() => call(WrapAlignment.spaceEvenly);
}

/// Extension for creating [TableCellVerticalAlignment] values with predefined options.
extension TableCellVerticalAlignmentPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TableCellVerticalAlignment> {
  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.top] value.
  @Deprecated('Use call(TableCellVerticalAlignment.top) instead')
  T top() => call(TableCellVerticalAlignment.top);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.middle] value.
  @Deprecated('Use call(TableCellVerticalAlignment.middle) instead')
  T middle() => call(TableCellVerticalAlignment.middle);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.bottom] value.
  @Deprecated('Use call(TableCellVerticalAlignment.bottom) instead')
  T bottom() => call(TableCellVerticalAlignment.bottom);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.baseline] value.
  @Deprecated('Use call(TableCellVerticalAlignment.baseline) instead')
  T baseline() => call(TableCellVerticalAlignment.baseline);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.fill] value.
  @Deprecated('Use call(TableCellVerticalAlignment.fill) instead')
  T fill() => call(TableCellVerticalAlignment.fill);

  /// Creates a [StyleAttribute] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  @Deprecated('Use call(TableCellVerticalAlignment.intrinsicHeight) instead')
  T intrinsicHeight() => call(TableCellVerticalAlignment.intrinsicHeight);
}