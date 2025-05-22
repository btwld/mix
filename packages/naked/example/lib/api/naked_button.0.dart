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
          child: ButtonExample(),
        ),
      ),
    );
  }
}

class ButtonExample extends StatefulWidget {
  const ButtonExample({super.key});

  @override
  State<ButtonExample> createState() => _ButtonExampleState();
}

class _ButtonExampleState extends State<ButtonExample> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  Color get backgroundColor {
    const baseColor = Color(0xFF3D3D3D);
    if (_isPressed) {
      return baseColor.withValues(alpha: 0.8);
    }
    if (_isHovered) {
      return baseColor.withValues(alpha: 0.9);
    }
    return baseColor;
  }

  double get scale {
    if (_isPressed) {
      return 0.95;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: () {
        debugPrint('Button pressed!');
      },
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
      onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isFocused ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Button',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
