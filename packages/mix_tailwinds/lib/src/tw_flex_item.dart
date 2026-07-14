import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

FlexibleModifierMix? twFlexibleModifierForFlexItem(String utility) {
  final ({int flex, FlexFit fit})? spec = switch (utility) {
    'flex-1' ||
    'flex-shrink' ||
    'shrink' ||
    'grow' => (flex: 1, fit: FlexFit.tight),
    'flex-auto' => (flex: 1, fit: FlexFit.loose),
    'flex-initial' ||
    'flex-none' ||
    'flex-shrink-0' ||
    'shrink-0' ||
    'grow-0' => (flex: 0, fit: FlexFit.loose),
    _ => null,
  };
  if (spec == null) return null;

  return FlexibleModifierMix(flex: spec.flex, fit: spec.fit);
}
