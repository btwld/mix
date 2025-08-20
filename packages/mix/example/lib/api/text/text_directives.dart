import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Style.text(
        .fontSize(18)
        .fontWeight(.w600)
        .color(Colors.blue.shade700)
    );

    return VBox(
      style: Style.flexbox(
        .spacing(16)
        .mainAxisSize(.min)
      ),
      children: [
        StyledText('hello world', style: baseStyle.uppercase()),
        StyledText('HELLO WORLD', style: baseStyle.lowercase()),
        StyledText('hello world', style: baseStyle.capitalize()),
        StyledText('hello world from mix', style: baseStyle.titleCase()),
        StyledText('hello world. this is mix.', style: baseStyle.sentenceCase()),
      ],
    );
  }
}