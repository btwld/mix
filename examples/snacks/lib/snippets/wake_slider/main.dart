import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: WakeSlider()),
        ),
      ),
    ),
  ),
);

/// Drag to grow a painted wake that settles on release.
class WakeSlider extends StatefulWidget {
  const WakeSlider({super.key});

  @override
  State<WakeSlider> createState() => _WakeSliderState();
}

class _WakeSliderState extends State<WakeSlider> {
  double _value = 0.45;
  double _wake = 0;
  bool _settling = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        key: const Key('wake-slider'),
        onHorizontalDragUpdate: (details) {
          setState(() {
            _settling = false;
            _value = (_value + details.delta.dx / 220).clamp(0.0, 1.0);
            _wake = details.delta.dx.abs().clamp(0.0, 18.0);
          });
        },
        onHorizontalDragEnd: (_) => setState(() {
          _settling = true;
          _wake = 0;
        }),
        onHorizontalDragCancel: () => setState(() {
          _settling = false;
          _wake = 0;
        }),
        child: SizedBox(
          width: 220,
          height: 46,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _wake),
            duration: _settling ? 320.ms : Duration.zero,
            curve: Curves.easeOut,
            builder: (context, wake, _) => CustomPaint(
              painter: _WakePainter(
                value: _value,
                wake: wake,
                ink: inkColor,
                muted: trackColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WakePainter extends CustomPainter {
  _WakePainter({
    required this.value,
    required this.wake,
    required this.ink,
    required this.muted,
  });

  final double value;
  final double wake;
  final Color ink;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    const bars = 22;
    final gap = size.width / bars;
    for (var i = 0; i < bars; i++) {
      final t = i / (bars - 1);
      final distance = (t - value).abs();
      final active = t <= value;
      final height = 10.0 + math.max(0.0, wake - distance * 48);
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(gap * i + gap / 2, size.height / 2),
          width: 5,
          height: height.clamp(10.0, 36.0),
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, Paint()..color = active ? ink : muted);
    }
  }

  @override
  bool shouldRepaint(covariant _WakePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.wake != wake ||
        oldDelegate.ink != ink ||
        oldDelegate.muted != muted;
  }
}
