import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

final class _CustomStyle {
  const _CustomStyle(this.value);

  final String value;
}

final class _CustomPayloadStyle {
  const _CustomPayloadStyle(this.payload);

  final JsonMap payload;
}

void main() {
  MixSchemaContract newContract() {
    final branch = MixSchemaBranch<_CustomStyle>.json(
      decode: (data) => _CustomStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
      validate: (data) => data['value'] is String,
      validationMessage: 'Custom branch requires a string value.',
    );

    return MixSchemaContractBuilder().addStyler('custom', branch).freeze();
  }

  test('exportJsonSchema adds mix_schema metadata', () {
    final schema = newContract().exportJsonSchema();

    expect(schema[r'$schema'], contains('draft-07'));
    expect(schema['x-mix-schema-contract'], 'mix_schema');
    expect(schema['x-mix-schema-version'], isA<String>());
    expect(schema['x-mix-schema-format-version'], mixSchemaFormatVersion);
  });

  test('contract builder cannot be mutated or frozen twice after freeze', () {
    final branch = MixSchemaBranch<_CustomStyle>.json(
      decode: (data) => _CustomStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
      validate: (data) => data['value'] is String,
      validationMessage: 'Custom branch requires a string value.',
    );
    final builder = MixSchemaContractBuilder().addStyler('custom', branch);
    final contract = builder.freeze();

    expect(contract.registeredTypes, ['custom']);
    expect(() => contract.registeredTypes.add('other'), throwsUnsupportedError);
    expect(() => builder.addStyler('other', branch), throwsStateError);
    expect(builder.builtIn, throwsStateError);
    expect(builder.freeze, throwsStateError);
  });

  test('contract builder reports a domain error when frozen empty', () {
    expect(
      () => MixSchemaContractBuilder().freeze(),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          allOf(contains('builtIn()'), contains('addStyler()')),
        ),
      ),
    );
  });

  test('format version is distinct from package version metadata', () {
    final schema = newContract().exportJsonSchema();

    expect(mixSchemaFormatVersion, 1);
    expect(schema['x-mix-schema-format-version'], mixSchemaFormatVersion);
    expect(schema['x-mix-schema-version'], mixSchemaVersion);
    expect(mixSchemaVersion, isA<String>());
  });

  test(
    'format version envelope is authoritative over custom branch fields',
    () {
      final branch = MixSchemaBranch<_CustomStyle>.json(
        decode: (data) => _CustomStyle(data['value']! as String),
        encode: (value) => {'v': 99, 'value': value.value},
        validate: (data) => data['value'] is String,
        validationMessage: 'Custom branch requires a string value.',
      );
      final contract = MixSchemaContractBuilder()
          .addStyler('custom', branch)
          .freeze();

      final encoded = switch (contract.encode(const _CustomStyle('ok'))) {
        MixSchemaEncodeSuccess(:final value) => value,
        MixSchemaEncodeFailure(:final errors) => fail('$errors'),
      };
      final schema = contract.exportJsonSchema();
      final branchSchema = (schema['anyOf']! as List).cast<JsonMap>().single;
      final properties = branchSchema['properties']! as JsonMap;

      expect(encoded['v'], mixSchemaFormatVersion);
      expect((properties['v']! as JsonMap)['const'], mixSchemaFormatVersion);
      expect((properties['v']! as JsonMap)['type'], 'integer');
    },
  );

  test('custom payload marker names round-trip but unknown markers fail', () {
    final branch = MixSchemaBranch<_CustomPayloadStyle>.json(
      decode: (data) => _CustomPayloadStyle(
        (data['payload']! as Map).cast<String, Object?>(),
      ),
      encode: (value) => {'payload': value.payload},
      validate: (data) => data['payload'] is Map,
      validationMessage: 'Custom branch requires a payload object.',
    );
    final contract = MixSchemaContractBuilder()
        .addStyler('custom', branch)
        .freeze();
    final payload = <String, Object?>{
      'tokenTerm': <String, Object?>{
        r'$token': 'custom.token',
        'apply': [
          <String, Object?>{'op': 'custom_directive'},
        ],
      },
      'mergeTerm': <String, Object?>{
        r'$merge': [
          <String, Object?>{'value': 'first'},
          <String, Object?>{'value': 'second'},
        ],
        'apply': [
          <String, Object?>{'op': 'custom_directive'},
        ],
      },
    };

    final encoded = switch (contract.encode(_CustomPayloadStyle(payload))) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };
    final decoded = switch (contract.decode<_CustomPayloadStyle>({
      'v': mixSchemaFormatVersion,
      'type': 'custom',
      'payload': payload,
    })) {
      MixSchemaDecodeSuccess<_CustomPayloadStyle>(:final value) => value,
      MixSchemaDecodeFailure<_CustomPayloadStyle>(:final errors) => fail(
        '$errors',
      ),
    };
    final rejected = contract.decode<_CustomPayloadStyle>({
      'v': mixSchemaFormatVersion,
      'type': 'custom',
      'payload': {
        'unknownTerm': {r'$custom': 'owned'},
      },
    });

    expect(encoded['payload'], payload);
    expect(decoded.payload, payload);
    final errors = switch (rejected) {
      MixSchemaDecodeFailure<_CustomPayloadStyle>(:final errors) => errors,
      MixSchemaDecodeSuccess<_CustomPayloadStyle>() => fail('expected failure'),
    };
    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unknownField),
    );
    expect(
      errors.map((error) => error.path),
      contains(r'/payload/unknownTerm/$custom'),
    );
  });

  test('shared built-in contract includes icon and image stylers', () {
    expect(
      builtInMixSchemaContract.registeredTypes,
      containsAll(<String>['icon', 'image']),
    );

    expect(
      builtInMixSchemaContract.decode<IconStyler>({
        'type': 'icon',
        'icon': {'codePoint': 0xe88a, 'fontFamily': 'MaterialIcons'},
      }),
      isA<MixSchemaDecodeSuccess<IconStyler>>(),
    );
    expect(
      builtInMixSchemaContract.decode<ImageStyler>({
        'type': 'image',
        'image': {'asset': 'avatar.png'},
      }),
      isA<MixSchemaDecodeSuccess<ImageStyler>>(),
    );
  });

  test('contract builder has no frozen registry state', () {
    final builder = MixSchemaContractBuilder();
    final contract = builder.builtIn().freeze();

    expect(
      contract.encode(ImageStyler(image: MemoryImage(Uint8List.fromList([0])))),
      isA<MixSchemaEncodeFailure>(),
    );
  });

  test('decode reports typeMismatch when payload type differs from T', () {
    final result = MixSchemaContractBuilder()
        .builtIn()
        .freeze()
        .decode<TextStyler>({'type': 'box'});

    final errors = switch (result) {
      MixSchemaDecodeFailure<TextStyler>(:final errors) => errors,
      MixSchemaDecodeSuccess<TextStyler>() => fail('expected decode failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.typeMismatch);
  });

  test('decode of minimal styler payload does not inject defaults', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final decoded = switch (contract.decode<BoxStyler>({'type': 'box'})) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(decoded.$alignment, isNull);
    expect(decoded.$clipBehavior, isNull);
    expect(decoded.$decoration, isNull);
    expect(decoded.$modifier, isNull);
    expect(decoded.$variants, isNull);
    expect(decoded.$animation, isNull);

    final encoded = switch (contract.encode(decoded)) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(encoded, {'v': 1, 'type': 'box'});
  });
}
