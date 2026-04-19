/// Shared error-reporting utilities for Mix generators.
///
/// All four generators (`mix_generator`, `styler_generator`,
/// `mixable_generator`, `widget_generator`) use the same helpers so error
/// shape stays consistent across the package.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

/// Throws an [InvalidGenerationSource] with [message] anchored to [element].
///
/// Use this in place of `throw InvalidGenerationSource(...)` at every call
/// site so error shape stays uniform. Pass [todo] when the user has a
/// concrete next step (e.g. `'Add the @MixableSpec annotation.'`).
Never fail(Element element, String message, {String todo = ''}) {
  throw InvalidGenerationSource(message, todo: todo, element: element);
}
