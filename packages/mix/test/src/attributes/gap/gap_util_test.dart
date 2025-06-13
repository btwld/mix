import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('GapUtility', () {
    final utility = GapUtility(UtilityTestDtoAttribute.new);

    test('should create attribute with double value', () {
      final attribute = utility(16.0);
      expect(attribute.value.value, 16.0);
    });

    test('should create attribute with different double values', () {
      final attr1 = utility(8.0);
      final attr2 = utility(24.5);
      final attr3 = utility(0.0);

      expect(attr1.value.value, 8.0);
      expect(attr2.value.value, 24.5);
      expect(attr3.value.value, 0.0);
    });

    test('should create attribute with space token reference', () {
      const token = SpaceToken('test-space');
      final attribute = utility.ref(token);
      
      // The token() call returns the resolved value
      expect(attribute.value.value, token());
      expect(attribute.value.value, isA<double>());
    });

    test('should resolve double value correctly', () {
      final attribute = utility(20.0);
      final mixData = MockMixData(Style());
      
      final resolved = attribute.resolve(mixData);
      expect(resolved, 20.0);
    });


    test('should handle negative values', () {
      final attribute = utility(-16.0);
      expect(attribute.value.value, -16.0);
    });

    test('should handle very large values', () {
      final attribute = utility(999999.0);
      expect(attribute.value.value, 999999.0);
    });
  });
}