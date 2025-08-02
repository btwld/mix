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
    final style = Style.box(
        .color(Colors.deepPurple)
        .height(100)
        .width(100)
        .borderRadius(.circular(40))
        .transformAlignment(.center)
        .phaseAnimation(
          trigger: ValueNotifier(_isExpanded),
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            .initial => style.scale(1),
            .compress => style.scale(0.75),
            .expanded => style.scale(1.25),
          },
          configBuilder: (phase) => switch (phase) {
            .initial => .decelerate(200.ms),
            .compress => .decelerate(100.ms),
            .expanded => .bounceOut(600.ms),
          },
        )
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
