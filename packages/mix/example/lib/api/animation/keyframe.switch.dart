import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

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
          style: Style.box()
              .color(
                _trigger.value ? Colors.deepPurpleAccent : Colors.grey.shade300,
              )
              .height(30)
              .width(65)
              .borderRadiusAll(Radius.circular(40))
              .alignment(
                _trigger.value ? Alignment.centerRight : Alignment.centerLeft,
              )
              .animate(AnimationConfig.easeOut(300.ms)),
          child: Box(
            style: Style.box()
                .height(30)
                .width(40)
                .color(Colors.white)
                .foregroundRadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.3, 1],
                  focalRadius: 1.1,
                  focal: Alignment.center,
                )
                .borderRounded(40)
                .scale(0.85)
                .shadowOnly(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  spreadRadius: 3,
                  offset: Offset(2, 4),
                )
                .keyframeAnimation(
                  trigger: _trigger,
                  timeline: [
                    KeyframeTrack<double>('scale', initial: 0.85, [
                      Keyframe.easeOutSine(1.25, 200.ms),
                      Keyframe.elasticOut(0.85, 500.ms),
                    ]),
                    KeyframeTrack<double>(
                      'width',
                      tweenBuilder: Tween.new,
                      initial: 40,
                      [
                        Keyframe.decelerate(50, 100.ms),
                        Keyframe.linear(50, 100.ms),
                        Keyframe.elasticOut(40, 500.ms),
                      ],
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
