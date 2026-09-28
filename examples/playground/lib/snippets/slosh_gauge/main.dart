import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const playgroundColor = Color(0xFF0C0C12);
const inkColor = Color(0xFFF5F5F7);
const accentColor = Color(0xFF7C6AF7);
const likeColor = Color(0xFFFF4D6D);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: SloshGauge()),
        ),
      ),
    ),
  ),
);

final gaugeColumn = FlexBoxStyler()
    .direction(.vertical)
    .spacing(10)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final gaugeVessel = BoxStyler()
    .width(72)
    .height(112)
    .borderRounded(16)
    .border(.color(const Color(0x33FFFFFF)).width(2))
    .clipBehavior(.antiAlias)
    .color(playgroundColor)
    .alignment(.bottomCenter);

/// Follows the fill amount without a spring that could overshoot below zero.
BoxStyler gaugeFillStyle({required double value}) =>
    BoxStyler().width(72).height(112 * value).animate(.linear(1.ms));

/// Lets the liquid tilt settle independently of the fill height.
BoxStyler gaugeSurfaceStyle({required double tilt, required bool isDragging}) =>
    BoxStyler()
        .size(72, 112)
        .linearGradient(
          colors: [accentColor, likeColor],
          begin: .bottomCenter,
          end: .topCenter,
        )
        .skew(0, isDragging ? tilt : 0)
        .animate(isDragging ? .linear(1.ms) : .spring(320.ms, bounce: 0.18));

final gaugeLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Drag vertically to fill the vessel; only the liquid's tilt uses a spring.
class SloshGauge extends StatefulWidget {
  const SloshGauge({super.key});

  @override
  State<SloshGauge> createState() => _SloshGaugeState();
}

class _SloshGaugeState extends State<SloshGauge> {
  double _value = 0.42;
  double _tilt = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final gaugeFill = gaugeFillStyle(value: _value);
    final gaugeSurface = gaugeSurfaceStyle(tilt: _tilt, isDragging: _dragging);

    return gaugeColumn(
      key: const Key('slosh-gauge'),
      children: [
        GestureDetector(
          onVerticalDragStart: (_) => setState(() => _dragging = true),
          onVerticalDragEnd: (_) => setState(() => _dragging = false),
          onVerticalDragCancel: () => setState(() => _dragging = false),
          onVerticalDragUpdate: (details) {
            setState(() {
              _value = (_value - details.delta.dy / 120).clamp(0.0, 1.0);
              _tilt = (-details.delta.dy / 120).clamp(-.12, .12);
            });
          },
          child: gaugeVessel(
            child: gaugeFill(
              // Spring only the tilt: a height spring can overshoot below zero.
              child: gaugeSurface(),
            ),
          ),
        ),
        gaugeLabel('${(_value * 100).round()}%'),
      ],
    );
  }
}
