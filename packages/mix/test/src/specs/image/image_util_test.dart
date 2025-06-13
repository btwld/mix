import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('ImageUtility', () {
    final imageUtility = ImageSpecUtility(MixUtility.selfBuilder);

    test('only() returns correct instance', () {
      final image = imageUtility.only(
        width: 100.0,
        height: 200.0,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        repeat: ImageRepeat.noRepeat,
        centerSlice: const Rect.fromLTWH(10, 10, 80, 80),
        filterQuality: FilterQuality.high,
        color: const ColorDto(Colors.red),
        colorBlendMode: BlendMode.multiply,
      );

      expect(image.width, 100.0);
      expect(image.height, 200.0);
      expect(image.fit, BoxFit.cover);
      expect(image.alignment, Alignment.center);
      expect(image.repeat, ImageRepeat.noRepeat);
      expect(image.centerSlice, const Rect.fromLTWH(10, 10, 80, 80));
      expect(image.filterQuality, FilterQuality.high);
      expect(image.color, const ColorDto(Colors.red));
      expect(image.colorBlendMode, BlendMode.multiply);
    });

    test('width() returns correct instance', () {
      final image = imageUtility.width(150.0);
      expect(image.width, 150.0);
    });

    test('height() returns correct instance', () {
      final image = imageUtility.height(250.0);
      expect(image.height, 250.0);
    });

    test('fit() returns correct instance', () {
      final image = imageUtility.fit(BoxFit.contain);
      expect(image.fit, BoxFit.contain);
    });

    test('alignment utility returns correct instance', () {
      final image = imageUtility.alignment(Alignment.topLeft);
      expect(image.alignment, Alignment.topLeft);
    });

    test('repeat utility returns correct instance', () {
      final image = imageUtility.repeat(ImageRepeat.repeatX);
      expect(image.repeat, ImageRepeat.repeatX);
    });

    test('centerSlice utility returns correct instance', () {
      const slice = Rect.fromLTWH(5, 5, 90, 90);
      final image = imageUtility.centerSlice(slice);
      expect(image.centerSlice, slice);
    });

    test('filterQuality utility returns correct instance', () {
      final image = imageUtility.filterQuality(FilterQuality.low);
      expect(image.filterQuality, FilterQuality.low);
    });

    test('color utility returns correct instance', () {
      final image = imageUtility.color(Colors.red);
      expect(image.color, const ColorDto(Colors.red));
    });

    test('colorBlendMode utility returns correct instance', () {
      final image = imageUtility.colorBlendMode(BlendMode.multiply);
      expect(image.colorBlendMode, BlendMode.multiply);
    });

    group('Fluent chaining', () {
      test('should chain multiple properties', () {
        final image = imageUtility.chain
          ..width(120)
          ..height(180)
          ..fit.cover()
          ..alignment.center();

        expect(image.attributeValue!.width, 120);
        expect(image.attributeValue!.height, 180);
        expect(image.attributeValue!.fit, BoxFit.cover);
        expect(image.attributeValue!.alignment, Alignment.center);
      });
    });

    group('Immutability', () {
      test('should create new instances on each call', () {
        final image1 = imageUtility.width(100);
        final image2 = imageUtility.width(200);

        expect(image1, isNot(same(image2)));
        expect(image1.width, isNot(equals(image2.width)));
      });
    });

    group('Integration with Style', () {
      test('should work within Style composition', () {
        final style = Style(
          imageUtility.width(100),
          imageUtility.height(100),
          imageUtility.fit(BoxFit.cover),
        );

        expect(style.styles.length,
            1); // Attributes are merged into one ImageSpecAttribute
      });
    });
  });
}
