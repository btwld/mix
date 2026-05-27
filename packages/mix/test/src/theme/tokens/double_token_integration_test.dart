import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('DoubleToken Integration Tests', () {
    test('DoubleToken can be created and called', () {
      const token = DoubleToken('opacity.half');

      // Calling the token should return a DoubleRef
      final ref = token();

      expect(ref, isA<double>());
      expect(ref, isA<DoubleRef>());
      // DoubleRef should be detectable as a token reference
      expect(isAnyTokenRef(ref), isTrue);
    });

    testWidgets('DoubleToken resolves through MixScope', (tester) async {
      const doubleToken = DoubleToken('opacity.test');
      const testValue = 0.75;

      await tester.pumpWidget(
        MixScope(
          tokens: {doubleToken: testValue},
          child: Builder(
            builder: (context) {
              final resolvedValue = doubleToken.resolve(context);

              expect(resolvedValue, equals(testValue));
              expect(resolvedValue, equals(0.75));

              return Container();
            },
          ),
        ),
      );
    });

    test('DoubleToken integrates with getReferenceValue', () {
      const doubleToken = DoubleToken('test.double');

      final ref = getReferenceValue(doubleToken);

      expect(ref, isA<double>());
      expect(ref, isA<DoubleRef>());
      expect(isAnyTokenRef(ref), isTrue);
    });

    test('DoubleRef implements double interface', () {
      const doubleToken = DoubleToken('test.value');
      final doubleRef = doubleToken();

      // Should work as a double in arithmetic operations
      final result = doubleRef + 1.0;
      expect(result, isA<double>());

      // Should work with comparison operators
      expect(doubleRef > 0, isA<bool>());
      expect(doubleRef < 1, isA<bool>());
    });

    test('DoubleToken and SpaceToken both produce token-detectable refs', () {
      const doubleToken = DoubleToken('general.value');
      const spaceToken = SpaceToken('space.value');

      final doubleRef = getReferenceValue(doubleToken);
      final spaceRef = getReferenceValue(spaceToken);

      // Both must satisfy the double interface (call site assignability).
      expect(doubleRef, isA<double>());
      expect(spaceRef, isA<double>());

      // Both must be recognised as token refs and round-trip to their tokens.
      expect(isAnyTokenRef(doubleRef), isTrue);
      expect(isAnyTokenRef(spaceRef), isTrue);
      expect(getTokenFromValue<double>(doubleRef), equals(doubleToken));
      expect(getTokenFromValue<double>(spaceRef), equals(spaceToken));
    });

    test('a plain double that is not registered stays a ValueSource', () {
      const ordinary = 42.0;

      expect(isAnyTokenRef(ordinary), isFalse);

      final prop = Prop.value(ordinary);
      expect(prop, PropMatcher.hasValues);
      expect(prop, isNot(PropMatcher.hasTokens));
    });
  });
}
