import '../../helpers.dart';
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
  final controller = WidgetStatesController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRadius(.all(.circular(10)))
        .onSelected(BoxStyler().color(Colors.blue));

    return Pressable(
      controller: controller,
      onPress: () {
        final isSelected = controller.has(WidgetState.selected);
        controller.update(WidgetState.selected, !isSelected);
      },
      child: Box(style: style),
    );
  }
}
