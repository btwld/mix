// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

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

/// {@template table_cell_vertical_alignment_utility}
/// A utility class for creating [StyleAttribute] instances from [TableCellVerticalAlignment] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleAttribute] instances
/// from predefined [TableCellVerticalAlignment] values.
/// {@endtemplate}
class TableCellVerticalAlignmentUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, TableCellVerticalAlignment> {
  const TableCellVerticalAlignmentUtility(super.builder);

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

/// Utility for creating [AlignmentGeometry] values with predefined alignments.
final class AlignmentUtility<S extends StyleAttribute<Object?>>
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

/// Utility for creating [AlignmentGeometry] values with both absolute and directional alignments.
final class AlignmentGeometryUtility<S extends StyleAttribute<Object?>>
    extends AlignmentUtility<S> {
  /// Provides access to directional alignment utilities.
  late final directional = AlignmentDirectionalUtility<S>(builder);
  AlignmentGeometryUtility(super.builder);
}

/// Utility for creating [AlignmentDirectional] values that respect text direction.
final class AlignmentDirectionalUtility<S extends StyleAttribute<Object?>>
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

/// Utility for creating [FontFeature] values with predefined OpenType features.
final class FontFeatureUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, FontFeature> {
  const FontFeatureUtility(super.builder);

  /// Creates a [StyleAttribute] instance using the [FontFeature.enable] constructor.
  T enable(String feature) => call(FontFeature.enable(feature));

  /// Creates a [StyleAttribute] instance using the [FontFeature.disable] constructor.
  T disable(String feature) => call(FontFeature.disable(feature));

