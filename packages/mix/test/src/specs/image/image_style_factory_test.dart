import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageStyler factory constructors', () {
    group('dot-shorthand resolution', () {
      test('factory resolves via dot-shorthand typed assignment', () {
        ImageStyler styler = ImageStyler.color(Colors.red);
        expect(styler.$color, isNotNull);
      });

      test('chaining after factory constructor works', () {
        final styler = ImageStyler.color(
          Colors.red,
        ).width(100).fit(BoxFit.cover);
        expect(styler.$color, isNotNull);
        expect(styler.$width, isNotNull);
        expect(styler.$fit, isNotNull);
      });
    });

    group('factory matches instance method', () {
      test('image', () {
        const img = AssetImage('test.png');
        expect(ImageStyler.image(img), equals(ImageStyler(image: img)));
      });

      test('width', () {
        expect(ImageStyler.width(200), equals(ImageStyler(width: 200)));
      });

      test('height', () {
        expect(ImageStyler.height(100), equals(ImageStyler(height: 100)));
      });

      test('color', () {
        expect(
          ImageStyler.color(Colors.blue),
          equals(ImageStyler(color: Colors.blue)),
        );
      });

      test('fit', () {
        expect(
          ImageStyler.fit(BoxFit.cover),
          equals(ImageStyler(fit: BoxFit.cover)),
        );
      });

      test('alignment', () {
        expect(
          ImageStyler.alignment(Alignment.center),
          equals(ImageStyler(alignment: Alignment.center)),
        );
      });

      test('repeat', () {
        expect(
          ImageStyler.repeat(ImageRepeat.repeat),
          equals(ImageStyler(repeat: ImageRepeat.repeat)),
        );
      });

      test('centerSlice', () {
        expect(
          ImageStyler.centerSlice(const Rect.fromLTWH(0, 0, 10, 10)),
          equals(ImageStyler(centerSlice: const Rect.fromLTWH(0, 0, 10, 10))),
        );
      });

      test('filterQuality', () {
        expect(
          ImageStyler.filterQuality(FilterQuality.high),
          equals(ImageStyler(filterQuality: FilterQuality.high)),
        );
      });

      test('colorBlendMode', () {
        expect(
          ImageStyler.colorBlendMode(BlendMode.multiply),
          equals(ImageStyler(colorBlendMode: BlendMode.multiply)),
        );
      });

      test('gaplessPlayback', () {
        expect(
          ImageStyler.gaplessPlayback(true),
          equals(ImageStyler(gaplessPlayback: true)),
        );
      });

      test('isAntiAlias', () {
        expect(
          ImageStyler.isAntiAlias(true),
          equals(ImageStyler(isAntiAlias: true)),
        );
      });

      test('matchTextDirection', () {
        expect(
          ImageStyler.matchTextDirection(true),
          equals(ImageStyler(matchTextDirection: true)),
        );
      });
    });

    group('resolved values', () {
      test('width resolves correctly', () {
        final width = ImageStyler.width(
          200,
        ).$width!.resolveProp(MockBuildContext());
        expect(width, 200);
      });

      test('fit resolves correctly', () {
        final fit = ImageStyler.fit(
          BoxFit.cover,
        ).$fit!.resolveProp(MockBuildContext());
        expect(fit, BoxFit.cover);
      });
    });
  });
}
