import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxMutableStyler', () {
    late BoxMutableStyler util;

    setUp(() {
      util = BoxMutableStyler();
    });

    group('Constructor', () {
      test('creates with provided BoxMix attribute', () {
        final boxMix = BoxStyler(alignment: Alignment.center);
        final utility = BoxMutableStyler(boxMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<BoxMutableStyler>());
        expect(
          spec,
          StyleSpec(spec: const BoxSpec(alignment: Alignment.center)),
        );
      });
    });

    group('Box utility properties', () {
      test('padding utility is EdgeInsetsGeometryUtility', () {
        expect(util.padding, isA<EdgeInsetsGeometryUtility<BoxStyler>>());
      });

      test('margin utility is EdgeInsetsGeometryUtility', () {
        expect(util.margin, isA<EdgeInsetsGeometryUtility<BoxStyler>>());
      });

      test('constraints utility is BoxConstraintsUtility', () {
        expect(util.constraints, isA<BoxConstraintsUtility<BoxStyler>>());
      });

      test('decoration utility is DecorationUtility', () {
        expect(util.decoration, isA<DecorationUtility<BoxStyler>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<BoxSpec, BoxStyler>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<BoxStyler>>());
      });
    });

    group('Flattened access properties', () {
      test('border utility provides border access', () {
        expect(util.border, isNotNull);
      });

      test('borderRadius utility provides borderRadius access', () {
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

      test('transform utility provides transform access', () {
        expect(util.transform, isNotNull);
      });

      test('clipBehavior utility provides clipBehavior access', () {
        expect(util.clipBehavior, isNotNull);
      });

      test('alignment utility provides alignment access', () {
        expect(util.alignment, isNotNull);
      });
    });

    group('Box property utilities', () {
      test('transform utility creates correct BoxMix', () {
        final matrix = Matrix4.identity();
        final result = util.transform(matrix);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxStyler>());
        expect(spec.spec.transform, matrix);
      });

      test('clipBehavior utility creates correct BoxMix', () {
        const clipBehavior = Clip.antiAlias;
        final result = util.clipBehavior(clipBehavior);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxStyler>());
        expect(spec.spec.clipBehavior, clipBehavior);
      });

      test('alignment utility creates correct BoxMix', () {
        const alignment = Alignment.center;
        final result = util.alignment(alignment);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxStyler>());
        expect(spec.spec.alignment, alignment);
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

        expect(result, isA<BoxStyler>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with BoxMutableStyler creates new instance', () {
        final other = BoxMutableStyler(BoxStyler(alignment: Alignment.center));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxMutableStyler>());
        expect(spec.spec.alignment, Alignment.center);
      });

      test('merge with BoxMix creates new instance', () {
        final otherMix = BoxStyler(alignment: Alignment.topRight);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxMutableStyler>());
        expect(spec.spec.alignment, Alignment.topRight);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<BoxSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = BoxMutableStyler(BoxStyler(alignment: Alignment.center));
        final other = BoxMutableStyler(BoxStyler(clipBehavior: Clip.antiAlias));

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns BoxSpec with resolved properties', () {
        final testUtil = BoxMutableStyler(
          BoxStyler(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            transform: Matrix4.identity(),
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StyleSpec<BoxSpec>>());
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
        expect(spec.spec.transform, Matrix4.identity());
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StyleSpec<BoxSpec>>());
        expect(spec.spec.alignment, isNull);
        expect(spec.spec.clipBehavior, isNull);
        expect(spec.spec.transform, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic alignment mutation test', () {
        final util = BoxMutableStyler();

        final result = util.alignment(Alignment.center);
        expect(result, isA<BoxStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
      });

      test('basic transform mutation test', () {
        final util = BoxMutableStyler();
        final matrix = Matrix4.identity();

        final result = util.transform(matrix);
        expect(result, isA<BoxStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.transform, matrix);
      });

      test('chaining utility methods accumulates properties', () {
        final util = BoxMutableStyler();
        final matrix = Matrix4.identity();

        // Chain multiple method calls - these mutate internal state
        util.alignment(Alignment.center);
        util.transform(matrix);
        util.clipBehavior(Clip.antiAlias);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.transform, matrix);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('cascade notation works with utility methods', () {
        final matrix = Matrix4.identity();
        final util = BoxMutableStyler()
          ..alignment(Alignment.center)
          ..transform(matrix)
          ..clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.transform, matrix);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('individual utility calls return BoxMix for further chaining', () {
        final util = BoxMutableStyler();
        final matrix = Matrix4.identity();

        // Each utility call should return a BoxStyle
        final alignmentResult = util.alignment(Alignment.center);
        final transformResult = util.transform(matrix);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<BoxStyler>());
        expect(transformResult, isA<BoxStyler>());
        expect(clipResult, isA<BoxStyler>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.transform, matrix);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = BoxMutableStyler();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.spec.alignment, isNull);

        // Mutate the utility
        util.alignment(Alignment.center);

        // Same utility instance should now resolve with the alignment
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.spec.alignment, Alignment.center);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = BoxMutableStyler();
        final matrix = Matrix4.identity();

        util.alignment(Alignment.center);
        util.transform(matrix);
        util.clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.transform, matrix);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = BoxMutableStyler();
        final matrix = Matrix4.identity();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.alignment(Alignment.center);
        final result2 = util.transform(matrix);

        // Both results are different BoxStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.transform, matrix);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct BoxSpec', () {
        final testUtil = BoxMutableStyler(
          BoxStyler(alignment: Alignment.center, clipBehavior: Clip.antiAlias),
        );

        expect(
          testUtil,
          resolvesTo(
            const StyleSpec(
              spec: BoxSpec(
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
              ),
            ),
          ),
        );
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        final matrix = Matrix4.identity();

        // Test individual utility calls
        final alignmentResult = util.alignment(Alignment.center);
        final transformResult = util.transform(matrix);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<BoxStyler>());
        expect(transformResult, isA<BoxStyler>());
        expect(clipResult, isA<BoxStyler>());
      });

      test('handles multiple merges correctly', () {
        final util1 = BoxMutableStyler(BoxStyler(alignment: Alignment.center));
        final util2 = BoxMutableStyler(BoxStyler(clipBehavior: Clip.antiAlias));
        final util3 = BoxMutableStyler(
          BoxStyler(transform: Matrix4.identity()),
        );

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
        expect(spec.spec.transform, Matrix4.identity());
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = BoxMutableStyler();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.spec.alignment, isNull);
        expect(spec.spec.clipBehavior, isNull);
        expect(spec.spec.transform, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = BoxMutableStyler(
          BoxStyler(alignment: Alignment.center),
        );
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.spec.alignment, Alignment.center);
      });
    });
  });
}
