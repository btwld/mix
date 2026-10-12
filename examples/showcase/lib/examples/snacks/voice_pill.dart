import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
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
          child: Padding(padding: .all(24), child: VoicePill()),
        ),
      ),
    ),
  ),
);

/// Springs the recording pill wider while held.
BoxStyler voiceSurfaceStyle({required bool isHeld}) => BoxStyler()
    .padding(.horizontal(isHeld ? 16 : 12))
    .padding(.vertical(10))
    .shape(.stadium())
    .color(isHeld ? dangerColor : trackColor)
    .animate(.spring(280.ms, bounce: 0.16));

final voiceRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final voiceIcon = IconStyler().size(18).color(inkColor);

final voiceBars = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(3)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Offsets each synthetic waveform bar's phase for a traveling pattern.
BoxStyler voiceBarStyle({required double progress, required int index}) =>
    BoxStyler()
        .width(3)
        .height(8 + 12 * (0.4 + 0.6 * math.sin(progress * math.pi * 2 + index)))
        .borderRadius(.circular(99))
        .color(inkColor);

/// Hold to animate a synthetic waveform; release or cancel to stop it.
class VoicePill extends StatefulWidget {
  const VoicePill({super.key});

  @override
  State<VoicePill> createState() => _VoicePillState();
}

class _VoicePillState extends State<VoicePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  bool _held = false;

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  void _stop() {
    _wave.stop();
    setState(() => _held = false);
  }

  @override
  Widget build(BuildContext context) {
    final voiceSurface = voiceSurfaceStyle(isHeld: _held);

    return Listener(
      onPointerDown: (_) {
        _wave.repeat();
        setState(() => _held = true);
      },
      onPointerUp: (_) => _stop(),
      onPointerCancel: (_) => _stop(),
      child: voiceSurface(
        key: const Key('voice-pill'),
        child: AnimatedBuilder(
          animation: _wave,
          builder: (context, _) {
            return voiceRow(
              children: [
                voiceIcon(icon: Icons.mic_rounded),
                if (_held)
                  voiceBars(
                    children: [
                      for (var i = 0; i < 5; i++)
                        voiceBarStyle(progress: _wave.value, index: i)(),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
