import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop Token Support', () {
    group('Prop.token constructor', () {
      test('creates Prop with token source', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = Prop.token(token);

        expect(mixProp.sources, hasLength(1));
        expect(mixProp.sources.first, isA<TokenSource<Shadow>>());
        // TokenSource doesn't provide direct Mix value
        final mixSource = mixProp.sources.whereType<MixSource<Shadow>>().firstOrNull;
        expect(mixSource, isNull); // Cannot provide value for tokens without context
      });

      test('stores token correctly', () {
        final token = MixToken<BoxShadow>('shadow.box');
        final mixProp = Prop.token(token);

        expect(mixProp.sources, hasLength(1));
        final source = mixProp.sources.first as TokenSource<BoxShadow>;
        expect(source.token, equals(token));
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

        final mixProp = Prop.token(token);

        final context = MockBuildContext(
          tokens: {token.defineValue(shadowValue)},
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

        final mixProp = Prop.token(token);

        final context = MockBuildContext(
          tokens: {token.defineValue(boxShadowValue)},
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

        final mixProp = Prop.token(token);

        final context = MockBuildContext(
          tokens: {token.defineValue(textStyleValue)},
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

        final tokenProp = Prop.token(token);
        final valueProp = Prop.mix(directShadow);

        final merged = tokenProp.mergeProp(valueProp);

        // Both sources should be accumulated and resolved during resolution
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<TokenSource<Shadow>>());
        expect(merged.sources[1], isA<MixSource<Shadow>>());

        // Test resolution with token context
        final context = MockBuildContext(
          tokens: {token.defineValue(shadowValue)},
        );

        final resolved = merged.resolveProp(context);
        // The resolved value should be the merged result of token + direct value
        expect(resolved, isA<Shadow>());
      });

      test('value source + token source (accumulation strategy)', () {
        final token = MixToken<Shadow>('shadow.primary');
        final directShadow = ShadowMix(color: Colors.red, blurRadius: 2.0);

        final valueProp = Prop.mix(directShadow);
        final tokenProp = Prop.token(token);

        final merged = valueProp.mergeProp(tokenProp);

        // Both sources should be accumulated
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<MixSource<Shadow>>());
        expect(merged.sources[1], isA<TokenSource<Shadow>>());
      });

      test('token source + token source (accumulation strategy)', () {
        final token1 = MixToken<Shadow>('shadow.primary');
        final token2 = MixToken<Shadow>('shadow.secondary');

        final prop1 = Prop.token(token1);
        final prop2 = Prop.token(token2);

        final merged = prop1.mergeProp(prop2);

        // Both token sources should be accumulated
        expect(merged.sources, hasLength(2));
        expect(merged.sources[0], isA<TokenSource<Shadow>>());
        expect(merged.sources[1], isA<TokenSource<Shadow>>());
        final source1 = merged.sources[0] as TokenSource<Shadow>;
        final source2 = merged.sources[1] as TokenSource<Shadow>;
        expect(source1.token, equals(token1));
        expect(source2.token, equals(token2));
      });

      test('preserves directives and animation during merge', () {
        final token = MixToken<Shadow>('shadow.primary');
        final directive = MockDirective<Shadow>('test');
        final animation = AnimationConfig.curve(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        final prop1 = Prop<Shadow>.token(token);
        final prop2 = Prop<Shadow>.directives([directive]);
        final prop3 = Prop<Shadow>.animation(animation);

        final merged = prop1.mergeProp(prop2).mergeProp(prop3);

        expect(merged.$directives, contains(directive));
        expect(merged.$animation, equals(animation));
      });
    });

    group('Edge cases', () {
      test('throws when resolving Prop with no sources', () {
        const p = Prop<int>.directives([]);
        expect(
          () => p.resolveProp(MockBuildContext()),
          throwsA(isA<FlutterError>()),
        );
      });
      test('throws error when resolving without context token', () {
        final token = MixToken<Shadow>('shadow.missing');
        final mixProp = Prop.token(token);

        final context = MockBuildContext(); // No tokens defined

        expect(() => mixProp.resolveProp(context), throwsA(isA<StateError>()));
      });

      test('handles null merge correctly', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = Prop.token(token);

        final merged = mixProp.mergeProp(null);

        expect(merged, equals(mixProp));
      });

      test('equality works correctly for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final prop1 = Prop.token(token);
        final prop2 = Prop.token(token);

        expect(prop1, equals(prop2));
      });

      test('hashCode works correctly for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final prop1 = Prop.token(token);
        final prop2 = Prop.token(token);

        expect(prop1.hashCode, equals(prop2.hashCode));
      });
    });

    group('Backward compatibility', () {
      test('value getter returns null for token sources', () {
        final token = MixToken<Shadow>('shadow.primary');
        final mixProp = Prop.token(token);

        // TokenSource doesn't provide direct Mix value
        final mixSource = mixProp.sources.whereType<MixSource<Shadow>>().firstOrNull;
        expect(mixSource, isNull);
      });

      test('Mix source resolves correctly', () {
        final shadowMix = ShadowMix(color: Colors.red, blurRadius: 2.0);
        final mixProp = Prop.mix(shadowMix);

        expect(mixProp, resolvesTo(const Shadow(color: Colors.red, blurRadius: 2.0)));
      });
    });
  });
}
