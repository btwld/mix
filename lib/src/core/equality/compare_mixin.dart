import '../../helpers/extensions/iterable_ext.dart';
import 'deep_collection_equality.dart';

/// Returns a `hashCode` for [props].
int _mapPropsToHashCode(Iterable? props) =>
    _finish([...?props].fold(0, _combine));

const _equality = DeepCollectionEquality();

/// Determines whether [list1] and [list2] are equal.
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
    } else if (unit1?.runtimeType != unit2?.runtimeType) {
      return false;
    } else if (unit1 != unit2) {
      return false;
    }
  }

  return true;
}

bool _isEquatable(dynamic object) {
  return object is Comparable;
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
int _combine(int hash, dynamic object) {
  if (object is Map) {
    object.keys
        .sorted((dynamic a, dynamic b) => a.hashCode - b.hashCode)
        .forEach((key) {
      hash = hash ^ _combine(hash, [key, object[key]]);
    });

    return hash;
  }
  if (object is Set) {
    object = object.sorted(((dynamic a, dynamic b) => a.hashCode - b.hashCode));
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }

    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((hash & 0x0007ffff) << 10));

  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((hash & 0x03ffffff) << 3));
  hash = hash ^ (hash >> 11);

  return 0x1fffffff & (hash + ((hash & 0x00003fff) << 15));
}

/// Returns a string representation of [props] with property names and values.
/// Only includes properties that are not null.
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

mixin Comparable {
  List<Object?> get props;

  bool get stringify => true;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Comparable &&
            runtimeType == other.runtimeType &&
            _equals(props, other.props);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ _mapPropsToHashCode(props);

  List<String> getDiff(Object other) {
    final diff = <String>[];

    // Return if there are no diferences.
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

  @override
  String toString() {
    return stringify ? mapPropsToString(runtimeType, props) : '$runtimeType';
  }
}
