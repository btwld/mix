import 'dart:io';
import 'dart:typed_data';

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

final class _CustomStyle {
  const _CustomStyle(this.value);

  final String value;
}

void main() {
  MixSchemaContract newContract() {
    final branch = Ack.object({'value': Ack.string()}).codec<_CustomStyle>(
      decode: (data) => _CustomStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
    );

    return MixSchemaContractBuilder().addStyler('custom', branch).freeze();
  }

  test('exportJsonSchema adds mix_schema metadata', () {
    final schema = newContract().exportJsonSchema();

    expect(schema[r'$schema'], contains('draft-07'));
    expect(schema['x-mix-schema-contract'], 'mix_schema');
    expect(schema['x-mix-schema-version'], isA<String>());
  });

  test('contract builder cannot be mutated or frozen twice after freeze', () {
    final branch = Ack.object({'value': Ack.string()}).codec<_CustomStyle>(
      decode: (data) => _CustomStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
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

  test('mixSchemaVersion stays in sync with pubspec version', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*([^\s]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec)?.group(1);

    expect(version, isNotNull);
    expect(mixSchemaVersion, version);
  });

  test('shared built-in contract leaves registry-backed stylers explicit', () {
    expect(
      builtInMixSchemaContract.registeredTypes,
      isNot(contains(anyOf('icon', 'image'))),
    );

    for (final payload in [
      {'type': 'icon', 'icon': 'home'},
      {'type': 'image', 'image': 'avatar'},
    ]) {
      final result = builtInMixSchemaContract.decode<Object>(payload);
      final errors = switch (result) {
        MixSchemaDecodeFailure<Object>(:final errors) => errors,
        MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
      };

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.unknownType),
      );
      expect(
        errors.single.message,
        allOf(
          contains('registry-backed'),
          contains('MixSchemaContractBuilder().builtIn()'),
        ),
      );
    }

    for (final styler in [
      IconStyler(icon: const IconData(0xe88a, fontFamily: 'MaterialIcons')),
      ImageStyler(image: MemoryImage(Uint8List.fromList([0]))),
    ]) {
      final result = builtInMixSchemaContract.encode(styler);
      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected failure'),
      };

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.unsupportedEncodeValue),
      );
      expect(
        errors.single.message,
        allOf(
          contains('registry-backed'),
          contains('MixSchemaContractBuilder().builtIn()'),
        ),
      );
    }
  });

  test('frozen contract remains usable with original registry behavior', () {
    void onEnd() {}

    final builder = MixSchemaContractBuilder()
      ..registry.animationOnEnd('done', onEnd);
    final contract = builder.builtIn().freeze();

    expect(
      () => builder.registry.animationOnEnd('later', () {}),
      throwsStateError,
    );
    expect(
      contract.decode<BoxStyler>({
        'type': 'box',
        'animation': {
          'duration': 250,
          'curve': 'linear',
          'delay': 0,
          'onEnd': 'done',
        },
      }),
      isA<MixSchemaDecodeSuccess<BoxStyler>>(),
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

    expect(encoded, {'type': 'box'});
  });
}
