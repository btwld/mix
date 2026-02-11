import 'package:flutter/foundation.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/spec.dart';
import '../../core/style_spec.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';

part 'flexbox_spec.g.dart';

/// Specification that combines box styling and flex layout properties.
///
/// Provides comprehensive styling for widgets that need both
/// box decoration and flex layout capabilities. Merges [BoxSpec] and
/// [FlexSpec] into a unified specification.
@MixableSpec()
@immutable
final class FlexBoxSpec extends Spec<FlexBoxSpec>
    with Diagnosticable, _$FlexBoxSpecMethods {
  /// Box styling properties for decoration, padding, constraints, etc.
  @override
  final StyleSpec<BoxSpec>? box;

  /// Flex layout properties for direction, alignment, spacing, etc.
  @override
  final StyleSpec<FlexSpec>? flex;

  const FlexBoxSpec({this.box, this.flex});
}
