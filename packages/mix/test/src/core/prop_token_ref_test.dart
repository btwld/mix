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

      test('IntRef passed to Prop.value - now detects token', () {
        final intToken = TestToken<int>('test-int');
        final intRef = IntRef.token(intToken);

        // Pass the IntRef to Prop.value
        final prop = Prop.value(intRef);

        // With fix: should now detect IntRef as token
        expect(
          prop,
          PropMatcher.hasTokens,
          reason: 'Should detect IntRef as token reference',
        );
        expect(
          prop,
          PropMatcher.isToken(intToken),
          reason: 'Should store the original int token',
        );
        expect(
          prop,
          isNot(PropMatcher.hasValues),
          reason: 'Should not store as ValueSource',
        );
      });

      test('StringRef passed to Prop.value - now detects token', () {
        final stringToken = TestToken<String>('test-string');
        final stringRef = StringRef.token(stringToken);

        // Pass the StringRef to Prop.value
        final prop = Prop.value(stringRef);

        // With fix: should now detect StringRef as token
        expect(
          prop,
          PropMatcher.hasTokens,
          reason: 'Should detect StringRef as token reference',
        );
        expect(
          prop,
          PropMatcher.isToken(stringToken),
          reason: 'Should store the original string token',
        );
        expect(
          prop,
          isNot(PropMatcher.hasValues),
          reason: 'Should not store as ValueSource',
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

      testWidgets('IntRef resolves to token value from context', (
        tester,
      ) async {
        final intToken = TestToken<int>('count-token');
        final intRef = IntRef.token(intToken);

        final prop = Prop.value(intRef);

        expect(prop, PropMatcher.hasTokens);
        expect(prop, PropMatcher.isToken(intToken));

        await tester.pumpWidget(
          MixScope(
            tokens: {intToken: 42},
            child: Builder(
              builder: (context) {
                final resolved = prop.resolveProp(context);

                expect(resolved, equals(42));
                expect(resolved, isNot(equals(intRef)));

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('StringRef resolves to token value from context', (
        tester,
      ) async {
        final stringToken = TestToken<String>('text-token');
        final stringRef = StringRef.token(stringToken);

        final prop = Prop.value(stringRef);

        expect(prop, PropMatcher.hasTokens);
        expect(prop, PropMatcher.isToken(stringToken));

        await tester.pumpWidget(
          MixScope(
            tokens: {stringToken: 'Hello World'},
            child: Builder(
              builder: (context) {
                final resolved = prop.resolveProp(context);

                expect(resolved, equals('Hello World'));
                expect(resolved, isNot(equals(stringRef)));

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

      test('isAnyTokenRef detects DoubleRef correctly', () {
        final doubleToken = TestToken<double>('test-double');
        final doubleRef = DoubleRef.token(doubleToken);

        expect(
          isAnyTokenRef(doubleRef),
          isTrue,
          reason: 'isAnyTokenRef should detect DoubleRef',
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
