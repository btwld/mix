import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/core/prop_refs.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';
import 'package:mix/src/theme/mix_theme.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop.value with Token References', () {
    setUp(() {
      clearTokenRegistry();
    });

    group('Current Behavior Tests', () {
      test('ColorRef behavior - isAnyTokenRef detects it correctly', () {
        final colorToken = TestToken<Color>('test-color');
        final colorRef = ColorRef(Prop.token(colorToken));

        // ColorRef should be detected as a token reference
        expect(
          isAnyTokenRef(colorRef),
          isTrue,
          reason: 'Should detect ColorRef as token reference',
        );

        // ColorRef already has proper token behavior built-in
        expect(
          colorRef,
          PropMatcher.hasTokens,
          reason: 'ColorRef should have token source',
        );
        expect(
          colorRef,
          PropMatcher.isToken(colorToken),
          reason: 'ColorRef should contain the original token',
        );
      });

      test('DoubleRef passed to Prop.value - now detects token', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        // Pass the DoubleRef to Prop.value
        final prop = Prop.value(doubleRef);

        // With fix: should now detect DoubleRef as token
        expect(
          prop,
          PropMatcher.hasTokens,
          reason: 'Should detect DoubleRef as token reference',
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

      test('BorderSideRef behavior - isAnyTokenRef detects it correctly', () {
        final borderSideToken = TestToken<BorderSide>('test-border-side');
        final borderSideRef = BorderSideRef(Prop.token(borderSideToken));

        // BorderSideRef should be detected as a token reference
        expect(
          isAnyTokenRef(borderSideRef),
          isTrue,
          reason: 'Should detect BorderSideRef as token reference',
        );

        // BorderSideRef should have proper token behavior built-in
        expect(
          borderSideRef,
          PropMatcher.hasTokens,
          reason: 'BorderSideRef should have token source',
        );
        expect(
          borderSideRef,
          PropMatcher.isToken(borderSideToken),
          reason: 'BorderSideRef should contain the original token',
        );
      });
    });

    group('Token Resolution Tests', () {
      testWidgets('DoubleRef resolves to token value from context', (
        tester,
      ) async {
        final doubleToken = TestToken<double>('width-token');
        final doubleRef = DoubleRef.token(doubleToken);

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

      testWidgets('BorderSideRef resolves to token value from context', (
        tester,
      ) async {
        final borderSideToken = TestToken<BorderSide>('border-side-token');
        const testBorderSide = BorderSide(color: Colors.red, width: 2.0);
        final borderSideRef = BorderSideRef(Prop.token(borderSideToken));

        // BorderSideRef IS already a Prop, no need to wrap in Prop.value
        final prop = borderSideRef;

        // Verify it's stored as TokenSource
        expect(prop, PropMatcher.hasTokens);
        expect(prop, PropMatcher.isToken(borderSideToken));

        await tester.pumpWidget(
          MixScope(
            tokens: {
              borderSideToken: testBorderSide, // Define the token value
            },
            child: Builder(
              builder: (context) {
                // Resolve the prop - should return the token value, not the ref value
                final resolved = prop.resolveProp(context);

                expect(
                  resolved,
                  equals(testBorderSide),
                  reason: 'Should resolve to token value from theme',
                );
                expect(
                  resolved,
                  isNot(equals(borderSideRef)),
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
      test('isAnyTokenRef detects ColorRef correctly', () {
        final colorToken = TestToken<Color>('test-color');
        final colorRef = ColorRef(Prop.token(colorToken));

        expect(
          isAnyTokenRef(colorRef),
          isTrue,
          reason: 'isAnyTokenRef should detect ColorRef',
        );
      });

      test('isAnyTokenRef detects DoubleRef correctly', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(
          isAnyTokenRef(doubleRef),
          isTrue,
          reason: 'isAnyTokenRef should detect DoubleRef',
        );
      });

      test('isAnyTokenRef detects BorderSideRef correctly', () {
        final borderSideToken = TestToken<BorderSide>('test-border-side');
        final borderSideRef = BorderSideRef(Prop.token(borderSideToken));

        expect(
          isAnyTokenRef(borderSideRef),
          isTrue,
          reason: 'isAnyTokenRef should detect BorderSideRef',
        );
      });

      test('getTokenFromValue retrieves token from DoubleRef', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        final retrieved = getTokenFromValue(doubleRef);
        expect(
          retrieved,
          equals(doubleToken),
          reason: 'Should retrieve original token from DoubleRef',
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
