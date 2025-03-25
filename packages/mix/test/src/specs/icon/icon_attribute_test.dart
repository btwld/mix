import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpecAttribute', () {
    test('resolve should return an instance of IconSpec', () {
      const attribute = IconSpecAttribute();
      final resolvedSpec = attribute.resolve(EmptyMixData);
      expect(resolvedSpec, isA<IconSpec>());
    });

    test('merge should return a new instance of IconSpecAttribute', () {
      const shadows = [
        ShadowDto(
          color: ColorDto(
            Colors.black,
          ),
        ),
        ShadowDto(
          color: ColorDto(Colors.black),
        ),
      ];

      const attribute1 = IconSpecAttribute(
        size: 24,
        color: ColorDto(Colors.black),
        weight: 24,
        grade: 24,
        opticalSize: 24,
        shadows: shadows,
        fill: 24,
        textDirection: TextDirection.ltr,
        applyTextScaling: true,
      );

      const attribute2 = IconSpecAttribute(
        size: 32,
        color: ColorDto(Colors.white),
        weight: 32,
        grade: 32,
        opticalSize: 32,
        shadows: [
          ShadowDto(
            color: ColorDto(
              Colors.black,
            ),
          ),
          ShadowDto(
            color: ColorDto(Colors.white),
          ),
        ],
        fill: 32,
        textDirection: TextDirection.rtl,
        applyTextScaling: true,
      );

      final mergedAttribute = attribute1.merge(attribute2);
      expect(mergedAttribute, isA<IconSpecAttribute>());
      expect(mergedAttribute.size, equals(32));
      expect(mergedAttribute.weight, equals(32));

      expect(mergedAttribute.color, equals(const ColorDto(Colors.white)));
      expect(mergedAttribute.grade, equals(32));
      expect(mergedAttribute.opticalSize, equals(32));
      expect(mergedAttribute.fill, equals(32));
      expect(mergedAttribute.textDirection, equals(TextDirection.rtl));
      expect(mergedAttribute.applyTextScaling, equals(true));
      expect(
        mergedAttribute.shadows,
        equals(
          [
            const ShadowDto(
              color: ColorDto(
                Colors.black,
              ),
            ),
            const ShadowDto(
              color: ColorDto(Colors.white),
            ),
          ],
        ),
      );
    });

    test('props should return a list of size and color', () {
      const size = 24.0;
      const color = ColorDto(Colors.black);
      const applyTextScaling = true;
      const fill = 2.0;
      const grade = 2.0;
      const opticalSize = 2.0;
      const shadows = [
        ShadowDto(
          color: ColorDto(
            Colors.black,
          ),
        ),
        ShadowDto(
          color: ColorDto(Colors.black),
        ),
      ];
      const textDirection = TextDirection.ltr;
      const weight = 2.0;

      const attribute = IconSpecAttribute(
        size: size,
        color: color,
        applyTextScaling: applyTextScaling,
        fill: fill,
        grade: grade,
        opticalSize: opticalSize,
        shadows: shadows,
        textDirection: textDirection,
        weight: weight,
      );

      expect(attribute.size, equals(size));
      expect(attribute.color, equals(color));
      expect(attribute.applyTextScaling, equals(applyTextScaling));
      expect(attribute.fill, equals(fill));
      expect(attribute.grade, equals(grade));
      expect(attribute.opticalSize, equals(opticalSize));
      expect(attribute.shadows, equals(shadows));
      expect(attribute.textDirection, equals(textDirection));
      expect(attribute.weight, equals(weight));
    });
  });
}
