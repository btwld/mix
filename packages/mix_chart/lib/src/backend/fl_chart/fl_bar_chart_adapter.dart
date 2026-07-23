import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../public/models/bar_data.dart';
import '../../public/models/chart_config.dart';
import '../../public/models/chart_enums.dart';
import '../../public/models/chart_hit.dart';
import '../../public/specs/bar/bar_background_spec.dart';
import '../../public/specs/bar/bar_chart_spec.dart';
import '../../public/specs/bar/bar_spec.dart';
import 'fl_chart_helpers.dart';
import 'fl_chart_tooltip_overlay.dart';

/// Private fl_chart implementation of the public bar-chart contract.
final class FlBarChartAdapter extends StatefulWidget {
  const FlBarChartAdapter({
    required this.groups,
    required this.spec,
    required this.xAxis,
    required this.yAxis,
    required this.topAxis,
    required this.rightAxis,
    required this.viewport,
    required this.dataTransition,
    required this.selectedItems,
    required this.onBarHover,
    required this.onBarTap,
    required this.onBarLongPress,
    required this.tooltipBuilder,
    required this.hitTestPadding,
    required this.mouseCursorResolver,
    super.key,
  });

  final List<BarGroup> groups;
  final BarChartSpec spec;
  final ChartAxis? xAxis;
  final ChartAxis? yAxis;
  final ChartAxis? topAxis;
  final ChartAxis? rightAxis;
  final ChartViewport? viewport;
  final ChartDataTransition dataTransition;
  final Set<BarSelectionKey> selectedItems;
  final ValueChanged<BarChartHit?>? onBarHover;
  final ValueChanged<BarChartHit>? onBarTap;
  final ValueChanged<BarChartHit>? onBarLongPress;
  final ChartTooltipBuilder? tooltipBuilder;
  final EdgeInsets hitTestPadding;

  final ChartMouseCursorResolver<BarChartHit>? mouseCursorResolver;

  @override
  State<FlBarChartAdapter> createState() => _FlBarChartAdapterState();
}

final class _FlBarChartAdapterState extends State<FlBarChartAdapter> {
  ChartHit? _tooltipHit;
  bool _topologyCompatible = true;

  bool _isSegmentSelected(BarGroup group, BarValue bar, BarSegment segment) =>
      widget.selectedItems.contains(
        BarSelectionKey.segment(
          groupId: group.id,
          barId: bar.id,
          segmentId: segment.id,
        ),
      );

  fl.BarChartRodData _resolveBar(
    BuildContext context,
    BarGroup group,
    BarValue bar,
    BarSpec presentation,
    Color fallbackColor,
  ) {
    final gradient = presentation.gradient;
    final selected =
        widget.selectedItems.contains(
          BarSelectionKey.bar(groupId: group.id, barId: bar.id),
        ) ||
        bar.segments.any((segment) => _isSegmentSelected(group, bar, segment));
    final formatter =
        widget.yAxis?.labelFormatter ?? (double value) => '$value';

    return fl.BarChartRodData(
      fromY: bar.fromY,
      toY: bar.toY,
      color: gradient == null ? (presentation.color ?? fallbackColor) : null,
      gradient: gradient,
      width: (presentation.width ?? 14) + (selected ? 2 : 0),
      borderRadius: presentation.borderRadius ?? .circular(6),
      borderDashArray: presentation.borderDashArray,
      borderSide: presentation.border ?? .none,
      backDrawRodData: _resolveBackground(presentation.background?.spec),
      rodStackItems: [
        for (var index = 0; index < bar.segments.length; index++)
          _resolveSegment(context, group, bar, bar.segments[index], index),
      ],
      label: fl.BarChartRodLabel(
        show: presentation.label != null,
        text: formatter(bar.toY),
        style: presentation.label?.spec.style,
        angle: presentation.labelAngle ?? 0,
        offset: presentation.labelOffset ?? const Offset(0, 8),
      ),
    );
  }

