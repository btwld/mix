import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../public/models/chart_config.dart';
import '../../public/models/chart_hit.dart';
import '../../public/models/chart_value_format.dart';
import '../../public/models/pie_data.dart';
import '../../public/specs/pie/pie_chart_spec.dart';
import '../../public/specs/pie/pie_slice_spec.dart';
import 'fl_chart_helpers.dart';
import 'fl_chart_tooltip_overlay.dart';

/// Private fl_chart implementation of the public pie-chart contract.
final class FlPieChartAdapter extends StatefulWidget {
  const FlPieChartAdapter({
    required this.slices,
    required this.spec,
    required this.dataTransition,
    required this.selectedSliceIds,
    required this.onSliceHover,
    required this.onSliceTap,
    required this.onSliceLongPress,
    required this.tooltipBuilder,
    required this.mouseCursorResolver,
    required this.valueFormatter,
    super.key,
  });

  final List<PieSlice> slices;
  final PieChartSpec spec;
  final ChartDataTransition dataTransition;
  final Set<Object> selectedSliceIds;
  final ValueChanged<PieChartHit?>? onSliceHover;
  final ValueChanged<PieChartHit>? onSliceTap;
  final ValueChanged<PieChartHit>? onSliceLongPress;
  final ChartTooltipBuilder? tooltipBuilder;
  final ChartMouseCursorResolver<PieChartHit>? mouseCursorResolver;

  final ChartAxisLabelFormatter? valueFormatter;

  @override
  State<FlPieChartAdapter> createState() => _FlPieChartAdapterState();
}

final class _FlPieChartAdapterState extends State<FlPieChartAdapter> {
  PieChartHit? _tooltipHit;
  bool _topologyCompatible = true;

