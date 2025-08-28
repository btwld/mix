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
          style: BoxStyle()
              .color(
                _trigger.value ? Colors.deepPurpleAccent : Colors.grey.shade300,
              )
              .height(30)
              .width(65)
              .borderRadius(.all(Radius.circular(40)))
              .transformAlignment(.center)
              .alignment(
                _trigger.value ? .centerRight : .centerLeft,
              )
              .animate(.easeOut(300.ms)),
          child: Box(
            style: BoxStyle()
                .height(30)
                .width(40)
                .color(Colors.white)
                .foregroundDecoration(
                  .gradient(
                    .radial(
                      .focalRadius(1.1)
                      .focal(.center)
                      .colors([
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                      ])
                      .stops([0.3, 1])
                    ),
                  ).borderRadius(.circular(40)),
                )
                .borderRadius(.circular(40))
                .transformAlignment(.center)
                .scale(0.85)
                .shadow(
                  .blurRadius(4)
                  .spreadRadius(3)
                  .offset(Offset(2, 4))
                  .color(
                    Colors.black.withValues(alpha: 0.1),
                  )
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
                    return .decelerate(150.ms);
                  },
                )
            ),
          ),
        ),
    
    );
  }
}
