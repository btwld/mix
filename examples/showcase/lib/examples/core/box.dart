import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _blue = Color(0xFF3B6EF5);
const _ink = Color(0xFF0C1733);

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: BoxExample())),
  ),
);

/// A standalone Mix Box example, reused by the catalog and its live preview.
class BoxExample extends StatelessWidget {
  const BoxExample({super.key});

  @override
  Widget build(BuildContext context) {
    final panel = BoxStyler()
        .color(Colors.white)
        .padding(.all(28))
        .borderRadius(.circular(16))
        .border(.color(const Color(0xFFD9E1EF)).width(1));

    return panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Box(
            style: BoxStyler()
                .size(68, 68)
                .color(_blue)
                .borderRadius(.circular(14))
                .alignment(.center),
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Style with Mix',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A flexible container for layout and styling.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF61708E)),
          ),
        ],
      ),
    );
  }
}
