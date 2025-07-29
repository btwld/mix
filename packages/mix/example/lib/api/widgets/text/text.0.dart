import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Example())),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Style.text()
        .fontSize(20)
        .fontWeight(FontWeight.w700)
        .directive(UppercaseStringDirective())
        .color(Colors.red);

    return StyledText('I love Mix', style: style);
  }
}
