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
        body: Center(
          child: ExampleCheckbox(),
        ),
      ),
    );
  }
}

class ExampleCheckbox extends StatefulWidget {
  const ExampleCheckbox({super.key});

  @override
  State<ExampleCheckbox> createState() => _ExampleCheckboxState();
}

class _ExampleCheckboxState extends State<ExampleCheckbox> {
  bool _isChecked = false;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  Color get borderColor {
    const baseColor = Color(0xFF3D3D3D);

    if (_isChecked) {
      return baseColor;
    }
    if (_isFocused) {
      return baseColor.withValues(alpha: 0.8);
    }
    if (_isHovered || _isPressed) {
      return baseColor.withValues(alpha: 0.6);
    }
    return baseColor.withValues(alpha: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
        });
      },
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
      onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6),
              color: _isChecked ? const Color(0xFF3D3D3D) : Colors.transparent,
            ),
            child: _isChecked
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          const Text(
            'Label',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3D3D),
            ),
          ),
        ],
      ),
    );
  }
}
