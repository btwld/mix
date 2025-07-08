import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  //  ShadowDto
  group('ShadowDto', () {
    test('Constructor assigns correct properties', () {
      final shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: const Offset(10, 10),
      );

      expect(shadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(shadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
    });

    test('from() creates correct instance', () {
      const shadow = Shadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
      );

      final shadowDto = ShadowDto.from(shadow);

      expect(shadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(shadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
    });

    test('maybeFrom() creates correct instance', () {
      const shadow = Shadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
      );

      final shadowDto = ShadowDto.from(shadow);

      expect(shadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(shadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
    });

    test('resolve() returns correct instance', () {
      final shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: const Offset(10, 10),
      );

      final shadow = shadowDto.resolve(EmptyMixData);

      expect(shadow.blurRadius, 10.0);
      expect(shadow.color, Colors.blue);
      expect(shadow.offset, const Offset(10, 10));
    });

    test('merge() returns correct instance', () {
      final shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: const Offset(10, 10),
      );

      final mergedShadowDto = shadowDto.merge(
        ShadowDto(
          blurRadius: 20.0,
          color: Colors.red,
          offset: const Offset(20, 20),
        ),
      );

      expect(mergedShadowDto.blurRadius.resolve(EmptyMixData), 20.0);
      expect(mergedShadowDto.color.resolve(EmptyMixData), Colors.red);
      expect(mergedShadowDto.offset.resolve(EmptyMixData), const Offset(20, 20));
    });
  });

  group('BoxShadowDto', () {
    test('Constructor assigns correct properties', () {
      final boxShadowDto = BoxShadowDto(
        color: Colors.blue,
        offset: const Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      expect(boxShadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(boxShadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
      expect(boxShadowDto.spreadRadius.resolve(EmptyMixData), 5.0);
    });

    test('from() creates correct instance', () {
      const boxShadow = BoxShadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final boxShadowDto = BoxShadowDto.from(boxShadow);

      expect(boxShadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(boxShadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
      expect(boxShadowDto.spreadRadius.resolve(EmptyMixData), 5.0);
    });

    test('maybeFrom() creates correct instance', () {
      const boxShadow = BoxShadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final boxShadowDto = BoxShadowDto.from(boxShadow);

      expect(boxShadowDto.blurRadius.resolve(EmptyMixData), 10.0);
      expect(boxShadowDto.color.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset.resolve(EmptyMixData), const Offset(10, 10));
      expect(boxShadowDto.spreadRadius.resolve(EmptyMixData), 5.0);
    });

    test('resolve() returns correct instance', () {
      final boxShadowDto = BoxShadowDto(
        color: Colors.blue,
        offset: const Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final boxShadow = boxShadowDto.resolve(EmptyMixData);

      expect(boxShadow.blurRadius, 10.0);
      expect(boxShadow.color, Colors.blue);
      expect(boxShadow.offset, const Offset(10, 10));
      expect(boxShadow.spreadRadius, 5.0);
    });

    test('merge() returns correct instance', () {
      final boxShadowDto = BoxShadowDto(
        color: Colors.blue,
        offset: const Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final mergedBoxShadowDto = boxShadowDto.merge(
        BoxShadowDto(
          color: Colors.red,
          offset: const Offset(20, 20),
          blurRadius: 20.0,
          spreadRadius: 10.0,
        ),
      );

      expect(mergedBoxShadowDto.blurRadius.resolve(EmptyMixData), 20.0);
      expect(mergedBoxShadowDto.color.resolve(EmptyMixData), Colors.red);
      expect(mergedBoxShadowDto.offset.resolve(EmptyMixData), const Offset(20, 20));
      expect(mergedBoxShadowDto.spreadRadius.resolve(EmptyMixData), 10.0);
    });
  });
}
