import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: FlexExample())),
  ),
);

/// FlexBox composes horizontal children without scattering spacing widgets.
class FlexExample extends StatelessWidget {
  const FlexExample({super.key});

  @override
  Widget build(BuildContext context) => FlexBox(
    style: FlexBoxStyler()
        .direction(.horizontal)
        .spacing(10)
        .mainAxisSize(.min),
    children: [
      for (var index = 0; index < 3; index++)
        Box(
          style: BoxStyler()
              .size(index == 0 ? 110 : 64, 54)
              .color(
                index == 0 ? const Color(0xFF5F8DF4) : const Color(0xFFBDD1F6),
              )
              .borderRadius(.circular(6)),
        ),
    ],
  );
}
