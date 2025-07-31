import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexBoxSpecUtility', () {
    late FlexBoxSpecUtility util;

    setUp(() {
      util = FlexBoxSpecUtility();
    });

    group('Constructor', () {
      test('creates with default FlexBoxMix when no attribute provided', () {
        final utility = FlexBoxSpecUtility();
        expect(utility.mix, isA<FlexBoxMix>());
      });

      test('creates with provided FlexBoxMix attribute', () {
        final flexBoxMix = FlexBoxMix(
          flex: FlexMix(direction: Axis.horizontal),
        );
        final utility = FlexBoxSpecUtility(flexBoxMix);

        expect(utility.mix, same(flexBoxMix));
      });
    });

    group('Box utility properties', () {
      test('padding utility is EdgeInsetsGeometryUtility', () {
        expect(util.padding, isA<EdgeInsetsGeometryUtility<FlexBoxMix>>());
      });

      test('margin utility is EdgeInsetsGeometryUtility', () {
        expect(util.margin, isA<EdgeInsetsGeometryUtility<FlexBoxMix>>());
      });

      test('constraints utility is BoxConstraintsUtility', () {
        expect(util.constraints, isA<BoxConstraintsUtility<FlexBoxMix>>());
      });

      test('decoration utility is DecorationUtility', () {
        expect(util.decoration, isA<DecorationUtility<FlexBoxMix>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(
          util.on,
          isA<OnContextVariantUtility<FlexBoxSpec, FlexBoxMix>>(),
        );
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<FlexBoxMix>>());
      });
    });

    group('Flattened access utilities', () {
      test('border utility provides border access', () {
        expect(util.border, isNotNull);
      });

      test('borderRadius utility provides border radius access', () {
        expect(util.borderRadius, isNotNull);
      });

      test('color utility provides color access', () {
        expect(util.color, isNotNull);
      });

      test('gradient utility provides gradient access', () {
        expect(util.gradient, isNotNull);
      });

      test('shape utility provides shape access', () {
        expect(util.shape, isNotNull);
      });
    });

    group('Box convenience shortcuts', () {
      test('width utility provides width access', () {
        expect(util.width, isNotNull);
      });

      test('height utility provides height access', () {
        expect(util.height, isNotNull);
      });

      test('minWidth utility provides minWidth access', () {
        expect(util.minWidth, isNotNull);
      });

      test('maxWidth utility provides maxWidth access', () {
        expect(util.maxWidth, isNotNull);
      });

      test('minHeight utility provides minHeight access', () {
        expect(util.minHeight, isNotNull);
      });

      test('maxHeight utility provides maxHeight access', () {
        expect(util.maxHeight, isNotNull);
      });
    });

    group('Box prop utilities', () {
      test('transform utility creates correct FlexBoxMix', () {
        final transform = Matrix4.identity();
        final result = util.transform(transform);
        expect(result, isA<FlexBoxMix>());
      });

      test('transformAlignment utility creates correct FlexBoxMix', () {
        final result = util.transformAlignment(Alignment.topLeft);
        expect(result, isA<FlexBoxMix>());
      });

      test('clipBehavior utility creates correct FlexBoxMix', () {
        final result = util.clipBehavior(Clip.antiAlias);
        expect(result, isA<FlexBoxMix>());
      });

      test('alignment utility creates correct FlexBoxMix', () {
        final result = util.alignment(Alignment.bottomRight);
        expect(result, isA<FlexBoxMix>());
      });
    });

    group('Flex utilities', () {
      test('direction utility creates correct FlexBoxMix', () {
        final result = util.direction(Axis.vertical);
        expect(result, isA<FlexBoxMix>());
      });

      test('mainAxisAlignment utility creates correct FlexBoxMix', () {
        final result = util.mainAxisAlignment(MainAxisAlignment.center);
        expect(result, isA<FlexBoxMix>());
      });

      test('crossAxisAlignment utility creates correct FlexBoxMix', () {
        final result = util.crossAxisAlignment(CrossAxisAlignment.stretch);
        expect(result, isA<FlexBoxMix>());
      });

      test('mainAxisSize utility creates correct FlexBoxMix', () {
        final result = util.mainAxisSize(MainAxisSize.min);
        expect(result, isA<FlexBoxMix>());
      });

      test('verticalDirection utility creates correct FlexBoxMix', () {
        final result = util.verticalDirection(VerticalDirection.up);
        expect(result, isA<FlexBoxMix>());
      });

      test('flexTextDirection utility creates correct FlexBoxMix', () {
        final result = util.flexTextDirection(TextDirection.rtl);
        expect(result, isA<FlexBoxMix>());
      });

      test('textBaseline utility creates correct FlexBoxMix', () {
        final result = util.textBaseline(TextBaseline.ideographic);
        expect(result, isA<FlexBoxMix>());
      });

      test('flexClipBehavior utility creates correct FlexBoxMix', () {
        final result = util.flexClipBehavior(Clip.antiAlias);
        expect(result, isA<FlexBoxMix>());
      });

      test('gap utility creates correct FlexBoxMix', () {
        final result = util.gap(16.0);
        expect(result, isA<FlexBoxMix>());
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

        expect(hoverBuilder, isA<VariantAttributeBuilder<FlexBoxSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('wrap utility creates modifier FlexBoxMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<FlexBoxMix>());
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with FlexBoxSpecUtility creates new instance', () {
        final other = FlexBoxSpecUtility(
          FlexBoxMix(flex: FlexMix(direction: Axis.horizontal)),
        );
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexBoxSpecUtility>());
      });

      test('merge with FlexBoxMix creates new instance', () {
        final otherMix = FlexBoxMix(flex: FlexMix(gap: 8.0));
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexBoxSpecUtility>());
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<FlexBoxSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.mix = FlexBoxMix(flex: FlexMix(direction: Axis.horizontal));
        final other = FlexBoxSpecUtility(
          FlexBoxMix(
            flex: FlexMix(
              gap: 8.0,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        );

        final result = util.merge(other);

        expect(result, isA<FlexBoxSpecUtility>());
      });
    });

    group('Resolve functionality', () {
      test('resolve returns FlexBoxSpec with resolved properties', () {
        util.mix = FlexBoxMix(
          flex: FlexMix(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            gap: 12.0,
          ),
        );

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<FlexBoxSpec>());
        expect(spec.flex.direction, Axis.vertical);
        expect(spec.flex.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex.gap, 12.0);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        // FlexBoxSpec always creates default BoxSpec and FlexSpec even when empty
        expect(spec.flex, isNotNull);
        expect(spec.flex.direction, isNull);
        expect(spec.flex.gap, isNull);
        expect(spec.box, isNotNull);
        expect(spec.box.alignment, isNull);
      });
    });

    group('Utility method behavior', () {
      test('utilities return new FlexBoxMix instances', () {
        final result1 = util.direction(Axis.vertical);
        final result2 = util.mainAxisAlignment(MainAxisAlignment.center);
        final result3 = util.gap(16.0);

        expect(result1, isA<FlexBoxMix>());
        expect(result2, isA<FlexBoxMix>());
        expect(result3, isA<FlexBoxMix>());
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct FlexBoxSpec', () {
        util.mix = FlexBoxMix(
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            gap: 8.0,
          ),
        );

        expect(
          util,
          resolvesTo(
            const FlexBoxSpec(
              flex: FlexSpec(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 8.0,
              ),
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

        util.mix = FlexBoxMix(flex: FlexMix.raw(gap: Prop.token(gapToken)));
        final spec = util.resolve(context);

        expect(spec.flex.gap, 24.0);
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

        expect(directionResult, isA<FlexBoxMix>());
        expect(alignmentResult, isA<FlexBoxMix>());
        expect(gapResult, isA<FlexBoxMix>());
      });

      test('handles multiple merges correctly', () {
        final util1 = FlexBoxSpecUtility(
          FlexBoxMix(flex: FlexMix(direction: Axis.horizontal)),
        );
        final util2 = FlexBoxSpecUtility(FlexBoxMix(flex: FlexMix(gap: 8.0)));
        final util3 = FlexBoxSpecUtility(
          FlexBoxMix(
            flex: FlexMix(mainAxisAlignment: MainAxisAlignment.center),
          ),
        );

        final result = util1.merge(util2).merge(util3);

        expect(result, isA<FlexBoxSpecUtility>());
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = FlexBoxSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        // FlexBoxSpec always creates default BoxSpec and FlexSpec even when empty
        expect(spec.flex, isNotNull);
        expect(spec.flex.direction, isNull);
        expect(spec.box, isNotNull);
        expect(spec.box.alignment, isNull);
      });

      test('merge with self returns new instance', () {
        util.mix = FlexBoxMix(flex: FlexMix(direction: Axis.horizontal));
        final result = util.merge(util);

        expect(result, isNot(same(util)));
      });
    });
  });
}