  fl.BarChartRodStackItem _resolveSegment(
    BuildContext context,
    BarGroup group,
    BarValue bar,
    BarSegment segment,
    int segmentIndex,
  ) {
    final override = segment.style?.build(context).spec;
    final presentation = _mergeSegment(widget.spec.segment?.spec, override);
    final palette = flResolvePalette(widget.spec.palette);
    final gradient = presentation.gradient;
    final color = presentation.color ?? palette[segmentIndex % palette.length];
    final selected = _isSegmentSelected(group, bar, segment);
    final border =
        presentation.border ??
        (selected
            ? const BorderSide(color: Colors.white, width: 2)
            : BorderSide.none);

    return fl.BarChartRodStackItem(
      segment.fromY,
      segment.toY,
      gradient == null ? color : null,
      gradient: gradient,
      label: presentation.label == null ? null : segment.label,
      labelStyle: presentation.label?.spec.style,
      borderSide: border,
    );
  }

  fl.BarTouchData _resolveTouchData() {
    final tooltip = widget.spec.tooltip?.spec;
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: .w600,
    ).merge(tooltip?.text?.spec.style);
    final formatter =
        widget.yAxis?.labelFormatter ?? (double value) => '$value';

    return fl.BarTouchData(
      touchCallback: _handleTouch,
      mouseCursorResolver: widget.mouseCursorResolver == null
          ? null
          : (event, response) =>
                widget.mouseCursorResolver!(_barHit(event, response)),
      touchTooltipData: fl.BarTouchTooltipData(
        tooltipBorderRadius: tooltip?.borderRadius ?? .circular(10),
        tooltipPadding:
            tooltip?.padding ?? const .symmetric(vertical: 9, horizontal: 12),
        tooltipMargin: tooltip?.margin ?? 12,
        maxContentWidth: tooltip?.maxWidth ?? 180,
        getTooltipItem: (_, groupIndex, rod, rodIndex) {
          final group = widget.groups[groupIndex];
          final bar = group.bars[rodIndex];

          return fl.BarTooltipItem(
            '${group.label} · ${bar.label}\n${formatter(rod.toY)}',
            textStyle,
          );
        },
        getTooltipColor: (_) =>
            tooltip?.backgroundColor ?? const Color(0xFF0F172A),
        fitInsideHorizontally: tooltip?.fitHorizontally ?? true,
        fitInsideVertically: tooltip?.fitVertically ?? true,
        tooltipBorder: tooltip?.border ?? .none,
      ),
      touchExtraThreshold: widget.hitTestPadding,
      handleBuiltInTouches: widget.tooltipBuilder == null,
    );
  }

  void _handleTouch(fl.FlTouchEvent event, fl.BarTouchResponse? response) {
    final hit = _barHit(event, response);
    if (event is fl.FlPointerExitEvent) {
      widget.onBarHover?.call(null);
      _setTooltipHit(null);

      return;
    }
    if (event is fl.FlPointerHoverEvent || event is fl.FlPointerEnterEvent) {
      widget.onBarHover?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlTapUpEvent && hit != null) {
      widget.onBarTap?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlLongPressStart && hit != null) {
      widget.onBarLongPress?.call(hit);
      _setTooltipHit(hit);
    }
  }

  BarChartHit? _barHit(fl.FlTouchEvent event, fl.BarTouchResponse? response) {
    final spot = response?.spot;
    if (spot == null || spot.touchedBarGroupIndex >= widget.groups.length) {
      return null;
    }
    final group = widget.groups[spot.touchedBarGroupIndex];
    if (spot.touchedRodDataIndex >= group.bars.length) return null;
    final bar = group.bars[spot.touchedRodDataIndex];
    final segmentIndex = spot.touchedStackItemIndex;
    final segment = segmentIndex >= 0 && segmentIndex < bar.segments.length
        ? bar.segments[segmentIndex]
        : null;

    return BarChartHit(
      groupId: group.id,
      barId: bar.id,
      segmentId: segment?.id,
      fromY: segment?.fromY ?? bar.fromY,
      toY: segment?.toY ?? bar.toY,
      localPosition: event.localPosition ?? response?.touchLocation ?? .zero,
      event: flPointerEvent(event),
    );
  }

  void _setTooltipHit(ChartHit? hit) {
    if (widget.tooltipBuilder == null || hit == _tooltipHit || !mounted) return;
    setState(() => _tooltipHit = hit);
  }

  @override
  void didUpdateWidget(FlBarChartAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _topologyCompatible = _hasSameTopology(oldWidget.groups, widget.groups);
  }

  @override
  Widget build(BuildContext context) {
    final palette = flResolvePalette(widget.spec.palette);
    final groups = <fl.BarChartGroupData>[];

    for (var groupIndex = 0; groupIndex < widget.groups.length; groupIndex++) {
      final group = widget.groups[groupIndex];
      final rods = <fl.BarChartRodData>[];
      for (var barIndex = 0; barIndex < group.bars.length; barIndex++) {
        final bar = group.bars[barIndex];
        final override = bar.style?.build(context).spec;
        final presentation = _mergeBar(widget.spec.bar?.spec, override);
        final fallbackColor = palette[barIndex % palette.length];
        rods.add(_resolveBar(context, group, bar, presentation, fallbackColor));
      }
      groups.add(
        fl.BarChartGroupData(
          x: groupIndex,
          barRods: rods,
          barsSpace: widget.spec.barSpacing ?? 4,
        ),
      );
    }

    final frame = widget.spec.frame?.spec;
    final effectiveXAxis =
        widget.xAxis ??
        ChartAxis.numeric(
          interval: 1,
          labelFormatter: (value) {
            final index = value.round();

            return index >= 0 && index < widget.groups.length
                ? widget.groups[index].label
                : '';
          },
        );
    final data = fl.BarChartData(
      barGroups: groups,
      groupsSpace: widget.spec.groupSpacing ?? 16,
      alignment: _resolveAlignment(widget.spec.alignment),
      titlesData: flResolveTitles(
        context: context,
        commonStyle: widget.spec.axis,
        xStyle: widget.spec.xAxis,
        yStyle: widget.spec.yAxis,
        topStyle: widget.spec.topAxis,
        rightStyle: widget.spec.rightAxis,
        xAxis: effectiveXAxis,
        yAxis: widget.yAxis,
        topAxis: widget.topAxis,
        rightAxis: widget.rightAxis,
      ),
      barTouchData: _resolveTouchData(),
      maxY: widget.yAxis?.max,
      minY: widget.yAxis?.min,
      gridData: flResolveGrid(widget.spec.grid),
      borderData: flResolveBorder(widget.spec.frame),
      backgroundColor: frame?.backgroundColor,
      rotationQuarterTurns: frame?.rotationQuarterTurns ?? 0,
    );
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations || !_topologyCompatible
        ? Duration.zero
        : widget.dataTransition.duration;
    Widget chart = fl.BarChart(
      data,
      duration: duration,
      curve: widget.dataTransition.curve,
      transformationConfig: flResolveViewport(widget.viewport),
    );
    if (frame?.clip == true) chart = ClipRect(child: chart);

    return flWrapTooltipOverlay(
      hit: _tooltipHit,
      builder: widget.tooltipBuilder,
      margin: widget.spec.tooltip?.spec.margin ?? 12,
      child: chart,
    );
  }
}

