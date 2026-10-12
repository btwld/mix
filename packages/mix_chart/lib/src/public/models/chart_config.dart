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
@immutable
final class ChartAxis {
  /// Explicit lower bound, or null to derive it from the data.
  final double? min;

  /// Explicit upper bound, or null to derive it from the data.
  final double? max;

  /// Tick interval, or null to let the renderer calculate it.
  final double? interval;

  /// Whether the minimum value is always included as a label.
  final bool minIncluded;

  /// Whether the maximum value is always included as a label.
  final bool maxIncluded;

  /// Optional text formatter used by default labels and semantics.
  final ChartAxisLabelFormatter? labelFormatter;

  /// Optional widget builder that replaces the default text label.
  final ChartAxisLabelBuilder? labelBuilder;

  /// Optional widget displayed as the axis name.
  final Widget? name;

  const ChartAxis._({
    required this.min,
    required this.max,
    required this.interval,
    required this.minIncluded,
    required this.maxIncluded,
    required this.labelFormatter,
    required this.labelBuilder,
    required this.name,
  });

  /// Creates a numeric axis.
  factory ChartAxis.numeric({
    double? min,
    double? max,
    double? interval,
    bool minIncluded = true,
    bool maxIncluded = true,
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
