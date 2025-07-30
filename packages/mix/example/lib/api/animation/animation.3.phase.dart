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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pressable(
        onPress: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Box(
          style: Style.box()
              .color(
                _isExpanded ? Colors.deepPurpleAccent : Colors.grey.shade300,
              )
              .height(30)
              .width(65)
              .borderRadius(BorderRadiusMix.all(Radius.circular(40)))
              .transformAlignment(Alignment.center)
              .alignment(
                _isExpanded ? Alignment.centerRight : Alignment.centerLeft,
              )
              .animate(AnimationConfig.decelerate(300.ms)),
          child: Box(
            style: Style.box()
                .height(30)
                .width(40)
                .color(Colors.white)
                .borderRadius(BorderRadiusMix.circular(40))
                .transformAlignment(Alignment.center)
                .scale(0.85)
                .shadow(
                  BoxShadowMix.color(
                    Colors.black.withValues(alpha: 0.1),
                  ).blurRadius(4).spreadRadius(3).offset(Offset(2, 4)),
                )
                .phaseAnimation(
                  trigger: _isExpanded,
                  phases: [false, true],
                  styleBuilder: (phase, style) {
                    return style
                        .scale(phase ? 1.25 : 0.85)
                        .width(phase ? 45 : 40);
                  },
                  configBuilder: (phase) {
                    return AnimationConfig.easeOut(200.ms);
                  },
                ),
          ),
        ),
      ),
    );
  }
}
