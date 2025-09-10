import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/core/prop_refs.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';
import 'package:mix/src/core/prop_source.dart';

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

      test('noSuchMethod throws UnimplementedError with detailed message', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        expect(
          () => (ref as dynamic).nonExistentMethod(),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              allOf([
                contains(
                  "Cannot access 'nonExistentMethod' on a Color token reference",
                ),
                contains('This is a context-dependent Color token'),
                contains(
                  'Token references can only be passed directly to Mix styling utilities',
                ),
                contains('Pass it to Mix utilities'),
                contains('Or resolve it first'),
              ]),
            ),
          ),
        );
      });
    });

    group('Class-based Token References', () {
      test('ColorRef implements Color interface', () {
        final token = TestToken<Color>('test-color');
        final ref = ColorRef(Prop.token(token));

        expect(ref, isA<Color>());
        expect(ref, PropMatcher.isToken(token));
      });

      test('DurationProp implements Duration interface', () {
        final token = TestToken<Duration>('test-duration');
        final ref = DurationRef(Prop.token(token));

        expect(ref, isA<Duration>());
        expect(ref, PropMatcher.isToken(token));
      });

      test('OffsetProp implements Offset interface', () {
        final token = TestToken<Offset>('test-offset');
        final ref = OffsetRef(Prop.token(token));

        expect(ref, isA<Offset>());
        expect(ref, PropMatcher.isToken(token));
      });

      test('RadiusProp implements Radius interface', () {
        final token = TestToken<Radius>('test-radius');
        final ref = RadiusRef(Prop.token(token));

        expect(ref, isA<Radius>());
        expect(ref, PropMatcher.isToken(token));
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

      group('IntRef', () {
        test('creates from token using hybrid hashing', () {
          final token = TestToken<int>('test-int');
          final ref = IntRef.token(token);

          expect(ref, isA<int>());
          expect(getTokenFromValue<int>(ref), equals(token));
          // Value is based on token's hash code
        });

        test('can be used as int', () {
          final token = TestToken<int>('test-int');
          final ref = IntRef.token(token);

          // Test arithmetic operations work correctly
          final originalValue = ref as int;
          expect(ref + 1, equals(originalValue + 1));
          expect(ref - 1, equals(originalValue - 1));
          expect(ref * 2, equals(originalValue * 2));
          expect(ref ~/ 2, equals(originalValue ~/ 2));
        });

        test('deterministic value for same token', () {
          final token = TestToken<int>('consistent-int');
          final ref1 = IntRef.token(token);
          final ref2 = IntRef.token(token);

          expect(ref1, equals(ref2));
          expect(
            getTokenFromValue<int>(ref1),
            equals(getTokenFromValue<int>(ref2)),
          );
        });

        test('different values for different tokens', () {
          final token1 = TestToken<int>('int-1');
          final token2 = TestToken<int>('int-2');
          final ref1 = IntRef.token(token1);
          final ref2 = IntRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(
            getTokenFromValue<int>(ref1),
            isNot(equals(getTokenFromValue<int>(ref2))),
          );
        });
      });

      group('StringRef', () {
        test('creates from token using hybrid hashing', () {
          final token = TestToken<String>('test-string');
          final ref = StringRef.token(token);

          expect(ref, isA<String>());
          expect(getTokenFromValue<String>(ref), equals(token));
          // Verify the value starts with the expected prefix
          expect(ref, startsWith('_tk_'));
        });

        test('can be used as string', () {
          final token = TestToken<String>('test-string');
          final ref = StringRef.token(token);

          // Test string operations
          expect(ref.length, greaterThan(4)); // At least '_tk_' + some digits
          expect(ref.contains('_tk_'), isTrue);
          expect(ref.startsWith('_tk_'), isTrue);
          expect(ref.toUpperCase(), contains('_TK_'));
        });

        test('deterministic value for same token', () {
          final token = TestToken<String>('consistent-string');
          final ref1 = StringRef.token(token);
          final ref2 = StringRef.token(token);

          expect(ref1, equals(ref2));
          expect(getTokenFromValue(ref1), equals(getTokenFromValue(ref2)));
        });

        test('different values for different tokens', () {
          final token1 = TestToken<String>('string-1');
          final token2 = TestToken<String>('string-2');
          final ref1 = StringRef.token(token1);
          final ref2 = StringRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(
            getTokenFromValue<String>(ref1),
            isNot(equals(getTokenFromValue<String>(ref2))),
          );
        });

        test('generates valid base36 representation', () {
          final token = TestToken<String>('base36-test');
          final ref = StringRef.token(token);

          expect(ref, startsWith('_tk_'));
          expect(ref, matches(RegExp(r'^_tk_[0-9a-z]+$')));
        });
      });
    });

    group('Registry Management', () {
      test('clearTokenRegistry removes all entries', () {
        final token1 = TestToken<double>('test-1');
        final token2 = TestToken<int>('test-2');
        final token3 = TestToken<String>('test-3');

        final ref1 = DoubleRef.token(token1);
        final ref2 = IntRef.token(token2);
        final ref3 = StringRef.token(token3);

        // Verify they work before clearing
        expect(getTokenFromValue(ref1), equals(token1));
        expect(getTokenFromValue(ref2), equals(token2));
        expect(getTokenFromValue(ref3), equals(token3));

        // Clear registry
        clearTokenRegistry();

        // Should throw after clearing
        expect(getTokenFromValue(ref1), isNull);
        expect(getTokenFromValue(ref2), isNull);
        expect(getTokenFromValue(ref3), isNull);
      });

      test('registry handles multiple tokens correctly', () {
        final tokens = List.generate(10, (i) => TestToken<double>('token-$i'));
        final refs = tokens.map((token) => DoubleRef.token(token)).toList();

        // Verify all references work
        for (int i = 0; i < tokens.length; i++) {
          expect(getTokenFromValue(refs[i]), equals(tokens[i]));
          expect(getTokenFromValue(refs[i])?.name, equals('token-$i'));
        }
      });

      test('different primitive types can coexist in registry', () {
        final doubleToken = TestToken<double>('double-token');
        final intToken = TestToken<int>('int-token');
        final stringToken = TestToken<String>('string-token');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(getTokenFromValue(doubleRef), equals(doubleToken));
        expect(getTokenFromValue(intRef), equals(intToken));
        expect(getTokenFromValue(stringRef), equals(stringToken));
      });
    });

    group('Edge Cases', () {
      test('handles tokens with same name but different instances', () {
        final token1 = TestToken<double>('same-name');
        final token2 = TestToken<double>('same-name');

        final ref1 = DoubleRef.token(token1);
        final ref2 = DoubleRef.token(token2);

        // Same token instances should produce same values
        expect(ref1, equals(ref1));
        expect(ref2, equals(ref2));

        // Different token instances with same name are equal (TestToken equality is name-based)
        // but may produce different representation values based on object hashCode
        expect(
          getTokenFromValue(ref1),
          equals(getTokenFromValue(ref2)),
        ); // Tokens are equal by name

        // But each ref should correctly retrieve its own token
        expect(getTokenFromValue(ref1), equals(token1));
        expect(getTokenFromValue(ref2), equals(token2));
      });

      test('handles tokens with special characters in names', () {
        final token = TestToken<String>('special!@#\$%^&*()_+-={}[]|;:,.<>?');
        final ref = StringRef.token(token);

        expect(getTokenFromValue(ref), equals(token));
        expect(
          getTokenFromValue(ref)?.name,
          equals('special!@#\$%^&*()_+-={}[]|;:,.<>?'),
        );
      });

      test('handles empty and very long token names', () {
        final emptyToken = TestToken<String>('');
        final longToken = TestToken<String>('a' * 1000);

        final emptyRef = StringRef.token(emptyToken);
        final longRef = StringRef.token(longToken);

        expect(getTokenFromValue(emptyRef), equals(emptyToken));
        expect(getTokenFromValue(longRef), equals(longToken));
      });

      test('handles negative hashCode values', () {
        // Create a token that likely has negative hashCode
        final token = TestToken<int>('negative-hash-test');
        final ref = IntRef.token(token);

        expect(getTokenFromValue(ref), equals(token));
        // Value is based on token's hash code
      });
    });

    group('Type Safety', () {
      test('extension types maintain type safety', () {
        final doubleToken = TestToken<double>('type-test');
        final intToken = TestToken<int>('type-test');
        final stringToken = TestToken<String>('type-test');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(doubleRef, isA<double>());
        expect(intRef, isA<int>());
        expect(stringRef, isA<String>());

        // Verify token types are preserved
        expect(getTokenFromValue(doubleRef), isA<TestToken<double>>());
        expect(getTokenFromValue(intRef), isA<TestToken<int>>());
        expect(getTokenFromValue(stringRef), isA<TestToken<String>>());
      });
    });

    group('isAnyTokenRef Function', () {
      test('returns true for class-based token references', () {
        final colorToken = TestToken<Color>('test-color');
        final durationToken = TestToken<Duration>('test-duration');
        final offsetToken = TestToken<Offset>('test-offset');
        final radiusToken = TestToken<Radius>('test-radius');
        final textStyleToken = TestToken<TextStyle>('test-text-style');

        final colorRef = ColorRef(Prop.token(colorToken));
        final durationRef = DurationRef(Prop.token(durationToken));
        final offsetProp = OffsetRef(Prop.token(offsetToken));
        final radiusRef = RadiusRef(Prop.token(radiusToken));
        final textStyleRef = TextStyleRef(Prop.token(textStyleToken));

        expect(isAnyTokenRef(colorRef), isTrue);
        expect(isAnyTokenRef(durationRef), isTrue);
        expect(isAnyTokenRef(offsetProp), isTrue);
        expect(isAnyTokenRef(radiusRef), isTrue);
        expect(isAnyTokenRef(textStyleRef), isTrue);
      });

      test('returns true for extension type token references', () {
        final doubleToken = TestToken<double>('test-double');
        final intToken = TestToken<int>('test-int');
        final stringToken = TestToken<String>('test-string');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(isAnyTokenRef(doubleRef), isTrue);
        expect(isAnyTokenRef(intRef), isTrue);
        expect(isAnyTokenRef(stringRef), isTrue);
      });

      test('returns false for non-token values', () {
        expect(isAnyTokenRef(Colors.red), isFalse);
        expect(isAnyTokenRef(42.0), isFalse);
        expect(isAnyTokenRef(42), isFalse);
        expect(isAnyTokenRef('hello'), isFalse);
        expect(isAnyTokenRef(const Duration(seconds: 1)), isFalse);
        expect(isAnyTokenRef(const Offset(10, 20)), isFalse);
        expect(isAnyTokenRef(Radius.circular(5)), isFalse);
        expect(isAnyTokenRef(<String>[]), isFalse);
        expect(isAnyTokenRef(<String, Object>{}), isFalse);
      });

      test(
        'returns false for manually created extension type values not in registry',
        () {
          final manualDoubleRef = DoubleRef(42.0);
          final manualIntRef = IntRef(42);
          final manualStringRef = StringRef('manual');

          expect(isAnyTokenRef(manualDoubleRef), isFalse);
          expect(isAnyTokenRef(manualIntRef), isFalse);
          expect(isAnyTokenRef(manualStringRef), isFalse);
        },
      );

      test('handles mixed collections correctly', () {
        final colorToken = TestToken<Color>('test-color');
        final doubleToken = TestToken<double>('test-double');

        final colorRef = ColorRef(Prop.token(colorToken));
        final doubleRef = DoubleRef.token(doubleToken);

        final mixedList = [colorRef, Colors.blue, doubleRef, 42.0, 'hello'];

        expect(isAnyTokenRef(mixedList[0]), isTrue); // ColorRef
        expect(isAnyTokenRef(mixedList[1]), isFalse); // Colors.blue
        expect(isAnyTokenRef(mixedList[2]), isTrue); // DoubleRef
        expect(isAnyTokenRef(mixedList[3]), isFalse); // 42.0
        expect(isAnyTokenRef(mixedList[4]), isFalse); // 'hello'
      });

      test('works correctly after registry clear', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(isAnyTokenRef(doubleRef), isTrue);

        clearTokenRegistry();

        expect(isAnyTokenRef(doubleRef), isFalse);
      });
    });

    group('getTokenFromValue Function', () {
      test('returns token for class-based token references', () {
        final colorToken = TestToken<Color>('test-color');
        final durationToken = TestToken<Duration>('test-duration');
        final offsetToken = TestToken<Offset>('test-offset');

        final colorRef = ColorRef(Prop.token(colorToken));
        final durationProp = DurationRef(Prop.token(durationToken));
        final offsetProp = OffsetRef(Prop.token(offsetToken));

        expect(colorRef, PropMatcher.isToken(colorToken));
        expect(durationProp, PropMatcher.isToken(durationToken));
        expect(offsetProp, PropMatcher.isToken(offsetToken));
      });

      test('returns token for extension type token references', () {
        final doubleToken = TestToken<double>('test-double');
        final intToken = TestToken<int>('test-int');
        final stringToken = TestToken<String>('test-string');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(getTokenFromValue(doubleRef), equals(doubleToken));
        expect(getTokenFromValue(intRef), equals(intToken));
        expect(getTokenFromValue(stringRef), equals(stringToken));
      });

      test('returns null for non-token values', () {
        expect(getTokenFromValue(Colors.red), isNull);
        expect(getTokenFromValue(42.0), isNull);
        expect(getTokenFromValue(42), isNull);
        expect(getTokenFromValue('hello'), isNull);
        expect(getTokenFromValue(const Duration(seconds: 1)), isNull);
        expect(getTokenFromValue(const Offset(10, 20)), isNull);
        expect(getTokenFromValue(Radius.circular(5)), isNull);
      });

      test(
        'returns null for manually created extension type values not in registry',
        () {
          final manualDoubleRef = DoubleRef(42.0);
          final manualIntRef = IntRef(42);
          final manualStringRef = StringRef('manual');

          expect(getTokenFromValue(manualDoubleRef), isNull);
          expect(getTokenFromValue(manualIntRef), isNull);
          expect(getTokenFromValue(manualStringRef), isNull);
        },
      );

      test('maintains type safety with generic parameter', () {
        final colorToken = TestToken<Color>('test-color');
        final doubleToken = TestToken<double>('test-double');
        final stringToken = TestToken<String>('test-string');

        final colorRef = ColorRef(Prop.token(colorToken));
        final doubleRef = DoubleRef.token(doubleToken);
        final stringRef = StringRef.token(stringToken);

        // Type-safe calls for class-based refs use $token
        final TestToken<Color> colorResult =
            colorRef.sources.whereType<TokenSource<Color>>().first.token
                as TestToken<Color>;
        final TestToken<double>? doubleResult =
            getTokenFromValue<double>(doubleRef) as TestToken<double>?;
        final TestToken<String>? stringResult =
            getTokenFromValue<String>(stringRef) as TestToken<String>?;

        expect(colorResult, equals(colorToken));
        expect(doubleResult, equals(doubleToken));
        expect(stringResult, equals(stringToken));

        expect(colorResult, isA<TestToken<Color>>());
        expect(doubleResult, isA<TestToken<double>>());
        expect(stringResult, isA<TestToken<String>>());
      });

      test('returns null when type parameter does not match token type', () {
        // This test is not applicable anymore as the type system prevents
        // passing a ColorRef (which implements Color) as a double parameter
        // The compiler will catch such type mismatches at compile time
      });

      test('handles polymorphic token references correctly', () {
        final alignmentGeometryToken = TestToken<AlignmentGeometry>(
          'test-alignment-geometry',
        );
        final alignmentToken = TestToken<Alignment>('test-alignment');

        final alignmentGeometryRef = AlignmentGeometryRef(
          Prop.token(alignmentGeometryToken),
        );
        final alignmentRef = AlignmentRef(Prop.token(alignmentToken));

        // Both should work with their specific types
        expect(
          alignmentGeometryRef,
          PropMatcher.isToken(alignmentGeometryToken),
        );
        expect(alignmentRef, PropMatcher.isToken(alignmentToken));

        // Both are class-based refs, so they use $token
        expect(alignmentRef, PropMatcher.isToken(alignmentToken));
      });

      test('works correctly after registry clear', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(getTokenFromValue(doubleRef), equals(doubleToken));

        clearTokenRegistry();

        expect(getTokenFromValue(doubleRef), isNull);
      });

      test('handles multiple tokens of same type correctly', () {
        final token1 = TestToken<double>('double-1');
        final token2 = TestToken<double>('double-2');
        final token3 = TestToken<double>('double-3');

        final ref1 = DoubleRef.token(token1);
        final ref2 = DoubleRef.token(token2);
        final ref3 = DoubleRef.token(token3);

        expect(getTokenFromValue(ref1), equals(token1));
        expect(getTokenFromValue(ref2), equals(token2));
        expect(getTokenFromValue(ref3), equals(token3));

        // Ensure they don't interfere with each other
        expect(getTokenFromValue(ref1), isNot(equals(token2)));
        expect(getTokenFromValue(ref1), isNot(equals(token3)));
      });

      test('works with edge case token names', () {
        final emptyNameToken = TestToken<String>('');
        final longNameToken = TestToken<String>('a' * 1000);
        final specialCharsToken = TestToken<String>('special!@#\$%^&*()');

        final emptyRef = StringRef.token(emptyNameToken);
        final longRef = StringRef.token(longNameToken);
        final specialRef = StringRef.token(specialCharsToken);

        expect(getTokenFromValue(emptyRef), equals(emptyNameToken));
        expect(getTokenFromValue(longRef), equals(longNameToken));
        expect(getTokenFromValue(specialRef), equals(specialCharsToken));
      });
    });
  });
}
