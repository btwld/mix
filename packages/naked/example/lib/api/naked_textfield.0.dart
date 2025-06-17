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
          child: TextFieldExample(),
        ),
      ),
    );
  }
}

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  Color get _backgroundColor {
    const baseColor = Colors.white;
    if (_isPressed || _isFocused) {
      return baseColor;
    }
    if (_isHovered) {
      return Colors.grey.shade200;
    }
    return baseColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: NakedTextField(
        cursorColor: Colors.grey.shade700,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
        onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
        onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
        builder: (context, textArea) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _backgroundColor,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 3,
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
            child: textArea,
          );
        },
      ),
    );
  }
}
