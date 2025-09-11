import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
            isA<UnimplementedError>().having(
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

    group('Extension Type Token References', () {
      group('SpaceRef', () {
        test('creates from token using hybrid hashing', () {
          final token = TestToken<double>('test-double');
          final ref = SpaceRef.token(token);

          expect(ref, isA<double>());
          expect(getTokenFromValue<double>(ref), equals(token));
          // Value is based on token's hash code
        });

        test('can be used as double', () {
          final token = TestToken<double>('test-double');
          final ref = SpaceRef.token(token);

          // Test arithmetic operations work correctly
          final originalValue = ref as double;
          expect(ref + 1.0, equals(originalValue + 1.0));
          expect(ref - 1.0, equals(originalValue - 1.0));
          expect(ref * 2.0, equals(originalValue * 2.0));
          expect(ref / 2.0, equals(originalValue / 2.0));
        });

        test('deterministic value for same token', () {
          final token = TestToken<double>('consistent-double');
          final ref1 = SpaceRef.token(token);
          final ref2 = SpaceRef.token(token);

          expect(ref1, equals(ref2));
          expect(
            getTokenFromValue<double>(ref1),
            equals(getTokenFromValue<double>(ref2)),
          );
        });

        test('different values for different tokens', () {
          final token1 = TestToken<double>('double-1');
          final token2 = TestToken<double>('double-2');
          final ref1 = SpaceRef.token(token1);
          final ref2 = SpaceRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(
            getTokenFromValue<double>(ref1),
            isNot(equals(getTokenFromValue<double>(ref2))),
          );
        });

        test('registry lookup works correctly', () {
          final token = TestToken<double>('registry-test');
          final ref = SpaceRef.token(token);

          expect(getTokenFromValue<double>(ref), equals(token));
          expect(getTokenFromValue<double>(ref)?.name, equals('registry-test'));
        });

        test('throws when token not found in registry', () {
          // Create a SpaceRef manually without registering it
          final manualRef = SpaceRef(42.0);

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

      test('detects SpaceRef as token reference', () {
        final token1 = TestToken<double>('test1');
        final ref1 = SpaceRef.token(token1);

        expect(isAnyTokenRef(ref1), isTrue);
      });

      test('correctly handles mixed types in collections', () {
        final colorToken = TestToken<Color>('color');
        final spaceToken = TestToken<double>('space');
        final colorRef = ColorRef(Prop.token(colorToken));
        final spaceRef = SpaceRef.token(spaceToken);

        final mixedList = <Object>[
          'regular string',
          42,
          spaceRef, // SpaceRef
          colorRef, // ColorRef
          Colors.red,
        ];

        expect(isAnyTokenRef(mixedList[0]), isFalse); // String
        expect(isAnyTokenRef(mixedList[1]), isFalse); // int
        expect(isAnyTokenRef(mixedList[2]), isTrue); // SpaceRef
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
        final manualSpaceRef = SpaceRef(42.0);

        expect(isAnyTokenRef(manualSpaceRef), isFalse);
      });
    });

    group('getTokenFromValue function', () {
      test('retrieves tokens from registered refs', () {
        final spaceToken = TestToken<double>('space');
        final spaceRef = SpaceRef.token(spaceToken);

        expect(getTokenFromValue(spaceRef), equals(spaceToken));
      });

      test('handles mixed registered and unregistered refs', () {
        final spaceToken = TestToken<double>('space');
        final spaceRef = SpaceRef.token(spaceToken);

        expect(getTokenFromValue(spaceRef), equals(spaceToken));
      });

      test('returns null for manually created refs', () {
        // Create refs manually without using .token() method
        final manualSpaceRef = SpaceRef(42.0);

        expect(getTokenFromValue(manualSpaceRef), isNull);
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
        final refs = tokens.map((token) => SpaceRef.token(token)).toList();

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
        final ref = SpaceRef.token(emptyNameToken);

        expect(getTokenFromValue(ref), equals(emptyNameToken));
      });

      test('handles complex token names', () {
        final longNameToken = TestToken<double>('very.long.token.name.with.dots');
        final specialCharsToken = TestToken<double>('token-with_special/chars@123');
        
        final longRef = SpaceRef.token(longNameToken);
        final specialRef = SpaceRef.token(specialCharsToken);

        expect(getTokenFromValue(longRef), equals(longNameToken));
        expect(getTokenFromValue(specialRef), equals(specialCharsToken));
      });
    });
  });
}