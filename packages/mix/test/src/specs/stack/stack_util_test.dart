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
        expect(utility, isA<StackSpecUtility>());
      });

      test('creates with provided StackMix attribute', () {
        final stackMix = StackMix(alignment: Alignment.center);
        final utility = StackSpecUtility(stackMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<StackSpecUtility>());
        expect(spec.alignment, Alignment.center);
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

      test('wrap utility is WidgetDecoratorUtility', () {
        expect(util.wrap, isA<WidgetDecoratorUtility<StackMix>>());
      });
    });

    group('Stack property utilities', () {
      test('alignment utility creates correct StackMix', () {
        final result = util.alignment(Alignment.topLeft);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackMix>());
        expect(spec.alignment, Alignment.topLeft);
      });

      test('fit utility creates correct StackMix', () {
        final result = util.fit(StackFit.expand);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackMix>());
        expect(spec.fit, StackFit.expand);
      });

      test('textDirection utility creates correct StackMix', () {
        final result = util.textDirection(TextDirection.rtl);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackMix>());
        expect(spec.textDirection, TextDirection.rtl);
      });

      test('clipBehavior utility creates correct StackMix', () {
        final result = util.clipBehavior(Clip.antiAlias);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<StackMix>());
        expect(spec.clipBehavior, Clip.antiAlias);
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

    group('Decorator utilities', () {
      test('wrap utility creates modifier StackMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<StackMix>());
        expect(result.$widgetDecoratorConfig, isNotNull);
        expect(result.$widgetDecoratorConfig!.$decorators!.length, 1);
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
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<StackSpecUtility>());
        expect(spec.alignment, Alignment.center);
      });

      test('merge with StackMix creates new instance', () {
        final otherMix = StackMix(fit: StackFit.expand);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<StackSpecUtility>());
        expect(spec.fit, StackFit.expand);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<StackSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = StackSpecUtility(
          StackMix(alignment: Alignment.center, fit: StackFit.loose),
        );
        final other = StackSpecUtility(
          StackMix(fit: StackFit.expand, clipBehavior: Clip.antiAlias),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand); // other takes precedence
        expect(spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns StackSpec with resolved properties', () {
        final testUtil = StackSpecUtility(
          StackMix(
            alignment: Alignment.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StackSpec>());
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StackSpec>());
        expect(spec.alignment, isNull);
        expect(spec.fit, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic alignment mutation test', () {
        final util = StackSpecUtility();

        final result = util.alignment(Alignment.center);
        expect(result, isA<StackMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
      });

      test('basic fit mutation test', () {
        final util = StackSpecUtility();

        final result = util.fit(StackFit.expand);
        expect(result, isA<StackMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.fit, StackFit.expand);
      });

      test('chaining utility methods accumulates properties', () {
        final util = StackSpecUtility();

        // Chain multiple method calls - these mutate internal state
        util.alignment(Alignment.center);
        util.fit(StackFit.expand);
        util.clipBehavior(Clip.antiAlias);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('cascade notation works with utility methods', () {
        final util = StackSpecUtility()
          ..alignment(Alignment.center)
          ..fit(StackFit.expand)
          ..clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('individual utility calls return StackMix for further chaining', () {
        final util = StackSpecUtility();

        // Each utility call should return a StackMix
        final alignmentResult = util.alignment(Alignment.center);
        final fitResult = util.fit(StackFit.expand);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<StackMix>());
        expect(fitResult, isA<StackMix>());
        expect(clipResult, isA<StackMix>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = StackSpecUtility();

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
        final util = StackSpecUtility();

        util.alignment(Alignment.center);
        util.fit(StackFit.expand);
        util.clipBehavior(Clip.antiAlias);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = StackSpecUtility();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.alignment(Alignment.center);
        final result2 = util.fit(StackFit.expand);

        // Both results are different StackMix instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct StackSpec', () {
        final testUtil = StackSpecUtility(
          StackMix(
            alignment: Alignment.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
          ),
        );

        expect(
          testUtil,
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

        final testUtil = StackSpecUtility(
          StackMix.raw(alignment: Prop.token(alignmentToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.alignment, Alignment.topLeft);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final alignmentResult = util.alignment(Alignment.center);
        final fitResult = util.fit(StackFit.expand);
        final clipResult = util.clipBehavior(Clip.antiAlias);

        expect(alignmentResult, isA<StackMix>());
        expect(fitResult, isA<StackMix>());
        expect(clipResult, isA<StackMix>());
      });

      test('handles multiple merges correctly', () {
        final util1 = StackSpecUtility(StackMix(alignment: Alignment.center));
        final util2 = StackSpecUtility(StackMix(fit: StackFit.expand));
        final util3 = StackSpecUtility(StackMix(clipBehavior: Clip.antiAlias));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.clipBehavior, Clip.antiAlias);
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
        final testUtil = StackSpecUtility(
          StackMix(alignment: Alignment.center),
        );
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.alignment, Alignment.center);
      });
    });
  });
}
