import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../public/models/chart_config.dart';
import '../../public/specs/shared/chart_axis_spec.dart';
import '../../public/specs/shared/chart_frame_spec.dart';
import '../../public/specs/shared/chart_grid_spec.dart';
import '../../public/specs/shared/chart_stroke_spec.dart';
import 'fl_axis_scale.dart';

/// Deterministic fallback colors used when a chart does not provide a palette.
const flDefaultPalette = [
  Color(0xFF6366F1),
  Color(0xFF06B6D4),
  Color(0xFFF97316),
  Color(0xFFEC4899),
  Color(0xFF22C55E),
  Color(0xFFEAB308),
];

/// Returns a non-empty palette for the backend.
List<Color> flResolvePalette(List<Color>? palette) =>
    palette == null || palette.isEmpty ? flDefaultPalette : palette;

/// Normalizes a public dash pattern before passing it to the renderer.
List<int>? flResolveDashArray(List<int>? dashArray) {
  if (dashArray == null || dashArray.isEmpty) return null;
  if (dashArray.any((length) => length <= 0)) {
    throw ArgumentError.value(
      dashArray,
      'dashArray',
      'All dash and gap lengths must be greater than 0',
    );
  }

  return dashArray;
}

/// Maps the public viewport contract to fl_chart.
fl.FlTransformationConfig flResolveViewport(ChartViewport? viewport) {
  final value = viewport ?? .none;

  return fl.FlTransformationConfig(
    scaleAxis: switch (value.axis) {
      .none => fl.FlScaleAxis.none,
      .horizontal => fl.FlScaleAxis.horizontal,
      .vertical => fl.FlScaleAxis.vertical,
      .both => fl.FlScaleAxis.free,
    },
    minScale: value.minScale,
    maxScale: value.maxScale,
    panEnabled: value.panEnabled,
    scaleEnabled: value.scaleEnabled,
    trackpadScrollCausesScale: value.trackpadScrollCausesScale,
    transformationController: value.controller,
  );
}

/// Maps the chart frame shared by all backends.
fl.FlBorderData flResolveBorder(StyleSpec<ChartFrameSpec>? frame) {
  final value = frame?.spec;

  return fl.FlBorderData(
    show: value?.showBorder ?? false,
    border: value?.border ?? .all(color: const Color(0xFFE2E8F0)),
  );
}

/// Maps the Cartesian grid shared by line and bar charts.
///
/// Grid lines follow the axis steps unless the grid style sets intervals.
fl.FlGridData flResolveGrid(
  StyleSpec<ChartGridSpec>? grid, {
  double? horizontalInterval,
  double? verticalInterval,
}) {
  final value = grid?.spec;
  final stroke = value?.stroke?.spec;
  final styledHorizontal = flGridInterval(grid, horizontal: true);
  final styledVertical = flGridInterval(grid, horizontal: false);
  final line = flResolveLine(
    stroke,
    fallbackColor: const Color(0xFFE2E8F0),
    fallbackWidth: 1,
  );

  return fl.FlGridData(
    show: value?.show ?? true,
    drawHorizontalLine: value?.showHorizontal ?? true,
    horizontalInterval: styledHorizontal ?? horizontalInterval,
    getDrawingHorizontalLine: (_) => line,
    drawVerticalLine: value?.showVertical ?? true,
    verticalInterval: styledVertical ?? verticalInterval,
    getDrawingVerticalLine: (_) => line,
  );
}

/// The grid interval set by the grid style, validated.
double? flGridInterval(
  StyleSpec<ChartGridSpec>? grid, {
  required bool horizontal,
}) => horizontal
    ? _validatedGridInterval(
        grid?.spec.horizontalInterval,
        'horizontalInterval',
      )
    : _validatedGridInterval(grid?.spec.verticalInterval, 'verticalInterval');

double? _validatedGridInterval(double? value, String name) {
  if (value == null) return null;
  if (!value.isFinite || value <= 0) {
    throw ArgumentError.value(value, name, 'Must be finite and greater than 0');
  }

  return value;
}

/// Merges mutually exclusive solid and gradient paints.
({Color? color, Gradient? gradient}) flMergePaint({
  required Color? baseColor,
  required Gradient? baseGradient,
  required Color? overrideColor,
  required Gradient? overrideGradient,
}) {
  if (overrideGradient != null) {
    return (color: null, gradient: overrideGradient);
  }
  if (overrideColor != null) {
    return (color: overrideColor, gradient: null);
  }

  return (color: baseColor, gradient: baseGradient);
}

