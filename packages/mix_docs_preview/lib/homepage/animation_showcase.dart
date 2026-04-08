library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final _trigger = ValueNotifier(false);

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    _trigger.value = !_trigger.value;
  }

  @override
  Widget build(BuildContext context) {
    // #docregion showcase
    final heartFrameStyle = BoxStyler()
        .paddingAll(20)
        .color(Colors.red)
        .shapeCircle()
        .keyframeAnimation(
          trigger: _trigger,
          timeline: [
            KeyframeTrack('scale', [
              .easeOutSine(0.84, 90.ms),
              .ease(1.16, 180.ms),
              .elasticOut(1.0, 500.ms),
            ], initial: 1.0),
            KeyframeTrack<double>('y', [
              .ease(-56.0, 140.ms),
              .decelerate(0.0, 280.ms),
            ], initial: 0.0),
          ],
          styleBuilder: (values, style) => style.transform(
            Matrix4.identity()
              ..scaleByDouble(values.get('scale'), values.get('scale'), 1.0, 1)
              ..translateByDouble(0, values.get('y'), 1, 1),
          ),
        );

    final heartStyle = IconStyler().size(80).color(Colors.white);
    // #enddocregion showcase

    // #docregion showcase
    return Pressable(
      onPress: _toggleAnimation,
      child: Box(
        style: heartFrameStyle,
        child: StyledIcon(icon: Icons.favorite, style: heartStyle),
      ),
    );
    // #enddocregion showcase
  }
}
