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
          child: RadioExample(),
        ),
      ),
    );
  }
}

enum RadioOption {
  banana,
  apple,
}

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  RadioOption _selectedValue = RadioOption.banana;

  @override
  Widget build(BuildContext context) {
    return NakedRadioGroup<RadioOption>(
      groupValue: _selectedValue,
      onChanged: (value) {
        setState(() => _selectedValue = value!);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Radio(value: RadioOption.banana),
          Radio(value: RadioOption.apple),
        ],
      ),
    );
  }
}

class Radio extends StatefulWidget {
  const Radio({
    super.key,
    required this.value,
  });

  final RadioOption value;

  @override
  State<Radio> createState() => _RadioState();
}

class _RadioState extends State<Radio> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  bool _isSelected = false;

  Color get borderColor {
    const baseColor = Color(0xFF3D3D3D);
    if (_isSelected) {
      return baseColor;
    }
    if (_isPressed || _isFocused) {
      return baseColor.withValues(alpha: 0.6);
    }
    if (_isHovered) {
      return baseColor.withValues(alpha: 0.3);
    }
    return baseColor.withValues(alpha: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return NakedRadio<RadioOption>(
      value: widget.value,
      onFocusState: (focused) => setState(() => _isFocused = focused),
      onHoverState: (hovered) => setState(() => _isHovered = hovered),
      onSelectState: (selected) => setState(() => _isSelected = selected),
      onPressedState: (pressed) => setState(() => _isPressed = pressed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: _isSelected ? 6 : 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