/// Maps a stroke without leaking renderer paint types through the public API.
fl.FlLine flResolveLine(
  ChartStrokeSpec? stroke, {
  required Color fallbackColor,
  required double fallbackWidth,
}) {
  final opacity = (stroke?.opacity ?? 1).clamp(0.0, 1.0);
  final color = (stroke?.color ?? fallbackColor).withValues(
    alpha: (stroke?.color ?? fallbackColor).a * opacity,
  );
  final gradient = stroke?.gradient?.withOpacity(opacity);

  return fl.FlLine(
    color: gradient == null ? color : null,
    gradient: gradient,
    strokeWidth: stroke?.width ?? fallbackWidth,
    dashArray: flResolveDashArray(stroke?.dashArray),
  );
}

/// Returns the original pointer event for hover-class renderer events.
PointerEvent? flPointerEvent(fl.FlTouchEvent event) => switch (event) {
  fl.FlPointerEnterEvent(:final event) => event,
  fl.FlPointerHoverEvent(:final event) => event,
  fl.FlPointerExitEvent(:final event) => event,
  _ => null,
};

/// The size a chart lays out in, with a fallback for unbounded constraints.
///
/// The fallback only guides tick density; the renderer still reports its own
/// layout error for an unbounded chart.
Size flLayoutSize(BoxConstraints constraints) => .new(
  constraints.hasBoundedWidth ? constraints.maxWidth : 300,
  constraints.hasBoundedHeight ? constraints.maxHeight : 200,
);

/// Titles, scales and tick origins resolved for one Cartesian chart.
typedef FlCartesianAxes = ({
  fl.FlTitlesData titles,
  FlAxisScale x,
  FlAxisScale y,
  double baselineX,
  double baselineY,
});

/// Resolves all four Cartesian axes for a chart laid out in [size].
///
/// The value axis is scaled first, so its labels can be measured before the
/// x axis is given the remaining width. [xData] is null for a categorical x
/// axis, whose [categoryLabel] names each position.
FlCartesianAxes flResolveCartesianAxes({
  required BuildContext context,
  required Size size,
  required StyleSpec<ChartAxisSpec>? commonStyle,
  required StyleSpec<ChartAxisSpec>? xStyle,
  required StyleSpec<ChartAxisSpec>? yStyle,
  required StyleSpec<ChartAxisSpec>? topStyle,
  required StyleSpec<ChartAxisSpec>? rightStyle,
  required ChartAxis? xAxis,
  required ChartAxis? yAxis,
  required ChartAxis? topAxis,
  required ChartAxis? rightAxis,
  required FlAxisData? xData,
  required FlAxisData? yData,
  required ChartViewport? viewport,
  required int rotationQuarterTurns,
  required double? horizontalGridInterval,
  required double? verticalGridInterval,
  ChartAxisLabelFormatter? categoryLabel,
}) {
  final common = commonStyle?.spec;
  final left = _AxisSide(
    side: .left,
    common: common,
    specific: yStyle?.spec,
    axis: yAxis,
    shownByDefault: true,
  );
  final top = _AxisSide(
    side: .top,
    common: common,
    specific: topStyle?.spec,
    axis: topAxis,
    shownByDefault: false,
  );
  final right = _AxisSide(
    side: .right,
    common: common,
    specific: rightStyle?.spec,
    axis: rightAxis,
    shownByDefault: false,
  );
  final bottom = _AxisSide(
    side: .bottom,
    common: common,
    specific: xStyle?.spec,
    axis: xAxis,
    shownByDefault: true,
  );

  final turned = rotationQuarterTurns.isOdd;
  final width = turned ? size.height : size.width;
  final height = turned ? size.width : size.height;
  final zoom = viewport?.axis ?? .none;
  final y = flResolveAxisScale(
    axis: yAxis,
    data: yData,
    extent: height - top.defaultExtent - bottom.defaultExtent,
    roundBounds: true,
    zoomable: zoom == .vertical || zoom == .both,
  );
  final baselineY = y.baselineFor([
    y.interval,
    rightAxis?.interval,
    horizontalGridInterval,
  ]);
  final leftReserved = left.valueAxisReservedSize(context, y, baselineY);
  final rightReserved = right.valueAxisReservedSize(context, y, baselineY);
  final x = xData == null
      ? FlAxisScale(
          min: null,
          max: null,
          step: xAxis?.interval ?? 1,
          interval: xAxis?.interval ?? 1,
        )
      : flResolveAxisScale(
          axis: xAxis,
          data: xData,
          extent:
              width - left.extent(leftReserved) - right.extent(rightReserved),
          roundBounds: false,
          zoomable: zoom == .horizontal || zoom == .both,
        );
  final baselineX = x.baselineFor([
    x.interval,
    topAxis?.interval,
    verticalGridInterval,
  ]);

  return (
    titles: fl.FlTitlesData(
      leftTitles: left.titles(context, y, reservedSize: leftReserved),
      topTitles: top.titles(context, x),
      rightTitles: right.titles(context, y, reservedSize: rightReserved),
      bottomTitles: bottom.titles(context, x, fallbackLabel: categoryLabel),
    ),
    x: x,
    y: y,
    baselineX: baselineX,
    baselineY: baselineY,
  );
}

