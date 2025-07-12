import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('Spacing Utils', () {
    final spacingUtils = EdgeInsetsGeometryUtility(UtilityTestAttribute.new);
    test('padding()', () {
      expect(
        spacingUtils(10).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 10, right: 10),
      );
      expect(
        spacingUtils(10, 20).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 20, right: 20),
      );
      expect(
        spacingUtils(10, 20, 30).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 30, left: 20, right: 20),
      );
      expect(
        spacingUtils(10, 20, 30, 40).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 30, left: 40, right: 20),
      );
    });

    test('spacingUtils.directional()', () {
      expect(
        spacingUtils.directional(10).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, start: 10, end: 10),
        reason: '1',
      );
      expect(
        spacingUtils.directional(10, 20).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, start: 20, end: 20),
        reason: '2',
      );
      expect(
        spacingUtils.directional(10, 20, 30).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 30, start: 20, end: 20),
        reason: '3',
      );
      expect(
        spacingUtils.directional(10, 20, 30, 40).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 30, start: 40, end: 20),
        reason: '4',
      );
    });

    test('spacingUtils.from', () {
      expect(
        spacingUtils.as(const EdgeInsets.all(10)).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 10, right: 10),
        reason: '1',
      );

      expect(
        spacingUtils.as(const EdgeInsets.only(top: 10)).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 0, left: 0, right: 0),
        reason: '2',
      );

      expect(
        spacingUtils.as(const EdgeInsets.only(left: 10)).value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, left: 10, right: 0),
        reason: '3',
      );

      expect(
        spacingUtils.as(const EdgeInsets.only(right: 10)).value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, left: 0, right: 10),
        reason: '4',
      );

      expect(
        spacingUtils.as(const EdgeInsets.only(bottom: 10)).value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 10, left: 0, right: 0),
        reason: '5',
      );

      expect(
        spacingUtils.as(const EdgeInsets.symmetric(horizontal: 10)).value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, left: 10, right: 10),
        reason: '6',
      );

      expect(
        spacingUtils.as(const EdgeInsets.symmetric(vertical: 10)).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 0, right: 0),
        reason: '7',
      );

      expect(
        spacingUtils.directional
            .as(const EdgeInsetsDirectional.only(start: 10))
            .value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, start: 10, end: 0),
        reason: '8',
      );

      expect(
        spacingUtils.directional
            .as(const EdgeInsetsDirectional.only(end: 10))
            .value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, start: 0, end: 10),
        reason: '9',
      );

      expect(
        spacingUtils.directional
            .as(const EdgeInsetsDirectional.only(top: 10))
            .value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 0, start: 0, end: 0),
        reason: '10',
      );

      expect(
        spacingUtils.directional
            .as(const EdgeInsetsDirectional.only(bottom: 10))
            .value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 10, start: 0, end: 0),
        reason: '11',
      );

      expect(
        spacingUtils.directional
            .as(const EdgeInsetsDirectional.only(start: 10, end: 20))
            .value,
        EdgeInsetsGeometryDto.only(top: 0, bottom: 0, start: 10, end: 20),
        reason: '12',
      );

      expect(
        spacingUtils.directional
            .as(
              const EdgeInsetsDirectional.only(start: 10, top: 30, end: 20),
            )
            .value,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 0, start: 10, end: 20),
        reason: '13',
      );

      expect(
        spacingUtils.directional
            .as(
              const EdgeInsetsDirectional.only(
                start: 10,
                top: 30,
                end: 20,
                bottom: 40,
              ),
            )
            .value,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 40, start: 10, end: 20),
        reason: '14',
      );
    });

    test('spacingUtils.only', () {
      expect(
        spacingUtils.only(top: 10).value,
        EdgeInsetsGeometryDto.only(top: 10),
      );

      expect(
        spacingUtils.only(left: 10).value,
        EdgeInsetsGeometryDto.only(left: 10),
      );

      expect(
        spacingUtils.only(right: 10).value,
        EdgeInsetsGeometryDto.only(right: 10),
      );

      expect(
        spacingUtils.only(bottom: 10).value,
        EdgeInsetsGeometryDto.only(bottom: 10),
      );
    });

    test('spacingUtils.top', () {
      expect(spacingUtils.top(10).value, EdgeInsetsGeometryDto.only(top: 10));
    });

    test('spacingUtils.bottom', () {
      expect(
        spacingUtils.bottom(10).value,
        EdgeInsetsGeometryDto.only(bottom: 10),
      );
    });

    test('spacingUtils.left', () {
      expect(spacingUtils.left(10).value, EdgeInsetsGeometryDto.only(left: 10));
    });

    test('spacingUtils.right', () {
      expect(
          spacingUtils.right(10).value, EdgeInsetsGeometryDto.only(right: 10));
    });

    test('spacingUtils.directional.start', () {
      expect(
        spacingUtils.directional.start(10).value,
        EdgeInsetsGeometryDto.only(start: 10),
      );
    });

    test('spacingUtils.directional.end', () {
      expect(
        spacingUtils.directional.end(10).value,
        EdgeInsetsGeometryDto.only(end: 10),
      );
    });

    test('spacingUtils.horizontal', () {
      expect(
        spacingUtils.horizontal(10).value,
        EdgeInsetsGeometryDto.only(left: 10, right: 10),
      );
    });

    test('spacingUtils.vertical', () {
      expect(
        spacingUtils.vertical(10).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10),
      );
    });

    test('spacingUtils.all', () {
      expect(
        spacingUtils.all(10).value,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 10, right: 10),
      );
    });

    test('spacingUtils.directional.only', () {
      expect(
        spacingUtils.directional.only(start: 10).value,
        EdgeInsetsGeometryDto.only(start: 10),
      );

      expect(
        spacingUtils.directional.only(end: 10).value,
        EdgeInsetsGeometryDto.only(end: 10),
      );

      expect(
        spacingUtils.directional.only(start: 10, end: 20).value,
        EdgeInsetsGeometryDto.only(start: 10, end: 20),
      );

      expect(
        spacingUtils.directional.only(top: 30, start: 10, end: 20).value,
        EdgeInsetsGeometryDto.only(top: 30, start: 10, end: 20),
      );

      expect(
        spacingUtils.directional
            .only(top: 30, bottom: 40, start: 10, end: 20)
            .value,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 40, start: 10, end: 20),
      );
    });
  });
}
