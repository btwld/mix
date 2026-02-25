import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(body: Center(child: Example1())),
    ),
  );
}

class Example1 extends StatelessWidget {
  const Example1({super.key});

  BoxStyler get style => .new()
      .color(Colors.red)
      .size(100, 100)
      .onHovered(BoxStyler().color(Colors.blue))
      .onPressed(BoxStyler().color(Colors.green))
      .onFocused(BoxStyler().color(Colors.yellow));

  @override
  Widget build(BuildContext context) {
    return style();
  }
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  final controller = WidgetStatesController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  BoxStyler get style => .new()
      .color(Colors.red)
      .size(100, 100)
      .onHovered(BoxStyler().color(Colors.blue))
      .onPressed(BoxStyler().color(Colors.green))
      .onFocused(BoxStyler().color(Colors.yellow));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => controller.pressed = true,
      onTapUp: (_) => controller.pressed = false,
      onTapCancel: () => controller.pressed = false,
      child: StyleBuilder(
        style: style,
        builder: (context, spec) {
          return Box(styleSpec: StyleSpec(spec: spec));
        },
        controller: controller,
      ),
    );
  }
}
