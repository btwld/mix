/// `x:` extension identifier and helpers.
///
/// Extension keys are the only escape hatch for custom widgets/specs/
/// modifiers/when-expressions/tokens (spec.md §Extensions). They follow
/// the atom grammar `[a-z][a-z0-9_-]*` (Decision #40):
///   * Lowercase ASCII only.
///   * Starts with a letter.
///   * No spaces, no dots, no uppercase inside an atom.
///
/// `x:` payloads are **opaque to validators** — only the identifier is
/// checked. Round-trip preservation (audit row G) is enforced by the
/// canonicalizer, parser, and serializer.
library;

import 'package:meta/meta.dart';

import '../_internal.dart' show MixSchemaConstants;

/// A validated `x:` extension identifier.
///
/// Construct via [ExtensionId.parse] for input from JSON, or via the
/// `unsafe` constructor when the value is known-good (e.g. internal
/// constants).
@immutable
class ExtensionId {
  /// Construct without validation. Reserved for internal use where the
  /// value is statically known to be valid.
  const ExtensionId.unsafe(this.value);

  /// Parse a string into an [ExtensionId]. Returns `null` when the input
  /// fails the atom grammar.
  static ExtensionId? parse(String input) {
    if (!isValidIdentifier(input)) return null;
    return ExtensionId.unsafe(input);
  }

  /// True iff [input] starts with `x:` followed by a valid atom (per
  /// Decision #40).
  static bool isValidIdentifier(String input) {
    if (!input.startsWith('x:')) return false;
    final atom = input.substring(2);
    return MixSchemaConstants.extensionAtom.hasMatch(atom);
  }

  /// True iff [input] is a valid path of one or more atoms separated by
  /// dots, prefixed `x:`. Used for `x:` token paths
  /// (e.g. `x:brand.primary`).
  static bool isValidTokenPath(String input) {
    if (!input.startsWith('x:')) return false;
    final segments = input.substring(2).split('.');
    if (segments.isEmpty) return false;
    for (final segment in segments) {
      if (!MixSchemaConstants.extensionAtom.hasMatch(segment)) return false;
    }
    return true;
  }

  /// The full identifier including the `x:` prefix.
  final String value;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtensionId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
