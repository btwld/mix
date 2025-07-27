import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/theme/tokens/mix_token.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';

void main() {
  group('Token References', () {
    setUp(() {
      // Clear registry before each test to ensure clean state
      clearTokenRegistry();
    });

    group('TokenRef Base Class', () {
      test('creates with token', () {
        final token = MixToken<Color>('test-color');
        final ref = ColorRef(token);

        expect(ref.token, equals(token));
      });

      test('equality based on token', () {
        final token1 = MixToken<Color>('test-color');
        final token2 = MixToken<Color>(
          'test-color',
        ); // Same name, different instance
        final token3 = MixToken<Color>('different-color');

        final ref1 = ColorRef(token1);
        final ref2 = ColorRef(token1); // Same token instance
        final ref3 = ColorRef(token2); // Different token instance, same name
        final ref4 = ColorRef(token3); // Different token

        expect(ref1, equals(ref2));
        expect(
          ref1,
          equals(ref3),
        ); // MixToken equality is based on name, so these are equal
        expect(ref1, isNot(equals(ref4)));
      });

      test('hashCode based on token', () {
        final token = MixToken<Color>('test-color');
        final ref1 = ColorRef(token);
        final ref2 = ColorRef(token);

        expect(ref1.hashCode, equals(ref2.hashCode));
        expect(ref1.hashCode, equals(token.hashCode));
      });

      test('toString shows type and token name', () {
        final token = MixToken<Color>('primary-color');
        final ref = ColorRef(token);

        expect(ref.toString(), equals('TokenRef<Color>(primary-color)'));
      });

      test('noSuchMethod throws UnimplementedError', () {
        final token = MixToken<Color>('test-color');
        final ref = ColorRef(token);

        expect(
          () => (ref as dynamic).nonExistentMethod(),
          throwsA(
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              contains('This is a Token reference for Color'),
            ),
          ),
        );
      });
    });

    group('Class-based Token References', () {
      test('ColorRef implements Color interface', () {
        final token = MixToken<Color>('test-color');
        final ref = ColorRef(token);

        expect(ref, isA<Color>());
        expect(ref.token, equals(token));
      });

      test('DurationRef implements Duration interface', () {
        final token = MixToken<Duration>('test-duration');
        final ref = DurationRef(token);

        expect(ref, isA<Duration>());
        expect(ref.token, equals(token));
      });

      test('OffsetRef implements Offset interface', () {
        final token = MixToken<Offset>('test-offset');
        final ref = OffsetRef(token);

        expect(ref, isA<Offset>());
        expect(ref.token, equals(token));
      });

      test('RadiusRef implements Radius interface', () {
        final token = MixToken<Radius>('test-radius');
        final ref = RadiusRef(token);

        expect(ref, isA<Radius>());
        expect(ref.token, equals(token));
      });
    });

    group('Extension Type Token References', () {
      group('DoubleRef', () {
        test('creates from token using token hashCode', () {
          final token = MixToken<double>('test-double');
          final ref = DoubleRef.token(token);

          expect(ref, isA<double>());
          expect(ref.mixToken, equals(token));
          expect(ref, equals(token.hashCode.toDouble()));
        });

        test('can be used as double', () {
          final token = MixToken<double>('test-double');
          final ref = DoubleRef.token(token);

          // Test arithmetic operations
          expect(ref + 1.0, equals(token.hashCode.toDouble() + 1.0));
          expect(ref - 1.0, equals(token.hashCode.toDouble() - 1.0));
          expect(ref * 2.0, equals(token.hashCode.toDouble() * 2.0));
          expect(ref / 2.0, equals(token.hashCode.toDouble() / 2.0));
        });

        test('deterministic value for same token', () {
          final token = MixToken<double>('consistent-double');
          final ref1 = DoubleRef.token(token);
          final ref2 = DoubleRef.token(token);

          expect(ref1, equals(ref2));
          expect(ref1.mixToken, equals(ref2.mixToken));
        });

        test('different values for different tokens', () {
          final token1 = MixToken<double>('double-1');
          final token2 = MixToken<double>('double-2');
          final ref1 = DoubleRef.token(token1);
          final ref2 = DoubleRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(ref1.mixToken, isNot(equals(ref2.mixToken)));
        });

        test('registry lookup works correctly', () {
          final token = MixToken<double>('registry-test');
          final ref = DoubleRef.token(token);

          expect(ref.mixToken, equals(token));
          expect(ref.mixToken.name, equals('registry-test'));
        });

        test('throws when token not found in registry', () {
          // Create a DoubleRef manually without registering it
          final manualRef = DoubleRef(42.0);

          expect(() => manualRef.mixToken, throwsA(isA<TypeError>()));
        });
      });

      group('IntRef', () {
        test('creates from token using token hashCode', () {
          final token = MixToken<int>('test-int');
          final ref = IntRef.token(token);

          expect(ref, isA<int>());
          expect(ref.mixToken, equals(token));
          expect(ref, equals(token.hashCode));
        });

        test('can be used as int', () {
          final token = MixToken<int>('test-int');
          final ref = IntRef.token(token);

          // Test arithmetic operations
          expect(ref + 1, equals(token.hashCode + 1));
          expect(ref - 1, equals(token.hashCode - 1));
          expect(ref * 2, equals(token.hashCode * 2));
          expect(ref ~/ 2, equals(token.hashCode ~/ 2));
        });

        test('deterministic value for same token', () {
          final token = MixToken<int>('consistent-int');
          final ref1 = IntRef.token(token);
          final ref2 = IntRef.token(token);

          expect(ref1, equals(ref2));
          expect(ref1.mixToken, equals(ref2.mixToken));
        });

        test('different values for different tokens', () {
          final token1 = MixToken<int>('int-1');
          final token2 = MixToken<int>('int-2');
          final ref1 = IntRef.token(token1);
          final ref2 = IntRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(ref1.mixToken, isNot(equals(ref2.mixToken)));
        });
      });

      group('StringRef', () {
        test('creates from token using token hashCode', () {
          final token = MixToken<String>('test-string');
          final ref = StringRef.token(token);

          expect(ref, isA<String>());
          expect(ref.mixToken, equals(token));
          expect(ref, equals('_tk_${token.hashCode.toRadixString(36)}'));
        });

        test('can be used as string', () {
          final token = MixToken<String>('test-string');
          final ref = StringRef.token(token);
          final expectedValue = '_tk_${token.hashCode.toRadixString(36)}';

          // Test string operations
          expect(ref.length, equals(expectedValue.length));
          expect(ref.contains('_tk_'), isTrue);
          expect(ref.startsWith('_tk_'), isTrue);
          expect(ref.toUpperCase(), equals(expectedValue.toUpperCase()));
        });

        test('deterministic value for same token', () {
          final token = MixToken<String>('consistent-string');
          final ref1 = StringRef.token(token);
          final ref2 = StringRef.token(token);

          expect(ref1, equals(ref2));
          expect(ref1.mixToken, equals(ref2.mixToken));
        });

        test('different values for different tokens', () {
          final token1 = MixToken<String>('string-1');
          final token2 = MixToken<String>('string-2');
          final ref1 = StringRef.token(token1);
          final ref2 = StringRef.token(token2);

          expect(ref1, isNot(equals(ref2)));
          expect(ref1.mixToken, isNot(equals(ref2.mixToken)));
        });

        test('generates valid base36 representation', () {
          final token = MixToken<String>('base36-test');
          final ref = StringRef.token(token);
          final hashBase36 = token.hashCode.toRadixString(36);

          expect(ref, equals('_tk_$hashBase36'));
          expect(ref, matches(RegExp(r'^_tk_[0-9a-z]+$')));
        });
      });
    });

    group('Registry Management', () {
      test('clearTokenRegistry removes all entries', () {
        final token1 = MixToken<double>('test-1');
        final token2 = MixToken<int>('test-2');
        final token3 = MixToken<String>('test-3');

        final ref1 = DoubleRef.token(token1);
        final ref2 = IntRef.token(token2);
        final ref3 = StringRef.token(token3);

        // Verify they work before clearing
        expect(ref1.mixToken, equals(token1));
        expect(ref2.mixToken, equals(token2));
        expect(ref3.mixToken, equals(token3));

        // Clear registry
        clearTokenRegistry();

        // Should throw after clearing
        expect(() => ref1.mixToken, throwsA(isA<TypeError>()));
        expect(() => ref2.mixToken, throwsA(isA<TypeError>()));
        expect(() => ref3.mixToken, throwsA(isA<TypeError>()));
      });

      test('registry handles multiple tokens correctly', () {
        final tokens = List.generate(10, (i) => MixToken<double>('token-$i'));
        final refs = tokens.map((token) => DoubleRef.token(token)).toList();

        // Verify all references work
        for (int i = 0; i < tokens.length; i++) {
          expect(refs[i].mixToken, equals(tokens[i]));
          expect(refs[i].mixToken.name, equals('token-$i'));
        }
      });

      test('different primitive types can coexist in registry', () {
        final doubleToken = MixToken<double>('double-token');
        final intToken = MixToken<int>('int-token');
        final stringToken = MixToken<String>('string-token');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(doubleRef.mixToken, equals(doubleToken));
        expect(intRef.mixToken, equals(intToken));
        expect(stringRef.mixToken, equals(stringToken));
      });
    });

    group('Edge Cases', () {
      test('handles tokens with same name but different instances', () {
        final token1 = MixToken<double>('same-name');
        final token2 = MixToken<double>('same-name');

        final ref1 = DoubleRef.token(token1);
        final ref2 = DoubleRef.token(token2);

        // Same token instances should produce same values
        expect(ref1, equals(ref1));
        expect(ref2, equals(ref2));

        // Different token instances with same name are equal (MixToken equality is name-based)
        // but may produce different representation values based on object hashCode
        expect(
          ref1.mixToken,
          equals(ref2.mixToken),
        ); // Tokens are equal by name

        // But each ref should correctly retrieve its own token
        expect(ref1.mixToken, equals(token1));
        expect(ref2.mixToken, equals(token2));
      });

      test('handles tokens with special characters in names', () {
        final token = MixToken<String>('special!@#\$%^&*()_+-={}[]|;:,.<>?');
        final ref = StringRef.token(token);

        expect(ref.mixToken, equals(token));
        expect(ref.mixToken.name, equals('special!@#\$%^&*()_+-={}[]|;:,.<>?'));
      });

      test('handles empty and very long token names', () {
        final emptyToken = MixToken<String>('');
        final longToken = MixToken<String>('a' * 1000);

        final emptyRef = StringRef.token(emptyToken);
        final longRef = StringRef.token(longToken);

        expect(emptyRef.mixToken, equals(emptyToken));
        expect(longRef.mixToken, equals(longToken));
      });

      test('handles negative hashCode values', () {
        // Create a token that likely has negative hashCode
        final token = MixToken<int>('negative-hash-test');
        final ref = IntRef.token(token);

        expect(ref.mixToken, equals(token));
        expect(ref, equals(token.hashCode));
      });
    });

    group('Performance', () {
      test('registry lookup is efficient for many entries', () {
        final stopwatch = Stopwatch()..start();

        // Create many token references
        final refs = <DoubleRef>[];
        for (int i = 0; i < 1000; i++) {
          final token = MixToken<double>('perf-test-$i');
          refs.add(DoubleRef.token(token));
        }

        // Access all tokens
        for (final ref in refs) {
          ref.mixToken; // Should be fast
        }

        stopwatch.stop();

        // Sanity check that it completes reasonably quickly
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Type Safety', () {
      test('extension types maintain type safety', () {
        final doubleToken = MixToken<double>('type-test');
        final intToken = MixToken<int>('type-test');
        final stringToken = MixToken<String>('type-test');

        final doubleRef = DoubleRef.token(doubleToken);
        final intRef = IntRef.token(intToken);
        final stringRef = StringRef.token(stringToken);

        expect(doubleRef, isA<double>());
        expect(intRef, isA<int>());
        expect(stringRef, isA<String>());

        // Verify token types are preserved
        expect(doubleRef.mixToken, isA<MixToken<double>>());
        expect(intRef.mixToken, isA<MixToken<int>>());
        expect(stringRef.mixToken, isA<MixToken<String>>());
      });
    });
  });
}
