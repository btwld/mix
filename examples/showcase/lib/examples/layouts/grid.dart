import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: GridExample())),
  ),
);

/// GridBox uses columns and gaps as a single style, including local breakpoints.
class GridExample extends StatelessWidget {
  const GridExample({super.key});

  @override
  Widget build(BuildContext context) {
    final GridBoxStyler layout = .equalColumns(
      3,
    ).gap(8).onConstraints(.maxWidth(220), .equalColumns(2));

    return SizedBox(
      width: 260,
      child: GridBox(
        style: layout,
        children: [
          for (var index = 0; index < 6; index++)
            Box(
              style: BoxStyler()
                  .height(40)
                  .color(const Color(0xFFBDD1F6))
                  .borderRadius(.circular(6)),
            ),
        ],
      ),
    );
  }
}
