import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const successColor = Color(0xFF3DD68C);
const dangerColor = Color(0xFFFF5C7A);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: StatusMark()),
        ),
      ),
    ),
  ),
);

final statusRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(10)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final statusLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Tap through four statuses; Flutter paints the glyph and Mix styles the row.
class StatusMark extends StatefulWidget {
  const StatusMark({super.key});

  @override
  State<StatusMark> createState() => _StatusMarkState();
}

class _StatusMarkState extends State<StatusMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  int _stage = 0;

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  void _cycle() {
    final next = (_stage + 1) % 4;
    setState(() => _stage = next);
    if (next == 1) {
      _spin.repeat();
    } else {
      _spin.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      key: const Key('status-mark'),
      onPress: _cycle,
      child: statusRow(
        children: [
          AnimatedBuilder(
            animation: _spin,
            builder: (context, _) {
              return TweenAnimationBuilder<double>(
                key: ValueKey(_stage),
                tween: Tween(begin: 0, end: 1),
                duration: 260.ms,
                curve: Curves.easeOut,
                builder: (context, reveal, _) => CustomPaint(
                  size: const Size(22, 22),
                  painter: _StatusPainter(
                    stage: _stage,
                    reveal: reveal,
                    spin: _spin.value,
                    ink: inkColor,
                    success: successColor,
                    danger: dangerColor,
                    muted: mutedColor,
                  ),
                ),
              );
            },
          ),
          statusLabel(const ['Idle', 'Running', 'Done', 'Failed'][_stage]),
        ],
      ),
    );
  }
}

class _StatusPainter extends CustomPainter {
  _StatusPainter({
    required this.stage,
    required this.reveal,
    required this.spin,
    required this.ink,
    required this.success,
    required this.danger,
    required this.muted,
  });

  final int stage;
  final double reveal;
  final double spin;
  final Color ink;
  final Color success;
  final Color danger;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    if (stage == 0) {
      paint.color = muted.withValues(alpha: reveal);
      canvas.drawCircle(center, 8, paint..strokeWidth = 1.5);
      return;
    }
    if (stage == 1) {
      paint.color = ink.withValues(alpha: reveal);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 8),
        spin * math.pi * 2,
        math.pi * 1.2 * reveal,
        false,
        paint,
      );
      return;
    }
    paint.color = (stage == 2 ? success : danger).withValues(alpha: reveal);
    canvas.drawCircle(center, 8, paint);
    if (stage == 2) {
      canvas.drawPath(
        Path()
          ..moveTo(center.dx - 4, center.dy)
          ..lineTo(center.dx - 1, center.dy + 3)
          ..lineTo(center.dx + 5, center.dy - 3),
        paint,
      );
    } else {
      canvas
        ..drawLine(
          center + const Offset(-3, -3),
          center + const Offset(3, 3),
          paint,
        )
        ..drawLine(
          center + const Offset(3, -3),
          center + const Offset(-3, 3),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _StatusPainter oldDelegate) {
    return oldDelegate.stage != stage ||
        oldDelegate.reveal != reveal ||
        oldDelegate.spin != spin ||
        oldDelegate.ink != ink ||
        oldDelegate.success != success ||
        oldDelegate.danger != danger ||
        oldDelegate.muted != muted;
  }
}
