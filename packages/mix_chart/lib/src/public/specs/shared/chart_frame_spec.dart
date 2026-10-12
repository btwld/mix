import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'chart_frame_spec.g.dart';

/// Resolved chart frame presentation.
@MixableSpec()
@immutable
final class ChartFrameSpec with _$ChartFrameSpec {
  /// Solid background behind the plot.
  @override
  final Color? backgroundColor;

  /// Border around the plot.
  @override
  final Border? border;

  /// Whether the border is visible.
  @override
  final bool? showBorder;

  /// Whether marks are clipped to the plot bounds.
  @override
  final bool? clip;

  /// Clockwise quarter-turn rotation.
  @override
  final int? rotationQuarterTurns;

  const ChartFrameSpec({
    this.backgroundColor,
    this.border,
    this.showBorder,
    this.clip,
    this.rotationQuarterTurns,
  });
}
