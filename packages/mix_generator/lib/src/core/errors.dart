/// Shared error-reporting utilities for Mix generators.
///
/// The Mix generators use the same helpers so error shape stays consistent
/// across the package.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

/// Reads a generated-method bitmask from an annotation, falling back to
/// [fallback] when the annotation leaves it unset.
int peekMethodsBitmask(ConstantReader reader, int fallback) {
  return reader.peek('methods')?.intValue ?? fallback;
}

/// Throws an [InvalidGenerationSource] with [message] anchored to [element].
///
/// Use this in place of `throw InvalidGenerationSource(...)` at every call
/// site so error shape stays uniform. Pass [todo] when the user has a
/// concrete next step (e.g. `'Add the @MixableSpec annotation.'`).
Never fail(Element element, String message, {String todo = ''}) {
  throw InvalidGenerationSource(message, todo: todo, element: element);
}

/// Casts [element] to [ClassElement] or fails with a uniform message.
///
/// Use this in place of `if (element is! ClassElement) fail(...)` so every
/// class-targeted generator emits the same "can only be applied to classes"
/// error shape.
ClassElement requireClassElement(Element element, String annotationName) {
  if (element is ClassElement) return element;
  fail(element, '$annotationName can only be applied to classes.');
}

/// Returns [element.name] or fails with [orFailWith].
///
/// `Element.name` is nullable in analyzer 10.x, but classes, top-level
/// variables, and top-level functions reachable via `@<Annotation>` always
/// carry a name in valid Dart source — a null name means the analyzer
/// resolved a synthetic or otherwise malformed element. Each generator
/// supplies its own failure message so existing validation-test wording
/// stays stable across the refactor.
String requireName(Element element, {required String orFailWith}) {
  final name = element.name;
  if (name == null) {
    fail(element, orFailWith);
  }

  return name;
}
