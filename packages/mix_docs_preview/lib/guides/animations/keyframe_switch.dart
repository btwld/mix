/// Animations guide — Keyframe Case 1: Simple toggle (scale + width).
///
/// A single trigger drives two tracks (scale and width). The style builder
/// reads both values and applies them together.
///
/// Preview: anim-switch
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const KeyframeSwitchExample());
}

class KeyframeSwitchExample extends StatefulWidget {
  const KeyframeSwitchExample({super.key});

  @override
  State<KeyframeSwitchExample> createState() => _KeyframeSwitchExampleState();
}

class _KeyframeSwitchExampleState extends State<KeyframeSwitchExample> {
  final _trigger = ValueNotifier(false);

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = BoxStyler()
        .height(30)
        .width(40)
        .color(Colors.deepPurpleAccent)
        .shapeStadium()
        .keyframeAnimation(
          trigger: _trigger,
          timeline: [
            KeyframeTrack('scale', [
              .easeOutSine(1.25, 200.ms),
              .elasticOut(0.85, 500.ms),
            ], initial: 0.85),
            // ignore: avoid-inferrable-type-arguments
            KeyframeTrack<double>('width', [
              .decelerate(50, 100.ms),
              .ease(80, 300.ms),
              .elasticOut(40, 500.ms),
            ], initial: 40),
          ],
          styleBuilder: (values, style) =>
              style.scale(values.get('scale')).width(values.get('width')),
        );

    return Center(
      child: Pressable(
        onPress: () {
          setState(() {
            _trigger.value = !_trigger.value;
          });
        },
        child: box(),
      ),
    );
  }
}
