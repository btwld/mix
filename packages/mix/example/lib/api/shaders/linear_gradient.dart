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
      home: Scaffold(body: Center(child: LinearGradientIconExample())),
    );
  }
}

class LinearGradientIconExample extends StatelessWidget {
  const LinearGradientIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledIcon(
      icon: CupertinoIcons.heart_fill,
      style: Style.icon()
          .size(100)
          .color(Colors.white)
          .wrapShaderMask(
            shaderCallback: ShaderCallbackBuilder.linearGradient(
              colors: [
                Colors.redAccent.shade100,
                Colors.redAccent.shade200,
                Colors.redAccent.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
    );
  }
}
