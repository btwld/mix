import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
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
          child: Padding(padding: .all(24), child: SlingButton()),
        ),
      ),
    ),
  ),
);

/// Follows the pull directly, then springs into recoil or rest.
BoxStyler slingButtonStyle({
  required bool isDragging,
  required bool isFired,
  required double pull,
}) {
  final scale = isFired ? 1.04 : 1.0;
  return BoxStyler()
      .paddingX(18)
      .paddingY(12)
      .borderRounded(16)
      .color(isFired ? successColor : accentColor)
      .wrap(
        // Keep recoil translation independent of the success scale.
        .translate(x: isFired ? 28 : -pull, y: 0)
            .scale(scale, scale)
            .orderOfModifiers(const [TranslateModifier, ScaleModifier]),
      )
      .animate(
        isDragging && !isFired ? .linear(1.ms) : .spring(320.ms, bounce: 0.18),
      );
}

final slingLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Pull left and release past the threshold to send, otherwise spring back.
class SlingButton extends StatefulWidget {
  const SlingButton({super.key});

  @override
  State<SlingButton> createState() => _SlingButtonState();
}

class _SlingButtonState extends State<SlingButton> {
  double _pull = 0;
  bool _fired = false;
  bool _dragging = false;
  bool _canceled = false;

  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _fire() {
    setState(() => _fired = true);
    _resetTimer = Timer(700.ms, () {
      setState(() {
        _fired = false;
        _pull = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final slingButton = slingButtonStyle(
      isDragging: _dragging,
      isFired: _fired,
      pull: _pull,
    );

    return Listener(
      onPointerCancel: (_) => setState(() {
        _canceled = true;
        _dragging = false;
        _pull = 0;
      }),
      child: GestureDetector(
        key: const Key('sling-button'),
        onHorizontalDragStart: _fired
            ? null
            : (_) => setState(() {
                _dragging = true;
                _canceled = false;
              }),
        onHorizontalDragUpdate: _fired
            ? null
            : (details) {
                setState(
                  () => _pull = (_pull - details.delta.dx).clamp(0.0, 36.0),
                );
              },
        onHorizontalDragEnd: _fired
            ? null
            : (_) {
                if (_canceled) return;
                setState(() => _dragging = false);
                if (_pull > 16) {
                  _fire();
                } else {
                  setState(() => _pull = 0);
                }
              },
        onHorizontalDragCancel: () => setState(() {
          _dragging = false;
          _pull = 0;
        }),
        child: slingButton(
          child: slingLabel(_fired ? 'Sent' : 'Pull left to send'),
        ),
      ),
    );
  }
}
