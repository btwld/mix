import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'testing_utils.dart';

void main() {
  group('Core Test Matchers', () {
    group('expectProp', () {
      test('matches direct values', () {
        final colorProp = Prop.value(Colors.red);
        expectProp(colorProp, Colors.red);

        final doubleProp = Prop.value(42.0);
        expectProp(doubleProp, 42.0);

        final stringProp = Prop.value('test');
        expectProp(stringProp, 'test');
      });

      test('matches Mix values', () {
        final edgeInsetsProp = MixProp(EdgeInsetsMix.all(16.0));
        expectProp(edgeInsetsProp, EdgeInsetsMix.all(16.0));

        final borderSide = BorderSideMix.create(
          color: Prop.value(Colors.red),
          width: Prop.value(2.0),
        );
        final borderProp = MixProp(BorderMix.all(borderSide));
        expectProp(borderProp, BorderMix.all(borderSide));
      });

      test('matches tokens', () {
        const colorToken = MixToken<Color>('primary');
        final colorProp = Prop.token(colorToken);
        expectProp(colorProp, colorToken);

        final spacingToken = MixToken<double>('spacing.small');
        final spacingProp = Prop.token(spacingToken);
        expectProp(spacingProp, spacingToken);
      });

      test('matches value from merged props (replacement strategy)', () {
        final prop1 = Prop.value(Colors.red);
        final prop2 = Prop.value(Colors.blue);
        final merged = prop1.mergeProp(prop2);

        // Prop uses replacement strategy - second value wins
        expectProp(merged, Colors.blue);
      });

      test('matches value from chained merges (replacement strategy)', () {
        const colorToken = MixToken<Color>('primary');
        final prop1 = Prop.value<Color>(Colors.red);
        final prop2 = Prop.token(colorToken);
        final prop3 = Prop.value<Color>(Colors.blue);

        final merged = prop1.mergeProp(prop2).mergeProp(prop3);

        // Prop uses replacement strategy - last value wins
        expectProp(merged, Colors.blue);
      });

      test('fails when prop is null', () {
        expect(
          () => expectProp<Color>(null, Colors.red),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails when expecting value but prop has token', () {
        const colorToken = MixToken<Color>('primary');
        final tokenProp = Prop.token(colorToken);

        expect(
          () => expectProp(tokenProp, Colors.red),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails when expecting token but prop has value', () {
        final valueProp = Prop.value(Colors.red);
        const colorToken = MixToken<Color>('primary');

        expect(
          () => expectProp(valueProp, colorToken),
          throwsA(isA<TestFailure>()),
        );
      });

      test('fails when expecting accumulated but prop has single value', () {
        final valueProp = Prop.value(Colors.red);

        expect(
          () => expectProp(valueProp, [Colors.red, Colors.blue]),
          throwsA(isA<TestFailure>()),
        );
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
        final attribute = OpacityWidgetDecoratorMix(opacity: 0.5);
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
        final shadow1 = MixProp(
          BoxShadowMix(color: Colors.red, blurRadius: 2.0),
        );
        final shadow2 = MixProp(
          BoxShadowMix(color: Colors.blue, spreadRadius: 4.0),
        );

        final merged = shadow1.mergeProp(shadow2);
        final resolved = merged.resolveProp(MockBuildContext());

        // MixProp types accumulate properties
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

        expect(resolved, isA<MockSpec>());
        expectProp(resolved.resolvedValue, Colors.blue);
      });

      test('merges Prop values correctly', () {
        final first = MockStyle(Prop.value<Color>(Colors.red));
        final second = MockStyle(Prop.value<Color>(Colors.blue));

        final merged = first.merge(second);

        // The merged attribute should contain a merged Prop (replacement strategy)
        expectProp(merged.value, Colors.blue);
      });
    });
  });
}
