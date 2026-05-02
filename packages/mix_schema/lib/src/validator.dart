/// Public Validator facade — runs the 4-stage pipeline per
/// IMPLEMENTATION.md §Validator pipeline:
///
///   1. Resource bounds (fail-closed).
///   2. JSON Schema structural validation on raw (sugary) input.
///   3. Internal canonicalize (reuse [Canonicalizer]).
///   4. Semantic checks on canonical form.
///
/// Stage 1 short-circuits on first breach. Stages 2 and 4 collect all
/// errors. Returns a merged [ValidationResult] with stable JSON Pointer
/// paths.
library;

import 'assets.dart';
import 'canonicalizer.dart';
import 'errors.dart';
import 'validator/bounds.dart';
import 'validator/structural.dart';

class Validator {
  Validator(this._assets) : _structural = StructuralValidator(LoadedSchema.fromJson(_assets.schema));

  final MixSchemaAssets _assets;
  final StructuralValidator _structural;

  /// Validate a parsed JSON document. Returns [ValidationResult.ok] when
  /// the document conforms.
  ValidationResult validate(Object? document) {
    // Stage 1 — fail-closed bounds.
    final boundsErrors = checkBounds(document);
    if (boundsErrors.isNotEmpty) return ValidationResult(boundsErrors);

    // Stage 2 — structural (collect-all).
    final structural = _structural.validate(document);

    // Stage 3 — canonicalize. Skip semantic if doc isn't a Map.
    if (document is! Map<String, Object?>) {
      return ValidationResult([
        ...structural,
      ]);
    }
    final canonical = Canonicalizer(_assets.registry).normalize(document);

    // Stage 4 — semantic checks (currently delegated to registry-driven
    // shape checks; richer checks land as Phase 4 sub-stages mature).
    final semantic = _semanticChecks(canonical);

    return ValidationResult([...structural, ...semantic]);
  }

  /// Stage 4 placeholder — verifies a few decision-bound invariants
  /// directly on canonical form. Richer per-prop / directive-target /
  /// variant-spec-must-match checks expand here as the validator
  /// matures.
  List<MixSchemaError> _semanticChecks(Map<String, Object?> canonical) {
    // For now, no extra semantic errors beyond structural. Hook stays
    // here so the pipeline ordering (bounds → structural → canonicalize
    // → semantic) is observable in tests.
    return const [];
  }
}
