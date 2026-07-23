import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../public/models/chart_config.dart';
import '../../public/specs/shared/chart_axis_spec.dart';
import '../../public/specs/shared/chart_frame_spec.dart';
import '../../public/specs/shared/chart_grid_spec.dart';
import '../../public/specs/shared/chart_stroke_spec.dart';

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
fl.FlGridData flResolveGrid(StyleSpec<ChartGridSpec>? grid) {
  final value = grid?.spec;
  final stroke = value?.stroke?.spec;
  final line = flResolveLine(
    stroke,
    fallbackColor: const Color(0xFFE2E8F0),
    fallbackWidth: 1,
  );

  return fl.FlGridData(
    show: value?.show ?? true,
    drawHorizontalLine: value?.showHorizontal ?? true,
    horizontalInterval: value?.horizontalInterval,
    getDrawingHorizontalLine: (_) => line,
    drawVerticalLine: value?.showVertical ?? true,
    verticalInterval: value?.verticalInterval,
    getDrawingVerticalLine: (_) => line,
  );
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
    dashArray: stroke?.dashArray,
  );
}

/// Returns the original pointer event for hover-class renderer events.
PointerEvent? flPointerEvent(fl.FlTouchEvent event) => switch (event) {
  fl.FlPointerEnterEvent(:final event) => event,
  fl.FlPointerHoverEvent(:final event) => event,
  fl.FlPointerExitEvent(:final event) => event,
  _ => null,
};

/// Maps all four Cartesian axes, merging the common axis style with each side.
fl.FlTitlesData flResolveTitles({
  required BuildContext context,
  required StyleSpec<ChartAxisSpec>? commonStyle,
  required StyleSpec<ChartAxisSpec>? xStyle,
  required StyleSpec<ChartAxisSpec>? yStyle,
  required StyleSpec<ChartAxisSpec>? topStyle,
  required StyleSpec<ChartAxisSpec>? rightStyle,
  required ChartAxis? xAxis,
  required ChartAxis? yAxis,
  required ChartAxis? topAxis,
  required ChartAxis? rightAxis,
}) => fl.FlTitlesData(
  leftTitles: _resolveAxisTitles(
    context: context,
    common: commonStyle?.spec,
    specific: yStyle?.spec,
    axis: yAxis,
    side: .left,
    shownByDefault: true,
  ),
  topTitles: _resolveAxisTitles(
    context: context,
    common: commonStyle?.spec,
    specific: topStyle?.spec,
    axis: topAxis,
    side: .top,
    shownByDefault: false,
  ),
  rightTitles: _resolveAxisTitles(
    context: context,
    common: commonStyle?.spec,
    specific: rightStyle?.spec,
    axis: rightAxis,
    side: .right,
    shownByDefault: false,
  ),
  bottomTitles: _resolveAxisTitles(
    context: context,
    common: commonStyle?.spec,
    specific: xStyle?.spec,
    axis: xAxis,
    side: .bottom,
    shownByDefault: true,
  ),
);

fl.AxisTitles _resolveAxisTitles({
  required BuildContext context,
  required ChartAxisSpec? common,
  required ChartAxisSpec? specific,
  required ChartAxis? axis,
  required ChartAxisSide side,
  required bool shownByDefault,
}) {
  T? pick<T>(T? commonValue, T? specificValue) => specificValue ?? commonValue;

  final showLabels =
      pick(common?.showLabels, specific?.showLabels) ??
      (shownByDefault || axis != null);
  final textStyle = const TextStyle(
    color: Color(0xFF64748B),
    fontSize: 11,
    height: 1.2,
  ).merge(common?.label?.spec.style).merge(specific?.label?.spec.style);
  final labelSpace = pick(common?.labelSpace, specific?.labelSpace) ?? 8;
  final labelAngle = pick(common?.labelAngle, specific?.labelAngle) ?? 0;
  final fitInside = pick(common?.fitInside, specific?.fitInside) ?? false;
  final fitInsideDistance =
      pick(common?.fitInsideDistance, specific?.fitInsideDistance) ?? 6;

  return fl.AxisTitles(
    axisNameWidget: axis?.name,
    axisNameSize: pick(common?.nameSize, specific?.nameSize) ?? 18,
    sideTitles: fl.SideTitles(
      showTitles: showLabels,
      getTitlesWidget: (value, meta) {
        final formatted =
            axis?.labelFormatter?.call(value) ?? meta.formattedValue;
        final label = ChartAxisLabel(
          value: value,
          formattedValue: formatted,
          side: side,
          min: meta.min,
          max: meta.max,
        );
        final child =
            axis?.labelBuilder?.call(context, label) ??
            Text(formatted, style: textStyle);

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
      reservedSize:
          pick(common?.reservedSize, specific?.reservedSize) ??
          (side == .left || side == .right ? 44 : 30),
      interval: axis?.interval,
      minIncluded: axis?.minIncluded ?? true,
      maxIncluded: axis?.maxIncluded ?? true,
    ),
    drawBelowEverything:
        pick(common?.drawBelowEverything, specific?.drawBelowEverything) ??
        true,
    sideTitleAlignment: pick(common?.alignment, specific?.alignment) == .inside
        ? fl.SideTitleAlignment.inside
        : fl.SideTitleAlignment.outside,
  );
}
