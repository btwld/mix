import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/internal/deep_collection_equality.dart';

void main() {
  group('DeepEqualityChecker hash code', () {
    const deepEquality = DeepCollectionEquality();
    test('checks primitive type equality', () {
      expect(deepEquality.equals(1, 1), isTrue);
      expect(deepEquality.equals('string', 'string'), isTrue);
      expect(deepEquality.equals(1.0, 1.0), isTrue);
      expect(deepEquality.equals(1, '1'), isFalse);
      expect(deepEquality.equals('1', 1), isFalse);
      expect(deepEquality.equals(1, 2), isFalse);
    });

    test('checks Map equality with simple types', () {
      expect(deepEquality.equals({'key': 'value'}, {'key': 'value'}), isTrue);
      expect(
        deepEquality.equals({'key1': 'value'}, {'key2': 'value'}),
        isFalse,
      );
      expect(
        deepEquality.equals({'key': 'value1'}, {'key': 'value2'}),
        isFalse,
      );
      expect(deepEquality.equals({}, {}), isTrue);
      expect(
        deepEquality.equals(
          {'key': 'value'},
          {'key': 'value', 'extra': 'value'},
        ),
        isFalse,
      );
    });

    test('checks Set equality with simple types', () {
      expect(deepEquality.equals({1, 2, 3}, {1, 2, 3}), isTrue);
      expect(deepEquality.equals({1, 2}, {1, 2, 3}), isFalse);
      expect(
        deepEquality.equals({3, 2, 1}, {1, 2, 3}),
        isTrue,
      ); // Order should not matter in sets
      // ignore: equal_elements_in_set
      expect(
        // ignore: equal_elements_in_set
        deepEquality.equals({1}, {1, 1, 1}),
        isTrue,
      ); // Duplicate elements in a set
    });

    test('checks Iterable equality with simple types', () {
      expect(deepEquality.equals([1, 2, 3], [1, 2, 3]), isTrue, reason: '1');
      expect(deepEquality.equals([1, 2, 3], [3, 2, 1]), isFalse, reason: '2');
      expect(deepEquality.equals([], []), isTrue, reason: '3');
      expect(deepEquality.equals([1, 2, 3], [1, 2]), isFalse, reason: '4');
    });

    test('checks nested collection equality', () {
      expect(
        deepEquality.equals(
          [
            {'key': 'value'},
            {'key2': 'value2'},
          ],
          [
            {'key': 'value'},
            {'key2': 'value2'},
          ],
        ),
        isTrue,
      );
      expect(
        deepEquality.equals(
          {
            'outer': {'inner': 'value'},
          },
          {
            'outer': {'inner': 'value'},
          },
        ),
        isTrue,
      );
      expect(
        deepEquality.equals(
          {
            'set': {1, 2, 3},
          },
          {
            'set': {3, 2, 1},
          },
        ),
        isTrue,
      );
      expect(
        deepEquality.equals(
          [
            1,
            [
              2,
              [3, 4],
            ],
          ],
          [
            1,
            [
              2,
              [3, 4],
            ],
          ],
        ),
        isTrue,
      );
      expect(
        deepEquality.equals(
          {
            'set': {1, 2, 3},
          },
          {
            'set': {1, 2},
          },
        ),
        isFalse,
      );
    });

    test('checks custom object equality', () {
      const obj1 = _CustomObject(id: 1, value: 'Test');
      const obj2 = _CustomObject(id: 1, value: 'Test');
      const obj3 = _CustomObject(id: 2, value: 'Test');

      expect(deepEquality.equals(obj1, obj2), isTrue);
      expect(deepEquality.equals(obj1, obj3), isFalse);
    });
    test('identical primitive values have the same hash code', () {
      expect(deepEquality.hash(123), deepEquality.hash(123));
      expect(deepEquality.hash('string'), deepEquality.hash('string'));
      expect(deepEquality.hash(true), deepEquality.hash(true));
    });

    test('lists with the same values produce the same hash code', () {
      var list1 = [1, 2, 3];
      var list2 = [1, 2, 3];
      expect(deepEquality.hash(list1), deepEquality.hash(list2));
    });

    test('sets with the same values produce the same hash code', () {
      var set1 = {1, 2, 3};
      var set2 = {3, 2, 1};
      expect(deepEquality.hash(set1), deepEquality.hash(set2));
    });

    test('maps with the same key-value pairs produce the same hash code', () {
      var map1 = {'a': 1, 'b': 2};
      var map2 = {'b': 2, 'a': 1};
      expect(deepEquality.hash(map1), deepEquality.hash(map2));
    });

    test(
      'nested collections with identical contents produce the same hash code',
      () {
        var nestedList1 = [
          [1, 2],
          {'a': 1},
        ];
        var nestedList2 = [
          [1, 2],
          {'a': 1},
        ];
        expect(deepEquality.hash(nestedList1), deepEquality.hash(nestedList2));
      },
    );

    test('unordered collections produce consistent hash codes', () {
      var iterable1 = {3, 2, 1};
      var iterable2 = {1, 2, 3};
      expect(deepEquality.hash(iterable1), deepEquality.hash(iterable2));
    });

    test(
      'custom objects with the same properties produce the same hash code',
      () {
        var object1 = const _CustomObject(id: 1, value: 'test');
        var object2 = const _CustomObject(id: 1, value: 'test');
        expect(deepEquality.hash(object1), deepEquality.hash(object2));
      },
    );

    test('different collections do not produce the same hash code', () {
      var list = [1, 2, 3];
      var set = {1, 2, 3};
      // It's possible but highly unlikely that these two will have the same hash code
      expect(deepEquality.hash(list), isNot(deepEquality.hash(set)));
    });

    test(
      'collections with null values handled properly in hash code computation',
      () {
        var listWithNull = [null, 2, 3];
        var listWithoutNull = [1, 2, 3];
        // Should not throw an exception and should not be equal
        expect(() => deepEquality.hash(listWithNull), returnsNormally);
        expect(
          deepEquality.hash(listWithNull),
          isNot(deepEquality.hash(listWithoutNull)),
        );
      },
    );

    test('hash code computation is efficient for large collections', () {
      var largeList = List.generate(100000, (index) => index);
      var timeStart = DateTime.now();
      deepEquality.hash(largeList);
      var timeEnd = DateTime.now();
      expect(
        timeEnd.difference(timeStart),
        lessThan(const Duration(seconds: 1)),
      );
    });

    test('checks nested custom object equality', () {
      const nestedObj1 = _AnotherCustomObject(
        id: 1,
        name: 'Nested',
        children: [
          _AnotherCustomObject(id: 2, name: 'Child', children: []),
          _AnotherCustomObject(id: 3, name: 'Child3', children: []),
          _AnotherCustomObject(
            id: 4,
            name: 'Child2',
            children: [
              _AnotherCustomObject(id: 5, name: 'Child3', children: []),
            ],
          ),
        ],
      );

      const nestedObj2 = _AnotherCustomObject(
        id: 1,
        name: 'Nested',
        children: [
          _AnotherCustomObject(id: 2, name: 'Child', children: []),
          _AnotherCustomObject(id: 3, name: 'Child3', children: []),
          _AnotherCustomObject(
            id: 4,
            name: 'Child2',
            children: [
              _AnotherCustomObject(id: 5, name: 'Child3', children: []),
            ],
          ),
        ],
      );

      const nestedObjDifferent = _AnotherCustomObject(
        id: 1,
        name: 'Nested',
        children: [
          _AnotherCustomObject(id: 2, name: 'Child', children: []),
          _AnotherCustomObject(id: 3, name: 'Child3', children: []),
          _AnotherCustomObject(
            id: 4,
            name: 'ChildX',
            children: [
              _AnotherCustomObject(id: 5, name: 'Child3', children: []),
            ],
          ),
        ],
      );

      expect(deepEquality.equals(nestedObj1, nestedObj2), isTrue);
      expect(deepEquality.equals(nestedObj1, nestedObjDifferent), isFalse);
    });

    test('ignores runtime type differences for inheritance', () {
      const baseShape = _BaseShape(name: 'shape1', id: 1);
      const extendedShape = _ExtendedShape(name: 'shape1', id: 1);

      expect(deepEquality.equals(baseShape, extendedShape), isTrue);

      final list1 = [baseShape, extendedShape];
      final list2 = [extendedShape, baseShape];

      expect(deepEquality.equals(list1, list2), isTrue);
    });

    test('matches extended shape instances with same values in lists', () {
      const extendedShape1 = _ExtendedShape(name: 'shape1', id: 1);
      const extendedShape2 = _ExtendedShape(name: 'shape1', id: 1);

      final list1 = [extendedShape1];
      final list2 = [extendedShape2];

      expect(deepEquality.equals(list1, list2), isTrue);

      // Test with different values to ensure it fails when it should
      const extendedShape3 = _ExtendedShape(name: 'shape2', id: 2);
      final list3 = [extendedShape3];

      expect(deepEquality.equals(list1, list3), isFalse);
    });
  });
}

// A dummy custom object class for testing purposes
class _CustomObject {
  final int id;
  final String value;

  const _CustomObject({required this.id, required this.value});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _CustomObject && other.id == id && other.value == value;
  }

  @override
  int get hashCode => Object.hash(id, value);
}

class _AnotherCustomObject {
  final int id;
  final String name;
  final List<_AnotherCustomObject> children;

  const _AnotherCustomObject({
    required this.id,
    required this.name,
    this.children = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AnotherCustomObject &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          listEquals(children, other.children);

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(children));
}

class _BaseShape {
  final String name;
  final int id;

  const _BaseShape({required this.name, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BaseShape && name == other.name && id == other.id;

  @override
  int get hashCode => Object.hash(name, id);
}

class _ExtendedShape extends _BaseShape {
  const _ExtendedShape({required super.name, required super.id});
}
