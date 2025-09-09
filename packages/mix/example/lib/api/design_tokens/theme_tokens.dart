/// Theme Tokens Example
/// 
/// Shows how to use design tokens for consistent theming across your app.
/// Design tokens allow you to define reusable values that can be referenced
/// throughout your styles and updated in one place.
/// 
/// Key concepts:
/// - Creating individual token types (ColorToken, RadiusToken) for type safety
/// - Using tokens in styles with token() method  
/// - Providing token values through MixScope with typed collections
/// - Building a design system with consistent values
library;

import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

// Using the new individual token types
final $primaryColor = ColorToken('primary');
final $pill = RadiusToken('pill');

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: {
        $primaryColor: Colors.blue,
      },
      radii: {
        $pill: Radius.circular(20),
      },
      child: _Example(),
    );
  }
}

class _Example extends StatelessWidget {
  const _Example();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .borderRadius(.topLeft($pill()))
        .color($primaryColor())
        .height(100)
        .width(100);

    return Box(style: style);
  }
}
