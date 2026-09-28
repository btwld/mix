import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: WrapExample())),
  ),
);

/// Resize the available width to see WrapBox move tiles into another run.
class WrapExample extends StatelessWidget {
  const WrapExample({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    child: WrapBox(
      style: WrapBoxStyler().spacing(8).runSpacing(8),
      children: [
        for (var index = 0; index < 6; index++)
          Box(
            style: BoxStyler()
                .size(index.isEven ? 74 : 66, 40)
                .color(
                  index == 0
                      ? const Color(0xFF5F8DF4)
                      : const Color(0xFFBDD1F6),
                )
                .borderRadius(.circular(6)),
          ),
      ],
    ),
  );
}
