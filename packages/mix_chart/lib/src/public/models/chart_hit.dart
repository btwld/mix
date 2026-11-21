import 'package:flutter/widgets.dart';

/// Hierarchical identity for one selectable point in a line chart.
@immutable
final class LinePointKey {
  /// Stable public series identifier.
  final Object seriesId;

  /// Stable public point identifier within [seriesId].
  final Object pointId;

  /// Creates a line-point selection key.
  const LinePointKey({required this.seriesId, required this.pointId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinePointKey &&
          seriesId == other.seriesId &&
          pointId == other.pointId;

  @override
  String toString() => 'LinePointKey(seriesId: $seriesId, pointId: $pointId)';

  @override
  int get hashCode => Object.hash(seriesId, pointId);
}

/// Hierarchical identity for one selectable bar or stacked segment.
@immutable
final class BarSelectionKey {
  /// Stable public group identifier.
  final Object groupId;

  /// Stable public bar identifier within [groupId].
  final Object barId;

  /// Stable segment identifier within [barId], or null for the whole bar.
  final Object? segmentId;

  const BarSelectionKey._({
    required this.groupId,
    required this.barId,
    required this.segmentId,
  });

  /// Creates a selection key for a whole bar.
  const BarSelectionKey.bar({required Object groupId, required Object barId})
    : this._(groupId: groupId, barId: barId, segmentId: null);

  /// Creates a selection key for a stacked bar segment.
  const BarSelectionKey.segment({
    required Object groupId,
    required Object barId,
    required Object segmentId,
  }) : this._(groupId: groupId, barId: barId, segmentId: segmentId);

  /// Whether this key identifies a stacked segment instead of a whole bar.
  bool get isSegment => segmentId != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarSelectionKey &&
          groupId == other.groupId &&
          barId == other.barId &&
          segmentId == other.segmentId;

  @override
  String toString() {
    final segmentId = this.segmentId;

    return segmentId == null
        ? 'BarSelectionKey.bar(groupId: $groupId, barId: $barId)'
        : 'BarSelectionKey.segment(groupId: $groupId, barId: $barId, '
              'segmentId: $segmentId)';
  }

  @override
  int get hashCode => Object.hash(groupId, barId, segmentId);
}

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

  /// Scoped key that can be passed back to a line chart for selection.
  LinePointKey get selectionKey => .new(seriesId: seriesId, pointId: pointId);
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

  /// Scoped key that can be passed back to a bar chart for selection.
  BarSelectionKey get selectionKey {
    final segmentId = this.segmentId;

    return segmentId == null
        ? .bar(groupId: groupId, barId: barId)
        : .segment(groupId: groupId, barId: barId, segmentId: segmentId);
  }
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
