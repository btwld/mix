import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

final primaryColor = MixToken<Color>('primary');
final pill = MixToken<Radius>('pill');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MixScope(
        data: MixScopeData.static(
          tokens: {primaryColor: Colors.amber, pill: Radius.circular(999)},
        ),
        child: child!,
      ),
      home: Scaffold(body: Center(child: Example())),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Style.box()
        .borderRadius(BorderRadiusMix.raw(topLeft: Prop.token(pill)))
        .color(Colors.red)
        .height(100)
        .width(100);

    return Box(style: style);
  }
}
