import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'chart_stroke_spec.dart';

part 'chart_grid_spec.g.dart';

/// Resolved Cartesian grid presentation.
@MixableSpec()
@immutable
final class ChartGridSpec with _$ChartGridSpec {
  /// Whether the grid is visible.
  @override
  final bool? show;

  /// Whether horizontal lines are visible.
  @override
  final bool? showHorizontal;

  /// Whether vertical lines are visible.
  @override
  final bool? showVertical;

  /// Horizontal line interval.
  @override
  final double? horizontalInterval;

  /// Vertical line interval.
  @override
  final double? verticalInterval;

  /// Shared grid-line stroke.
  @override
  final StyleSpec<ChartStrokeSpec>? stroke;

  const ChartGridSpec({
    this.show,
    this.showHorizontal,
    this.showVertical,
    this.horizontalInterval,
    this.verticalInterval,
    this.stroke,
  });
}
