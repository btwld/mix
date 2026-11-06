/// Provides a [DeepCollectionEquality] class that can be used to compare the
/// equality of complex data structures, such as maps, sets, and iterables,
/// by recursively comparing their elements.
///
/// The [equals] method compares two objects for deep equality, handling maps,
/// sets, and iterables.
///
/// This class is useful when you need to compare complex data structures for
/// equality or use them as keys in a hash-based data structure, such as a
/// [Map] or [Set].
class DeepCollectionEquality {
  /// Creates a new [DeepCollectionEquality] instance.
  const DeepCollectionEquality();

  /// Compares two maps for deep equality.
  /// The maps are equal if they have the same keys and values.
  /// The order of keys is not considered.
  bool _mapsEqual(Map map1, Map map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || !equals(map1[key], map2[key])) {
        return false;
      }
    }

    return true;
  }

  /// Compares two iterables for deep equality, considering element order.
  /// The iterables are equal if they have the same length and contain the same
  /// elements in the same order.
  bool _iterablesEqual(Iterable iter1, Iterable iter2) {
    final iterator1 = iter1.iterator;
    final iterator2 = iter2.iterator;

    while (iterator1.moveNext()) {
      if (!iterator2.moveNext() ||
          !equals(iterator1.current, iterator2.current)) {
        return false;
      }
    }

    return !iterator2.moveNext();
  }

  /// Compares two sets for deep equality.
  /// The order of elements in the sets is not considered.
  /// The sets are equal if they contain the same elements.
  bool _setsEqual(Set set1, Set set2) {
    if (set1.length != set2.length) return false;
    for (var value in set1) {
      if (!set2.contains(value)) {
        return false;
      }
    }

    return true;
  }

  /// Compares two objects for deep equality, handling maps, sets, and iterables.
  /// The objects are equal if they reference the same object, or if they have
  /// the same collection shape and equal elements.
  /// Maps match by key and value, sets match without regard to order, and
  /// other iterables match in order.
  /// Mismatched collection shapes are not equal. Other values use `==`.
  bool equals(Object? obj1, Object? obj2) {
    if (identical(obj1, obj2)) return true;
    if (obj1 == null || obj2 == null) return false;

    if (obj1 is Map || obj2 is Map) {
      if (obj1 is! Map || obj2 is! Map) return false;

      return _mapsEqual(obj1, obj2);
    }
    if (obj1 is Set || obj2 is Set) {
      if (obj1 is! Set || obj2 is! Set) return false;

      return _setsEqual(obj1, obj2);
    }
    if (obj1 is Iterable || obj2 is Iterable) {
      if (obj1 is! Iterable || obj2 is! Iterable) return false;

      return _iterablesEqual(obj1, obj2);
    }

    return obj1 == obj2;
  }

  /// Computes a hash code for an object, handling maps, sets, and iterables.
  /// The hash code is based on the object's runtime type and fields.
  /// The hash code is consistent with [equals].
  int hash(Object? obj) {
    if (obj is Map) {
      return Object.hashAllUnordered([
        for (final entry in obj.entries)
          Object.hash(hash(entry.key), hash(entry.value)),
      ]);
    } else if (obj is Set) {
      return Object.hashAllUnordered(obj);
    } else if (obj is Iterable) {
      return Object.hashAll([for (final element in obj) hash(element)]);
    }

    return obj.hashCode;
  }
}
