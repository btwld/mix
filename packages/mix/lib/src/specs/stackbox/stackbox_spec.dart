import 'package:flutter/foundation.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/spec.dart';
import '../../core/style_spec.dart';
import '../box/box_spec.dart';
import '../stack/stack_spec.dart';

part 'stackbox_spec.g.dart';

/// Specification that combines box styling and stack layout properties.
///
/// Provides comprehensive styling for widgets that need both
/// box decoration and stack layout capabilities. Merges [BoxSpec] and
/// [StackSpec] into a unified specification.
@MixableSpec()
@immutable
final class StackBoxSpec extends Spec<StackBoxSpec>
    with Diagnosticable, _$StackBoxSpecMethods {
  /// Box styling properties for decoration, padding, constraints, etc.
  @override
  final StyleSpec<BoxSpec>? box;

  /// Stack layout properties for alignment, fit, clipping, etc.
  @override
  final StyleSpec<StackSpec>? stack;

  const StackBoxSpec({this.box, this.stack});
}

@Deprecated('Use StackBoxSpec instead')
typedef ZBoxSpec = StackBoxSpec;
