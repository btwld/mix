import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  test('style JSON Schema exports 1.0 protocol metadata', () {
    final schema = mixProtocol.exportStyleJsonSchema();

    expect(schema[r'$schema'], contains('draft-07'));
    expect(schema['x-mix-protocol-contract'], 'mix_protocol');
    expect(schema['x-mix-protocol-version'], '1.0.0');
    expect(schema['x-mix-protocol-format-version'], mixProtocolFormatVersion);
    expect(mixProtocolVersion, '1.0.0');
    expect(jsonEncode(schema), isNot(contains('mix_schema')));
  });

  test('package and exported metadata versions stay in lockstep', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(pubspec, contains('version: $mixProtocolVersion'));
    expect(mixProtocolFormatVersion, 1);
  });

  test('fixed protocol includes icon and image style branches', () {
    expect(
      mixProtocol.decodeStyle<IconStyler>({
        'v': 1,
        'type': 'icon',
        'icon': {'codePoint': 0xe88a, 'fontFamily': 'MaterialIcons'},
      }),
      isA<MixProtocolSuccess<IconStyler>>(),
    );
    expect(
      mixProtocol.decodeStyle<ImageStyler>({
        'v': 1,
        'type': 'image',
        'image': {'asset': 'avatar.png'},
      }),
      isA<MixProtocolSuccess<ImageStyler>>(),
    );
  });

  test('unsupported runtime identities fail without partial output', () {
    final result = mixProtocol.encodeStyle(
      ImageStyler(image: MemoryImage(Uint8List.fromList([0]))),
    );

    expect(result, isA<MixProtocolFailure<JsonMap>>());
  });

  test('decodeStyle reports a requested-type mismatch', () {
    final result = mixProtocol.decodeStyle<TextStyler>({'v': 1, 'type': 'box'});
    final errors = switch (result) {
      MixProtocolFailure<TextStyler>(:final errors) => errors,
      MixProtocolSuccess<TextStyler>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.typeMismatch);
  });

  test('minimal style decode and canonical encode inject no defaults', () {
    final decoded = switch (mixProtocol.decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
    })) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(decoded.$alignment, isNull);
    expect(decoded.$clipBehavior, isNull);
    expect(decoded.$decoration, isNull);
    expect(decoded.$modifier, isNull);
    expect(decoded.$variants, isNull);
    expect(decoded.$animation, isNull);

    final encoded = switch (mixProtocol.encodeStyle(decoded)) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };
    expect(encoded, {'v': 1, 'type': 'box'});
  });
}
