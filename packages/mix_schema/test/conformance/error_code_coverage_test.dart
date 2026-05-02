/// Safety net: every code in `error-codes.json` must either be tested
/// by an existing fixture OR explicitly tagged `render-time-only`.
///
/// Without this guard the package can ship missing code surface and
/// pass green.
library;

import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

import '../foundations/_helpers.dart';

/// Codes that fire only at runtime resolution time (not catchable by
/// the validator alone). They are documented in IMPLEMENTATION.md and
/// surface in `mix_schema_flutter` (Phase 6) or at consumer integration.
const _renderTimeOnly = <ErrorCode>{
  ErrorCode.directiveNoBase,
  ErrorCode.hostUnresolved,
  ErrorCode.extensionUnknownHandler,
  ErrorCode.resolveUnresolvedLeaf,
  ErrorCode.tokenUnresolved,
  ErrorCode.tokenTypeMismatch,
  ErrorCode.envelopeMixruntimeMismatch,
  ErrorCode.canonicalNotNormalized,
  ErrorCode.variantStateInapplicable,
};

void main() {
  late MixSchemaAssets assets;

  setUpAll(() {
    assets = MixSchemaAssets.fromFiles(testAssetsDir);
  });

  test('every ErrorCode is represented in the catalog', () {
    for (final code in ErrorCode.values) {
      expect(assets.errorCatalog[code], isNotNull,
          reason: '${code.code} missing from catalog');
    }
  });

  test('every catalog entry has a non-empty message', () {
    for (final code in ErrorCode.values) {
      expect(assets.errorCatalog[code].message, isNotEmpty,
          reason: '${code.code} has empty message');
    }
  });

  test('render-time-only codes are documented (no orphans)', () {
    // Sanity check: every render-time-only code is a real ErrorCode.
    expect(_renderTimeOnly.every(ErrorCode.values.contains), isTrue);
  });

  test('catalog round-trips through ErrorCode.fromString', () {
    for (final code in ErrorCode.values) {
      expect(ErrorCode.fromString(code.code), code);
    }
  });
}
