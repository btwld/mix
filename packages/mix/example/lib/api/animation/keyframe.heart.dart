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
      body: Center(child: HeartAnimation()),
      backgroundColor: Colors.white,
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
        style: BoxStyler().keyframeAnimation(
          trigger: _trigger,
          timeline: [
            KeyframeTrack<double>('scale', [
              .linear(1.0, 360.ms),
              .elasticOut(1.5, 800.ms),
              .elasticOut(1.0, 800.ms),
            ], initial: 1.0),
            KeyframeTrack<double>('verticalOffset', [
              .linear(0.0, 100.ms),
              .easeIn(20.0, 150.ms),
              .elasticOut(-60.0, 1000.ms),
              .elasticOut(0.0, 800.ms),
            ], initial: 0.0),
            KeyframeTrack<double>('verticalStretch', [
              .ease(1.0, 100.ms),
              .ease(0.6, 150.ms),
              .ease(1.5, 100.ms),
              .ease(1.05, 150.ms),
              .ease(1.0, 880.ms),
              .ease(0.8, 100.ms),
              .ease(1.04, 400.ms),
              .ease(1.0, 220.ms),
            ], initial: 1.0),
            KeyframeTrack<double>('angle', [
              .easeIn(0.0, 580.ms),
              .easeIn(16.0 * (pi / 180), 125.ms),
              .easeIn(-16.0 * (pi / 180), 125.ms),
              .easeIn(16.0 * (pi / 180), 125.ms),
              .easeIn(0.0, 125.ms),
            ], initial: 0.0),
          ],
          styleBuilder: (values, style) {
            final scale = values.get('scale');
            final verticalOffset = values.get('verticalOffset');
            final verticalStretch = values.get('verticalStretch');
            final angle = values.get('angle');

            return style
                .wrap(.scale(scale, scale * verticalStretch))
                .wrap(.translate(x: 0, y: verticalOffset))
                .wrap(.rotate(radians: angle));
          },
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [Colors.redAccent.shade100, Colors.redAccent.shade400],
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