fl.BarChartAlignment _resolveAlignment(BarAlignment? alignment) =>
    switch (alignment ?? BarAlignment.spaceEvenly) {
      .start => fl.BarChartAlignment.start,
      .end => fl.BarChartAlignment.end,
      .center => fl.BarChartAlignment.center,
      .spaceEvenly => fl.BarChartAlignment.spaceEvenly,
      .spaceAround => fl.BarChartAlignment.spaceAround,
      .spaceBetween => fl.BarChartAlignment.spaceBetween,
    };

fl.BackgroundBarChartRodData _resolveBackground(BarBackgroundSpec? background) {
  final gradient = background?.gradient;

  return fl.BackgroundBarChartRodData(
    fromY: background?.fromY,
    toY: background?.toY,
    show: background?.show ?? false,
    color: gradient == null
        ? (background?.color ?? const Color(0xFFE2E8F0))
        : null,
    gradient: gradient,
  );
}

BarSpec _mergeBar(BarSpec? base, BarSpec? override) {
  if (base == null) return override ?? const BarSpec();
  if (override == null) return base;
  final paint = flMergePaint(
    baseColor: base.color,
    baseGradient: base.gradient,
    overrideColor: override.color,
    overrideGradient: override.gradient,
  );

  return BarSpec(
    color: paint.color,
    gradient: paint.gradient,
    width: override.width ?? base.width,
    borderRadius: override.borderRadius ?? base.borderRadius,
    border: override.border ?? base.border,
    borderDashArray: override.borderDashArray ?? base.borderDashArray,
    background: _mergeBackground(base.background, override.background),
    label: override.label ?? base.label,
    labelOffset: override.labelOffset ?? base.labelOffset,
    labelAngle: override.labelAngle ?? base.labelAngle,
  );
}

