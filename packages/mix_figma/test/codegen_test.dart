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

  test('rejects token names that normalize to one Dart identifier', () {
    expect(
      () => generateTokensSource({
        'light': {
          'v': 1,
          'type': 'theme',
          'colors': {'color.a-b': '#336699', 'color.a_b': '#8DA4EF'},
        },
      }),
      throwsA(
        isA<FormatException>()
            .having((error) => error.message, 'message', contains('color.a-b'))
            .having((error) => error.message, 'message', contains('color.a_b')),
      ),
    );
  });

  test('rejects mode names that normalize to one Dart identifier', () {
    expect(
      () => generateTokensSource({
        'dark-mode': {'v': 1, 'type': 'theme'},
        'dark_mode': {'v': 1, 'type': 'theme'},
      }),
      throwsA(
        isA<FormatException>()
            .having((error) => error.message, 'message', contains('dark-mode'))
            .having((error) => error.message, 'message', contains('dark_mode')),
      ),
    );
  });
}
