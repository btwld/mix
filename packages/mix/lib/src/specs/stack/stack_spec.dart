import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

part 'stack_spec.g.dart';

/// Specification for stack layout properties.
///
/// Provides configuration for stack-specific properties such as
/// alignment, fit, text direction, and clipping behavior.
@MixableSpec()
@immutable
final class StackSpec extends Spec<StackSpec>
    with Diagnosticable, _$StackSpecMethods {
  /// How to align the non-positioned children.
  @override
  final AlignmentGeometry? alignment;

  /// How to size the non-positioned children.
  @override
  final StackFit? fit;

  /// The text direction to use for rendering.
  @override
  final TextDirection? textDirection;

  /// The content will be clipped (or not) according to this option.
  @override
  final Clip? clipBehavior;

  const StackSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
  });
}
