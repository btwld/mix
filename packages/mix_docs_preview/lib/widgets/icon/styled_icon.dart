import 'package:mix_docs_preview/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = IconStyler().size(32).color(Colors.blue);

    return StyledIcon(icon: Icons.favorite, style: style);
  }
}
