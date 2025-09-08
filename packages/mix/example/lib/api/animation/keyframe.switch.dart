import '../../helpers.dart';
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
                  focal: Alignment.center,
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
                      Keyframe.easeOutSine(1.25, 200.ms),
                      Keyframe.elasticOut(0.85, 500.ms),
                    ], initial: 0.85),
                    KeyframeTrack<double>(
                      'width',
                      [
                        Keyframe.decelerate(50, 100.ms),
                        Keyframe.linear(50, 100.ms),
                        Keyframe.elasticOut(40, 500.ms),
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
