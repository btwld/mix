import 'package:flutter/foundation.dart';
// Used by generated styler code for constructor parameter types.
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

import '../pressable/pressable_builders.dart';

import '../box/box_spec.dart';
import '../flex/flex_spec.dart';
import '../text/text_spec.dart';
import 'flexbox_widget.dart';

part 'flexbox_spec.g.dart';

/// Specification that combines box styling and flex layout properties.
///
/// Provides comprehensive styling for widgets that need both
/// box decoration and flex layout capabilities. Merges [BoxSpec] and
/// [FlexSpec] into a unified specification.
@MixableSpec(
  target: FlexBox.new,
  extraStylerMixins: [_FlexBoxStylerPressableMixin],
)
@immutable
final class FlexBoxSpec with _$FlexBoxSpec {
  /// Box styling properties for decoration, padding, constraints, etc.
  @override
  final StyleSpec<BoxSpec>? box;

  /// Flex layout properties for direction, alignment, spacing, etc.
  @override
  final StyleSpec<FlexSpec>? flex;

  const FlexBoxSpec({this.box, this.flex});
}

/// Adds the terminal interactive builder to [FlexBoxStyler].
// The extraStylerMixins generator hook supplies the owning styler type.
// ignore: avoid-unused-generics
mixin _FlexBoxStylerPressableMixin<ST extends Style<FlexBoxSpec>>
    on Style<FlexBoxSpec> {
  PressableChildrenBuilder pressable() =>
      .new((children) => FlexBox(style: this, children: children));
}
