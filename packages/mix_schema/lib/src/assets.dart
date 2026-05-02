/// Asset bundle for the Mix Schema reference implementation.
///
/// Holds the three normative JSON documents the validator needs:
///   * `schema.v1.json` — formal JSON Schema (Draft 2020-12).
///   * `registry.json` — per-prop typing.
///   * `error-codes.json` — 52 normative error codes.
///
/// Two factories:
///   * [MixSchemaAssets.embedded] — caller provides pre-parsed maps. The
///     pure-Dart core uses this exclusively; no `dart:io` involved.
///   * [MixSchemaAssets.fromFiles] — convenience CLI loader using
///     `dart:io File`. NOT usable on the web.
///
/// The pure core (`validator.dart`, `canonicalizer.dart`, `parser*.dart`,
/// `serializer*.dart`) MUST NOT call `MixSchemaAssets.fromFiles` directly;
/// they accept an [MixSchemaAssets] instance from the caller.
library;

import 'dart:convert' show json;
import 'dart:io' show File;

import 'errors.dart';
import 'registry.dart';

/// Three-document bundle the validator/canonicalizer/parser/serializer
/// share.
class MixSchemaAssets {
  MixSchemaAssets._({
    required this.schema,
    required this.registry,
    required this.errorCatalog,
  });

  /// Parsed `schema.v1.json` as a `Map<String, Object?>`. The validator
  /// walks this directly.
  final Map<String, Object?> schema;

  /// Typed view of `registry.json`.
  final Registry registry;

  /// Typed view of `error-codes.json`.
  final ErrorCatalog errorCatalog;

  /// Build from already-parsed JSON maps. Use this in embedded contexts
  /// (Flutter app, web, server) where the caller controls how the JSON is
  /// loaded.
  ///
  /// Throws `StateError` when the maps are inconsistent (e.g. the error
  /// catalog is missing codes).
  factory MixSchemaAssets.embedded({
    required Map<String, Object?> schema,
    required Map<String, Object?> registry,
    required Map<String, Object?> errorCodes,
  }) {
    return MixSchemaAssets._(
      schema: Map.unmodifiable(schema),
      registry: Registry.fromJson(registry),
      errorCatalog: ErrorCatalog.fromJson(errorCodes),
    );
  }

  /// Convenience CLI loader. Reads the three JSON files from [dirPath]:
  ///   * `$dirPath/schema.v1.json`
  ///   * `$dirPath/registry.json`
  ///   * `$dirPath/error-codes.json`
  ///
  /// Uses `dart:io File`. NOT available on the web — call
  /// [MixSchemaAssets.embedded] there instead.
  factory MixSchemaAssets.fromFiles(String dirPath) {
    Map<String, Object?> readJson(String name) {
      final path = '$dirPath/$name';
      final contents = File(path).readAsStringSync();
      final decoded = json.decode(contents);
      if (decoded is! Map<String, Object?>) {
        throw StateError('$path: expected a JSON object at the root');
      }
      return decoded;
    }

    return MixSchemaAssets.embedded(
      schema: readJson('schema.v1.json'),
      registry: readJson('registry.json'),
      errorCodes: readJson('error-codes.json'),
    );
  }
}
