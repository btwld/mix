import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_enums.dart';
import '../../models/chart_config.dart';
import '../../models/chart_hit.dart';
import '../../models/bar_data.dart';
import '../../widgets/bar_chart.dart';
import '../shared/chart_axis_spec.dart';
import '../shared/chart_frame_spec.dart';
import '../shared/chart_grid_spec.dart';
import '../shared/chart_tooltip_spec.dart';
import 'bar_spec.dart';

part 'bar_chart_spec.g.dart';

/// Resolved presentation for a [BarChart].
@MixableSpec(target: BarChart.new)
@immutable
final class BarChartSpec with _$BarChartSpec {
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

  /// Common presentation inherited by every bar.
  @override
  final StyleSpec<BarSpec>? bar;

  /// Common presentation inherited by every stacked segment.
  @override
  final StyleSpec<BarSegmentSpec>? segment;

  /// Colors cycled across bars that do not set an explicit color.
  @override
  final List<Color>? palette;

  /// Space between groups.
  @override
  final double? groupSpacing;

  /// Space between bars within a group.
  @override
  final double? barSpacing;

  /// Distribution of groups across the available width.
  @override
  final BarAlignment? alignment;

  /// Built-in tooltip presentation.
  @override
  final StyleSpec<ChartTooltipSpec>? tooltip;

  const BarChartSpec({
    this.frame,
    this.axis,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.grid,
    this.bar,
    this.segment,
    this.palette,
    this.groupSpacing,
    this.barSpacing,
    this.alignment,
    this.tooltip,
  });
}
