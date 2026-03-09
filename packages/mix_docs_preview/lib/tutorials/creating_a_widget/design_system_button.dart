/// Design system button gallery
///
/// Simplified button variants: Filled, Outlined, Elevated, Link, and Disabled.
/// Matches the creating-a-widget tutorial style.
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  Widget _buildButton(String label, BoxStyler boxStyle, TextStyler textStyle) {
    return Pressable(
      onPress: () {},
      child: Box(
        style: boxStyle.onPressed(.scale(0.96)),
        child: StyledText(label, style: textStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        _buildButton(
          'Filled',
          BoxStyler()
              .color(Colors.blueAccent)
              .paddingX(24)
              .paddingY(12)
              .borderRounded(8),
          TextStyler().color(Colors.white).fontSize(16).fontWeight(.w500),
        ),
        const SizedBox(height: 12),
        _buildButton(
          'Outlined',
          BoxStyler()
              .color(Colors.transparent)
              .borderAll(color: Colors.blueAccent, width: 1.5)
              .paddingX(24)
              .paddingY(12)
              .borderRounded(8),
          TextStyler().color(Colors.blueAccent).fontSize(16).fontWeight(.w500),
        ),
        const SizedBox(height: 12),
        _buildButton(
          'Elevated',
          BoxStyler()
              .color(Colors.blueAccent)
              .paddingX(24)
              .paddingY(12)
              .borderRounded(8)
              .shadow(
                BoxShadowMix()
                    .color(Colors.blueAccent.shade700.withValues(alpha: 0.5))
                    .offset(x: 0, y: 4)
                    .blurRadius(8),
              ),
          TextStyler().color(Colors.white).fontSize(16).fontWeight(.w500),
        ),
        const SizedBox(height: 12),
        _buildButton(
          'Link',
          BoxStyler()
              .color(Colors.transparent)
              .paddingX(24)
              .paddingY(12)
              .borderRounded(8),
          TextStyler()
              .color(Colors.blueAccent)
              .fontSize(16)
              .fontWeight(.w500)
              .decoration(.underline),
        ),
        const SizedBox(height: 12),
        Pressable(
          enabled: false,
          child: Box(
            style: BoxStyler()
                .color(Colors.blueGrey.shade100)
                .paddingX(24)
                .paddingY(12)
                .borderRounded(8),
            child: StyledText(
              'Disabled',
              style: TextStyler()
                  .color(Colors.blueGrey.shade700)
                  .fontSize(16)
                  .fontWeight(.w500),
            ),
          ),
        ),
      ],
    );
  }
}
