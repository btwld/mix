import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../public/models/chart_config.dart';
import '../../public/models/chart_enums.dart';
import '../../public/models/chart_hit.dart';
import '../../public/models/line_data.dart';
import '../../public/specs/line/line_chart_spec.dart';
import '../../public/specs/line/line_series_spec.dart';
import '../../public/specs/shared/chart_area_spec.dart';
import '../../public/specs/shared/chart_marker_spec.dart';
import '../../public/specs/shared/chart_stroke_spec.dart';
import 'fl_chart_helpers.dart';
import 'fl_chart_tooltip_overlay.dart';

/// Private fl_chart implementation of the public line-chart contract.
final class FlLineChartAdapter extends StatefulWidget {
  const FlLineChartAdapter({
    required this.series,
    required this.spec,
    required this.xAxis,
    required this.yAxis,
    required this.topAxis,
    required this.rightAxis,
    required this.viewport,
    required this.dataTransition,
    required this.selectedPoints,
    required this.onPointHover,
    required this.onPointTap,
    required this.onPointLongPress,
    required this.tooltipBuilder,
    required this.hitTestRadius,
    required this.mouseCursorResolver,
    super.key,
  });

  final List<LineSeries> series;
  final LineChartSpec spec;
  final ChartAxis? xAxis;
  final ChartAxis? yAxis;
  final ChartAxis? topAxis;
  final ChartAxis? rightAxis;
  final ChartViewport? viewport;
  final ChartDataTransition dataTransition;
  final Set<LinePointKey> selectedPoints;
  final ValueChanged<LineChartHit?>? onPointHover;
  final ValueChanged<LineChartHit>? onPointTap;
  final ValueChanged<LineChartHit>? onPointLongPress;
  final ChartTooltipBuilder? tooltipBuilder;
  final double hitTestRadius;

  final ChartMouseCursorResolver<LineChartHit>? mouseCursorResolver;

  @override
  State<FlLineChartAdapter> createState() => _FlLineChartAdapterState();
}

final class _FlLineChartAdapterState extends State<FlLineChartAdapter> {
  ChartHit? _tooltipHit;
  bool _topologyCompatible = true;

  bool _isPointSelected(LineSeries series, ChartPoint point) => widget
      .selectedPoints
      .contains(LinePointKey(seriesId: series.id, pointId: point.id));

  fl.LineChartBarData _resolveSeries(
    LineSeries series,
    LineSeriesSpec presentation,
    Color fallbackColor,
  ) {
    final stroke = presentation.stroke?.spec;
    final opacity = (stroke?.opacity ?? 1).clamp(0.0, 1.0);
    final baseColor = (stroke?.color ?? fallbackColor).withValues(
      alpha: (stroke?.color ?? fallbackColor).a * opacity,
    );
    final gradient = stroke?.gradient?.withOpacity(opacity);
    final marker = presentation.marker?.spec;
    final hasSelectedPoint = series.points.any(
      (point) => _isPointSelected(series, point),
    );
    final curve = presentation.curve ?? .straight;

    return fl.LineChartBarData(
      spots: series.points
          .map(
            (point) => point.y == null
                ? fl.FlSpot.nullSpot
                : fl.FlSpot(point.x, point.y!),
          )
          .toList(growable: false),
      show: presentation.show ?? true,
      color: gradient == null ? baseColor : null,
      gradient: gradient,
      barWidth: stroke?.width ?? 2.5,
      isCurved: curve == .curved,
      curveSmoothness: presentation.smoothness ?? 0.35,
      preventCurveOverShooting: presentation.preventCurveOvershooting ?? false,
      preventCurveOvershootingThreshold:
          presentation.curveOvershootingThreshold ?? 10,
      isStrokeCapRound: presentation.roundStrokeCap ?? true,
      isStrokeJoinRound: presentation.roundStrokeJoin ?? true,
      belowBarData: _resolveArea(presentation.belowArea?.spec, baseColor),
      aboveBarData: _resolveArea(presentation.aboveArea?.spec, baseColor),
      dotData: fl.FlDotData(
        show: (marker?.show ?? false) || hasSelectedPoint,
        checkToShowDot: (spot, bar) {
          final pointIndex = bar.spots.indexWhere(
            (candidate) => identical(candidate, spot),
          );
          if (pointIndex < 0 || pointIndex >= series.points.length) {
            return false;
          }

          return (marker?.show ?? false) ||
              _isPointSelected(series, series.points[pointIndex]);
        },
        getDotPainter: (_, _, _, pointIndex) {
          final selected =
              pointIndex < series.points.length &&
              _isPointSelected(series, series.points[pointIndex]);

          return _resolveMarker(marker, baseColor, selected);
        },
      ),
      dashArray: stroke?.dashArray,
      shadow: presentation.shadow ?? const Shadow(color: Colors.transparent),
      isStepLineChart: switch (curve) {
        .stepBefore || .stepMiddle || .stepAfter => true,
        .straight || .curved => false,
      },
      lineChartStepData: fl.LineChartStepData(
        stepDirection: switch (curve) {
          .stepBefore => fl.LineChartStepData.stepDirectionBackward,
          .stepMiddle => fl.LineChartStepData.stepDirectionMiddle,
          .stepAfter => fl.LineChartStepData.stepDirectionForward,
          .straight || .curved => fl.LineChartStepData.stepDirectionMiddle,
        },
      ),
    );
  }

