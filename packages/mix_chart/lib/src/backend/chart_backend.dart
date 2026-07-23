import 'package:flutter/widgets.dart';

import '../public/models/bar_data.dart';
import '../public/models/chart_config.dart';
import '../public/models/chart_hit.dart';
import '../public/models/line_data.dart';
import '../public/models/pie_data.dart';
import '../public/specs/bar/bar_chart_spec.dart';
import '../public/specs/line/line_chart_spec.dart';
import '../public/specs/pie/pie_chart_spec.dart';
import 'fl_chart/fl_bar_chart_adapter.dart';
import 'fl_chart/fl_line_chart_adapter.dart';
import 'fl_chart/fl_pie_chart_adapter.dart';

/// Creates the private rendering backend for a line chart.
Widget buildLineChartBackend({
  required List<LineSeries> series,
  required LineChartSpec spec,
  required ChartAxis? xAxis,
  required ChartAxis? yAxis,
  required ChartAxis? topAxis,
  required ChartAxis? rightAxis,
  required ChartViewport? viewport,
  required ChartDataTransition dataTransition,
  required Set<LinePointKey> selectedPoints,
  required ValueChanged<LineChartHit?>? onPointHover,
  required ValueChanged<LineChartHit>? onPointTap,
  required ValueChanged<LineChartHit>? onPointLongPress,
  required ChartTooltipBuilder? tooltipBuilder,
  required double hitTestRadius,
  required ChartMouseCursorResolver<LineChartHit>? mouseCursorResolver,
}) => FlLineChartAdapter(
  spec: spec,
  series: series,
  xAxis: xAxis,
  yAxis: yAxis,
  topAxis: topAxis,
  rightAxis: rightAxis,
  viewport: viewport,
  dataTransition: dataTransition,
  selectedPoints: selectedPoints,
  onPointHover: onPointHover,
  onPointTap: onPointTap,
  onPointLongPress: onPointLongPress,
  tooltipBuilder: tooltipBuilder,
  hitTestRadius: hitTestRadius,
  mouseCursorResolver: mouseCursorResolver,
);

/// Creates the private rendering backend for a bar chart.
Widget buildBarChartBackend({
  required List<BarGroup> groups,
  required BarChartSpec spec,
  required ChartAxis? xAxis,
  required ChartAxis? yAxis,
  required ChartAxis? topAxis,
  required ChartAxis? rightAxis,
  required ChartViewport? viewport,
  required ChartDataTransition dataTransition,
  required Set<BarSelectionKey> selectedItems,
  required ValueChanged<BarChartHit?>? onBarHover,
  required ValueChanged<BarChartHit>? onBarTap,
  required ValueChanged<BarChartHit>? onBarLongPress,
  required ChartTooltipBuilder? tooltipBuilder,
  required EdgeInsets hitTestPadding,
  required ChartMouseCursorResolver<BarChartHit>? mouseCursorResolver,
}) => FlBarChartAdapter(
  spec: spec,
  groups: groups,
  xAxis: xAxis,
  yAxis: yAxis,
  topAxis: topAxis,
  rightAxis: rightAxis,
  viewport: viewport,
  dataTransition: dataTransition,
  selectedItems: selectedItems,
  onBarHover: onBarHover,
  onBarTap: onBarTap,
  onBarLongPress: onBarLongPress,
  tooltipBuilder: tooltipBuilder,
  hitTestPadding: hitTestPadding,
  mouseCursorResolver: mouseCursorResolver,
);

/// Creates the private rendering backend for a pie chart.
Widget buildPieChartBackend({
  required List<PieSlice> slices,
  required PieChartSpec spec,
  required ChartDataTransition dataTransition,
  required Set<Object> selectedSliceIds,
  required ValueChanged<PieChartHit?>? onSliceHover,
  required ValueChanged<PieChartHit>? onSliceTap,
  required ValueChanged<PieChartHit>? onSliceLongPress,
  required ChartTooltipBuilder? tooltipBuilder,
  required ChartMouseCursorResolver<PieChartHit>? mouseCursorResolver,
  required ChartAxisLabelFormatter? valueFormatter,
}) => FlPieChartAdapter(
  spec: spec,
  slices: slices,
  dataTransition: dataTransition,
  selectedSliceIds: selectedSliceIds,
  onSliceHover: onSliceHover,
  onSliceTap: onSliceTap,
  onSliceLongPress: onSliceLongPress,
  tooltipBuilder: tooltipBuilder,
  mouseCursorResolver: mouseCursorResolver,
  valueFormatter: valueFormatter,
);
