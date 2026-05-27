import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/directive.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Token References', () {
    setUp(() {
      // Clear registry before each test to ensure clean state
      clearTokenRegistry();
    });

    group('TokenRef Base Class', () {
      test('creates with token', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        expect(ref, PropMatcher.isToken(token));
      });

      test('equality based on token', () {
        final token1 = TestToken<Color>('test-color');
        final token2 = TestToken<Color>(
          'test-color',
        ); // Same name, different instance
        final token3 = TestToken<Color>('different-color');

        final ref1 = ColorRef(Prop.token(token1));
        final ref2 = ColorRef(Prop.token(token1)); // Same token instance
        final ref3 = ColorRef(
          Prop.token(token2),
        ); // Different token instance, same name
        final ref4 = ColorRef(Prop.token(token3)); // Different token

        expect(ref1, equals(ref2));
        expect(
          ref1,
          equals(ref3),
        ); // TestToken equality is based on name, so these are equal
        expect(ref1, isNot(equals(ref4)));
      });

      test('hashCode based on token', () {
        final token = TestToken<Color>('test-color');
        final ref1 = ColorRef(Prop.token(token));
        final ref2 = ColorRef(Prop.token(token));

        expect(ref1.hashCode, equals(ref2.hashCode));
      });

      test('noSuchMethod provides helpful error', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        expect(
          () => (ref as dynamic).alpha,
          throwsA(
            isA<UnsupportedError>().having(
              (e) => e.message,
              'message',
              contains('Cannot access'),
            ),
          ),
        );
      });

      test('toString returns proper representation', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        final result = ref.toString();
        expect(result, contains('ColorRef'));
        expect(result, contains('sources'));
      });

      test('implements Color interface correctly', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        // Should be compatible with Color interface
        expect(ref, isA<Color>());
      });

      test('maintains all token information', () {
        final token = TestToken<Color>('detailed-token');
        final ref = ColorRef(Prop.token(token));

        expect(ref, PropMatcher.isToken(token));
        expect(ref, PropMatcher.hasTokens);
        expect(ref, isNot(PropMatcher.hasValues));
      });
    });

    group('ColorRef Color method overrides', () {
      final baseToken = TestToken<Color>('base-color');

      test('withAlpha returns ColorRef with AlphaColorDirective', () {
        final ref = ColorRef(Prop.token(baseToken));

        final result = ref.withAlpha(128);

        expect(result, isA<ColorRef>());
        expect((result as ColorRef).$directives, [
          const AlphaColorDirective(128),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test('withRed returns ColorRef with WithRedColorDirective', () {
        final ref = ColorRef(Prop.token(baseToken));

        final result = ref.withRed(200);

        expect(result, isA<ColorRef>());
        expect((result as ColorRef).$directives, [
          const WithRedColorDirective(200),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test('withGreen returns ColorRef with WithGreenColorDirective', () {
        final ref = ColorRef(Prop.token(baseToken));

        final result = ref.withGreen(150);

        expect(result, isA<ColorRef>());
        expect((result as ColorRef).$directives, [
          const WithGreenColorDirective(150),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test('withBlue returns ColorRef with WithBlueColorDirective', () {
        final ref = ColorRef(Prop.token(baseToken));

        final result = ref.withBlue(75);

        expect(result, isA<ColorRef>());
        expect((result as ColorRef).$directives, [
          const WithBlueColorDirective(75),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test('withOpacity returns ColorRef with OpacityColorDirective', () {
        final ref = ColorRef(Prop.token(baseToken));

        // ignore: deprecated_member_use
        final result = ref.withOpacity(0.5);

        expect(result, isA<ColorRef>());
        expect((result as ColorRef).$directives, [
          const OpacityColorDirective(0.5),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test(
        'withValues returns ColorRef with WithValuesColorDirective carrying all args',
        () {
          final ref = ColorRef(Prop.token(baseToken));

          final result = ref.withValues(
            alpha: 0.5,
            red: 0.1,
            green: 0.2,
            blue: 0.3,
            colorSpace: ColorSpace.sRGB,
          );

          expect(result, isA<ColorRef>());
          expect((result as ColorRef).$directives, [
            const WithValuesColorDirective(
              alpha: 0.5,
              red: 0.1,
              green: 0.2,
              blue: 0.3,
              colorSpace: ColorSpace.sRGB,
            ),
          ]);
          expect(result, PropMatcher.isToken(baseToken));
        },
      );

      test('chained calls accumulate directives in call order', () {
        final ref = ColorRef(Prop.token(baseToken));

        final result = ref.withAlpha(10).withRed(20).withBlue(30) as ColorRef;

        expect(result.$directives, [
          const AlphaColorDirective(10),
          const WithRedColorDirective(20),
          const WithBlueColorDirective(30),
        ]);
        expect(result, PropMatcher.isToken(baseToken));
      });

      test('resolution applies directives after the token resolves', () {
        final ref = ColorRef(Prop.token(baseToken));
        const baseColor = Color(0xFF808080);
        final context = MockBuildContext(tokens: {baseToken: baseColor});

        final chained = ref.withAlpha(64).withRed(10) as ColorRef;

        final resolved = chained.resolveProp(context);
        final expected = const WithRedColorDirective(
          10,
        ).apply(const AlphaColorDirective(64).apply(baseColor));

        expect(resolved, equals(expected));
      });

      test('accessors still throw via noSuchMethod (regression guard)', () {
        final ref = ColorRef(Prop.token(baseToken));

        expect(
          () => (ref as dynamic).alpha,
          throwsA(isA<UnsupportedError>()),
        );
        expect(() => (ref as dynamic).red, throwsA(isA<UnsupportedError>()));
        expect(
          () => (ref as dynamic).opacity,
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => (ref as dynamic).value,
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Extension Type Token References', () {
      group('DoubleRef', () {
        test('creates from token using hybrid hashing', () {
          final token = TestToken<double>('test-double');
          final ref = DoubleRef.token(token);

          expect(ref, isA<double>());
          expect(getTokenFromValue<double>(ref), equals(token));
          // Value is based on token's hash code
        });

        test('can be used as double', () {
          final token = TestToken<double>('test-double');
          final ref = DoubleRef.token(token);

          // Test arithmetic operations work correctly
          final originalValue = ref as double;
          expect(ref + 1.0, equals(originalValue + 1.0));
          expect(ref - 1.0, equals(originalValue - 1.0));
          expect(ref * 2.0, equals(originalValue * 2.0));
          expect(ref / 2.0, equals(originalValue / 2.0));
        });

        test('deterministic value for same token', () {
          final token = TestToken<double>('consistent-double');
          final ref1 = DoubleRef.token(token);
          final ref2 = DoubleRef.token(token);

          expect(ref1, equals(ref2));
          expect(
            getTokenFromValue<double>(ref1),
            equals(getTokenFromValue<double>(ref2)),
          );
        });

        test('different values for different tokens', () {
          final token1 = TestToken<double>('double-1');
          final token2 = TestToken<double>('double-2');
          final ref1 = DoubleRef.token(token1);
          final ref2 = DoubleRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(
            getTokenFromValue<double>(ref1),
            isNot(equals(getTokenFromValue<double>(ref2))),
          );
        });

        test('registry lookup works correctly', () {
          final token = TestToken<double>('registry-test');
          final ref = DoubleRef.token(token);

          expect(getTokenFromValue<double>(ref), equals(token));
          expect(getTokenFromValue<double>(ref)?.name, equals('registry-test'));
        });

        test('throws when token not found in registry', () {
          // Create a DoubleRef manually without registering it
          final manualRef = DoubleRef(42.0);

          expect(getTokenFromValue<double>(manualRef), isNull);
        });
      });
    });

    group('isAnyTokenRef detection', () {
      test('detects ColorRef as token reference', () {
        final colorToken = TestToken<Color>('color-test');
        final colorRef = ColorRef(Prop.token(colorToken));

        expect(isAnyTokenRef(colorRef), isTrue);
      });

      test('detects DoubleRef as token reference', () {
        final token1 = TestToken<double>('test1');
        final ref1 = DoubleRef.token(token1);

        expect(isAnyTokenRef(ref1), isTrue);
      });

      test('correctly handles mixed types in collections', () {
        final colorToken = TestToken<Color>('color');
        final doubleToken = TestToken<double>('double');
        final colorRef = ColorRef(Prop.token(colorToken));
        final doubleRef = DoubleRef.token(doubleToken);

        final mixedList = <Object>[
          'regular string',
          42,
          doubleRef, // DoubleRef
          colorRef, // ColorRef
          Colors.red,
        ];

        expect(isAnyTokenRef(mixedList[0]), isFalse); // String
        expect(isAnyTokenRef(mixedList[1]), isFalse); // int
        expect(isAnyTokenRef(mixedList[2]), isTrue); // DoubleRef
        expect(isAnyTokenRef(mixedList[3]), isTrue); // ColorRef
        expect(isAnyTokenRef(mixedList[4]), isFalse); // Color
      });

      test('does not detect non-token refs', () {
        final nonTokenValues = [
          42.0,
          'hello',
          Colors.red,
          const EdgeInsets.all(8),
          null,
        ];

        for (final value in nonTokenValues) {
          if (value != null) {
            expect(isAnyTokenRef(value), isFalse);
          }
        }
      });

      test('does not detect manually created refs', () {
        // Create refs manually without using .token() method
        final manualDoubleRef = DoubleRef(42.0);

        expect(isAnyTokenRef(manualDoubleRef), isFalse);
      });

      test('detects any Prop carrying a TokenSource', () {
        final token = TestToken<int>('plain-prop-token');

        expect(isAnyTokenRef(Prop.token(token)), isTrue);
      });

      test('does not detect a plain Prop.value', () {
        expect(isAnyTokenRef(Prop.value(42)), isFalse);
      });
    });

    group('getTokenFromValue function', () {
      test('retrieves tokens from registered refs', () {
        final doubleToken = TestToken<double>('double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(getTokenFromValue(doubleRef), equals(doubleToken));
      });

      test('handles mixed registered and unregistered refs', () {
        final doubleToken = TestToken<double>('double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(getTokenFromValue(doubleRef), equals(doubleToken));
      });

      test('returns null for manually created refs', () {
        // Create refs manually without using .token() method
        final manualDoubleRef = DoubleRef(42.0);

        expect(getTokenFromValue(manualDoubleRef), isNull);
      });

      test('handles edge cases', () {
        expect(getTokenFromValue(42), isNull);
        expect(getTokenFromValue('string'), isNull);
        // Note: getTokenFromValue doesn't accept null, so we skip that test
      });
    });

    group('clearTokenRegistry', () {
      test('clears all registered tokens', () {
        final tokens = List.generate(10, (i) => TestToken<double>('token-$i'));
        final refs = tokens.map((token) => DoubleRef.token(token)).toList();

        // Verify all tokens are registered
        for (int i = 0; i < refs.length; i++) {
          expect(getTokenFromValue(refs[i]), equals(tokens[i]));
        }

        // Clear registry
        clearTokenRegistry();

        // Verify all tokens are cleared
        for (final ref in refs) {
          expect(getTokenFromValue(ref), isNull);
        }
      });
    });

    group('Token reference edge cases', () {
      test('handles empty string token names', () {
        final emptyNameToken = TestToken<double>('');
        final ref = DoubleRef.token(emptyNameToken);

        expect(getTokenFromValue(ref), equals(emptyNameToken));
      });

      test('handles complex token names', () {
        final longNameToken = TestToken<double>(
          'very.long.token.name.with.dots',
        );
        final specialCharsToken = TestToken<double>(
          'token-with_special/chars@123',
        );

        final longRef = DoubleRef.token(longNameToken);
        final specialRef = DoubleRef.token(specialCharsToken);

        expect(getTokenFromValue(longRef), equals(longNameToken));
        expect(getTokenFromValue(specialRef), equals(specialCharsToken));
      });
    });
  });
}
