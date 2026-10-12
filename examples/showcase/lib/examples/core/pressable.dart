import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _blue = Color(0xFF3B6EF5);

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: PressableExample())),
  ),
);

/// PressableBox supplies keyboard, pointer, focus, and pressed-state behavior.
class PressableExample extends StatefulWidget {
  const PressableExample({super.key});

  @override
  State<PressableExample> createState() => _PressableExampleState();
}

class _PressableExampleState extends State<PressableExample> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) => PressableBox(
    semanticsLabel: _pressed ? 'Pressed' : 'Press me',
    onPress: () => setState(() => _pressed = !_pressed),
    style: BoxStyler()
        .color(_pressed ? const Color(0xFF274CB9) : _blue)
        .padding(.horizontal(28))
        .padding(.vertical(14))
        .borderRadius(.circular(9))
        .onHovered(.scale(1.04))
        .onPressed(.scale(0.95))
        .animate(.easeOut(160.ms)),
    child: Text(
      _pressed ? 'Pressed!' : 'Press me',
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}
