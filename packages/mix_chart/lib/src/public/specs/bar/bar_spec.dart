import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import 'bar_background_spec.dart';

part 'bar_spec.g.dart';

/// Resolved presentation for one bar.
@MixableSpec()
@immutable
final class BarSpec with _$BarSpec {
  /// Solid bar fill.
  @override
  final Color? color;

  /// Gradient bar fill.
  @override
  final Gradient? gradient;

  /// Bar width.
  @override
  final double? width;

  /// Bar corner radii.
  @override
  final BorderRadius? borderRadius;

  /// Bar outline.
  @override
  final BorderSide? border;

  /// Positive alternating dash and gap lengths. Empty renders a solid border.
  @override
  final List<int>? borderDashArray;

  /// Optional track behind the bar.
  @override
  final StyleSpec<BarBackgroundSpec>? background;

  /// Bar label presentation.
  @override
  final StyleSpec<TextSpec>? label;

  /// Offset from the bar tip to its label.
  @override
  final Offset? labelOffset;

  /// Label rotation in radians.
  @override
  final double? labelAngle;

  const BarSpec({
    this.color,
    this.gradient,
    this.width,
    this.borderRadius,
    this.border,
    this.borderDashArray,
    this.background,
    this.label,
    this.labelOffset,
    this.labelAngle,
  });
}

/// Resolved presentation for one stacked bar segment.
@MixableSpec()
@immutable
final class BarSegmentSpec with _$BarSegmentSpec {
  /// Solid segment fill.
  @override
  final Color? color;

  /// Gradient segment fill.
  @override
  final Gradient? gradient;

  /// Segment outline.
  @override
  final BorderSide? border;

  /// Segment label presentation.
  @override
  final StyleSpec<TextSpec>? label;

  const BarSegmentSpec({this.color, this.gradient, this.border, this.label});
}
