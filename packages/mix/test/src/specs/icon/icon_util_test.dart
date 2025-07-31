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
        expect(utility.mix, isA<IconMix>());
      });

      test('creates with provided IconMix attribute', () {
        final iconMix = IconMix(size: 24.0);
        final utility = IconSpecUtility(iconMix);

        expect(utility.mix, same(iconMix));
        expectProp(utility.mix.$size, 24.0);
      });
    });

    group('Icon utility properties', () {
      test('color utility is ColorUtility', () {
        expect(util.color, isA<ColorUtility<IconMix>>());
      });

      test('size utility is MixUtility', () {
        expect(util.size, isA<MixUtility<IconMix, double>>());
      });

      test('weight utility is MixUtility', () {
        expect(util.weight, isA<MixUtility<IconMix, double>>());
      });

      test('grade utility is MixUtility', () {
        expect(util.grade, isA<MixUtility<IconMix, double>>());
      });

      test('opticalSize utility is MixUtility', () {
        expect(util.opticalSize, isA<MixUtility<IconMix, double>>());
      });

      test('shadow utility is ShadowUtility', () {
        expect(util.shadow, isA<ShadowUtility<IconMix>>());
      });

      test('textDirection utility is MixUtility', () {
        expect(util.textDirection, isA<MixUtility<IconMix, TextDirection>>());
      });

      test('applyTextScaling utility is MixUtility', () {
        expect(util.applyTextScaling, isA<MixUtility<IconMix, bool>>());
      });

      test('fill utility is MixUtility', () {
        expect(util.fill, isA<MixUtility<IconMix, double>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<IconSpec, IconMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<IconMix>>());
      });
    });

    group('Icon property utilities', () {
      test('size utility creates correct IconMix', () {
        final result = util.size(24.0);
        expectProp(result.$size, 24.0);
      });

      test('weight utility creates correct IconMix', () {
        final result = util.weight(400.0);
        expectProp(result.$weight, 400.0);
      });

      test('grade utility creates correct IconMix', () {
        final result = util.grade(0.5);
        expectProp(result.$grade, 0.5);
      });

      test('opticalSize utility creates correct IconMix', () {
        final result = util.opticalSize(48.0);
        expectProp(result.$opticalSize, 48.0);
      });

      test('textDirection utility creates correct IconMix', () {
        final result = util.textDirection(TextDirection.rtl);
        expectProp(result.$textDirection, TextDirection.rtl);
      });

      test('applyTextScaling utility creates correct IconMix', () {
        final result = util.applyTextScaling(false);
        expectProp(result.$applyTextScaling, false);
      });

      test('fill utility creates correct IconMix', () {
        final result = util.fill(0.8);
        expectProp(result.$fill, 0.8);
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
        expect(result.$modifierConfig!.$modifiers!.length, 1);
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

        expect(result, isNot(same(util)));
        expect(result, isA<IconSpecUtility>());
        expectProp(result.mix.$size, 32.0);
      });

      test('merge with IconMix creates new instance', () {
        final otherMix = IconMix(weight: 600.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<IconSpecUtility>());
        expectProp(result.mix.$weight, 600.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<IconSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.mix = IconMix(size: 24.0, weight: 400.0);
        final other = IconSpecUtility(IconMix(weight: 600.0, fill: 0.8));

        final result = util.merge(other);

        expectProp(result.mix.$size, 24.0);
        expectProp(result.mix.$weight, 600.0); // other takes precedence
        expectProp(result.mix.$fill, 0.8);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns IconSpec with resolved properties', () {
        util.mix = IconMix(size: 24.0, weight: 400.0, fill: 0.8);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<IconSpec>());
        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.fill, 0.8);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.size, isNull);
        expect(spec.weight, isNull);
        expect(spec.fill, isNull);
      });
    });

    group('Utility method behavior', () {
      test('utilities return new IconMix instances', () {
        final result1 = util.size(24.0);
        final result2 = util.weight(400.0);
        final result3 = util.fill(0.8);

        expectProp(result1.$size, 24.0);
        expectProp(result2.$weight, 400.0);
        expectProp(result3.$fill, 0.8);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct IconSpec', () {
        util.mix = IconMix(size: 24.0, weight: 400.0, fill: 0.8);

        expect(
          util,
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

        util.mix = IconMix.raw(size: Prop.token(sizeToken));
        final spec = util.resolve(context);

        expect(spec.size, 32.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final sizeResult = util.size(24.0);
        final weightResult = util.weight(400.0);
        final fillResult = util.fill(0.8);

        expectProp(sizeResult.$size, 24.0);
        expectProp(weightResult.$weight, 400.0);
        expectProp(fillResult.$fill, 0.8);
      });

      test('handles multiple merges correctly', () {
        final util1 = IconSpecUtility(IconMix(size: 24.0));
        final util2 = IconSpecUtility(IconMix(weight: 400.0));
        final util3 = IconSpecUtility(IconMix(fill: 0.8));

        final result = util1.merge(util2).merge(util3);

        expectProp(result.mix.$size, 24.0);
        expectProp(result.mix.$weight, 400.0);
        expectProp(result.mix.$fill, 0.8);
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
        util.mix = IconMix(size: 24.0);
        final result = util.merge(util);

        expect(result, isNot(same(util)));
        expectProp(result.mix.$size, 24.0);
      });
    });
  });
}
