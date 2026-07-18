import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/src/core/codegen/token_source_generator.dart';

void main() {
  test('generates deterministic declarations and per-mode scope maps', () {
    final source = generateTokensSource({
      'light': {
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.brand': '#336699',
          'color.accent': {r'$token': 'color.brand'},
        },
        'spaces': {'space.sm': 8},
        'durations': {'duration.fast': 120},
      },
      'dark': {
        'v': 1,
        'type': 'theme',
        'colors': {
          'color.brand': '#8DA4EF',
          'color.accent': {r'$token': 'color.brand'},
        },
        'spaces': {'space.sm': 8},
        'durations': {'duration.fast': 120},
      },
    });

    expect(source, File('test/fixtures/tokens.g.dart').readAsStringSync());
    expect(source, contains('const colorColorAccent'));
    expect(source, contains('final lightTokens'));
    expect(source, contains('final darkTokens'));
    expect(source, isNot(contains(r'$token')));
  });
}
