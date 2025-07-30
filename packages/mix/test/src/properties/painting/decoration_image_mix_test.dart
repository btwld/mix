import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/painting/decoration_image_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('DecorationImageMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        const imageProvider = AssetImage('assets/test.png');
        const centerSlice = Rect.fromLTWH(10, 10, 20, 20);

        final decorationImageMix = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: centerSlice,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        expectProp(decorationImageMix.$image, imageProvider);
        expectProp(decorationImageMix.$fit, BoxFit.cover);
        expectProp(decorationImageMix.$alignment, Alignment.center);
        expectProp(decorationImageMix.$centerSlice, centerSlice);
        expectProp(decorationImageMix.$repeat, ImageRepeat.repeat);
        expectProp(decorationImageMix.$filterQuality, FilterQuality.high);
        expectProp(decorationImageMix.$invertColors, true);
        expectProp(decorationImageMix.$isAntiAlias, false);
      });

      test('value constructor extracts properties from DecorationImage', () {
        const imageProvider = AssetImage('assets/test.png');
        const decorationImage = DecorationImage(
          image: imageProvider,
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
          repeat: ImageRepeat.noRepeat,
          filterQuality: FilterQuality.medium,
        );

        final decorationImageMix = DecorationImageMix.value(decorationImage);

        expectProp(decorationImageMix.$image, imageProvider);
        expectProp(decorationImageMix.$fit, BoxFit.contain);
        expectProp(decorationImageMix.$alignment, Alignment.topLeft);
        expectProp(decorationImageMix.$repeat, ImageRepeat.noRepeat);
        expectProp(decorationImageMix.$filterQuality, FilterQuality.medium);
      });

      test('maybeValue returns null for null input', () {
        final result = DecorationImageMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns DecorationImageMix for non-null input', () {
        const decorationImage = DecorationImage(
          image: AssetImage('assets/test.png'),
        );
        final result = DecorationImageMix.maybeValue(decorationImage);

        expect(result, isNotNull);
        expectProp(result!.$image, const AssetImage('assets/test.png'));
      });
    });

    group('Factory Constructors', () {
      test('image factory creates DecorationImageMix with image', () {
        const testImageProvider = AssetImage('test_image.png');
        final decorationImageMix = DecorationImageMix.image(testImageProvider);

        expectProp(decorationImageMix.$image, testImageProvider);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('fit factory creates DecorationImageMix with fit', () {
        final decorationImageMix = DecorationImageMix.fit(BoxFit.contain);

        expectProp(decorationImageMix.$fit, BoxFit.contain);
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('alignment factory creates DecorationImageMix with alignment', () {
        final decorationImageMix = DecorationImageMix.alignment(
          Alignment.topLeft,
        );

        expectProp(decorationImageMix.$alignment, Alignment.topLeft);
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test(
        'centerSlice factory creates DecorationImageMix with centerSlice',
        () {
          const rect = Rect.fromLTWH(5, 5, 10, 10);
          final decorationImageMix = DecorationImageMix.centerSlice(rect);

          expectProp(decorationImageMix.$centerSlice, rect);
          expect(decorationImageMix.$image, isNull);
          expect(decorationImageMix.$fit, isNull);
          expect(decorationImageMix.$alignment, isNull);
          expect(decorationImageMix.$repeat, isNull);
          expect(decorationImageMix.$filterQuality, isNull);
          expect(decorationImageMix.$invertColors, isNull);
          expect(decorationImageMix.$isAntiAlias, isNull);
        },
      );

      test('repeat factory creates DecorationImageMix with repeat', () {
        final decorationImageMix = DecorationImageMix.repeat(
          ImageRepeat.repeatX,
        );

        expectProp(decorationImageMix.$repeat, ImageRepeat.repeatX);
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test(
        'filterQuality factory creates DecorationImageMix with filterQuality',
        () {
          final decorationImageMix = DecorationImageMix.filterQuality(
            FilterQuality.low,
          );

          expectProp(decorationImageMix.$filterQuality, FilterQuality.low);
          expect(decorationImageMix.$image, isNull);
          expect(decorationImageMix.$fit, isNull);
          expect(decorationImageMix.$alignment, isNull);
          expect(decorationImageMix.$centerSlice, isNull);
          expect(decorationImageMix.$repeat, isNull);
          expect(decorationImageMix.$invertColors, isNull);
          expect(decorationImageMix.$isAntiAlias, isNull);
        },
      );

      test(
        'invertColors factory creates DecorationImageMix with invertColors',
        () {
          final decorationImageMix = DecorationImageMix.invertColors(true);

          expectProp(decorationImageMix.$invertColors, true);
          expect(decorationImageMix.$image, isNull);
          expect(decorationImageMix.$fit, isNull);
          expect(decorationImageMix.$alignment, isNull);
          expect(decorationImageMix.$centerSlice, isNull);
          expect(decorationImageMix.$repeat, isNull);
          expect(decorationImageMix.$filterQuality, isNull);
          expect(decorationImageMix.$isAntiAlias, isNull);
        },
      );

      test(
        'isAntiAlias factory creates DecorationImageMix with isAntiAlias',
        () {
          final decorationImageMix = DecorationImageMix.isAntiAlias(true);

          expectProp(decorationImageMix.$isAntiAlias, true);
          expect(decorationImageMix.$image, isNull);
          expect(decorationImageMix.$fit, isNull);
          expect(decorationImageMix.$alignment, isNull);
          expect(decorationImageMix.$centerSlice, isNull);
          expect(decorationImageMix.$repeat, isNull);
          expect(decorationImageMix.$filterQuality, isNull);
          expect(decorationImageMix.$invertColors, isNull);
        },
      );
    });

    group('Utility Methods', () {
      test('image utility works correctly', () {
        const testImageProvider = AssetImage('test_image.png');
        final decorationImageMix = DecorationImageMix().image(
          testImageProvider,
        );

        expectProp(decorationImageMix.$image, testImageProvider);
      });

      test('fit utility works correctly', () {
        final decorationImageMix = DecorationImageMix().fit(BoxFit.fitWidth);

        expectProp(decorationImageMix.$fit, BoxFit.fitWidth);
      });

      test('alignment utility works correctly', () {
        final decorationImageMix = DecorationImageMix().alignment(
          Alignment.centerLeft,
        );

        expectProp(decorationImageMix.$alignment, Alignment.centerLeft);
      });

      test('centerSlice utility works correctly', () {
        const rect = Rect.fromLTWH(8, 8, 16, 16);
        final decorationImageMix = DecorationImageMix().centerSlice(rect);

        expectProp(decorationImageMix.$centerSlice, rect);
      });

      test('repeat utility works correctly', () {
        final decorationImageMix = DecorationImageMix().repeat(
          ImageRepeat.noRepeat,
        );

        expectProp(decorationImageMix.$repeat, ImageRepeat.noRepeat);
      });

      test('filterQuality utility works correctly', () {
        final decorationImageMix = DecorationImageMix().filterQuality(
          FilterQuality.none,
        );

        expectProp(decorationImageMix.$filterQuality, FilterQuality.none);
      });

      test('invertColors utility works correctly', () {
        final decorationImageMix = DecorationImageMix().invertColors(false);

        expectProp(decorationImageMix.$invertColors, false);
      });

      test('isAntiAlias utility works correctly', () {
        final decorationImageMix = DecorationImageMix().isAntiAlias(false);

        expectProp(decorationImageMix.$isAntiAlias, false);
      });
    });

    group('resolve', () {
      test('resolves to DecorationImage with correct properties', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        const resolvedValue = DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        expect(decorationImageMix, resolvesTo(resolvedValue));
      });

      test('uses default values for null properties', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
        );

        const resolvedValue = DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center, // default
          repeat: ImageRepeat.noRepeat, // default
          filterQuality: FilterQuality.low, // default
          invertColors: false, // default
          isAntiAlias: false, // default
        );

        expect(decorationImageMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final decorationImageMix = DecorationImageMix(
          image: const AssetImage('assets/test.png'),
        );
        final merged = decorationImageMix.merge(null);

        expect(merged, same(decorationImageMix));
      });

      test('merges properties correctly', () {
        const imageProvider1 = AssetImage('assets/test1.png');
        const imageProvider2 = AssetImage('assets/test2.png');

        final first = DecorationImageMix(
          image: imageProvider1,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        final second = DecorationImageMix(
          image: imageProvider2,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
        );

        final merged = first.merge(second);

        expectProp(merged.$image, imageProvider2); // overridden
        expectProp(merged.$fit, BoxFit.cover); // preserved
        expectProp(merged.$alignment, Alignment.center); // preserved
        expectProp(merged.$repeat, ImageRepeat.repeat); // new
        expectProp(merged.$filterQuality, FilterQuality.high); // new
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix1 = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        final decorationImageMix2 = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        expect(decorationImageMix1, decorationImageMix2);
        expect(decorationImageMix1.hashCode, decorationImageMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final decorationImageMix1 = DecorationImageMix(
          image: const AssetImage('assets/test1.png'),
        );
        final decorationImageMix2 = DecorationImageMix(
          image: const AssetImage('assets/test2.png'),
        );

        expect(decorationImageMix1, isNot(decorationImageMix2));
      });

      test('handles complex property differences', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix1 = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.cover,
        );
        final decorationImageMix2 = DecorationImageMix(
          image: imageProvider,
          fit: BoxFit.contain,
        );

        expect(decorationImageMix1, isNot(decorationImageMix2));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        const testImageProvider = AssetImage('test_image.png');
        final decorationImageMix = DecorationImageMix(
          image: testImageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: const Rect.fromLTWH(10, 10, 20, 20),
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        expect(decorationImageMix.props.length, 8);
        expect(decorationImageMix.props, contains(decorationImageMix.$image));
        expect(decorationImageMix.props, contains(decorationImageMix.$fit));
        expect(
          decorationImageMix.props,
          contains(decorationImageMix.$alignment),
        );
        expect(
          decorationImageMix.props,
          contains(decorationImageMix.$centerSlice),
        );
        expect(decorationImageMix.props, contains(decorationImageMix.$repeat));
        expect(
          decorationImageMix.props,
          contains(decorationImageMix.$filterQuality),
        );
        expect(
          decorationImageMix.props,
          contains(decorationImageMix.$invertColors),
        );
        expect(
          decorationImageMix.props,
          contains(decorationImageMix.$isAntiAlias),
        );
      });
    });
  });
}
