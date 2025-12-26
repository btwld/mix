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

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

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
    // Using BoxStyler() - the recommended Mix 2.0 API
    final style = BoxStyler()
        .color(Colors.deepPurple)
        .height(100)
        .width(100)
        .borderRounded(40)
        .phaseAnimation(
          trigger: _isExpanded,
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            .initial =>
              style //
                  .scale(1),
            .compress =>
              style //
                  .scale(0.75)
                  .color(Colors.red.shade800),
            .expanded =>
              style //
                  .scale(1.25)
                  .borderRounded(20)
                  .color(Colors.yellow.shade300),
          },
          configBuilder: (phase) => switch (phase) {
            .initial => .springWithDampingRatio(800.ms, ratio: 0.3),
            .compress => .decelerate(200.ms),
            .expanded => .decelerate(100.ms),
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
