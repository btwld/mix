/// State-triggered implicit animation example.
///
/// A square grows each time you tap it. The size is driven by a counter;
/// when the counter changes, the style animates to the new size using a
/// spring animation.
///
/// Key concepts:
/// - Implicit animation with .animate(.spring(...))
/// - State drives the style (counter * 10 for size)
/// - Pressable triggers setState to increment counter
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
  int _counter = 2;

  @override
  Widget build(BuildContext context) {
    final box = BoxStyler()
        .color(Colors.deepPurple)
        .size(_counter * 10, _counter * 10)
        .animate(.spring(1.s, bounce: 0.6));

    return Pressable(
      onPress: () => setState(() => _counter += 3),
      child: box(),
    );
  }
}
