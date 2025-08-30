import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexStyleSpecUtility', () {
    group('Constructor', () {
      test('', () {
        final attribute = ImageStyler(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
          semanticLabel: 'Test image',
          excludeFromSemantics: true,
          gaplessPlayback: true,
          isAntiAlias: false,
          matchTextDirection: true,
        );

        expect(attribute.$width, resolvesTo(100.0));
        expect(attribute.$height, resolvesTo(200.0));
        expect(attribute.$color, resolvesTo(Colors.red));
        expect(attribute.$repeat, resolvesTo(ImageRepeat.repeat));
        expect(attribute.$fit, resolvesTo(BoxFit.cover));
        expect(attribute.$alignment, resolvesTo(Alignment.center));
        expect(
          attribute.$centerSlice,
          resolvesTo(Rect.fromLTWH(10, 10, 20, 20)),
        );
        expect(attribute.$filterQuality, resolvesTo(FilterQuality.high));
        expect(attribute.$colorBlendMode, resolvesTo(BlendMode.multiply));
        expect(attribute.$semanticLabel, resolvesTo('Test image'));
        expect(attribute.$excludeFromSemantics, resolvesTo(true));
        expect(attribute.$gaplessPlayback, resolvesTo(true));
        expect(attribute.$isAntiAlias, resolvesTo(false));
        expect(attribute.$matchTextDirection, resolvesTo(true));
      });

      test('', () {
        final attribute = ImageStyler();

        expect(attribute.$width, isNull);
        expect(attribute.$height, isNull);
        expect(attribute.$color, isNull);
        expect(attribute.$repeat, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$alignment, isNull);
        expect(attribute.$centerSlice, isNull);
        expect(attribute.$filterQuality, isNull);
        expect(attribute.$colorBlendMode, isNull);
        expect(attribute.$semanticLabel, isNull);
        expect(attribute.$excludeFromSemantics, isNull);
        expect(attribute.$gaplessPlayback, isNull);
        expect(attribute.$isAntiAlias, isNull);
        expect(attribute.$matchTextDirection, isNull);
      });
    });

    group('Factory Constructors', () {
      test('', () {
        final imageMix = ImageStyler().width(150.0);

        expect(imageMix.$width, resolvesTo(150.0));
      });

      test('', () {
        final imageMix = ImageStyler().height(250.0);

        expect(imageMix.$height, resolvesTo(250.0));
      });

      test('', () {
        final imageMix = ImageStyler().color(Colors.blue);

        expect(imageMix.$color, resolvesTo(Colors.blue));
      });

      test('', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final imageMix = ImageStyler().animate(animation);

        expect(imageMix.$animation, animation);
      });

      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = ImageStyler().color(Colors.white);
        final imageMix = ImageStyler().variant(variant, style);

        expect(imageMix.$variants, isNotNull);
        expect(imageMix.$variants!.length, 1);
      });

      test('', () {
        final imageMix = ImageStyler().semanticLabel('My Image');

        expect(imageMix.$semanticLabel, resolvesTo('My Image'));
      });

      test('', () {
        final imageMix = ImageStyler().excludeFromSemantics(true);

        expect(imageMix.$excludeFromSemantics, resolvesTo(true));
      });

      test('', () {
        final imageMix = ImageStyler().gaplessPlayback(true);

        expect(imageMix.$gaplessPlayback, resolvesTo(true));
      });

      test('', () {
        final imageMix = ImageStyler().isAntiAlias(false);

        expect(imageMix.$isAntiAlias, resolvesTo(false));
      });

      test('', () {
        final imageMix = ImageStyler().matchTextDirection(true);

        expect(imageMix.$matchTextDirection, resolvesTo(true));
      });
    });

    group('Utility Methods', () {
      test('width utility works correctly', () {
        final attribute = ImageStyler().width(200.0);

        expect(attribute.$width, resolvesTo(200.0));
      });

      test('height utility works correctly', () {
        final attribute = ImageStyler().height(300.0);

        expect(attribute.$height, resolvesTo(300.0));
      });

      test('color utility works correctly', () {
        final attribute = ImageStyler().color(Colors.purple);

        expect(attribute.$color, resolvesTo(Colors.purple));
      });

      test('repeat utility works correctly', () {
        final attribute = ImageStyler().repeat(ImageRepeat.repeatX);

        expect(attribute.$repeat, resolvesTo(ImageRepeat.repeatX));
      });

      test('fit utility works correctly', () {
        final attribute = ImageStyler().fit(BoxFit.fill);

        expect(attribute.$fit, resolvesTo(BoxFit.fill));
      });

      test('alignment utility works correctly', () {
        final attribute = ImageStyler().alignment(Alignment.topLeft);

        expect(attribute.$alignment, resolvesTo(Alignment.topLeft));
      });

      test('centerSlice utility works correctly', () {
        final rect = Rect.fromLTWH(5, 5, 10, 10);
        final attribute = ImageStyler().centerSlice(rect);

        expect(attribute.$centerSlice, resolvesTo(rect));
      });

      test('filterQuality utility works correctly', () {
        final attribute = ImageStyler().filterQuality(FilterQuality.medium);

        expect(attribute.$filterQuality, resolvesTo(FilterQuality.medium));
      });

      test('colorBlendMode utility works correctly', () {
        final attribute = ImageStyler().colorBlendMode(BlendMode.overlay);

        expect(attribute.$colorBlendMode, resolvesTo(BlendMode.overlay));
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = ImageStyler().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = ImageStyler().color(Colors.white);
        final imageMix = ImageStyler().variant(variant, style);

        expect(imageMix.$variants, isNotNull);
        expect(imageMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            ImageStyler().color(Colors.white),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            ImageStyler().color(Colors.black),
          ),
        ];
        final imageMix = ImageStyler().variants(variants);

        expect(imageMix.$variants, isNotNull);
        expect(imageMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('', () {
        final attribute = ImageStyler(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.spec.width, 100.0);
        expect(spec.spec.height, 200.0);
        expect(spec.spec.color, Colors.red);
        expect(spec.spec.repeat, ImageRepeat.repeat);
        expect(spec.spec.fit, BoxFit.cover);
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.centerSlice, Rect.fromLTWH(10, 10, 20, 20));
        expect(spec.spec.filterQuality, FilterQuality.high);
        expect(spec.spec.colorBlendMode, BlendMode.multiply);
      });

      test('resolves with null values correctly', () {
        final attribute = ImageStyler().width(150.0).height(250.0);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.spec.width, 150.0);
        expect(spec.spec.height, 250.0);
        expect(spec.spec.color, isNull);
        expect(spec.spec.repeat, isNull);
        expect(spec.spec.fit, isNull);
        expect(spec.spec.alignment, isNull);
        expect(spec.spec.centerSlice, isNull);
        expect(spec.spec.filterQuality, isNull);
        expect(spec.spec.colorBlendMode, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = ImageStyler(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
        );

        final second = ImageStyler(
          width: 150.0,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        final merged = first.merge(second);

        expect(merged.$width, resolvesTo(150.0)); // second overrides
        expect(merged.$height, resolvesTo(200.0)); // from first
        expect(merged.$color, resolvesTo(Colors.red)); // from first
        expect(merged.$fit, resolvesTo(BoxFit.cover)); // from second
        expect(merged.$alignment, resolvesTo(Alignment.center)); // from second
      });

      test('returns this when other is null', () {
        final attribute = ImageStyler().width(100.0);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isFalse);
        expect(merged, equals(attribute));
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = ImageStyler()
            .width(100.0)
            .height(200.0)
            .color(Colors.blue);

        final attr2 = ImageStyler()
            .width(100.0)
            .height(200.0)
            .color(Colors.blue);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = ImageStyler().width(100.0);
        final attr2 = ImageStyler().width(200.0);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = ImageStyler(
          width: 100.0,
          height: 200.0,
          color: Colors.red,
          image: AssetImage('test_image.png'),
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        expect(attribute.props.length, 18);
        expect(attribute.props, contains(attribute.$width));
        expect(attribute.props, contains(attribute.$height));
        expect(attribute.props, contains(attribute.$color));
        expect(attribute.props, contains(attribute.$repeat));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$image));
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$centerSlice));
        expect(attribute.props, contains(attribute.$filterQuality));
        expect(attribute.props, contains(attribute.$colorBlendMode));
      });
    });
  });
}
