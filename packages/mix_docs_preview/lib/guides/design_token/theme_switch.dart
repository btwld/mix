/// Theme Switching Example
///
/// A stadium-shaped box with text that toggles between light and dark themes.
/// Demonstrates swapping token maps at runtime via MixScope.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

final $bg = ColorToken('bg');
final $fg = ColorToken('fg');
final $border = ColorToken('border');

final _lightColors = {
  $bg: Colors.white,
  $fg: Colors.deepPurple,
  $border: Colors.deepPurple,
};

final _darkColors = {
  $bg: Colors.deepPurple.shade900,
  $fg: Colors.white,
  $border: Colors.deepPurpleAccent,
};

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool _isDark = false;

  BoxStyler get _box => BoxStyler()
      .color($bg())
      .shapeStadium()
      .padding(.symmetric(horizontal: 24, vertical: 12))
      .borderAll(color: $border(), width: 2)
      .animate(.easeInOut(200.ms));

  TextStyler get _label =>
      TextStyler().color($fg()).fontSize(16).fontWeight(.w600);

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: _isDark ? _darkColors : _lightColors,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Box(
            style: _box,
            child: StyledText(
              _isDark ? 'Dark Theme' : 'Light Theme',
              style: _label,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isDark = !_isDark),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Toggle Theme',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
