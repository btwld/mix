/// Animations guide — Case 2: Variant-triggered implicit animation.
///
/// When the widget enters a variant (e.g. hovered), the style animates toward
/// the variant's target; .animate(...) controls how that transition runs.
///
/// Preview: anim-hover-scale
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(const ImplicitVariantHoverExample());
}

class ImplicitVariantHoverExample extends StatelessWidget {
  const ImplicitVariantHoverExample({super.key});

  @override
  Widget build(BuildContext context) {
    final box = BoxStyler()
        .color(Colors.black)
        .size(100, 100)
        .borderRounded(10)
        .scale(1)
        .onHovered(.color(Colors.blue).scale(1.5))
        .animate(.spring(800.ms));

    return box();
  }
}
