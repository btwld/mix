import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MixableMap Tests', () {
    // Sample attribute objects for testing
    const attr1 = MockIntScalarAttribute(2);
    const attr2 = MockBooleanScalarAttribute(true);

    test('Empty constructor creates an empty map', () {
      const mixableMap = AttributeMap.empty();
      expect(mixableMap.length, 0);
      expect(mixableMap.isEmpty, isTrue);
      expect(mixableMap.isNotEmpty, isFalse);
      expect(mixableMap.values, isEmpty);
    });

    test('Factory constructor initializes map with given attributes', () {
      final mixableMap = AttributeMap([attr1, attr2]);
      expect(mixableMap.length, 2);
      expect(mixableMap.isEmpty, isFalse);
      expect(mixableMap.isNotEmpty, isTrue);
      expect(mixableMap.values, containsAll([attr1, attr2]));
    });

    test('MergeMap merges non-mergeable attributes correctly', () {
      final mixableMap = AttributeMap([attr1, attr2]);
      expect(mixableMap.containsType(attr1), isTrue);
      expect(mixableMap.containsType(attr2), isTrue);
      expect(mixableMap.containsValue(attr1), isTrue);
      expect(mixableMap.containsValue(attr2), isTrue);
      expect(mixableMap.length, 2);
    });

    test('MergeMap merges mergeable attributes correctly', () {
      const mergeAttr1 = MockIntScalarAttribute(2);
      const mergeAttr2 = MockIntScalarAttribute(3);

      final mixableMap = AttributeMap([mergeAttr1, mergeAttr2]);
      expect(mixableMap.containsType(mergeAttr1), isTrue);
      expect(mixableMap.containsType(mergeAttr2), isTrue);

      expect(mixableMap.length, 1);
    });

    test('contains returns correct value', () {
      final mixableMap = AttributeMap<SpecMix>([attr1]);
      expect(mixableMap.containsType(attr1), isTrue);
      expect(mixableMap.containsType(attr2), isFalse);
    });

    test('attributeOfType retrieves correct attribute', () {
      const attr1 = MockIntScalarAttribute(2);
      const attr2 = MockSpecBooleanAttribute(true);
      final mixableMap = AttributeMap([attr1, attr2]);
      final retrievedAttribute = mixableMap
          .attributeOfType<MockSpecBooleanAttribute>();

      expect(retrievedAttribute, isNotNull);
      expect(retrievedAttribute, attr2);
    });

    test('whereType filters attributes correctly', () {
      const attr1 = MockIntScalarAttribute(2);
      const attr2 = MockBooleanScalarAttribute(true);
      const attr3 = MockDoubleScalarAttribute(2.0);

      final mixableMap = AttributeMap([attr1, attr2]);
      final filteredAttributes = mixableMap.whereType<MockIntScalarAttribute>();
      expect(filteredAttributes, contains(attr1));
      expect(filteredAttributes, isNot(contains(attr3)));
    });

    test('merge combines two MixableMaps correctly', () {
      const attr1 = MockIntScalarAttribute(2);
      const attr2 = MockBooleanScalarAttribute(true);

      final mixableMap1 = AttributeMap<SpecMix>([attr1]);
      final mixableMap2 = AttributeMap<SpecMix>([attr2]);
      final mergedMap = mixableMap1.merge(mixableMap2);
      expect(mergedMap.values, containsAll([attr1, attr2]));
    });

    // equality
    test('Equality holds when all properties are the same', () {
      const attr1 = MockIntScalarAttribute(2);
      const attr2 = MockBooleanScalarAttribute(false);

      final mixableMap1 = AttributeMap([attr1]);
      final mixableMap2 = AttributeMap([attr1]);
      expect(mixableMap1, mixableMap2);

      final mixableMap3 = AttributeMap([attr2]);

      expect(mixableMap1, isNot(mixableMap3));
    });
  });
}
