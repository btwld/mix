import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  // ShadowUtility
  group('ShadowUtility', () {
    final shadowUtility = ShadowUtility(UtilityTestAttribute.new);

    test('call() returns correct instance', () {
      final shadow = shadowUtility(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: const Offset(10, 10),
      );

      expect(shadow.value.blurRadius, 10.0);
      expect(shadow.value.color, Mix.value(Colors.blue));
      expect(shadow.value.offset, const Offset(10, 10));
    });

    // color()
    test('color() returns correct instance', () {
      final shadow = shadowUtility.color(Colors.blue);

      expect(shadow.value.color, Mix.value(Colors.blue));
    });

    // offset()
    test('offset() returns correct instance', () {
      final shadow = shadowUtility.offset(10, 10);

      expect(shadow.value.offset, const Offset(10, 10));
    });
  });

  // BoxShadowUtility
  group('BoxShadowUtility', () {
    final boxShadowUtility = BoxShadowUtility(UtilityTestAttribute.new);

    test('call() returns correct instance', () {
      final boxShadow = boxShadowUtility(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: const Offset(10, 10),
        spreadRadius: 10.0,
      );

      expect(boxShadow.value.blurRadius, 10.0);
      expect(boxShadow.value.color, Mix.value(Colors.blue));
      expect(boxShadow.value.offset, const Offset(10, 10));
      expect(boxShadow.value.spreadRadius, 10.0);
    });

    // color()
    test('color() returns correct instance', () {
      final boxShadow = boxShadowUtility.color(Colors.blue);

      expect(boxShadow.value.color, Mix.value(Colors.blue));
    });

    // offset()
    test('offset() returns correct instance', () {
      final boxShadow = boxShadowUtility.offset(10, 10);

      expect(boxShadow.value.offset, const Offset(10, 10));
    });

    // spreadRadius()
    test('spreadRadius() returns correct instance', () {
      final boxShadow = boxShadowUtility.spreadRadius(10);

      expect(boxShadow.value.spreadRadius, 10);
    });

    // blurRadius()
    test('blurRadius() returns correct instance', () {
      final boxShadow = boxShadowUtility.blurRadius(10);

      expect(boxShadow.value.blurRadius, 10);
    });
  });
}
