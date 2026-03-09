/// Animations guide — Phase: Tap → compress → expand → initial.
///
/// A square reacts to tap: it compresses, then expands, then returns to its
/// original size, moving through each phase in order.
///
/// Preview: anim-tap-phase
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const PhaseTapCompressExample());
}

enum AnimationPhases { initial, compress, expanded }

class PhaseTapCompressExample extends StatefulWidget {
  const PhaseTapCompressExample({super.key});

  @override
  State<PhaseTapCompressExample> createState() =>
      _PhaseTapCompressExampleState();
}

class _PhaseTapCompressExampleState extends State<PhaseTapCompressExample> {
  final _isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = BoxStyler()
        .color(Colors.deepPurple)
        .height(100)
        .width(100)
        .borderRounded(40)
        .phaseAnimation(
          trigger: _isExpanded,
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            .initial => style.scale(1),
            .compress => style.scale(0.75).color(Colors.red.shade800),
            .expanded =>
              style.scale(1.25).borderRounded(20).color(Colors.yellow.shade300),
          },
          configBuilder: (phase) => switch (phase) {
            .initial => .springWithDampingRatio(800.ms, ratio: 0.3),
            .compress => .decelerate(200.ms),
            .expanded => .decelerate(100.ms),
          },
        );

    return Pressable(
      onPress: () => _isExpanded.value = !_isExpanded.value,
      child: box(),
    );
  }
}
