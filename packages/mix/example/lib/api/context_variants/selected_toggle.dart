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
  final controller = WidgetStatesController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(60)
        .width(120)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .borderAll(color: Colors.grey.shade300, width: 2)
        .animate(.spring(300.ms))
        .onSelected(BoxStyler()
          .color(Colors.blue.shade500)
          .borderAll(color: Colors.blue.shade600, width: 2)
          .shadowColor(Colors.blue.shade200)
          .shadowBlurRadius(10)
          .shadowSpreadRadius(2)
        );

    final textStyle = TextStyler()
        .fontSize(16)
        .fontWeight(.w600)
        .color(Colors.grey.shade700)
        .onSelected(TextStyler().color(Colors.white));

    return Pressable(
      controller: controller,
      onPress: () {
        final isSelected = controller.has(WidgetState.selected);
        controller.update(WidgetState.selected, !isSelected);
      },
      child: Box(
        style: style,
        child: Center(
          child: StyledText(
            controller.has(WidgetState.selected) ? 'Selected' : 'Select Me',
            style: textStyle,
          ),
        ),
      ),
    );
  }
}