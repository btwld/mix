import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_config.dart';
import '../../models/chart_hit.dart';
import '../../models/line_data.dart';
import '../../widgets/line_chart.dart';
import '../shared/chart_axis_spec.dart';
import '../shared/chart_frame_spec.dart';
import '../shared/chart_grid_spec.dart';
import '../shared/chart_tooltip_spec.dart';
import 'line_series_spec.dart';

part 'line_chart_spec.g.dart';

/// Resolved presentation for a [LineChart].
@MixableSpec(target: LineChart.new)
@immutable
final class LineChartSpec with _$LineChartSpec {
  /// Plot frame.
  @override
  final StyleSpec<ChartFrameSpec>? frame;

  /// Common presentation inherited by all axes.
  @override
  final StyleSpec<ChartAxisSpec>? axis;

  /// Bottom x-axis override.
  @override
  final StyleSpec<ChartAxisSpec>? xAxis;

  /// Left y-axis override.
  @override
  final StyleSpec<ChartAxisSpec>? yAxis;

  /// Top-axis override.
  @override
  final StyleSpec<ChartAxisSpec>? topAxis;

  /// Right-axis override.
  @override
  final StyleSpec<ChartAxisSpec>? rightAxis;

  /// Plot grid.
  @override
  final StyleSpec<ChartGridSpec>? grid;

  /// Common presentation inherited by every series.
  @override
  final StyleSpec<LineSeriesSpec>? series;

  /// Colors cycled across series that do not set an explicit color.
  @override
  final List<Color>? palette;

  /// Built-in tooltip presentation.
  @override
  final StyleSpec<ChartTooltipSpec>? tooltip;

  const LineChartSpec({
    this.frame,
    this.axis,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.grid,
    this.series,
    this.palette,
    this.tooltip,
  });
}
