import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const accentColor = Color(0xFF7C6AF7);
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
          child: Padding(padding: .all(24), child: ThoughtLine()),
        ),
      ),
    ),
  ),
);

final thoughtStage = BoxStyler()
    .size(240, 110)
    .color(Colors.transparent)
    .alignment(.topLeft);

final thoughtColumn = FlexBoxStyler()
    .direction(.vertical)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

final thoughtRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Switches the heading icon's color when the work finishes.
IconStyler thoughtIconStyle({required bool isDone}) =>
    IconStyler().size(16).color(isDone ? successColor : accentColor);

final thoughtTitle = TextStyler()
    .color(inkColor)
    .fontSize(13)
    .fontWeight(.w600);

/// Unfolds and fades each step while its parent handles hidden interaction.
BoxStyler thoughtRevealStyle({required bool isVisible}) => BoxStyler()
    .wrap(
      .align(
        alignment: .topLeft,
        widthFactor: 1,
        heightFactor: isVisible ? 1 : 0,
      ).opacity(isVisible ? 1 : 0),
    )
    .animate(.easeOut(180.ms));

final thoughtInset = BoxStyler().padding(.top(6)).padding(.left(24));

final thoughtLabel = TextStyler()
    .color(mutedColor)
    .fontSize(12)
    .fontWeight(.w500);

/// Tap to reveal the simulated work steps, then tap again to restart.
class ThoughtLine extends StatefulWidget {
  const ThoughtLine({super.key});

  @override
  State<ThoughtLine> createState() => _ThoughtLineState();
}

class _ThoughtLineState extends State<ThoughtLine> {
  int _step = -1;
  Timer? _timer;

  static const _steps = [
    'Read the tokens',
    'Sketch the motion',
    'Commit the style',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _run() {
    _timer?.cancel();
    setState(() => _step = 1);
    _timer = Timer.periodic(const Duration(milliseconds: 420), (timer) {
      if (!mounted) return;
      if (_step >= _steps.length) {
        setState(() => _step++);
        timer.cancel();
        return;
      }
      setState(() => _step++);
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _step > _steps.length;
    final thoughtIcon = thoughtIconStyle(isDone: done);

    return Pressable(
      key: const Key('thought-line'),
      onPress: _run,
      child: thoughtStage(
        child: thoughtColumn(
          children: [
            thoughtRow(
              children: [
                thoughtIcon(
                  icon: done ? Icons.check_circle_outline : Icons.auto_awesome,
                ),
                thoughtTitle(
                  done
                      ? 'Thought for 1.3s'
                      : (_step < 0 ? 'Run thought' : 'Thinking'),
                ),
              ],
            ),
            for (var i = 0; i < _steps.length; i++)
              IgnorePointer(
                ignoring: done || i >= _step,
                child: ExcludeSemantics(
                  excluding: done || i >= _step,
                  child: ClipRect(
                    child: thoughtRevealStyle(isVisible: !done && i < _step)(
                      child: thoughtInset(child: thoughtLabel(_steps[i])),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
