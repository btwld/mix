import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../specs/line/line_series_spec.dart';

/// A numeric point in a line series.
@immutable
final class ChartPoint {
  /// Stable point identifier.
  final Object id;

  /// Horizontal value.
  final double x;

  /// Vertical value, or null to create a line gap.
  final double? y;

  const ChartPoint._({required this.id, required this.x, required this.y});

  /// Creates a validated point.
  factory ChartPoint({required Object id, required double x, double? y}) {
    if (!x.isFinite) {
      throw ArgumentError.value(x, 'x', 'Must be finite for point $id');
    }
    if (y != null && !y.isFinite) {
      throw ArgumentError.value(y, 'y', 'Must be finite for point $id');
    }

    return ChartPoint._(id: id, x: x, y: y);
  }
}

/// An ordered line-chart series.
@immutable
final class LineSeries {
  /// Stable series identifier.
  final Object id;

  /// User-facing series name used by semantics and default tooltips.
  final String label;

  /// Ordered points.
  final List<ChartPoint> points;

  /// Optional presentation override for this series.
  final LineSeriesStyler? style;

  const LineSeries._({
    required this.id,
    required this.label,
    required this.points,
    required this.style,
  });

  /// Creates a validated line series.
  factory LineSeries({
    required Object id,
    required String label,
    required List<ChartPoint> points,
    LineSeriesStyler? style,
  }) {
    _requireLabel(label, 'series', id);
    _requireUniqueIds(points.map((point) => point.id), 'point', id);

    return LineSeries._(
      id: id,
      label: label,
      points: UnmodifiableListView(List<ChartPoint>.of(points)),
      style: style,
    );
  }
}

void _requireLabel(String label, String kind, Object id) {
  if (label.trim().isEmpty) {
    throw ArgumentError.value(label, 'label', '$kind $id needs a label');
  }
}

void _requireUniqueIds(Iterable<Object> ids, String kind, Object ownerId) {
  final seen = <Object>{};
  for (final id in ids) {
    if (!seen.add(id)) {
      throw ArgumentError.value(id, 'id', 'Duplicate $kind ID in $ownerId');
    }
  }
}
