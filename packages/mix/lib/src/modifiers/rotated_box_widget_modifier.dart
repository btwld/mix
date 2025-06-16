// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'rotated_box_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class RotatedBoxModifierSpec
    extends WidgetModifierSpec<RotatedBoxModifierSpec>
    with _$RotatedBoxModifierSpec, Diagnosticable {
  final int quarterTurns;
  const RotatedBoxModifierSpec([int? quarterTurns])
      : quarterTurns = quarterTurns ?? 0;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    _debugFillProperties(properties);
  }

  @override
  RotatedBoxModifierSpec lerp(RotatedBoxModifierSpec? other, double t) {
    if (other == null) return _$this;

    return RotatedBoxModifierSpec(
      MixHelpers.lerpInt(quarterTurns, other.quarterTurns, t),
    );
  }

  @override
  Widget build(Widget child) {
    return RotatedBox(quarterTurns: quarterTurns, child: child);
  }
}

final class RotatedBoxModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, RotatedBoxModifierSpecAttribute> {
  const RotatedBoxModifierSpecUtility(super.builder);
  T d90() => call(1);
  T d180() => call(2);
  T d270() => call(3);

  T call(int value) =>
      builder(RotatedBoxModifierSpecAttribute(quarterTurns: value));
}
