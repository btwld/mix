import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../public/models/chart_config.dart';

/// Plot length per tick interval targeted by the automatic step.
///
/// This is the figure fl_chart uses for its own automatic interval, so charts
/// keep the tick density they had.
const flPixelsPerInterval = 40.0;

/// Smallest plot length allowed per interval after bounds are rounded out.
///
/// Leaves about 10px between default labels, which are 11px text on a 1.2
/// line height.
const _minPixelsPerInterval = 24.0;

/// Plot length assumed when the available one is unknown or not positive.
const _fallbackExtent = 200.0;

/// Times the step may be widened to space out ticks after rounding.
///
/// Each widening at least doubles the step, so this covers a 256-fold
/// shortfall; the loop usually ends after one or two.
const _maxStepWidenings = 8;

/// Fraction of the value a zero-width range is widened by on each side.
const _flatRangePadding = 0.05;

/// Tolerance, in steps, for treating a value as lying on a tick.
const _tickTolerance = 1e-6;

/// Data extent of one Cartesian axis.
typedef FlAxisData = ({double min, double max, bool wholeNumbers});

/// Bounds and tick step resolved for one numeric Cartesian axis.
@immutable
final class FlAxisScale {
  /// Bound passed to the renderer, or null to let it derive one.
  final double? min;

  /// Bound passed to the renderer, or null to let it derive one.
  final double? max;

  /// Step the ticks fall on, or null when there is nothing to scale.
  final double? step;

  /// Interval passed to the renderer for labels and grid lines.
  ///
  /// Null on a zoomable axis without an explicit interval, so the renderer
  /// keeps choosing a finer step as the viewport zooms in.
  final double? interval;

  const FlAxisScale({
    required this.min,
    required this.max,
    required this.step,
    required this.interval,
  });

  /// Origin the renderer counts ticks from.
  ///
  /// The lower bound when it lies on every interval in [intervals], so the
  /// renderer's first tick lands on it exactly; zero otherwise, including
  /// when the renderer chooses the interval itself while zooming.
  double baselineFor(Iterable<double?> intervals) {
    final min = this.min;
    if (min == null || interval == null) return 0;
    for (final interval in intervals) {
      if (interval != null && !flIsOnTick(min, interval)) return 0;
    }

    return min;
  }

  /// Label settings for [axis] when it is drawn along this scale.
  ({double? interval, bool minIncluded, bool maxIncluded}) titlesFor(
    ChartAxis? axis,
  ) {
    final tickStep = axis?.interval ?? step;
    final minOnTick = _boundOnTick(min, tickStep);
    final maxOnTick = _boundOnTick(max, tickStep);

    return (
      interval: axis?.interval ?? interval,
      minIncluded: axis?.labelsMin(onTick: minOnTick) ?? minOnTick,
      maxIncluded: axis?.labelsMax(onTick: maxOnTick) ?? maxOnTick,
    );
  }
}

/// Resolves the bounds and tick step of a numeric axis.
///
/// Explicit [ChartAxis] values always win. Otherwise the step is a round
/// number (1, 2 or 5 times a power of ten) giving about one interval per
/// [flPixelsPerInterval] of [extent], and at least 1 when [data] holds only
/// whole numbers. With [roundBounds], a bound taken from [data] is rounded out
/// to the step. A zero-width data range is widened so the data sits inside
/// the plot rather than on its edge.
FlAxisScale flResolveAxisScale({
  required ChartAxis? axis,
  required FlAxisData? data,
  required double extent,
  required bool roundBounds,
  required bool zoomable,
}) {
  final explicitMin = axis?.min;
  final explicitMax = axis?.max;
  final explicitStep = axis?.interval;
  if (data == null) {
    return FlAxisScale(
      min: explicitMin,
      max: explicitMax,
      step: explicitStep,
      interval: explicitStep,
    );
  }
  var low = explicitMin ?? data.min;
  var high = explicitMax ?? data.max;
  final wholeNumbers = data.wholeNumbers;
  if (high <= low) {
    (low, high) = _widen(
      low: low,
      high: high,
      minIsExplicit: explicitMin != null,
      maxIsExplicit: explicitMax != null,
      roundBounds: roundBounds,
      wholeNumbers: wholeNumbers,
    );
  }

  final length = extent.isFinite && extent > 0 ? extent : _fallbackExtent;
  final count = math.max(length ~/ flPixelsPerInterval, 1);
  var step = explicitStep ?? flNiceStep((high - low) / count);
  if (explicitStep == null && wholeNumbers) step = math.max(step, 1);

  (double, double) bounds() => (
    explicitMin ?? (roundBounds ? _floorToStep(low, step) : low),
    explicitMax ?? (roundBounds ? _ceilToStep(high, step) : high),
  );
  var (min, max) = bounds();
  if (explicitStep == null) {
    // Rounding the bounds out adds up to two intervals. Widen the step when
    // that leaves the ticks too close together for the space.
    for (var attempt = 0; attempt < _maxStepWidenings; attempt++) {
      final intervals = (max - min) / step;
      if (intervals <= 1 || length / intervals >= _minPixelsPerInterval) break;
      step = _nextNiceStep(step);
      (min, max) = bounds();
    }
  }

  return FlAxisScale(
    min: min,
    max: max,
    step: step,
    interval: zoomable ? explicitStep : step,
  );
}

