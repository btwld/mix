// ignore_for_file: avoid-mutating-parameters

import '../core/extensions/iterable_ext.dart';
import 'deep_collection_equality.dart';

/// Returns a `hashCode` for [props].
/// This function uses the Jenkins hash function to generate a hash code for the given properties.
int _mapPropsToHashCode(Iterable? props) =>
    _finish([...?props].fold(0, _combine));

// Instance of DeepCollectionEquality used for deep comparison of collections.
const _equality = DeepCollectionEquality();

/// Determines whether [list1] and [list2] are equal.
/// This function checks if two lists are identical or equal in terms of their elements and their order.
bool _equals(List? list1, List? list2) {
  // If the lists are identical (same instance), they are equal.
  if (identical(list1, list2)) return true;
  // If either list is null, they are not equal.
  if (list1 == null || list2 == null) return false;
  // If the lengths of the lists are not equal, they are not equal.
  final length = list1.length;
  if (length != list2.length) return false;

  // Compare each pair of elements in the lists.
  for (int i = 0; i < length; i++) {
    final unit1 = list1[i];
    final unit2 = list2[i];

    // If both elements are Comparable and not equal, the lists are not equal.
    if (_isEquatable(unit1) && _isEquatable(unit2)) {
      if (unit1 != unit2) return false;
    }
    // If the element is a collection, use deep equality to compare.
    else if (unit1 is Iterable || unit1 is Map) {
      if (!_equality.equals(unit1, unit2)) return false;
    }
    // If the runtime types of the elements are not equal, the lists are not equal.
    else if (unit1?.runtimeType != unit2?.runtimeType) {
      return false;
    }
    // If the elements are not equal, the lists are not equal.
    else if (unit1 != unit2) {
      return false;
    }
  }

  // If all elements are equal, the lists are equal.
  return true;
}

// Checks if the given object is Comparable.
bool _isEquatable(dynamic object) {
  return object is Comparable;
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
/// This function implements the Jenkins hash function to generate a hash code for the given object.
int _combine(int hash, dynamic object) {
  // If the object is a Map, sort the keys and combine their hash codes.
  if (object is Map) {
    object.keys
        .sorted((dynamic a, dynamic b) => a.hashCode - b.hashCode)
        .forEach((key) {
      hash = hash ^ _combine(hash, [key, object[key]]);
    });

    return hash;
  }
  // If the object is a Set, sort the elements and combine their hash codes.
  if (object is Set) {
    object = object.sorted(((dynamic a, dynamic b) => a.hashCode - b.hashCode));
  }
  // If the object is an Iterable, combine the hash codes of all elements.
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }

    return hash ^ object.length;
  }

  // Combine the current hash code with the hash code of the object.
  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((hash & 0x0007ffff) << 10));

  return hash ^ (hash >> 6);
}

// Finalizes the hash code computation by performing additional bitwise operations.
int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((hash & 0x03ffffff) << 3));
  hash = hash ^ (hash >> 11);

  return 0x1fffffff & (hash + ((hash & 0x00003fff) << 15));
}

/// Returns a string representation of [props] with property names and values.
/// Only includes properties that are not null.
/// This function is used for debugging and logging purposes.
String mapPropsToString(Type runtimeType, List<Object?> props) {
  final buffer = StringBuffer()..write('$runtimeType(');

  for (var value in props) {
    if (value != null) {
      if (buffer.length > runtimeType.toString().length + 1) {
        buffer.write(', ');
      }
      buffer.write(value);
    }
  }

  buffer.write(')');

  return buffer.toString();
}

/// A mixin that helps implement equality
/// without needing to explicitly override [operator ==] and [hashCode].
/// This mixin provides a standard implementation of equality and hash code based on the properties of the object.
mixin Comparable {
  // The properties based on which equality and hash code are computed.
  List<Object?> get props;

  // Whether to use a detailed string representation of the object.
  bool get stringify => true;

  // Overrides the equality operator to compare based on the properties.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Comparable &&
            runtimeType == other.runtimeType &&
            _equals(props, other.props);
  }

  // Overrides the hash code getter to compute the hash code based on the properties.
  @override
  int get hashCode => runtimeType.hashCode ^ _mapPropsToHashCode(props);

  // Returns a list of properties that differ between this object and another.
  List<String> getDiff(Object other) {
    final diff = <String>[];

    // Return if there are no differences.
    if (this == other) return diff;

    if (other is Comparable) {
      final otherProps = other.props;
      final length = props.length;

      for (int i = 0; i < length; i++) {
        final unit1 = props[i];
        final unit2 = otherProps[i];

        if (unit1 is Iterable || unit1 is Map) {
          if (!_equality.equals(unit1, unit2)) {
            diff.add(props[i].toString());
          }
        } else if (unit1?.runtimeType != unit2?.runtimeType) {
          diff.add(props[i].toString());
        } else if (unit1 != unit2) {
          diff.add(props[i].toString());
        }
      }
    } else {
      diff.add('other is not EquatableMixin');
    }

    return diff;
  }

  // Overrides the string representation of the object for debugging and logging.
  @override
  String toString() {
    return stringify ? mapPropsToString(runtimeType, props) : '$runtimeType';
  }
}
