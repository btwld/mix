import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

import '_helpers.dart';

void main() {
  late MixSchemaAssets assets;

  setUpAll(() {
    assets = MixSchemaAssets.fromFiles(testAssetsDir);
  });

  test('catalog contains all 52 codes from error-codes.json', () {
    expect(assets.errorCatalog.codes.toSet(), ErrorCode.values.toSet());
    expect(ErrorCode.values, hasLength(52));
  });

  test('every catalog entry has a non-empty message', () {
    for (final code in ErrorCode.values) {
      final def = assets.errorCatalog[code];
      expect(
        def.message,
        isNotEmpty,
        reason: 'code ${code.code} has empty message',
      );
    }
  });

  test('ErrorCode.fromString round-trips for every code', () {
    for (final code in ErrorCode.values) {
      expect(ErrorCode.fromString(code.code), code);
    }
    expect(ErrorCode.fromString('not.a.real.code'), isNull);
  });

  test('category derived from code prefix', () {
    expect(ErrorCode.envelopeDocumentTooLarge.category, 'envelope');
    expect(ErrorCode.directiveNoBase.category, 'directive');
    expect(ErrorCode.canonicalDepthExceeded.category, 'canonical');
  });

  test('all 15 declared categories are represented', () {
    const declared = <String>{
      'envelope',
      'widget',
      'style',
      'spec',
      'value',
      'literal',
      'directive',
      'variant',
      'modifier',
      'animation',
      'token',
      'extension',
      'host',
      'canonical',
      'resolve',
    };
    final present = ErrorCode.values.map((e) => e.category).toSet();
    expect(present, equals(declared));
  });

  test('MixSchemaError equality and toString', () {
    const a = MixSchemaError(
      code: ErrorCode.valueNullForbidden,
      message: 'msg',
      path: '/root/x',
    );
    const b = MixSchemaError(
      code: ErrorCode.valueNullForbidden,
      message: 'msg',
      path: '/root/x',
    );
    expect(a, equals(b));
    expect(a.toString(), contains('value.null-forbidden'));
    expect(a.toString(), contains('/root/x'));
  });

  test('ValidationResult.ok is empty and valid', () {
    expect(ValidationResult.ok.errors, isEmpty);
    expect(ValidationResult.ok.isValid, isTrue);
  });

  test('ValidationResult.isValid false when an error is present', () {
    const result = ValidationResult([
      MixSchemaError(
        code: ErrorCode.valueNullForbidden,
        message: 'm',
        path: '',
      ),
    ]);
    expect(result.isValid, isFalse);
  });

  test('ValidationResult.isValid stays true when only warnings/infos', () {
    const result = ValidationResult([
      MixSchemaError(
        code: ErrorCode.variantStateInapplicable,
        message: 'm',
        path: '',
        severity: Severity.info,
      ),
    ]);
    expect(result.isValid, isTrue);
  });
}