/// Rounds [rough] to 1, 2, 5 or 10 times a power of ten.
///
/// Uses fl_chart's thresholds, so an automatic step matches the one the
/// renderer would have picked for the same range and space.
double flNiceStep(double rough) {
  if (!rough.isFinite || rough <= 0) return 1;
  final magnitude = _powerOfTen((math.log(rough) / math.ln10).floor());
  final fraction = rough / magnitude;
  final nice = fraction >= 7.6
      ? 10
      : fraction >= 2.6
      ? 5
      : fraction >= 1.6
      ? 2
      : 1;

  return _clean(nice * magnitude);
}

double _nextNiceStep(double step) {
  final magnitude = _powerOfTen(
    (math.log(step) / math.ln10 + _tickTolerance).floor(),
  );
  final fraction = (step / magnitude).round();

  return _clean(
    switch (fraction) {
          1 => 2,
          2 => 5,
          _ => 10,
        } *
        magnitude,
  );
}

double _powerOfTen(int exponent) => exponent >= 0
    ? math.pow(10, exponent).toDouble()
    : 1 / math.pow(10, -exponent);

/// Drops binary noise such as the 4 in 0.30000000000000004.
double _clean(double value) => double.parse(value.toStringAsPrecision(12));

double _floorToStep(double value, double step) => _cleanMultiple(
  (value / step + _tickTolerance).floorToDouble() * step,
  step,
);

double _ceilToStep(double value, double step) =>
    _cleanMultiple((value / step - _tickTolerance).ceilToDouble() * step, step);

/// Drops binary noise from a multiple of [step], as [_clean] does.
///
/// A value many steps from zero keeps more digits, so cleaning never moves
/// it by more than [_tickTolerance] steps: 1698797425999 stays put.
double _cleanMultiple(double value, double step) {
  if (value == 0) return value;
  final stepDigits = (math.log((value / step).abs()) / math.ln10).ceil();
  // Six digits for the tolerance, one for rounding; 17 round-trips exactly.
  final digits = (stepDigits + 7).clamp(12, 17);

  return double.parse(value.toStringAsPrecision(digits));
}

/// Whether [value] lies on a multiple of [step].
bool flIsOnTick(double value, double step) {
  final ticks = value / step;

  return (ticks - ticks.roundToDouble()).abs() <= _tickTolerance;
}

bool _boundOnTick(double? bound, double? step) =>
    bound == null || step == null || flIsOnTick(bound, step);

(double, double) _widen({
  required double low,
  required double high,
  required bool minIsExplicit,
  required bool maxIsExplicit,
  required bool roundBounds,
  required bool wholeNumbers,
}) {
  double padding(double value) => roundBounds
      ? (value == 0 ? 1 : value.abs() * _flatRangePadding)
      : (wholeNumbers || value == 0 ? 0.5 : value.abs() * _flatRangePadding);

  if (minIsExplicit) return (low, low + padding(low));
  if (maxIsExplicit) return (high - padding(high), high);
  // Every value is the same. A value axis keeps zero as its floor.
  if (roundBounds && low == 0) return (0, 1);

  return (low - padding(low), high + padding(high));
}

/// The values the renderer labels along an axis, in order.
///
/// Mirrors fl_chart's own iteration, so label sizes can be measured before
/// layout.
Iterable<double> flTickValues({
  required double min,
  required double max,
  required double interval,
  required double baseline,
  required bool minIncluded,
  required bool maxIncluded,
}) sync* {
  if (!(max > min) || !(interval > 0)) return;
  final offset = (baseline - min) % interval;
  final first = (max - min).abs() <= offset || offset == 0 ? min : min + offset;
  final firstIsMin = first == min;
  final epsilon = interval / 100000;
  if (minIncluded && !firstIsMin) yield min;
  var index = !minIncluded && firstIsMin ? 1 : 0;
  var reachedMax = false;
  while (index < 10000) {
    final value = first + index * interval;
    final overshoot = value - max;
    if (overshoot > epsilon) break;
    if (overshoot.abs() <= epsilon) {
      if (maxIncluded) yield max;
      reachedMax = true;
      break;
    }
    yield value;
    index++;
  }
  if (maxIncluded && !reachedMax) yield max;
}

/// Formats a tick the way fl_chart 1.3 does: K, M and B suffixes, with as
/// many decimals as the step needs.
///
/// Owning it keeps tick text the same on every supported fl_chart version
/// (1.2 rounds every suffixed tick to one decimal, so 1050 and 1100 both read
/// 1.1K) and lets label sizes be measured before layout.
String flFormatTick(double min, double max, double value, double interval) {
  final negative = value < 0;
  final magnitude = value.abs();
  final range = (min - max).abs();
  final step = math.min(range, interval);
  final (divisor, symbol) = magnitude >= 1e9
      ? (1e9, 'B')
      : magnitude >= 1e6
      ? (1e6, 'M')
      : magnitude >= 1e3
      ? (1e3, 'K')
      : (1.0, '');
  var number = (magnitude / divisor).toStringAsFixed(
    _fractionDigits(step / divisor),
  );
  if (number.contains('.')) number = number.replaceFirst(RegExp(r'\.?0+$'), '');
  if (negative) number = '-$number';
  if (number == '-0') number = '0';

  return number + symbol;
}

const _fractionDigitLimits = [
  1.0,
  0.1,
  0.01,
  0.001,
  0.0001,
  0.00001,
  0.000001,
  0.0000001,
  0.00000001,
];

int _fractionDigits(double value) {
  for (final (index, limit) in _fractionDigitLimits.indexed) {
    if (value >= limit) return index + 1;
  }

  return value > 0 ? 10 : 1;
}
