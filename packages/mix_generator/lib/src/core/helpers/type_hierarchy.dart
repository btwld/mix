/// Helpers for walking analyzer type hierarchies.
library;

import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Walks the superclass chain looking for a type matched by [checker].
///
/// Returns the matching [InterfaceType] with type arguments preserved after
/// substitution, or `null` when no matching supertype exists.
InterfaceType? findSupertypeMatching(
  InterfaceType? start,
  TypeChecker checker,
) {
  var current = start;
  while (current != null) {
    if (checker.isExactlyType(current)) {
      return current;
    }

    current = current.superclass;
  }

  return null;
}
