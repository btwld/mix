import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsGeometryDto', () {
    test(
      'only creates EdgeInsetsDto when directional values are not provided',
      () {
        final dto = EdgeInsetsGeometryDto.only(
          top: 10,
          bottom: 20,
          left: 30,
          right: 40,
        );
        expect(dto, isA<EdgeInsetsDto>());
        expect(dto.top?.resolve(EmptyMixData), equals(10));
        expect(dto.bottom?.resolve(EmptyMixData), equals(20));
        expect((dto as EdgeInsetsDto).left?.resolve(EmptyMixData), equals(30));
        expect((dto).right?.resolve(EmptyMixData), equals(40));
      },
    );

    test(
      'only creates EdgeInsetsDirectionalDto when directional values are provided',
      () {
        final dto = EdgeInsetsGeometryDto.only(
          top: 10,
          bottom: 20,
          start: 30,
          end: 40,
        );
        expect(dto, isA<EdgeInsetsDirectionalDto>());
        expect(dto.top?.resolve(EmptyMixData), equals(10));
        expect(dto.bottom?.resolve(EmptyMixData), equals(20));
        expect(
          (dto as EdgeInsetsDirectionalDto).start?.resolve(EmptyMixData),
          equals(30),
        );
        expect((dto).end?.resolve(EmptyMixData), equals(40));
      },
    );

    test('tryToMerge returns first dto if second is null', () {
      final dto1 = EdgeInsetsDto(top: 10, bottom: 20, left: 30, right: 40);
      final merged = EdgeInsetsGeometryDto.tryToMerge(dto1, null);
      expect(merged, equals(dto1));
    });

    test('tryToMerge returns second dto if first is null', () {
      final dto2 = EdgeInsetsDirectionalDto(
        top: 10,
        bottom: 20,
        start: 30,
        end: 40,
      );
      final merged = EdgeInsetsGeometryDto.tryToMerge(null, dto2);
      expect(merged, equals(dto2));
    });

    test('tryToMerge merges dtos of the same type', () {
      final dto1 = EdgeInsetsDto(top: 10, bottom: 20);
      final dto2 = EdgeInsetsDto(left: 30, right: 40);
      final merged = EdgeInsetsGeometryDto.tryToMerge(dto1, dto2);
      expect(merged, isA<EdgeInsetsDto>());
      expect(merged!.top, equals(const SpaceDto.value(10)));
      expect(merged.bottom, equals(const SpaceDto.value(20)));
      expect((merged as EdgeInsetsDto).left, equals(const SpaceDto.value(30)));
      expect((merged).right, equals(const SpaceDto.value(40)));
    });

    test('tryToMerge merges dtos of different types', () {
      final dto1 = EdgeInsetsDto(top: 10, bottom: 20);
      final dto2 = EdgeInsetsDirectionalDto(start: 30, end: 40);
      final merged = EdgeInsetsGeometryDto.tryToMerge(dto1, dto2);
      expect(merged, isA<EdgeInsetsDirectionalDto>());
      expect(merged!.top, equals(const SpaceDto.value(10)));
      expect(merged.bottom, equals(const SpaceDto.value(20)));
      expect(
        (merged as EdgeInsetsDirectionalDto).start,
        equals(const SpaceDto.value(30)),
      );
      expect((merged).end, equals(const SpaceDto.value(40)));
    });
  });

  group('EdgeInsetsDto', () {
    test('all constructor sets all values', () {
      final dto = EdgeInsetsDto.all(10);
      expect(dto.top, equals(const SpaceDto.value(10)));
      expect(dto.bottom, equals(const SpaceDto.value(10)));
      expect(dto.left, equals(const SpaceDto.value(10)));
      expect(dto.right, equals(const SpaceDto.value(10)));
    });

    test('none constructor sets all values to 0', () {
      final dto = EdgeInsetsDto.none();
      expect(dto.top, equals(const SpaceDto.value(0)));
      expect(dto.bottom, equals(const SpaceDto.value(0)));
      expect(dto.left, equals(const SpaceDto.value(0)));
      expect(dto.right, equals(const SpaceDto.value(0)));
    });

    test('resolve returns EdgeInsets with token values', () {
      final dto = EdgeInsetsDto(top: 10, bottom: 20, left: 30, right: 40);
      final mix = EmptyMixData;
      final resolved = dto.resolve(mix);
      expect(resolved, isA<EdgeInsets>());
      expect(resolved.top, equals(10));
      expect(resolved.bottom, equals(20));
      expect(resolved.left, equals(30));
      expect(resolved.right, equals(40));
    });
  });

  group('EdgeInsetsDirectionalDto', () {
    test('all constructor sets all values', () {
      final dto = EdgeInsetsDirectionalDto.all(10);
      expect(dto.top, equals(const SpaceDto.value(10)));
      expect(dto.bottom, equals(const SpaceDto.value(10)));
      expect(dto.start, equals(const SpaceDto.value(10)));
      expect(dto.end, equals(const SpaceDto.value(10)));
    });

    test('none constructor sets all values to 0', () {
      final dto = EdgeInsetsDirectionalDto.none();
      expect(dto.top, equals(const SpaceDto.value(0)));
      expect(dto.bottom, equals(const SpaceDto.value(0)));
      expect(dto.start, equals(const SpaceDto.value(0)));
      expect(dto.end, equals(const SpaceDto.value(0)));
    });

    test('resolve returns EdgeInsetsDirectional with token values', () {
      final dto = EdgeInsetsDirectionalDto(
        top: 10,
        bottom: 20,
        start: 30,
        end: 40,
      );
      final mix = EmptyMixData;
      final resolved = dto.resolve(mix);
      expect(resolved, isA<EdgeInsetsDirectional>());
      expect(resolved.top, equals(10));
      expect(resolved.bottom, equals(20));
      expect(resolved.start, equals(30));
      expect(resolved.end, equals(40));
    });
  });

  group('EdgeInsetsGeometryExt', () {
    test('toDto converts EdgeInsets to EdgeInsetsDto', () {
      const edgeInsets = EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );
      final dto = EdgeInsetsDto.from(edgeInsets);
      expect(dto, isA<EdgeInsetsDto>());
      expect(dto.top, equals(const SpaceDto.value(10)));
      expect(dto.bottom, equals(const SpaceDto.value(20)));
      expect(dto.left, equals(const SpaceDto.value(30)));
      expect((dto).right, equals(const SpaceDto.value(40)));
    });

    test(
      'toDto converts EdgeInsetsDirectional to EdgeInsetsDirectionalDto',
      () {
        const edgeInsetsDirectional = EdgeInsetsDirectional.only(
          top: 10,
          bottom: 20,
          start: 30,
          end: 40,
        );
        final dto = EdgeInsetsDirectionalDto.from(edgeInsetsDirectional);
        expect(dto, isA<EdgeInsetsDirectionalDto>());
        expect(dto.top, equals(const SpaceDto.value(10)));
        expect(dto.bottom, equals(const SpaceDto.value(20)));
        expect(
          dto.start,
          equals(const SpaceDto.value(30)),
        );
        expect((dto).end, equals(const SpaceDto.value(40)));
      },
    );
  });
}
