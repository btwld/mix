import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: SwitchAnimation(),
          ),
        ),
      ),
    );
  }
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
              .borderRadius(BorderRadiusMix.all(Radius.circular(40)))
              .transformAlignment(Alignment.center)
              .alignment(
                _trigger.value ? Alignment.centerRight : Alignment.centerLeft,
              )
              .animate(AnimationConfig.easeOut(300.ms)),
          child: Box(
            style: Style.box()
                .height(30)
                .width(40)
                .color(Colors.white)
                .foregroundDecoration(
                  BoxDecorationMix.gradient(
                    RadialGradientMix()
                        .focalRadius(1.1)
                        .focal(Alignment.center)
                        .colors([
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                        ])
                        .stops([0.3, 1]),
                  ).borderRadius(BorderRadiusMix.circular(40)),
                )
                .borderRadius(BorderRadiusMix.circular(40))
                .transformAlignment(Alignment.center)
                .scale(0.85)
                .shadow(
                  BoxShadowMix.color(
                    Colors.black.withValues(alpha: 0.1),
                  ).blurRadius(4).spreadRadius(3).offset(Offset(2, 4)),
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
                    return AnimationConfig.decelerate(150.ms);
                  },
                ),
          ),
        ),
      ),
    );
  }
}
