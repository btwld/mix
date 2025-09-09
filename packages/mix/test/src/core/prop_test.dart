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
      final token = MixToken<Color>('primary');
      final prop = Prop.token(token);

      expect(prop, isNot(PropMatcher.hasValues));
      expect(prop, PropMatcher.hasTokens);
      expect(prop, PropMatcher.isToken(token));
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
      final token = MixToken<int>('n');
      final p1 = Prop.value(1);
      final p2 = Prop.token(token);

      final merged = p1.mergeProp(p2);

      // With universal accumulation, both sources are preserved
      expect(merged, PropMatcher.hasValues);
      expect(merged, PropMatcher.hasTokens);
      expect(merged, PropMatcher.isToken(token));

      // But during resolution, token takes precedence
      final context = MockBuildContext(tokens: {TokenDefinition(token, 42)});
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
