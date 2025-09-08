import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconMutableStyler', () {
    late IconMutableStyler util;

    setUp(() {
      util = IconMutableStyler();
    });

    group('Constructor', () {
      test('', () {
        final utility = IconMutableStyler();
        expect(utility, isA<IconMutableStyler>());
      });

      test('', () {
        final iconMix = IconStyler(size: 24.0);
        final utility = IconMutableStyler(iconMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<IconMutableStyler>());
        expect(spec.spec.size, 24.0);
      });
    });

    group('Icon utility properties', () {
      test('color utility is ColorUtility', () {
        expect(util.color, isA<ColorUtility<IconStyler>>());
      });

      test('size is now a method', () {
        expect(util.size, isA<Function>());
      });

      test('weight is now a method', () {
        expect(util.weight, isA<Function>());
      });

      test('grade is now a method', () {
        expect(util.grade, isA<Function>());
      });

      test('opticalSize is now a method', () {
        expect(util.opticalSize, isA<Function>());
      });

      test('shadow utility is ShadowUtility', () {
        expect(util.shadow, isA<ShadowUtility<IconStyler>>());
      });

      test('textDirection utility is MixUtility', () {
        expect(
          util.textDirection,
          isA<MixUtility<IconStyler, TextDirection>>(),
        );
      });

      test('applyTextScaling is now a method', () {
        expect(util.applyTextScaling, isA<Function>());
      });

      test('fill is now a method', () {
        expect(util.fill, isA<Function>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<IconSpec, IconStyler>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<IconStyler>>());
      });
    });

    group('Icon property utilities', () {
      test('', () {
        final result = util.size(24.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.size, 24.0);
      });

      test('', () {
        final result = util.weight(400.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.weight, 400.0);
      });

      test('', () {
        final result = util.grade(0.5);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.grade, 0.5);
      });

      test('', () {
        final result = util.opticalSize(48.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.opticalSize, 48.0);
      });

      test('', () {
        final result = util.textDirection(TextDirection.rtl);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.textDirection, TextDirection.rtl);
      });

      test('', () {
        final result = util.applyTextScaling(false);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.applyTextScaling, false);
      });

      test('', () {
        final result = util.fill(0.8);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconStyler>());
        expect(spec.spec.fill, 0.8);
      });
    });

    group('Color utilities', () {
      test('', () {
        final result = util.color.red();
        expect(result, isA<IconStyler>());
      });

      test('color utility with specific color', () {
        final result = util.color(Colors.blue);
        expect(result, isA<IconStyler>());
      });
    });

    group('Shadow utilities', () {
      test('', () {
        final result = util.shadow(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );
        expect(result, isA<IconStyler>());
      });

      test('', () {
        final shadows = [
          ShadowMix(color: Colors.black, blurRadius: 2.0),
          ShadowMix(color: Colors.grey, blurRadius: 4.0),
        ];
        final result = util.shadows(shadows);
        expect(result, isA<IconStyler>());
      });
    });

    group('Animation', () {
      test('animate() adds animation config', () {
        final animationConfig = AnimationConfig.linear(
          const Duration(seconds: 1),
        );
        final result = util.animate(animationConfig);

        expect(result.$animation, animationConfig);
      });
    });

    group('Variant utilities', () {
      test('on utility creates VariantAttributeBuilder', () {
        final hoverBuilder = util.on.hover;

        expect(hoverBuilder, isA<VariantAttributeBuilder<IconSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<IconStyler>());
        expect(result.$widgetModifier, isNotNull);
        expect(result.$widgetModifier!.$widgetModifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('', () {
        final other = IconMutableStyler(IconStyler(size: 32.0));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<IconMutableStyler>());
        expect(spec.spec.size, 32.0);
      });

      test('', () {
        final otherMix = IconStyler(weight: 600.0);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<IconMutableStyler>());
        expect(spec.spec.weight, 600.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<IconSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = IconMutableStyler(IconStyler(size: 24.0, weight: 400.0));
        final other = IconMutableStyler(IconStyler(weight: 600.0, fill: 0.8));

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 600.0); // other takes precedence
        expect(spec.spec.fill, 0.8);
      });
    });

    group('Resolve functionality', () {
      test('', () {
        final testUtil = IconMutableStyler(
          IconStyler(size: 24.0, weight: 400.0, fill: 0.8),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StyleSpec<IconSpec>>());
        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StyleSpec<IconSpec>>());
        expect(spec.spec.size, isNull);
        expect(spec.spec.weight, isNull);
        expect(spec.spec.fill, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic size mutation test', () {
        final util = IconMutableStyler();

        final result = util.size(24.0);
        expect(result, isA<IconStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.size, 24.0);
      });

      test('basic weight mutation test', () {
        final util = IconMutableStyler();

        final result = util.weight(400.0);
        expect(result, isA<IconStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.weight, 400.0);
      });

      test('chaining utility methods accumulates properties', () {
        final util = IconMutableStyler();

        // Chain multiple method calls - these mutate internal state
        util.size(24.0);
        util.weight(400.0);
        util.fill(0.8);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });

      test('cascade notation works with utility methods', () {
        final util = IconMutableStyler()
          ..size(24.0)
          ..weight(400.0)
          ..fill(0.8);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });

      test('', () {
        final util = IconMutableStyler();

        // Each utility call should return an IconStyle
        final sizeResult = util.size(24.0);
        final weightResult = util.weight(400.0);
        final fillResult = util.fill(0.8);

        expect(sizeResult, isA<IconStyler>());
        expect(weightResult, isA<IconStyler>());
        expect(fillResult, isA<IconStyler>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = IconMutableStyler();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.size, isNull);

        // Mutate the utility
        util.size(24.0);

        // Same utility instance should now resolve with the size
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.size, 24.0);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = IconMutableStyler();

        util.size(24.0);
        util.weight(400.0);
        util.fill(0.8);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = IconMutableStyler();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.size(24.0);
        final result2 = util.weight(400.0);

        // Both results are different IconStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('', () {
        final testUtil = IconMutableStyler(
          IconStyler(size: 24.0, weight: 400.0, fill: 0.8),
        );

        expect(
          testUtil,
          resolvesTo(
            StyleSpec(
              spec: const IconSpec(size: 24.0, weight: 400.0, fill: 0.8),
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const sizeToken = MixToken<double>('iconSize');
        final context = MockBuildContext(tokens: {sizeToken.defineValue(32.0)});

        final testUtil = IconMutableStyler(
          IconStyler.create(size: Prop.token(sizeToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.size, 32.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final sizeResult = util.size(24.0);
        final weightResult = util.weight(400.0);
        final fillResult = util.fill(0.8);

        expect(sizeResult, isA<IconStyler>());
        expect(weightResult, isA<IconStyler>());
        expect(fillResult, isA<IconStyler>());
      });

      test('handles multiple merges correctly', () {
        final util1 = IconMutableStyler(IconStyler(size: 24.0));
        final util2 = IconMutableStyler(IconStyler(weight: 400.0));
        final util3 = IconMutableStyler(IconStyler(fill: 0.8));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.size, 24.0);
        expect(spec.spec.weight, 400.0);
        expect(spec.spec.fill, 0.8);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = IconMutableStyler();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.spec.size, isNull);
        expect(spec.spec.weight, isNull);
        expect(spec.spec.fill, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = IconMutableStyler(IconStyler(size: 24.0));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.spec.size, 24.0);
      });
    });
  });
}
