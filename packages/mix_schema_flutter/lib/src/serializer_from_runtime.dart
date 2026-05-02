/// Inverse of `parser_to_runtime.dart`: Mix runtime objects →
/// `mix_schema` typed model.
///
/// Round-trip invariant 3 (per IMPLEMENTATION.md §Round-trip
/// invariants): `parse(serialize(obj))` renders identically to `obj`.
/// Realized only when the runtime preserves token identity (Mix's
/// `Prop<T>` retains token info — preserve it, do not eagerly resolve).
///
/// Foundational shape; full per-prop inverse lands as the bridge
/// matures.
library;

import 'package:flutter/widgets.dart';
import 'package:mix_schema/mix_schema.dart';

class RuntimeSerializer {
  const RuntimeSerializer();

  /// Convert a Flutter [Widget] tree built from Mix back into a
  /// `mix_schema` typed model. Currently a placeholder for non-trivial
  /// trees — direct construction returns a minimal envelope.
  WidgetNode fromWidget(Widget widget) {
    throw UnimplementedError(
      'Runtime serializer is a placeholder. Phase 6 establishes the API '
      'shape; per-prop inverse conversion lands incrementally. Use the '
      'pure Serializer in mix_schema for typed model → JSON.',
    );
  }
}
