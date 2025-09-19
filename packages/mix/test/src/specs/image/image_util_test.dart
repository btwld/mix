import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageMutableStyler', () {
    late ImageMutableStyler util;

    setUp(() {
      util = ImageMutableStyler();
    });

    group('Constructor', () {
      test('', () {
        final utility = ImageMutableStyler();
        expect(utility, isA<ImageMutableStyler>());
      });

      test('', () {
        final imageMix = ImageStyler(width: 100.0);
        final utility = ImageMutableStyler(imageMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<ImageMutableStyler>());
        expect(spec.spec.width, 100.0);
      });
    });

    group('Image utility properties', () {
      test('width is now a method', () {
        expect(util.width, isA<Function>());
      });

      test('height is now a method', () {
        expect(util.height, isA<Function>());
      });

      test('color utility is ColorUtility', () {
        expect(util.color, isA<ColorUtility<ImageStyler>>());
      });

      test('repeat utility is MixUtility', () {
        expect(util.repeat, isA<MixUtility<ImageStyler, ImageRepeat>>());
      });

      test('fit utility is MixUtility', () {
        expect(util.fit, isA<MixUtility<ImageStyler, BoxFit>>());
      });

      test('alignment utility is MixUtility', () {
        expect(
          util.alignment,
          isA<MixUtility<ImageStyler, AlignmentGeometry>>(),
        );
      });

      test('centerSlice utility is MixUtility', () {
        expect(util.centerSlice, isA<MixUtility<ImageStyler, Rect>>());
      });

      test('filterQuality utility is MixUtility', () {
        expect(
          util.filterQuality,
          isA<MixUtility<ImageStyler, FilterQuality>>(),
        );
      });

      test('colorBlendMode utility is MixUtility', () {
        expect(util.colorBlendMode, isA<MixUtility<ImageStyler, BlendMode>>());
      });

      test('semanticLabel is now a method', () {
        expect(util.semanticLabel, isA<Function>());
      });

      test('excludeFromSemantics is now a method', () {
        expect(util.excludeFromSemantics, isA<Function>());
      });

      test('gaplessPlayback is now a method', () {
        expect(util.gaplessPlayback, isA<Function>());
      });

      test('isAntiAlias is now a method', () {
        expect(util.isAntiAlias, isA<Function>());
      });

      test('matchTextDirection is now a method', () {
        expect(util.matchTextDirection, isA<Function>());
      });

      test('on utility is OnContextVariantUtility', () {
        expect(util.on, isA<OnContextVariantUtility<ImageSpec, ImageStyler>>());
      });

      test('wrap utility is WidgetModifierUtility', () {
        expect(util.wrap, isA<WidgetModifierUtility<ImageStyler>>());
      });
    });

    group('Image property utilities', () {
      test('', () {
        final result = util.width(100.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.width, 100.0);
      });

      test('', () {
        final result = util.height(200.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.height, 200.0);
      });

      test('', () {
        final result = util.repeat(ImageRepeat.repeat);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.repeat, ImageRepeat.repeat);
      });

      test('', () {
        final result = util.fit(BoxFit.cover);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.fit, BoxFit.cover);
      });

      test('', () {
        final result = util.alignment(Alignment.topLeft);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.alignment, Alignment.topLeft);
      });

      test('', () {
        const rect = Rect.fromLTWH(10, 10, 50, 50);
        final result = util.centerSlice(rect);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.centerSlice, rect);
      });

      test('', () {
        final result = util.filterQuality(FilterQuality.high);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.filterQuality, FilterQuality.high);
      });

      test('', () {
        final result = util.colorBlendMode(BlendMode.multiply);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.colorBlendMode, BlendMode.multiply);
      });

      test('', () {
        final result = util.semanticLabel('Test Image');
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.semanticLabel, 'Test Image');
      });

      test('', () {
        final result = util.excludeFromSemantics(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.excludeFromSemantics, true);
      });

      test('', () {
        final result = util.gaplessPlayback(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.gaplessPlayback, true);
      });

      test('', () {
        final result = util.isAntiAlias(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.isAntiAlias, true);
      });

      test('', () {
        final result = util.matchTextDirection(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageStyler>());
        expect(spec.spec.matchTextDirection, true);
      });
    });

    group('Color utilities', () {
      test('', () {
        final result = util.color.red();
        expect(result, isA<ImageStyler>());
      });

      test('color utility with specific color', () {
        final result = util.color(Colors.blue);
        expect(result, isA<ImageStyler>());
      });

      test('color utility with different colors', () {
        final redResult = util.color(Colors.red);
        final greenResult = util.color(Colors.green);
        final blueResult = util.color(Colors.blue);

        expect(redResult, isA<ImageStyler>());
        expect(greenResult, isA<ImageStyler>());
        expect(blueResult, isA<ImageStyler>());
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

        expect(hoverBuilder, isA<VariantAttributeBuilder<ImageSpec>>());
      });
    });

    group('Modifier utilities', () {
      test('', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<ImageStyler>());
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
        final other = ImageMutableStyler(ImageStyler(width: 150.0));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<ImageMutableStyler>());
        expect(spec.spec.width, 150.0);
      });

      test('', () {
        final otherMix = ImageStyler(height: 250.0);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<ImageMutableStyler>());
        expect(spec.spec.height, 250.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<ImageSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = ImageMutableStyler(
          ImageStyler(width: 100.0, height: 200.0),
        );
        final other = ImageMutableStyler(
          ImageStyler(height: 300.0, fit: BoxFit.cover),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 300.0); // other takes precedence
        expect(spec.spec.fit, BoxFit.cover);
      });
    });

    group('Resolve functionality', () {
      test('', () {
        final testUtil = ImageMutableStyler(
          ImageStyler(width: 100.0, height: 200.0, fit: BoxFit.cover),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<StyleSpec<ImageSpec>>());
        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<StyleSpec<ImageSpec>>());
        expect(spec.spec.width, isNull);
        expect(spec.spec.height, isNull);
        expect(spec.spec.fit, isNull);
      });

      test('resolve handles all properties correctly', () {
        final testUtil = ImageMutableStyler(
          ImageStyler(
            width: 100.0,
            height: 200.0,
            color: Colors.red,
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            centerSlice: const Rect.fromLTWH(0, 0, 50, 50),
            filterQuality: FilterQuality.high,
            colorBlendMode: BlendMode.multiply,
            semanticLabel: 'Test',
            excludeFromSemantics: true,
            gaplessPlayback: true,
            isAntiAlias: false,
            matchTextDirection: true,
          ),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(
          spec,
          equals(
            StyleSpec(
              spec: const ImageSpec(
                width: 100.0,
                height: 200.0,
                color: Colors.red,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                centerSlice: Rect.fromLTWH(0, 0, 50, 50),
                filterQuality: FilterQuality.high,
                colorBlendMode: BlendMode.multiply,
                semanticLabel: 'Test',
                excludeFromSemantics: true,
                gaplessPlayback: true,
                isAntiAlias: false,
                matchTextDirection: true,
              ),
            ),
          ),
        );
      });
    });

    group('Chaining methods', () {
      test('basic width mutation test', () {
        final util = ImageMutableStyler();

        final result = util.width(100.0);
        expect(result, isA<ImageStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.width, 100.0);
      });

      test('basic height mutation test', () {
        final util = ImageMutableStyler();

        final result = util.height(200.0);
        expect(result, isA<ImageStyler>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.height, 200.0);
      });

      test('chaining utility methods accumulates properties', () {
        final util = ImageMutableStyler();

        // Chain multiple method calls - these mutate internal state
        util.width(100.0);
        util.height(200.0);
        util.fit(BoxFit.cover);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });

      test('cascade notation works with utility methods', () {
        final util = ImageMutableStyler()
          ..width(100.0)
          ..height(200.0)
          ..fit(BoxFit.cover);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });

      test('', () {
        final util = ImageMutableStyler();

        // Each utility call should return an ImageStyle
        final widthResult = util.width(100.0);
        final heightResult = util.height(200.0);
        final fitResult = util.fit(BoxFit.cover);

        expect(widthResult, isA<ImageStyler>());
        expect(heightResult, isA<ImageStyler>());
        expect(fitResult, isA<ImageStyler>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = ImageMutableStyler();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.spec.width, isNull);

        // Mutate the utility
        util.width(100.0);

        // Same utility instance should now resolve with the width
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.spec.width, 100.0);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = ImageMutableStyler();

        util.width(100.0);
        util.height(200.0);
        util.fit(BoxFit.cover);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = ImageMutableStyler();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.width(100.0);
        final result2 = util.height(200.0);

        // Both results are different ImageStyle instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('', () {
        final testUtil = ImageMutableStyler(
          ImageStyler(width: 100.0, height: 200.0, fit: BoxFit.cover),
        );

        expect(
          testUtil,
          resolvesTo(
            StyleSpec(
              spec: const ImageSpec(
                width: 100.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const widthToken = TestToken<double>('imageWidth');
        final context = MockBuildContext(
          tokens: {widthToken: 150.0},
        );

        final testUtil = ImageMutableStyler(
          ImageStyler.create(width: Prop.token(widthToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.width, 150.0);
      });

      test('resolves multiple tokens', () {
        const widthToken = TestToken<double>('imageWidth');
        const heightToken = TestToken<double>('imageHeight');
        const colorToken = TestToken<Color>('imageColor');

        final context = MockBuildContext(
          tokens: {
            widthToken: 200.0,
            heightToken: 300.0,
            colorToken: Colors.blue,
          },
        );

        final testUtil = ImageMutableStyler(
          ImageStyler.create(
            width: Prop.token(widthToken),
            height: Prop.token(heightToken),
            color: Prop.token(colorToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.width, 200.0);
        expect(spec.spec.height, 300.0);
        expect(spec.spec.color, Colors.blue);
      });

      test('resolves enum tokens', () {
        const fitToken = TestToken<BoxFit>('imageFit');
        const repeatToken = TestToken<ImageRepeat>('imageRepeat');
        const filterQualityToken = TestToken<FilterQuality>(
          'imageFilterQuality',
        );

        final context = MockBuildContext(
          tokens: {
            fitToken: BoxFit.cover,
            repeatToken: ImageRepeat.repeat,
            filterQualityToken: FilterQuality.high,
          },
        );

        final testUtil = ImageMutableStyler(
          ImageStyler.create(
            fit: Prop.token(fitToken),
            repeat: Prop.token(repeatToken),
            filterQuality: Prop.token(filterQualityToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.fit, BoxFit.cover);
        expect(spec.spec.repeat, ImageRepeat.repeat);
        expect(spec.spec.filterQuality, FilterQuality.high);
      });

      test('resolves string and bool tokens', () {
        const labelToken = TestToken<String>('imageLabel');
        const excludeToken = TestToken<bool>('excludeFromSemantics');
        const gaplessToken = TestToken<bool>('gaplessPlayback');

        final context = MockBuildContext(
          tokens: {
            labelToken: 'My Image',
            excludeToken: true,
            gaplessToken: false,
          },
        );

        final testUtil = ImageMutableStyler(
          ImageStyler.create(
            semanticLabel: Prop.token(labelToken),
            excludeFromSemantics: Prop.token(excludeToken),
            gaplessPlayback: Prop.token(gaplessToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.spec.semanticLabel, 'My Image');
        expect(spec.spec.excludeFromSemantics, true);
        expect(spec.spec.gaplessPlayback, false);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final widthResult = util.width(100.0);
        final heightResult = util.height(200.0);
        final fitResult = util.fit(BoxFit.cover);

        expect(widthResult, isA<ImageStyler>());
        expect(heightResult, isA<ImageStyler>());
        expect(fitResult, isA<ImageStyler>());
      });

      test('handles multiple merges correctly', () {
        final util1 = ImageMutableStyler(ImageStyler(width: 100.0));
        final util2 = ImageMutableStyler(ImageStyler(height: 200.0));
        final util3 = ImageMutableStyler(ImageStyler(fit: BoxFit.cover));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.fit, BoxFit.cover);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = ImageMutableStyler();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.spec.width, isNull);
        expect(spec.spec.height, isNull);
        expect(spec.spec.fit, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = ImageMutableStyler(ImageStyler(width: 100.0));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.spec.width, 100.0);
      });
    });
  });
}
