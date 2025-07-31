import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexSpecUtility', () {
    late FlexSpecUtility util;

    setUp(() {
      util = FlexSpecUtility();
    });

    group('Constructor', () {
      test('creates with default FlexMix when no attribute provided', () {
        final utility = FlexSpecUtility();
        expect(utility.mix, isA<FlexMix>());
      });

      test('creates with provided FlexMix attribute', () {
        final flexMix = FlexMix(direction: Axis.horizontal);
        final utility = FlexSpecUtility(flexMix);

        expect(utility.mix, same(flexMix));
        expectProp(utility.mix.$direction, Axis.horizontal);
      });
    });

    group('Property utilities', () {
      test('direction utility creates correct FlexMix', () {
        final result = util.direction(Axis.vertical);
        expectProp(result.$direction, Axis.vertical);
      });

      test('mainAxisAlignment utility creates correct FlexMix', () {
        final result = util.mainAxisAlignment(MainAxisAlignment.center);
        expectProp(result.$mainAxisAlignment, MainAxisAlignment.center);
      });

      test('crossAxisAlignment utility creates correct FlexMix', () {
        final result = util.crossAxisAlignment(CrossAxisAlignment.stretch);
        expectProp(result.$crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      test('mainAxisSize utility creates correct FlexMix', () {
        final result = util.mainAxisSize(MainAxisSize.min);
        expectProp(result.$mainAxisSize, MainAxisSize.min);
      });

      test('verticalDirection utility creates correct FlexMix', () {
        final result = util.verticalDirection(VerticalDirection.up);
        expectProp(result.$verticalDirection, VerticalDirection.up);
      });

      test('textDirection utility creates correct FlexMix', () {
        final result = util.textDirection(TextDirection.rtl);
        expectProp(result.$textDirection, TextDirection.rtl);
      });

      test('textBaseline utility creates correct FlexMix', () {
        final result = util.textBaseline(TextBaseline.ideographic);
        expectProp(result.$textBaseline, TextBaseline.ideographic);
      });

      test('clipBehavior utility creates correct FlexMix', () {
        final result = util.clipBehavior(Clip.antiAlias);
        expectProp(result.$clipBehavior, Clip.antiAlias);
      });

      test('gap utility creates correct FlexMix', () {
        final result = util.gap(16.0);
        expectProp(result.$gap, 16.0);
      });
    });

    group('Convenience methods', () {
      test('row() sets direction to horizontal', () {
        final result = util.row();
        expectProp(result.$direction, Axis.horizontal);
      });

      test('column() sets direction to vertical', () {
        final result = util.column();
        expectProp(result.$direction, Axis.vertical);
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

        expect(hoverBuilder, isA<VariantAttributeBuilder<FlexSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('wrap utility creates modifier FlexMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<FlexMix>());
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with FlexSpecUtility creates new instance', () {
        final other = FlexSpecUtility(FlexMix(direction: Axis.horizontal));
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexSpecUtility>());
        expectProp(result.mix.$direction, Axis.horizontal);
      });

      test('merge with FlexMix creates new instance', () {
        final otherMix = FlexMix(gap: 8.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexSpecUtility>());
        expectProp(result.mix.$gap, 8.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<FlexSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.mix = FlexMix(direction: Axis.horizontal, gap: 4.0);
        final other = FlexSpecUtility(
          FlexMix(gap: 8.0, clipBehavior: Clip.hardEdge),
        );

        final result = util.merge(other);

        expectProp(result.mix.$direction, Axis.horizontal);
        expectProp(result.mix.$gap, 8.0); // other takes precedence
        expectProp(result.mix.$clipBehavior, Clip.hardEdge);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns FlexSpec with resolved properties', () {
        util.mix = FlexMix(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 12.0,
        );

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<FlexSpec>());
        expect(spec.direction, Axis.vertical);
        expect(spec.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.gap, 12.0);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.direction, isNull);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.gap, isNull);
      });
    });

    group('Cascade notation support', () {
      test('utilities return new FlexMix instances', () {
        final result1 = util.direction(Axis.horizontal);
        final result2 = util.mainAxisAlignment(MainAxisAlignment.spaceBetween);
        final result3 = util.gap(16.0);

        expectProp(result1.$direction, Axis.horizontal);
        expectProp(result2.$mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expectProp(result3.$gap, 16.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct FlexSpec', () {
        util.mix = FlexMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 8.0,
        );

        expect(
          util,
          resolvesTo(
            const FlexSpec(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 8.0,
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const gapToken = MixToken<double>('gap');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {gapToken: 24.0}),
        );

        util.mix = FlexMix.raw(gap: Prop.token(gapToken));
        final spec = util.resolve(context);

        expect(spec.gap, 24.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final directionResult = util.direction(Axis.vertical);
        final alignmentResult = util.mainAxisAlignment(
          MainAxisAlignment.spaceEvenly,
        );
        final gapResult = util.gap(20.0);

        expectProp(directionResult.$direction, Axis.vertical);
        expectProp(
          alignmentResult.$mainAxisAlignment,
          MainAxisAlignment.spaceEvenly,
        );
        expectProp(gapResult.$gap, 20.0);
      });

      test('handles multiple merges correctly', () {
        final util1 = FlexSpecUtility(FlexMix(direction: Axis.horizontal));
        final util2 = FlexSpecUtility(FlexMix(gap: 8.0));
        final util3 = FlexSpecUtility(
          FlexMix(mainAxisAlignment: MainAxisAlignment.center),
        );

        final result = util1.merge(util2).merge(util3);

        expectProp(result.mix.$direction, Axis.horizontal);
        expectProp(result.mix.$gap, 8.0);
        expectProp(result.mix.$mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = FlexSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.direction, isNull);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.crossAxisAlignment, isNull);
        expect(spec.gap, isNull);
      });

      test('merge with self returns new instance', () {
        util.mix = FlexMix(direction: Axis.horizontal);
        final result = util.merge(util);

        expect(result, isNot(same(util)));
        expectProp(result.mix.$direction, Axis.horizontal);
      });
    });
  });
}
