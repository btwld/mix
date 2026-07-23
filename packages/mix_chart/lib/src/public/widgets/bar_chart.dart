import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../backend/chart_backend.dart';
import '../models/bar_data.dart';
import '../models/chart_config.dart';
import '../models/chart_hit.dart';
import '../specs/bar/bar_chart_spec.dart';
import 'chart_semantics.dart';

/// A grouped, stacked, or floating bar chart with a Mix-owned API.
final class BarChart extends StyleWidget<BarChartSpec> {
  /// Creates a bar chart.
  BarChart({
    required List<BarGroup> groups,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.viewport,
    this.dataTransition = ChartDataTransition.none,
    Set<BarSelectionKey> selectedItems = const {},
    this.onBarHover,
    this.onBarTap,
    this.onBarLongPress,
    this.tooltipBuilder,
    this.hitTestPadding = const EdgeInsets.all(4),
    this.mouseCursorResolver,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
    BarChartStyler style = const BarChartStyler.create(),
    super.styleSpec,
    super.key,
  }) : groups = UnmodifiableListView(List<BarGroup>.of(groups)),
       selectedItems = UnmodifiableSetView(
         Set<BarSelectionKey>.of(selectedItems),
       ),
       super(style: style) {
    _requireUniqueIds(groups.map((item) => item.id), 'group');
    if (!hitTestPadding.isNonNegative) {
      throw ArgumentError.value(
        hitTestPadding,
        'hitTestPadding',
        'Must be non-negative',
      );
    }
  }

  /// Ordered category groups.
  final List<BarGroup> groups;

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

  /// Scoped keys of selected bars or segments.
  final Set<BarSelectionKey> selectedItems;

  /// Called when the hovered bar changes.
  final ValueChanged<BarChartHit?>? onBarHover;

  /// Called when a bar is tapped.
  final ValueChanged<BarChartHit>? onBarTap;

  /// Called when a bar is long-pressed.
  final ValueChanged<BarChartHit>? onBarLongPress;

  /// Optional custom widget tooltip.
  final ChartTooltipBuilder? tooltipBuilder;

  /// Extra padding around bars used for hit testing.
  final EdgeInsets hitTestPadding;

  /// Resolves the mouse cursor from the bar under the pointer.
  final ChartMouseCursorResolver<BarChartHit>? mouseCursorResolver;

  /// Accessible chart name.
  final String? semanticsLabel;

  /// Accessible chart value. A deterministic data summary is used when null.
  final String? semanticsValue;

  /// Whether the chart is decorative.
  final bool excludeFromSemantics;

  String _barSummary() {
    final formatter = yAxis?.labelFormatter ?? (double value) => '$value';

    return groups
        .map((group) {
          final values = group.bars
              .map((bar) => '${bar.label} ${formatter(bar.toY)}')
              .join(', ');

          return values.isEmpty ? group.label : '${group.label}: $values';
        })
        .join('; ');
  }

  @override
  Widget build(BuildContext context, BarChartSpec spec) {
    final child = buildBarChartBackend(
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

    return buildChartSemantics(
      label: semanticsLabel,
      value: semanticsValue ?? _barSummary(),
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
