import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'bar_background_spec.g.dart';

/// Resolved presentation for a bar background track.
@MixableSpec()
@immutable
final class BarBackgroundSpec with _$BarBackgroundSpec {
  /// Whether the track is visible.
  @override
  final bool? show;

  /// Track lower edge.
  @override
  final double? fromY;

  /// Track upper edge.
  @override
  final double? toY;

  /// Solid track color.
  @override
  final Color? color;

  /// Gradient track fill.
  @override
  final Gradient? gradient;

  const BarBackgroundSpec({
    this.show,
    this.fromY,
    this.toY,
    this.color,
    this.gradient,
  });
}