  fl.LineTouchData _resolveTouchData() {
    final tooltip = widget.spec.tooltip?.spec;
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: .w600,
    ).merge(tooltip?.text?.spec.style);
    final formatter =
        widget.yAxis?.labelFormatter ?? (double value) => '$value';

    return fl.LineTouchData(
      touchCallback: _handleTouch,
      mouseCursorResolver: widget.mouseCursorResolver == null
          ? null
          : (event, response) =>
                widget.mouseCursorResolver!(_lineHit(event, response)),
      touchTooltipData: fl.LineTouchTooltipData(
        tooltipBorderRadius: tooltip?.borderRadius ?? .circular(10),
        tooltipPadding:
            tooltip?.padding ?? const .symmetric(vertical: 9, horizontal: 12),
        tooltipMargin: tooltip?.margin ?? 12,
        maxContentWidth: tooltip?.maxWidth ?? 180,
        getTooltipItems: (spots) => spots
            .map((spot) {
              final series = widget.series[spot.barIndex];

              return fl.LineTooltipItem(
                '${series.label}\n${formatter(spot.y)}',
                textStyle,
              );
            })
            .toList(growable: false),
        getTooltipColor: (_) =>
            tooltip?.backgroundColor ?? const Color(0xFF0F172A),
        fitInsideHorizontally: tooltip?.fitHorizontally ?? true,
        fitInsideVertically: tooltip?.fitVertically ?? true,
        tooltipBorder: tooltip?.border ?? .none,
      ),
      touchSpotThreshold: widget.hitTestRadius,
      handleBuiltInTouches: widget.tooltipBuilder == null,
    );
  }

  void _handleTouch(fl.FlTouchEvent event, fl.LineTouchResponse? response) {
    final hit = _lineHit(event, response);

    if (event is fl.FlPointerExitEvent) {
      widget.onPointHover?.call(null);
      _setTooltipHit(null);

      return;
    }
    if (event is fl.FlPointerHoverEvent || event is fl.FlPointerEnterEvent) {
      widget.onPointHover?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlTapUpEvent && hit != null) {
      widget.onPointTap?.call(hit);
      _setTooltipHit(hit);

      return;
    }
    if (event is fl.FlLongPressStart && hit != null) {
      widget.onPointLongPress?.call(hit);
      _setTooltipHit(hit);
    }
  }

  LineChartHit? _lineHit(
    fl.FlTouchEvent event,
    fl.LineTouchResponse? response,
  ) {
    final spot = response?.lineBarSpots?.firstOrNull;
    if (spot == null || spot.barIndex >= widget.series.length) return null;
    final series = widget.series[spot.barIndex];
    if (spot.spotIndex >= series.points.length) return null;
    final point = series.points[spot.spotIndex];
    if (point.y == null) return null;

    return LineChartHit(
      seriesId: series.id,
      pointId: point.id,
      x: point.x,
      y: point.y!,
      localPosition: event.localPosition ?? response?.touchLocation ?? .zero,
      event: flPointerEvent(event),
    );
  }

  void _setTooltipHit(ChartHit? hit) {
    if (widget.tooltipBuilder == null || hit == _tooltipHit || !mounted) return;
    setState(() => _tooltipHit = hit);
  }

  @override
  void didUpdateWidget(FlLineChartAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _topologyCompatible = _hasSameTopology(oldWidget.series, widget.series);
  }

  @override
  Widget build(BuildContext context) {
    final palette = flResolvePalette(widget.spec.palette);
    final bars = <fl.LineChartBarData>[];

    for (var index = 0; index < widget.series.length; index++) {
      final series = widget.series[index];
      final override = series.style?.build(context).spec;
      final presentation = _mergeSeries(widget.spec.series?.spec, override);
      bars.add(
        _resolveSeries(series, presentation, palette[index % palette.length]),
      );
    }

    final frame = widget.spec.frame?.spec;
    final data = fl.LineChartData(
      lineBarsData: bars,
      titlesData: flResolveTitles(
        context: context,
        commonStyle: widget.spec.axis,
        xStyle: widget.spec.xAxis,
        yStyle: widget.spec.yAxis,
        topStyle: widget.spec.topAxis,
        rightStyle: widget.spec.rightAxis,
        xAxis: widget.xAxis,
        yAxis: widget.yAxis,
        topAxis: widget.topAxis,
        rightAxis: widget.rightAxis,
      ),
      lineTouchData: _resolveTouchData(),
      gridData: flResolveGrid(widget.spec.grid),
      borderData: flResolveBorder(widget.spec.frame),
      minX: widget.xAxis?.min,
      maxX: widget.xAxis?.max,
      minY: widget.yAxis?.min,
      maxY: widget.yAxis?.max,
      clipData: frame?.clip == true
          ? const fl.FlClipData.all()
          : const fl.FlClipData.none(),
      backgroundColor: frame?.backgroundColor,
      rotationQuarterTurns: frame?.rotationQuarterTurns ?? 0,
    );
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations || !_topologyCompatible
        ? Duration.zero
        : widget.dataTransition.duration;
    final chart = fl.LineChart(
      data,
      duration: duration,
      curve: widget.dataTransition.curve,
      transformationConfig: flResolveViewport(widget.viewport),
    );

    return flWrapTooltipOverlay(
      hit: _tooltipHit,
      builder: widget.tooltipBuilder,
      margin: widget.spec.tooltip?.spec.margin ?? 12,
      child: chart,
    );
  }
}

