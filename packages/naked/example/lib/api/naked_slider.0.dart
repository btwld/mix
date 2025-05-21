import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MySlider(),
        ),
      ),
    );
  }
}

class MySlider extends StatefulWidget {
  const MySlider({super.key});

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: SizedBox(
        width: double.infinity,
        height: 20,
        child: NakedSlider(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
          },
          child: CustomPaint(
            foregroundPainter: SliderThumbPainter(
              value: _value,
              thumbColor: Colors.white,
              thumbSize: 18,
              borderColor: Colors.black,
            ),
            painter: SliderTrackPainter(
              value: _value,
              activeTrackColor: Colors.black,
              trackColor: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}

class SliderTrackPainter extends CustomPainter {
  final double value;
  final Color activeTrackColor;
  final Color trackColor;

  SliderTrackPainter({
    required this.value,
    required this.activeTrackColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = activeTrackColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final double verticalCenter = size.height / 2;

    canvas.drawLine(
      Offset(0, verticalCenter),
      Offset(size.width, verticalCenter),
      backgroundPaint,
    );

    canvas.drawLine(
      Offset(0, verticalCenter),
      Offset(size.width * value, verticalCenter),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(SliderTrackPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.activeTrackColor != activeTrackColor ||
        oldDelegate.trackColor != trackColor;
  }
}

class SliderThumbPainter extends CustomPainter {
  final double value;
  final double thumbSize;
  final Color thumbColor;
  final Color borderColor;

  SliderThumbPainter({
    required this.value,
    required this.thumbSize,
    required this.thumbColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint thumbPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double verticalCenter = size.height / 2;

    canvas.drawCircle(
      Offset(size.width * value, verticalCenter),
      thumbSize / 2,
      thumbPaint,
    );

    canvas.drawCircle(
      Offset(size.width * value, verticalCenter),
      thumbSize / 2,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(SliderThumbPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.thumbSize != thumbSize;
  }
}
