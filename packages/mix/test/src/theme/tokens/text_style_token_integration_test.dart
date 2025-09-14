import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextStyleToken Integration Tests', () {
    setUp(() {
      clearTokenRegistry();
    });

    group('Basic Token Functionality', () {
      test('TextStyleToken can be created and called', () {
        const token = TextStyleToken('text.style.heading');
        
        // Calling the token should return a TextStyleRef
        final ref = token();
        
        expect(ref, isA<TextStyleRef>());
        expect(ref, isA<TextStyle>());
        expect(ref, PropMatcher.hasTokens);
        expect(ref, PropMatcher.isToken(token));
      });

      testWidgets('TextStyleToken resolves through MixScope', (tester) async {
        const textStyleToken = TextStyleToken('test.textStyle');
        const testStyle = TextStyle(fontSize: 18, color: Colors.blue);

        await tester.pumpWidget(
          MixScope(
            tokens: {textStyleToken: testStyle},
            child: Builder(
              builder: (context) {
                final resolvedStyle = textStyleToken.resolve(context);
                
                expect(resolvedStyle, equals(testStyle));
                expect(resolvedStyle.fontSize, equals(18));
                expect(resolvedStyle.color, equals(Colors.blue));
                
                return Container();
              },
            ),
          ),
        );
      });

      test('TextStyleToken correctly prevents direct property access', () {
        const textStyleToken = TextStyleToken('test.textStyle');
        final textStyleRef = textStyleToken();
        
        // TextStyleRef should throw error when trying to access properties directly
        expect(
          () => textStyleRef.fontSize,
          throwsA(isA<UnimplementedError>()),
          reason: 'TextStyleRef should prevent direct property access',
        );
        
        expect(
          () => textStyleRef.color,
          throwsA(isA<UnimplementedError>()),
          reason: 'TextStyleRef should prevent direct property access',
        );
      });

      test('TextStyleToken integrates with getReferenceValue', () {
        const textStyleToken = TextStyleToken('test.textStyle');
        
        final ref = getReferenceValue(textStyleToken);
        
        expect(ref, isA<TextStyle>());
        expect(ref, isA<TextStyleRef>());
        expect(ref, PropMatcher.hasTokens);
        expect(ref, PropMatcher.isToken(textStyleToken));
      });

      test('TextStyleRef implements TextStyle interface', () {
        const textStyleToken = TextStyleToken('test.style');
        final textStyleRef = textStyleToken();
        
        // Should be detectable as a token reference
        expect(isAnyTokenRef(textStyleRef), isTrue);
        
        // Should implement TextStyle
        expect(textStyleRef, isA<TextStyle>());
      });
    });

    group('mix() Method Functionality', () {
      test('TextStyleToken.mix() returns TextStyleMixRef', () {
        final token = TextStyleToken('test');
        final mixRef = token.mix();
        
        expect(mixRef, isA<TextStyleMixRef>());
        expect(mixRef, isA<TextStyleMix>());
        expect(mixRef, isA<Prop<TextStyle>>());
      });

      test('returned MixRef contains the original token', () {
        final token = TextStyleToken('test');
        final mixRef = token.mix();

        expect(mixRef, PropMatcher.isToken(token));
        expect(mixRef, PropMatcher.hasTokens);
      });

      test('both call() and mix() work on same token', () {
        final token = TextStyleToken('test');
        
        final flutterRef = token.call();
        final mixRef = token.mix();

        // Both should contain the same token but be different types
        expect(flutterRef, isA<TextStyleRef>());
        expect(flutterRef, isA<TextStyle>());
        expect(mixRef, isA<TextStyleMixRef>());
        expect(mixRef, isA<TextStyleMix>());

        // Both should have the same token source
        expect(flutterRef, PropMatcher.isToken(token));
        expect(mixRef, PropMatcher.isToken(token));
      });

      test('mix() method can be called multiple times', () {
        final token = TextStyleToken('test');
        
        final mixRef1 = token.mix();
        final mixRef2 = token.mix();

        expect(mixRef1, isA<TextStyleMixRef>());
        expect(mixRef2, isA<TextStyleMixRef>());
        expect(mixRef1, PropMatcher.isToken(token));
        expect(mixRef2, PropMatcher.isToken(token));
      });
    });

    group('Other Token Types mix() Methods', () {
      test('ShadowToken.mix() returns ShadowMixRef', () {
        final token = ShadowToken('test-shadow');
        final mixRef = token.mix();

        expect(mixRef, isA<ShadowMixRef>());
        expect(mixRef, isA<ShadowMix>());
        expect(mixRef, isA<Prop<Shadow>>());
        expect(mixRef, PropMatcher.isToken(token));
      });

      test('BoxShadowToken.mix() returns BoxShadowMixRef', () {
        final token = BoxShadowToken('test-boxshadow');
        final mixRef = token.mix();

        expect(mixRef, isA<BoxShadowMixRef>());
        expect(mixRef, isA<BoxShadowMix>());
        expect(mixRef, isA<Prop<BoxShadow>>());
        expect(mixRef, PropMatcher.isToken(token));
      });

      test('ShadowListToken.mix() returns ShadowListMixRef', () {
        final token = ShadowListToken('test-shadows');
        final mixRef = token.mix();

        expect(mixRef, isA<ShadowListMixRef>());
        expect(mixRef, isA<ShadowListMix>());
        expect(mixRef, isA<Prop<List<Shadow>>>());
        expect(mixRef, PropMatcher.isToken(token));
      });

      test('BoxShadowListToken.mix() returns BoxShadowListMixRef', () {
        final token = BoxShadowListToken('test-boxshadows');
        final mixRef = token.mix();

        expect(mixRef, isA<BoxShadowListMixRef>());
        expect(mixRef, isA<BoxShadowListMix>());
        expect(mixRef, isA<Prop<List<BoxShadow>>>());
        expect(mixRef, PropMatcher.isToken(token));
      });
    });

    group('MixRef Classes', () {
      test('TextStyleMixRef can be created with a token prop', () {
        final token = TextStyleToken('test-style');
        final mixRef = TextStyleMixRef(Prop.token(token));

        expect(mixRef, isA<TextStyleMixRef>());
        expect(mixRef, isA<Prop<TextStyle>>());
        expect(mixRef, isA<TextStyleMix>());
        expect(mixRef, PropMatcher.isToken(token));
        expect(mixRef, PropMatcher.hasTokens);
      });

      test('TextStyleMixRef throws UnimplementedError when accessing methods directly', () {
        final token = TextStyleToken('test-style');
        final mixRef = TextStyleMixRef(Prop.token(token));

        expect(
          () => mixRef.color(Colors.red),
          throwsA(isA<UnimplementedError>()),
        );

        expect(
          () => mixRef.fontSize(16),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('TextStyleMixRef toString works correctly', () {
        final token = TextStyleToken('test-style');
        final mixRef = TextStyleMixRef(Prop.token(token));

        expect(mixRef.toString(), isA<String>());
        expect(mixRef.toString().length, greaterThan(0));
      });

      test('TextStyleMixRef is detected as token reference', () {
        final token = TextStyleToken('test-style');
        final mixRef = TextStyleMixRef(Prop.token(token));

        expect(isAnyTokenRef(mixRef), isTrue);
      });

      test('ShadowMixRef can be created and behaves correctly', () {
        final token = ShadowToken('test-shadow');
        final mixRef = ShadowMixRef(Prop.token(token));

        expect(mixRef, isA<ShadowMixRef>());
        expect(mixRef, isA<Prop<Shadow>>());
        expect(mixRef, isA<ShadowMix>());
        expect(mixRef, PropMatcher.isToken(token));
        
        expect(
          () => mixRef.color(Colors.red),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('BoxShadowMixRef can be created and behaves correctly', () {
        final token = BoxShadowToken('test-boxshadow');
        final mixRef = BoxShadowMixRef(Prop.token(token));

        expect(mixRef, isA<BoxShadowMixRef>());
        expect(mixRef, isA<Prop<BoxShadow>>());
        expect(mixRef, isA<BoxShadowMix>());
        expect(mixRef, PropMatcher.isToken(token));
        
        expect(
          () => mixRef.spreadRadius(2.0),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('Token Registry Integration', () {
      test('token registry works correctly for all mix() refs', () {
        final textToken = TextStyleToken('test-style');
        final shadowToken = ShadowToken('test-shadow');
        final boxShadowToken = BoxShadowToken('test-boxshadow');

        final textMixRef = textToken.mix();
        final shadowMixRef = shadowToken.mix();
        final boxShadowMixRef = boxShadowToken.mix();

        // All should be detected as token references
        expect(isAnyTokenRef(textMixRef), isTrue);
        expect(isAnyTokenRef(shadowMixRef), isTrue);
        expect(isAnyTokenRef(boxShadowMixRef), isTrue);
      });

      test('mix() and call() refs are both detected as token references', () {
        final token = TextStyleToken('test-style');
        
        final flutterRef = token.call();
        final mixRef = token.mix();

        expect(isAnyTokenRef(flutterRef), isTrue);
        expect(isAnyTokenRef(mixRef), isTrue);
      });
    });

    group('Backward Compatibility', () {
      test('existing token.call() usage continues to work', () {
        final token = TextStyleToken('test-style');
        
        // This existing pattern should still work
        final flutterRef = token.call();
        // Alternative syntax should also still work  
        final flutterRef2 = token();

        expect(flutterRef, isA<TextStyleRef>());
        expect(flutterRef, isA<TextStyle>());
        expect(flutterRef, PropMatcher.isToken(token));

        expect(flutterRef2, isA<TextStyleRef>());
        expect(flutterRef2, isA<TextStyle>());
        expect(flutterRef2, PropMatcher.isToken(token));
      });

      test('existing shadow token usage still works', () {
        final shadowToken = ShadowToken('test-shadow');
        final boxShadowToken = BoxShadowToken('test-boxshadow');
        
        final shadowRef = shadowToken.call();
        final boxShadowRef = boxShadowToken.call();

        expect(shadowRef, isA<ShadowRef>());
        expect(shadowRef, isA<Shadow>());
        expect(boxShadowRef, isA<BoxShadowRef>());
        expect(boxShadowRef, isA<BoxShadow>());
      });

      test('can use both token.call() and token.mix() in same code', () {
        final textToken = TextStyleToken('test-style');
        
        // Flutter usage
        final flutterRef = textToken.call();
        
        // Mix usage (NEW!)
        final mixRef = textToken.mix();
        
        // Both should work correctly
        expect(flutterRef, isA<TextStyle>());
        expect(mixRef, isA<TextStyleMix>());
        expect(flutterRef, PropMatcher.isToken(textToken));
        expect(mixRef, PropMatcher.isToken(textToken));
      });

      testWidgets('both call() and mix() refs resolve through MixScope', (tester) async {
        final token = TextStyleToken('theme-style');
        const expectedStyle = TextStyle(fontSize: 20, color: Colors.green);
        
        await tester.pumpWidget(
          MixScope(
            tokens: {token: expectedStyle},
            child: Builder(
              builder: (context) {
                final flutterRef = token.call();
                final mixRef = token.mix();
                
                // Both should resolve to the same style through context
                expect(flutterRef.resolveProp(context), equals(expectedStyle));
                expect(mixRef.resolveProp(context), equals(expectedStyle));
                
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Error Handling', () {
      test('direct access to MixRef methods throws appropriate errors', () {
        final token = TextStyleToken('error-test');
        final mixRef = token.mix();
        
        expect(
          () => mixRef.color(Colors.red),
          throwsA(isA<UnimplementedError>()),
        );
        
        expect(
          () => mixRef.fontSize(16),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('error messages are helpful for token reference misuse', () {
        final token = TextStyleToken('error-test');
        final mixRef = token.mix();
        
        try {
          mixRef.color(Colors.red);
          fail('Expected UnimplementedError');
        } catch (e) {
          expect(e, isA<UnimplementedError>());
          expect(e.toString(), contains('TextStyle'));
          expect(e.toString(), contains('token reference'));
          expect(e.toString(), contains('context'));
        }
      });
    });

    group('Type Safety', () {
      test('compile-time type safety for all token types', () {
        final textToken = TextStyleToken('text');
        final shadowToken = ShadowToken('shadow');
        final boxShadowToken = BoxShadowToken('boxshadow');
        final shadowListToken = ShadowListToken('shadows');
        final boxShadowListToken = BoxShadowListToken('boxshadows');
        
        // These assignments should all compile correctly
        TextStyleRef textRef = textToken.call();
        TextStyleMixRef textMixRef = textToken.mix();
        
        ShadowRef shadowRef = shadowToken.call();
        ShadowMixRef shadowMixRef = shadowToken.mix();
        
        BoxShadowRef boxShadowRef = boxShadowToken.call();
        BoxShadowMixRef boxShadowMixRef = boxShadowToken.mix();
        
        ShadowListRef shadowListRef = shadowListToken.call();
        ShadowListMixRef shadowListMixRef = shadowListToken.mix();
        
        BoxShadowListRef boxShadowListRef = boxShadowListToken.call();
        BoxShadowListMixRef boxShadowListMixRef = boxShadowListToken.mix();
        
        // Runtime verification
        expect(textRef, isA<TextStyle>());
        expect(textMixRef, isA<TextStyleMix>());
        expect(shadowRef, isA<Shadow>());
        expect(shadowMixRef, isA<ShadowMix>());
        expect(boxShadowRef, isA<BoxShadow>());
        expect(boxShadowMixRef, isA<BoxShadowMix>());
        expect(shadowListRef, isA<List<Shadow>>());
        expect(shadowListMixRef, isA<ShadowListMix>());
        expect(boxShadowListRef, isA<List<BoxShadow>>());
        expect(boxShadowListMixRef, isA<BoxShadowListMix>());
      });

      test('mix() vs call() return different but compatible types', () {
        final token = TextStyleToken('test-style');

        final flutterRef = token.call(); // Returns TextStyleRef
        final mixRef = token.mix();       // Returns TextStyleMixRef

        // Different concrete types
        expect(flutterRef.runtimeType, isNot(mixRef.runtimeType));
        expect(flutterRef, isA<TextStyleRef>());
        expect(mixRef, isA<TextStyleMixRef>());

        // But both are Prop<TextStyle> and have token source
        expect(flutterRef, isA<Prop<TextStyle>>());
        expect(mixRef, isA<Prop<TextStyle>>());
        expect(flutterRef, PropMatcher.isToken(token));
        expect(mixRef, PropMatcher.isToken(token));
      });
    });

    group('Performance and Memory', () {
      test('creating multiple TextStyler with same token.mix() is efficient', () {
        final token = TextStyleToken('shared-style');
        
        final refs = List.generate(50, (i) => token.mix());
        
        for (final ref in refs) {
          expect(ref, PropMatcher.isToken(token));
          expect(isAnyTokenRef(ref), isTrue);
        }
        
        expect(refs.length, equals(50));
      });
    });
  });
}