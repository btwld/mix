// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';

/// Extension for creating [VerticalDirection] values with predefined options.
extension VerticalDirectionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, VerticalDirection> {
  T call(VerticalDirection value) => utilityBuilder(value);

  @Deprecated('Use call(VerticalDirection.up) instead')
  /// Creates a style with [VerticalDirection.up] value.
  T up() => call(.up);

  @Deprecated('Use call(VerticalDirection.down) instead')
  /// Creates a style with [VerticalDirection.down] value.
  T down() => call(.down);
}

/// Extension for creating [BorderStyle] values with predefined options.
extension BorderStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BorderStyle> {
  T call(BorderStyle value) => utilityBuilder(value);

  @Deprecated('Use call(BorderStyle.none) instead')
  /// Creates a style with [BorderStyle.none] value.
  T none() => call(.none);

  @Deprecated('Use call(BorderStyle.solid) instead')
  /// Creates a style with [BorderStyle.solid] value.
  T solid() => call(.solid);
}

/// Extension for creating [Clip] values with predefined options.
extension ClipPropUtilityExt<T extends Style<Object?>> on MixUtility<T, Clip> {
  T call(Clip value) => utilityBuilder(value);

  @Deprecated('Use call(Clip.none) instead')
  /// Creates a [Style] instance with [Clip.none] value.
  T none() => call(.none);

  @Deprecated('Use call(Clip.hardEdge) instead')
  /// Creates a [Style] instance with [Clip.hardEdge] value.
  T hardEdge() => call(.hardEdge);

  @Deprecated('Use call(Clip.antiAlias) instead')
  /// Creates a [Style] instance with [Clip.antiAlias] value.
  T antiAlias() => call(.antiAlias);

  @Deprecated('Use call(Clip.antiAliasWithSaveLayer) instead')
  /// Creates a [Style] instance with [Clip.antiAliasWithSaveLayer] value.
  T antiAliasWithSaveLayer() => call(.antiAliasWithSaveLayer);
}

/// Extension for creating [Axis] values with predefined options.
extension AxisPropUtilityExt<T extends Style<Object?>> on MixUtility<T, Axis> {
  T call(Axis value) => utilityBuilder(value);

  @Deprecated('Use call(Axis.horizontal) instead')
  /// Creates a [Style] instance with [Axis.horizontal] value.
  T horizontal() => call(.horizontal);

  @Deprecated('Use call(Axis.vertical) instead')
  /// Creates a [Style] instance with [Axis.vertical] value.
  T vertical() => call(.vertical);
}

/// Extension for creating [FlexFit] values with predefined options.
extension FlexFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FlexFit> {
  T call(FlexFit value) => utilityBuilder(value);

  @Deprecated('Use call(FlexFit.tight) instead')
  /// Creates a [Style] instance with [FlexFit.tight] value.
  T tight() => call(.tight);

  @Deprecated('Use call(FlexFit.loose) instead')
  /// Creates a [Style] instance with [FlexFit.loose] value.
  T loose() => call(.loose);
}

/// Extension for creating [StackFit] values with predefined options.
extension StackFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, StackFit> {
  T call(StackFit value) => utilityBuilder(value);

  @Deprecated('Use call(StackFit.loose) instead')
  /// Creates a [Style] instance with [StackFit.loose] value.
  T loose() => call(.loose);

  @Deprecated('Use call(StackFit.expand) instead')
  /// Creates a [Style] instance with [StackFit.expand] value.
  T expand() => call(.expand);

  @Deprecated('Use call(StackFit.passthrough) instead')
  /// Creates a [Style] instance with [StackFit.passthrough] value.
  T passthrough() => call(.passthrough);
}

/// Extension for creating [ImageRepeat] values with predefined options.
extension ImageRepeatPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, ImageRepeat> {
  T call(ImageRepeat value) => utilityBuilder(value);

  @Deprecated('Use call(ImageRepeat.repeat) instead')
  /// Creates a [Style] instance with [ImageRepeat.repeat] value.
  T repeat() => call(.repeat);

