import 'dart:async';

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
  final trigger = ValueNotifier(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(5.s, (timer) {
      trigger.value++;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  BoxMix get _boxStyle => Style.box()
      .color(Colors.blueAccent.shade400)
      .paddingX(16)
      .paddingY(8)
      .borderRounded(30)
      .foregroundLinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0),
        ],
        stops: [0.0, 0.3, 0.4, 1],
        tileMode: TileMode.clamp,
      )
      .keyframeAnimation(
        trigger: trigger,
        timeline: [
          KeyframeTrack<double>('progress', initial: -1, [
            Keyframe.ease(1, 2000.ms),
          ]),
        ],
        styleBuilder: (values, style) => style.foregroundDecoration(
          BoxDecorationMix.gradient(
            LinearGradientMix(
              transform: _SlidingGradientTransform(
                slidePercent: values.get('progress'),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Box(
          style: _boxStyle,
          child: StyledText(
            'Update',
            style: Style.text()
                //
                .color(Colors.white)
                .fontWeight(FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()
      ..translateByDouble(bounds.width * slidePercent, 0.0, 0.0, 1);
  }
}
