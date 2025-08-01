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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Style.box()
        .color(Colors.deepPurpleAccent)
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(40)))
        .transformAlignment(Alignment.center)
        .phaseAnimation(
          trigger: ValueNotifier(_isExpanded),
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            AnimationPhases.initial => style.scale(1),
            AnimationPhases.compress => style.scale(0.75),
            AnimationPhases.expanded => style.scale(1.25),
          },
          configBuilder: (phase) => switch (phase) {
            AnimationPhases.initial => CurveAnimationConfig.decelerate(200.ms),
            AnimationPhases.compress => CurveAnimationConfig.decelerate(100.ms),
            AnimationPhases.expanded => CurveAnimationConfig.bounceOut(600.ms),
          },
        );

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Box(style: style),
    );
  }
}
