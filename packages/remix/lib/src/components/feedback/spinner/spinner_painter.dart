part of 'spinner.dart';

abstract interface class SpinnerPainter extends CustomPainter {
  final Animation<double> animation;
  final double strokeWidth;
  final Color color;

  SpinnerPainter({
    required this.animation,
    required this.strokeWidth,
    required this.color,
  }) : super(repaint: animation);
}

class DottedSpinnerPainter extends SpinnerPainter {
  DottedSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final specStrokeWidth = strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth;

    canvas.translate(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    const lines = 12;
    const lineAngle = 2 * pi / lines;

    for (int i = 0; i < lines; i++) {
      final angle = i * lineAngle;
      final opacity = (lines - i + animation.value * lines) % lines / lines;

      paint.color = color.withOpacity(opacity);

      final lineHeight = radius * 0.45;

      canvas.drawLine(
        Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle)),
        Offset(lineHeight * cos(angle), lineHeight * sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DottedSpinnerPainter oldDelegate) => true;
}

class StrippedSpinnerPainter extends SpinnerPainter {
  StrippedSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final specStrokeWidth = strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth;

    canvas.translate(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    const lines = 12;
    const lineAngle = 2 * pi / lines;

    for (int i = 0; i < lines; i++) {
      final angle = i * lineAngle;
      final opacity = (lines - i + animation.value * lines) % lines / lines;

      paint.color = color.withOpacity(opacity);

      final lineHeight = radius * 0.8;

      canvas.drawLine(
        Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle)),
        Offset(lineHeight * cos(angle), lineHeight * sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DottedSpinnerPainter oldDelegate) => true;
}

class SolidSpinnerPainter extends SpinnerPainter {
  SolidSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final specStrokeWidth = strokeWidth;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth
      ..color = color;

    canvas.translate(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    const startAngle = pi / 3;
    const sweepAngle = 2 * pi / 3;

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle + animation.value * 2 * pi,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(SolidSpinnerPainter oldDelegate) => true;
}
