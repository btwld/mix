import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';

/// The side of a Cartesian chart occupied by an axis label.
enum ChartAxisSide { left, top, right, bottom }

/// Backend-neutral information passed to an axis label builder.
@immutable
final class ChartAxisLabel {
  /// Numeric axis value represented by this label.
  final double value;

  /// Text produced by the axis formatter.
  final String formattedValue;

  /// Side on which the label is rendered.
  final ChartAxisSide side;

  /// Minimum visible value of the axis.
  final double min;

  /// Maximum visible value of the axis.
  final double max;

  /// Creates axis label information.
  const ChartAxisLabel({
    required this.value,
    required this.formattedValue,
    required this.side,
    required this.min,
    required this.max,
  });
}

/// Formats a numeric axis value.
typedef ChartAxisLabelFormatter = String Function(double value);

/// Builds an arbitrary Flutter widget for an axis label.
typedef ChartAxisLabelBuilder =
    Widget Function(BuildContext context, ChartAxisLabel label);

/// Numeric axis configuration independent of the rendering backend.
///
/// Unset values follow common charting practice. Ticks fall on a round step
/// (1, 2 or 5 times a power of ten) chosen for the space available, and never
/// on fractions when every value on the axis is a whole number. A value-axis
/// bound left to the data is rounded out to that step, so the first and last
/// ticks are round numbers too.
@immutable
final class ChartAxis {
  /// Explicit lower bound, or null to derive it from the data.
  ///
  /// A derived value-axis bound is rounded down to the tick step.
  final double? min;

  /// Explicit upper bound, or null to derive it from the data.
  ///
  /// A derived value-axis bound is rounded up to the tick step.
  final double? max;

  /// Tick interval, or null to choose a round step from the data range and the
  /// available space.
  ///
  /// Grid lines follow this interval unless the grid sets its own.
  final double? interval;

  /// Optional text formatter used by default labels and semantics.
  final ChartAxisLabelFormatter? labelFormatter;

  /// Optional widget builder that replaces the default text label.
  final ChartAxisLabelBuilder? labelBuilder;

  /// Optional widget displayed as the axis name.
  final Widget? name;

  final bool? _minIncluded;
  final bool? _maxIncluded;

  const ChartAxis._({
    required this.min,
    required this.max,
    required this.interval,
    required this._minIncluded,
    required this._maxIncluded,
    required this.labelFormatter,
    required this.labelBuilder,
    required this.name,
  });

  /// Creates a numeric axis.
  ///
  /// [minIncluded] and [maxIncluded] force a label at the axis bound even when
  /// the bound is not on a tick. Set them to false to never label the bound.
  /// When they are not set, a bound is labelled only when it falls on a tick,
  /// so a label at an arbitrary data value never crowds the round ticks.
  factory ChartAxis.numeric({
    double? min,
    double? max,
    double? interval,
    bool? minIncluded,
    bool? maxIncluded,
    ChartAxisLabelFormatter? labelFormatter,
    ChartAxisLabelBuilder? labelBuilder,
    Widget? name,
  }) {
    _requireFinite('min', min);
    _requireFinite('max', max);
    _requireFinite('interval', interval);
    if (interval != null && interval <= 0) {
      throw ArgumentError.value(interval, 'interval', 'Must be greater than 0');
    }
    if (min != null && max != null && min >= max) {
      throw ArgumentError.value(
        (min, max),
        'min/max',
        'min must be less than max',
      );
    }

    return ChartAxis._(
      min: min,
      max: max,
      interval: interval,
      minIncluded: minIncluded,
      maxIncluded: maxIncluded,
      labelFormatter: labelFormatter,
      labelBuilder: labelBuilder,
      name: name,
    );
  }

  /// Whether the minimum value is always included as a label.
  ///
  /// False when not set explicitly: the bound is then labelled only when it
  /// falls on a tick.
  bool get minIncluded => _minIncluded ?? false;

  /// Whether the maximum value is always included as a label.
  ///
  /// False when not set explicitly: the bound is then labelled only when it
  /// falls on a tick.
  bool get maxIncluded => _maxIncluded ?? false;

  /// Whether the lower bound gets a label, given whether it falls on a tick.
  @internal
  bool labelsMin({required bool onTick}) => _minIncluded ?? onTick;

  /// Whether the upper bound gets a label, given whether it falls on a tick.
  @internal
  bool labelsMax({required bool onTick}) => _maxIncluded ?? onTick;
}

/// Axes affected by Cartesian chart pan and zoom.
enum ChartScaleAxis { none, horizontal, vertical, both }

/// Pan and zoom configuration for line and bar charts.
@immutable
final class ChartViewport {
  /// Axes that may be transformed.
  final ChartScaleAxis axis;

  /// Minimum allowed scale.
  final double minScale;

  /// Maximum allowed scale.
  final double maxScale;

  /// Whether pointer panning is enabled.
  final bool panEnabled;

  /// Whether pointer or trackpad scaling is enabled.
  final bool scaleEnabled;

  /// Whether trackpad scrolling changes scale.
  final bool trackpadScrollCausesScale;

  /// Optional Flutter controller for programmatic transformations.
  final TransformationController? controller;

  /// A viewport with pan and zoom disabled.
  static final none = ChartViewport();

  const ChartViewport._({
    required this.axis,
    required this.minScale,
    required this.maxScale,
    required this.panEnabled,
    required this.scaleEnabled,
    required this.trackpadScrollCausesScale,
    required this.controller,
  });

  /// Creates viewport behavior.
  factory ChartViewport({
    ChartScaleAxis axis = .none,
    double minScale = 1,
    double maxScale = 2.5,
    bool panEnabled = true,
    bool scaleEnabled = true,
    bool trackpadScrollCausesScale = false,
    TransformationController? controller,
  }) {
    if (!minScale.isFinite || minScale < 1) {
      throw ArgumentError.value(
        minScale,
        'minScale',
        'Must be finite and at least 1',
      );
    }
    if (!maxScale.isFinite || maxScale < minScale) {
      throw ArgumentError.value(
        maxScale,
        'maxScale',
        'Must be finite and at least minScale',
      );
    }

    return ChartViewport._(
      axis: axis,
      minScale: minScale,
      maxScale: maxScale,
      panEnabled: panEnabled,
      scaleEnabled: scaleEnabled,
      trackpadScrollCausesScale: trackpadScrollCausesScale,
      controller: controller,
    );
  }
}

/// Curve-based interpolation for compatible chart data updates.
@immutable
final class ChartDataTransition {
  /// Transition duration.
  final Duration duration;

  /// Transition curve.
  final Curve curve;

  /// Disables renderer-owned data interpolation.
  static const none = ChartDataTransition(duration: .zero);

  /// Creates a chart data transition.
  const ChartDataTransition({
    required this.duration,
    this.curve = Curves.linear,
  });

  /// Creates an ease-in-out data transition.
  factory ChartDataTransition.easeInOut(Duration duration) =>
      ChartDataTransition(duration: duration, curve: Curves.easeInOut);
}

void _requireFinite(String name, double? value) {
  if (value != null && !value.isFinite) {
    throw ArgumentError.value(value, name, 'Must be finite');
  }
}
