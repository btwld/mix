/// Typewriter Animation Directive Example
///
/// This example demonstrates the clean API of progress-aware SpecDirectives where
/// Mix automatically manages the animation progress.
///
/// Key concepts:
/// - **No manual progress values needed** - just declare the directive once!
/// - SpecDirectives automatically animate when added/removed from styles
/// - Toggle between styles with/without the directive to trigger animation
/// - Framework handles all progress interpolation internally
/// - Use `.animate()` to configure duration and curve
/// - Use `reverse: true` parameter for reverse animations (consolidated API)
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool _showTypewriter = false;
  bool _showReverse = false;

  void _animateTypewriter() {
    setState(() {
      _showTypewriter = true;
      _showReverse = false;
    });
  }

  void _animateReverseTypewriter() {
    setState(() {
      _showTypewriter = false;
      _showReverse = true;
    });
  }

  void _reset() {
    setState(() {
      _showTypewriter = false;
      _showReverse = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Base style with animation configuration
    final baseStyle = TextStyler()
        .fontSize(24)
        .fontWeight(FontWeight.w600)
        .color(Colors.blue.shade700)
        .animate(
          AnimationConfig.curve(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
          ),
        );

    // Clean API - just declare the directive, no progress values needed!
    // Framework automatically animates between presence/absence
    final typewriterStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const TypewriterDirective()],
      ),
    );

    // Reverse typewriter - use reverse parameter
    final reverseTypewriterStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const TypewriterDirective(reverse: true)],
      ),
    );

    return ColumnBox(
      style: FlexBoxStyler().spacing(24).mainAxisSize(MainAxisSize.min),
      children: [
        // Typewriter effect - automatically animates when toggled!
        ColumnBox(
          style: FlexBoxStyler().spacing(8).mainAxisSize(MainAxisSize.min),
          children: [
            StyledText(
              'Hello from Mix framework!',
              style: _showTypewriter ? typewriterStyle : baseStyle,
            ),
            Text(
              'Typewriter: ${_showTypewriter ? "Active" : "Inactive"}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),

        // Reverse typewriter effect - automatically animates when toggled!
        ColumnBox(
          style: FlexBoxStyler().spacing(8).mainAxisSize(MainAxisSize.min),
          children: [
            StyledText(
              'Goodbye from Mix framework!',
              style: _showReverse ? reverseTypewriterStyle : baseStyle,
            ),
            Text(
              'Reverse Typewriter: ${_showReverse ? "Active" : "Inactive"}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),

        // Control buttons
        RowBox(
          style: FlexBoxStyler().spacing(12).mainAxisSize(MainAxisSize.min),
          children: [
            ElevatedButton(
              onPressed: _animateTypewriter,
              child: const Text('Typewriter'),
            ),
            ElevatedButton(
              onPressed: _animateReverseTypewriter,
              child: const Text('Reverse'),
            ),
            ElevatedButton(onPressed: _reset, child: const Text('Reset')),
          ],
        ),
      ],
    );
  }
}
