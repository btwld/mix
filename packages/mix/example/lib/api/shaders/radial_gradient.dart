import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: LinearGradientIconExample())),
    );
  }
}

class LinearGradientIconExample extends StatelessWidget {
  const LinearGradientIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledText(
      'Hello',
      style: Style.text()
          .fontSize(100)
          .color(Colors.white)
          .fontWeight(FontWeight.bold)
          .wrap(
            WidgetModifierConfig.shaderMask(
              shaderCallback: ShaderCallbackBuilder.radialGradient(
                center: Alignment.centerLeft,
                radius: 0.7,
                colors: [
                  Colors.blueAccent.shade100,
                  Colors.blueAccent.shade700,
                ],
              ),
            ),
          ),
    );
  }
}
