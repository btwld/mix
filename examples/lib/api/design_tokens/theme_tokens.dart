/// Theme Tokens Example
///
/// Shows how to use design tokens for consistent theming across your app.
/// Design tokens allow you to define reusable values that can be referenced
/// throughout your styles and updated in one place.
///
/// Key concepts:
/// - Creating individual token types (ColorToken, RadiusToken, etc.)
/// - Using tokens in styles with direct calls
/// - Providing token values through MixScope with typed parameters
/// - Building a design system with consistent values
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

// Create individual token instances using specific token types
final $primaryColor = ColorToken('primary');
final $pill = RadiusToken('pill');
final $spacing = SpaceToken('spacing.large');

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: {$primaryColor: Colors.blue},
      spaces: {$spacing: 16.0},
      radii: {$pill: Radius.circular(20)},
      child: _Example(),
    );
  }
}

class _Example extends StatelessWidget {
  const _Example();

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .borderRadiusTopLeft($pill())
        .color($primaryColor())
        .height(100)
        .width(100)
        .paddingAll(16.0);

    return Box(
      style: style,
      child: MixScope(
        colors: {$primaryColor: Colors.red},
        child: StyledText(
          'Hello, World!',
          style: TextStyler()
              .color($primaryColor())
              .wrap(.new().padding(.all($spacing()))),
        ),
      ),
    );
  }
}