  @Deprecated('Use call(ImageRepeat.repeatX) instead')
  /// Creates a [Style] instance with [ImageRepeat.repeatX] value.
  T repeatX() => call(.repeatX);

  @Deprecated('Use call(ImageRepeat.repeatY) instead')
  /// Creates a [Style] instance with [ImageRepeat.repeatY] value.
  T repeatY() => call(.repeatY);

  @Deprecated('Use call(ImageRepeat.noRepeat) instead')
  /// Creates a [Style] instance with [ImageRepeat.noRepeat] value.
  T noRepeat() => call(.noRepeat);
}

/// Extension for creating [TextDirection] values with predefined options.
extension TextDirectionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextDirection> {
  T call(TextDirection value) => utilityBuilder(value);

  @Deprecated('Use call(TextDirection.rtl) instead')
  /// Creates a [Style] instance with [TextDirection.rtl] value.
  T rtl() => call(.rtl);

  @Deprecated('Use call(TextDirection.ltr) instead')
  /// Creates a [Style] instance with [TextDirection.ltr] value.
  T ltr() => call(.ltr);
}

/// Extension for creating [TextLeadingDistribution] values with predefined options.
extension TextLeadingDistributionPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextLeadingDistribution> {
  T call(TextLeadingDistribution value) => utilityBuilder(value);

  @Deprecated('Use call(TextLeadingDistribution.proportional) instead')
  /// Creates a [Style] instance with [TextLeadingDistribution.proportional] value.
  T proportional() => call(.proportional);

  @Deprecated('Use call(TextLeadingDistribution.even) instead')
  /// Creates a [Style] instance with [TextLeadingDistribution.even] value.
  T even() => call(.even);
}

/// Extension for creating [TileMode] values with predefined options.
extension TileModePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TileMode> {
  T call(TileMode value) => utilityBuilder(value);

  @Deprecated('Use call(TileMode.clamp) instead')
  /// Creates a [Style] instance with [TileMode.clamp] value.
  T clamp() => call(.clamp);

  @Deprecated('Use call(TileMode.repeated) instead')
  /// Creates a [Style] instance with [TileMode.repeated] value.
  T repeated() => call(.repeated);

  @Deprecated('Use call(TileMode.mirror) instead')
  /// Creates a [Style] instance with [TileMode.mirror] value.
  T mirror() => call(.mirror);

  @Deprecated('Use call(TileMode.decal) instead')
  /// Creates a [Style] instance with [TileMode.decal] value.
  T decal() => call(.decal);
}

/// Extension for creating [MainAxisAlignment] values with predefined options.
extension MainAxisAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, MainAxisAlignment> {
  T call(MainAxisAlignment value) => utilityBuilder(value);

