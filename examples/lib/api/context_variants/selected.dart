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
        .borderRounded(10)
        .variant(
          ContextVariant.widgetState(.selected),
          BoxStyler().color(Colors.blue),
        );

    return Pressable(
      onPress: () {
        final isSelected = controller.has(.selected);
        controller.update(.selected, !isSelected);
      },
      controller: controller,
      child: Box(style: style),
    );
  }
}
