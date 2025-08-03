import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MixProp Token Support', () {
    group('MixProp.token constructor', () {
      test('creates MixProp with token source', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = MixProp.token(token, ShadowMix.value);

        expect(mixProp.sources, hasLength(1));
        expect(mixProp.sources.first, isA<MixTokenSource<Shadow>>());
        expect(
          mixProp.value,
          isNull,
        ); // Cannot provide value for tokens without context
      });

      test('stores token and converter correctly', () {
        final token = MixToken<BoxShadow>('shadow.box');
        final mixProp = MixProp.token(token, BoxShadowMix.value);

        expect(mixProp.sources, hasLength(1));
        final source = mixProp.sources.first as MixTokenSource<BoxShadow>;
        expect(source.token, equals(token));
        expect(source.converter, equals(BoxShadowMix.value));
      });
    });

    group('Token resolution', () {
      test('resolves token to correct value', () {
        final token = MixToken<Shadow>('shadow.primary');
        final shadowValue = Shadow(
          color: Colors.black,
          offset: Offset.zero,
          blurRadius: 4.0,
        );

        final mixProp = MixProp.token(token, ShadowMix.value);

        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: shadowValue}),
        );

        expect(mixProp, resolvesTo(shadowValue, context: context));
      });

      test('resolves BoxShadow token correctly', () {
        final token = MixToken<BoxShadow>('shadow.box');
        final boxShadowValue = BoxShadow(
          color: Colors.red,
          offset: Offset(2, 2),
          blurRadius: 8.0,
          spreadRadius: 1.0,
        );

        final mixProp = MixProp.token(token, BoxShadowMix.value);

        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: boxShadowValue}),
        );

        expect(mixProp, resolvesTo(boxShadowValue, context: context));
      });

      test('resolves TextStyle token correctly', () {
        final token = MixToken<TextStyle>('text.body');
        final textStyleValue = TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.blue,
        );

        final mixProp = MixProp.token(token, TextStyleMix.value);

        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: textStyleValue}),
        );

        expect(mixProp, resolvesTo(textStyleValue, context: context));
      });
    });

    group('Merging behavior', () {
      test('token source + value source (accumulation strategy)', () {
        final token = MixToken<Shadow>('shadow.primary');
        final shadowValue = Shadow(
          color: Colors.black,
          blurRadius: 4.0,
          offset: Offset.zero,
        );
        final directShadow = ShadowMix(color: Colors.red, blurRadius: 2.0);

        final tokenProp = MixProp.token(token, ShadowMix.value);
        final valueProp = MixProp(directShadow);

        final merged = tokenProp.mergeProp(valueProp);

        // Both sources should be accumulated and resolved during resolution
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<MixTokenSource<Shadow>>());
        expect(merged.sources[1], isA<MixValueSource<Shadow>>());

        // Test resolution with token context
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {token: shadowValue}),
        );

        final resolved = merged.resolveProp(context);
        // The resolved value should be the merged result of token + direct value
        expect(resolved, isA<Shadow>());
      });

      test('value source + token source (accumulation strategy)', () {
        final token = MixToken<Shadow>('shadow.primary');
        final directShadow = ShadowMix(color: Colors.red, blurRadius: 2.0);

        final valueProp = MixProp(directShadow);
        final tokenProp = MixProp.token(token, ShadowMix.value);

        final merged = valueProp.mergeProp(tokenProp);

        // Both sources should be accumulated
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<MixValueSource<Shadow>>());
        expect(merged.sources[1], isA<MixTokenSource<Shadow>>());
      });

      test('token source + token source (accumulation strategy)', () {
        final token1 = MixToken<Shadow>('shadow.primary');
        final token2 = MixToken<Shadow>('shadow.secondary');

        final prop1 = MixProp.token(token1, ShadowMix.value);
        final prop2 = MixProp.token(token2, ShadowMix.value);

        final merged = prop1.mergeProp(prop2);

        // Both token sources should be accumulated
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<MixTokenSource<Shadow>>());
        expect(merged.sources[1], isA<MixTokenSource<Shadow>>());
        final source1 = merged.sources[0] as MixTokenSource<Shadow>;
        final source2 = merged.sources[1] as MixTokenSource<Shadow>;
        expect(source1.token, equals(token1));
        expect(source2.token, equals(token2));
      });

      test('preserves modifiers and animation during merge', () {
        final token = MixToken<Shadow>('shadow.primary');
        final modifier = MockModifier<Shadow>('test');
        final animation = AnimationConfig.curve(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        final prop1 = MixProp<Shadow>.token(token, ShadowMix.value);
        final prop2 = MixProp<Shadow>.modifiers([modifier]);
        final prop3 = MixProp<Shadow>.animation(animation);

        final merged = prop1.mergeProp(prop2).mergeProp(prop3);

        expect(merged.$modifiers, contains(modifier));
        expect(merged.$animation, equals(animation));
      });
    });

    group('Edge cases', () {
      test('throws error when resolving without context token', () {
        final token = MixToken<Shadow>('shadow.missing');
        final mixProp = MixProp.token(token, ShadowMix.value);

        final context = MockBuildContext(); // No tokens defined

        expect(() => mixProp.resolveProp(context), throwsA(isA<StateError>()));
      });

      test('handles null merge correctly', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = MixProp.token(token, ShadowMix.value);

        final merged = mixProp.mergeProp(null);

        expect(merged, equals(mixProp));
      });

      test('equality works correctly for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final prop1 = MixProp.token(token, ShadowMix.value);
        final prop2 = MixProp.token(token, ShadowMix.value);

        expect(prop1, equals(prop2));
      });

      test('hashCode works correctly for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final prop1 = MixProp.token(token, ShadowMix.value);
        final prop2 = MixProp.token(token, ShadowMix.value);

        expect(prop1.hashCode, equals(prop2.hashCode));
      });
    });

    group('Backward compatibility', () {
      test('value getter returns null for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = MixProp.token(token, ShadowMix.value);

        expect(mixProp.value, isNull);
      });

      test('value getter returns Mix for value sources', () {
        final shadowMix = ShadowMix(color: Colors.red, blurRadius: 2.0);
        final mixProp = MixProp(shadowMix);

        expect(mixProp.value, equals(shadowMix));
      });
    });
  });
}
