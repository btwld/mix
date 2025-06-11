import 'package:flutter/material.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const v = Variant('name');
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: PressableBox(
          onPress: () {
            print('pressed');
          },
          style: Style(
            BoxStyle()
                .color(Colors.red)
                .height(100)
                .padding(10)
                .onVariant(v, (style) {
                  return style
                      .color(Colors.green)
                      .padding(10)
                      .onVariant(v, (style) => style.height(200));
                })
                .onHover((style) => style.color(Colors.blue))
                .onPress((style) => style.color(Colors.yellow)),
          ).applyVariant(v),
          child: const Box(),
        ),
      ),
    );
  }
}
