import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackSpecUtility', () {
    late StackSpecUtility util;

    setUp(() {
      util = StackSpecUtility();
    });

    group('Constructor', () {
      test('creates with default StackMix when no attribute provided', () {
        final utility = StackSpecUtility();
        expect(utility.style, isA<StackMix>());
      });

      test('creates with provided StackMix attribute', () {
        final stackMix = StackMix(alignment: Alignment.center);
        final utility = StackSpecUtility(stackMix);

        expect(utility.style, same(stackMix));
        expectProp(utility.style.$alignment, Alignment.center);
      });
    });

    group('Stack utility properties', () {
      test('alignment utility is MixUtility', () {
        expect(util.alignment, isA<MixUtility<StackMix, AlignmentGeometry>>());
      });

      test('fit utility is MixUtility', () {
        expect(util.fit, isA<MixUtility<StackMix, StackFit>>());
      });

      test('textDirection utility is MixUtility', () {
        expect(util.textDirection, isA<MixUtility<StackMix, TextDirection>>());
      });

      test('clipBehavior utility is MixUtility', () {
        expect(util.clipBehavior, isA<MixUtility<StackMix, Clip>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<StackSpec, StackMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<StackMix>>());
      });
    });

    group('Stack property utilities', () {
      test('alignment utility creates correct StackMix', () {
        final result = util.alignment(Alignment.topLeft);
        expectProp(result.$alignment, Alignment.topLeft);
      });

      test('fit utility creates correct StackMix', () {
        final result = util.fit(StackFit.expand);
        expectProp(result.$fit, StackFit.expand);
      });

      test('textDirection utility creates correct StackMix', () {
        final result = util.textDirection(TextDirection.rtl);
        expectProp(result.$textDirection, TextDirection.rtl);
      });

      test('clipBehavior utility creates correct StackMix', () {
        final result = util.clipBehavior(Clip.antiAlias);
        expectProp(result.$clipBehavior, Clip.antiAlias);
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

        expect(hoverBuilder, isA<VariantAttributeBuilder<StackSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('wrap utility creates modifier StackMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<StackMix>());
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with StackSpecUtility creates new instance', () {
        final other = StackSpecUtility(StackMix(alignment: Alignment.center));
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<StackSpecUtility>());
        expectProp(result.style.$alignment, Alignment.center);
      });

      test('merge with StackMix creates new instance', () {
        final otherMix = StackMix(fit: StackFit.expand);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<StackSpecUtility>());
        expectProp(result.style.$fit, StackFit.expand);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<StackSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.style = StackMix(alignment: Alignment.center, fit: StackFit.loose);
        final other = StackSpecUtility(
          StackMix(fit: StackFit.expand, clipBehavior: Clip.antiAlias),
        );

        final result = util.merge(other);

        expectProp(result.style.$alignment, Alignment.center);
        expectProp(
          result.style.$fit,
          StackFit.expand,
        ); // other takes precedence
        expectProp(result.style.$clipBehavior, Clip.antiAlias);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns StackSpec with resolved properties', () {
        util.style = StackMix(
          alignment: Alignment.center,
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        );

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StackSpec>());
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, isNull);
        expect(spec.fit, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Utility method behavior', () {
      test('utilities return new StackMix instances', () {
        final result1 = util.alignment(Alignment.center);
        final result2 = util.fit(StackFit.expand);
        final result3 = util.clipBehavior(Clip.antiAlias);

        expectProp(result1.$alignment, Alignment.center);
        expectProp(result2.$fit, StackFit.expand);
        expectProp(result3.$clipBehavior, Clip.antiAlias);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct StackSpec', () {
        util.style = StackMix(
          alignment: Alignment.center,
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        );

        expect(
          util,
          resolvesTo(
            const StackSpec(
              alignment: Alignment.center,
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const alignmentToken = MixToken<AlignmentGeometry>('stackAlignment');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {alignmentToken: Alignment.topLeft},
          ),
        );

        util.style = StackMix.raw(alignment: Prop.token(alignmentToken));
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.topLeft);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final alignmentResult = util.alignment(Alignment.center);
        final fitResult = util.fit(StackFit.expand);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expectProp(alignmentResult.$alignment, Alignment.center);
        expectProp(fitResult.$fit, StackFit.expand);
        expectProp(clipResult.$clipBehavior, Clip.antiAlias);
      });

      test('handles multiple merges correctly', () {
        final util1 = StackSpecUtility(StackMix(alignment: Alignment.center));
        final util2 = StackSpecUtility(StackMix(fit: StackFit.expand));
        final util3 = StackSpecUtility(StackMix(clipBehavior: Clip.antiAlias));

        final result = util1.merge(util2).merge(util3);

        expectProp(result.style.$alignment, Alignment.center);
        expectProp(result.style.$fit, StackFit.expand);
        expectProp(result.style.$clipBehavior, Clip.antiAlias);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = StackSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.alignment, isNull);
        expect(spec.fit, isNull);
        expect(spec.clipBehavior, isNull);
      });

      test('merge with self returns new instance', () {
        util.style = StackMix(alignment: Alignment.center);
        final result = util.merge(util);

        expect(result, isNot(same(util)));
        expectProp(result.style.$alignment, Alignment.center);
      });
    });
  });
}
