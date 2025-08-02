import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpecUtility', () {
    late IconSpecUtility util;

    setUp(() {
      util = IconSpecUtility();
    });

    group('Constructor', () {
      test('creates with default IconMix when no attribute provided', () {
        final utility = IconSpecUtility();
        expect(utility, isA<IconSpecUtility>());
      });

      test('creates with provided IconMix attribute', () {
        final iconMix = IconMix(size: 24.0);
        final utility = IconSpecUtility(iconMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<IconSpecUtility>());
        expect(spec.size, 24.0);
      });
    });

    group('Icon utility properties', () {
      test('color utility is ColorUtility', () {
        expect(util.color, isA<ColorUtility<IconMix>>());
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
        expect(util.shadow, isA<ShadowUtility<IconMix>>());
      });

      test('textDirection utility is MixUtility', () {
        expect(util.textDirection, isA<MixUtility<IconMix, TextDirection>>());
      });

      test('applyTextScaling is now a method', () {
        expect(util.applyTextScaling, isA<Function>());
      });

      test('fill is now a method', () {
        expect(util.fill, isA<Function>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<IconSpec, IconMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<WidgetDecoratorUtility<IconMix>>());
      });
    });

    group('Icon property utilities', () {
      test('size utility creates correct IconMix', () {
        final result = util.size(24.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.size, 24.0);
      });

      test('weight utility creates correct IconMix', () {
        final result = util.weight(400.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.weight, 400.0);
      });

      test('grade utility creates correct IconMix', () {
        final result = util.grade(0.5);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.grade, 0.5);
      });

      test('opticalSize utility creates correct IconMix', () {
        final result = util.opticalSize(48.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.opticalSize, 48.0);
      });

      test('textDirection utility creates correct IconMix', () {
        final result = util.textDirection(TextDirection.rtl);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.textDirection, TextDirection.rtl);
      });

      test('applyTextScaling utility creates correct IconMix', () {
        final result = util.applyTextScaling(false);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.applyTextScaling, false);
      });

      test('fill utility creates correct IconMix', () {
        final result = util.fill(0.8);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<IconMix>());
        expect(spec.fill, 0.8);
      });
    });

    group('Color utilities', () {
      test('color utility creates correct IconMix', () {
        final result = util.color.red();
        expect(result, isA<IconMix>());
      });

      test('color utility with specific color', () {
        final result = util.color(Colors.blue);
        expect(result, isA<IconMix>());
      });
    });

    group('Shadow utilities', () {
      test('shadow utility creates correct IconMix', () {
        final result = util.shadow(
          color: Colors.black,
          offset: const Offset(2, 2),
          blurRadius: 4.0,
        );
        expect(result, isA<IconMix>());
      });

      test('shadows method creates correct IconMix', () {
        final shadows = [
          ShadowMix(color: Colors.black, blurRadius: 2.0),
          ShadowMix(color: Colors.grey, blurRadius: 4.0),
        ];
        final result = util.shadows(shadows);
        expect(result, isA<IconMix>());
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
      test('wrap utility creates modifier IconMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<IconMix>());
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$decorators!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with IconSpecUtility creates new instance', () {
        final other = IconSpecUtility(IconMix(size: 32.0));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<IconSpecUtility>());
        expect(spec.size, 32.0);
      });

      test('merge with IconMix creates new instance', () {
        final otherMix = IconMix(weight: 600.0);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<IconSpecUtility>());
        expect(spec.weight, 600.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<IconSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = IconSpecUtility(IconMix(size: 24.0, weight: 400.0));
        final other = IconSpecUtility(IconMix(weight: 600.0, fill: 0.8));

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 600.0); // other takes precedence
        expect(spec.fill, 0.8);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns IconSpec with resolved properties', () {
        final testUtil = IconSpecUtility(
          IconMix(size: 24.0, weight: 400.0, fill: 0.8),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<IconSpec>());
        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<IconSpec>());
        expect(spec.size, isNull);
        expect(spec.weight, isNull);
        expect(spec.fill, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic size mutation test', () {
        final util = IconSpecUtility();

        final result = util.size(24.0);
        expect(result, isA<IconMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, 24.0);
      });

      test('basic weight mutation test', () {
        final util = IconSpecUtility();

        final result = util.weight(400.0);
        expect(result, isA<IconMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.weight, 400.0);
      });

      test('chaining utility methods accumulates properties', () {
        final util = IconSpecUtility();

        // Chain multiple method calls - these mutate internal state
        util.size(24.0);
        util.weight(400.0);
        util.fill(0.8);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });

      test('cascade notation works with utility methods', () {
        final util = IconSpecUtility()
          ..size(24.0)
          ..weight(400.0)
          ..fill(0.8);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });

      test('individual utility calls return IconMix for further chaining', () {
        final util = IconSpecUtility();

        // Each utility call should return an IconMix
        final sizeResult = util.size(24.0);
        final weightResult = util.weight(400.0);
        final fillResult = util.fill(0.8);

        expect(sizeResult, isA<IconMix>());
        expect(weightResult, isA<IconMix>());
        expect(fillResult, isA<IconMix>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = IconSpecUtility();

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
        final util = IconSpecUtility();

        util.size(24.0);
        util.weight(400.0);
        util.fill(0.8);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = IconSpecUtility();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.size(24.0);
        final result2 = util.weight(400.0);

        // Both results are different IconMix instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct IconSpec', () {
        final testUtil = IconSpecUtility(
          IconMix(size: 24.0, weight: 400.0, fill: 0.8),
        );

        expect(
          testUtil,
          resolvesTo(const IconSpec(size: 24.0, weight: 400.0, fill: 0.8)),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const sizeToken = MixToken<double>('iconSize');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {sizeToken: 32.0}),
        );

        final testUtil = IconSpecUtility(
          IconMix.raw(size: Prop.token(sizeToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.size, 32.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final sizeResult = util.size(24.0);
        final weightResult = util.weight(400.0);
        final fillResult = util.fill(0.8);

        expect(sizeResult, isA<IconMix>());
        expect(weightResult, isA<IconMix>());
        expect(fillResult, isA<IconMix>());
      });

      test('handles multiple merges correctly', () {
        final util1 = IconSpecUtility(IconMix(size: 24.0));
        final util2 = IconSpecUtility(IconMix(weight: 400.0));
        final util3 = IconSpecUtility(IconMix(fill: 0.8));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = IconSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.size, isNull);
        expect(spec.weight, isNull);
        expect(spec.fill, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = IconSpecUtility(IconMix(size: 24.0));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.size, 24.0);
      });
    });
  });
}
