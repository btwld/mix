import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

part 'wrap_spec.g.dart';

/// Specification for Flutter [Wrap] layout properties.
@MixableSpec()
@immutable
final class WrapSpec with _$WrapSpec {
  /// The direction to use as the main axis; defaults to [Axis.horizontal].
  @override
  final Axis? direction;

  /// How children are placed within a run; defaults to [WrapAlignment.start].
  @override
  final WrapAlignment? alignment;

  /// Space between children in a run; defaults to zero.
  @override
  final double? spacing;

  /// How runs are placed in the cross axis; defaults to [WrapAlignment.start].
  @override
  final WrapAlignment? runAlignment;

  /// Space between runs in the cross axis; defaults to zero.
  @override
  final double? runSpacing;

  /// How the children within a run should be aligned relative to each other
  /// in the cross axis; defaults to [WrapCrossAlignment.start].
  @override
  final WrapCrossAlignment? crossAxisAlignment;

  /// Determines horizontal ordering; defaults to the ambient [Directionality].
  @override
  final TextDirection? textDirection;

  /// Determines vertical ordering; defaults to [VerticalDirection.down].
  @override
  final VerticalDirection? verticalDirection;

  /// Controls clipping for visual overflow; defaults to [Clip.none].
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
