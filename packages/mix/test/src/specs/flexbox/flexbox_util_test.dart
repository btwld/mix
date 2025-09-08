import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexBoxMutableStyler', () {
    late FlexBoxMutableStyler util;

    setUp(() {
      util = FlexBoxMutableStyler();
    });

    group('Constructor', () {
      test('', () {
        final utility = FlexBoxMutableStyler();
        expect(utility, isA<FlexBoxMutableStyler>());
      });

      test('', () {
        final flexBoxMix = FlexBoxStyler(direction: Axis.horizontal);
        final utility = FlexBoxMutableStyler(flexBoxMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<FlexBoxMutableStyler>());
        expect(spec.flex?.direction, Axis.horizontal);
      });
    });

    group('Box utility properties', () {
      test('padding utility is EdgeInsetsGeometryUtility', () {
        expect(util.padding, isA<EdgeInsetsGeometryUtility<FlexBoxStyler>>());
      });

      test('margin utility is EdgeInsetsGeometryUtility', () {
        expect(util.margin, isA<EdgeInsetsGeometryUtility<FlexBoxStyler>>());
      });

      test('constraints utility is BoxConstraintsUtility', () {
        expect(util.constraints, isA<BoxConstraintsUtility<FlexBoxStyler>>());
      });

      test('decoration utility is DecorationUtility', () {
        expect(util.decoration, isA<DecorationUtility<FlexBoxStyler>>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(
          util.on,
          isA<OnContextVariantUtility<FlexBoxSpec, FlexBoxStyler>>(),
        );
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<FlexBoxStyler>>());
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
      test('', () {
        final transform = Matrix4.identity();
        final result = util.transform(transform);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.transformAlignment(Alignment.topLeft);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.clipBehavior(Clip.antiAlias);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.alignment(Alignment.bottomRight);
        expect(result, isA<FlexBoxStyler>());
      });
    });

    group('Flex utilities', () {
      test('', () {
        final result = util.direction(Axis.vertical);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.mainAxisAlignment(MainAxisAlignment.center);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.crossAxisAlignment(CrossAxisAlignment.stretch);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.mainAxisSize(MainAxisSize.min);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.verticalDirection(VerticalDirection.up);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.flexTextDirection(TextDirection.rtl);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.textBaseline(TextBaseline.ideographic);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.flexClipBehavior(Clip.antiAlias);
        expect(result, isA<FlexBoxStyler>());
      });

      test('', () {
        final result = util.spacing(16.0);
        expect(result, isA<FlexBoxStyler>());
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
      test('', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<FlexBoxStyler>());
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
        final other = FlexBoxMutableStyler(
          FlexBoxStyler(direction: Axis.horizontal),
        );
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexBoxMutableStyler>());
      });

      test('', () {
        final otherMix = FlexBoxStyler(spacing: 8.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexBoxMutableStyler>());
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<FlexBoxSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = FlexBoxMutableStyler(
          FlexBoxStyler(direction: Axis.horizontal),
        );
        final other = FlexBoxMutableStyler(
          FlexBoxStyler(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.flex?.direction, Axis.horizontal);
        expect(spec.flex?.spacing, 8.0);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    group('Resolve functionality', () {
      test('', () {
        final testUtil = FlexBoxMutableStyler(
          FlexBoxStyler(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12.0,
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StyleSpec<FlexBoxSpec>>());
        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex?.spacing, 12.0);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StyleSpec<FlexBoxSpec>>());
        expect(spec.flex?.direction, isNull);
        expect(spec.flex?.spacing, isNull);
        expect(spec.flex?.mainAxisAlignment, isNull);
      });
    });

    group('Chaining methods', () {
      test('basic direction mutation test', () {
        final util = FlexBoxMutableStyler();

        final result = util.direction(Axis.vertical);
        expect(result, isA<FlexBoxStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.direction, Axis.vertical);
      });

      test('basic gap mutation test', () {
        final util = FlexBoxMutableStyler();

        final result = util.spacing(16.0);
        expect(result, isA<FlexBoxStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.spacing, 16.0);
      });

      test('chaining utility methods accumulates properties', () {
        final util = FlexBoxMutableStyler();

        // Chain multiple method calls - these mutate internal state
        util.direction(Axis.vertical);
        util.mainAxisAlignment(MainAxisAlignment.center);
        util.spacing(16.0);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex?.spacing, 16.0);
      });

      test('cascade notation works with utility methods', () {
        final util = FlexBoxMutableStyler()
          ..direction(Axis.vertical)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..spacing(16.0);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex?.spacing, 16.0);
      });

      test('', () {
        final util = FlexBoxMutableStyler();

        // Each utility call should return a FlexBoxStyle
        final directionResult = util.direction(Axis.vertical);
        final alignmentResult = util.mainAxisAlignment(
          MainAxisAlignment.center,
        );
        final spacingResult = util.spacing(16.0);

        expect(directionResult, isA<FlexBoxStyler>());
        expect(alignmentResult, isA<FlexBoxStyler>());
        expect(spacingResult, isA<FlexBoxStyler>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex?.spacing, 16.0);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = FlexBoxMutableStyler();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.flex?.direction, isNull);

        // Mutate the utility
        util.direction(Axis.vertical);

        // Same utility instance should now resolve with the direction
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.flex?.direction, Axis.vertical);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = FlexBoxMutableStyler();

        util.direction(Axis.vertical);
        util.mainAxisAlignment(MainAxisAlignment.center);
        util.spacing(16.0);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex?.spacing, 16.0);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = FlexBoxMutableStyler();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.direction(Axis.vertical);
        final result2 = util.spacing(16.0);

        // Both results are different FlexBoxStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.flex?.direction, Axis.vertical);
        expect(spec.flex?.spacing, 16.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('', () {
        final testUtil = FlexBoxMutableStyler(
          FlexBoxStyler(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
          ),
        );

        expect(
          testUtil,
          resolvesTo(
            isA<StyleSpec<FlexBoxSpec>>().having(
              (w) => w.spec,
              'spec',
              FlexBoxSpec(
                box: StyleSpec(
                  spec: BoxSpec(),
                ), // Empty BoxSpec instead of null
                flex: StyleSpec(
                  spec: FlexSpec(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.0,
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const gapToken = MixToken<double>('gap');
        final context = MockBuildContext(tokens: {gapToken.defineValue(24.0)});

        final testUtil = FlexBoxMutableStyler(
          FlexBoxStyler.create(
            flex: Prop.maybeMix(
              FlexStyler.create(spacing: Prop.token(gapToken)),
            ),
          ),
        );
        final spec = testUtil.resolve(context);
        final flexSpec = spec.spec.flex?.spec;

        expect(flexSpec?.spacing, 24.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final directionResult = util.direction(Axis.vertical);
        final alignmentResult = util.mainAxisAlignment(
          MainAxisAlignment.spaceEvenly,
        );
        final spacingResult = util.spacing(20.0);

        expect(directionResult, isA<FlexBoxStyler>());
        expect(alignmentResult, isA<FlexBoxStyler>());
        expect(spacingResult, isA<FlexBoxStyler>());
      });

      test('handles multiple merges correctly', () {
        final util1 = FlexBoxMutableStyler(
          FlexBoxStyler(direction: Axis.horizontal),
        );
        final util2 = FlexBoxMutableStyler(FlexBoxStyler(spacing: 8.0));
        final util3 = FlexBoxMutableStyler(
          FlexBoxStyler(mainAxisAlignment: MainAxisAlignment.center),
        );

        final result = util1.merge(util2).merge(util3);

        expect(result, isA<FlexBoxMutableStyler>());
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = FlexBoxMutableStyler();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        // FlexBoxStyleSpec with empty utility has null specs
        expect(spec.flex, isNull);
        expect(spec.container, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = FlexBoxMutableStyler(
          FlexBoxStyler(direction: Axis.horizontal),
        );
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.flex?.direction, Axis.horizontal);
      });
    });
  });
}
