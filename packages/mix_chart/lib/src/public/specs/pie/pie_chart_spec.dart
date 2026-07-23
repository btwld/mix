import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../models/chart_config.dart';
import '../../models/chart_hit.dart';
import '../../models/pie_data.dart';
import '../../widgets/pie_chart.dart';
import '../shared/chart_frame_spec.dart';
import '../shared/chart_tooltip_spec.dart';
import 'pie_slice_spec.dart';

part 'pie_chart_spec.g.dart';

/// Resolved presentation for a [PieChart].
@MixableSpec(target: PieChart.new)
@immutable
final class PieChartSpec with _$PieChartSpec {
  /// Chart frame.
  @override
  final StyleSpec<ChartFrameSpec>? frame;

  /// Common presentation inherited by every slice.
  @override
  final StyleSpec<PieSliceSpec>? slice;

  /// Colors cycled across slices without an explicit fill.
  @override
  final List<Color>? palette;

  /// Radius of the donut center. Zero renders a pie.
  @override
  final double? centerRadius;

  /// Center fill color.
  @override
  final Color? centerColor;

  /// Gap between slices.
  @override
  final double? sliceSpacing;

  /// Starting angle in degrees.
  @override
  final double? startAngle;

  /// Whether labels rotate radially.
  @override
  final bool? sunbeamLabels;

  /// Built-in tooltip presentation.
  @override
  final StyleSpec<ChartTooltipSpec>? tooltip;

  const PieChartSpec({
    this.frame,
    this.slice,
    this.palette,
    this.centerRadius,
    this.centerColor,
    this.sliceSpacing,
    this.startAngle,
    this.sunbeamLabels,
    this.tooltip,
  });
}
