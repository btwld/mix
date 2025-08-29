import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

void main() {
  group('Core Test Matchers', () {
    group('Modern Testing Patterns', () {
      test('resolvesTo matches direct values', () {
        final colorProp = Prop.value(Colors.red);
        expect(colorProp, resolvesTo(Colors.red));

        final doubleProp = Prop.value(42.0);
        expect(doubleProp, resolvesTo(42.0));

        final stringProp = Prop.value('test');
        expect(stringProp, resolvesTo('test'));
      });

      test('resolvesTo matches resolved Mix values', () {
        final edgeInsetsProp = Prop.mix(EdgeInsetsMix.all(16.0));
        expect(edgeInsetsProp, resolvesTo(const EdgeInsets.all(16.0)));

        final borderSide = BorderSideMix.create(
          color: Prop.value(Colors.red),
          width: Prop.value(2.0),
        );
        final borderProp = Prop.mix(BorderMix.all(borderSide));
        final context = MockBuildContext();
        final resolved = borderProp.resolveProp(context);
        expect(resolved, isA<Border>());
        expect(resolved.top.color, Colors.red);
        expect(resolved.top.width, 2.0);
      });

      test('PropMatcher identifies token structure', () {
        const colorToken = MixToken<Color>('primary');
        final colorProp = Prop.token(colorToken);
        expect(colorProp, PropMatcher.isToken(colorToken));
        expect(colorProp, PropMatcher.hasTokens);

        final spacingToken = MixToken<double>('spacing.small');
        final spacingProp = Prop.token(spacingToken);
        expect(spacingProp, PropMatcher.isToken(spacingToken));
        expect(spacingProp, PropMatcher.hasTokens);
      });

      test('resolvesTo matches value from merged props (replacement strategy)', () {
        final prop1 = Prop.value(Colors.red);
        final prop2 = Prop.value(Colors.blue);
        final merged = prop1.mergeProp(prop2);

        // Prop uses replacement strategy - second value wins during resolution
        expect(merged, resolvesTo(Colors.blue));
      });

      test('merged props preserve all sources (universal accumulation)', () {
        // Test without tokens to avoid resolution issues
        final prop1 = Prop.value<Color>(Colors.red);
        final prop2 = Prop.value<Color>(Colors.green);
        final prop3 = Prop.value<Color>(Colors.blue);

        final merged = prop1.mergeProp(prop2).mergeProp(prop3);

        // Prop uses replacement strategy - last value wins during resolution
        expect(merged, resolvesTo(Colors.blue));
        
        // Test that the prop contains all sources 
        expect(merged, PropMatcher.hasValues);
      });

      test('resolvesTo fails when prop is null', () {
        expect(
          null,
          isNot(resolvesTo(Colors.red)),
        );
      });

      test('PropMatcher distinguishes between token and value', () {
        const colorToken = MixToken<Color>('primary');
        final tokenProp = Prop.token(colorToken);

        expect(tokenProp, PropMatcher.hasTokens);
        expect(tokenProp, isNot(PropMatcher.hasValues));
        expect(tokenProp, isNot(PropMatcher.isValue(Colors.red)));
      });

      test('PropMatcher distinguishes between value and token', () {
        final valueProp = Prop.value(Colors.red);
        const colorToken = MixToken<Color>('primary');

        expect(valueProp, PropMatcher.hasValues);
        expect(valueProp, isNot(PropMatcher.hasTokens));
        expect(valueProp, isNot(PropMatcher.isToken(colorToken)));
      });

      test('resolvesTo works with single values', () {
        final valueProp = Prop.value(Colors.red);

        expect(valueProp, resolvesTo(Colors.red));
        expect(valueProp, isNot(resolvesTo(Colors.blue)));
      });
    });

    group('resolvesTo', () {
      test('resolves Prop values', () {
        final colorProp = Prop.value(Colors.red);
        expect(colorProp, resolvesTo(Colors.red));

        final doubleProp = Prop.value(42.0);
        expect(doubleProp, resolvesTo(42.0));
      });

      test('resolves Mix types', () {
        final radiusMix = BorderRadiusMix.all(Radius.circular(8.0));
        expect(radiusMix, resolvesTo(BorderRadius.circular(8.0)));

        final edgeInsetsMix = EdgeInsetsMix.all(16.0);
        expect(edgeInsetsMix, resolvesTo(const EdgeInsets.all(16.0)));
      });

      test('resolves attributes', () {
        final attribute = OpacityModifierMix(opacity: 0.5);
        final resolved = attribute.resolve(MockBuildContext());

        expect(resolved.opacity, 0.5);
      });

      test('resolves tokens with custom context', () {
        const colorToken = MixToken<Color>('primary');
        final tokenProp = Prop.token(colorToken);

        final context = MockBuildContext(
          tokens: {colorToken.defineValue(const Color(0xFF2196F3))},
        );

        expect(
          tokenProp,
          resolvesTo(const Color(0xFF2196F3), context: context),
        );
      });

      test('resolves merged props', () {
        final prop1 = Prop.value(100.0);
        final prop2 = Prop.value(200.0);
        final merged = prop1.mergeProp(prop2);

        // For non-Mix types, last value wins
        expect(merged, resolvesTo(200.0));
      });

      test('resolves merged Mix props with accumulation', () {
        final shadow1 = Prop.mix(
          BoxShadowMix(color: Colors.red, blurRadius: 2.0),
        );
        final shadow2 = Prop.mix(
          BoxShadowMix(color: Colors.blue, spreadRadius: 4.0),
        );

        final merged = shadow1.mergeProp(shadow2);
        final resolved = merged.resolveProp(MockBuildContext());

        // Mix types accumulate properties
        expect(resolved.color, Colors.blue);
        expect(resolved.blurRadius, 2.0);
        expect(resolved.spreadRadius, 4.0);
      });

      test('fails when resolvable is null', () {
        expect(null, isNot(resolvesTo(Colors.red)));
      });

      test('fails when resolved value does not match expected', () {
        final prop = Prop.value(Colors.red);

        expect(prop, isNot(resolvesTo(Colors.blue)));
      });
    });
  });

  group('Test Utilities', () {
    group('MockBuildContext', () {
      test('provides basic context functionality', () {
        final context = MockBuildContext();

        expect(context.mounted, isTrue);
        expect(context.debugDoingBuild, isFalse);
        expect(context.size, const Size(800, 600));
      });

      test('provides MixScope with custom data', () {
        final context = MockBuildContext(
          tokens: {MixToken<Color>('primary').defineValue(Colors.blue)},
        );

        final mixScope = context.dependOnInheritedWidgetOfExactType<MixScope>();
        expect(mixScope, isNotNull);
      });
    });

    group('UtilityTestAttribute', () {
      test('wraps Prop values', () {
        final attr = MockStyle(Prop.value<Color>(Colors.red));
        expect(attr.value, isA<Prop<Color>>());
      });

      test('resolves to MockSpec', () {
        final attr = MockStyle(Prop.value<Color>(Colors.blue));
        final resolved = attr.resolve(MockBuildContext());

        expect(resolved, isA<WidgetSpec<MockSpec>>());
        expect(resolved.spec.resolvedValue, resolvesTo(Colors.blue));
      });

      test('merges Prop values correctly', () {
        final first = MockStyle(Prop.value<Color>(Colors.red));
        final second = MockStyle(Prop.value<Color>(Colors.blue));

        final merged = first.merge(second);

        // The merged attribute should contain a merged Prop (replacement strategy)
        expect(merged.value, resolvesTo(Colors.blue));
      });
    });
  });
}
