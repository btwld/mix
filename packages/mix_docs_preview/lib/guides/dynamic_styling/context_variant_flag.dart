/// Context variant with a custom InheritedWidget flag.
///
/// Box is red when flag is false, blue when true.
/// Tapping toggles the flag.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class CustomInheritedWidget extends InheritedWidget {
  final bool flag;

  const CustomInheritedWidget({
    super.key,
    required this.flag,
    required super.child,
  });

  static CustomInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant CustomInheritedWidget oldWidget) {
    return flag != oldWidget.flag;
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return CustomInheritedWidget(
      flag: _flag,
      child: Pressable(
        onPress: () => setState(() => _flag = !_flag),
        child: Box(
          style: BoxStyler()
              .color(Colors.red)
              .size(100, 100)
              .borderRounded(10)
              .variant(
                ContextVariant('custom_flag', (context) {
                  return CustomInheritedWidget.of(context)?.flag ?? false;
                }),
                BoxStyler().color(Colors.blue),
              ),
        ),
      ),
    );
  }
}
