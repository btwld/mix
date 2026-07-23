import 'package:flutter/foundation.dart';
// Used by generated styler code for constructor parameter types.
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';

import '../box/box_spec.dart';
import '../wrap/wrap_spec.dart';
import 'wrapbox_widget.dart';

part 'wrapbox_spec.g.dart';

/// Specification that combines box styling and wrap/flow layout properties.
///
/// Spike prototype — not exported from `mix.dart`. Mirrors [FlexBoxSpec].
///
/// The nested wrap sub-spec is named [flow] (not `wrap`) because generated
/// Stylers already reserve `wrap` for widget-modifier chaining.
@MixableSpec(target: WrapBox.new)
@immutable
final class WrapBoxSpec with _$WrapBoxSpec {
  /// Box styling properties for decoration, padding, constraints, etc.
  @override
  final StyleSpec<BoxSpec>? box;

  /// Wrap/flow layout properties (direction, spacing, alignment, etc.).
  ///
  /// Named `flow` to avoid clashing with the base Styler `wrap` modifier API.
  @override
  final StyleSpec<WrapSpec>? flow;

  const WrapBoxSpec({this.box, this.flow});
}
