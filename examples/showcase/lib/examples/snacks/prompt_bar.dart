import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const playgroundColor = Color(0xFF0C0C12);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: .dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C6AF7),
        brightness: .dark,
      ),
      useMaterial3: true,
    ),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: PromptBar()),
        ),
      ),
    ),
  ),
);

final promptSurface = BoxStyler()
    .color(trackColor)
    .borderRadius(.circular(16))
    .padding(.all(8))
    .width(280);

final promptRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center);

/// Gives the send/stop tile a small press-and-release spring.
BoxStyler promptButtonStyle({required bool isEnabled}) => BoxStyler()
    .size(34, 34)
    .borderRadius(.circular(8))
    .alignment(.center)
    .color(isEnabled ? inkColor : playgroundColor)
    .onPressed(.scale(0.92))
    .animate(.spring(240.ms, bounce: 0.12));

/// Keeps the action icon legible against its tile.
IconStyler promptIconStyle({required bool isEnabled}) =>
    IconStyler().size(16).color(isEnabled ? pageColor : mutedColor);

/// Enter a prompt and send it; the same button can stop the simulated request.
class PromptBar extends StatefulWidget {
  const PromptBar({super.key});

  @override
  State<PromptBar> createState() => _PromptBarState();
}

class _PromptBarState extends State<PromptBar> {
  final _controller = TextEditingController();
  bool _busy = false;
  Timer? _completion;

  @override
  void dispose() {
    _completion?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_busy || _controller.text.trim().isEmpty) return;
    final sentText = _controller.text;
    setState(() => _busy = true);
    _completion = Timer(900.ms, () {
      // Completion must not erase a different draft typed while busy.
      if (_controller.text == sentText) _controller.clear();
      setState(() => _busy = false);
    });
  }

  void _stop() {
    _completion?.cancel();
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _controller.text.trim().isNotEmpty;
    final promptButton = promptButtonStyle(isEnabled: canSend || _busy);
    final promptIcon = promptIconStyle(isEnabled: canSend || _busy);

    return promptSurface(
      key: const Key('prompt-bar'),
      child: promptRow(
        children: [
          Expanded(
            child: SizedBox(
              height: 34,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: _controller,
                textInputAction: .send,
                onSubmitted: (_) => _send(),
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: inkColor, fontSize: 13),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  hintText: 'Ask Mix…',
                  hintStyle: TextStyle(color: Color(0xFF8B8B93)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: _busy ? 'Stop' : 'Send',
            child: PressableBox(
              onPress: _busy ? _stop : (canSend ? _send : null),
              style: promptButton,
              child: promptIcon(
                icon: _busy ? Icons.stop_rounded : Icons.arrow_upward_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
