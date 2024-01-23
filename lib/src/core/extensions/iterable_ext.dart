import 'dart:math';

import '../attribute.dart';

// @nodoc
extension IterableExt<T> on Iterable<T> {
  T? get firstMaybeNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }

    return null;
  }

  Iterable<T> sorted([Comparator<T>? compare]) {
    List<T> newList = List.of(this);
    newList.sort(compare);

    return newList;
  }
}

extension ListExt<T> on List<T> {
  List<T> merge(List<T>? other) {
    if (other == null) return this;

    if (isEmpty) return other;

    final listLength = length;
    final otherLength = other.length;
    final maxLength = max(listLength, otherLength);

    return List<T>.generate(maxLength, (int index) {
      if (index < listLength && index < otherLength) {
        final currentValue = this[index];
        final otherValue = other[index];
        if (currentValue is Mergeable) {
          return currentValue.merge(otherValue);
        }

        return otherValue ?? currentValue;
      } else if (index < listLength) {
        return this[index];
      }

      return other[index];
    });
  }
}