StyleSpec<BarBackgroundSpec>? _mergeBackground(
  StyleSpec<BarBackgroundSpec>? base,
  StyleSpec<BarBackgroundSpec>? override,
) {
  if (base == null) return override;
  if (override == null) return base;
  final paint = flMergePaint(
    baseColor: base.spec.color,
    baseGradient: base.spec.gradient,
    overrideColor: override.spec.color,
    overrideGradient: override.spec.gradient,
  );

  return StyleSpec(
    spec: BarBackgroundSpec(
      show: override.spec.show ?? base.spec.show,
      fromY: override.spec.fromY ?? base.spec.fromY,
      toY: override.spec.toY ?? base.spec.toY,
      color: paint.color,
      gradient: paint.gradient,
    ),
  );
}

BarSegmentSpec _mergeSegment(BarSegmentSpec? base, BarSegmentSpec? override) {
  if (base == null) return override ?? const BarSegmentSpec();
  if (override == null) return base;
  final paint = flMergePaint(
    baseColor: base.color,
    baseGradient: base.gradient,
    overrideColor: override.color,
    overrideGradient: override.gradient,
  );

  return BarSegmentSpec(
    color: paint.color,
    gradient: paint.gradient,
    border: override.border ?? base.border,
    label: override.label ?? base.label,
  );
}

bool _hasSameTopology(List<BarGroup> oldGroups, List<BarGroup> newGroups) {
  if (oldGroups.length != newGroups.length) return false;
  for (var groupIndex = 0; groupIndex < oldGroups.length; groupIndex++) {
    final oldGroup = oldGroups[groupIndex];
    final newGroup = newGroups[groupIndex];
    if (oldGroup.id != newGroup.id ||
        oldGroup.bars.length != newGroup.bars.length) {
      return false;
    }
    for (var barIndex = 0; barIndex < oldGroup.bars.length; barIndex++) {
      final oldBar = oldGroup.bars[barIndex];
      final newBar = newGroup.bars[barIndex];
      if (oldBar.id != newBar.id ||
          oldBar.segments.length != newBar.segments.length) {
        return false;
      }
      for (
        var segmentIndex = 0;
        segmentIndex < oldBar.segments.length;
        segmentIndex++
      ) {
        if (oldBar.segments[segmentIndex].id !=
            newBar.segments[segmentIndex].id) {
          return false;
        }
      }
    }
  }

  return true;
}
