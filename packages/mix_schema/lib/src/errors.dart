/// Mix Schema error catalog.
///
/// Mirrors `error-codes.json` (the language-neutral source of truth — spec
/// Decision #39). All errors emitted by the validator, canonicalizer,
/// parser, and serializer use these codes.
///
/// Adding a code is a MINOR schema bump; renaming or removing is MAJOR.
library;

import 'package:meta/meta.dart';

/// Severity bands as declared in `error-codes.json`.
enum Severity { error, warning, info }

/// Stable identifier for every code in `error-codes.json`.
///
/// The Dart enum names are `lowerCamelCase` rewrites of the kebab codes.
/// The wire-format string (e.g. `"envelope.document-too-large"`) is exposed
/// via [code] and is what gets serialized in error reports.
enum ErrorCode {
  // envelope
  envelopeDocumentTooLarge('envelope.document-too-large'),
  envelopeSchemaUnsupported('envelope.schema-unsupported'),
  envelopeMixruntimeMismatch('envelope.mixruntime-mismatch'),
  envelopeFieldMissing('envelope.field-missing'),
  envelopeFieldForbidden('envelope.field-forbidden'),

  // widget
  widgetUnknown('widget.unknown'),
  widgetFieldForbidden('widget.field-forbidden'),
  widgetFieldMissing('widget.field-missing'),
  widgetChildAndChildrenExclusive('widget.child-and-children-exclusive'),

  // style
  styleSpecMissing('style.spec-missing'),
  styleSpecForbiddenField('style.spec-forbidden-field'),
  styleSubstyleForbidsNesting('style.substyle-forbids-nesting'),

  // spec
  specUnknown('spec.unknown'),
  specPropUnknown('spec.prop-unknown'),

  // value
  valueShapeInvalid('value.shape-invalid'),
  valueValueTokenExclusive('value.value-token-exclusive'),
  valueTypeMismatch('value.type-mismatch'),
  valueEnumUnknown('value.enum-unknown'),
  valueNumberNotFinite('value.number-not-finite'),
  valueNullForbidden('value.null-forbidden'),

  // literal
  literalUnknown('literal.unknown'),
  literalSubfieldUnknown('literal.subfield-unknown'),
  literalSubfieldNotValue('literal.subfield-not-value'),

  // directive
  directiveUnknown('directive.unknown'),
  directiveTypeMismatch('directive.type-mismatch'),
  directiveOnLiteralRoot('directive.on-literal-root'),
  directiveDivideByZero('directive.divide-by-zero'),
  directiveClampInvalidRange('directive.clamp-invalid-range'),
  directiveNoBase('directive.no-base'),
  directiveChainTooLong('directive.chain-too-long'),

  // variant
  variantUnknownWhen('variant.unknown-when'),
  variantSpecMismatch('variant.spec-mismatch'),
  variantStateInapplicable('variant.state-inapplicable'),
  variantDirectionIgnored('variant.direction-ignored'),

  // modifier
  modifierUnknown('modifier.unknown'),
  modifierPropUnknown('modifier.prop-unknown'),

  // animation
  animationKindUnknown('animation.kind-unknown'),
  animationCurveRequired('animation.curve-required'),
  animationCurveForbidden('animation.curve-forbidden'),

  // token
  tokenFormInvalid('token.form-invalid'),
  tokenNamespaceUnknown('token.namespace-unknown'),
  tokenUnresolved('token.unresolved'),
  tokenTypeMismatch('token.type-mismatch'),
  tokenPathTooLong('token.path-too-long'),

  // extension
  extensionIdentifierInvalid('extension.identifier-invalid'),
  extensionUnknownHandler('extension.unknown-handler'),
  extensionNestedXForbidden('extension.nested-x-forbidden'),

  // canonical
  canonicalNotNormalized('canonical.not-normalized'),
  canonicalDepthExceeded('canonical.depth-exceeded'),
  canonicalArrayTooLong('canonical.array-too-long'),

  // host
  hostUnresolved('host.unresolved'),

  // resolve
  resolveUnresolvedLeaf('resolve.unresolved-leaf');

  const ErrorCode(this.code);

  /// The wire-format identifier (e.g. `envelope.document-too-large`).
  final String code;

  /// Category — the segment before the first `.` in [code].
  String get category => code.split('.').first;

  /// Look up an [ErrorCode] by its wire-format string. Returns `null` when
  /// unknown.
  static ErrorCode? fromString(String code) {
    for (final value in ErrorCode.values) {
      if (value.code == code) return value;
    }
    return null;
  }
}

/// Definition of an error code as declared in `error-codes.json`.
///
/// The validator/parser instantiate `MixSchemaError` from this metadata
/// when they detect a violation.
@immutable
class ErrorCodeDef {
  const ErrorCodeDef({
    required this.code,
    required this.message,
    required this.severity,
    this.hint,
  });

  /// The [ErrorCode] this definition applies to.
  final ErrorCode code;

