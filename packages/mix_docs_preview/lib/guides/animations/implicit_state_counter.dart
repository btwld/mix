/// Animations guide — Case 1: State-triggered implicit animation.
///
/// A square grows each time you tap it. The size is driven by a counter;
/// when the counter changes, the style animates to the new size using a
/// spring animation.
///
/// Preview: implicit-anim-counter
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const ImplicitStateCounterExample());
}

class ImplicitStateCounterExample extends StatefulWidget {
  const ImplicitStateCounterExample({super.key});

  @override
  State<ImplicitStateCounterExample> createState() =>
      _ImplicitStateCounterExampleState();
}

class _ImplicitStateCounterExampleState
    extends State<ImplicitStateCounterExample> {
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
