import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late FocusNode focusNode1;
  late FocusNode focusNode2;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRounded(10)
        .wrap(.new().opacity(0.4))
        .onFocused(
          BoxStyler()
              .color(Colors.blue)
              .borderAll(color: Colors.blue.shade700, width: 3),
        );

    return Column(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            Pressable(
              onPress: () {
                // Request focus when pressed
                focusNode1.requestFocus();
              },
              focusNode: focusNode1,
              child: Box(style: style),
            ),
            Pressable(
              onPress: () {
                // Request focus when pressed
                focusNode2.requestFocus();
              },
              focusNode: focusNode2,
              child: Box(style: style),
            ),
          ],
        ),
        Text(
          'Click a box to focus it, or use Tab key to navigate',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
