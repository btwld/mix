import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxSpecUtility', () {
    late BoxSpecUtility util;

    setUp(() {
      util = BoxSpecUtility();
    });

    group('Constructor', () {
      test('creates with default BoxMix when no attribute provided', () {
        final utility = BoxSpecUtility();
        expect(utility.style, isA<BoxMix>());
      });

      test('creates with provided BoxMix attribute', () {
        final boxMix = BoxMix(alignment: Alignment.center);
        final utility = BoxSpecUtility(boxMix);

        expect(utility.style, same(boxMix));
        expectProp(utility.style.$alignment, Alignment.center);
      });
    });

    group('Utility properties', () {
      test('padding utility is EdgeInsetsGeometryUtility', () {
        expect(util.padding, isA<EdgeInsetsGeometryUtility<BoxMix>>());
      });

      test('margin utility is EdgeInsetsGeometryUtility', () {
        expect(util.margin, isA<EdgeInsetsGeometryUtility<BoxMix>>());
      });

      test('constraints utility is BoxConstraintsUtility', () {
        expect(util.constraints, isA<BoxConstraintsUtility<BoxMix>>());
      });

      test('decoration utility is DecorationUtility', () {
        expect(util.decoration, isA<DecorationUtility<BoxMix>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<BoxSpec, BoxMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<BoxMix>>());
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

    group('Convenience shortcuts', () {
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

    group('Prop utilities', () {
      test('transform utility creates correct BoxMix', () {
        final transform = Matrix4.identity();
        final result = util.transform(transform);
        expectProp(result.$transform, transform);
      });

      test('transformAlignment utility creates correct BoxMix', () {
        final result = util.transformAlignment(Alignment.topLeft);
        expectProp(result.$transformAlignment, Alignment.topLeft);
      });

      test('clipBehavior utility creates correct BoxMix', () {
        final result = util.clipBehavior(Clip.antiAlias);
        expectProp(result.$clipBehavior, Clip.antiAlias);
      });

      test('alignment utility creates correct BoxMix', () {
        final result = util.alignment(Alignment.bottomRight);
        expectProp(result.$alignment, Alignment.bottomRight);
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

        expect(hoverBuilder, isA<VariantAttributeBuilder<BoxSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('wrap utility creates modifier BoxMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<BoxMix>());
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with BoxSpecUtility creates new instance', () {
        final other = BoxSpecUtility(BoxMix(alignment: Alignment.center));
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxSpecUtility>());
        expectProp(result.style.$alignment, Alignment.center);
      });

      test('merge with BoxMix creates new instance', () {
        final otherMix = BoxMix(clipBehavior: Clip.hardEdge);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxSpecUtility>());
        expectProp(result.style.$clipBehavior, Clip.hardEdge);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<BoxSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.style = BoxMix(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
        );
        final other = BoxSpecUtility(
          BoxMix(clipBehavior: Clip.hardEdge, transform: Matrix4.identity()),
        );

        final result = util.merge(other);

        expectProp(result.style.$alignment, Alignment.center);
        expectProp(
          result.style.$clipBehavior,
          Clip.hardEdge,
        ); // other takes precedence
        expectProp(result.style.$transform, Matrix4.identity());
      });
    });

    group('Resolve functionality', () {
      test('resolve returns BoxSpec with resolved properties', () {
        util.style = BoxMix(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          transform: Matrix4.identity(),
        );

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<BoxSpec>());
        expect(spec.alignment, Alignment.center);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.transform, Matrix4.identity());
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, isNull);
        expect(spec.clipBehavior, isNull);
        expect(spec.transform, isNull);
      });
    });

    group('Utility method behavior', () {
      test('utilities return new BoxMix instances', () {
        final result1 = util.alignment(Alignment.center);
        final result2 = util.clipBehavior(Clip.antiAlias);
        final result3 = util.transform(Matrix4.identity());

        expectProp(result1.$alignment, Alignment.center);
        expectProp(result2.$clipBehavior, Clip.antiAlias);
        expectProp(result3.$transform, Matrix4.identity());
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct BoxSpec', () {
        util.style = BoxMix(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
        );

        expect(
          util,
          resolvesTo(
            const BoxSpec(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const alignmentToken = MixToken<AlignmentGeometry>('alignment');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(
            tokens: {alignmentToken: Alignment.topLeft},
          ),
        );

        util.style = BoxMix.raw(alignment: Prop.token(alignmentToken));
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.topLeft);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final alignmentResult = util.alignment(Alignment.center);
        final clipResult = util.clipBehavior(Clip.antiAlias);
        final transformResult = util.transform(Matrix4.identity());

        expectProp(alignmentResult.$alignment, Alignment.center);
        expectProp(clipResult.$clipBehavior, Clip.antiAlias);
        expectProp(transformResult.$transform, Matrix4.identity());
      });

      test('handles multiple merges correctly', () {
        final util1 = BoxSpecUtility(BoxMix(alignment: Alignment.center));
        final util2 = BoxSpecUtility(BoxMix(clipBehavior: Clip.antiAlias));
        final util3 = BoxSpecUtility(BoxMix(transform: Matrix4.identity()));

        final result = util1.merge(util2).merge(util3);

        expectProp(result.style.$alignment, Alignment.center);
        expectProp(result.style.$clipBehavior, Clip.antiAlias);
        expectProp(result.style.$transform, Matrix4.identity());
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = BoxSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.alignment, isNull);
        expect(spec.clipBehavior, isNull);
        expect(spec.transform, isNull);
      });

      test('merge with self returns new instance', () {
        util.style = BoxMix(alignment: Alignment.center);
        final result = util.merge(util);

        expect(result, isNot(same(util)));
        expectProp(result.style.$alignment, Alignment.center);
      });
    });
  });
}