  /// Message template with `$path`, `$found`, `$expected`, `$max`, etc.
  /// placeholders. Substitutions happen at error-construction time.
  final String message;

  /// Severity per the catalog.
  final Severity severity;

  /// Optional actionable hint.
  final String? hint;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorCodeDef &&
          other.code == code &&
          other.message == message &&
          other.severity == severity &&
          other.hint == hint;

  @override
  int get hashCode => Object.hash(code, message, severity, hint);
}

/// Catalog of error code definitions, parsed from `error-codes.json`.
class ErrorCatalog {
  ErrorCatalog._(this._byCode);

  final Map<ErrorCode, ErrorCodeDef> _byCode;

  /// Build a catalog from a parsed `error-codes.json` document.
  ///
  /// Validates that every [ErrorCode] declared in this enum has a matching
  /// entry in the document. Throws `StateError` if the catalog is missing
  /// codes or has unknown ones.
  factory ErrorCatalog.fromJson(Map<String, Object?> json) {
    final codes = json['codes'];
    if (codes is! Map) {
      throw StateError('error-codes.json: missing or invalid "codes" map');
    }

    final byCode = <ErrorCode, ErrorCodeDef>{};
    final unknown = <String>[];

    for (final entry in codes.entries) {
      final key = entry.key;
      if (key is! String) continue;
      final value = entry.value;
      if (value is! Map) {
        throw StateError('error-codes.json: code "$key" is not a map');
      }

      final ec = ErrorCode.fromString(key);
      if (ec == null) {
        unknown.add(key);
        continue;
      }

      final message = value['message'];
      if (message is! String) {
        throw StateError('error-codes.json: code "$key" missing message');
      }
      final severityName = value['severity'];
      if (severityName is! String) {
        throw StateError('error-codes.json: code "$key" missing severity');
      }
      final severity = Severity.values.firstWhere(
        (s) => s.name == severityName,
        orElse: () => throw StateError(
          'error-codes.json: unknown severity "$severityName" on "$key"',
        ),
      );
      final hint = value['hint'];

      byCode[ec] = ErrorCodeDef(
        code: ec,
        message: message,
        severity: severity,
        hint: hint is String ? hint : null,
      );
    }

    final missing = ErrorCode.values
        .where((c) => !byCode.containsKey(c))
        .map((c) => c.code)
        .toList();

    if (missing.isNotEmpty) {
      throw StateError(
        'error-codes.json missing entries for: ${missing.join(", ")}',
      );
    }
    if (unknown.isNotEmpty) {
      throw StateError(
        'error-codes.json contains entries unknown to ErrorCode: '
        '${unknown.join(", ")}',
      );
    }

    return ErrorCatalog._(Map.unmodifiable(byCode));
  }

  /// Look up the definition for a code.
  ErrorCodeDef operator [](ErrorCode code) => _byCode[code]!;

  /// All codes known to this catalog.
  Iterable<ErrorCode> get codes => _byCode.keys;
}

/// A single error reported by the validator / canonicalizer / parser /
/// serializer.
@immutable
class MixSchemaError {
  const MixSchemaError({
    required this.code,
    required this.message,
    required this.path,
    this.severity = Severity.error,
    this.hint,
  });

  /// Stable identifier for the violation.
  final ErrorCode code;

  /// Human-readable message with placeholders substituted.
  final String message;

  /// JSON Pointer (RFC 6901) path to the offending node. Empty string for
  /// root-level errors.
  final String path;

  /// Severity. Defaults to [Severity.error].
  final Severity severity;

  /// Optional hint.
  final String? hint;

  @override
  String toString() {
    final at = path.isEmpty ? '' : ' @ $path';
    final hintPart = hint == null ? '' : ' (hint: $hint)';
    return '[${code.code}]$at $message$hintPart';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixSchemaError &&
          other.code == code &&
          other.message == message &&
          other.path == path &&
          other.severity == severity &&
          other.hint == hint;

  @override
  int get hashCode =>
      Object.hash(code, message, path, severity, hint);
}

/// Result of a validation run.
///
/// `errors` is collect-all within a stage (per spec: validator runs in a
/// single strict mode but reports as many errors as it can per stage).
@immutable
class ValidationResult {
  const ValidationResult(this.errors);

  /// Empty (zero-error) result.
  static const ValidationResult ok = ValidationResult(<MixSchemaError>[]);

  /// Errors reported, in encounter order. Use [byCode] / [bySeverity] to
  /// slice.
  final List<MixSchemaError> errors;

  /// True iff no [Severity.error] entries are present. Warnings and infos
  /// do not invalidate the result.
  bool get isValid => errors.every((e) => e.severity != Severity.error);

  /// Errors with the given code.
  Iterable<MixSchemaError> byCode(ErrorCode code) =>
      errors.where((e) => e.code == code);

  /// Errors with the given severity.
  Iterable<MixSchemaError> bySeverity(Severity severity) =>
      errors.where((e) => e.severity == severity);
}
