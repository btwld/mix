import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../specs/bar/bar_spec.dart';

/// One colored segment of a stacked bar.
@immutable
final class BarSegment {
  /// Stable segment identifier.
  final Object id;

  /// User-facing segment name.
  final String label;

  /// Segment lower edge.
  final double fromY;

  /// Segment upper edge.
  final double toY;

  /// Optional presentation override.
  final BarSegmentStyler? style;

  const BarSegment._({
    required this.id,
    required this.label,
    required this.fromY,
    required this.toY,
    required this.style,
  });

  /// Creates a validated stacked segment.
  factory BarSegment({
    required Object id,
    required String label,
    required double fromY,
    required double toY,
    BarSegmentStyler? style,
  }) {
    _validateRange(fromY, toY, 'segment', id);
    _validateLabel(label, 'segment', id);

    return BarSegment._(
      id: id,
      label: label,
      fromY: fromY,
      toY: toY,
      style: style,
    );
  }
}

/// One bar within a group.
@immutable
final class BarValue {
  /// Stable bar identifier.
  final Object id;

  /// User-facing bar name.
  final String label;

  /// Bar lower edge.
  final double fromY;

  /// Bar upper edge.
  final double toY;

  /// Optional ordered stacked segments.
  final List<BarSegment> segments;

  /// Optional presentation override.
  final BarStyler? style;

  const BarValue._({
    required this.id,
    required this.label,
    required this.fromY,
    required this.toY,
    required this.segments,
    required this.style,
  });

  /// Creates a validated bar.
  factory BarValue({
    required Object id,
    required String label,
    double fromY = 0,
    required double toY,
    List<BarSegment> segments = const [],
    BarStyler? style,
  }) {
    _validateRange(fromY, toY, 'bar', id);
    _validateLabel(label, 'bar', id);
    _validateUniqueIds(segments.map((segment) => segment.id), 'segment', id);

    return BarValue._(
      id: id,
      label: label,
      fromY: fromY,
      toY: toY,
      segments: UnmodifiableListView(List<BarSegment>.of(segments)),
      style: style,
    );
  }
}

/// A category containing one or more grouped bars.
@immutable
final class BarGroup {
  /// Stable group identifier.
  final Object id;

  /// User-facing category label.
  final String label;

  /// Bars shown in this group.
  final List<BarValue> bars;

  const BarGroup._({required this.id, required this.label, required this.bars});

  /// Creates a validated bar group.
  factory BarGroup({
    required Object id,
    required String label,
    required List<BarValue> bars,
  }) {
    _validateLabel(label, 'group', id);
    _validateUniqueIds(bars.map((bar) => bar.id), 'bar', id);

    return BarGroup._(
      id: id,
      label: label,
      bars: UnmodifiableListView(List<BarValue>.of(bars)),
    );
  }
}

void _validateRange(double fromY, double toY, String kind, Object id) {
  if (!fromY.isFinite || !toY.isFinite) {
    throw ArgumentError.value(
      (fromY, toY),
      'fromY/toY',
      '$kind $id values must be finite',
    );
  }
}

void _validateLabel(String label, String kind, Object id) {
  if (label.trim().isEmpty) {
    throw ArgumentError.value(label, 'label', '$kind $id needs a label');
  }
}

void _validateUniqueIds(Iterable<Object> ids, String kind, Object ownerId) {
  final seen = <Object>{};
  for (final id in ids) {
    if (!seen.add(id)) {
      throw ArgumentError.value(id, 'id', 'Duplicate $kind ID in $ownerId');
    }
  }
}
