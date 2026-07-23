import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_enums.dart';

part 'chart_axis_spec.g.dart';

/// Resolved presentation for one Cartesian axis.
@MixableSpec()
@immutable
final class ChartAxisSpec with _$ChartAxisSpec {
  /// Whether labels are visible.
  @override
  final bool? showLabels;

  /// Nested Mix text presentation for labels.
  @override
  final StyleSpec<TextSpec>? label;

  /// Maximum layout space reserved for labels.
  @override
  final double? reservedSize;

  /// Gap between a label and the plot.
  @override
  final double? labelSpace;

  /// Label rotation in radians.
  @override
  final double? labelAngle;

  /// Whether edge labels are translated inside available bounds.
  @override
  final bool? fitInside;

  /// Distance retained from an edge when fitting labels.
  @override
  final double? fitInsideDistance;

  /// Maximum space reserved for the axis name.
  @override
  final double? nameSize;

  /// Whether the axis draws below chart overlays.
  @override
  final bool? drawBelowEverything;

  /// Placement relative to the plot.
  @override
  final ChartAxisLabelAlignment? alignment;

  const ChartAxisSpec({
    this.showLabels,
    this.label,
    this.reservedSize,
    this.labelSpace,
    this.labelAngle,
    this.fitInside,
    this.fitInsideDistance,
    this.nameSize,
    this.drawBelowEverything,
    this.alignment,
  });
}
