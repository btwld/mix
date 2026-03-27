library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final Box = BoxStyler()
        .width(120)
        .height(120)
        .borderRounded(16)
        .color(Colors.deepPurple);

    return Box();
  }
}
