import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/painting/decoration_image_mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('', () {
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

        expect(decorationImageMix.$image, resolvesTo(imageProvider));
        expect(decorationImageMix.$fit, resolvesTo(BoxFit.cover));
        expect(decorationImageMix.$alignment, resolvesTo(Alignment.center));
        expect(decorationImageMix.$centerSlice, resolvesTo(centerSlice));
        expect(decorationImageMix.$repeat, resolvesTo(ImageRepeat.repeat));
        expect(
          decorationImageMix.$filterQuality,
          resolvesTo(FilterQuality.high),
        );
        expect(decorationImageMix.$invertColors, resolvesTo(true));
        expect(decorationImageMix.$isAntiAlias, resolvesTo(false));
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

        expect(decorationImageMix.$image, resolvesTo(imageProvider));
        expect(decorationImageMix.$fit, resolvesTo(BoxFit.contain));
        expect(decorationImageMix.$alignment, resolvesTo(Alignment.topLeft));
        expect(decorationImageMix.$repeat, resolvesTo(ImageRepeat.noRepeat));
        expect(
          decorationImageMix.$filterQuality,
          resolvesTo(FilterQuality.medium),
        );
      });

      test('maybeValue returns null for null input', () {
        final result = DecorationImageMix.maybeValue(null);
        expect(result, isNull);
      });

      test('', () {
        const decorationImage = DecorationImage(
          image: AssetImage('assets/test.png'),
        );
        final result = DecorationImageMix.maybeValue(decorationImage);

        expect(result, isNotNull);
        expect(result!.$image, resolvesTo(const AssetImage('assets/test.png')));
      });
    });

    group('Factory Constructors', () {
      test('', () {
        const testImageProvider = AssetImage('test_image.png');
        final decorationImageMix = DecorationImageMix.image(testImageProvider);

        expect(decorationImageMix.$image, resolvesTo(testImageProvider));
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.fit(BoxFit.contain);

        expect(decorationImageMix.$fit, resolvesTo(BoxFit.contain));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.alignment(
          Alignment.topLeft,
        );

        expect(decorationImageMix.$alignment, resolvesTo(Alignment.topLeft));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        const rect = Rect.fromLTWH(5, 5, 10, 10);
        final decorationImageMix = DecorationImageMix.centerSlice(rect);

        expect(decorationImageMix.$centerSlice, resolvesTo(rect));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.repeat(
          ImageRepeat.repeatX,
        );

        expect(decorationImageMix.$repeat, resolvesTo(ImageRepeat.repeatX));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.filterQuality(
          FilterQuality.low,
        );

        expect(
          decorationImageMix.$filterQuality,
          resolvesTo(FilterQuality.low),
        );
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$invertColors, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.invertColors(true);

        expect(decorationImageMix.$invertColors, resolvesTo(true));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$isAntiAlias, isNull);
      });

      test('', () {
        final decorationImageMix = DecorationImageMix.isAntiAlias(true);

        expect(decorationImageMix.$isAntiAlias, resolvesTo(true));
        expect(decorationImageMix.$image, isNull);
        expect(decorationImageMix.$fit, isNull);
        expect(decorationImageMix.$alignment, isNull);
        expect(decorationImageMix.$centerSlice, isNull);
        expect(decorationImageMix.$repeat, isNull);
        expect(decorationImageMix.$filterQuality, isNull);
        expect(decorationImageMix.$invertColors, isNull);
      });
    });

    group('Utility Methods', () {
      test('image utility works correctly', () {
        const testImageProvider = AssetImage('test_image.png');
        final decorationImageMix = DecorationImageMix().image(
          testImageProvider,
        );

        expect(decorationImageMix.$image, resolvesTo(testImageProvider));
      });

      test('fit utility works correctly', () {
        final decorationImageMix = DecorationImageMix().fit(BoxFit.fitWidth);

        expect(decorationImageMix.$fit, resolvesTo(BoxFit.fitWidth));
      });

      test('alignment utility works correctly', () {
        final decorationImageMix = DecorationImageMix().alignment(
          Alignment.centerLeft,
        );

        expect(decorationImageMix.$alignment, resolvesTo(Alignment.centerLeft));
      });

      test('centerSlice utility works correctly', () {
        const rect = Rect.fromLTWH(8, 8, 16, 16);
        final decorationImageMix = DecorationImageMix().centerSlice(rect);

        expect(decorationImageMix.$centerSlice, resolvesTo(rect));
      });

      test('repeat utility works correctly', () {
        final decorationImageMix = DecorationImageMix().repeat(
          ImageRepeat.noRepeat,
        );

        expect(decorationImageMix.$repeat, resolvesTo(ImageRepeat.noRepeat));
      });

      test('filterQuality utility works correctly', () {
        final decorationImageMix = DecorationImageMix().filterQuality(
          FilterQuality.none,
        );

        expect(
          decorationImageMix.$filterQuality,
          resolvesTo(FilterQuality.none),
        );
      });

      test('invertColors utility works correctly', () {
        final decorationImageMix = DecorationImageMix().invertColors(false);

        expect(decorationImageMix.$invertColors, resolvesTo(false));
      });

      test('isAntiAlias utility works correctly', () {
        final decorationImageMix = DecorationImageMix().isAntiAlias(false);

        expect(decorationImageMix.$isAntiAlias, resolvesTo(false));
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
          filterQuality: FilterQuality.medium, // default
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

        expect(merged.$image, resolvesTo(imageProvider2)); // overridden
        expect(merged.$fit, resolvesTo(BoxFit.cover)); // preserved
        expect(merged.$alignment, resolvesTo(Alignment.center)); // preserved
        expect(merged.$repeat, resolvesTo(ImageRepeat.repeat)); // new
        expect(merged.$filterQuality, resolvesTo(FilterQuality.high)); // new
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
