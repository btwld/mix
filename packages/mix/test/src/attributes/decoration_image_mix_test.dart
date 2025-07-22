import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('DecorationImageMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        const imageProvider = AssetImage('assets/test.png');
        const centerSlice = Rect.fromLTWH(10, 10, 20, 20);

        final decorationImageMix = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: centerSlice,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        expect(decorationImageMix.image, isProp(imageProvider));
        expect(decorationImageMix.fit, isProp(BoxFit.cover));
        expect(decorationImageMix.alignment, isProp(Alignment.center));
        expect(decorationImageMix.centerSlice, isProp(centerSlice));
        expect(decorationImageMix.repeat, isProp(ImageRepeat.repeat));
        expect(decorationImageMix.filterQuality, isProp(FilterQuality.high));
        expect(decorationImageMix.invertColors, isProp(true));
        expect(decorationImageMix.isAntiAlias, isProp(false));
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

        expect(decorationImageMix.image, isProp(imageProvider));
        expect(decorationImageMix.fit, isProp(BoxFit.contain));
        expect(decorationImageMix.alignment, isProp(Alignment.topLeft));
        expect(decorationImageMix.repeat, isProp(ImageRepeat.noRepeat));
        expect(decorationImageMix.filterQuality, isProp(FilterQuality.medium));
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
        expect(result!.image, isProp(const AssetImage('assets/test.png')));
      });
    });

    group('resolve', () {
      test('resolves to DecorationImage with correct properties', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
          invertColors: true,
          isAntiAlias: false,
        );

        final context = MockBuildContext();
        final resolved = decorationImageMix.resolve(context);

        expect(resolved.image, imageProvider);
        expect(resolved.fit, BoxFit.cover);
        expect(resolved.alignment, Alignment.center);
        expect(resolved.repeat, ImageRepeat.repeat);
        expect(resolved.filterQuality, FilterQuality.high);
        expect(resolved.invertColors, true);
        expect(resolved.isAntiAlias, false);
      });

      test('uses default values for null properties', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
        );

        final context = MockBuildContext();
        final resolved = decorationImageMix.resolve(context);

        expect(resolved.image, imageProvider);
        expect(resolved.fit, BoxFit.cover);
        expect(resolved.alignment, Alignment.center); // default
        expect(resolved.repeat, ImageRepeat.noRepeat); // default
        expect(resolved.filterQuality, FilterQuality.low); // default
        expect(resolved.invertColors, false); // default
        expect(resolved.isAntiAlias, false); // default
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final decorationImageMix = DecorationImageMix.only(
          image: const AssetImage('assets/test.png'),
        );
        final merged = decorationImageMix.merge(null);

        expect(merged, same(decorationImageMix));
      });

      test('merges properties correctly', () {
        const imageProvider1 = AssetImage('assets/test1.png');
        const imageProvider2 = AssetImage('assets/test2.png');

        final first = DecorationImageMix.only(
          image: imageProvider1,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        final second = DecorationImageMix.only(
          image: imageProvider2,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
        );

        final merged = first.merge(second);

        expect(merged.image, isProp(imageProvider2)); // overridden
        expect(merged.fit, isProp(BoxFit.cover)); // preserved
        expect(merged.alignment, isProp(Alignment.center)); // preserved
        expect(merged.repeat, isProp(ImageRepeat.repeat)); // new
        expect(merged.filterQuality, isProp(FilterQuality.high)); // new
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix1 = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        final decorationImageMix2 = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );

        expect(decorationImageMix1, decorationImageMix2);
        expect(decorationImageMix1.hashCode, decorationImageMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final decorationImageMix1 = DecorationImageMix.only(
          image: const AssetImage('assets/test1.png'),
        );
        final decorationImageMix2 = DecorationImageMix.only(
          image: const AssetImage('assets/test2.png'),
        );

        expect(decorationImageMix1, isNot(decorationImageMix2));
      });

      test('handles complex property differences', () {
        const imageProvider = AssetImage('assets/test.png');
        final decorationImageMix1 = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.cover,
        );
        final decorationImageMix2 = DecorationImageMix.only(
          image: imageProvider,
          fit: BoxFit.contain,
        );

        expect(decorationImageMix1, isNot(decorationImageMix2));
      });
    });
  });
}
