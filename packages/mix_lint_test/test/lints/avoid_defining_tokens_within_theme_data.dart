import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Wrong case
final wrongTheme = MixScopeData.static(
  tokens: {
    // expect_lint: mix_avoid_defining_tokens_within_theme_data
    MixableToken<Color>('a'): Colors.black,
    // expect_lint: mix_avoid_defining_tokens_within_theme_data
    MixableToken<Breakpoint>('a'): Breakpoint(),
    // expect_lint: mix_avoid_defining_tokens_within_theme_data
    MixableToken<Radius>('a'): Radius.circular(10),
    // expect_lint: mix_avoid_defining_tokens_within_theme_data
    MixableToken<double>('a'): 10,
    // expect_lint: mix_avoid_defining_tokens_within_theme_data
    MixableToken<TextStyle>('a'): TextStyle(color: Colors.black),
  },
);

// Correct case
final colorToken = MixableToken<Color>('a');
final breakpointToken = MixableToken<Breakpoint>('b');
final radiusToken = MixableToken<Radius>('c');
final spaceToken = MixableToken<double>('d');
final textStyleToken = MixableToken<TextStyle>('e');

final correctTheme = MixScopeData.static(
  tokens: {
    colorToken: Colors.black,
    breakpointToken: Breakpoint(),
    radiusToken: Radius.circular(10),
    spaceToken: 10,
    textStyleToken: TextStyle(color: Colors.black),
  },
);
