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
    return Transform.scale(
      scale: 8,
      child: Center(
        child: Pressable(
          onPress: () {
            setState(() {
              _trigger.value = !_trigger.value;
            });
          },
          child: Box(
            style: Style.box(
              BoxMix()
                  .color(
                    _trigger.value
                        ? Colors.deepPurpleAccent
                        : Colors.grey.shade300,
                  )
                  .height(30)
                  .width(65)
                  .borderRadius(BorderRadiusMix.all(Radius.circular(40)))
                  .transformAlignment(Alignment.center)
                  .alignment(
                    _trigger.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                  )
                  .animate(AnimationConfig.easeOut(300.ms)),
            ),
            child: Box(
              style: Style.box(
                BoxMix()
                    .height(30)
                    .width(40)
                    .color(Colors.white)
                    .foregroundDecoration(
                      BoxDecorationMix()
                          .gradient(
                            GradientMix.radial(
                              RadialGradientMix()
                                  .focalRadius(1.1)
                                  .focal(Alignment.center)
                                  .colors([
                                    Colors.black.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ])
                                  .stops([0.3, 1]),
                            ),
                          )
                          .borderRadius(BorderRadiusMix.circular(40)),
                    )
                    .borderRadius(BorderRadiusMix.circular(40))
                    .transformAlignment(Alignment.center)
                    .scale(0.85)
                    .shadow(
                      BoxShadowMix()
                          .blurRadius(4)
                          .spreadRadius(3)
                          .offset(Offset(2, 4))
                          .color(Colors.black.withValues(alpha: 0.1)),
                    )
                    .phaseAnimation(
                      trigger: _trigger,
                      phases: [false, true],
                      styleBuilder: (phase, style) {
                        return style
                            .scale(phase ? 1.25 : 0.85)
                            .color(Colors.white)
                            .width(phase ? 45 : 40);
                      },
                      configBuilder: (phase) {
                        if (!phase) {
                          return CurveAnimationConfig.springDurationBased(
                            duration: 200.ms,
                            bounce: 0.0,
                          );
                        }
                        return CurveAnimationConfig.springDurationBased(
                          duration: 300.ms,
                          bounce: 0.6,
                        );
                      },
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
