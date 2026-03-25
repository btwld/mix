import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final hoverStyle = BoxStyler()
        .onDark(.color(Colors.blue))
        .onLight(.color(Colors.green));

    final style = BoxStyler()
        .color(Colors.red)
        .height(100)
        .width(100)
        .borderRounded(10)
        .onHovered(hoverStyle);

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(platformBrightness: isDark ? .dark : .light),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Box(style: style),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => isDark = !isDark),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isDark ? 'Dark mode' : 'Light mode',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
