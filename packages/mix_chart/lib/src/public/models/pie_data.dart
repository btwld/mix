import 'package:flutter/widgets.dart';

import '../specs/pie/pie_slice_spec.dart';

/// A slice in a pie or donut chart.
@immutable
final class PieSlice {
  /// Stable slice identifier.
  final Object id;

  /// User-facing slice name.
  final String label;

  /// Non-negative slice value.
  final double value;

  /// Optional presentation override.
  final PieSliceStyler? style;

  /// Optional widget displayed on the slice.
  final Widget? badge;

  const PieSlice._({
    required this.id,
    required this.label,
    required this.value,
    required this.style,
    required this.badge,
  });

  /// Creates a validated pie slice.
  factory PieSlice({
    required Object id,
    required String label,
    required double value,
    PieSliceStyler? style,
    Widget? badge,
  }) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Slice $id must have a finite, non-negative value',
      );
    }
    if (label.trim().isEmpty) {
      throw ArgumentError.value(label, 'label', 'Slice $id needs a label');
    }

    return PieSlice._(
      id: id,
      label: label,
      value: value,
      style: style,
      badge: badge,
    );
  }
}
