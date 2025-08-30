import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

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
        .borderRadius(.circular(10))
        .onFocused(BoxStyler()
            .color(Colors.blue)
            .border(
              BorderMix.all(
                BorderSideMix(
                  color: Colors.blue.shade700,
                  width: 3,
                ),
              ),
            )
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Pressable(
              focusNode: focusNode1,
              onPress: () {
                // Request focus when pressed
                focusNode1.requestFocus();
              },
              child: Box(style: style),
            ),
            Pressable(
              focusNode: focusNode2,
              onPress: () {
                // Request focus when pressed
                focusNode2.requestFocus();
              },
              child: Box(style: style),
            ),
          ],
        ),
        Text(
          'Click a box to focus it, or use Tab key to navigate',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}