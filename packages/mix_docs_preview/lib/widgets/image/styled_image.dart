/// StyledImage example
///
/// Shows ImageStyler with dimensions, fit, and color blend.
/// Uses a placeholder when no asset is available.

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
    final style = ImageStyler()
        .width(160)
        .height(160)
        .fit(.cover)
        .color(Colors.blue.withValues(alpha: 0.3))
        .colorBlendMode(.overlay);

    return StyledImage(
      image: NetworkImage('https://picsum.photos/160'),
      style: style,
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Box(
          style: BoxStyler()
              .size(160, 160)
              .color(Colors.grey.shade200)
              .alignment(.center),
          child: StyledText(
            'Loading…',
            style: TextStyler.color(Colors.grey.shade600).fontSize(14),
          ),
        );
      },
      errorBuilder: (_, error, stackTrace) => Box(
        style: BoxStyler()
            .size(160, 160)
            .color(Colors.grey.shade300)
            .alignment(.center),
        child: StyledText(
          'Image unavailable',
          style: TextStyler.color(Colors.grey.shade600).fontSize(14),
        ),
      ),
    );
  }
}
