import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_enums.dart';
import '../shared/chart_area_spec.dart';
import '../shared/chart_marker_spec.dart';
import '../shared/chart_stroke_spec.dart';

part 'line_series_spec.g.dart';

/// Resolved presentation for one line series.
@MixableSpec()
@immutable
final class LineSeriesSpec with _$LineSeriesSpec {
  /// Whether the series is visible.
  @override
  final bool? show;

  /// Line stroke.
  @override
  final StyleSpec<ChartStrokeSpec>? stroke;

  /// Line interpolation mode.
  @override
  final LineCurve? curve;

  /// Smoothness used by curved lines.
  @override
  final double? smoothness;

  /// Whether curved lines guard against overshooting.
  @override
  final bool? preventCurveOvershooting;

  /// Overshoot guard threshold.
  @override
  final double? curveOvershootingThreshold;

  /// Whether stroke caps are rounded.
  @override
  final bool? roundStrokeCap;

  /// Whether stroke joins are rounded.
  @override
  final bool? roundStrokeJoin;

  /// Point marker presentation.
  @override
  final StyleSpec<ChartMarkerSpec>? marker;

  /// Fill below the line.
  @override
  final StyleSpec<ChartAreaSpec>? belowArea;

  /// Fill above the line.
  @override
  final StyleSpec<ChartAreaSpec>? aboveArea;

  /// Line shadow.
  @override
  final Shadow? shadow;

  const LineSeriesSpec({
    this.show,
    this.stroke,
    this.curve,
    this.smoothness,
    this.preventCurveOvershooting,
    this.curveOvershootingThreshold,
    this.roundStrokeCap,
    this.roundStrokeJoin,
    this.marker,
    this.belowArea,
    this.aboveArea,
    this.shadow,
  });
}
