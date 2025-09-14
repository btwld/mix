import 'package:flutter/widgets.dart';

import 'deep_collection_equality.dart';
import 'internal_extensions.dart';

/// Instance of DeepCollectionEquality used for deep comparison of collections.
const _equality = DeepCollectionEquality();

/// Determines whether [list1] and [list2] are equal using deep comparison.
bool _equals(List? list1, List? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  final length = list1.length;
  if (length != list2.length) return false;

  for (int i = 0; i < length; i++) {
    final unit1 = list1[i];
    final unit2 = list2[i];

    if (_isEquatable(unit1) && _isEquatable(unit2)) {
      if (unit1 != unit2) return false;
    } else if (unit1 is Iterable || unit1 is Map) {
      if (!_equality.equals(unit1, unit2)) return false;
    } else if (unit1 != unit2) {
      return false;
    }
  }

  return true;
}

/// Checks if the given object implements [Equatable].
bool _isEquatable(dynamic object) {
  return object is Equatable;
}

/// Returns a string representation of [props] for debugging purposes.
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

/// Mixin that provides standard equality and hash code implementation based on properties.
///
/// Automatically implements [operator ==] and [hashCode] based on the [props] list,
/// eliminating the need for manual implementation in most cases.
mixin Equatable {
  /// The properties based on which equality and hash code are computed.
  List<Object?> get props;

  /// Whether to use a detailed string representation of the object.
  bool get stringify => true;

  /// Overrides the equality operator to compare based on the properties.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            _equals(props, other.props);
  }

  /// Overrides the hash code getter to compute hash code based on properties.
  @override
  int get hashCode {
    // Combine runtimeType hash with deep hashes of props for consistency with deep equality
    var hash = runtimeType.hashCode;
    for (final prop in props) {
      hash = Object.hash(hash, _equality.hash(prop));
    }

    return hash;
  }

  /// Returns a map of properties that differ between this object and another.
  @visibleForTesting
  Map<String, String> getDiff(Equatable other) {
    final diff = <String, String>{};

    // Return empty map if no differences
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

  /// Overrides string representation for debugging and logging.
  @override
  String toString() {
    return stringify ? mapPropsToString(runtimeType, props) : '$runtimeType';
  }
}

/// Compares two objects and returns a map of differences.
///
/// Returns an empty map if the objects are equal, otherwise returns
/// a map describing the differences between the objects.
Map<String, String?> compareObjects(Object? obj1, Object? obj2) {
  final Map<String, String?> differences = {};

  if (obj1 == obj2) return differences;

  if (obj1 == null || obj2 == null) {
    differences[obj1.runtimeType.toString()] = obj2.runtimeType.toString();
  } else if (obj1 is Equatable && obj2 is Equatable) {
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
