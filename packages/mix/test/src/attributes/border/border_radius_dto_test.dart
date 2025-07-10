import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderRadiusDto', () {
    test('merge returns merged object correctly', () {
      final attr1 = BorderRadiusDto(
        topLeft: const Radius.circular(5.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(20.0),
      );

      final attr2 = BorderRadiusDto(
        topLeft: const Radius.circular(25.0),
        topRight: const Radius.circular(30.0),
        bottomLeft: const Radius.circular(35.0),
        bottomRight: const Radius.circular(40.0),
      );

      final merged = attr1.merge(attr2);

      expect(
        merged.topLeft?.resolve(EmptyMixData),
        attr2.topLeft?.resolve(EmptyMixData),
      );
      expect(
        merged.topRight?.resolve(EmptyMixData),
        attr2.topRight?.resolve(EmptyMixData),
      );
      expect(
        merged.bottomLeft?.resolve(EmptyMixData),
        attr2.bottomLeft?.resolve(EmptyMixData),
      );
      expect(
        merged.bottomRight?.resolve(EmptyMixData),
        attr2.bottomRight?.resolve(EmptyMixData),
      );
    });

    test('merge should combine two BorderRadiusDto correctly', () {
      final borderRadius1 = BorderRadiusDto(
        topLeft: const Radius.circular(30),
        topRight: const Radius.circular(40),
        bottomLeft: const Radius.circular(10),
        bottomRight: const Radius.circular(20),
      );
      final borderRadius2 = BorderRadiusDto(
        topLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(50),
      );

      final mergedBorderRadius = borderRadius1.merge(borderRadius2);

      expect(
        mergedBorderRadius.topLeft?.resolve(EmptyMixData),
        const Radius.circular(20),
      );
      expect(
        mergedBorderRadius.topRight?.resolve(EmptyMixData),
        const Radius.circular(40),
      );
      expect(
        mergedBorderRadius.bottomLeft?.resolve(EmptyMixData),
        const Radius.circular(10),
      );
      expect(
        mergedBorderRadius.bottomRight?.resolve(EmptyMixData),
        const Radius.circular(50),
      );
    });

    test('resolve should create a BorderRadius with the correct values', () {
      final borderRadius = BorderRadiusDto(
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(20),
        bottomLeft: const Radius.circular(30),
        bottomRight: const Radius.circular(40),
      );

      final resolvedBorderRadius = borderRadius.resolve(EmptyMixData);

      expect(
        resolvedBorderRadius,
        const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(40),
        ),
      );
    });

    test('Equality holds when properties are the same', () {
      final attr1 = BorderRadiusDto(
        topLeft: const Radius.circular(5.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(20.0),
      );
      final attr2 = BorderRadiusDto(
        topLeft: const Radius.circular(5.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(20.0),
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });

    test('Equality fails when properties are different', () {
      final attr1 = BorderRadiusDto(
        topLeft: const Radius.circular(5.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(20.0),
      );

      final attr2 = BorderRadiusDto(
        topLeft: const Radius.circular(5.0),
        topRight: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(25.0),
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });

  group('BorderRadiusDirectionalDto', () {
    test('merge returns merged object correctly', () {
      final attr1 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(5.0),
        topEnd: const Radius.circular(10.0),
        bottomStart: const Radius.circular(15.0),
        bottomEnd: const Radius.circular(20.0),
      );

      final attr2 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(25.0),
        topEnd: const Radius.circular(30.0),
        bottomStart: const Radius.circular(35.0),
        bottomEnd: const Radius.circular(40.0),
      );

      final merged = attr1.merge(attr2);

      expect(
        merged.topStart?.resolve(EmptyMixData),
        attr2.topStart?.resolve(EmptyMixData),
      );
      expect(
        merged.topEnd?.resolve(EmptyMixData),
        attr2.topEnd?.resolve(EmptyMixData),
      );
      expect(
        merged.bottomStart?.resolve(EmptyMixData),
        attr2.bottomStart?.resolve(EmptyMixData),
      );
      expect(
        merged.bottomEnd?.resolve(EmptyMixData),
        attr2.bottomEnd?.resolve(EmptyMixData),
      );
    });

    test('merge should combine two BorderRadiusDirectionalDto correctly', () {
      final borderRadius1 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(10),
        topEnd: const Radius.circular(10),
        bottomStart: const Radius.circular(10),
        bottomEnd: const Radius.circular(10),
      );
      final borderRadius2 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(20),
        bottomEnd: const Radius.circular(30),
      );

      final mergedBorderRadius = borderRadius1.merge(borderRadius2);

      expect(
        mergedBorderRadius.topStart?.resolve(EmptyMixData),
        const Radius.circular(20),
      );
      expect(
        mergedBorderRadius.topEnd?.resolve(EmptyMixData),
        const Radius.circular(10),
      );
      expect(
        mergedBorderRadius.bottomStart?.resolve(EmptyMixData),
        const Radius.circular(10),
      );
      expect(
        mergedBorderRadius.bottomEnd?.resolve(EmptyMixData),
        const Radius.circular(30),
      );
    });

    test(
      'resolve should create a BorderRadiusDirectional with the correct values',
      () {
        final borderRadius = BorderRadiusDirectionalDto(
          topStart: const Radius.circular(10),
          topEnd: const Radius.circular(20),
          bottomStart: const Radius.circular(30),
          bottomEnd: const Radius.circular(40),
        );

        final resolvedBorderRadius = borderRadius.resolve(EmptyMixData);

        expect(
          resolvedBorderRadius,
          const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(20),
            bottomStart: Radius.circular(30),
            bottomEnd: Radius.circular(40),
          ),
        );
      },
    );

    test('Equality holds when properties are the same', () {
      final attr1 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(5.0),
        topEnd: const Radius.circular(10.0),
        bottomStart: const Radius.circular(15.0),
        bottomEnd: const Radius.circular(20.0),
      );
      final attr2 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(5.0),
        topEnd: const Radius.circular(10.0),
        bottomStart: const Radius.circular(15.0),
        bottomEnd: const Radius.circular(20.0),
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });

    test('Equality fails when properties are different', () {
      final attr1 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(5.0),
        topEnd: const Radius.circular(10.0),
        bottomStart: const Radius.circular(15.0),
        bottomEnd: const Radius.circular(20.0),
      );

      final attr2 = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(5.0),
        topEnd: const Radius.circular(10.0),
        bottomStart: const Radius.circular(15.0),
        bottomEnd: const Radius.circular(25.0),
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });

  group('BorderSideDto', () {
    test('from constructor sets all values correctly', () {
      final attr = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr.color?.resolve(EmptyMixData), Colors.red);
      expect(attr.width?.resolve(EmptyMixData), 1.0);
      expect(attr.style?.resolve(EmptyMixData), BorderStyle.solid);
    });
    test('resolve returns correct BorderSide', () {
      final attr = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      final borderSide = attr.resolve(EmptyMixData);
      expect(
        borderSide,
        const BorderSide(
          color: Colors.red,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      );
    });
    test('Equality holds when all attributes are the same', () {
      final attr1 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      final attr2 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });
    test('Equality fails when attributes are different', () {
      final attr1 = BorderSideDto(
        color: Colors.red,
        style: BorderStyle.solid,
        width: 1.0,
      );
      final attr2 = BorderSideDto(
        color: Colors.blue,
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });
  group('BorderRadiusGeometryDto', () {
    test('getRadiusValue returns Radius.zero when radius is null', () {
      final dto = BorderRadiusDto();
      final radius = dto.getRadiusValue(EmptyMixData, null);
      expect(radius, Radius.zero);
    });

    // debugFillProperties test removed as BorderRadiusDto doesn't implement Diagnosticable
  });

  group('BorderRadiusDirectionalDto', () {
    test('resolve returns BorderRadiusDirectional with null values', () {
      final dto = BorderRadiusDirectionalDto();
      final resolved = dto.resolve(EmptyMixData);
      expect(resolved, BorderRadiusDirectional.zero);
    });

    test('topLeft, topRight, bottomLeft, and bottomRight are always null', () {
      final dto = BorderRadiusDirectionalDto(
        topStart: const Radius.circular(1),
        topEnd: const Radius.circular(2),
        bottomStart: const Radius.circular(3),
        bottomEnd: const Radius.circular(4),
      );
      expect(dto.topLeft, isNull);
      expect(dto.topRight, isNull);
      expect(dto.bottomLeft, isNull);
      expect(dto.bottomRight, isNull);
    });
  });
}
