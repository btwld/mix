import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../backend/chart_backend.dart';
import '../models/chart_config.dart';
import '../models/chart_hit.dart';
import '../models/pie_data.dart';
import '../specs/pie/pie_chart_spec.dart';
import 'chart_semantics.dart';

/// A pie or donut chart with a Mix-owned public API.
final class PieChart extends StyleWidget<PieChartSpec> {
  /// Creates a pie or donut chart.
  PieChart({
    required List<PieSlice> slices,
    this.dataTransition = ChartDataTransition.none,
    Set<Object> selectedSliceIds = const {},
    this.onSliceHover,
    this.onSliceTap,
    this.onSliceLongPress,
    this.tooltipBuilder,
    this.mouseCursorResolver,
    this.valueFormatter,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
    PieChartStyler style = const PieChartStyler.create(),
    super.styleSpec,
    super.key,
  }) : slices = UnmodifiableListView(List<PieSlice>.of(slices)),
       selectedSliceIds = UnmodifiableSetView(Set<Object>.of(selectedSliceIds)),
       super(style: style) {
    _requireUniqueIds(slices.map((item) => item.id), 'slice');
  }

  /// Ordered slices.
  final List<PieSlice> slices;

  /// Renderer-owned transition for compatible data updates.
  final ChartDataTransition dataTransition;

  /// IDs of selected slices.
  final Set<Object> selectedSliceIds;

  /// Called when the hovered slice changes.
  final ValueChanged<PieChartHit?>? onSliceHover;

  /// Called when a slice is tapped.
  final ValueChanged<PieChartHit>? onSliceTap;

  /// Called when a slice is long-pressed.
  final ValueChanged<PieChartHit>? onSliceLongPress;

  /// Optional custom widget tooltip.
  final ChartTooltipBuilder? tooltipBuilder;

  /// Resolves the mouse cursor from the slice under the pointer.
  final ChartMouseCursorResolver<PieChartHit>? mouseCursorResolver;

  /// Formats numeric values for default tooltips and semantics.
  final ChartAxisLabelFormatter? valueFormatter;

  /// Accessible chart name.
  final String? semanticsLabel;

  /// Accessible chart value. A deterministic data summary is used when null.
  final String? semanticsValue;

  /// Whether the chart is decorative.
  final bool excludeFromSemantics;

  String _pieSummary() {
    final formatter = valueFormatter ?? (double value) => '$value';

    return slices
        .map((slice) => '${slice.label}: ${formatter(slice.value)}')
        .join('; ');
  }

  @override
  Widget build(BuildContext context, PieChartSpec spec) {
    final child = buildPieChartBackend(
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

    return buildChartSemantics(
      label: semanticsLabel,
      value: semanticsValue ?? _pieSummary(),
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
