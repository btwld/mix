/// Tap Phase Animation Example
///
/// Demonstrates multi-phase animations that respond to user taps. The animation
/// progresses through three distinct phases: initial, compress, and expanded.
///
/// Key concepts:
/// - Using .phaseAnimation() for complex state-based animations
/// - Defining animation phases with enums
/// - Different animation configs for each phase
/// - ValueNotifier for animation triggers
/// - Transform alignment and scaling
library;

import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(BlockAnimation());
}

enum AnimationPhases { initial, compress, expanded }

class BlockAnimation extends StatefulWidget {
  const BlockAnimation({super.key});

  @override
  State<BlockAnimation> createState() => _BlockAnimationState();
}

class _BlockAnimationState extends State<BlockAnimation> {
  final _isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = $box
        .color(Colors.deepPurple)
        .height(100)
        .width(100)
        .borderRadiusCircular(40)
        .phaseAnimation(
          trigger: _isExpanded,
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            AnimationPhases.initial => style.scale(1),
            AnimationPhases.compress =>
              style.scale(0.75).color(Colors.deepPurple.shade800),
            AnimationPhases.expanded =>
              style
                  .scale(1.25)
                  .borderRadiusCircular(20)
                  .color(Colors.deepPurple.shade300),
          },
          configBuilder: (phase) => switch (phase) {
            AnimationPhases.initial =>
              CurveAnimationConfig.springWithDampingRatio(800.ms, ratio: 0.3),
            AnimationPhases.compress => CurveAnimationConfig.decelerate(200.ms),
            AnimationPhases.expanded => CurveAnimationConfig.decelerate(100.ms),
          },
        );

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded.value = !_isExpanded.value;
        });
      },
      child: Box(style: style),
    );
  }
}
