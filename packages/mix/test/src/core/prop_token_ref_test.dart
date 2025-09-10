import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';
import 'package:mix/src/theme/mix_theme.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop.value with Token References', () {
    setUp(() {
      clearTokenRegistry();
    });

    group('Current Behavior Tests', () {
      test('ColorProp behavior - isAnyTokenRef detects it correctly', () {
        final colorToken = TestToken<Color>('test-color');
        final colorRef = ColorRef(Prop.token(colorToken));

        // ColorProp should be detected as a token reference
        expect(
          isAnyTokenRef(colorRef),
          isTrue,
          reason: 'Should detect ColorProp as token reference',
        );

        // ColorProp already has proper token behavior built-in
        expect(
          colorRef,
          PropMatcher.hasTokens,
          reason: 'ColorProp should have token source',
        );
        expect(
          colorRef,
          PropMatcher.isToken(colorToken),
          reason: 'ColorProp should contain the original token',
        );
      });

      test('SpaceRef passed to Prop.value - now detects token', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = SpaceRef.token(doubleToken);

        // Pass the DoubleRef to Prop.value
        final prop = Prop.value(doubleRef);

        // With fix: should now detect SpaceRef as token
        expect(
          prop,
          PropMatcher.hasTokens,
          reason: 'Should detect SpaceRef as token reference',
        );
        expect(
          prop,
          PropMatcher.isToken(doubleToken),
          reason: 'Should store the original double token',
        );
        expect(
          prop,
          isNot(PropMatcher.hasValues),
          reason: 'Should not store as ValueSource',
        );
      });


    });

    group('Token Resolution Tests', () {
      testWidgets('SpaceRef resolves to token value from context', (
        tester,
      ) async {
        final doubleToken = TestToken<double>('width-token');
        final doubleRef = SpaceRef.token(doubleToken);

        // Create Prop from token reference
        final prop = Prop.value(doubleRef);

        // Verify it's stored as TokenSource
        expect(prop, PropMatcher.hasTokens);
        expect(prop, PropMatcher.isToken(doubleToken));

        await tester.pumpWidget(
          MixScope(
            tokens: {
              doubleToken: 150.0, // Define the token value
            },
            child: Builder(
              builder: (context) {
                // Resolve the prop - should return the token value, not the ref value
                final resolved = prop.resolveProp(context);

                expect(
                  resolved,
                  equals(150.0),
                  reason: 'Should resolve to token value from theme',
                );
                expect(
                  resolved,
                  isNot(equals(doubleRef)),
                  reason: 'Should not return the reference value',
                );

                return Container();
              },
            ),
          ),
        );
      });


    });

    group('Verify detection functions work', () {
      test('isAnyTokenRef detects ColorProp correctly', () {
        final colorToken = TestToken<Color>('test-color');
        final colorRef = ColorRef(Prop.token(colorToken));

        expect(
          isAnyTokenRef(colorRef),
          isTrue,
          reason: 'isAnyTokenRef should detect ColorProp',
        );
      });

      test('isAnyTokenRef detects SpaceRef correctly', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = SpaceRef.token(doubleToken);

        expect(
          isAnyTokenRef(doubleRef),
          isTrue,
          reason: 'isAnyTokenRef should detect SpaceRef',
        );
      });

      test('getTokenFromValue retrieves token from SpaceRef', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = SpaceRef.token(doubleToken);

        final retrieved = getTokenFromValue(doubleRef);
        expect(
          retrieved,
          equals(doubleToken),
          reason: 'Should retrieve original token from SpaceRef',
        );
      });

      test('getTokenFromValue returns null for regular values', () {
        expect(getTokenFromValue(42.0), isNull);
        expect(getTokenFromValue(Colors.red), isNull);
        expect(getTokenFromValue('hello'), isNull);
      });
    });
  });
}
