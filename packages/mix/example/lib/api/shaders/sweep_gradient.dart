import 'package:flutter/cupertino.dart';
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
      home: Scaffold(body: Center(child: SweepGradientIconExample())),
    );
  }
}

class SweepGradientIconExample extends StatelessWidget {
  const SweepGradientIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledIcon(
      icon: CupertinoIcons.clock_solid,
      style: Style.icon()
          .size(100)
          .color(Colors.white)
          .wrapShaderMask(
            shaderCallback: ShaderCallbackBuilder.sweepGradient(
              colors: [
                Colors.redAccent.shade100,
                Colors.redAccent.shade400,
                Colors.redAccent.shade200,
              ],
              center: Alignment.topCenter,
            ),
          ),
    );
  }
}
