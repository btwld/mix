/// Stage 1 of the validator pipeline — resource bounds.
///
/// Fail-closed per spec §Security Considerations. Short-circuits on the
/// first breach to prevent DoS via deeply nested or oversized documents.
library;

import 'dart:convert' show json;

import '../_internal.dart' show Bounds, MixSchemaConstants, JsonPointer;
import '../errors.dart';

/// Run stage 1 against raw input. Returns a list of errors; empty when
/// all bounds are within limits.
List<MixSchemaError> checkBounds(Object? document) {
  final errors = <MixSchemaError>[];

  // Document size — encode and measure.
  final encoded = json.encode(document);
  final byteSize = Bounds.byteSize(encoded);
  if (byteSize > MixSchemaConstants.maxDocumentBytes) {
    errors.add(MixSchemaError(
      code: ErrorCode.envelopeDocumentTooLarge,
      message: 'Document is $byteSize bytes; maximum is '
          '${MixSchemaConstants.maxDocumentBytes}.',
      path: JsonPointer.root,
    ));
    return errors; // Fail-closed.
  }

  // Tree depth.
  final depth = Bounds.maxDepthOf(document);
  if (depth > MixSchemaConstants.maxDepth) {
    errors.add(MixSchemaError(
      code: ErrorCode.canonicalDepthExceeded,
      message:
          'Tree nesting depth $depth exceeds maximum of ${MixSchemaConstants.maxDepth}.',
      path: JsonPointer.root,
    ));
    return errors;
  }

  // Array length.
  final overflow = Bounds.findArrayOverflow(document);
  if (overflow != null) {
    errors.add(MixSchemaError(
      code: ErrorCode.canonicalArrayTooLong,
      message: 'Array has ${overflow.length} elements; maximum is '
          '${MixSchemaConstants.maxArrayLength}.',
      path: overflow.path,
    ));
    return errors;
  }

  // Directive chain length and token path length are nested checks —
  // walk the document looking for directives arrays and token strings.
  _walkChainsAndTokens(document, JsonPointer.root, errors);

  return errors;
}

void _walkChainsAndTokens(Object? value, String pointer, List<MixSchemaError> out) {
  if (value is Map<String, Object?>) {
    for (final entry in value.entries) {
      final key = entry.key;
      final child = entry.value;
      final childPath = JsonPointer.appendKey(pointer, key);

      if (key == 'directives' && child is List) {
        if (child.length > MixSchemaConstants.maxDirectiveChain) {
          out.add(MixSchemaError(
            code: ErrorCode.directiveChainTooLong,
            message:
                'Directive chain has ${child.length} entries; maximum is '
                '${MixSchemaConstants.maxDirectiveChain}.',
            path: childPath,
          ));
          return;
        }
      }

      if (key == 'token' && child is String) {
        if (child.length > MixSchemaConstants.maxTokenPathLength) {
          out.add(MixSchemaError(
            code: ErrorCode.tokenPathTooLong,
            message: 'Token path "$child" exceeds '
                '${MixSchemaConstants.maxTokenPathLength} characters.',
            path: childPath,
          ));
          return;
        }
      }

      _walkChainsAndTokens(child, childPath, out);
      if (out.isNotEmpty) return;
    }
  } else if (value is List) {
    for (var i = 0; i < value.length; i++) {
      _walkChainsAndTokens(value[i], JsonPointer.appendIndex(pointer, i), out);
      if (out.isNotEmpty) return;
    }
  }
}
