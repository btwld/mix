import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../backend/chart_backend.dart';
import '../models/chart_config.dart';
import '../models/chart_hit.dart';
import '../models/line_data.dart';
import '../specs/line/line_chart_spec.dart';
import 'chart_semantics.dart';

/// A line or area chart with a Mix-owned public API.
final class LineChart extends StyleWidget<LineChartSpec> {
  /// Creates a line or area chart.
  LineChart({
    required List<LineSeries> series,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.viewport,
    this.dataTransition = ChartDataTransition.none,
    Set<LinePointKey> selectedPoints = const {},
    this.onPointHover,
    this.onPointTap,
    this.onPointLongPress,
    this.tooltipBuilder,
    this.hitTestRadius = 10,
    this.mouseCursorResolver,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
    LineChartStyler style = const LineChartStyler.create(),
    super.styleSpec,
    super.key,
  }) : series = UnmodifiableListView(List<LineSeries>.of(series)),
       selectedPoints = UnmodifiableSetView(
         Set<LinePointKey>.of(selectedPoints),
       ),
       super(style: style) {
    _requireUniqueIds(series.map((item) => item.id), 'series');
    if (!hitTestRadius.isFinite || hitTestRadius < 0) {
      throw ArgumentError.value(
        hitTestRadius,
        'hitTestRadius',
        'Must be finite and non-negative',
      );
    }
  }

  /// Ordered series.
  final List<LineSeries> series;

  /// Bottom x-axis configuration.
  final ChartAxis? xAxis;

  /// Left y-axis configuration.
  final ChartAxis? yAxis;

  /// Optional top-axis configuration.
  final ChartAxis? topAxis;

  /// Optional right-axis configuration.
  final ChartAxis? rightAxis;

  /// Optional pan and zoom behavior.
  final ChartViewport? viewport;

  /// Renderer-owned transition for compatible data updates.
  final ChartDataTransition dataTransition;

  /// Scoped keys of selected points.
  final Set<LinePointKey> selectedPoints;

  /// Called when the hovered point changes.
  final ValueChanged<LineChartHit?>? onPointHover;

  /// Called when a point is tapped.
  final ValueChanged<LineChartHit>? onPointTap;

  /// Called when a point is long-pressed.
  final ValueChanged<LineChartHit>? onPointLongPress;

  /// Optional custom widget tooltip.
  final ChartTooltipBuilder? tooltipBuilder;

  /// Extra distance in logical pixels used when hit-testing points.
  final double hitTestRadius;

  /// Resolves the mouse cursor from the point under the pointer.
  final ChartMouseCursorResolver<LineChartHit>? mouseCursorResolver;

  /// Accessible chart name.
  final String? semanticsLabel;

  /// Accessible chart value. A deterministic data summary is used when null.
  final String? semanticsValue;

  /// Whether the chart is decorative.
  final bool excludeFromSemantics;

  String _lineSummary() {
    final formatter = yAxis?.labelFormatter ?? (double value) => '$value';

    return series
        .map((item) {
          final values = item.points
              .where((point) => point.y != null)
              .map((point) => formatter(point.y!))
              .join(', ');

          return values.isEmpty ? item.label : '${item.label}: $values';
        })
        .join('; ');
  }

  @override
  Widget build(BuildContext context, LineChartSpec spec) {
    final child = buildLineChartBackend(
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

    return buildChartSemantics(
      label: semanticsLabel,
      value: semanticsValue ?? _lineSummary(),
      exclude: excludeFromSemantics,
      child: child,
    );
  }
}

void _requireUniqueIds(Iterable<Object> ids, String kind) {
  final seen = <Object>{};
  for (final id in ids) {
    if (!seen.add(id)) {
      throw ArgumentError.value(id, 'id', 'Duplicate $kind ID');
    }
  }
}
