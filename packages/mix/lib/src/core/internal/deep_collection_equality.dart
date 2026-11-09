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

  /// Keeps plain values on their own [Object.hashCode]. Collections are
  /// wrapped so [Object.hashAllUnordered] sees [hash] instead of identity.
  Object? _valueHashIdentity(Object? value) {
    if (value is Map || value is Iterable) {
      return _HashedValue(hash(value));
    }

    return value;
  }

  /// Compares two objects for deep equality, handling maps, sets, and iterables.
  ///
  /// The same collection shape is required. Maps compare keys and values,
  /// sets ignore order, and other iterables keep order. Other values use `==`.
  bool equals(Object? obj1, Object? obj2) {
    if (identical(obj1, obj2)) return true;
    if (obj1 == null || obj2 == null) return false;

    if (obj1 is Map) {
      return obj2 is Map && _mapsEqual(obj1, obj2);
    } else if (obj2 is Map) {
      return false;
    } else if (obj1 is Set) {
      return obj2 is Set && _setsEqual(obj1, obj2);
    } else if (obj2 is Set) {
      return false;
    } else if (obj1 is Iterable) {
      return obj2 is Iterable && _iterablesEqual(obj1, obj2);
    } else if (obj2 is Iterable) {
      return false;
    }

    return obj1 == obj2;
  }

  /// Computes a hash code for an object, handling maps, sets, and iterables.
  /// The hash code is based on the object's runtime type and fields.
  /// The hash code is consistent with [equals].
  int hash(Object? obj) {
    if (obj is Map) {
      return Object.hashAllUnordered(obj.keys) ^
          Object.hashAllUnordered(obj.values.map(_valueHashIdentity));
    } else if (obj is Set) {
      return Object.hashAllUnordered(obj);
    } else if (obj is Iterable) {
      int hashCode = 0;
      for (var value in obj) {
        hashCode ^= hash(value);
      }

      return hashCode;
    }

    return obj.hashCode;
  }
}

/// Carries a precomputed hash into [Object.hashAllUnordered].
///
/// Map values that are collections would otherwise contribute their identity
/// hash, so two deeply equal maps could compare equal and still hash apart.
class _HashedValue {
  final int _code;

  const _HashedValue(this._code);

  @override
  bool operator ==(Object other) =>
      other is _HashedValue && other._code == _code;

  @override
  int get hashCode => _code;
}
