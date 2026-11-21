import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _ink = Color(0xFF0C1733);

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: TextExample())),
  ),
);

/// Fluent text styling with a clear visual hierarchy.
class TextExample extends StatelessWidget {
  const TextExample({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StyledText(
        'The quick brown fox',
        style: TextStyler().fontSize(26).fontWeight(.w700).color(_ink),
      ),
      const SizedBox(height: 8),
      StyledText(
        'Jumps over the lazy dog.',
        style: TextStyler().fontSize(17).color(const Color(0xFF6A7895)),
      ),
    ],
  );
}
