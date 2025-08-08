import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageSpecUtility', () {
    late ImageSpecUtility util;

    setUp(() {
      util = ImageSpecUtility();
    });

    group('Constructor', () {
      test('creates with default ImageMix when no attribute provided', () {
        final utility = ImageSpecUtility();
        expect(utility, isA<ImageSpecUtility>());
      });

      test('creates with provided ImageMix attribute', () {
        final imageMix = ImageMix(width: 100.0);
        final utility = ImageSpecUtility(imageMix);
        final context = MockBuildContext();
        final spec = utility.resolve(context);

        expect(utility, isA<ImageSpecUtility>());
        expect(spec.width, 100.0);
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
        expect(util.color, isA<ColorUtility<ImageMix>>());
      });

      test('repeat utility is MixUtility', () {
        expect(util.repeat, isA<MixUtility<ImageMix, ImageRepeat>>());
      });

      test('fit utility is MixUtility', () {
        expect(util.fit, isA<MixUtility<ImageMix, BoxFit>>());
      });

      test('alignment utility is MixUtility', () {
        expect(util.alignment, isA<MixUtility<ImageMix, AlignmentGeometry>>());
      });

      test('centerSlice utility is MixUtility', () {
        expect(util.centerSlice, isA<MixUtility<ImageMix, Rect>>());
      });

      test('filterQuality utility is MixUtility', () {
        expect(util.filterQuality, isA<MixUtility<ImageMix, FilterQuality>>());
      });

      test('colorBlendMode utility is MixUtility', () {
        expect(util.colorBlendMode, isA<MixUtility<ImageMix, BlendMode>>());
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
        expect(util.on, isA<OnContextVariantUtility<ImageSpec, ImageMix>>());
      });

      test('wrap utility is ModifierUtility', () {
        expect(util.wrap, isA<ModifierUtility<ImageMix>>());
      });
    });

    group('Image property utilities', () {
      test('width utility creates correct ImageMix', () {
        final result = util.width(100.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.width, 100.0);
      });

      test('height utility creates correct ImageMix', () {
        final result = util.height(200.0);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.height, 200.0);
      });

      test('repeat utility creates correct ImageMix', () {
        final result = util.repeat(ImageRepeat.repeat);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.repeat, ImageRepeat.repeat);
      });

      test('fit utility creates correct ImageMix', () {
        final result = util.fit(BoxFit.cover);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.fit, BoxFit.cover);
      });

      test('alignment utility creates correct ImageMix', () {
        final result = util.alignment(Alignment.topLeft);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.alignment, Alignment.topLeft);
      });

      test('centerSlice utility creates correct ImageMix', () {
        const rect = Rect.fromLTWH(10, 10, 50, 50);
        final result = util.centerSlice(rect);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.centerSlice, rect);
      });

      test('filterQuality utility creates correct ImageMix', () {
        final result = util.filterQuality(FilterQuality.high);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.filterQuality, FilterQuality.high);
      });

      test('colorBlendMode utility creates correct ImageMix', () {
        final result = util.colorBlendMode(BlendMode.multiply);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.colorBlendMode, BlendMode.multiply);
      });

      test('semanticLabel utility creates correct ImageMix', () {
        final result = util.semanticLabel('Test Image');
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.semanticLabel, 'Test Image');
      });

      test('excludeFromSemantics utility creates correct ImageMix', () {
        final result = util.excludeFromSemantics(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.excludeFromSemantics, true);
      });

      test('gaplessPlayback utility creates correct ImageMix', () {
        final result = util.gaplessPlayback(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.gaplessPlayback, true);
      });

      test('isAntiAlias utility creates correct ImageMix', () {
        final result = util.isAntiAlias(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.isAntiAlias, true);
      });

      test('matchTextDirection utility creates correct ImageMix', () {
        final result = util.matchTextDirection(true);
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(result, isA<ImageMix>());
        expect(spec.matchTextDirection, true);
      });
    });

    group('Color utilities', () {
      test('color utility creates correct ImageMix', () {
        final result = util.color.red();
        expect(result, isA<ImageMix>());
      });

      test('color utility with specific color', () {
        final result = util.color(Colors.blue);
        expect(result, isA<ImageMix>());
      });

      test('color utility with different colors', () {
        final redResult = util.color(Colors.red);
        final greenResult = util.color(Colors.green);
        final blueResult = util.color(Colors.blue);

        expect(redResult, isA<ImageMix>());
        expect(greenResult, isA<ImageMix>());
        expect(blueResult, isA<ImageMix>());
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
      test('wrap utility creates modifier ImageMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<ImageMix>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with ImageSpecUtility creates new instance', () {
        final other = ImageSpecUtility(ImageMix(width: 150.0));
        final result = util.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<ImageSpecUtility>());
        expect(spec.width, 150.0);
      });

      test('merge with ImageMix creates new instance', () {
        final otherMix = ImageMix(height: 250.0);
        final result = util.merge(otherMix);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(util)));
        expect(result, isA<ImageSpecUtility>());
        expect(spec.height, 250.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<ImageSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        final util1 = ImageSpecUtility(ImageMix(width: 100.0, height: 200.0));
        final other = ImageSpecUtility(
          ImageMix(height: 300.0, fit: BoxFit.cover),
        );

        final result = util1.merge(other);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 300.0); // other takes precedence
        expect(spec.fit, BoxFit.cover);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns ImageSpec with resolved properties', () {
        final testUtil = ImageSpecUtility(
          ImageMix(width: 100.0, height: 200.0, fit: BoxFit.cover),
        );

        final context = MockBuildContext();
        final spec = testUtil.resolve(context);

        expect(spec, isA<ImageSpec>());
        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec, isA<ImageSpec>());
        expect(spec.width, isNull);
        expect(spec.height, isNull);
        expect(spec.fit, isNull);
      });

      test('resolve handles all properties correctly', () {
        final testUtil = ImageSpecUtility(
          ImageMix(
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
            const ImageSpec(
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
        );
      });
    });

    group('Chaining methods', () {
      test('basic width mutation test', () {
        final util = ImageSpecUtility();

        final result = util.width(100.0);
        expect(result, isA<ImageMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.width, 100.0);
      });

      test('basic height mutation test', () {
        final util = ImageSpecUtility();

        final result = util.height(200.0);
        expect(result, isA<ImageMix>());

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.height, 200.0);
      });

      test('chaining utility methods accumulates properties', () {
        final util = ImageSpecUtility();

        // Chain multiple method calls - these mutate internal state
        util.width(100.0);
        util.height(200.0);
        util.fit(BoxFit.cover);

        // Verify accumulated state through resolution
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });

      test('cascade notation works with utility methods', () {
        final util = ImageSpecUtility()
          ..width(100.0)
          ..height(200.0)
          ..fit(BoxFit.cover);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });

      test('individual utility calls return ImageMix for further chaining', () {
        final util = ImageSpecUtility();

        // Each utility call should return an ImageMix
        final widthResult = util.width(100.0);
        final heightResult = util.height(200.0);
        final fitResult = util.fit(BoxFit.cover);

        expect(widthResult, isA<ImageMix>());
        expect(heightResult, isA<ImageMix>());
        expect(fitResult, isA<ImageMix>());

        // But the utility itself should have accumulated all changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });
    });

    group('Mutating behavior vs Builder pattern', () {
      test('utility mutates internal state (not builder pattern)', () {
        final util = ImageSpecUtility();

        // Store initial resolution
        final context = MockBuildContext();
        final initialSpec = util.resolve(context);
        expect(initialSpec.width, isNull);

        // Mutate the utility
        util.width(100.0);

        // Same utility instance should now resolve with the width
        final mutatedSpec = util.resolve(context);
        expect(mutatedSpec.width, 100.0);

        // This proves it's mutating, not building new instances
      });

      test('multiple calls accumulate on same instance', () {
        final util = ImageSpecUtility();

        util.width(100.0);
        util.height(200.0);
        util.fit(BoxFit.cover);

        final context = MockBuildContext();
        final spec = util.resolve(context);

        // All properties should be present in the same instance
        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });

      test('demonstrates difference from immutable builder pattern', () {
        final util = ImageSpecUtility();

        // In a builder pattern, this would create new instances
        // In mutable pattern, this modifies the same instance
        final result1 = util.width(100.0);
        final result2 = util.height(200.0);

        // Both results are different ImageMix instances
        expect(result1, isNot(same(result2)));

        // But the utility itself has accumulated both changes
        final context = MockBuildContext();
        final spec = util.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct ImageSpec', () {
        final testUtil = ImageSpecUtility(
          ImageMix(width: 100.0, height: 200.0, fit: BoxFit.cover),
        );

        expect(
          testUtil,
          resolvesTo(
            const ImageSpec(width: 100.0, height: 200.0, fit: BoxFit.cover),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const widthToken = MixToken<double>('imageWidth');
        final context = MockBuildContext(
          tokens: {widthToken.defineValue(150.0)},
        );

        final testUtil = ImageSpecUtility(
          ImageMix.create(width: Prop.token(widthToken)),
        );
        final spec = testUtil.resolve(context);

        expect(spec.width, 150.0);
      });

      test('resolves multiple tokens', () {
        const widthToken = MixToken<double>('imageWidth');
        const heightToken = MixToken<double>('imageHeight');
        const colorToken = MixToken<Color>('imageColor');

        final context = MockBuildContext(
          tokens: {
            widthToken.defineValue(200.0),
            heightToken.defineValue(300.0),
            colorToken.defineValue(Colors.blue),
          },
        );

        final testUtil = ImageSpecUtility(
          ImageMix.create(
            width: Prop.token(widthToken),
            height: Prop.token(heightToken),
            color: Prop.token(colorToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.width, 200.0);
        expect(spec.height, 300.0);
        expect(spec.color, Colors.blue);
      });

      test('resolves enum tokens', () {
        const fitToken = MixToken<BoxFit>('imageFit');
        const repeatToken = MixToken<ImageRepeat>('imageRepeat');
        const filterQualityToken = MixToken<FilterQuality>(
          'imageFilterQuality',
        );

        final context = MockBuildContext(
          tokens: {
            fitToken.defineValue(BoxFit.cover),
            repeatToken.defineValue(ImageRepeat.repeat),
            filterQualityToken.defineValue(FilterQuality.high),
          },
        );

        final testUtil = ImageSpecUtility(
          ImageMix.create(
            fit: Prop.token(fitToken),
            repeat: Prop.token(repeatToken),
            filterQuality: Prop.token(filterQualityToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.fit, BoxFit.cover);
        expect(spec.repeat, ImageRepeat.repeat);
        expect(spec.filterQuality, FilterQuality.high);
      });

      test('resolves string and bool tokens', () {
        const labelToken = MixToken<String>('imageLabel');
        const excludeToken = MixToken<bool>('excludeFromSemantics');
        const gaplessToken = MixToken<bool>('gaplessPlayback');

        final context = MockBuildContext(
          tokens: {
            labelToken.defineValue('My Image'),
            excludeToken.defineValue(true),
            gaplessToken.defineValue(false),
          },
        );

        final testUtil = ImageSpecUtility(
          ImageMix.create(
            semanticLabel: Prop.token(labelToken),
            excludeFromSemantics: Prop.token(excludeToken),
            gaplessPlayback: Prop.token(gaplessToken),
          ),
        );
        final spec = testUtil.resolve(context);

        expect(spec.semanticLabel, 'My Image');
        expect(spec.excludeFromSemantics, true);
        expect(spec.gaplessPlayback, false);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final widthResult = util.width(100.0);
        final heightResult = util.height(200.0);
        final fitResult = util.fit(BoxFit.cover);

        expect(widthResult, isA<ImageMix>());
        expect(heightResult, isA<ImageMix>());
        expect(fitResult, isA<ImageMix>());
      });

      test('handles multiple merges correctly', () {
        final util1 = ImageSpecUtility(ImageMix(width: 100.0));
        final util2 = ImageSpecUtility(ImageMix(height: 200.0));
        final util3 = ImageSpecUtility(ImageMix(fit: BoxFit.cover));

        final result = util1.merge(util2).merge(util3);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });
    });

    group('Edge cases', () {
      test('handles empty utility', () {
        final emptyUtil = ImageSpecUtility();
        final context = MockBuildContext();
        final spec = emptyUtil.resolve(context);

        expect(spec.width, isNull);
        expect(spec.height, isNull);
        expect(spec.fit, isNull);
      });

      test('merge with self returns new instance', () {
        final testUtil = ImageSpecUtility(ImageMix(width: 100.0));
        final result = testUtil.merge(testUtil);
        final context = MockBuildContext();
        final spec = result.resolve(context);

        expect(result, isNot(same(testUtil)));
        expect(spec.width, 100.0);
      });
    });
  });
}
