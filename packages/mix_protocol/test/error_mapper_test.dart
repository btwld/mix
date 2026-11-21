import 'dart:convert';
import 'dart:typed_data';

import 'package:ack/ack.dart' as ack;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/src/errors/mix_protocol_error.dart';
import 'package:mix_protocol/src/errors/schema_error_mapper.dart';

void main() {
  test(
    'public diagnostic wire codes remain stable across the package rename',
    () {
      expect(MixProtocolErrorCode.values.map((code) => code.wireValue), [
        'unsupported_version',
        'null_forbidden',
        'limit_exceeded',
        'type_mismatch',
        'required_field',
        'unknown_field',
        'invalid_enum',
        'invalid_token_name',
        'constraint_violation',
        'unsupported_encode_value',
        'inventory_skew',
        'unknown_type',
        'unresolved_identity_name',
        'unresolved_identity_value',
        'validation_failed',
        'transform_failed',
      ]);
    },
  );

  test('public diagnostics omit runtime-only values from JSON output', () {
    final typeMismatch = mixProtocol.decodeStyle<TextStyler>({
      'v': 1,
      'type': 'box',
    });
    final typeMismatchError = switch (typeMismatch) {
      MixProtocolFailure<TextStyler>(:final errors) => errors.single,
      MixProtocolSuccess<TextStyler>() => fail('expected failure'),
    };
    final unsupportedIdentity = mixProtocol.encodeStyle(
      ImageStyler(image: MemoryImage(Uint8List.fromList([1]))),
    );
    final unsupportedIdentityError = switch (unsupportedIdentity) {
      MixProtocolFailure<JsonMap>(:final errors) => errors.single,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    for (final error in [typeMismatchError, unsupportedIdentityError]) {
      expect(error.toJson(), isNot(contains('value')));
      expect(() => jsonEncode(error.toJson()), returnsNormally);
    }
  });

  test('public diagnostics preserve recursively JSON-safe values', () {
    const error = MixProtocolError(
      code: MixProtocolErrorCode.constraintViolation,
      path: '/value',
      message: 'Invalid value.',
      value: {
        'items': [1, 2.5, 'three', true, null],
      },
    );

    expect(error.toJson()['value'], {
      'items': [1, 2.5, 'three', true, null],
    });
    expect(() => jsonEncode(error.toJson()), returnsNormally);
  });

  MixProtocolErrorCode codeFor(ack.SchemaError error) {
    return mapSchemaError(error).single.code;
  }

  test('maps type_mismatch', () {
    final result = ack.Ack.object({
      'value': ack.Ack.string(),
    }).safeParse('nope');

    expect(codeFor(result.getError()), MixProtocolErrorCode.typeMismatch);
  });

  test('reaches unsupported_version through contract preflight', () {
    final result = mixProtocol.decodeStyle<Object>({'v': 2, 'type': 'box'});

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.unsupportedVersion);
  });

  test('reaches null_forbidden through contract preflight', () {
    final result = mixProtocol.decodeStyle<Object>({
      'v': 1,
      'type': 'box',
      'padding': null,
    });

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.nullForbidden);
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

    final result = mixProtocol.decodeStyle<Object>({'v': 1, ...style});

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.limitExceeded);
  });

  test('carries warning severity separately from errors', () {
    final result = mixProtocol.decodeStyle<Object>(
      {'v': 1, 'type': 'box', 'future': true},
      options: const MixProtocolDecodeOptions(
        mode: MixProtocolDecodeMode.lenient,
      ),
    );

    final warnings = switch (result) {
      MixProtocolSuccess<Object>(:final warnings) => warnings,
      MixProtocolFailure<Object>(:final errors) => fail('$errors'),
    };

    expect(warnings.single.code, MixProtocolErrorCode.unknownField);
    expect(warnings.single.severity, MixProtocolDiagnosticSeverity.warning);
  });

  test('maps required_field', () {
    final result = ack.Ack.object({'value': ack.Ack.string()}).safeParse({});

    expect(codeFor(result.getError()), MixProtocolErrorCode.requiredField);
  });

  test('maps unknown_field', () {
    final result = ack.Ack.object({
      'value': ack.Ack.string(),
    }).safeParse({'value': 'x', 'extra': true});

    expect(codeFor(result.getError()), MixProtocolErrorCode.unknownField);
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

    expect(errors.single.code, MixProtocolErrorCode.unknownField);
    expect(errors.single.path, '/outer/future');
  });

  test('maps invalid_enum', () {
    final result = ack.Ack.enumString(['a']).safeParse('b');

    expect(codeFor(result.getError()), MixProtocolErrorCode.invalidEnum);
  });

  test('maps Ack enum codec failures to invalid_enum', () {
    final contract = mixProtocol;
    final result = contract.decodeStyle<Object>({
      'v': 1,
      'type': 'flex',
      'direction': 'diagonal',
    });

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.invalidEnum);
  });

  test('maps constraint_violation', () {
    final result = ack.Ack.string().minLength(2).safeParse('a');

    expect(
      codeFor(result.getError()),
      MixProtocolErrorCode.constraintViolation,
    );
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
      MixProtocolErrorCode.unsupportedEncodeValue,
    );
  });

  test('maps unknown_type at root discriminator', () {
    final contract = mixProtocol;
    final result = contract.decodeStyle<Object>({'v': 1, 'type': 'missing'});

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.unknownType);
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
      MixProtocolErrorCode.unresolvedIdentityName,
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
      MixProtocolErrorCode.unresolvedIdentityValue,
    );
  });

  test('maps transform_failed', () {
    final result = ack.Ack.string()
        .codec<int>(
          decode: (_) => throw StateError('bad transform'),
          encode: (value) => '$value',
        )
        .safeParse('x');

    expect(codeFor(result.getError()), MixProtocolErrorCode.transformFailed);
  });

  test('maps validation_failed fallback', () {
    final result = ack.Ack.instance<Object>()
        .refine((_) => false, message: 'no')
        .safeParse(Object());

    expect(codeFor(result.getError()), MixProtocolErrorCode.validationFailed);
  });
}