  /// Creates a [StyleAttribute] instance using the [FontFeature.alternative] constructor.
  T alternative(int value) => call(FontFeature.alternative(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.alternativeFractions] constructor.
  T alternativeFractions() => call(const FontFeature.alternativeFractions());

  /// Creates a [StyleAttribute] instance using the [FontFeature.contextualAlternates] constructor.
  T contextualAlternates() => call(const FontFeature.contextualAlternates());

  /// Creates a [StyleAttribute] instance using the [FontFeature.caseSensitiveForms] constructor.
  T caseSensitiveForms() => call(const FontFeature.caseSensitiveForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.characterVariant] constructor.
  T characterVariant(int value) => call(FontFeature.characterVariant(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.denominator] constructor.
  T denominator() => call(const FontFeature.denominator());

  /// Creates a [StyleAttribute] instance using the [FontFeature.fractions] constructor.
  T fractions() => call(const FontFeature.fractions());

  /// Creates a [StyleAttribute] instance using the [FontFeature.historicalForms] constructor.
  T historicalForms() => call(const FontFeature.historicalForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.historicalLigatures] constructor.
  T historicalLigatures() => call(const FontFeature.historicalLigatures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.liningFigures] constructor.
  T liningFigures() => call(const FontFeature.liningFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.localeAware] constructor.
  T localeAware({bool enable = true}) {
    return call(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [StyleAttribute] instance using the [FontFeature.notationalForms] constructor.
  T notationalForms([int value = 1]) =>
      call(FontFeature.notationalForms(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.numerators] constructor.
  T numerators() => call(const FontFeature.numerators());

  /// Creates a [StyleAttribute] instance using the [FontFeature.oldstyleFigures] constructor.
  T oldstyleFigures() => call(const FontFeature.oldstyleFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.ordinalForms] constructor.
  T ordinalForms() => call(const FontFeature.ordinalForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.proportionalFigures] constructor.
  T proportionalFigures() => call(const FontFeature.proportionalFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.randomize] constructor.
  T randomize() => call(const FontFeature.randomize());

  /// Creates a [StyleAttribute] instance using the [FontFeature.stylisticAlternates] constructor.
  T stylisticAlternates() => call(const FontFeature.stylisticAlternates());

  /// Creates a [StyleAttribute] instance using the [FontFeature.scientificInferiors] constructor.
  T scientificInferiors() => call(const FontFeature.scientificInferiors());

  /// Creates a [StyleAttribute] instance using the [FontFeature.stylisticSet] constructor.
  T stylisticSet(int value) => call(FontFeature.stylisticSet(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.subscripts] constructor.
  T subscripts() => call(const FontFeature.subscripts());

  /// Creates a [StyleAttribute] instance using the [FontFeature.superscripts] constructor.
  T superscripts() => call(const FontFeature.superscripts());

  /// Creates a [StyleAttribute] instance using the [FontFeature.swash] constructor.
  T swash([int value = 1]) => call(FontFeature.swash(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.tabularFigures] constructor.
  T tabularFigures() => call(const FontFeature.tabularFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.slashedZero] constructor.
  T slashedZero() => call(const FontFeature.slashedZero());
}

/// Utility for creating [Duration] values with time unit methods.
final class DurationUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Duration> {
  const DurationUtility(super.builder);

  T microseconds(int microseconds) =>
      call(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      call(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => call(Duration(seconds: seconds));

  T minutes(int minutes) => call(Duration(minutes: minutes));

  /// Creates a [StyleAttribute] instance with [Duration.zero] value.
  T zero() => call(Duration.zero);
}

/// Extension for creating font size values as doubles.
extension FontSizePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, double> {
  // No predefined font size values - this extension provides type consistency for font sizes
}

/// Utility for creating [FontWeight] values with predefined weights.
final class FontWeightUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, FontWeight> {
  const FontWeightUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [FontWeight.w100] value.
  T w100() => call(FontWeight.w100);

  /// Creates a [StyleAttribute] instance with [FontWeight.w200] value.
  T w200() => call(FontWeight.w200);

  /// Creates a [StyleAttribute] instance with [FontWeight.w300] value.
  T w300() => call(FontWeight.w300);

  /// Creates a [StyleAttribute] instance with [FontWeight.w400] value.
  T w400() => call(FontWeight.w400);

  /// Creates a [StyleAttribute] instance with [FontWeight.w500] value.
  T w500() => call(FontWeight.w500);

  /// Creates a [StyleAttribute] instance with [FontWeight.w600] value.
  T w600() => call(FontWeight.w600);

  /// Creates a [StyleAttribute] instance with [FontWeight.w700] value.
  T w700() => call(FontWeight.w700);

  /// Creates a [StyleAttribute] instance with [FontWeight.w800] value.
  T w800() => call(FontWeight.w800);

  /// Creates a [StyleAttribute] instance with [FontWeight.w900] value.
  T w900() => call(FontWeight.w900);

  /// Creates a [StyleAttribute] instance with [FontWeight.normal] value.
  T normal() => call(FontWeight.normal);

  /// Creates a [StyleAttribute] instance with [FontWeight.bold] value.
  T bold() => call(FontWeight.bold);
}

/// Utility for creating [TextDecoration] values with predefined decorations.
final class TextDecorationUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, TextDecoration> {
  const TextDecorationUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [TextDecoration.none] value.
  T none() => call(TextDecoration.none);

  /// Creates a [StyleAttribute] instance with [TextDecoration.underline] value.
  T underline() => call(TextDecoration.underline);

  /// Creates a [StyleAttribute] instance with [TextDecoration.overline] value.
  T overline() => call(TextDecoration.overline);

  /// Creates a [StyleAttribute] instance with [TextDecoration.lineThrough] value.
  T lineThrough() => call(TextDecoration.lineThrough);

  /// Creates a [StyleAttribute] instance using the [TextDecoration.combine] constructor.
  T combine(List<TextDecoration> decorations) {
    return call(TextDecoration.combine(decorations));
  }
}

/// Utility for creating [Curve] values with predefined animation curves.
final class CurveUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Curve> {
  const CurveUtility(super.builder);

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) => call(
    SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass),
  );

  /// Creates a [StyleAttribute] instance with [Curves.linear] value.
  T linear() => call(Curves.linear);

  /// Creates a [StyleAttribute] instance with [Curves.decelerate] value.
  T decelerate() => call(Curves.decelerate);

  /// Creates a [StyleAttribute] instance with [Curves.fastLinearToSlowEaseIn] value.
  T fastLinearToSlowEaseIn() => call(Curves.fastLinearToSlowEaseIn);

  /// Creates a [StyleAttribute] instance with [Curves.fastEaseInToSlowEaseOut] value.
  T fastEaseInToSlowEaseOut() => call(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [StyleAttribute] instance with [Curves.ease] value.
  T ease() => call(Curves.ease);

  /// Creates a [StyleAttribute] instance with [Curves.easeIn] value.
  T easeIn() => call(Curves.easeIn);

  /// Creates a [StyleAttribute] instance with [Curves.easeInToLinear] value.
  T easeInToLinear() => call(Curves.easeInToLinear);

  /// Creates a [StyleAttribute] instance with [Curves.easeInSine] value.
  T easeInSine() => call(Curves.easeInSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuad] value.
  T easeInQuad() => call(Curves.easeInQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeInCubic] value.
  T easeInCubic() => call(Curves.easeInCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuart] value.
  T easeInQuart() => call(Curves.easeInQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuint] value.
  T easeInQuint() => call(Curves.easeInQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeInExpo] value.
  T easeInExpo() => call(Curves.easeInExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeInCirc] value.
  T easeInCirc() => call(Curves.easeInCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeInBack] value.
  T easeInBack() => call(Curves.easeInBack);

  /// Creates a [StyleAttribute] instance with [Curves.easeOut] value.
  T easeOut() => call(Curves.easeOut);

  /// Creates a [StyleAttribute] instance with [Curves.linearToEaseOut] value.
  T linearToEaseOut() => call(Curves.linearToEaseOut);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutSine] value.
  T easeOutSine() => call(Curves.easeOutSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuad] value.
  T easeOutQuad() => call(Curves.easeOutQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutCubic] value.
  T easeOutCubic() => call(Curves.easeOutCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuart] value.
  T easeOutQuart() => call(Curves.easeOutQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuint] value.
  T easeOutQuint() => call(Curves.easeOutQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutExpo] value.
  T easeOutExpo() => call(Curves.easeOutExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutCirc] value.
  T easeOutCirc() => call(Curves.easeOutCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutBack] value.
  T easeOutBack() => call(Curves.easeOutBack);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOut] value.
  T easeInOut() => call(Curves.easeInOut);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutSine] value.
  T easeInOutSine() => call(Curves.easeInOutSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuad] value.
  T easeInOutQuad() => call(Curves.easeInOutQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCubic] value.
  T easeInOutCubic() => call(Curves.easeInOutCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCubicEmphasized] value.
  T easeInOutCubicEmphasized() => call(Curves.easeInOutCubicEmphasized);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuart] value.
  T easeInOutQuart() => call(Curves.easeInOutQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuint] value.
  T easeInOutQuint() => call(Curves.easeInOutQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutExpo] value.
  T easeInOutExpo() => call(Curves.easeInOutExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCirc] value.
  T easeInOutCirc() => call(Curves.easeInOutCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutBack] value.
  T easeInOutBack() => call(Curves.easeInOutBack);

  /// Creates a [StyleAttribute] instance with [Curves.fastOutSlowIn] value.
  T fastOutSlowIn() => call(Curves.fastOutSlowIn);

  /// Creates a [StyleAttribute] instance with [Curves.slowMiddle] value.
  T slowMiddle() => call(Curves.slowMiddle);

  /// Creates a [StyleAttribute] instance with [Curves.bounceIn] value.
  T bounceIn() => call(Curves.bounceIn);

  /// Creates a [StyleAttribute] instance with [Curves.bounceOut] value.
  T bounceOut() => call(Curves.bounceOut);

  /// Creates a [StyleAttribute] instance with [Curves.bounceInOut] value.
  T bounceInOut() => call(Curves.bounceInOut);

  /// Creates a [StyleAttribute] instance with [Curves.elasticIn] value.
  T elasticIn() => call(Curves.elasticIn);

  /// Creates a [StyleAttribute] instance with [Curves.elasticOut] value.
  T elasticOut() => call(Curves.elasticOut);

  /// Creates a [StyleAttribute] instance with [Curves.elasticInOut] value.
  T elasticInOut() => call(Curves.elasticInOut);
}

/// Utility for creating [Offset] values with predefined positions.
final class OffsetUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Offset> {
  const OffsetUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [Offset.zero] value.
  T zero() => call(Offset.zero);

  /// Creates a [StyleAttribute] instance with [Offset.infinite] value.
  T infinite() => call(Offset.infinite);

  /// Creates a [StyleAttribute] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return call(Offset.fromDirection(direction, distance));
  }
}

/// Utility for creating [Radius] values with predefined radius shapes.
final class RadiusUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Radius> {
  const RadiusUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [Radius.zero] value.
  T zero() => call(Radius.zero);

  /// Creates a [StyleAttribute] instance using the [Radius.circular] constructor.
  T circular(double radius) => call(Radius.circular(radius));

  /// Creates a [StyleAttribute] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => call(Radius.elliptical(x, y));
}

/// Utility for creating [Rect] values with predefined rectangles and constructors.
final class RectUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Rect> {
  const RectUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [Rect.zero] value.
  T zero() => call(Rect.zero);

  /// Creates a [StyleAttribute] instance with [Rect.largest] value.
  T largest() => call(Rect.largest);

  /// Creates a [StyleAttribute] instance using the [Rect.fromLTRB] constructor.
  T fromLTRB(double left, double top, double right, double bottom) {
    return call(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromLTWH] constructor.
  T fromLTWH(double left, double top, double width, double height) {
    return call(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromCircle] constructor.
  T fromCircle({required Offset center, required double radius}) {
    return call(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromCenter] constructor.
  T fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return call(Rect.fromCenter(center: center, width: width, height: height));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromPoints] constructor.
  T fromPoints(Offset a, Offset b) => call(Rect.fromPoints(a, b));
}

/// Extension for creating [Paint] values for custom drawing operations.
extension PaintPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Paint> {
  // No predefined paint values - this extension provides type consistency
}

/// Extension for creating [Locale] values for internationalization.
extension LocalePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Locale> {
  // No predefined locale values - this extension provides type consistency
}

/// Utility for creating [ImageProvider] values with different image sources.
final class ImageProviderUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, ImageProvider> {
  const ImageProviderUtility(super.builder);

  /// Creates an [StyleAttribute] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => call(NetworkImage(url));
  T file(File file) => call(FileImage(file));
  T asset(String asset) => call(AssetImage(asset));
  T memory(Uint8List bytes) => call(MemoryImage(bytes));
}

/// Utility for creating [GradientTransform] values for gradient transformations.
final class GradientTransformUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, GradientTransform> {
  const GradientTransformUtility(super.builder);

  /// Creates an [StyleAttribute] instance with a [GradientRotation] value.
  T rotate(double radians) => call(GradientRotation(radians));
}

/// Utility for creating [Matrix4] values for 3D transformations.
final class Matrix4Utility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, Matrix4> {
  const Matrix4Utility(super.builder);

  /// Creates a [StyleAttribute] instance using the [Matrix4.fromList] constructor.
  T fromList(List<double> values) => call(Matrix4.fromList(values));

  /// Creates a [StyleAttribute] instance using the [Matrix4.zero] constructor.
  T zero() => call(Matrix4.zero());

  /// Creates a [StyleAttribute] instance using the [Matrix4.identity] constructor.
  T identity() => call(Matrix4.identity());

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationX] constructor.
  T rotationX(double radians) => call(Matrix4.rotationX(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationY] constructor.
  T rotationY(double radians) => call(Matrix4.rotationY(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationZ] constructor.
  T rotationZ(double radians) => call(Matrix4.rotationZ(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.translationValues] constructor.
  T translationValues(double x, double y, double z) {
    return call(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [StyleAttribute] instance using the [Matrix4.diagonal3Values] constructor.
  T diagonal3Values(double x, double y, double z) {
    return call(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [StyleAttribute] instance using the [Matrix4.skewX] constructor.
  T skewX(double alpha) => call(Matrix4.skewX(alpha));

  /// Creates a [StyleAttribute] instance using the [Matrix4.skewY] constructor.
  T skewY(double beta) => call(Matrix4.skewY(beta));

  /// Creates a [StyleAttribute] instance using the [Matrix4.skew] constructor.
  T skew(double alpha, double beta) => call(Matrix4.skew(alpha, beta));

  /// Creates a [StyleAttribute] instance using the [Matrix4.fromBuffer] constructor.
  T fromBuffer(ByteBuffer buffer, int offset) {
    return call(Matrix4.fromBuffer(buffer, offset));
  }
}

/// Utility for creating font family strings with various constructors.
final class FontFamilyUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, String> {
  const FontFamilyUtility(super.builder);

  /// Creates a [StyleAttribute] instance using the [String.fromCharCodes] constructor.
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return call(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [StyleAttribute] instance using the [String.fromCharCode] constructor.
  T fromCharCode(int charCode) => call(String.fromCharCode(charCode));

  /// Creates a [StyleAttribute] instance using the [String.fromEnvironment] constructor.
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return call(String.fromEnvironment(name, defaultValue: defaultValue));
  }
}

/// Utility for creating [TextScaler] values for text scaling.
final class TextScalerUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, TextScaler> {
  const TextScalerUtility(super.builder);

  /// Creates a [StyleAttribute] instance with [TextScaler.noScaling] value.
  T noScaling() => call(TextScaler.noScaling);

  /// Creates a [StyleAttribute] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) => call(TextScaler.linear(textScaleFactor));
}

/// Extension for creating [TableColumnWidth] values for table column sizing.
extension TableColumnWidthPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TableColumnWidth> {
  // No predefined table column width values - this extension provides type consistency
}

/// Utility for creating [TableBorder] values with predefined border styles.
class TableBorderUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, TableBorder> {
  const TableBorderUtility(super.builder);

  /// Creates a [StyleAttribute] instance using the [TableBorder.all] constructor.
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

  /// Creates a [StyleAttribute] instance using the [TableBorder.symmetric] constructor.
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

/// Utility for creating stroke alignment values for border positioning.
final class StrokeAlignUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, double> {
  const StrokeAlignUtility(super.builder);

  T center() => call(0);
  T inside() => call(-1);
  T outside() => call(1);
}

/// Extension for creating string values.
extension StringPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, String> {
  // No predefined string values - this extension provides type consistency
}

/// Extension for creating [double] values with predefined options.
extension DoublePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, double> {
  /// Creates an [StyleAttribute] instance with a value of 0.
  T zero() => call(0);

  /// Creates an [StyleAttribute] instance with a value of [double.infinity].
  T infinity() => call(double.infinity);
}

/// Extension for creating [int] values with predefined options.
extension IntPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, int> {
  /// Creates an [StyleAttribute] instance with a value of 0.
  T zero() => call(0);
}

/// Extension for creating [bool] values with predefined options.
extension BoolPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, bool> {
  /// Creates an [StyleAttribute] instance with a value of `true`.
  T on() => call(true);

  /// Creates an [StyleAttribute] instance with a value of `false`.
  T off() => call(false);
}
