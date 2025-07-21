import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

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
      expect(strutStyle.value, isA<StrutStyleMix>());

      expect(
        strutStyle.value,
        resolvesTo(
          const StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            height: 2.0,
            leading: 1.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            forceStrutHeight: true,
          ),
        ),
      );
    });

    test('fontFamily', () {
      final strutStyle = strutStyleUtility.fontFamily('Roboto');

      expect(
        strutStyle.value,
        resolvesTo(const StrutStyle(fontFamily: 'Roboto')),
      );
    });

    test('fontSize', () {
      final strutStyle = strutStyleUtility.fontSize(24.0);

      expect(strutStyle.value, resolvesTo(const StrutStyle(fontSize: 24.0)));
    });

    test('height', () {
      final strutStyle = strutStyleUtility.height(2.0);

      expect(strutStyle.value, resolvesTo(const StrutStyle(height: 2.0)));
    });

    test('leading', () {
      final strutStyle = strutStyleUtility.leading(1.0);

      expect(strutStyle.value, resolvesTo(const StrutStyle(leading: 1.0)));
    });

    test('fontWeight', () {
      final strutStyle = strutStyleUtility.fontWeight(FontWeight.bold);

      expect(
        strutStyle.value,
        resolvesTo(const StrutStyle(fontWeight: FontWeight.bold)),
      );
    });

    test('fontStyle', () {
      final strutStyle = strutStyleUtility.fontStyle(FontStyle.italic);

      expect(
        strutStyle.value,
        resolvesTo(const StrutStyle(fontStyle: FontStyle.italic)),
      );
    });

    test('forceStrutHeight', () {
      final strutStyle = strutStyleUtility.forceStrutHeight(true);

      expect(
        strutStyle.value,
        resolvesTo(const StrutStyle(forceStrutHeight: true)),
      );
    });

    test('as', () {
      final strutStyle = RandomGenerator.strutStyle();
      final attribute = strutStyleUtility.as(strutStyle);

      expect(attribute.value, isA<StrutStyleMix>());
      expect(attribute.value, equals(StrutStyleMix.value(strutStyle)));
      expect(attribute.value, resolvesTo(strutStyle));
    });
  });
}
