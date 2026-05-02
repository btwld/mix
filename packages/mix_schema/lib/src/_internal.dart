/// Package-private utilities shared by the validator, canonicalizer,
/// parser, and serializer.
///
/// Owns:
///   * resource bound constants (§Security Considerations)
///   * RFC 6901 JSON Pointer encode/decode
///   * canonical structural equality (§Structural equality)
///   * bound-checking helpers (depth, byte size, array length)
///
/// Pure Dart. MUST NOT import dart:io. (Asset loaders live in `assets.dart`.)
library;

import 'dart:convert' show utf8;

/// Resource caps from spec.md §Security Considerations.
///
/// These are normative limits the validator enforces fail-closed before any
/// deep traversal of an untrusted document.
class MixSchemaConstants {
  MixSchemaConstants._();

  /// Maximum document size in bytes (1 MiB).
  /// Error code: `envelope.document-too-large`.
  static const int maxDocumentBytes = 1048576;

  /// Maximum nesting depth (widget + style, combined).
  /// Error code: `canonical.depth-exceeded`.
  static const int maxDepth = 32;

  /// Maximum length for any array (`children`, `variants`, `modifiers`,
  /// `directives`, `textDirectives`, `x:` arrays).
  /// Error code: `canonical.array-too-long`.
  static const int maxArrayLength = 1024;

  /// Maximum directive chain length on a single leaf.
  /// Error code: `directive.chain-too-long`.
  static const int maxDirectiveChain = 16;

  /// Maximum token path length in characters.
  /// Error code: `token.path-too-long`.
  static const int maxTokenPathLength = 128;

  /// `x:` extension atom grammar — `[a-z][a-z0-9_-]*`.
  /// Error code: `extension.identifier-invalid`.
  static final RegExp extensionAtom = RegExp(r'^[a-z][a-z0-9_-]*$');
}

/// RFC 6901 JSON Pointer helpers.
///
/// JSON Pointer paths are how the validator and parser report the location
/// of an error (`/root/child/style/props/color`). Two characters need
/// escaping inside a token: `~` → `~0` and `/` → `~1`.
class JsonPointer {
  JsonPointer._();

  /// Empty pointer — refers to the document root.
  static const String root = '';

  /// Escape a single token per RFC 6901 §3.
  static String escape(String token) {
    if (!token.contains('~') && !token.contains('/')) return token;
    final buffer = StringBuffer();
    for (var i = 0; i < token.length; i++) {
      final c = token.codeUnitAt(i);
      if (c == 0x7e) {
        buffer.write('~0');
      } else if (c == 0x2f) {
        buffer.write('~1');
      } else {
        buffer.writeCharCode(c);
      }
    }
    return buffer.toString();
  }

  /// Unescape a single token per RFC 6901 §4.
  ///
  /// Per spec: `~1` first → `/`, then `~0` → `~`. Doing it in this order
  /// avoids treating user input `~01` as `/`.
  static String unescape(String token) {
    if (!token.contains('~')) return token;
    return token.replaceAll('~1', '/').replaceAll('~0', '~');
  }

  /// Append an object key to an existing pointer.
  static String appendKey(String pointer, String key) =>
      '$pointer/${escape(key)}';

  /// Append an array index to an existing pointer.
  static String appendIndex(String pointer, int index) => '$pointer/$index';

  /// Decode a pointer string into its tokens.
  ///
  /// Returns an empty list for the root pointer. Throws `FormatException`
  /// on a non-empty pointer that doesn't start with `/` (per RFC 6901 §3).
  static List<String> decode(String pointer) {
    if (pointer.isEmpty) return const [];
    if (!pointer.startsWith('/')) {
      throw FormatException(
        'JSON Pointer must start with "/" or be empty',
        pointer,
      );
    }
    return pointer.substring(1).split('/').map(unescape).toList();
  }
}

/// Canonical structural equality per spec.md §Structural equality.
///
/// Algorithm:
///   * `null` == `null`.
///   * Maps are equal iff key sets match and values match per-key (order
///     within a map is not significant — canonical form pins order for
///     serialization, not comparison).
///   * Lists are equal iff length matches and element-at-index values are
///     equal in order.
///   * `num` values compare numerically (so `16` and `16.0` are equal).
///   * `String` and `bool` compare via `==`.
///
/// Used by validator, canonicalizer (idempotency tests), parser, serializer
/// (round-trip invariants).
bool deepEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;

  if (a is num && b is num) return a == b;
  if (a is String && b is String) return a == b;
  if (a is bool && b is bool) return a == b;

  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!deepEquals(a[key], b[key])) return false;
    }
    return true;
  }

  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!deepEquals(a[i], b[i])) return false;
    }
    return true;
  }

  return false;
}

/// Bound checks against the resource caps in `MixSchemaConstants`.
///
/// All checks return the observed value when over the limit, or `null` when
/// safe. Validator stage 1 wires the over-limit values into structured
/// error reports.
class Bounds {
  Bounds._();

  /// Encoded byte length of a JSON-as-string. UTF-8 encoded.
  static int byteSize(String json) => utf8.encode(json).length;

  /// Maximum nesting depth of a parsed JSON value.
  ///
  /// Counts every nested Map / List as a level. A scalar or empty container
  /// is depth 1. Equivalent to the longest root-to-leaf path through the
  /// tree.
  static int maxDepthOf(Object? value) {
    if (value is Map) {
      var max = 0;
      for (final v in value.values) {
        final d = maxDepthOf(v);
        if (d > max) max = d;
      }
      return max + 1;
    }
    if (value is List) {
      var max = 0;
      for (final v in value) {
        final d = maxDepthOf(v);
        if (d > max) max = d;
      }
      return max + 1;
    }
    return 1;
  }

  /// Walks `value` and reports the first array whose length exceeds
  /// `maxArrayLength`, returning its JSON Pointer path and length.
  ///
  /// Returns `null` when no offending array is found.
  static ArrayOverflow? findArrayOverflow(Object? value, [String pointer = '']) {
    if (value is List) {
      if (value.length > MixSchemaConstants.maxArrayLength) {
        return ArrayOverflow(path: pointer, length: value.length);
      }
      for (var i = 0; i < value.length; i++) {
        final hit = findArrayOverflow(value[i], JsonPointer.appendIndex(pointer, i));
        if (hit != null) return hit;
      }
    } else if (value is Map) {
      for (final entry in value.entries) {
        final key = entry.key;
        if (key is! String) continue;
        final hit = findArrayOverflow(
          entry.value,
          JsonPointer.appendKey(pointer, key),
        );
        if (hit != null) return hit;
      }
    }
    return null;
  }
}

/// Result returned by `Bounds.findArrayOverflow` when an array exceeds
/// `MixSchemaConstants.maxArrayLength`.
class ArrayOverflow {
  const ArrayOverflow({required this.path, required this.length});

  /// JSON Pointer path to the offending array.
  final String path;

  /// Observed length of the array.
  final int length;
}
