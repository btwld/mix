import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: DemoApp());
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: HeartAnimation()),
    );
  }
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({super.key});

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> {
  final ValueNotifier<int> _trigger = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _trigger.value++;
        });
      },
      child: Box(
        style: Style.box()
            .transformAlignment(Alignment.center)
            .keyframes(
              trigger: _trigger,
              timeline: [
                KeyframeTrack<Color>(
                  'color',
                  tweenBuilder: ColorTween.new,
                  initial: Colors.red.shade100,
                  [
                    Keyframe.linear(Colors.blue.shade100, 100.ms),
                    Keyframe.elasticOut(Colors.blue.shade400, 800.ms),
                    Keyframe.elasticOut(Colors.green.shade100, 800.ms),
                  ],
                ),
                KeyframeTrack<double>('scale', initial: 1.0, [
                  Keyframe.linear(1.0, 360.ms),
                  Keyframe.elasticOut(1.5, 800.ms),
                  Keyframe.elasticOut(1.0, 800.ms),
                ]),
                KeyframeTrack<double>('verticalOffset', initial: 0.0, [
                  Keyframe.linear(0.0, 100.ms),
                  Keyframe.easeIn(20.0, 150.ms),
                  Keyframe.elasticOut(-60.0, 1000.ms),
                  Keyframe.elasticOut(0.0, 800.ms),
                ]),
                KeyframeTrack<double>('verticalStretch', initial: 1.0, [
                  Keyframe.ease(1.0, 100.ms),
                  Keyframe.ease(0.6, 150.ms),
                  Keyframe.ease(1.5, 100.ms),
                  Keyframe.ease(1.05, 150.ms),
                  Keyframe.ease(1.0, 880.ms),
                  Keyframe.ease(0.8, 100.ms),
                  Keyframe.ease(1.04, 400.ms),
                  Keyframe.ease(1.0, 220.ms),
                ]),
                KeyframeTrack<double>('angle', initial: 0.0, [
                  Keyframe.easeIn(0.0, 580.ms),
                  Keyframe.easeIn(16.0 * (pi / 180), 125.ms),
                  Keyframe.easeIn(-16.0 * (pi / 180), 125.ms),
                  Keyframe.easeIn(16.0 * (pi / 180), 125.ms),
                  Keyframe.easeIn(0.0, 125.ms),
                ]),
              ],
              styleBuilder: (values, style) {
                final scale = values.get('scale');
                final verticalOffset = values.get('verticalOffset');
                final verticalStretch = values.get('verticalStretch');
                final angle = values.get('angle');

                return style.transform(
                  Matrix4.identity()
                    ..scaleByDouble(scale, scale, scale, 1.0)
                    ..translateByDouble(0, verticalOffset, 0, 1)
                    ..scaleByDouble(1, verticalStretch, 1, 1)
                    ..rotateZ(angle),
                );
              },
            ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.redAccent.shade100, Colors.redAccent.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: StyledIcon(
            icon: CupertinoIcons.heart_fill,
            style: IconMix().size(100).color(Colors.white),
          ),
        ),
      ),
    );
  }
}
