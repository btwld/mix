import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'flex_spec.g.dart';

/// Defines the styling for a Flex widget.
///
/// This class provides configuration for flex-specific properties such as
/// direction, alignment, and spacing through the Mix framework.
@MixableSpec()
@immutable
final class FlexSpec extends Spec<FlexSpec>
    with Diagnosticable, _$FlexSpecMethods {
  /// The direction to use as the main axis.
  @override
  final Axis? direction;

  /// How the children should be placed along the main axis.
  @override
  final MainAxisAlignment? mainAxisAlignment;

  /// How the children should be placed along the cross axis.
  @override
  final CrossAxisAlignment? crossAxisAlignment;

  /// How much space should be occupied in the main axis.
  @override
  final MainAxisSize? mainAxisSize;

  /// Determines the order to lay children out vertically.
  @override
  final VerticalDirection? verticalDirection;

  /// Determines the order to lay children out horizontally.
  @override
  final TextDirection? textDirection;

  /// A baseline to use for aligning items.
  @override
  final TextBaseline? textBaseline;

  /// The content will be clipped (or not) according to this option.
  @override
  final Clip? clipBehavior;

  /// The spacing between children.
  @override
  final double? spacing;

  /// Creates a [FlexSpec] with the provided properties.
  const FlexSpec({
    this.direction,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.spacing,
  });
}
