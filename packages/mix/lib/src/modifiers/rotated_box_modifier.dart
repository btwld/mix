import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

part 'rotated_box_modifier.g.dart';

/// Modifier that rotates its child by quarter turns.
///
/// Wraps the child in a [RotatedBox] widget with the specified quarter turns.
@MixableModifier()
final class RotatedBoxModifier extends WidgetModifier<RotatedBoxModifier>
    with Diagnosticable {
  final int quarterTurns;
  const RotatedBoxModifier([int? quarterTurns])
    : quarterTurns = quarterTurns ?? 0;

  @override
  RotatedBoxModifier copyWith({int? quarterTurns}) {
    return RotatedBoxModifier(quarterTurns ?? this.quarterTurns);
  }

  @override
  RotatedBoxModifier lerp(RotatedBoxModifier? other, double t) {
    if (other == null) return this;

    return RotatedBoxModifier(MixOps.lerp(quarterTurns, other.quarterTurns, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('quarterTurns', quarterTurns));
  }

  @override
  List<Object?> get props => [quarterTurns];

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

final class RotatedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, RotatedBoxModifierMix> {
  const RotatedBoxModifierUtility(super.utilityBuilder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) => utilityBuilder(
    RotatedBoxModifierMix.create(quarterTurns: Prop.value(value)),
  );
}
