import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('BorderRadiusDto', () {
    test('merge returns merged object correctly', () {
      const attr1 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(5.0)),
        topRight: Mixable.value(Radius.circular(10.0)),
        bottomLeft: Mixable.value(Radius.circular(15.0)),
        bottomRight: Mixable.value(Radius.circular(20.0)),
      );

      const attr2 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(25.0)),
        topRight: Mixable.value(Radius.circular(30.0)),
        bottomLeft: Mixable.value(Radius.circular(35.0)),
        bottomRight: Mixable.value(Radius.circular(40.0)),
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
      const borderRadius1 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(30)),
        topRight: Mixable.value(Radius.circular(40)),
        bottomLeft: Mixable.value(Radius.circular(10)),
        bottomRight: Mixable.value(Radius.circular(20)),
      );
      const borderRadius2 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(20)),
        bottomRight: Mixable.value(Radius.circular(50)),
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
      const borderRadius = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(10)),
        topRight: Mixable.value(Radius.circular(20)),
        bottomLeft: Mixable.value(Radius.circular(30)),
        bottomRight: Mixable.value(Radius.circular(40)),
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
      const attr1 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(5.0)),
        topRight: Mixable.value(Radius.circular(10.0)),
        bottomLeft: Mixable.value(Radius.circular(15.0)),
        bottomRight: Mixable.value(Radius.circular(20.0)),
      );
      const attr2 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(5.0)),
        topRight: Mixable.value(Radius.circular(10.0)),
        bottomLeft: Mixable.value(Radius.circular(15.0)),
        bottomRight: Mixable.value(Radius.circular(20.0)),
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });

    test('Equality fails when properties are different', () {
      const attr1 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(5.0)),
        topRight: Mixable.value(Radius.circular(10.0)),
        bottomLeft: Mixable.value(Radius.circular(15.0)),
        bottomRight: Mixable.value(Radius.circular(20.0)),
      );

      const attr2 = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(5.0)),
        topRight: Mixable.value(Radius.circular(10.0)),
        bottomLeft: Mixable.value(Radius.circular(15.0)),
        bottomRight: Mixable.value(Radius.circular(25.0)),
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });

  group('BorderRadiusDirectionalDto', () {
    test('merge returns merged object correctly', () {
      const attr1 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(5.0)),
        topEnd: Mixable.value(Radius.circular(10.0)),
        bottomStart: Mixable.value(Radius.circular(15.0)),
        bottomEnd: Mixable.value(Radius.circular(20.0)),
      );

      const attr2 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(25.0)),
        topEnd: Mixable.value(Radius.circular(30.0)),
        bottomStart: Mixable.value(Radius.circular(35.0)),
        bottomEnd: Mixable.value(Radius.circular(40.0)),
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
      const borderRadius1 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(10)),
        topEnd: Mixable.value(Radius.circular(10)),
        bottomStart: Mixable.value(Radius.circular(10)),
        bottomEnd: Mixable.value(Radius.circular(10)),
      );
      const borderRadius2 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(20)),
        bottomEnd: Mixable.value(Radius.circular(30)),
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
        const borderRadius = BorderRadiusDirectionalDto(
          topStart: Mixable.value(Radius.circular(10)),
          topEnd: Mixable.value(Radius.circular(20)),
          bottomStart: Mixable.value(Radius.circular(30)),
          bottomEnd: Mixable.value(Radius.circular(40)),
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
      const attr1 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(5.0)),
        topEnd: Mixable.value(Radius.circular(10.0)),
        bottomStart: Mixable.value(Radius.circular(15.0)),
        bottomEnd: Mixable.value(Radius.circular(20.0)),
      );
      const attr2 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(5.0)),
        topEnd: Mixable.value(Radius.circular(10.0)),
        bottomStart: Mixable.value(Radius.circular(15.0)),
        bottomEnd: Mixable.value(Radius.circular(20.0)),
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });

    test('Equality fails when properties are different', () {
      const attr1 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(5.0)),
        topEnd: Mixable.value(Radius.circular(10.0)),
        bottomStart: Mixable.value(Radius.circular(15.0)),
        bottomEnd: Mixable.value(Radius.circular(20.0)),
      );

      const attr2 = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(5.0)),
        topEnd: Mixable.value(Radius.circular(10.0)),
        bottomStart: Mixable.value(Radius.circular(15.0)),
        bottomEnd: Mixable.value(Radius.circular(25.0)),
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });

  group('BorderSideDto', () {
    test('from constructor sets all values correctly', () {
      const attr = BorderSideDto(
        color: Mixable.value(Colors.red),
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr.color?.resolve(EmptyMixData), Colors.red);
      expect(attr.width, 1.0);
      expect(attr.style, BorderStyle.solid);
    });
    test('resolve returns correct BorderSide', () {
      const attr = BorderSideDto(
        color: Mixable.value(Colors.red),
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
      const attr1 = BorderSideDto(
        color: Mixable.value(Colors.red),
        style: BorderStyle.solid,
        width: 1.0,
      );
      const attr2 = BorderSideDto(
        color: Mixable.value(Colors.red),
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, attr2);
      expect(attr1.hashCode, attr2.hashCode);
    });
    test('Equality fails when attributes are different', () {
      const attr1 = BorderSideDto(
        color: Mixable.value(Colors.red),
        style: BorderStyle.solid,
        width: 1.0,
      );
      const attr2 = BorderSideDto(
        color: Mixable.value(Colors.blue),
        style: BorderStyle.solid,
        width: 1.0,
      );
      expect(attr1, isNot(attr2));
      expect(attr1.hashCode, isNot(attr2.hashCode));
    });
  });
  group('BorderRadiusGeometryDto', () {
    test('getRadiusValue returns Radius.zero when radius is null', () {
      const dto = BorderRadiusDto();
      final radius = dto.getRadiusValue(EmptyMixData, null);
      expect(radius, Radius.zero);
    });

    test('debugFillProperties adds all properties', () {
      const dto = BorderRadiusDto(
        topLeft: Mixable.value(Radius.circular(1)),
        topRight: Mixable.value(Radius.circular(2)),
        bottomLeft: Mixable.value(Radius.circular(3)),
        bottomRight: Mixable.value(Radius.circular(4)),
      );
      final properties = DiagnosticPropertiesBuilder();
      dto.debugFillProperties(properties);
      expect(properties.properties.length, 8);
      expect(properties.properties[0].name, 'topLeft');
      expect(properties.properties[1].name, 'topRight');
      expect(properties.properties[2].name, 'bottomLeft');
      expect(properties.properties[3].name, 'bottomRight');
      expect(properties.properties[4].name, 'topStart');
      expect(properties.properties[5].name, 'topEnd');
      expect(properties.properties[6].name, 'bottomStart');
      expect(properties.properties[7].name, 'bottomEnd');
    });
  });

  group('BorderRadiusDirectionalDto', () {
    test('resolve returns BorderRadiusDirectional with null values', () {
      const dto = BorderRadiusDirectionalDto();
      final resolved = dto.resolve(EmptyMixData);
      expect(resolved, BorderRadiusDirectional.zero);
    });

    test('topLeft, topRight, bottomLeft, and bottomRight are always null', () {
      const dto = BorderRadiusDirectionalDto(
        topStart: Mixable.value(Radius.circular(1)),
        topEnd: Mixable.value(Radius.circular(2)),
        bottomStart: Mixable.value(Radius.circular(3)),
        bottomEnd: Mixable.value(Radius.circular(4)),
      );
      expect(dto.topLeft, isNull);
      expect(dto.topRight, isNull);
      expect(dto.bottomLeft, isNull);
      expect(dto.bottomRight, isNull);
    });
  });
}
