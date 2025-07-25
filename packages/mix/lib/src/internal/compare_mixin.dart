// ignore_for_file: avoid-dynamic

import 'package:flutter/widgets.dart';

import 'deep_collection_equality.dart';
import 'internal_extensions.dart';

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
  return object is EqualityMixin;
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
      buffer.write(value.toString());
    }
  }

  buffer.write(')');

  return buffer.toString();
}

/// A mixin that helps implement equality
/// without needing to explicitly override [operator ==] and [hashCode].
/// This mixin provides a standard implementation of equality and hash code based on the properties of the object.
mixin EqualityMixin {
  // The properties based on which equality and hash code are computed.
  List<Object?> get props;

  // Whether to use a detailed string representation of the object.
  bool get stringify => true;

  // Overrides the equality operator to compare based on the properties.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EqualityMixin &&
            runtimeType == other.runtimeType &&
            _equals(props, other.props);
  }

  // Overrides the hash code getter to compute the hash code based on the properties.
  @override
  int get hashCode {
    // Combine runtimeType hash with individual property hashes
    // This provides better distribution than hashAll for sparse lists
    var hash = runtimeType.hashCode;
    for (final prop in props) {
      hash = Object.hash(hash, prop);
    }

    return hash;
  }

  // Returns a list of properties that differ between this object and another.
  @visibleForTesting
  Map<String, String> getDiff(EqualityMixin other) {
    final diff = <String, String>{};

    // Return if there are no differences.
    if (this == other) return diff;

    final otherProps = other.props;
    final length = props.length;

    for (int i = 0; i < length; i++) {
      final unit1 = props[i];
      final unit2 = otherProps[i];

      final differences = compareObjects(unit1, unit2);
      if (differences.isNotEmpty) {
        final propName =
            unit1?.runtimeType.toString() ??
            unit2?.runtimeType.toString() ??
            'N/A';
        diff[propName] = differences.toString();
      }
    }

    return diff;
  }

  // Overrides the string representation of the object for debugging and logging.
  @override
  String toString() {
    return stringify ? mapPropsToString(runtimeType, props) : '$runtimeType';
  }
}

Map<String, String?> compareObjects(Object? obj1, Object? obj2) {
  final Map<String, String?> differences = {};

  if (obj1 == obj2) return differences;

  if (obj1 == null || obj2 == null) {
    differences[obj1.runtimeType.toString()] = obj2.runtimeType.toString();
  } else if (obj1 is EqualityMixin && obj2 is EqualityMixin) {
    final value = obj1.getDiff(obj2);
    if (value.isNotEmpty) {
      differences[obj1.runtimeType.toString()] = value.toString();
    }
  } else if (obj1 is Iterable && obj2 is Iterable) {
    if (!_equality.equals(obj1, obj2)) {
      // compare each item in the iterable and add it
      for (int i = 0; i < obj1.length; i++) {
        final value = compareObjects(
          obj1.elementAtOrNull(i),
          obj2.elementAtOrNull(i),
        );
        if (value.isNotEmpty) {
          differences.addAll(value);
        }
      }
    }
  } else if (obj1 is Map && obj2 is Map) {
    if (!_equality.equals(obj1, obj2)) {
      // compare each item in the map and add it
      for (final key in obj1.keys) {
        final value = compareObjects(obj1[key], obj2[key]);
        if (value.isNotEmpty) {
          differences.addAll(value);
        }
      }
    }
  } else if (obj1.runtimeType != obj2.runtimeType) {
    differences[obj1.runtimeType.toString()] = obj2.runtimeType.toString();
  } else if (obj1 != obj2) {
    differences[obj1.toString()] = obj2.toString();
  }

  return differences;
}
