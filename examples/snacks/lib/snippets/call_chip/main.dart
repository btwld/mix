import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
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
          child: Padding(padding: .all(24), child: CallChip()),
        ),
      ),
    ),
  ),
);

final callSurface = StackBoxStyler()
    .width(168)
    .height(36)
    .shapeStadium()
    .clipBehavior(.antiAlias)
    .color(trackColor)
    .stackAlignment(.centerLeft);

/// Animates simulated progress and reports completion to the owning state.
BoxStyler callProgressStyle({
  required String phase,
  required VoidCallback onEnd,
}) => BoxStyler()
    .height(36)
    .width(phase == 'idle' ? 0 : 168)
    .color(phase == 'bad' ? dangerColor : successColor)
    .animate(phase == 'run' ? .linear(900.ms, onEnd: onEnd) : .linear(1.ms));

final callInset = BoxStyler().paddingX(14).paddingY(8);

final callLabel = TextStyler().color(inkColor).fontSize(12).fontWeight(.w600);

/// Tap to simulate a call, alternating successful and failed completions.
class CallChip extends StatefulWidget {
  const CallChip({super.key});

  @override
  State<CallChip> createState() => _CallChipState();
}

class _CallChipState extends State<CallChip> {
  String _phase = 'idle';
  bool _okNext = true;

  void _run() {
    if (_phase == 'run') return;
    _okNext = _phase != 'ok';
    setState(() => _phase = 'idle');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _phase = 'run');
    });
  }

  void _finish() {
    if (!mounted || _phase != 'run') return;
    setState(() => _phase = _okNext ? 'ok' : 'bad');
  }

  @override
  Widget build(BuildContext context) {
    final callProgress = callProgressStyle(phase: _phase, onEnd: _finish);

    return Pressable(
      key: const Key('call-chip'),
      onPress: _run,
      child: callSurface(
        children: [
          KeyedSubtree(
            key: ValueKey(_okNext),
            child: callProgress(key: const Key('call-fill')),
          ),
          callInset(
            child: callLabel(switch (_phase) {
              'run' => 'search_docs  …',
              'ok' => 'search_docs  done',
              'bad' => 'search_docs  retry',
              _ => 'search_docs',
            }),
          ),
        ],
      ),
    );
  }
}
