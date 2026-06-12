import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

part 'rotated_box_modifier.g.dart';

/// Modifier that rotates its child by quarter turns.
///
/// Wraps the child in a [RotatedBox] widget with the specified quarter turns.
@MixableModifier(lerp: false)
final class RotatedBoxModifier extends WidgetModifier<RotatedBoxModifier>
    with Diagnosticable, _$RotatedBoxModifierMethods {
  @override
  final int quarterTurns;
  const RotatedBoxModifier([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  @override
  RotatedBoxModifier lerp(RotatedBoxModifier? other, double t) {
    if (other == null) return this;

    return RotatedBoxModifier(MixOps.lerp(quarterTurns, other.quarterTurns, t));
  }

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}
