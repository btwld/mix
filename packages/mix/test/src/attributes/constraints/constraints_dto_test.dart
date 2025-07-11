import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/attributes/constraints/constraints_dto.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('BoxConstraintsDto', () {
    test('from constructor sets all values correctly', () {
      const constraints = BoxConstraints(
        minWidth: 50,
        maxWidth: 150,
        minHeight: 100,
        maxHeight: 200,
      );
      final constraintsDto = BoxConstraintsDto.value(constraints);

      expect(constraints.minWidth, 50);
      expect(constraints.maxWidth, 150);
      expect(constraints.minHeight, 100);
      expect(constraints.maxHeight, 200);

      expect(constraintsDto.minWidth, 50);
      expect(constraintsDto.maxWidth, 150);
      expect(constraintsDto.minHeight, 100);
      expect(constraintsDto.maxHeight, 200);
    });
    test('merge returns merged object correctly', () {
      final constraints1 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
      final constraints2 = BoxConstraintsDto(minWidth: 60, minHeight: 110);
      final merged = constraints1.merge(constraints2);
      expect(merged.minWidth, 60);
      expect(merged.minHeight, 110);
      expect(merged.maxWidth, isNull);
      expect(merged.maxHeight, isNull);
    });
    test('resolve returns correct BoxConstraints with default values', () {
      final constraints = BoxConstraintsDto();

      expect(constraints, isA<BoxConstraintsDto>());
      expect(constraints.minWidth, isNull);
      expect(constraints.maxWidth, isNull);
      expect(constraints.minHeight, isNull);
      expect(constraints.maxHeight, isNull);
      
      expect(
        constraints,
        resolvesTo(
          const BoxConstraints(
            minWidth: 0,
            maxWidth: double.infinity,
            minHeight: 0,
            maxHeight: double.infinity,
          ),
        ),
      );
    });
    test('resolve returns correct BoxConstraints with specific values', () {
      final constraints = BoxConstraintsDto(minWidth: 50, minHeight: 100);

      expect(constraints, isA<BoxConstraintsDto>());
      expect(constraints.minWidth, 50);
      expect(constraints.maxWidth, isNull);
      expect(constraints.minHeight, 100);

      expect(
        constraints,
        resolvesTo(
          const BoxConstraints(
            minWidth: 50,
            maxWidth: double.infinity,
            minHeight: 100,
            maxHeight: double.infinity,
          ),
        ),
      );
    });
    test('Equality holds when all properties are the same', () {
      final constraints1 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
      final constraints2 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
      expect(constraints1, constraints2);
    });
    test('Equality fails when properties are different', () {
      final constraints1 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
      final constraints2 = BoxConstraintsDto(minWidth: 60, minHeight: 100);
      expect(constraints1, isNot(constraints2));
    });
  });
}
