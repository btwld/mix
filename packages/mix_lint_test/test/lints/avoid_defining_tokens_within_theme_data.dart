// import 'package:flutter/material.dart';
// import 'package:mix/mix.dart';

// // Wrong case
// final wrongTheme = MixScopeData.static(
//   tokens: {
//     // expect_lint: mix_avoid_defining_tokens_within_theme_data
//     MixToken<Color>('a'): Colors.black,
//     // expect_lint: mix_avoid_defining_tokens_within_theme_data
//     MixToken<Breakpoint>('a'): Breakpoint(),
//     // expect_lint: mix_avoid_defining_tokens_within_theme_data
//     MixToken<Radius>('a'): Radius.circular(10),
//     // expect_lint: mix_avoid_defining_tokens_within_theme_data
//     MixToken<double>('a'): 10,
//     // expect_lint: mix_avoid_defining_tokens_within_theme_data
//     MixToken<TextStyle>('a'): TextStyle(color: Colors.black),
//   },
// );

// // Correct case
// final colorToken = MixToken<Color>('a');
// final breakpointToken = MixToken<Breakpoint>('b');
// final radiusToken = MixToken<Radius>('c');
// final spaceToken = MixToken<double>('d');
// final textStyleToken = MixToken<TextStyle>('e');

// final correctTheme = MixScopeData.static(
//   tokens: {
//     colorToken: Colors.black,
//     breakpointToken: Breakpoint(),
//     radiusToken: Radius.circular(10),
//     spaceToken: 10,
//     textStyleToken: TextStyle(color: Colors.black),
//   },
// );