  @Deprecated('Use call(MainAxisAlignment.start) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.start] value.
  T start() => call(.start);

  @Deprecated('Use call(MainAxisAlignment.end) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.end] value.
  T end() => call(.end);

  @Deprecated('Use call(MainAxisAlignment.center) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.center] value.
  T center() => call(.center);

  @Deprecated('Use call(MainAxisAlignment.spaceBetween) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.spaceBetween] value.
  T spaceBetween() => call(.spaceBetween);

  @Deprecated('Use call(MainAxisAlignment.spaceAround) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.spaceAround] value.
  T spaceAround() => call(.spaceAround);

  @Deprecated('Use call(MainAxisAlignment.spaceEvenly) instead')
  /// Creates a [Style] instance with [MainAxisAlignment.spaceEvenly] value.
  T spaceEvenly() => call(.spaceEvenly);
}

/// Extension for creating [CrossAxisAlignment] values with predefined options.
extension CrossAxisAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, CrossAxisAlignment> {
  T call(CrossAxisAlignment value) => utilityBuilder(value);

  @Deprecated('Use call(CrossAxisAlignment.start) instead')
  /// Creates a [Style] instance with [CrossAxisAlignment.start] value.
  T start() => call(.start);

  @Deprecated('Use call(CrossAxisAlignment.end) instead')
  /// Creates a [Style] instance with [CrossAxisAlignment.end] value.
  T end() => call(.end);

  @Deprecated('Use call(CrossAxisAlignment.center) instead')
  /// Creates a [Style] instance with [CrossAxisAlignment.center] value.
  T center() => call(.center);

  @Deprecated('Use call(CrossAxisAlignment.stretch) instead')
  /// Creates a [Style] instance with [CrossAxisAlignment.stretch] value.
  T stretch() => call(.stretch);

  @Deprecated('Use call(CrossAxisAlignment.baseline) instead')
  /// Creates a [Style] instance with [CrossAxisAlignment.baseline] value.
  T baseline() => call(.baseline);
}

/// Extension for creating [MainAxisSize] values with predefined options.
extension MainAxisSizePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, MainAxisSize> {
  T call(MainAxisSize value) => utilityBuilder(value);

  @Deprecated('Use call(MainAxisSize.min) instead')
  /// Creates a [Style] instance with [MainAxisSize.min] value.
  T min() => call(.min);

  @Deprecated('Use call(MainAxisSize.max) instead')
  /// Creates a [Style] instance with [MainAxisSize.max] value.
  T max() => call(.max);
}

/// Extension for creating [BoxFit] values with predefined options.
extension BoxFitPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BoxFit> {
  T call(BoxFit value) => utilityBuilder(value);

  @Deprecated('Use call(BoxFit.fill) instead')
  /// Creates a [Style] instance with [BoxFit.fill] value.
  T fill() => call(.fill);

  @Deprecated('Use call(BoxFit.contain) instead')
  /// Creates a [Style] instance with [BoxFit.contain] value.
  T contain() => call(.contain);

  @Deprecated('Use call(BoxFit.cover) instead')
  /// Creates a [Style] instance with [BoxFit.cover] value.
  T cover() => call(.cover);

  @Deprecated('Use call(BoxFit.fitWidth) instead')
  /// Creates a [Style] instance with [BoxFit.fitWidth] value.
  T fitWidth() => call(.fitWidth);

  @Deprecated('Use call(BoxFit.fitHeight) instead')
  /// Creates a [Style] instance with [BoxFit.fitHeight] value.
  T fitHeight() => call(.fitHeight);

  @Deprecated('Use call(BoxFit.none) instead')
  /// Creates a [Style] instance with [BoxFit.none] value.
  T none() => call(.none);

  @Deprecated('Use call(BoxFit.scaleDown) instead')
  /// Creates a [Style] instance with [BoxFit.scaleDown] value.
  T scaleDown() => call(.scaleDown);
}

/// Extension for creating [BlendMode] values with predefined options.
extension BlendModePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BlendMode> {
  T call(BlendMode value) => utilityBuilder(value);

  @Deprecated('Use call(BlendMode.clear) instead')
  /// Creates a [Style] instance with [BlendMode.clear] value.
  T clear() => call(.clear);

  @Deprecated('Use call(BlendMode.src) instead')
  /// Creates a [Style] instance with [BlendMode.src] value.
  T src() => call(.src);

  @Deprecated('Use call(BlendMode.dst) instead')
  /// Creates a [Style] instance with [BlendMode.dst] value.
  T dst() => call(.dst);

  @Deprecated('Use call(BlendMode.srcOver) instead')
  /// Creates a [Style] instance with [BlendMode.srcOver] value.
  T srcOver() => call(.srcOver);

  @Deprecated('Use call(BlendMode.dstOver) instead')
  /// Creates a [Style] instance with [BlendMode.dstOver] value.
  T dstOver() => call(.dstOver);

  @Deprecated('Use call(BlendMode.srcIn) instead')
  /// Creates a [Style] instance with [BlendMode.srcIn] value.
  T srcIn() => call(.srcIn);

  @Deprecated('Use call(BlendMode.dstIn) instead')
  /// Creates a [Style] instance with [BlendMode.dstIn] value.
  T dstIn() => call(.dstIn);

  @Deprecated('Use call(BlendMode.srcOut) instead')
  /// Creates a [Style] instance with [BlendMode.srcOut] value.
  T srcOut() => call(.srcOut);

  @Deprecated('Use call(BlendMode.dstOut) instead')
  /// Creates a [Style] instance with [BlendMode.dstOut] value.
  T dstOut() => call(.dstOut);

  @Deprecated('Use call(BlendMode.srcATop) instead')
  /// Creates a [Style] instance with [BlendMode.srcATop] value.
  T srcATop() => call(.srcATop);

  @Deprecated('Use call(BlendMode.dstATop) instead')
  /// Creates a [Style] instance with [BlendMode.dstATop] value.
  T dstATop() => call(.dstATop);

  @Deprecated('Use call(BlendMode.xor) instead')
  /// Creates a [Style] instance with [BlendMode.xor] value.
  T xor() => call(.xor);

  @Deprecated('Use call(BlendMode.plus) instead')
  /// Creates a [Style] instance with [BlendMode.plus] value.
  T plus() => call(.plus);

  @Deprecated('Use call(BlendMode.modulate) instead')
  /// Creates a [Style] instance with [BlendMode.modulate] value.
  T modulate() => call(.modulate);

  @Deprecated('Use call(BlendMode.screen) instead')
  /// Creates a [Style] instance with [BlendMode.screen] value.
  T screen() => call(.screen);

  @Deprecated('Use call(BlendMode.overlay) instead')
  /// Creates a [Style] instance with [BlendMode.overlay] value.
  T overlay() => call(.overlay);

  @Deprecated('Use call(BlendMode.darken) instead')
  /// Creates a [Style] instance with [BlendMode.darken] value.
  T darken() => call(.darken);

  @Deprecated('Use call(BlendMode.lighten) instead')
  /// Creates a [Style] instance with [BlendMode.lighten] value.
  T lighten() => call(.lighten);

  @Deprecated('Use call(BlendMode.colorDodge) instead')
  /// Creates a [Style] instance with [BlendMode.colorDodge] value.
  T colorDodge() => call(.colorDodge);

  @Deprecated('Use call(BlendMode.colorBurn) instead')
  /// Creates a [Style] instance with [BlendMode.colorBurn] value.
  T colorBurn() => call(.colorBurn);

  @Deprecated('Use call(BlendMode.hardLight) instead')
  /// Creates a [Style] instance with [BlendMode.hardLight] value.
  T hardLight() => call(.hardLight);

  @Deprecated('Use call(BlendMode.softLight) instead')
  /// Creates a [Style] instance with [BlendMode.softLight] value.
  T softLight() => call(.softLight);

  @Deprecated('Use call(BlendMode.difference) instead')
  /// Creates a [Style] instance with [BlendMode.difference] value.
  T difference() => call(.difference);

  @Deprecated('Use call(BlendMode.exclusion) instead')
  /// Creates a [Style] instance with [BlendMode.exclusion] value.
  T exclusion() => call(.exclusion);

  @Deprecated('Use call(BlendMode.multiply) instead')
  /// Creates a [Style] instance with [BlendMode.multiply] value.
  T multiply() => call(.multiply);

  @Deprecated('Use call(BlendMode.hue) instead')
  /// Creates a [Style] instance with [BlendMode.hue] value.
  T hue() => call(.hue);

  @Deprecated('Use call(BlendMode.saturation) instead')
  /// Creates a [Style] instance with [BlendMode.saturation] value.
  T saturation() => call(.saturation);

  @Deprecated('Use call(BlendMode.color) instead')
  /// Creates a [Style] instance with [BlendMode.color] value.
  T color() => call(.color);

  @Deprecated('Use call(BlendMode.luminosity) instead')
  /// Creates a [Style] instance with [BlendMode.luminosity] value.
  T luminosity() => call(.luminosity);
}

/// Extension for creating [BoxShape] values with predefined options.
extension BoxShapePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, BoxShape> {
  T call(BoxShape value) => utilityBuilder(value);

  @Deprecated('Use call(BoxShape.rectangle) instead')
  /// Creates a [Style] instance with [BoxShape.rectangle] value.
  T rectangle() => call(.rectangle);

  @Deprecated('Use call(BoxShape.circle) instead')
  /// Creates a [Style] instance with [BoxShape.circle] value.
  T circle() => call(.circle);
}

/// Extension for creating [FontStyle] values with predefined options.
extension FontStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FontStyle> {
  T call(FontStyle value) => utilityBuilder(value);

  @Deprecated('Use call(FontStyle.normal) instead')
  /// Creates a [Style] instance with [FontStyle.normal] value.
  T normal() => call(.normal);

  @Deprecated('Use call(FontStyle.italic) instead')
  /// Creates a [Style] instance with [FontStyle.italic] value.
  T italic() => call(.italic);
}

/// Extension for creating [TextDecorationStyle] values with predefined options.
extension TextDecorationStylePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextDecorationStyle> {
  T call(TextDecorationStyle value) => utilityBuilder(value);

  @Deprecated('Use call(TextDecorationStyle.solid) instead')
  /// Creates a [Style] instance with [TextDecorationStyle.solid] value.
  T solid() => call(.solid);

  @Deprecated('Use call(TextDecorationStyle.double) instead')
  /// Creates a [Style] instance with [TextDecorationStyle.double] value.
  T double() => call(.double);

  @Deprecated('Use call(TextDecorationStyle.dotted) instead')
  /// Creates a [Style] instance with [TextDecorationStyle.dotted] value.
  T dotted() => call(.dotted);

  @Deprecated('Use call(TextDecorationStyle.dashed) instead')
  /// Creates a [Style] instance with [TextDecorationStyle.dashed] value.
  T dashed() => call(.dashed);

  @Deprecated('Use call(TextDecorationStyle.wavy) instead')
  /// Creates a [Style] instance with [TextDecorationStyle.wavy] value.
  T wavy() => call(.wavy);
}

/// Extension for creating [TextBaseline] values with predefined options.
extension TextBaselinePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextBaseline> {
  T call(TextBaseline value) => utilityBuilder(value);

  @Deprecated('Use call(TextBaseline.alphabetic) instead')
  /// Creates a [Style] instance with [TextBaseline.alphabetic] value.
  T alphabetic() => call(.alphabetic);

  @Deprecated('Use call(TextBaseline.ideographic) instead')
  /// Creates a [Style] instance with [TextBaseline.ideographic] value.
  T ideographic() => call(.ideographic);
}

/// Extension for creating [TextOverflow] values with predefined options.
extension TextOverflowPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextOverflow> {
  T call(TextOverflow value) => utilityBuilder(value);

  @Deprecated('Use call(TextOverflow.clip) instead')
  /// Creates a [Style] instance with [TextOverflow.clip] value.
  T clip() => call(.clip);

  @Deprecated('Use call(TextOverflow.fade) instead')
  /// Creates a [Style] instance with [TextOverflow.fade] value.
  T fade() => call(.fade);

  @Deprecated('Use call(TextOverflow.ellipsis) instead')
  /// Creates a [Style] instance with [TextOverflow.ellipsis] value.
  T ellipsis() => call(.ellipsis);

  @Deprecated('Use call(TextOverflow.visible) instead')
  /// Creates a [Style] instance with [TextOverflow.visible] value.
  T visible() => call(.visible);
}

/// Extension for creating [TextWidthBasis] values with predefined options.
extension TextWidthBasisPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextWidthBasis> {
  T call(TextWidthBasis value) => utilityBuilder(value);

  @Deprecated('Use call(TextWidthBasis.parent) instead')
  /// Creates a [Style] instance with [TextWidthBasis.parent] value.
  T parent() => call(.parent);

  @Deprecated('Use call(TextWidthBasis.longestLine) instead')
  /// Creates a [Style] instance with [TextWidthBasis.longestLine] value.
  T longestLine() => call(.longestLine);
}

/// Extension for creating [TextAlign] values with predefined options.
extension TextAlignPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextAlign> {
  T call(TextAlign value) => utilityBuilder(value);

  @Deprecated('Use call(TextAlign.left) instead')
  /// Creates a [Style] instance with [TextAlign.left] value.
  T left() => call(.left);

  @Deprecated('Use call(TextAlign.right) instead')
  /// Creates a [Style] instance with [TextAlign.right] value.
  T right() => call(.right);

  @Deprecated('Use call(TextAlign.center) instead')
  /// Creates a [Style] instance with [TextAlign.center] value.
  T center() => call(.center);

  @Deprecated('Use call(TextAlign.justify) instead')
  /// Creates a [Style] instance with [TextAlign.justify] value.
  T justify() => call(.justify);

  @Deprecated('Use call(TextAlign.start) instead')
  /// Creates a [Style] instance with [TextAlign.start] value.
  T start() => call(.start);

  @Deprecated('Use call(TextAlign.end) instead')
  /// Creates a [Style] instance with [TextAlign.end] value.
  T end() => call(.end);
}

/// Extension for creating [FilterQuality] values with predefined options.
extension FilterQualityPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FilterQuality> {
  T call(FilterQuality value) => utilityBuilder(value);

  @Deprecated('Use call(FilterQuality.none) instead')
  /// Creates a [Style] instance with [FilterQuality.none] value.
  T none() => call(.none);

  @Deprecated('Use call(FilterQuality.low) instead')
  /// Creates a [Style] instance with [FilterQuality.low] value.
  T low() => call(.low);

  @Deprecated('Use call(FilterQuality.medium) instead')
  /// Creates a [Style] instance with [FilterQuality.medium] value.
  T medium() => call(.medium);

  @Deprecated('Use call(FilterQuality.high) instead')
  /// Creates a [Style] instance with [FilterQuality.high] value.
  T high() => call(.high);
}

/// Extension for creating [WrapAlignment] values with predefined options.
extension WrapAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, WrapAlignment> {
  T call(WrapAlignment value) => utilityBuilder(value);

  @Deprecated('Use call(WrapAlignment.start) instead')
  /// Creates a [Style] instance with [WrapAlignment.start] value.
  T start() => call(.start);

  @Deprecated('Use call(WrapAlignment.end) instead')
  /// Creates a [Style] instance with [WrapAlignment.end] value.
  T end() => call(.end);

  @Deprecated('Use call(WrapAlignment.center) instead')
  /// Creates a [Style] instance with [WrapAlignment.center] value.
  T center() => call(.center);

  @Deprecated('Use call(WrapAlignment.spaceBetween) instead')
  /// Creates a [Style] instance with [WrapAlignment.spaceBetween] value.
  T spaceBetween() => call(.spaceBetween);

  @Deprecated('Use call(WrapAlignment.spaceAround) instead')
  /// Creates a [Style] instance with [WrapAlignment.spaceAround] value.
  T spaceAround() => call(.spaceAround);

  @Deprecated('Use call(WrapAlignment.spaceEvenly) instead')
  /// Creates a [Style] instance with [WrapAlignment.spaceEvenly] value.
  T spaceEvenly() => call(.spaceEvenly);
}

/// Extension for creating [TableCellVerticalAlignment] values with predefined options.
extension TableCellVerticalAlignmentPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TableCellVerticalAlignment> {
  T call(TableCellVerticalAlignment value) => utilityBuilder(value);

  @Deprecated('Use call(TableCellVerticalAlignment.top) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.top] value.
  T top() => call(.top);

  @Deprecated('Use call(TableCellVerticalAlignment.middle) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.middle] value.
  T middle() => call(.middle);

  @Deprecated('Use call(TableCellVerticalAlignment.bottom) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.bottom] value.
  T bottom() => call(.bottom);

  @Deprecated('Use call(TableCellVerticalAlignment.baseline) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.baseline] value.
  T baseline() => call(.baseline);

  @Deprecated('Use call(TableCellVerticalAlignment.fill) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.fill] value.
  T fill() => call(.fill);

  @Deprecated('Use call(TableCellVerticalAlignment.intrinsicHeight) instead')
  /// Creates a [Style] instance with [TableCellVerticalAlignment.intrinsicHeight] value.
  T intrinsicHeight() => call(.intrinsicHeight);
}
