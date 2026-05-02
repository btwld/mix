/// Public Serializer facade.
///
/// Round-trip invariant 1 (Decision #17, IMPLEMENTATION.md):
/// `serialize(parse(x)) ≡ x` for any canonical `x` under canonical
/// structural equality.
///
/// Stage 5 in the build order; pure-Dart layer only.
library;

import 'dart:convert' show JsonEncoder, json;

import 'types/document.dart';

class Serializer {
  const Serializer();

  /// Serialize to canonical JSON text. Uses pretty-print (2-space
  /// indent) by default; pass [pretty]: false for a single-line form.
  String toJson(MixJsonDocument doc, {bool pretty = true}) {
    final map = toMap(doc);
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(map);
    }
    return json.encode(map);
  }

  /// Serialize to a canonical `Map<String, Object?>`.
  Map<String, Object?> toMap(MixJsonDocument doc) => doc.toJson();
}
