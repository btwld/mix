import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Prop', () {
    test('value constructor stores direct value', () {
      final prop = Prop.value(42);

      expect(prop, PropMatcher.hasValues);
      expect(prop, isNot(PropMatcher.hasTokens));
      expect(prop, resolvesTo(42));
    });

    test('token constructor stores token reference', () {
      final token = TestToken<Color>('primary');
      final prop = Prop.token(token);

      expect(prop, isNot(PropMatcher.hasValues));
      expect(prop, PropMatcher.hasTokens);
      expect(prop, PropMatcher.isToken(token));
    });

    group('Prop.tokenWith', () {
      test('creates Prop with mapped token source', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color, Color>(
          token,
          (color) => color.withRed(12),
        );

        expect(prop, PropMatcher.hasTokens);
        expect(prop, PropMatcher.isMappedToken<Color>(token));
      });

      test('hasToken returns true', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color, Color>(token, (color) => color);

        expect(prop.hasToken, isTrue);
      });

      test('resolves mapped token from context', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color, Color>(token, (color) => color);

        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(prop.resolveProp(context), equals(Colors.red));
      });

      test('applies directives after mapped token resolution', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<TextStyle, Color>(
          token,
          (color) => TextStyle(color: color),
          directives: [
            MockDirective<TextStyle>(
              'force-black',
              (value) => value.copyWith(color: Colors.black),
            ),
          ],
        );

        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(prop.resolveProp(context).color, equals(Colors.black));
      });

      test('resolver returning Mix<V> participates in mix accumulation', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<TextStyle, Color>(
          token,
          (color) => TextStyleMix(color: color),
        );
        final base = Prop.value<TextStyle>(const TextStyle(fontSize: 20));
        MixConverterRegistry.instance.register(TextStyleConverter());

        final merged = prop.mergeProp(base);
        final context = MockBuildContext(tokens: {token: Colors.red});

        final resolved = merged.resolveProp(context);
        expect(resolved.color, equals(Colors.red));
        expect(resolved.fontSize, 20);
      });

      test('resolver returning plain V uses replacement strategy', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<TextStyle, Color>(
          token,
          (color) => TextStyle(color: color),
        );
        final base = Prop.value<TextStyle>(const TextStyle(fontSize: 20));

        final merged = prop.mergeProp(base);
        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(merged.resolveProp(context).fontSize, 20);
        expect(merged.resolveProp(context).color, isNull);
      });

      test('throws when resolver returns unsupported type', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color, Color>(
          token,
          (color) => color.value,
        );

        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(() => prop.resolveProp(context), throwsA(isA<ArgumentError>()));
      });

      test('nullable resolver can return null for nullable V', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color?, Color>(token, (color) => null);

        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(prop.resolveProp(context), isNull);
      });

      test('non-nullable resolver cannot return null', () {
        final token = TestToken<Color>('primary');
        final prop = Prop.tokenWith<Color, Color>(token, (color) => null);

        final context = MockBuildContext(tokens: {token: Colors.red});

        expect(() => prop.resolveProp(context), throwsA(isA<ArgumentError>()));
      });

      test('merge order: tokenWith + value keeps value', () {
        final token = TestToken<Color>('primary');
        final tokenProp = Prop.tokenWith<TextStyle, Color>(
          token,
          (color) => TextStyle(color: color),
        );
        final valueProp = Prop.value<TextStyle>(const TextStyle(fontSize: 20));

        final merged = tokenProp.mergeProp(valueProp);
        final context = MockBuildContext(tokens: {token: Colors.red});
        final resolved = merged.resolveProp(context);

        expect(resolved.fontSize, 20);
        expect(resolved.color, isNull);
      });

      test('merge order: value + tokenWith keeps token', () {
        final token = TestToken<Color>('primary');
        final valueProp = Prop.value<TextStyle>(const TextStyle(fontSize: 20));
        final tokenProp = Prop.tokenWith<TextStyle, Color>(
          token,
          (color) => TextStyle(color: color),
        );

        final merged = valueProp.mergeProp(tokenProp);
        final context = MockBuildContext(tokens: {token: Colors.red});
        final resolved = merged.resolveProp(context);

        expect(resolved.fontSize, isNull);
        expect(resolved.color, equals(Colors.red));
      });

      test('same token with different resolvers are equal', () {
        final token = TestToken<Color>('primary');
        final mapped1 = Prop.tokenWith<Color, Color>(token, (_) => Colors.red);
        final mapped2 = Prop.tokenWith<Color, Color>(token, (_) => Colors.blue);

        expect(mapped1, equals(mapped2));
      });

      test('resolves according to source order with same token', () {
        final token = TestToken<Color>('primary');
        final red = Prop.tokenWith<Color, Color>(
          token,
          (_) => const Color(0xFFFF0000),
        );
        final blue = Prop.tokenWith<Color, Color>(
          token,
          (_) => const Color(0xFF0000FF),
        );

        final redThenBlue = red.mergeProp(blue);
        final blueThenRed = blue.mergeProp(red);
        final context = MockBuildContext(tokens: {token: Colors.black});

        expect(
          redThenBlue.resolveProp(context),
          equals(const Color(0xFF0000FF)),
        );
        expect(
          blueThenRed.resolveProp(context),
          equals(const Color(0xFFFF0000)),
        );
      });

      test('missing token throws consistent error', () {
        final token = TestToken<Color>('missing');
        final prop = Prop.tokenWith<Color, Color>(token, (color) => color);

        expect(
          () => prop.resolveProp(MockBuildContext()),
          throwsA(isA<StateError>()),
        );
      });
    });

    test('merge replaces source with other source', () {
      final prop1 = Prop.value(10);
      final prop2 = Prop.value(20);

      final merged = prop1.mergeProp(prop2);

      expect(merged, PropMatcher.hasValues);
      expect(merged, resolvesTo(20));
    });

    test('resolves direct values', () {
      final prop = Prop.value(42);
      final context = MockBuildContext();

      final resolved = prop.resolveProp(context);

      expect(resolved, equals(42));
    });

    test('merges value and token sources (universal accumulation)', () {
      final token = TestToken<int>('n');
      final p1 = Prop.value(1);
      final p2 = Prop.token(token);

      final merged = p1.mergeProp(p2);

      // With universal accumulation, both sources are preserved
      expect(merged, PropMatcher.hasValues);
      expect(merged, PropMatcher.hasTokens);
      expect(merged, PropMatcher.isToken(token));

      // But during resolution, token takes precedence
      final context = MockBuildContext(tokens: {token: 42});
      expect(merged, resolvesTo(42, context: context));
    });

    test('merges directives', () {
      // Intentionally pass an empty directives list to 'a' and verify it is preserved
      final a = Prop.value(1).directives(<Directive<int>>[]);
      final b = Prop.value(2);

      final merged = a.mergeProp(b);

      expect(merged.$directives, a.$directives); // preserved from a
    });

    test('throws when resolving without value or token', () {
      final p = const Prop<int>.directives([]);
      expect(
        () => p.resolveProp(MockBuildContext()),
        throwsA(isA<FlutterError>()),
      );
    });
  });

  group('Prop with Mix values', () {
    test('value constructor stores Mix value', () {
      final mixValue = MockMix<int>(42);
      final prop = Prop.mix(mixValue);

      expect(prop, resolvesTo(42));
    });

    test('merge combines Mix values', () {
      final mix1 = MockMix<int>(10, merger: (a, b) => a + b);
      final mix2 = MockMix<int>(20, merger: (a, b) => a + b);

      final prop1 = Prop.mix(mix1);
      final prop2 = Prop.mix(mix2);

      final merged = prop1.mergeProp(prop2);

      expect(merged, resolvesTo(30));
    });

    test('resolves Mix values', () {
      final mixValue = MockMix<int>(42);
      final prop = Prop.mix(mixValue);
      final context = MockBuildContext();

      final resolved = prop.resolveProp(context);

      expect(resolved, equals(42));
    });
  });

  group('Prop no auto-conversion behavior', () {
    test('Prop.value does NOT auto-convert to Mix', () {
      // Register converter
      MixConverterRegistry.instance.register(TextStyleConverter());

      // Create prop with regular value
      final prop = Prop.value(const TextStyle(fontSize: 16));

      // Should be ValueSource, NOT MixSource
      expect(prop, PropMatcher.hasValues);
      expect(prop, isNot(PropMatcher.hasMixes));
    });

    test('Prop.mix creates MixSource', () {
      final mix = TextStyleMix(fontSize: 16);
      final prop = Prop.mix(mix);

      expect(prop, PropMatcher.hasMixes);
    });

    test('Conversion happens during resolution with Mix values', () {
      // Register converter
      MixConverterRegistry.instance.register(TextStyleConverter());

      final prop1 = Prop.value(const TextStyle(fontSize: 16));
      final prop2 = Prop.mix(TextStyleMix(color: Colors.red));
      final merged = prop1.mergeProp(prop2);

      // Sources are not converted yet
      expect(merged, PropMatcher.hasValues);
      expect(merged, PropMatcher.hasMixes);

      // Conversion happens during resolution
      final context = MockBuildContext();
      final resolved = merged.resolveProp(context);
      expect(resolved.fontSize, 16);
      expect(resolved.color, Colors.red);
    });

    test('No Mix values means no conversion', () {
      final prop1 = Prop.value(Colors.red);
      final prop2 = Prop.value(Colors.blue);
      final merged = prop1.mergeProp(prop2);

      // No converter should be called
      final context = MockBuildContext();
      final resolved = merged.resolveProp(context);
      expect(resolved, Colors.blue); // Last value wins
    });

    test('Mixed regular and Mix values are properly converted and merged', () {
      // Register converter
      MixConverterRegistry.instance.register(EdgeInsetsConverter());

      // Create props with mixed types - simpler test case
      final prop1 = Prop.value(const EdgeInsets.all(8.0));
      final prop2 = Prop.mix(EdgeInsetsMix(left: 16.0, top: 20.0));

      // Merge props
      final merged = prop1.mergeProp(prop2);

      // Resolution should convert regular values and merge with Mix
      final context = MockBuildContext();
      final resolved = merged.resolveProp(context);

      // The Mix values should take precedence where specified
      // prop1 converted: all sides = 8.0
      // prop2 Mix: left = 16.0, top = 20.0
      // Merged result takes Mix values where specified
      expect(resolved.left, 16.0); // from Mix
      expect(resolved.top, 20.0); // from Mix
      expect(resolved.right, 8.0); // from converted prop1
      expect(resolved.bottom, 8.0); // from converted prop1
    });
  });
}
