import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('DecorationImageUtility', () {
    late DecorationImageUtility<MockStyle<DecorationImageMix>> util;

    setUp(() {
      util = DecorationImageUtility<MockStyle<DecorationImageMix>>(
        MockStyle.new,
      );
    });

    group('utility properties', () {
      test('has provider utility', () {
        expect(util.provider, isA<MixUtility>());
      });

      test('has fit utility', () {
        expect(util.fit, isA<MixUtility>());
      });

      test('has alignment utility', () {
        expect(util.alignment, isA<MixUtility>());
      });

      test('has centerSlice utility', () {
        expect(util.centerSlice, isA<MixUtility>());
      });

      test('has repeat utility', () {
        expect(util.repeat, isA<MixUtility>());
      });

      test('has filterQuality utility', () {
        expect(util.filterQuality, isA<MixUtility>());
      });

      test('has invertColors utility', () {
        expect(util.invertColors, isA<Function>());
      });

      test('has isAntiAlias utility', () {
        expect(util.isAntiAlias, isA<Function>());
      });
    });

    group('property setters', () {
      test('provider sets image provider', () {
        const provider = NetworkImage('https://example.com/image.png');
        final result = util.provider(provider);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(decorationImage, const DecorationImage(image: provider));
      });

      test('fit sets box fit', () {
        final provider = mockImageProvider();
        final result = util(image: provider, fit: BoxFit.cover);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, fit: BoxFit.cover),
        );
      });

      test('alignment sets alignment geometry', () {
        final provider = mockImageProvider();
        final result = util(image: provider, alignment: Alignment.topRight);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, alignment: Alignment.topRight),
        );
      });

      test('centerSlice sets center slice rect', () {
        const rect = Rect.fromLTWH(10, 10, 20, 20);
        final provider = mockImageProvider();
        final result = util(image: provider, centerSlice: rect);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, centerSlice: rect),
        );
      });

      test('repeat sets image repeat', () {
        final provider = mockImageProvider();
        final result = util(image: provider, repeat: ImageRepeat.repeatX);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, repeat: ImageRepeat.repeatX),
        );
      });

      test('filterQuality sets filter quality', () {
        final provider = mockImageProvider();
        final result = util(image: provider, filterQuality: FilterQuality.high);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, filterQuality: FilterQuality.high),
        );
      });

      test('invertColors sets invert colors flag', () {
        final provider = mockImageProvider();
        final result = util(image: provider, invertColors: true);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, invertColors: true),
        );
      });

      test('isAntiAlias sets anti-alias flag', () {
        final provider = mockImageProvider();
        final result = util(image: provider, isAntiAlias: true);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(image: provider, isAntiAlias: true),
        );
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        const provider = AssetImage('assets/test.png');
        const rect = Rect.fromLTWH(5, 5, 10, 10);

        final result = util(
          image: provider,
          fit: BoxFit.fitHeight,
          alignment: Alignment.bottomLeft,
          centerSlice: rect,
          repeat: ImageRepeat.repeatY,
          filterQuality: FilterQuality.medium,
          invertColors: false,
          isAntiAlias: false,
        );

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          const DecorationImage(
            image: provider,
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomLeft,
            centerSlice: rect,
            repeat: ImageRepeat.repeatY,
            filterQuality: FilterQuality.medium,
            invertColors: false,
            isAntiAlias: false,
          ),
        );
      });

      test('sets partial properties', () {
        final provider = MemoryImage(Uint8List.fromList([1, 2, 3, 4]));

        final result = util(
          image: provider,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          DecorationImage(
            image: provider,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        );
      });

      test('handles null values', () {
        final result = util();

        expect(
          () => result.value.resolve(MockBuildContext()),
          throwsStateError,
        );
      });
    });

    group('call method', () {
      test('delegates to only method with all parameters', () {
        const provider = NetworkImage('https://example.com/test.jpg');
        const rect = Rect.fromLTWH(0, 0, 50, 50);

        final result = util(
          image: provider,
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          centerSlice: rect,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.low,
          invertColors: true,
          isAntiAlias: true,
        );

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          const DecorationImage(
            image: provider,
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            centerSlice: rect,
            repeat: ImageRepeat.repeat,
            filterQuality: FilterQuality.low,
            invertColors: true,
            isAntiAlias: true,
          ),
        );
      });

      test('handles partial parameters', () {
        const provider = AssetImage('assets/partial.png');

        final result = util(image: provider, fit: BoxFit.fill);

        final decorationImage = result.value.resolve(MockBuildContext());

        expect(
          decorationImage,
          const DecorationImage(image: provider, fit: BoxFit.fill),
        );
      });
    });

    group('as method', () {
      test('accepts DecorationImage', () {
        const provider = NetworkImage('https://example.com/as-test.png');
        const rect = Rect.fromLTWH(2, 2, 8, 8);

        const decorationImage = DecorationImage(
          image: provider,
          fit: BoxFit.fitWidth,
          alignment: Alignment.centerRight,
          centerSlice: rect,
          repeat: ImageRepeat.noRepeat,
          filterQuality: FilterQuality.none,
          invertColors: false,
          isAntiAlias: true,
        );

        final result = util.as(decorationImage);

        expect(
          result.value,
          DecorationImageMix(
            image: provider,
            fit: BoxFit.fitWidth,
            alignment: Alignment.centerRight,
            centerSlice: rect,
            repeat: ImageRepeat.noRepeat,
            filterQuality: FilterQuality.none,
            invertColors: false,
            isAntiAlias: true,
          ),
        );
      });

      test('handles minimal DecorationImage', () {
        const provider = AssetImage('assets/minimal.png');
        const decorationImage = DecorationImage(image: provider);

        final result = util.as(decorationImage);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved.image, provider);
      });
    });

    group('property combinations', () {
      test('can combine different properties', () {
        const provider = NetworkImage('https://example.com/combo.png');

        final providerResult = util.provider(provider);
        final fitResult = util(image: provider, fit: BoxFit.cover);
        final alignmentResult = util(
          image: provider,
          alignment: Alignment.bottomRight,
        );

        final providerImage = providerResult.value.resolve(MockBuildContext());
        final fitImage = fitResult.value.resolve(MockBuildContext());
        final alignmentImage = alignmentResult.value.resolve(
          MockBuildContext(),
        );

        expect(providerImage.image, provider);
        expect(fitImage.fit, BoxFit.cover);
        expect(alignmentImage.alignment, Alignment.bottomRight);
      });
    });

    group('edge cases', () {
      test('handles different image provider types', () {
        const networkProvider = NetworkImage('https://example.com/network.png');
        const assetProvider = AssetImage('assets/asset.png');
        final memoryProvider = MemoryImage(Uint8List.fromList([1, 2, 3, 4]));

        final networkResult = util.provider(networkProvider);
        final assetResult = util.provider(assetProvider);
        final memoryResult = util.provider(memoryProvider);

        final networkImage = networkResult.value.resolve(MockBuildContext());
        final assetImage = assetResult.value.resolve(MockBuildContext());
        final memoryImage = memoryResult.value.resolve(MockBuildContext());

        expect(networkImage.image, networkProvider);
        expect(assetImage.image, assetProvider);
        expect(memoryImage.image, memoryProvider);
      });

      test('handles all BoxFit values', () {
        final provider = mockImageProvider();
        for (final boxFit in BoxFit.values) {
          final result = util(image: provider, fit: boxFit);
          final decorationImage = result.value.resolve(MockBuildContext());
          expect(decorationImage.fit, boxFit);
        }
      });

      test('handles all ImageRepeat values', () {
        final provider = mockImageProvider();
        final imageRepeats = [
          ImageRepeat.repeat,
          ImageRepeat.repeatX,
          ImageRepeat.repeatY,
          ImageRepeat.noRepeat,
        ];

        for (final imageRepeat in imageRepeats) {
          final result = util(image: provider, repeat: imageRepeat);
          final decorationImage = result.value.resolve(MockBuildContext());
          expect(decorationImage.repeat, imageRepeat);
        }
      });

      test('handles all FilterQuality values', () {
        final provider = mockImageProvider();
        for (final filterQuality in FilterQuality.values) {
          final result = util(image: provider, filterQuality: filterQuality);
          final decorationImage = result.value.resolve(MockBuildContext());
          expect(decorationImage.filterQuality, filterQuality);
        }
      });

      test('handles boolean properties', () {
        final provider = mockImageProvider();
        final result1 = util(image: provider, invertColors: true);
        final result2 = util(image: provider, isAntiAlias: false);

        final image1 = result1.value.resolve(MockBuildContext());
        final image2 = result2.value.resolve(MockBuildContext());

        expect(image1.invertColors, true);
        expect(image2.isAntiAlias, false);
      });
    });
  });
}
