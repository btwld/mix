import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxBorderDto', () {
    test('isDirectional', () {
      final borderDto = BorderDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        left: BorderSideDto(width: 1.0),
        right: BorderSideDto(width: 1.0),
      );

      expect(borderDto.isDirectional, false);

      final directionalDto = BorderDirectionalDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        start: BorderSideDto(width: 1.0),
        end: BorderSideDto(width: 1.0),
      );

      expect(directionalDto.isDirectional, true);
    });

    test('merge', () {
      final borderDto1 = BorderDto(
        top: BorderSideDto(width: 1.0),
        bottom: BorderSideDto(width: 1.0),
        left: BorderSideDto(width: 1.0),
        right: BorderSideDto(width: 1.0),
      );

      final borderDto2 = BorderDto(
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
      final borderDto = BorderDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        left: BorderSideDto(width: 15.0),
        right: BorderSideDto(width: 20.0),
      );

      final resolvedBorder = borderDto.resolve(EmptyMixData);

      expect(resolvedBorder.top, const BorderSide(width: 5.0));
      expect(resolvedBorder.bottom, const BorderSide(width: 10.0));
      expect(resolvedBorder.left, const BorderSide(width: 15.0));
      expect(resolvedBorder.right, const BorderSide(width: 20.0));
    });

    test('resolve() Border with default value', () {
      final borderDto = BorderDto(
        top: BorderSideDto(width: 5.0),
        left: BorderSideDto(width: 15.0),
      );

      final resolvedBorder = borderDto.resolve(EmptyMixData);

      expect(resolvedBorder.top, const BorderSide(width: 5.0));
      expect(resolvedBorder.bottom, BorderSide.none);
      expect(resolvedBorder.left, const BorderSide(width: 15.0));
      expect(resolvedBorder.right, BorderSide.none);
    });

    test('resolve() BorderDirectional', () {
      final borderDto = BorderDirectionalDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        start: BorderSideDto(width: 15.0),
        end: BorderSideDto(width: 20.0),
      );

      final resolvedBorder = borderDto.resolve(EmptyMixData);

      expect(resolvedBorder.top, const BorderSide(width: 5.0));
      expect(resolvedBorder.bottom, const BorderSide(width: 10.0));
      expect(resolvedBorder.start, const BorderSide(width: 15.0));
      expect(resolvedBorder.end, const BorderSide(width: 20.0));
    });

    //  merge
    test('merge() Border', () {
      final borderDto1 = BorderDto(
        top: BorderSideDto(color: Colors.red, width: 1.0),
        bottom: BorderSideDto(color: Colors.red, width: 1.0),
        left: BorderSideDto(color: Colors.red, width: 1.0),
        right: BorderSideDto(color: Colors.red, width: 1.0),
      );

      final borderDto2 = BorderDto(
        top: BorderSideDto(width: 2.0),
        bottom: BorderSideDto(width: 2.0),
        left: BorderSideDto(width: 2.0),
        right: BorderSideDto(width: 2.0),
      );

      final merged = borderDto1.merge(borderDto2);

      // MIGRATED: Much cleaner assertions using custom matchers
      expect(merged.top?.width, resolvesTo(2.0));
      expect(merged.top?.color, resolvesTo(Colors.red));

      expect(merged.bottom?.width, resolvesTo(2.0));
      expect(merged.bottom?.color, resolvesTo(Colors.red));

      expect(merged.left?.width, resolvesTo(2.0));
      expect(merged.left?.color, resolvesTo(Colors.red));

      expect(merged.right?.width, resolvesTo(2.0));
      expect(merged.right?.color, resolvesTo(Colors.red));
    });

    test('merge BorderDto and BorderDirectionalDto', () {
      final borderDto = BorderDto.all(
        BorderSideDto(color: Colors.yellow, width: 3.0),
      );

      final borderDirectionalDto = BorderDirectionalDto(
        top: BorderSideDto(color: Colors.green),
        bottom: BorderSideDto(width: 4.0),
        start: BorderSideDto(color: Colors.red, width: 1.0),
        end: BorderSideDto(color: Colors.blue, width: 2.0),
      );
      final mergedBorder =
          BoxBorderDto.tryToMerge(borderDto, borderDirectionalDto)
              as BorderDirectionalDto?;

      expect(mergedBorder?.top?.color?.resolve(EmptyMixData), Colors.green);
      expect(mergedBorder?.top?.width?.resolve(EmptyMixData), 3.0);
      expect(mergedBorder?.bottom?.color?.resolve(EmptyMixData), Colors.yellow);
      expect(mergedBorder?.bottom?.width?.resolve(EmptyMixData), 4.0);

      expect(mergedBorder?.start?.color?.resolve(EmptyMixData), Colors.red);
      expect(mergedBorder?.start?.width?.resolve(EmptyMixData), 1.0);
      expect(mergedBorder?.end?.color?.resolve(EmptyMixData), Colors.blue);
      expect(mergedBorder?.end?.width?.resolve(EmptyMixData), 2.0);
    });
  });

  // BorderSideDto tests
  group('BorderSideDto', () {
    test('should correctly merge with another BorderSideDto', () {
      final borderSideDto1 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );

      final borderSideDto2 = BorderSideDto(
        color: Colors.blue,
        style: BorderStyle.solid,
        width: 2.0,
      );

      final merged = borderSideDto1.merge(borderSideDto2);

      // MIGRATED: Clean assertions - much more readable!
      expect(merged.width, resolvesTo(2.0));
      expect(merged.color, resolvesTo(Colors.blue));
      expect(merged.style, resolvesTo(BorderStyle.solid));
    });

    // copywith
    test('copyWith should correctly copy the BorderSideDto', () {
      final borderSideDto = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );

      final copied = borderSideDto.merge(
        BorderSideDto(color: Colors.blue, width: 2.0),
      );

      expect(copied.width?.resolve(EmptyMixData), 2.0);
      expect(copied.color?.resolve(EmptyMixData), Colors.blue);
      expect(copied.style?.resolve(EmptyMixData), BorderStyle.solid);
    });

    // from
    // TODO: BorderSideDto.value() constructor doesn't exist
    /*
    test('from should correctly create a BorderSideDto from a BorderSide', () {
      const borderSide = BorderSide(
        color: Colors.red,
        width: 1.0,
        style: BorderStyle.solid,
      );

      final borderSideDto = BorderSideDto.value(borderSide);

      expect(borderSideDto.width?.resolve(EmptyMixData), borderSide.width);
      expect(borderSideDto.color?.resolve(EmptyMixData), borderSide.color);
      expect(borderSideDto.style?.resolve(EmptyMixData), borderSide.style);
    });
    */

    // resolve
    test(
      'resolve should correctly create a BorderSide from a BorderSideDto',
      () {
        final borderSideDto = BorderSideDto(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 1.0,
        );

        final resolved = borderSideDto.resolve(EmptyMixData);

        expect(resolved.width, 1.0);
        expect(resolved.color, Colors.red);
        expect(resolved.style, BorderStyle.solid);
      },
    );
  });
}