/// Label space a value axis reserves when its style does not set one.
const _valueAxisReservedSize = 44.0;

/// Label space a category axis reserves when its style does not set one.
const _categoryAxisReservedSize = 30.0;

/// One side of a Cartesian chart: its axis data and merged presentation.
final class _AxisSide {
  final ChartAxisSide side;
  final ChartAxisSpec? common;
  final ChartAxisSpec? specific;
  final ChartAxis? axis;
  final bool shownByDefault;

  const _AxisSide({
    required this.side,
    required this.common,
    required this.specific,
    required this.axis,
    required this.shownByDefault,
  });

  bool get isVertical => side == .left || side == .right;

  bool get showLabels =>
      pick((spec) => spec.showLabels) ?? (shownByDefault || axis != null);

  double get nameSize => pick((spec) => spec.nameSize) ?? 18;

  double get labelSpace => pick((spec) => spec.labelSpace) ?? 8;

  double get labelAngle => pick((spec) => spec.labelAngle) ?? 0;

  /// Reserved label space: the style's, or the package default.
  double get reservedSize =>
      pick((spec) => spec.reservedSize) ??
      (isVertical ? _valueAxisReservedSize : _categoryAxisReservedSize);

  /// Space this side takes from the plot with its default reserved size.
  double get defaultExtent => extent(reservedSize);

  T? pick<T>(T? Function(ChartAxisSpec spec) read) {
    final specific = this.specific;
    final common = this.common;

    return (specific == null ? null : read(specific)) ??
        (common == null ? null : read(common));
  }

  /// Space this side takes from the plot, mirroring the renderer's rules.
  double extent(double reservedSize) =>
      (showLabels && reservedSize != 0 ? reservedSize : 0) +
      (axis?.name != null && nameSize != 0 ? nameSize : 0);

  /// Reserved space for a value axis drawn along [scale].
  ///
  /// The style's value wins. Otherwise the default grows, never shrinks, to
  /// fit the widest default text label, so a long tick stays on one line.
  double valueAxisReservedSize(
    BuildContext context,
    FlAxisScale scale,
    double baseline,
  ) {
    final styled = pick((spec) => spec.reservedSize);
    if (styled != null) return styled;
    if (!showLabels || axis?.labelBuilder != null) return reservedSize;
    final min = scale.min;
    final max = scale.max;
    final settings = scale.titlesFor(axis);
    final interval = settings.interval ?? scale.step;
    if (min == null || max == null || interval == null) return reservedSize;

    final label = labelStyle();
    final media = MediaQuery.maybeOf(context);
    var style = DefaultTextStyle.of(context).style.merge(label.spec.style);
    if (media?.boldText ?? false) {
      style = style.merge(const TextStyle(fontWeight: .bold));
    }
    final angle = labelAngle;
    var widest = 0.0;
    for (final value in flTickValues(
      min: min,
      max: max,
      interval: interval,
      baseline: baseline,
      minIncluded: settings.minIncluded,
      maxIncluded: settings.maxIncluded,
    )) {
      final painter = TextPainter(
        text: TextSpan(
          text: labelText(value, min, max, interval),
          style: style,
        ),
        textDirection:
            label.spec.textDirection ?? Directionality.maybeOf(context) ?? .ltr,
        textScaler: label.spec.textScaler ?? media?.textScaler ?? .noScaling,
        maxLines: 1,
      )..layout();
      final size = painter.size;
      painter.dispose();
      widest = math.max(
        widest,
        size.width * math.cos(angle).abs() +
            size.height * math.sin(angle).abs(),
      );
    }

    return math.max(reservedSize, (widest + labelSpace).ceilToDouble());
  }

  /// Text of the default label at [value].
  String labelText(
    double value,
    double min,
    double max,
    double interval, {
    ChartAxisLabelFormatter? fallback,
  }) =>
      axis?.labelFormatter?.call(value) ??
      fallback?.call(value) ??
      flFormatTick(min, max, value, interval);

