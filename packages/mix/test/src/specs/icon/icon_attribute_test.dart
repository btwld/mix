import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpecAttribute', () {
    test('resolve should return an instance of IconSpec', () {
      final attribute = IconSpecAttribute();
      final resolvedSpec = attribute.resolve(EmptyMixData);
      expect(resolvedSpec, isA<IconSpec>());
    });

    test('merge should return a new instance of IconSpecAttribute', () {
      final shadows = [
        ShadowDto(color: Colors.black),
        ShadowDto(color: Colors.black),
      ];

      final attribute1 = IconSpecAttribute(
        size: 24,
        color: Colors.black,
        weight: 24,
        grade: 24,
        opticalSize: 24,
        shadows: shadows,
        fill: 24,
        textDirection: TextDirection.ltr,
        applyTextScaling: true,
      );

      final attribute2 = IconSpecAttribute(
        size: 32,
        color: Colors.white,
        weight: 32,
        grade: 32,
        opticalSize: 32,
        shadows: [
          ShadowDto(color: Colors.black),
          ShadowDto(color: Colors.white),
        ],
        fill: 32,
        textDirection: TextDirection.rtl,
        applyTextScaling: true,
      );

      final mergedAttribute = attribute1.merge(attribute2);
      expect(mergedAttribute, isA<IconSpecAttribute>());
      expect(mergedAttribute.size, equals(Prop.value(32)));
      expect(mergedAttribute.weight, equals(Prop.value(32)));

      expect(mergedAttribute.color, equals(Prop.value(Colors.white)));
      expect(mergedAttribute.grade, equals(Prop.value(32)));
      expect(mergedAttribute.opticalSize, equals(Prop.value(32)));
      expect(mergedAttribute.fill, equals(Prop.value(32)));
      expect(mergedAttribute.textDirection, equals(TextDirection.rtl));
      expect(mergedAttribute.applyTextScaling, equals(true));
      expect(
        mergedAttribute.shadows,
        equals([
          MixProp<Shadow, ShadowDto>.value(ShadowDto(color: Colors.black)),
          MixProp<Shadow, ShadowDto>.value(ShadowDto(color: Colors.white)),
        ]),
      );
    });

    test('props should return a list of size and color', () {
      const size = 24.0;
      const color = Colors.black;
      const applyTextScaling = true;
      const fill = 2.0;
      const grade = 2.0;
      const opticalSize = 2.0;
      final shadows = [
        ShadowDto(color: Colors.black),
        ShadowDto(color: Colors.black),
      ];
      const textDirection = TextDirection.ltr;
      const weight = 2.0;

      final attribute = IconSpecAttribute(
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

      expect(attribute.size, equals(Prop.value(size)));
      expect(attribute.color, equals(Prop.value(color)));
      expect(attribute.applyTextScaling, equals(applyTextScaling));
      expect(attribute.fill, equals(Prop.value(fill)));
      expect(attribute.grade, equals(Prop.value(grade)));
      expect(attribute.opticalSize, equals(Prop.value(opticalSize)));
      expect(attribute.shadows, equals([
        MixProp<Shadow, ShadowDto>.value(ShadowDto(color: Colors.black)),
        MixProp<Shadow, ShadowDto>.value(ShadowDto(color: Colors.black)),
      ]));
      expect(attribute.textDirection, equals(textDirection));
      expect(attribute.weight, equals(Prop.value(weight)));
    });
  });
}
