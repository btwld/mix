import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/equatable.dart';

void main() {
  group('Equatable', () {
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

    group('propsEquals and propsDiff', () {
      test('propsEquals matches Equatable equality for equal props', () {
        final left = TestClass(1, 'A');
        final right = TestClass(1, 'A');

        expect(propsEquals(left.props, right.props), isTrue);
        expect(left.getDiff(right), isEmpty);
      });

      test('propsEquals rejects unequal props', () {
        final left = TestClass(1, 'A');
        final right = TestClass(2, 'B');

        expect(propsEquals(left.props, right.props), isFalse);
        expect(left.getDiff(right), isNotEmpty);
      });

      test('propsDiff reports prop list length mismatch', () {
        final diff = propsDiff([1, 'A'], [1, 'A', true]);

        expect(diff['props.length'], 'this: 2, other: 3');
      });

      test('propsHash is stable for equal prop lists', () {
        final left = TestClass(1, 'A');
        final right = TestClass(1, 'A');

        expect(
          propsHash(left.runtimeType, left.props),
          propsHash(right.runtimeType, right.props),
        );
      });
    });
  });
}

class TestClass with Equatable {
  final int id;
  final String name;

  TestClass(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

class DeepNestedClass with Equatable {
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