  /// Text presentation of default labels on this side.
  StyleSpec<TextSpec> labelStyle() {
    final textStyle = const TextStyle(
      color: Color(0xFF64748B),
      fontSize: 11,
      height: 1.2,
    ).merge(common?.label?.spec.style).merge(specific?.label?.spec.style);
    final commonLabel = common?.label;
    final specificLabel = specific?.label;
    final specificText = specificLabel?.spec;
    // Axes can arrive as raw StyleSpecs, so compose resolved values here.
    // Rebuild raw struts without reapplying package prefixes to qualified fonts.
    // StrutStyleMix does not retain leadingDistribution or debugLabel.
    final commonStrut = commonLabel?.spec.strutStyle;
    final specificStrut = specificText?.strutStyle;
    final strut = commonStrut == null
        ? specificStrut
        : specificStrut == null
        ? commonStrut
        : StrutStyle(
            fontFamily: specificStrut.fontFamily ?? commonStrut.fontFamily,
            fontFamilyFallback:
                specificStrut.fontFamilyFallback ??
                commonStrut.fontFamilyFallback,
            fontSize: specificStrut.fontSize ?? commonStrut.fontSize,
            height: specificStrut.height ?? commonStrut.height,
            leadingDistribution:
                specificStrut.leadingDistribution ??
                commonStrut.leadingDistribution,
            leading: specificStrut.leading ?? commonStrut.leading,
            fontWeight: specificStrut.fontWeight ?? commonStrut.fontWeight,
            fontStyle: specificStrut.fontStyle ?? commonStrut.fontStyle,
            forceStrutHeight:
                specificStrut.forceStrutHeight ?? commonStrut.forceStrutHeight,
            debugLabel: specificStrut.debugLabel ?? commonStrut.debugLabel,
          );

    return StyleSpec(
      spec: (commonLabel?.spec ?? const TextSpec()).copyWith(
        overflow: specificText?.overflow,
        strutStyle: strut,
        textAlign: specificText?.textAlign,
        textScaler: specificText?.textScaler,
        maxLines: specificText?.maxLines,
        style: textStyle,
        textWidthBasis: specificText?.textWidthBasis,
        textHeightBehavior: specificText?.textHeightBehavior,
        textDirection: specificText?.textDirection,
        softWrap: specificText?.softWrap,
        textDirectives: specificText?.textDirectives,
        selectionColor: specificText?.selectionColor,
        semanticsLabel: specificText?.semanticsLabel,
        locale: specificText?.locale,
      ),
      animation: specificLabel?.animation ?? commonLabel?.animation,
      widgetModifiers:
          specificLabel?.widgetModifiers ?? commonLabel?.widgetModifiers,
    );
  }

  fl.AxisTitles titles(
    BuildContext context,
    FlAxisScale scale, {
    double? reservedSize,
    ChartAxisLabelFormatter? fallbackLabel,
  }) {
    final labelSpec = labelStyle();
    final fitInside = pick((spec) => spec.fitInside) ?? false;
    final fitInsideDistance = pick((spec) => spec.fitInsideDistance) ?? 6;
    final settings = scale.titlesFor(axis);

    return fl.AxisTitles(
      axisNameWidget: axis?.name,
      axisNameSize: nameSize,
      sideTitles: fl.SideTitles(
        showTitles: showLabels,
        getTitlesWidget: (value, meta) {
          final formatted = labelText(
            value,
            meta.min,
            meta.max,
            meta.appliedInterval,
            fallback: fallbackLabel,
          );
          final label = ChartAxisLabel(
            value: value,
            formattedValue: formatted,
            side: side,
            min: meta.min,
            max: meta.max,
          );
          final child =
              axis?.labelBuilder?.call(context, label) ??
              StyledText(formatted, styleSpec: labelSpec);

          return fl.SideTitleWidget(
            meta: meta,
            space: labelSpace,
            angle: labelAngle,
            fitInside: fl.SideTitleFitInsideData.fromTitleMeta(
              meta,
              enabled: fitInside,
              distanceFromEdge: fitInsideDistance,
            ),
            child: child,
          );
        },
        reservedSize: reservedSize ?? this.reservedSize,
        interval: settings.interval,
        minIncluded: settings.minIncluded,
        maxIncluded: settings.maxIncluded,
      ),
      drawBelowEverything: pick((spec) => spec.drawBelowEverything) ?? true,
      sideTitleAlignment: pick((spec) => spec.alignment) == .inside
          ? fl.SideTitleAlignment.inside
          : fl.SideTitleAlignment.outside,
    );
  }
}
