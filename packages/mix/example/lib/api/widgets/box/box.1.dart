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
    final style = Style.box()
        .gradient(
          GradientMix.linear(
            LinearGradientMix(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        )
        .shadow(BoxShadowMix(color: Colors.deepPurple.shade700, blurRadius: 10))
        .height(50)
        .width(100)
        .borderRadius(BorderRadiusMix.all(Radius.circular(10)));

    return Box(style: style);
  }
}
