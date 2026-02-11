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

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  BoxStyler get _boxStyle => BoxStyler()
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
        tileMode: .clamp,
      )
      .keyframeAnimation(
        timeline: [
          // ignore: avoid-inferrable-type-arguments
          KeyframeTrack<double>('progress', [.ease(1.0, 2000.ms)], initial: -1),
        ],
        styleBuilder: (values, style) => style.foregroundDecoration(
          .gradient(
            LinearGradientMix().transform(
              _SlidingGradientTransform(slidePercent: values.get('progress')),
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
            style: TextStyler()
                //
                .color(Colors.white)
                .fontWeight(.w500),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return .identity()
      ..translateByDouble(bounds.width * slidePercent, 0.0, 0.0, 1);
  }
}
