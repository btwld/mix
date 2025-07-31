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
        expect(utility.mix, isA<ImageMix>());
      });

      test('creates with provided ImageMix attribute', () {
        final imageMix = ImageMix(width: 100.0);
        final utility = ImageSpecUtility(imageMix);
        
        expect(utility.mix, same(imageMix));
        expectProp(utility.mix.$width, 100.0);
      });
    });

    group('Image utility properties', () {
      test('width utility is MixUtility', () {
        expect(util.width, isA<MixUtility<ImageMix, double>>());
      });

      test('height utility is MixUtility', () {
        expect(util.height, isA<MixUtility<ImageMix, double>>());
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
        expectProp(result.$width, 100.0);
      });

      test('height utility creates correct ImageMix', () {
        final result = util.height(200.0);
        expectProp(result.$height, 200.0);
      });

      test('repeat utility creates correct ImageMix', () {
        final result = util.repeat(ImageRepeat.repeat);
        expectProp(result.$repeat, ImageRepeat.repeat);
      });

      test('fit utility creates correct ImageMix', () {
        final result = util.fit(BoxFit.cover);
        expectProp(result.$fit, BoxFit.cover);
      });

      test('alignment utility creates correct ImageMix', () {
        final result = util.alignment(Alignment.topLeft);
        expectProp(result.$alignment, Alignment.topLeft);
      });

      test('centerSlice utility creates correct ImageMix', () {
        const rect = Rect.fromLTWH(10, 10, 50, 50);
        final result = util.centerSlice(rect);
        expectProp(result.$centerSlice, rect);
      });

      test('filterQuality utility creates correct ImageMix', () {
        final result = util.filterQuality(FilterQuality.high);
        expectProp(result.$filterQuality, FilterQuality.high);
      });

      test('colorBlendMode utility creates correct ImageMix', () {
        final result = util.colorBlendMode(BlendMode.multiply);
        expectProp(result.$colorBlendMode, BlendMode.multiply);
      });

      test('semanticLabel utility creates correct ImageMix', () {
        final result = util.semanticLabel('Test Image');
        expectProp(result.$semanticLabel, 'Test Image');
      });

      test('excludeFromSemantics utility creates correct ImageMix', () {
        final result = util.excludeFromSemantics(true);
        expectProp(result.$excludeFromSemantics, true);
      });

      test('gaplessPlayback utility creates correct ImageMix', () {
        final result = util.gaplessPlayback(true);
        expectProp(result.$gaplessPlayback, true);
      });

      test('isAntiAlias utility creates correct ImageMix', () {
        final result = util.isAntiAlias(true);
        expectProp(result.$isAntiAlias, true);
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
        expect(result.$modifierConfig, isNotNull);
        expect(result.$modifierConfig!.$modifiers!.length, 1);
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

        expect(result, isNot(same(util)));
        expect(result, isA<ImageSpecUtility>());
        expectProp(result.mix.$width, 150.0);
      });

      test('merge with ImageMix creates new instance', () {
        final otherMix = ImageMix(height: 250.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<ImageSpecUtility>());
        expectProp(result.mix.$height, 250.0);
      });

      test('merge throws error for unsupported type', () {
        expect(
          () => util.merge('invalid_type' as Style<ImageSpec>),
          throwsA(isA<TypeError>()),
        );
      });

      test('merge combines properties correctly', () {
        util.mix = ImageMix(width: 100.0, height: 200.0);
        final other = ImageSpecUtility(
          ImageMix(height: 300.0, fit: BoxFit.cover),
        );
        
        final result = util.merge(other);
        
        expectProp(result.mix.$width, 100.0);
        expectProp(result.mix.$height, 300.0); // other takes precedence
        expectProp(result.mix.$fit, BoxFit.cover);
      });
    });

    group('Resolve functionality', () {
      test('resolve returns ImageSpec with resolved properties', () {
        util.mix = ImageMix(
          width: 100.0,
          height: 200.0,
          fit: BoxFit.cover,
        );
        
        final context = MockBuildContext();
        final spec = util.resolve(context);
        
        expect(spec, isA<ImageSpec>());
        expect(spec.width, 100.0);
        expect(spec.height, 200.0);
        expect(spec.fit, BoxFit.cover);
      });

      test('resolve handles null properties', () {
        final context = MockBuildContext();
        final spec = util.resolve(context);
        
        expect(spec.width, isNull);
        expect(spec.height, isNull);
        expect(spec.fit, isNull);
      });
    });

    group('Utility method behavior', () {
      test('utilities return new ImageMix instances', () {
        final result1 = util.width(100.0);
        final result2 = util.height(200.0);
        final result3 = util.fit(BoxFit.cover);
        
        expectProp(result1.$width, 100.0);
        expectProp(result2.$height, 200.0);
        expectProp(result3.$fit, BoxFit.cover);
      });
    });

    group('Integration with resolvesTo matcher', () {
      test('utility resolves to correct ImageSpec', () {
        util.mix = ImageMix(
          width: 100.0,
          height: 200.0,
          fit: BoxFit.cover,
        );
        
        expect(
          util,
          resolvesTo(
            const ImageSpec(
              width: 100.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        );
      });
    });

    group('Token support', () {
      test('resolves tokens with context', () {
        const widthToken = MixToken<double>('imageWidth');
        final context = MockBuildContext(
          mixScopeData: MixScopeData.static(tokens: {widthToken: 150.0}),
        );
        
        util.mix = ImageMix.raw(width: Prop.token(widthToken));
        final spec = util.resolve(context);
        
        expect(spec.width, 150.0);
      });
    });

    group('Complex scenarios', () {
      test('handles complex utility usage', () {
        // Test individual utility calls
        final widthResult = util.width(100.0);
        final heightResult = util.height(200.0);
        final fitResult = util.fit(BoxFit.cover);

        expectProp(widthResult.$width, 100.0);
        expectProp(heightResult.$height, 200.0);
        expectProp(fitResult.$fit, BoxFit.cover);
      });

      test('handles multiple merges correctly', () {
        final util1 = ImageSpecUtility(ImageMix(width: 100.0));
        final util2 = ImageSpecUtility(ImageMix(height: 200.0));
        final util3 = ImageSpecUtility(ImageMix(fit: BoxFit.cover));
        
        final result = util1.merge(util2).merge(util3);
        
        expectProp(result.mix.$width, 100.0);
        expectProp(result.mix.$height, 200.0);
        expectProp(result.mix.$fit, BoxFit.cover);
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
        util.mix = ImageMix(width: 100.0);
        final result = util.merge(util);
        
        expect(result, isNot(same(util)));
        expectProp(result.mix.$width, 100.0);
      });
    });
  });
}
