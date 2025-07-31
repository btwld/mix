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

class _DemoAppState extends State<DemoApp> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animatedCurve;
  final Tween<double> _tween = Tween<double>(begin: -1, end: 1);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: 1500.ms, vsync: this);
    _animatedCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _timer = Timer.periodic(3.s, (timer) {
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  BoxMix get _boxStyle => Style.box()
      .color(Colors.blueAccent.shade400)
      .padding(EdgeInsetsMix.symmetric(horizontal: 16, vertical: 8))
      .borderRadius(BorderRadiusMix.circular(30))
      .foregroundDecoration(
        BoxDecorationMix.gradient(
          LinearGradientMix()
              .colors([
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0),
              ])
              .stops([0.0, 0.3, 0.4, 1])
              .tileMode(TileMode.clamp)
              .transform(
                _SlidingGradientTransform(
                  slidePercent: _tween.animate(_animatedCurve).value,
                ),
              ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animatedCurve,
          builder: (context, child) {
            return Box(
              style: _boxStyle,
              child: StyledText(
                'Update',
                style: Style.text()
                    .color(Colors.white)
                    .fontWeight(FontWeight.w500),
              ),
            );
          },
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
