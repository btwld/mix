import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(SwitchAnimation());
}

class SwitchAnimation extends StatefulWidget {
  const SwitchAnimation({super.key});

  @override
  State<SwitchAnimation> createState() => _SwitchAnimationState();
}

class _SwitchAnimationState extends State<SwitchAnimation> {
  final ValueNotifier<bool> _trigger = ValueNotifier(false);

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pressable(
        onPress: () {
          setState(() {
            _trigger.value = !_trigger.value;
          });
        },
        child: Box(
          style: BoxStyler()
              .color(
                _trigger.value ? Colors.deepPurpleAccent : Colors.grey.shade300,
              )
              .height(30)
              .width(65)
              .borderRadiusAll(.circular(40))
              .alignment(
                _trigger.value ? .centerRight : .centerLeft,
              )
              .animate(.easeOut(300.ms)),
          child: Box(
            style: BoxStyler()
                .height(30)
                .width(40)
                .color(Colors.white)
                .foregroundRadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.3, 1],
                  focal: .center,
                  focalRadius: 1.1,
                )
                .borderRounded(40)
                .scale(0.85)
                .shadowOnly(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: Offset(2, 4),
                  blurRadius: 4,
                  spreadRadius: 3,
                )
                .keyframeAnimation(
                  trigger: _trigger,
                  timeline: [
                    KeyframeTrack<double>('scale', [
                      .easeOutSine(1.25, 200.ms),
                      .elasticOut(0.85, 500.ms),
                    ], initial: 0.85),
                    KeyframeTrack<double>(
                      'width',
                      [
                        .decelerate(50, 100.ms),
                        .linear(50, 100.ms),
                        .elasticOut(40, 500.ms),
                      ],
                      initial: 40,
                      tweenBuilder: Tween.new,
                    ),
                  ],
                  styleBuilder: (values, style) => style
                      .scale(values.get('scale'))
                      .width(values.get('width')),
                ),
          ),
        ),
      ),
    );
  }
}
