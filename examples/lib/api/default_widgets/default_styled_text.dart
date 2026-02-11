import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyler()
        .fontSize(50)
        .fontWeight(.w600)
        .color(Colors.blue.shade700)
        .onHovered(TextStyler().color(Colors.red))
        .animate(.easeInOut(1.s));

    final iconStyle = IconStyler().size(20).color(Colors.blueAccent);

    return DefaultStyledIcon(
      style: iconStyle,
      child: DefaultStyledText(
        style: baseStyle,
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            StyledText('hello world'),
            StyledText(
              'Mix is awesome',
              style: TextStyler().onHovered(
                TextStyler().color(Colors.deepPurple),
              ),
            ),
            StyledIcon(icon: Icons.ac_unit),
          ],
        ),
      ),
    );
  }
}
