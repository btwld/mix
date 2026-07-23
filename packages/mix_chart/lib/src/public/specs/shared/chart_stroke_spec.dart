import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'chart_stroke_spec.g.dart';

/// Resolved paint for a chart line or outline.
@MixableSpec()
@immutable
final class ChartStrokeSpec with _$ChartStrokeSpec {
  /// Solid stroke color.
  @override
  final Color? color;

  /// Gradient stroke paint, which takes precedence over [color].
  @override
  final Gradient? gradient;

  /// Stroke width.
  @override
  final double? width;

  /// Positive alternating dash and gap lengths. Empty renders a solid stroke.
  @override
  final List<int>? dashArray;

  /// Opacity multiplier from zero to one.
  @override
  final double? opacity;

  const ChartStrokeSpec({
    this.color,
    this.gradient,
    this.width,
    this.dashArray,
    this.opacity,
  });
}
