import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxBorderDto', () {
    test('isDirectional', () {
      const borderDto = BoxBorderDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        left: BorderSideDto(width: 1.0),
        right: BorderSideDto(width: 1.0),
      );

      expect(borderDto.isDirectional, false);

      const directionalDto = BoxBorderDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        start: BorderSideDto(width: 1.0),
        end: BorderSideDto(width: 1.0),
      );

      expect(directionalDto.isDirectional, true);
    });

    test('merge', () {
      const borderDto1 = BoxBorderDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        left: BorderSideDto(width: 1.0),
        right: BorderSideDto(width: 1.0),
      );

      const borderDto2 = BoxBorderDto(
        top: BorderSideDto(width: 2.0),
        bottom: BorderSideDto(width: 2.0),
        left: BorderSideDto(width: 2.0),
        right: BorderSideDto(width: 2.0),
      );

      final merged = borderDto1.merge(borderDto2);

      expect(merged.top, borderDto2.top);
      expect(merged.bottom, borderDto2.bottom);
      expect(merged.left, borderDto2.left);
      expect(merged.right, borderDto2.right);
    });

    // resolve
    test('resolve() Border', () {
      const borderDto = BoxBorderDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        left: BorderSideDto(width: 15.0),
        right: BorderSideDto(width: 20.0),
      );

      final resolvedBorder = borderDto.resolve(EmptyMixData) as Border;

      expect(resolvedBorder.top, const BorderSide(width: 5.0));
      expect(resolvedBorder.bottom, const BorderSide(width: 10.0));
      expect(resolvedBorder.left, const BorderSide(width: 15.0));
      expect(resolvedBorder.right, const BorderSide(width: 20.0));
    });

    test('resolve() BorderDirectional', () {
      const borderDto = BoxBorderDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        start: BorderSideDto(width: 15.0),
        end: BorderSideDto(width: 20.0),
      );

      final resolvedBorder =
          borderDto.resolve(EmptyMixData) as BorderDirectional;

      expect(resolvedBorder.top, const BorderSide(width: 5.0));
      expect(resolvedBorder.bottom, const BorderSide(width: 10.0));
      expect(resolvedBorder.start, const BorderSide(width: 15.0));
      expect(resolvedBorder.end, const BorderSide(width: 20.0));
    });
  });

  // BorderSideDto tests
  group('BorderSideDto', () {
    test('should correctly merge with another BorderSideDto', () {
      const borderSideDto1 = BorderSideDto(
        width: 1.0,
        color: ColorDto(Colors.red),
        style: BorderStyle.solid,
      );

      const borderSideDto2 = BorderSideDto(
        width: 2.0,
        color: ColorDto(Colors.blue),
        style: BorderStyle.solid,
      );

      final merged = borderSideDto1.merge(borderSideDto2);

      expect(merged.width, borderSideDto2.width);
      expect(merged.color, borderSideDto2.color);
      expect(merged.style, borderSideDto2.style);
    });

    // copywith
    test('copyWith should correctly copy the BorderSideDto', () {
      const borderSideDto = BorderSideDto(
        width: 1.0,
        color: ColorDto(Colors.red),
        style: BorderStyle.solid,
      );

      final copied = borderSideDto.copyWith(
        width: 2.0,
        color: const ColorDto(Colors.blue),
      );

      expect(copied.width, 2.0);
      expect(copied.color, const ColorDto(Colors.blue));
      expect(copied.style, BorderStyle.solid);
    });

    // from
    test('from should correctly create a BorderSideDto from a BorderSide', () {
      const borderSide = BorderSide(
        width: 1.0,
        color: Colors.red,
        style: BorderStyle.solid,
      );

      final borderSideDto = BorderSideDto.from(borderSide);

      expect(borderSideDto.width, borderSide.width);
      expect(borderSideDto.color, ColorDto(borderSide.color));
      expect(borderSideDto.style, borderSide.style);
    });

    // resolve
    test('resolve should correctly create a BorderSide from a BorderSideDto',
        () {
      const borderSideDto = BorderSideDto(
        width: 1.0,
        color: ColorDto(Colors.red),
        style: BorderStyle.solid,
      );

      final resolved = borderSideDto.resolve(EmptyMixData);

      expect(resolved.width, borderSideDto.width);
      expect(resolved.color, borderSideDto.color?.resolve(EmptyMixData));
      expect(resolved.style, borderSideDto.style);
    });
  });
}
