import 'package:mix_schema/src/_internal.dart';
import 'package:test/test.dart';

void main() {
  group('deepEquals — primitives', () {
    test('null equals null', () {
      expect(deepEquals(null, null), isTrue);
    });

    test('null does not equal anything else', () {
      expect(deepEquals(null, 0), isFalse);
      expect(deepEquals(null, ''), isFalse);
      expect(deepEquals(null, false), isFalse);
    });

    test('strings compare via ==', () {
      expect(deepEquals('foo', 'foo'), isTrue);
      expect(deepEquals('foo', 'bar'), isFalse);
    });

    test('booleans compare via ==', () {
      expect(deepEquals(true, true), isTrue);
      expect(deepEquals(false, false), isTrue);
      expect(deepEquals(true, false), isFalse);
    });

    test('int and double are equal when numerically equal (16 == 16.0)', () {
      expect(deepEquals(16, 16.0), isTrue);
      expect(deepEquals(0, 0.0), isTrue);
      expect(deepEquals(-1, -1.0), isTrue);
    });

    test('different numbers are not equal', () {
      expect(deepEquals(16, 17), isFalse);
      expect(deepEquals(16.0, 16.5), isFalse);
    });
  });

  group('deepEquals — maps', () {
    test('empty maps are equal', () {
      expect(deepEquals(<String, Object?>{}, <String, Object?>{}), isTrue);
    });

    test('matching maps are equal regardless of key order', () {
      final a = {'a': 1, 'b': 2};
      final b = {'b': 2, 'a': 1};
      expect(deepEquals(a, b), isTrue);
    });

    test('different key sets are not equal', () {
      expect(deepEquals({'a': 1}, {'b': 1}), isFalse);
    });

    test('different sizes are not equal', () {
      expect(deepEquals({'a': 1}, {'a': 1, 'b': 2}), isFalse);
    });

    test('different values are not equal', () {
      expect(deepEquals({'a': 1}, {'a': 2}), isFalse);
    });

    test('recurses into nested maps', () {
      final a = {
        'top': {'inner': 'value'},
      };
      final b = {
        'top': {'inner': 'value'},
      };
      expect(deepEquals(a, b), isTrue);
    });
  });

  group('deepEquals — lists', () {
    test('empty lists are equal', () {
      expect(deepEquals(<Object?>[], <Object?>[]), isTrue);
    });

    test('lists are equal element-wise in order', () {
      expect(deepEquals([1, 2, 3], [1, 2, 3]), isTrue);
    });

    test('lists are NOT equal when order differs', () {
      expect(deepEquals([1, 2, 3], [3, 2, 1]), isFalse);
    });

    test('different lengths are not equal', () {
      expect(deepEquals([1, 2], [1, 2, 3]), isFalse);
    });

    test('recurses into nested lists', () {
      expect(
        deepEquals(
          [
            [1, 2],
            [3, 4],
          ],
          [
            [1, 2],
            [3, 4],
          ],
        ),
        isTrue,
      );
    });
  });

  group('deepEquals — mixed structures', () {
    test('canonical Value with int matches canonical Value with double', () {
      final a = {
        'value': {'top': 16, 'left': 16, 'right': 16, 'bottom': 16},
      };
      final b = {
        'value': {'top': 16.0, 'left': 16.0, 'right': 16.0, 'bottom': 16.0},
      };
      expect(deepEquals(a, b), isTrue);
    });

    test('disagreement deep in tree returns false', () {
      final a = {
        'root': {
          'children': [
            {'widget': 'Box'},
            {'widget': 'Box'},
          ],
        },
      };
      final b = {
        'root': {
          'children': [
            {'widget': 'Box'},
            {'widget': 'StyledText'},
          ],
        },
      };
      expect(deepEquals(a, b), isFalse);
    });

    test('list vs map of same content is not equal', () {
      expect(deepEquals([1, 2, 3], {'0': 1, '1': 2, '2': 3}), isFalse);
    });
  });
}
