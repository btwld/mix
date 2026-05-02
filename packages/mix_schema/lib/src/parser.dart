/// Public Parser facade.
///
/// Layered:
///   * [Parser.parseCanonical] — canonical Map → typed [MixJsonDocument].
///     No validation, no canonicalization.
///   * [Parser.parseValidating] — runs the full pipeline (Validator →
///     Canonicalizer → parseCanonical) in one call.
///
/// Stage 5 in the build order; pure-Dart layer only. The Mix-runtime
/// conversion (typed model → BoxStyler/TextStyler/...) lives in the
/// `mix_schema_flutter` package.
library;

import 'dart:convert' show json;

import 'assets.dart';
import 'canonicalizer.dart';
import 'errors.dart';
import 'types/document.dart';
import 'validator.dart';

class Parser {
  Parser(this._assets);

  final MixSchemaAssets _assets;

  /// Parse a canonical JSON string. Throws `FormatException` if the
  /// payload isn't a JSON object at the root or fails type construction.
  MixJsonDocument parse(String jsonText) {
    final decoded = json.decode(jsonText);
    if (decoded is! Map<String, Object?>) {
      throw FormatException('Document root must be a JSON object', jsonText);
    }
    return parseCanonical(decoded);
  }

  /// Parse an already-decoded canonical JSON map.
  MixJsonDocument parseCanonical(Map<String, Object?> canonical) =>
      MixJsonDocument.fromJson(canonical);

  /// Run the full pipeline: bounds + structural + canonicalize + parse.
  /// Returns a [ParseResult] carrying both the validation outcome and,
  /// when valid, the typed document.
  ParseResult parseValidating(Object? document) {
    final validator = Validator(_assets);
    final result = validator.validate(document);
    if (!result.isValid || document is! Map<String, Object?>) {
      return ParseResult(validation: result, document: null);
    }
    final canonical = Canonicalizer(_assets.registry).normalize(document);
    return ParseResult(
      validation: result,
      document: parseCanonical(canonical),
    );
  }
}

/// Outcome of [Parser.parseValidating].
class ParseResult {
  const ParseResult({required this.validation, required this.document});

  final ValidationResult validation;
  final MixJsonDocument? document;

  bool get isValid => validation.isValid && document != null;
}