fl.BarAreaData _resolveArea(ChartAreaSpec? area, Color fallbackColor) {
  final gradient = area?.gradient;

  return fl.BarAreaData(
    show: area?.show ?? false,
    color: gradient == null
        ? (area?.color ?? fallbackColor.withValues(alpha: 0.14))
        : null,
    gradient: gradient,
    cutOffY: area?.cutoffY ?? 0,
    applyCutOffY: area?.applyCutoff ?? false,
  );
}

fl.FlDotPainter _resolveMarker(
  ChartMarkerSpec? marker,
  Color fallbackColor,
  bool selected,
) {
  final radius = (marker?.radius ?? 4) * (selected ? 1.35 : 1);
  final color = marker?.color ?? fallbackColor;
  final borderColor = marker?.borderColor ?? Colors.white;
  final borderWidth = marker?.borderWidth ?? 2;

  final painter = switch (marker?.shape ?? ChartMarkerShape.circle) {
    .circle => fl.FlDotCirclePainter(
      color: color,
      radius: radius,
      strokeColor: borderColor,
      strokeWidth: borderWidth,
    ),
    .square => fl.FlDotSquarePainter(
      color: color,
      size: radius * 2,
      strokeColor: borderColor,
      strokeWidth: borderWidth,
    ),
    .cross => fl.FlDotCrossPainter(
      color: color,
      size: radius * 2,
      width: borderWidth == 0 ? 2 : borderWidth,
    ),
  };
  final shadow = marker?.shadow;

  return shadow == null || shadow.color.a == 0
      ? painter
      : _ShadowedDotPainter(painter: painter, shadow: shadow);
}

final class _ShadowedDotPainter extends fl.FlDotPainter {
  final fl.FlDotPainter painter;
  final Shadow shadow;

  const _ShadowedDotPainter({required this.painter, required this.shadow});

  @override
  void draw(Canvas canvas, fl.FlSpot spot, Offset offsetInCanvas) {
    final size = painter.getSize(spot);
    canvas.drawCircle(
      offsetInCanvas + shadow.offset,
      size.longestSide / 2,
      Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(.normal, shadow.blurSigma),
    );
    painter.draw(canvas, spot, offsetInCanvas);
  }

