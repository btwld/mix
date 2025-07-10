import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/attribute_generator.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleUtility', () {
    final strutStyleUtility = StrutStyleUtility(UtilityTestAttribute.new);
    test('callable', () {
      final strutStyle = strutStyleUtility(
        fontFamily: 'Roboto',
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        forceStrutHeight: true,
        height: 2.0,
        leading: 1.0,
      );

      expect(strutStyleUtility(), isA<UtilityTestAttribute>());
      expect(strutStyle.value, isA<StrutStyleDto>());

      final resolved = strutStyle.value.resolve(EmptyMixData);
      expect(resolved.fontFamily, 'Roboto');
      expect(resolved.fontSize, 24.0);
      expect(resolved.height, 2.0);
      expect(resolved.leading, 1.0);
      expect(resolved.fontWeight, FontWeight.bold);
      expect(resolved.fontStyle, FontStyle.italic);
      expect(resolved.forceStrutHeight, true);
    });

    test('fontFamily', () {
      final strutStyle = strutStyleUtility.fontFamily('Roboto');
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.fontFamily, 'Roboto');
    });

    test('fontSize', () {
      final strutStyle = strutStyleUtility.fontSize(24.0);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.fontSize, 24.0);
    });

    test('height', () {
      final strutStyle = strutStyleUtility.height(2.0);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.height, 2.0);
    });

    test('leading', () {
      final strutStyle = strutStyleUtility.leading(1.0);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.leading, 1.0);
    });

    test('fontWeight', () {
      final strutStyle = strutStyleUtility.fontWeight(FontWeight.bold);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.fontWeight, FontWeight.bold);
    });

    test('fontStyle', () {
      final strutStyle = strutStyleUtility.fontStyle(FontStyle.italic);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.fontStyle, FontStyle.italic);
    });

    test('forceStrutHeight', () {
      final strutStyle = strutStyleUtility.forceStrutHeight(true);
      final resolved = strutStyle.value.resolve(EmptyMixData);

      expect(resolved.forceStrutHeight, true);
    });

    test('as', () {
      final strutStyle = RandomGenerator.strutStyle();
      final attribute = strutStyleUtility.as(strutStyle);

      expect(attribute.value, isA<StrutStyleDto>());
      expect(attribute.value, equals(StrutStyleDto.value(strutStyle)));
      expect(attribute.value.resolve(EmptyMixData), equals(strutStyle));
    });
  });
}
