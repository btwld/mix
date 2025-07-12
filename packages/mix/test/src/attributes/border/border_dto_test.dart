import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

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

      expect(merged.top?.width, resolvesTo(2.0));
      expect(merged.bottom?.width, resolvesTo(2.0));
      expect(merged.left?.width, resolvesTo(2.0));
      expect(merged.right?.width, resolvesTo(2.0));
    });

    // resolve
    test('resolve() Border', () {
      final borderDto = BorderDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        left: BorderSideDto(width: 15.0),
        right: BorderSideDto(width: 20.0),
      );

      expect(
        borderDto,
        resolvesTo(
          const Border(
            top: BorderSide(width: 5.0),
            bottom: BorderSide(width: 10.0),
            left: BorderSide(width: 15.0),
            right: BorderSide(width: 20.0),
          ),
        ),
      );
    });

    test('resolve() Border with default value', () {
      final borderDto = BorderDto(
        top: BorderSideDto(width: 5.0),
        left: BorderSideDto(width: 15.0),
      );

      expect(
        borderDto,
        resolvesTo(
          const Border(
            top: BorderSide(width: 5.0),
            bottom: BorderSide.none,
            left: BorderSide(width: 15.0),
            right: BorderSide.none,
          ),
        ),
      );
    });

    test('resolve() BorderDirectional', () {
      final borderDto = BorderDirectionalDto(
        top: BorderSideDto(width: 5.0),
        bottom: BorderSideDto(width: 10.0),
        start: BorderSideDto(width: 15.0),
        end: BorderSideDto(width: 20.0),
      );

      expect(
        borderDto,
        resolvesTo(
          const BorderDirectional(
            top: BorderSide(width: 5.0),
            bottom: BorderSide(width: 10.0),
            start: BorderSide(width: 15.0),
            end: BorderSide(width: 20.0),
          ),
        ),
      );
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

      expect(mergedBorder?.top?.color, resolvesTo(Colors.green));
      expect(mergedBorder?.top?.width, resolvesTo(3.0));
      expect(mergedBorder?.bottom?.color, resolvesTo(Colors.yellow));
      expect(mergedBorder?.bottom?.width, resolvesTo(4.0));

      expect(mergedBorder?.start?.color, resolvesTo(Colors.red));
      expect(mergedBorder?.start?.width, resolvesTo(1.0));
      expect(mergedBorder?.end?.color, resolvesTo(Colors.blue));
      expect(mergedBorder?.end?.width, resolvesTo(2.0));
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

      expect(copied.width, resolvesTo(2.0));
      expect(copied.color, resolvesTo(Colors.blue));
      expect(copied.style, resolvesTo(BorderStyle.solid));
    });

    // from
    test('from should correctly create a BorderSideDto from a BorderSide', () {
      const borderSide = BorderSide(
        color: Colors.red,
        width: 1.0,
        style: BorderStyle.solid,
      );

      final borderSideDto = BorderSideDto.value(borderSide);

      expect(borderSideDto.width, resolvesTo(borderSide.width));
      expect(borderSideDto.color, resolvesTo(borderSide.color));
      expect(borderSideDto.style, resolvesTo(borderSide.style));
    });

    // resolve
    test(
      'resolve should correctly create a BorderSide from a BorderSideDto',
      () {
        final borderSideDto = BorderSideDto(
          color: Colors.red,
          style: BorderStyle.solid,
          width: 1.0,
        );

        expect(
          borderSideDto,
          resolvesTo(
            const BorderSide(
              color: Colors.red,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        );
      },
    );
  });
}
