import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'chart_area_spec.g.dart';

/// Resolved fill above or below a line.
@MixableSpec()
@immutable
final class ChartAreaSpec with _$ChartAreaSpec {
  /// Whether the area is visible.
  @override
  final bool? show;

  /// Solid fill color.
  @override
  final Color? color;

  /// Gradient fill, which takes precedence over [color].
  @override
  final Gradient? gradient;

  /// Optional cutoff value.
  @override
  final double? cutoffY;

  /// Whether [cutoffY] clips the area.
  @override
  final bool? applyCutoff;

  const ChartAreaSpec({
    this.show,
    this.color,
    this.gradient,
    this.cutoffY,
    this.applyCutoff,
  });
}
