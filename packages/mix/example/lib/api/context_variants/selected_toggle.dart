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
        .height(60)
        .width(120)
        .borderRounded(30)
        .color(Colors.grey.shade200)
        .borderAll(color: Colors.grey.shade300, width: 2)
        .animate(AnimationConfig.spring(300.ms))
        .variant(
          ContextVariant.widgetState(WidgetState.selected),
          BoxStyler()
              .color(Colors.blue.shade500)
              .borderAll(color: Colors.blue.shade600, width: 2)
              .shadowOnly(
                color: Colors.blue.shade200,
                blurRadius: 10,
                spreadRadius: 2,
              ),
        );

    final textStyle = TextStyler()
        .fontSize(16)
        .fontWeight(FontWeight.w600)
        .color(Colors.grey.shade700)
        .variant(
          ContextVariant.widgetState(WidgetState.selected),
          TextStyler().color(Colors.white),
        );

    return Pressable(
      onPress: () {
        final isSelected = controller.has(WidgetState.selected);
        controller.update(WidgetState.selected, !isSelected);
      },
      controller: controller,
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
