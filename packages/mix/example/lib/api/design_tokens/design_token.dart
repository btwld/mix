import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

final $primaryColor = MixToken<Color>('primary');
final $pill = MixToken<Radius>('pill');

final tokenDefinitions = {
  $primaryColor.defineValue(Colors.blue),
  $pill.defineValue(Radius.circular(20)),
};

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MixScope(
      tokens: tokenDefinitions,
      child: _Example(),
    );
  }
}

class _Example extends StatelessWidget {
  const _Example();

  @override
  Widget build(BuildContext context) {
    final style = Style.box(
        .borderRadius(.topLeft($pill()))
        .color($primaryColor())
        .height(100)
        .width(100)
    );

    return Box(style: style);
  }
}
