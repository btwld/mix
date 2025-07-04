import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/attributes/color/color_dto.dart';
import 'package:mix/src/attributes/shadow/shadow_dto.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  //  ShadowDto
  group('ShadowDto', () {
    test('Constructor assigns correct properties', () {
      const shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
      );

      expect(shadowDto.blurRadius, 10.0);
      expect(shadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset, const Offset(10, 10));
    });

    test('from() creates correct instance', () {
      const shadow = Shadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
      );

      final shadowDto = shadow.toDto();

      expect(shadowDto.blurRadius, 10.0);
      expect(shadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset, const Offset(10, 10));
    });

    test('maybeFrom() creates correct instance', () {
      const shadow = Shadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
      );

      final shadowDto = shadow.toDto();

      expect(shadowDto.blurRadius, 10.0);
      expect(shadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(shadowDto.offset, const Offset(10, 10));
    });

    test('resolve() returns correct instance', () {
      const shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
      );

      final shadow = shadowDto.resolve(EmptyMixData);

      expect(shadow.blurRadius, 10.0);
      expect(shadow.color, Colors.blue);
      expect(shadow.offset, const Offset(10, 10));
    });

    test('merge() returns correct instance', () {
      const shadowDto = ShadowDto(
        blurRadius: 10.0,
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
      );

      final mergedShadowDto = shadowDto.merge(
        const ShadowDto(
          blurRadius: 20.0,
          color: ColorDto.value(Colors.red),
          offset: Offset(20, 20),
        ),
      );

      expect(mergedShadowDto.blurRadius, 20.0);
      expect(mergedShadowDto.color?.resolve(EmptyMixData), Colors.red);
      expect(mergedShadowDto.offset, const Offset(20, 20));
    });
  });

  group('BoxShadowDto', () {
    test('Constructor assigns correct properties', () {
      const boxShadowDto = BoxShadowDto(
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      expect(boxShadowDto.blurRadius, 10.0);
      expect(boxShadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset, const Offset(10, 10));
      expect(boxShadowDto.spreadRadius, 5.0);
    });

    test('from() creates correct instance', () {
      const boxShadow = BoxShadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final boxShadowDto = boxShadow.toDto();

      expect(boxShadowDto.blurRadius, 10.0);
      expect(boxShadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset, const Offset(10, 10));
      expect(boxShadowDto.spreadRadius, 5.0);
    });

    test('maybeFrom() creates correct instance', () {
      const boxShadow = BoxShadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final boxShadowDto = boxShadow.toDto();

      expect(boxShadowDto.blurRadius, 10.0);
      expect(boxShadowDto.color?.resolve(EmptyMixData), Colors.blue);
      expect(boxShadowDto.offset, const Offset(10, 10));
      expect(boxShadowDto.spreadRadius, 5.0);
    });

    test('resolve() returns correct instance', () {
      const boxShadowDto = BoxShadowDto(
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
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
      const boxShadowDto = BoxShadowDto(
        color: ColorDto.value(Colors.blue),
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );

      final mergedBoxShadowDto = boxShadowDto.merge(
        const BoxShadowDto(
          color: ColorDto.value(Colors.red),
          offset: Offset(20, 20),
          blurRadius: 20.0,
          spreadRadius: 10.0,
        ),
      );

      expect(mergedBoxShadowDto.blurRadius, 20.0);
      expect(mergedBoxShadowDto.color?.resolve(EmptyMixData), Colors.red);
      expect(mergedBoxShadowDto.offset, const Offset(20, 20));
      expect(mergedBoxShadowDto.spreadRadius, 10.0);
    });
  });
}
