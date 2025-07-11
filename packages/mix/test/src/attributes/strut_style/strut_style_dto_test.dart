import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/attributes/strut_style/strut_style_dto.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('StrutStyleDto', () {
    test('from constructor sets all values correctly', () {
      final strutStyle = StrutStyleDto(
        fontFamily: 'Roboto',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        height: 2.0,
        leading: 1.0,
        forceStrutHeight: true,
      );

      expect(
        strutStyle,
        resolvesTo(
          StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            height: 2.0,
            leading: 1.0,
            forceStrutHeight: true,
          ),
        ),
      );
    });

    // Test to check if the merge function returns a merged object correctly
    test('merge returns merged object correctly', () {
      final strutStyle1 = StrutStyleDto(fontFamily: 'Roboto', fontSize: 24.0);
      final strutStyle2 = StrutStyleDto(
        fontWeight: FontWeight.bold,
        height: 2.0,
        leading: 1.0,
      );
      final merged = strutStyle1.merge(strutStyle2);

      expect(
        merged,
        resolvesTo(
          StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            height: 2.0,
            leading: 1.0,
          ),
        ),
      );
    });

    // Test to check if the resolve function returns the correct StrutStyle
    test('resolve returns correct StrutStyle', () {
      final strutStyle = StrutStyleDto(
        fontFamily: 'Roboto',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        height: 2.0,
        leading: 1.0,
      );

      expect(
        strutStyle,
        resolvesTo(
          StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            height: 2.0,
            leading: 1.0,
          ),
        ),
      );
    });

    // Test to check if two StrutStyleDtos with the same properties are equal
    test('Equality holds when all properties are the same', () {
      final strutStyle1 = StrutStyleDto(fontFamily: 'Roboto', fontSize: 24.0);
      final strutStyle2 = StrutStyleDto(fontFamily: 'Roboto', fontSize: 24.0);

      expect(strutStyle1, strutStyle2);
    });

    // Test to check if two StrutStyleDtos with different properties are not equal
    test('Equality fails when properties are different', () {
      final strutStyle1 = StrutStyleDto(fontFamily: 'Roboto', fontSize: 24.0);
      final strutStyle2 = StrutStyleDto(fontFamily: 'Lato', fontSize: 24.0);

      expect(strutStyle1, isNot(strutStyle2));
    });
  });
}
