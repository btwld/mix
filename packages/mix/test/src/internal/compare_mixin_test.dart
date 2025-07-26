import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/internal/compare_mixin.dart';

void main() {
  group('EquatableMixin', () {
    test('Should have correct equality', () {
      final instance1 = TestClass(1, "A");
      final instance2 = TestClass(1, "A");
      final instance3 = TestClass(2, "B");

      expect(instance1, instance2);
      expect(instance1, isNot(instance3));
      expect(instance2, isNot(instance3));
    });

    test('Should have correct hashCode', () {
      final instance1 = TestClass(1, "A");
      final instance2 = TestClass(1, "A");
      final instance3 = TestClass(2, "B");

      expect(instance1.hashCode, instance2.hashCode);
      expect(instance1.hashCode, isNot(instance3.hashCode));
    });

    test('Should have correct toString', () {
      final instance = TestClass(1, "A");
      expect(instance.toString(), 'TestClass(1, A)');
    });

    test('Deep nested class Should have correct equality', () {
      final instance1 = DeepNestedClass(deepNestedMap, deepNestedList);
      final instance2 = DeepNestedClass(deepNestedMap, deepNestedList);
      final instance3 = DeepNestedClass(
        {
          'key1': {'innerKey1': 1, 'innerKey2': 999},
        },
        [
          [
            ['value1', 'value2'],
            ['value3', 'value4'],
          ],
          [
            ['value5', 'value6'],
            ['value7', 'value8'],
          ],
        ],
      );

      expect(instance1, instance2);
      expect(instance1, isNot(instance3));
      expect(instance2, isNot(instance3));
    });

    test('Deep nested class Should have correct hashCode', () {
      final instance1 = DeepNestedClass(deepNestedMap, deepNestedList);
      final instance2 = DeepNestedClass(deepNestedMap, deepNestedList);
      final instance3 = DeepNestedClass(
        {
          'key1': {'innerKey1': 1, 'innerKey2': 999},
        },
        [
          [
            ['value1', 'value2'],
            ['value3', 'value4'],
          ],
          [
            ['value5', 'value6'],
            ['value7', 'value8'],
          ],
        ],
      );

      expect(instance1.hashCode, instance2.hashCode);
      expect(instance1.hashCode, isNot(instance3.hashCode));
    });

    test('Deep nested class Should have correct toString', () {
      final instance = DeepNestedClass(deepNestedMap, deepNestedList);
      expect(
        instance.toString(),
        'DeepNestedClass({key1: {innerKey1: 1, innerKey2: 2},'
        ' key2: {innerKey3: 3, innerKey4: 4}},'
        ' [[[value1, value2], [value3, value4]],'
        ' [[value5, value6], [value7, value8]]])',
      );
    });
  });
}

class TestClass with EqualityMixin {
  final int id;
  final String name;

  TestClass(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

class DeepNestedClass with EqualityMixin {
  final Map<String, Map<String, int>> deepNestedMap;
  final List<List<List<String>>> deepNestedList;

  DeepNestedClass(this.deepNestedMap, this.deepNestedList);

  @override
  List<Object?> get props => [deepNestedMap, deepNestedList];
}

Map<String, Map<String, int>> deepNestedMap = {
  'key1': {'innerKey1': 1, 'innerKey2': 2},
  'key2': {'innerKey3': 3, 'innerKey4': 4},
};

List<List<List<String>>> deepNestedList = [
  [
    ['value1', 'value2'],
    ['value3', 'value4'],
  ],
  [
    ['value5', 'value6'],
    ['value7', 'value8'],
  ],
];