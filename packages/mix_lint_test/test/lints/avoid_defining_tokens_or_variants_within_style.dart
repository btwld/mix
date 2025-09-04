// // ignore_for_file: mix_avoid_empty_variants
// import 'package:flutter/material.dart';
// import 'package:mix/mix.dart';

// // Wrong case
// final wrong_case_variant = CompoundStyle(
//   // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//   Variant('a')(
//     // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//     Variant('b')(),
//   ),
// );

// final wrong_case_token = CompoundStyle(
//   // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//   $box.color.token(MixToken<Color>('test')),
//   // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//   $box.padding.all.token(MixToken<double>('test')),
//   // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//   $text.style.token(MixToken<TextStyle>('test')),
//   // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//   $on.breakpoint(Breakpoint())(
//     // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//     $box.color.token(MixToken<Color>('test')),
//     // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//     $box.padding.all.token(MixToken<double>('test')),
//     // expect_lint: mix_avoid_defining_tokens_or_variants_within_style
//     $text.style.token(MixToken<TextStyle>('test')),
//   ),
// );

// // Correct case
// final a = NamedVariant('a');
// final b = NamedVariant('b');

// final correct_case_variant = CompoundStyle(a(b()));

// final colorToken = MixToken<Color>('test');
// final spaceToken = MixToken<double>('test');
// final textStyleToken = MixToken<TextStyle>('test');
// final breakpoint = Breakpoint();

// final correct_case_token = CompoundStyle(
//   $box.color.token(colorToken),
//   $box.padding.all.token(spaceToken),
//   $text.style.token(textStyleToken),
//   $on.breakpoint(breakpoint)(
//     $box.color.token(colorToken),
//     $box.padding.all.token(spaceToken),
//     $text.style.token(textStyleToken),
//   ),
// );
