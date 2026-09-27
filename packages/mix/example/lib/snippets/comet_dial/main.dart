import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const accentColor = Color(0xFF7C6AF7);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: CometDial()),
        ),
      ),
    ),
  ),
);

final dialLabel = TextStyler().color(inkColor).fontSize(22).fontWeight(.w600);

/// Drag horizontally to change the dial; its painted trail settles on release.
class CometDial extends StatefulWidget {
  const CometDial({super.key});

  @override
  State<CometDial> createState() => _CometDialState();
}

class _CometDialState extends State<CometDial> {
  double _angle = -math.pi / 2;
  double _speed = 0;
  bool _settling = false;

  @override
  Widget build(BuildContext context) {
    final progress = ((_angle + math.pi / 2) / (math.pi * 1.5)).clamp(0.0, 1.0);
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        key: const Key('comet-dial'),
        onPanUpdate: (details) {
          setState(() {
            _settling = false;
            _angle = (_angle + details.delta.dx * 0.02).clamp(
              -math.pi / 2,
              math.pi,
            );
            _speed = details.delta.dx.clamp(-12.0, 12.0);
          });
        },
        onPanEnd: (_) => setState(() {
          _settling = true;
          _speed = 0;
        }),
        onPanCancel: () => setState(() {
          _settling = false;
          _speed = 0;
        }),
        child: SizedBox(
          width: 120,
          height: 120,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _speed),
            duration: _settling ? 320.ms : Duration.zero,
            curve: Curves.easeOut,
            builder: (context, speed, _) => CustomPaint(
              painter: _CometPainter(
                angle: _angle,
                speed: speed,
                ink: inkColor,
                muted: trackColor,
                accent: accentColor,
              ),
              child: Center(child: dialLabel('${(progress * 100).round()}')),
            ),
          ),
        ),
      ),
    );
  }
}

class _CometPainter extends CustomPainter {
  _CometPainter({
    required this.angle,
    required this.speed,
    required this.ink,
    required this.muted,
    required this.accent,
  });

  final double angle;
  final double speed;
  final Color ink;
  final Color muted;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    for (var i = 0; i < 24; i++) {
      final t = -math.pi / 2 + (math.pi * 1.5) * (i / 23);
      final outer = Offset(
        center.dx + math.cos(t) * radius,
        center.dy + math.sin(t) * radius,
      );
      final inner = Offset(
        center.dx + math.cos(t) * (radius - 8),
        center.dy + math.sin(t) * (radius - 8),
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = t <= angle ? ink : muted
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
    final head = Offset(
      center.dx + math.cos(angle) * (radius - 4),
      center.dy + math.sin(angle) * (radius - 4),
    );
    canvas.drawCircle(head, 6, Paint()..color = accent);
    if (speed.abs() > 0.4) {
      final tail = Offset(
        center.dx + math.cos(angle - 0.35 * speed.sign) * (radius - 4),
        center.dy + math.sin(angle - 0.35 * speed.sign) * (radius - 4),
      );
      canvas.drawLine(
        tail,
        head,
        Paint()
          ..color = accent.withValues(
            alpha: 0.45 * (speed.abs() / 12).clamp(0.0, 1.0),
          )
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CometPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.speed != speed ||
        oldDelegate.ink != ink ||
        oldDelegate.muted != muted ||
        oldDelegate.accent != accent;
  }
}
