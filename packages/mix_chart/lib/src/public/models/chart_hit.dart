import 'package:flutter/widgets.dart';

/// Common information for a chart interaction hit.
sealed class ChartHit {
  /// Position of the interaction within the chart.
  final Offset localPosition;

  /// Original Flutter pointer event when the renderer provides one.
  final PointerEvent? event;

  const ChartHit({required this.localPosition, required this.event});
}

/// A hit on a line-chart point.
final class LineChartHit extends ChartHit {
  /// Stable public series identifier.
  final Object seriesId;

  /// Stable public point identifier.
  final Object pointId;

  /// Point x value.
  final double x;

  /// Point y value.
  final double y;

  /// Creates a line-chart hit.
  const LineChartHit({
    required this.seriesId,
    required this.pointId,
    required this.x,
    required this.y,
    required super.localPosition,
    required super.event,
  });
}

/// A hit on a bar or stacked bar segment.
final class BarChartHit extends ChartHit {
  /// Stable public group identifier.
  final Object groupId;

  /// Stable public bar identifier.
  final Object barId;

  /// Stable segment identifier when a stacked segment was hit.
  final Object? segmentId;

  /// Lower edge of the hit value.
  final double fromY;

  /// Upper edge of the hit value.
  final double toY;

  /// Creates a bar-chart hit.
  const BarChartHit({
    required this.groupId,
    required this.barId,
    required this.segmentId,
    required this.fromY,
    required this.toY,
    required super.localPosition,
    required super.event,
  });
}

/// A hit on a pie or donut slice.
final class PieChartHit extends ChartHit {
  /// Stable public slice identifier.
  final Object sliceId;

  /// Slice value.
  final double value;

  /// Creates a pie-chart hit.
  const PieChartHit({
    required this.sliceId,
    required this.value,
    required super.localPosition,
    required super.event,
  });
}

/// Builds a custom widget tooltip for a chart hit.
typedef ChartTooltipBuilder =
    Widget Function(BuildContext context, ChartHit hit);

/// Resolves a pointer cursor from the public chart hit under the pointer.
typedef ChartMouseCursorResolver<T extends ChartHit> =
    MouseCursor Function(T? hit);
