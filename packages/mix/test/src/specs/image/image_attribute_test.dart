import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('ImageMixAttribute', () {
    test('resolve returns correct ImageSpec', () {
      final attribute = ImageSpecAttribute.only(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
      );

      expect(
        attribute,
        resolvesTo(
          ImageSpec(
            width: 100,
            height: 200,
            color: Colors.red,
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
          ),
        ),
      );
    });

    test('merge returns correct ImageMixAttribute', () {
      final attribute1 = ImageSpecAttribute.only(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
      );
      final attribute2 = ImageSpecAttribute.only(
        width: 150,
        height: 250,
        color: Colors.blue,
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.fill,
      );
      final mergedAttribute = attribute1.merge(attribute2);

      expect(mergedAttribute.width, isA<Prop<double>>());
      expect(mergedAttribute.width.value, 150);
      expect(mergedAttribute.height, isA<Prop<double>>());
      expect(mergedAttribute.height.value, 250);
      expect(mergedAttribute.color, isA<Prop<Color>>());
      expect(mergedAttribute.repeat, ImageRepeat.noRepeat);
      expect(mergedAttribute.fit, BoxFit.fill);
    });
  });
}
