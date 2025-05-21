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
          child: MyRadioGroup(),
        ),
      ),
    );
  }
}

enum RadioOption {
  banana,
  apple,
}

class MyRadioGroup extends StatefulWidget {
  const MyRadioGroup({super.key});

  @override
  State<MyRadioGroup> createState() => _MyRadioGroupState();
}

class _MyRadioGroupState extends State<MyRadioGroup> {
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
          RadioButton(value: RadioOption.banana),
          RadioButton(value: RadioOption.apple),
        ],
      ),
    );
  }
}

class RadioButton extends StatefulWidget {
  const RadioButton({
    super.key,
    required this.value,
  });

  final RadioOption value;

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  Color getBorderColor(bool isSelected) {
    const baseColor = Color(0xFF3D3D3D);
    if (isSelected) {
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
    return NakedRadioButton<RadioOption>(
      value: widget.value,
      onFocusState: (focused) => setState(() => _isFocused = focused),
      onHoverState: (hovered) => setState(() => _isHovered = hovered),
      onPressedState: (pressed) => setState(() => _isPressed = pressed),
      builder: (_, selected) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: getBorderColor(selected),
              width: selected ? 6 : 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}
