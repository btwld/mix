/// Typewriter Animation Directive Example
///
/// This example demonstrates how SpecDirective automatically animates
/// between different progress values when used with Mix's animation system.
///
/// Key concepts:
/// - SpecDirectives are **automatically animated** by the Mix framework
/// - Simply switch between styles with different progress values
/// - The framework handles lerping by calling the directive's lerp() method
/// - No manual progress tracking or animation controllers needed
/// - Add `.animate()` to configure duration and curve
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

    // Start with directive at progress 0.0 (hidden state)
    final typewriterHiddenStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const TypewriterDirective(progress: 0.0)],
      ),
    );

    // Animate to progress 1.0 (fully visible)
    final typewriterVisibleStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const TypewriterDirective(progress: 1.0)],
      ),
    );

    // Reverse typewriter: start fully visible
    final reverseVisibleStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const ReverseTypewriterDirective(progress: 0.0)],
      ),
    );

    // Reverse typewriter: animate to hidden
    final reverseHiddenStyle = baseStyle.merge(
      TextStyler(
        textDirectives: [const ReverseTypewriterDirective(progress: 1.0)],
      ),
    );

    return ColumnBox(
      style: FlexBoxStyler().spacing(24).mainAxisSize(MainAxisSize.min),
      children: [
        // Typewriter effect - animates from progress 0.0 to 1.0
        ColumnBox(
          style: FlexBoxStyler().spacing(8).mainAxisSize(MainAxisSize.min),
          children: [
            StyledText(
              'Hello from Mix framework!',
              style: _showTypewriter
                  ? typewriterVisibleStyle
                  : typewriterHiddenStyle,
            ),
            Text(
              'Typewriter: ${_showTypewriter ? "Active" : "Inactive"}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),

        // Reverse typewriter effect - animates from progress 0.0 to 1.0
        ColumnBox(
          style: FlexBoxStyler().spacing(8).mainAxisSize(MainAxisSize.min),
          children: [
            StyledText(
              'Goodbye from Mix framework!',
              style: _showReverse ? reverseHiddenStyle : reverseVisibleStyle,
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
