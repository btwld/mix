import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackMutableStyler', () {
    late StackMutableStyler util;

    setUp(() {
      util = StackMutableStyler();
    });

    group('Constructor', () {
      test('', () {
        final utility = StackMutableStyler();
        expect(utility, isA<StackMutableStyler>());
      });

      test('', () {
        final stackMix = StackStyler(alignment: Alignment.center);
        final utility = StackMutableStyler(stackMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<StackMutableStyler>());
        expect(spec.spec.alignment, Alignment.center);
      });
    });

    group('Stack utility properties', () {
      test('alignment utility is MixUtility', () {
        expect(
          util.alignment,
          isA<MixUtility<StackStyler, AlignmentGeometry>>(),
        );
      });

      test('fit utility is MixUtility', () {
        expect(util.fit, isA<MixUtility<StackStyler, StackFit>>());
      });

      test('textDirection utility is MixUtility', () {
        expect(
          util.textDirection,
          isA<MixUtility<StackStyler, TextDirection>>(),
        );
      });

      test('clipBehavior utility is MixUtility', () {
        expect(util.clipBehavior, isA<MixUtility<StackStyler, Clip>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<StackSpec, StackStyler>>());
      });

      test('wrap utility is WidgetModifierUtility', () {
        expect(util.wrap, isA<WidgetModifierUtility<StackStyler>>());
      });
    });

    group('Stack property utilities', () {
      test('', () {
        final result = util.alignment(Alignment.topLeft);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackStyler>());
        expect(spec.spec.alignment, Alignment.topLeft);
      });

      test('', () {
        final result = util.fit(StackFit.expand);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackStyler>());
        expect(spec.spec.fit, StackFit.expand);
      });

      test('', () {
        final result = util.textDirection(TextDirection.rtl);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackStyler>());
        expect(spec.spec.textDirection, TextDirection.rtl);
      });

      test('', () {
        final result = util.clipBehavior(Clip.antiAlias);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackStyler>());
        expect(spec.spec.clipBehavior, Clip.antiAlias);
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
      test('', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<StackStyler>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('', () {
        final other = StackMutableStyler(
          StackStyler(alignment: Alignment.center),
        );
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<StackMutableStyler>());
        expect(spec.spec.alignment, Alignment.center);
      });

      test('', () {
        final otherMix = StackStyler(fit: StackFit.expand);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<StackMutableStyler>());
        expect(spec.spec.fit, StackFit.expand);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<StackSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = StackMutableStyler(
          StackStyler(alignment: Alignment.center, fit: StackFit.loose),
        );
        final other = StackMutableStyler(
          StackStyler(fit: StackFit.expand, clipBehavior: Clip.antiAlias),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand); // other takes precedence
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Resolve functionality', () {
      test('', () {
        final testUtil = StackMutableStyler(
          StackStyler(
            alignment: Alignment.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StyleSpec<StackSpec>>());
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StyleSpec<StackSpec>>());
        expect(spec.spec.alignment, isNull);
        expect(spec.spec.fit, isNull);
        expect(spec.spec.clipBehavior, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic alignment mutation test', () {
        final util = StackMutableStyler();

        final result = util.alignment(Alignment.center);
        expect(result, isA<StackStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
      });

      test('basic fit mutation test', () {
        final util = StackMutableStyler();

        final result = util.fit(StackFit.expand);
        expect(result, isA<StackStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.fit, StackFit.expand);
      });

      test('chaining utility methods accumulates properties', () {
        final util = StackMutableStyler();

        // Chain multiple method calls - these mutate internal state
        util.alignment(Alignment.center);
        util.fit(StackFit.expand);
        util.clipBehavior(Clip.antiAlias);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('cascade notation works with utility methods', () {
        final util = StackMutableStyler()
          ..alignment(Alignment.center)
          ..fit(StackFit.expand)
          ..clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('', () {
        final util = StackMutableStyler();

        // Each utility call should return a StackStyle
        final alignmentResult = util.alignment(Alignment.center);
        final fitResult = util.fit(StackFit.expand);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<StackStyler>());
        expect(fitResult, isA<StackStyler>());
        expect(clipResult, isA<StackStyler>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = StackMutableStyler();

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
        final util = StackMutableStyler();

        util.alignment(Alignment.center);
        util.fit(StackFit.expand);
        util.clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = StackMutableStyler();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.alignment(Alignment.center);
        final result2 = util.fit(StackFit.expand);

        // Both results are different StackStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('', () {
        final testUtil = StackMutableStyler(
          StackStyler(
            alignment: Alignment.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
          ),
        );

        expect(
          testUtil,
          resolvesTo(
            const StyleSpec(
              spec: StackSpec(
                alignment: Alignment.center,
                fit: StackFit.expand,
                clipBehavior: Clip.antiAlias,
              ),
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const alignmentToken = MixToken<AlignmentGeometry>('stackAlignment');
        final context = MockBuildContext(
          tokens: {TokenDefinition(alignmentToken, Alignment.topLeft)},
        );

        final testUtil = StackMutableStyler(
          StackStyler.create(alignment: Prop.token(alignmentToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.alignment, Alignment.topLeft);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final alignmentResult = util.alignment(Alignment.center);
        final fitResult = util.fit(StackFit.expand);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<StackStyler>());
        expect(fitResult, isA<StackStyler>());
        expect(clipResult, isA<StackStyler>());
      });

      test('handles multiple merges correctly', () {
        final util1 = StackMutableStyler(
          StackStyler(alignment: Alignment.center),
        );
        final util2 = StackMutableStyler(StackStyler(fit: StackFit.expand));
        final util3 = StackMutableStyler(
          StackStyler(clipBehavior: Clip.antiAlias),
        );

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = StackMutableStyler();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.spec.alignment, isNull);
        expect(spec.spec.fit, isNull);
        expect(spec.spec.clipBehavior, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = StackMutableStyler(
          StackStyler(alignment: Alignment.center),
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
