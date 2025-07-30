import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: BlockAnimation())),
    );
  }
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
          trigger: _isExpanded,
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            AnimationPhases.initial => style.scale(1),
            AnimationPhases.compress => style.scale(0.75),
            AnimationPhases.expanded => style.scale(1.25),
          },
          configBuilder: (phase) => switch (phase) {
            AnimationPhases.initial => AnimationConfig.decelerate(200.ms),
            AnimationPhases.compress => AnimationConfig.decelerate(100.ms),
            AnimationPhases.expanded => AnimationConfig.bounceOut(600.ms),
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
