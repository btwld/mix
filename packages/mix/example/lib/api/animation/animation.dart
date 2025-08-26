import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const SimpleContainerApp());
}

class SimpleContainerApp extends StatefulWidget {
  const SimpleContainerApp({super.key});

  @override
  State<SimpleContainerApp> createState() => _SimpleContainerAppState();
}

class _SimpleContainerAppState extends State<SimpleContainerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: KeyframeAnimation())),
    );
  }
}

class KeyframeAnimation extends StatefulWidget {
  const KeyframeAnimation({super.key});

  @override
  State<KeyframeAnimation> createState() => _KeyframeAnimationState();
}

class _KeyframeAnimationState extends State<KeyframeAnimation> {
  final trigger = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => trigger.value++,
      child: Box(
        style: Style.box(
          BoxMix() //
              .borderRadius(BorderRadiusDirectionalMix.circular(20))
              .color(Colors.blue)
              .width(150)
              .height(150)
              .transformAlignment(Alignment.center)
              .keyframes(
                trigger: trigger,
                timeline: [
                  KeyframeTrack<Color?>(
                    'color',
                    tweenBuilder: ColorTween.new,
                    initialValue: Colors.blue,
                    [
                      KeyframeSegment(Duration(seconds: 1), Colors.red),
                      KeyframeSegment(Duration(seconds: 2), Colors.green),
                    ],
                  ),
                  KeyframeTrack<double?>(
                    'scale',
                    tweenBuilder: Tween<double>.new,
                    initialValue: 1.0,
                    [
                      KeyframeSegment(1.seconds, 2.0, curve: Curves.easeIn),
                      KeyframeSegment(2.seconds, 1.0, curve: Curves.elasticOut),
                    ],
                  ),
                ],
                styleBuilder: (result, style) => (style as BoxMix)
                    .color(result['color'] as Color)
                    .scale(result['scale'] as double),
              ),
        ),
      ),
    );
  }
}
