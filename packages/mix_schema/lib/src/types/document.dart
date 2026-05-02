/// `MixJsonDocument` envelope and `TokenBundle`.
///
/// The envelope is the top-level shape of every Mix JSON document
/// (spec.md §Envelope):
///
/// ```jsonc
/// {
///   "$schema":    "https://mix.dev/schema/v1.json",
///   "schema":     "1.0.0",
///   "mixRuntime": "^2.0.0",      // advisory
///   "tokens":     { ... },        // optional inline bundle
///   "root":       <WidgetNode>
/// }
/// ```
library;

import 'package:meta/meta.dart';

import 'nodes.dart';
import 'values.dart';

/// Root document.
@immutable
class MixJsonDocument {
  const MixJsonDocument({
    this.schemaUri,
    required this.schema,
    this.mixRuntime,
    this.tokens,
    required this.root,
  });

  factory MixJsonDocument.fromJson(Map<String, Object?> json) {
    final schemaField = json['schema'];
    if (schemaField is! String) {
      throw FormatException('Envelope requires "schema"');
    }
    final rootRaw = json['root'];
    if (rootRaw is! Map<String, Object?>) {
      throw FormatException('Envelope requires "root" widget');
    }
    return MixJsonDocument(
      schemaUri: json[r'$schema'] is String ? json[r'$schema']! as String : null,
      schema: schemaField,
      mixRuntime:
          json['mixRuntime'] is String ? json['mixRuntime']! as String : null,
      tokens: json['tokens'] is Map<String, Object?>
          ? TokenBundle.fromJson(json['tokens']! as Map<String, Object?>)
          : null,
      root: WidgetNode.fromJson(rootRaw),
    );
  }

  /// `$schema` field — points at the formal JSON Schema document.
  /// Optional; advisory.
  final String? schemaUri;

  /// `schema` semver — the spec version the document targets.
  final String schema;

  /// `mixRuntime` semver range — advisory.
  final String? mixRuntime;

  /// Optional inline token bundle.
  final TokenBundle? tokens;

  /// Required root widget.
  final WidgetNode root;

  Map<String, Object?> toJson() {
    final out = <String, Object?>{
      if (schemaUri != null) r'$schema': schemaUri,
      'schema': schema,
      if (mixRuntime != null) 'mixRuntime': mixRuntime,
      if (tokens != null && tokens!.entries.isNotEmpty)
        'tokens': tokens!.toJson(),
      'root': root.toJson(),
    };
    return out;
  }

  @override
  bool operator ==(Object other) =>
      other is MixJsonDocument &&
      other.schemaUri == schemaUri &&
      other.schema == schema &&
      other.mixRuntime == mixRuntime &&
      other.tokens == tokens &&
      other.root == root;

  @override
  int get hashCode =>
      Object.hash(MixJsonDocument, schemaUri, schema, mixRuntime, tokens, root);
}

/// Inline token bundle: flat-keyed map from `namespace.name` token paths
/// to canonical [PropertyValue]s.
@immutable
class TokenBundle {
  const TokenBundle(this.entries);

  factory TokenBundle.fromJson(Map<String, Object?> json) {
    final out = <String, PropertyValue>{};
    for (final entry in json.entries) {
      final pv = PropertyValue.fromJson(entry.value);
      if (pv == null) {
        throw FormatException('TokenBundle["${entry.key}"]: invalid Value');
      }
      out[entry.key] = pv;
    }
    return TokenBundle(Map.unmodifiable(out));
  }

  final Map<String, PropertyValue> entries;

  Map<String, Object?> toJson() => {
        for (final e in entries.entries) e.key: e.value.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (other is! TokenBundle) return false;
    if (other.entries.length != entries.length) return false;
    for (final entry in entries.entries) {
      if (!other.entries.containsKey(entry.key)) return false;
      if (other.entries[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final sorted = entries.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return Object.hashAll([for (final e in sorted) ...[e.key, e.value]]);
  }
}