  fl.PieChartSectionData _resolveSlice(
    PieSlice slice,
    PieSliceSpec presentation,
    Color fallbackColor,
    double defaultRadius,
  ) {
    final formatter = widget.valueFormatter ?? formatChartValue;
    final selected = widget.selectedSliceIds.contains(slice.id);

    return fl.PieChartSectionData(
      value: slice.value,
      color: presentation.color ?? fallbackColor,
      gradient: presentation.gradient,
      radius:
          (presentation.radius ?? defaultRadius) +
          (selected ? (widget.spec.selectedSliceRadiusOffset ?? 8.0) : 0),
      showTitle: presentation.showLabel ?? true,
      titleStyle:
          const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 12,
                fontWeight: .w600,
                height: 1.15,
              )
              .merge(widget.spec.slice?.spec.label?.spec.style)
              .merge(presentation.label?.spec.style),
      title: '${slice.label}\n${formatter(slice.value)}',
      borderSide: presentation.border ?? .none,
      cornerRadius: presentation.cornerRadius ?? 0,
      badgeWidget: slice.badge,
      titlePositionPercentageOffset: presentation.labelPosition ?? 0.58,
      badgePositionPercentageOffset: presentation.badgePosition ?? 0.5,
    );
  }

  /// Slice thickness when no style sets one.
  ///
  /// 80 logical pixels when the pie, with room for a selected slice to
  /// expand, fits its box. In a smaller box the slices thin out to fit.
  double _defaultSliceRadius(Size size) {
    final available = math.min(size.width, size.height) / 2;
    if (!available.isFinite) return _preferredSliceRadius;
    final center = widget.spec.centerRadius ?? 0;
    final expansion = math.max(widget.spec.selectedSliceRadiusOffset ?? 8, 0);
    final fitted = available - center - expansion;

    return fitted > 0
        ? math.min(fitted, _preferredSliceRadius)
        : math.max(available - center, 1);
  }

  Widget _buildDefaultTooltip(BuildContext context, ChartHit chartHit) {
    final hit = chartHit as PieChartHit;
    final tooltip = widget.spec.tooltip?.spec;
    final sliceIndex = widget.slices.indexWhere(
      (item) => item.id == hit.sliceId,
    );
    if (sliceIndex < 0) return const SizedBox.shrink();
    final slice = widget.slices[sliceIndex];
    final formatter = widget.valueFormatter ?? formatChartValue;
    final borderSide = tooltip?.border ?? .none;
    final text = tooltip?.text ?? const StyleSpec(spec: TextSpec());

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: tooltip?.maxWidth ?? 180),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tooltip?.backgroundColor ?? const Color(0xFF0F172A),
          border: .fromBorderSide(borderSide),
          borderRadius: tooltip?.borderRadius ?? .circular(10),
        ),
        child: Padding(
          padding:
              tooltip?.padding ?? const .symmetric(vertical: 9, horizontal: 12),
          child: StyledText(
            '${slice.label}\n${formatter(slice.value)}',
            styleSpec: text.copyWith(
              spec: text.spec.copyWith(
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: .w600,
                ).merge(text.spec.style),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTouch(fl.FlTouchEvent event, fl.PieTouchResponse? response) {
    final hit = _pieHit(event, response);
    if (event is fl.FlPointerExitEvent) {
      widget.onSliceHover?.call(null);
      _setTooltipHit(null);

      return;
    }
    if (event is fl.FlPointerHoverEvent || event is fl.FlPointerEnterEvent) {
      widget.onSliceHover?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlTapUpEvent) {
      if (hit != null) widget.onSliceTap?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlLongPressStart && hit != null) {
      widget.onSliceLongPress?.call(hit);
      _setTooltipHit(hit);
    }
  }

  PieChartHit? _pieHit(fl.FlTouchEvent event, fl.PieTouchResponse? response) {
    final index = response?.touchedSection?.touchedSectionIndex ?? -1;
    if (index < 0 || index >= widget.slices.length) return null;
    final slice = widget.slices[index];

    return PieChartHit(
      sliceId: slice.id,
      value: slice.value,
      localPosition: event.localPosition ?? response?.touchLocation ?? .zero,
      event: flPointerEvent(event),
    );
  }

  void _setTooltipHit(PieChartHit? hit) {
    if (hit == _tooltipHit || !mounted) return;
    setState(() => _tooltipHit = hit);
  }

  @override
  void didUpdateWidget(FlPieChartAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _topologyCompatible = _hasSameTopology(oldWidget.slices, widget.slices);
    final hit = _tooltipHit;
    if (hit == null) return;
    if (!_topologyCompatible) {
      _tooltipHit = null;

      return;
    }
    final sliceIndex = widget.slices.indexWhere(
      (slice) => slice.id == hit.sliceId,
    );
    if (sliceIndex < 0 || widget.slices[sliceIndex].value == 0) {
      _tooltipHit = null;

      return;
    }
    final slice = widget.slices[sliceIndex];
    _tooltipHit = PieChartHit(
      sliceId: slice.id,
      value: slice.value,
      localPosition: hit.localPosition,
      event: hit.event,
    );
  }

  @override
  Widget build(BuildContext context) {
    final frame = widget.spec.frame?.spec;
    final hasDrawableData = widget.slices.any((slice) => slice.value > 0);
    Widget chart;

    if (hasDrawableData) {
      final palette = flResolvePalette(widget.spec.palette);
      final presentations = [
        for (final slice in widget.slices)
          _mergeSlice(
            widget.spec.slice?.spec,
            slice.style?.build(context).spec,
          ),
      ];
      final disableAnimations =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      final duration = disableAnimations || !_topologyCompatible
          ? Duration.zero
          : widget.dataTransition.duration;
      chart = FlRendererIntrinsics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final defaultRadius = _defaultSliceRadius(constraints.biggest);
            final sections = [
              for (var index = 0; index < widget.slices.length; index++)
                _resolveSlice(
                  widget.slices[index],
                  presentations[index],
                  palette[index % palette.length],
                  defaultRadius,
                ),
            ];
            final total = widget.slices.fold(
              0.0,
              (sum, slice) => sum + slice.value,
            );
            var angle =
                ((widget.spec.startAngle ?? -90) +
                    (frame?.rotationQuarterTurns ?? 0) * 90) *
                math.pi /
                180;
            for (var index = 0; index < sections.length; index++) {
              final section = sections[index];
              final halfSweep = math.pi * section.value / total;
              final middle = angle + halfSweep;
              angle += halfSweep * 2;
              // Explicit placement may intentionally put text outside the slice.
              if (!section.showTitle ||
                  presentations[index].labelPosition != null) {
                continue;
              }
              final center = widget.spec.centerRadius ?? 0.0;
              final distance = center + section.radius * 0.58;
              final inset = (widget.spec.sliceSpacing ?? 2) / 2 + 2;
              bool fits(String text) {
                final painter = TextPainter(
                  text: TextSpan(
                    text: text,
                    style: DefaultTextStyle.of(context).style
                        .merge(section.titleStyle)
                        .merge(
                          MediaQuery.boldTextOf(context)
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : null,
                        ),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout();
                final width = painter.width / 2;
                final height = painter.height / 2;
                painter.dispose();
                final rotation = widget.spec.sunbeamLabels == true
                    ? 0.0
                    : -middle;
                final cos = math.cos(rotation);
                final sin = math.sin(rotation);
                // Distance from the hole's centre to the oriented text rectangle.
                final nearX = math.max(0.0, (distance * cos).abs() - width);
                final nearY = math.max(0.0, (distance * sin).abs() - height);
                if (center > 0 &&
                    math.sqrt(nearX * nearX + nearY * nearY) < center + 2) {
                  return false;
                }
                for (final x in [-width, width]) {
                  for (final y in [-height, height]) {
                    final radial = distance + x * cos - y * sin;
                    final tangent = x * sin + y * cos;
                    if (math.sqrt(radial * radial + tangent * tangent) >
                        center + section.radius - 2) {
                      return false;
                    }
                    if (halfSweep < math.pi / 2) {
                      if (radial * math.sin(halfSweep) -
                              tangent.abs() * math.cos(halfSweep) <
                          inset) {
                        return false;
                      }
                    } else if (halfSweep < math.pi && radial < inset) {
                      // Conservative for reflex sectors; never bridge adjacent slices.
                      return false;
                    }
                  }
                }
                return true;
              }

              if (!fits(section.title)) {
                final value = (widget.valueFormatter ?? formatChartValue)(
                  section.value,
                );
                sections[index] = section.copyWith(
                  title: value,
                  showTitle: fits(value),
                );
              }
            }
            final data = fl.PieChartData(
              sections: sections,
              centerSpaceRadius: widget.spec.centerRadius ?? 0,
              centerSpaceColor:
                  widget.spec.centerColor ?? const Color(0x00000000),
              sectionsSpace: widget.spec.sliceSpacing ?? 2,
              startDegreeOffset:
                  (widget.spec.startAngle ?? -90) +
                  (frame?.rotationQuarterTurns ?? 0) * 90.0,
              pieTouchData: fl.PieTouchData(
                touchCallback: _handleTouch,
                mouseCursorResolver: widget.mouseCursorResolver == null
                    ? null
                    : (event, response) =>
                          widget.mouseCursorResolver!(_pieHit(event, response)),
              ),
              borderData: flResolveBorder(widget.spec.frame),
              titleSunbeamLayout: widget.spec.sunbeamLabels ?? false,
            );

            return fl.PieChart(
              data,
              duration: duration,
              curve: widget.dataTransition.curve,
            );
          },
        ),
      );
    } else {
      chart = const SizedBox.expand();
    }

    if (frame?.backgroundColor case final color?) {
      chart = ColoredBox(color: color, child: chart);
    }
    if (frame?.clip == true) chart = ClipRect(child: chart);

    return flWrapTooltipOverlay(
      hit: _tooltipHit,
      builder: widget.tooltipBuilder ?? _buildDefaultTooltip,
      margin: widget.spec.tooltip?.spec.margin ?? 12,
      fitHorizontally:
          widget.tooltipBuilder != null ||
          (widget.spec.tooltip?.spec.fitHorizontally ?? true),
      fitVertically:
          widget.tooltipBuilder != null ||
          (widget.spec.tooltip?.spec.fitVertically ?? true),
      child: chart,
    );
  }
}

PieSliceSpec _mergeSlice(PieSliceSpec? base, PieSliceSpec? override) {
  if (base == null) return override ?? const PieSliceSpec();
  if (override == null) return base;
  final paint = flMergePaint(
    baseColor: base.color,
    baseGradient: base.gradient,
    overrideColor: override.color,
    overrideGradient: override.gradient,
  );

  return PieSliceSpec(
    color: paint.color,
    gradient: paint.gradient,
    radius: override.radius ?? base.radius,
    showLabel: override.showLabel ?? base.showLabel,
    label: override.label ?? base.label,
    labelPosition: override.labelPosition ?? base.labelPosition,
    border: override.border ?? base.border,
    cornerRadius: override.cornerRadius ?? base.cornerRadius,
    badgePosition: override.badgePosition ?? base.badgePosition,
  );
}

const _preferredSliceRadius = 80.0;

bool _hasSameTopology(List<PieSlice> oldSlices, List<PieSlice> newSlices) {
  if (oldSlices.length != newSlices.length) return false;
  for (var index = 0; index < oldSlices.length; index++) {
    if (oldSlices[index].id != newSlices[index].id) return false;
  }

  return true;
}
