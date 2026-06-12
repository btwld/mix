import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/directive.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/theme/tokens/mix_token.dart';
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

        expect(() => (ref as dynamic).alpha, throwsA(isA<UnsupportedError>()));
        expect(() => (ref as dynamic).red, throwsA(isA<UnsupportedError>()));
        expect(
          () => (ref as dynamic).opacity,
          throwsA(isA<UnsupportedError>()),
        );
        expect(() => (ref as dynamic).value, throwsA(isA<UnsupportedError>()));
      });
    });

    group('Extension Type Token References', () {
      group('DoubleRef', () {
        test('creates from token using monotonic sentinel registry', () {
          final token = TestToken<double>('test-double');
          final ref = DoubleRef.token(token);

          expect(ref, isA<double>());
          expect(getTokenFromValue<double>(ref), equals(token));
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

        test('returns null for an arbitrary double that is not a sentinel', () {
          // 42.0 was never returned by DoubleRef.token, so it must not be
          // mistakenly identified as a registered token sentinel.
          expect(getTokenFromValue<double>(42.0), isNull);
        });

        test('re-issues the same sentinel for the same token instance', () {
          final token = TestToken<double>('idempotent-token');

          final ref1 = DoubleRef.token(token);
          final ref2 = DoubleRef.token(token);

          expect(ref1, equals(ref2));
          expect(getTokenFromValue<double>(ref1), same(token));
          expect(getTokenFromValue<double>(ref2), same(token));
        });

        test('distinct tokens always receive distinct sentinels', () {
          final a = TestToken<double>('alloc-a');
          final b = TestToken<double>('alloc-b');

          final aRef = DoubleRef.token(a);
          final bRef = DoubleRef.token(b);

          expect(aRef, isNot(equals(bRef)));
          expect(getTokenFromValue<double>(aRef), same(a));
          expect(getTokenFromValue<double>(bRef), same(b));
        });

        test(
          'distinct tokens with colliding hashes receive distinct sentinels',
          () {
            final a = _HashCollidingDoubleToken('alloc-a');
            final b = _HashCollidingDoubleToken('alloc-b');

            expect(a, isNot(equals(b)));
            expect(a.hashCode, equals(b.hashCode));

            final aRef = DoubleRef.token(a);
            final bRef = DoubleRef.token(b);

            expect(aRef, isNot(equals(bRef)));
            expect(getTokenFromValue<double>(aRef), same(a));
            expect(getTokenFromValue<double>(bRef), same(b));
          },
        );
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

      test('does not detect arbitrary double values as token refs', () {
        // Any plain double that was never returned by DoubleRef.token must
        // not be misclassified as a token ref.
        expect(isAnyTokenRef(42.0), isFalse);
        expect(isAnyTokenRef(-0.0000001), isFalse);
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

      test('returns null for arbitrary values that are not sentinels', () {
        // Plain doubles, ints, strings — anything that wasn't issued by
        // DoubleRef.token must round-trip to null.
        expect(getTokenFromValue(42.0), isNull);
        expect(getTokenFromValue(42), isNull);
        expect(getTokenFromValue('string'), isNull);
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

    group('getReferenceValue unsupported types', () {
      test('throws UnsupportedError naming the token and type', () {
        const token = _UnsupportedToken('layout.edge-insets');

        expect(
          () => getReferenceValue(token),
          throwsA(
            isA<UnsupportedError>().having(
              (e) => e.message,
              'message',
              allOf(contains('EdgeInsets'), contains('layout.edge-insets')),
            ),
          ),
        );
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

/// Token type that intentionally targets a value type not covered by the
/// reference dispatch table in [getReferenceValue].
class _UnsupportedToken extends MixToken<EdgeInsets> {
  const _UnsupportedToken(super.name);
}

class _HashCollidingDoubleToken extends MixToken<double> {
  const _HashCollidingDoubleToken(super.name);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _HashCollidingDoubleToken && other.name == name;
  }

  @override
  int get hashCode => 1;
}
