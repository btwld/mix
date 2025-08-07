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
      test('creates with provided BoxMix attribute', () {
        final boxMix = BoxMix(alignment: Alignment.center);
        final utility = BoxSpecUtility(boxMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<BoxSpecUtility>());
        expect(spec, BoxSpec(alignment: Alignment.center));
      });
    });

    group('Box utility properties', () {
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

      test('wrap utility is WidgetModifierUtility', () {
        expect(util.wrap, isA<WidgetModifierUtility<BoxMix>>());
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

      test('transformAlignment utility provides transformAlignment access', () {
        expect(util.transformAlignment, isNotNull);
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

        expect(result, isA<BoxMix>());
        expect(spec.transform, matrix);
      });

      test('transformAlignment utility creates correct BoxMix', () {
        const alignment = Alignment.topLeft;
        final result = util.transformAlignment(alignment);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxMix>());
        expect(spec.transformAlignment, alignment);
      });

      test('clipBehavior utility creates correct BoxMix', () {
        const clipBehavior = Clip.antiAlias;
        final result = util.clipBehavior(clipBehavior);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxMix>());
        expect(spec.clipBehavior, clipBehavior);
      });

      test('alignment utility creates correct BoxMix', () {
        const alignment = Alignment.center;
        final result = util.alignment(alignment);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<BoxMix>());
        expect(spec.alignment, alignment);
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
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
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
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxSpecUtility>());
        expect(spec.alignment, Alignment.center);
      });

      test('merge with BoxMix creates new instance', () {
        final otherMix = BoxMix(alignment: Alignment.topRight);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<BoxSpecUtility>());
        expect(spec.alignment, Alignment.topRight);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<BoxSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = BoxSpecUtility(BoxMix(alignment: Alignment.center));
        final other = BoxSpecUtility(BoxMix(clipBehavior: Clip.antiAlias));

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns BoxSpec with resolved properties', () {
        final testUtil = BoxSpecUtility(
          BoxMix(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            transform: Matrix4.identity(),
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<BoxSpec>());
        expect(spec.alignment, Alignment.center);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.transform, Matrix4.identity());
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<BoxSpec>());
        expect(spec.alignment, isNull);
        expect(spec.clipBehavior, isNull);
        expect(spec.transform, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic alignment mutation test', () {
        final util = BoxSpecUtility();

        final result = util.alignment(Alignment.center);
        expect(result, isA<BoxMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
      });

      test('basic transform mutation test', () {
        final util = BoxSpecUtility();
        final matrix = Matrix4.identity();

        final result = util.transform(matrix);
        expect(result, isA<BoxMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.transform, matrix);
      });

      test('chaining utility methods accumulates properties', () {
        final util = BoxSpecUtility();
        final matrix = Matrix4.identity();

        // Chain multiple method calls - these mutate internal state
        util.alignment(Alignment.center);
        util.transform(matrix);
        util.clipBehavior(Clip.antiAlias);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.transform, matrix);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('cascade notation works with utility methods', () {
        final matrix = Matrix4.identity();
        final util = BoxSpecUtility()
          ..alignment(Alignment.center)
          ..transform(matrix)
          ..clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.transform, matrix);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('individual utility calls return BoxMix for further chaining', () {
        final util = BoxSpecUtility();
        final matrix = Matrix4.identity();

        // Each utility call should return a BoxMix
        final alignmentResult = util.alignment(Alignment.center);
        final transformResult = util.transform(matrix);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<BoxMix>());
        expect(transformResult, isA<BoxMix>());
        expect(clipResult, isA<BoxMix>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.transform, matrix);
        expect(spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = BoxSpecUtility();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.alignment, isNull);

        // Mutate the utility
        util.alignment(Alignment.center);

        // Same utility instance should now resolve with the alignment
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.alignment, Alignment.center);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = BoxSpecUtility();
        final matrix = Matrix4.identity();

        util.alignment(Alignment.center);
        util.transform(matrix);
        util.clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.alignment, Alignment.center);
        expect(spec.transform, matrix);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = BoxSpecUtility();
        final matrix = Matrix4.identity();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.alignment(Alignment.center);
        final result2 = util.transform(matrix);

        // Both results are different BoxMix instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.transform, matrix);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct BoxSpec', () {
        final testUtil = BoxSpecUtility(
          BoxMix(alignment: Alignment.center, clipBehavior: Clip.antiAlias),
        );

        expect(
          testUtil,
          resolvesTo(
            const BoxSpec(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
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

        expect(alignmentResult, isA<BoxMix>());
        expect(transformResult, isA<BoxMix>());
        expect(clipResult, isA<BoxMix>());
      });

      test('handles multiple merges correctly', () {
        final util1 = BoxSpecUtility(BoxMix(alignment: Alignment.center));
        final util2 = BoxSpecUtility(BoxMix(clipBehavior: Clip.antiAlias));
        final util3 = BoxSpecUtility(BoxMix(transform: Matrix4.identity()));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.transform, Matrix4.identity());
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
        final testUtil = BoxSpecUtility(BoxMix(alignment: Alignment.center));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.alignment, Alignment.center);
      });
    });
  });
}
