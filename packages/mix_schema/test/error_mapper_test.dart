import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';

void main() {
  MixSchemaErrorCode codeFor(SchemaError error) {
    return mapSchemaError(error).single.code;
  }

  test('R-7 maps type_mismatch', () {
    final result = Ack.object({'value': Ack.string()}).safeParse('nope');

    expect(codeFor(result.getError()), MixSchemaErrorCode.typeMismatch);
  });

  test('R-7 maps required_field', () {
    final result = Ack.object({'value': Ack.string()}).safeParse({});

    expect(codeFor(result.getError()), MixSchemaErrorCode.requiredField);
  });

  test('R-7 maps unknown_field', () {
    final result = Ack.object({
      'value': Ack.string(),
    }).safeParse({'value': 'x', 'extra': true});

    expect(codeFor(result.getError()), MixSchemaErrorCode.unknownField);
  });

  test('R-7 maps invalid_enum', () {
    final result = Ack.enumString(['a']).safeParse('b');

    expect(codeFor(result.getError()), MixSchemaErrorCode.invalidEnum);
  });

  test('R-7 maps Ack enum codec failures to invalid_enum', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final result = contract.validate({'type': 'flex', 'direction': 'diagonal'});

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.invalidEnum);
  });

  test('R-7 maps constraint_violation', () {
    final result = Ack.string().minLength(2).safeParse('a');

    expect(codeFor(result.getError()), MixSchemaErrorCode.constraintViolation);
  });

  test('R-7 maps unsupported_encode_value', () {
    final result = Ack.string()
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

  test('R-7 maps unknown_type at root discriminator', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final result = contract.validate({'type': 'missing'});

    final errors = switch (result) {
      MixSchemaValidationFailure(:final errors) => errors,
      MixSchemaValidationSuccess() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.unknownType);
  });

  test('R-7 maps unknown_registry_id', () {
    final result = Ack.string()
        .codec<Object>(
          decode: (value) => throw UnknownRegistryIdError(
            MixSchemaScope.animationOnEnd,
            value,
          ),
          encode: (_) => 'x',
        )
        .safeParse('missing');

    expect(codeFor(result.getError()), MixSchemaErrorCode.unknownRegistryId);
  });

  test('R-7 maps unknown_registry_value', () {
    final value = Object();
    final result = Ack.string()
        .codec<Object>(
          decode: (value) => value,
          encode: (_) => throw UnknownRegistryValueError(
            MixSchemaScope.animationOnEnd,
            value,
          ),
        )
        .safeEncode(value);

    expect(codeFor(result.getError()), MixSchemaErrorCode.unknownRegistryValue);
  });

  test('R-7 maps transform_failed', () {
    final result = Ack.string()
        .codec<int>(
          decode: (_) => throw StateError('bad transform'),
          encode: (value) => '$value',
        )
        .safeParse('x');

    expect(codeFor(result.getError()), MixSchemaErrorCode.transformFailed);
  });

  test('R-7 maps validation_failed fallback', () {
    final result = Ack.instance<Object>()
        .refine((_) => false, message: 'no')
        .safeParse(Object());

    expect(codeFor(result.getError()), MixSchemaErrorCode.validationFailed);
  });
}
