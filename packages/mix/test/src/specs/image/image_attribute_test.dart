import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ImageMixAttribute', () {
    test('resolve returns correct ImageSpec', () {
      final attribute = ImageSpecAttribute(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
      );

      final spec = attribute.resolve(EmptyMixData);

      expect(spec.width, 100);
      expect(spec.height, 200);
      expect(spec.color, Colors.red);
      expect(spec.repeat, ImageRepeat.repeat);
      expect(spec.fit, BoxFit.cover);
    });

    test('merge returns correct ImageMixAttribute', () {
      final attribute1 = ImageSpecAttribute(
        width: 100,
        height: 200,
        color: Colors.red,
        repeat: ImageRepeat.repeat,
        fit: BoxFit.cover,
      );
      final attribute2 = ImageSpecAttribute(
        width: 150,
        height: 250,
        color: Colors.blue,
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.fill,
      );
      final mergedAttribute = attribute1.merge(attribute2);

      expect(mergedAttribute.width, 150);
      expect(mergedAttribute.height, 250);
      expect(mergedAttribute.color, Mix.value(Colors.blue));
      expect(mergedAttribute.repeat, ImageRepeat.noRepeat);
      expect(mergedAttribute.fit, BoxFit.fill);
    });
  });
}
