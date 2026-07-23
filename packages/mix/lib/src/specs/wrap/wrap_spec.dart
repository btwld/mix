import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

part 'wrap_spec.g.dart';

/// Specification for Flutter [Wrap] layout properties.
///
/// Spike prototype — not exported from `mix.dart`.
@MixableSpec()
@immutable
final class WrapSpec with _$WrapSpec {
  /// The direction to use as the main axis.
  @override
  final Axis? direction;

  /// How the children within a run should be placed in the main axis.
  @override
  final WrapAlignment? alignment;

  /// How much space to place between children in a run in the main axis.
  @override
  final double? spacing;

  /// How the runs themselves should be placed in the cross axis.
  @override
  final WrapAlignment? runAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  @override
  final double? runSpacing;

  /// How the children within a run should be aligned relative to each other
  /// in the cross axis.
  @override
  final WrapCrossAlignment? crossAxisAlignment;

  /// Determines the order to lay children out horizontally.
  @override
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically.
  @override
  final VerticalDirection? verticalDirection;

  /// The content will be clipped (or not) according to this option.
  @override
  final Clip? clipBehavior;

  /// Creates a [WrapSpec] with the provided properties.
  const WrapSpec({
    this.direction,
    this.alignment,
    this.spacing,
    this.runAlignment,
    this.runSpacing,
    this.crossAxisAlignment,
    this.textDirection,
    this.verticalDirection,
    this.clipBehavior,
  });
}
