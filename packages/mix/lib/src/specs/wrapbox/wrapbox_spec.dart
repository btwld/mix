import 'package:flutter/foundation.dart';
// Used by generated styler code for constructor parameter types.
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

import '../box/box_spec.dart';
import '../pressable/pressable_builders.dart';
import '../text/text_spec.dart';
import '../wrap/wrap_spec.dart';
import 'wrapbox_widget.dart';

part 'wrapbox_spec.g.dart';

/// Specification that combines box styling and wrap/flow layout properties.
///
/// The nested Wrap sub-spec is named [flow] because `wrap` is the inherited
/// widget-modifier method on generated stylers. [WrapBoxStyler] also flattens
/// Wrap properties for ordinary fluent use while retaining `flow(...)` as the
/// advanced nested composition escape hatch.
@MixableSpec(
  target: WrapBox.new,
  extraStylerMixins: [_WrapBoxStylerPressableMixin],
)
@immutable
final class WrapBoxSpec with _$WrapBoxSpec {
  /// Box styling properties for decoration, padding, constraints, etc.
  @override
  final StyleSpec<BoxSpec>? box;

  /// Wrap layout properties (direction, spacing, alignment, etc.).
  ///
  /// Named `flow` to avoid clashing with the base Styler `wrap` modifier API.
  @override
  final StyleSpec<WrapSpec>? flow;

  const WrapBoxSpec({this.box, this.flow});
}

mixin _WrapBoxStylerPressableMixin<ST extends Style<WrapBoxSpec>>
    on MixStyler<ST, WrapBoxSpec> {
  /// Finishes this style and returns a reusable interactive builder.
  PressableChildrenBuilder pressable() =>
      .new((children) => WrapBox(style: this, children: children));
}
