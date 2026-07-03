import 'package:ack/ack.dart' as ack;
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';

void main() {
  MixSchemaErrorCode codeFor(ack.SchemaError error) {
    return mapSchemaError(error).single.code;
  }

  test('maps type_mismatch', () {
    final result = ack.Ack.object({
      'value': ack.Ack.string(),
    }).safeParse('nope');

    expect(codeFor(result.getError()), MixSchemaErrorCode.typeMismatch);
  });

  test('reaches unsupported_version through contract preflight', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().decode<Object>(
      {'v': 2, 'type': 'box'},
    );

    final errors = switch (result) {
      MixSchemaDecodeFailure<Object>(:final errors) => errors,
      MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.unsupportedVersion);
  });

  test('reaches null_forbidden through contract preflight', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().decode<Object>(
      {'v': 1, 'type': 'box', 'padding': null},
    );

    final errors = switch (result) {
      MixSchemaDecodeFailure<Object>(:final errors) => errors,
      MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.nullForbidden);
  });

  test('reaches limit_exceeded through contract preflight', () {
    var style = <String, Object?>{'type': 'box'};
    for (var i = 0; i < 70; i += 1) {
      style = <String, Object?>{
        'type': 'box',
        'variants': [
          {'kind': 'named', 'name': 'v$i', 'style': style},
        ],
      };
    }

    final result = MixSchemaContractBuilder().builtIn().freeze().decode<Object>(
      {'v': 1, ...style},
    );

    final errors = switch (result) {
      MixSchemaDecodeFailure<Object>(:final errors) => errors,
      MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.limitExceeded);
  });

  test('carries warning severity separately from errors', () {
    final result = MixSchemaContractBuilder().builtIn().freeze().decode<Object>(
      {'type': 'box'},
    );

    final warnings = switch (result) {
      MixSchemaDecodeSuccess<Object>(:final warnings) => warnings,
      MixSchemaDecodeFailure<Object>(:final errors) => fail('$errors'),
    };

    expect(warnings.single.code, MixSchemaErrorCode.requiredField);
    expect(warnings.single.severity, MixSchemaDiagnosticSeverity.warning);
  });

  test('maps required_field', () {
    final result = ack.Ack.object({'value': ack.Ack.string()}).safeParse({});

    expect(codeFor(result.getError()), MixSchemaErrorCode.requiredField);
  });

  test('maps unknown_field', () {
    final result = ack.Ack.object({
      'value': ack.Ack.string(),
    }).safeParse({'value': 'x', 'extra': true});

    expect(codeFor(result.getError()), MixSchemaErrorCode.unknownField);
  });

  test('unwraps transform-wrapped schema errors with outer path', () {
    final inner = ack.Ack.object({'known': ack.Ack.string()});
    final schema = ack.Ack.object({
      'outer': ack.Ack.codec<Object, Object, JsonMap>(
        input: ack.Ack.any(),
        decode: (wire) {
          final result = inner.safeParse(wire);
          if (result.isFail) throw result.getError();

          return result.getOrThrow()!;
        },
        encode: (value) => value,
      ),
    });

    final result = schema.safeParse({
      'outer': {'known': 'x', 'future': true},
    });
    final errors = mapSchemaError(result.getError());

    expect(errors.single.code, MixSchemaErrorCode.unknownField);
    expect(errors.single.path, '/outer/future');
  });

  test('maps invalid_enum', () {
    final result = ack.Ack.enumString(['a']).safeParse('b');

    expect(codeFor(result.getError()), MixSchemaErrorCode.invalidEnum);
  });

  test('maps Ack enum codec failures to invalid_enum', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final result = contract.validate({'type': 'flex', 'direction': 'diagonal'});

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.invalidEnum);
  });

  test('maps constraint_violation', () {
    final result = ack.Ack.string().minLength(2).safeParse('a');

    expect(codeFor(result.getError()), MixSchemaErrorCode.constraintViolation);
  });

  test('maps unsupported_encode_value', () {
    final result = ack.Ack.string()
        .codec<int>(
          decode: int.parse,
          encode: (value) =>
              throw UnsupportedEncodeValueError(value, 'blocked'),
        )
        .safeEncode(1);

    expect(
      codeFor(result.getError()),
      MixSchemaErrorCode.unsupportedEncodeValue,
    );
  });

  test('maps unknown_type at root discriminator', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final result = contract.validate({'type': 'missing'});

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.unknownType);
  });

  test('maps unresolved_identity_name', () {
    final result = ack.Ack.string()
        .codec<Object>(
          decode: (value) => throw UnresolvedIdentityNameError('icon', value),
          encode: (_) => 'x',
        )
        .safeParse('missing');

    expect(
      codeFor(result.getError()),
      MixSchemaErrorCode.unresolvedIdentityName,
    );
  });

  test('maps unresolved_identity_value', () {
    final value = Object();
    final result = ack.Ack.string()
        .codec<Object>(
          decode: (value) => value,
          encode: (_) => throw UnresolvedIdentityValueError('image', value),
        )
        .safeEncode(value);

    expect(
      codeFor(result.getError()),
      MixSchemaErrorCode.unresolvedIdentityValue,
    );
  });

  test('maps transform_failed', () {
    final result = ack.Ack.string()
        .codec<int>(
          decode: (_) => throw StateError('bad transform'),
          encode: (value) => '$value',
        )
        .safeParse('x');

    expect(codeFor(result.getError()), MixSchemaErrorCode.transformFailed);
  });

  test('maps validation_failed fallback', () {
    final result = ack.Ack.instance<Object>()
        .refine((_) => false, message: 'no')
        .safeParse(Object());

    expect(codeFor(result.getError()), MixSchemaErrorCode.validationFailed);
  });
}
