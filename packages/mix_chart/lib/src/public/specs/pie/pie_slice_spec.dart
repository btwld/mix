import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'pie_slice_spec.g.dart';

/// Resolved presentation for one pie or donut slice.
@MixableSpec()
@immutable
final class PieSliceSpec with _$PieSliceSpec {
  /// Solid slice fill.
  @override
  final Color? color;

  /// Gradient slice fill.
  @override
  final Gradient? gradient;

  /// Slice outer radius.
  @override
  final double? radius;

  /// Whether the slice label is visible.
  @override
  final bool? showLabel;

  /// Slice label presentation.
  @override
  final StyleSpec<TextSpec>? label;

  /// Radial label position from zero to one.
  @override
  final double? labelPosition;

  /// Slice outline.
  @override
  final BorderSide? border;

  /// Slice corner radius.
  @override
  final double? cornerRadius;

  /// Radial badge position from zero to one.
  @override
  final double? badgePosition;

  const PieSliceSpec({
    this.color,
    this.gradient,
    this.radius,
    this.showLabel,
    this.label,
    this.labelPosition,
    this.border,
    this.cornerRadius,
    this.badgePosition,
  });
}
