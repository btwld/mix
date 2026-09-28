import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);
const successColor = Color(0xFF3DD68C);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: LatticeLoader()),
        ),
      ),
    ),
  ),
);

final loaderRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(12)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Highlights the active cell, then colors the completed grid.
BoxStyler loaderCellStyle({
  required int phase,
  required String? status,
  required int index,
}) => BoxStyler()
    .size(12, 12)
    .borderRadius(.circular(3))
    .color(
      status == 'done'
          ? successColor
          : (phase % 9 == index ? inkColor : trackColor),
    )
    .animate(.easeInOut(120.ms));

final loaderLabels = FlexBoxStyler()
    .direction(.vertical)
    .spacing(2)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

final loaderTitle = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

final loaderCaption = TextStyler()
    .color(mutedColor)
    .fontSize(12)
    .fontWeight(.w500);

/// Tap to simulate work; a timer advances the highlighted grid cell.
class LatticeLoader extends StatefulWidget {
  const LatticeLoader({super.key});

  @override
  State<LatticeLoader> createState() => _LatticeLoaderState();
}

class _LatticeLoaderState extends State<LatticeLoader> {
  int _phase = 0;
  String _status = 'idle';
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _run() {
    _timer?.cancel();
    setState(() {
      _status = 'run';
      _phase = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (!mounted) return;
      setState(() => _phase++);
      if (_phase > 18) {
        timer.cancel();
        setState(() => _status = 'done');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _phase * 0.09;
    return Pressable(
      key: const Key('lattice-loader'),
      onPress: _status == 'run' ? null : _run,
      child: loaderRow(
        children: [
          SizedBox(
            width: 42,
            child: Wrap(
              spacing: 3,
              runSpacing: 3,
              children: [
                for (var i = 0; i < 9; i++)
                  loaderCellStyle(phase: _phase, status: _status, index: i)(),
              ],
            ),
          ),
          loaderLabels(
            children: [
              loaderTitle(_status == 'done' ? 'Shipped' : 'Thinking'),
              loaderCaption(
                _status == 'idle'
                    ? 'Tap to run'
                    : '${elapsed.toStringAsFixed(1)}s',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