  @override
  Size getSize(fl.FlSpot spot) => painter.getSize(spot);

  @override
  bool hitTest(
    fl.FlSpot spot,
    Offset touched,
    Offset center,
    double extraThreshold,
  ) => painter.hitTest(spot, touched, center, extraThreshold);

  @override
  fl.FlDotPainter lerp(fl.FlDotPainter a, fl.FlDotPainter b, double t) => b;

  @override
  Color get mainColor => painter.mainColor;

  @override
  List<Object?> get props => [painter, shadow];
}

LineSeriesSpec _mergeSeries(LineSeriesSpec? base, LineSeriesSpec? override) {
  if (base == null) return override ?? const LineSeriesSpec();
  if (override == null) return base;

  return LineSeriesSpec(
    show: override.show ?? base.show,
    stroke: _mergeNested(base.stroke, override.stroke, _mergeStroke),
    curve: override.curve ?? base.curve,
    smoothness: override.smoothness ?? base.smoothness,
    preventCurveOvershooting:
        override.preventCurveOvershooting ?? base.preventCurveOvershooting,
    curveOvershootingThreshold:
        override.curveOvershootingThreshold ?? base.curveOvershootingThreshold,
    roundStrokeCap: override.roundStrokeCap ?? base.roundStrokeCap,
    roundStrokeJoin: override.roundStrokeJoin ?? base.roundStrokeJoin,
    marker: _mergeNested(base.marker, override.marker, _mergeMarker),
    belowArea: _mergeNested(base.belowArea, override.belowArea, _mergeArea),
    aboveArea: _mergeNested(base.aboveArea, override.aboveArea, _mergeArea),
    shadow: override.shadow ?? base.shadow,
  );
}

StyleSpec<T>? _mergeNested<T extends Spec<T>>(
  StyleSpec<T>? base,
  StyleSpec<T>? override,
  T Function(T base, T override) merge,
) {
  if (base == null) return override;
  if (override == null) return base;

  return StyleSpec(spec: merge(base.spec, override.spec));
}

ChartStrokeSpec _mergeStroke(ChartStrokeSpec base, ChartStrokeSpec override) {
  final paint = flMergePaint(
    baseColor: base.color,
    baseGradient: base.gradient,
    overrideColor: override.color,
    overrideGradient: override.gradient,
  );

  return ChartStrokeSpec(
    color: paint.color,
    gradient: paint.gradient,
    width: override.width ?? base.width,
    dashArray: override.dashArray ?? base.dashArray,
    opacity: override.opacity ?? base.opacity,
  );
}

ChartMarkerSpec _mergeMarker(ChartMarkerSpec base, ChartMarkerSpec override) =>
    .new(
      show: override.show ?? base.show,
      shape: override.shape ?? base.shape,
      color: override.color ?? base.color,
      radius: override.radius ?? base.radius,
      borderColor: override.borderColor ?? base.borderColor,
      borderWidth: override.borderWidth ?? base.borderWidth,
      shadow: override.shadow ?? base.shadow,
    );

ChartAreaSpec _mergeArea(ChartAreaSpec base, ChartAreaSpec override) {
  final paint = flMergePaint(
    baseColor: base.color,
    baseGradient: base.gradient,
    overrideColor: override.color,
    overrideGradient: override.gradient,
  );

  return ChartAreaSpec(
    show: override.show ?? base.show,
    color: paint.color,
    gradient: paint.gradient,
    cutoffY: override.cutoffY ?? base.cutoffY,
    applyCutoff: override.applyCutoff ?? base.applyCutoff,
  );
}

bool _hasSameTopology(List<LineSeries> oldSeries, List<LineSeries> newSeries) {
  if (oldSeries.length != newSeries.length) return false;
  for (var seriesIndex = 0; seriesIndex < oldSeries.length; seriesIndex++) {
    final oldItem = oldSeries[seriesIndex];
    final newItem = newSeries[seriesIndex];
    if (oldItem.id != newItem.id ||
        oldItem.points.length != newItem.points.length) {
      return false;
    }
    for (var pointIndex = 0; pointIndex < oldItem.points.length; pointIndex++) {
      final oldPoint = oldItem.points[pointIndex];
      final newPoint = newItem.points[pointIndex];
      if (oldPoint.id != newPoint.id ||
          (oldPoint.y == null) != (newPoint.y == null)) {
        return false;
      }
    }
  }

  return true;
}
