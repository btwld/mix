import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
// ignore: implementation_imports
import 'package:mix_schema/src/core/branch_codec.dart';
// ignore: implementation_imports
import 'package:mix_schema/src/errors/schema_error_mapper.dart';

void main() {
  group('discriminatedBranchCodec', () {
    test('unsupported runtime subtype encodes as unsupported_encode_value', () {
      final codec = Ack.discriminated<_Animal>(
        discriminatorKey: 'type',
        schemas: {
          'dog': discriminatedBranchCodec<_Animal, _Dog>(
            type: 'dog',
            input: Ack.object({'breed': Ack.string()}),
            decode: (data) => _Dog(data['breed']! as String),
            encode: (value) => {'breed': value.breed},
          ),
          'cat': discriminatedBranchCodec<_Animal, _Cat>(
            type: 'cat',
            input: Ack.object({'name': Ack.string()}),
            decode: (data) => _Cat(data['name']! as String),
            encode: (value) => {'name': value.name},
          ),
        },
      );

      final result = codec.safeEncode(const _Bird('sparrow'));
      expect(result.isFail, isTrue);

      const mapper = SchemaErrorMapper();
      final mapped = mapper.mapEncode(result.getError());

      expect(mapped, hasLength(1));
      expect(mapped.single.code, MixSchemaErrorCode.unsupportedEncodeValue);
      expect(mapped.single.message, contains('Unsupported encode subtype'));
    });

    test('supported subtypes still round-trip', () {
      final codec = Ack.discriminated<_Animal>(
        discriminatorKey: 'type',
        schemas: {
          'dog': discriminatedBranchCodec<_Animal, _Dog>(
            type: 'dog',
            input: Ack.object({'breed': Ack.string()}),
            decode: (data) => _Dog(data['breed']! as String),
            encode: (value) => {'breed': value.breed},
          ),
        },
      );

      final encoded = codec.safeEncode(const _Dog('beagle'));
      expect(encoded.getOrThrow(), {'type': 'dog', 'breed': 'beagle'});

      final decoded = codec.safeParse({'type': 'dog', 'breed': 'beagle'});
      expect(decoded.getOrThrow(), isA<_Dog>());
    });

    test('user encode cannot override the injected discriminator', () {
      final codec = Ack.discriminated<_Animal>(
        discriminatorKey: 'type',
        schemas: {
          'dog': discriminatedBranchCodec<_Animal, _Dog>(
            type: 'dog',
            input: Ack.object({'breed': Ack.string()}),
            decode: (data) => _Dog(data['breed']! as String),
            encode: (value) => {'type': 'spoofed', 'breed': value.breed},
          ),
        },
      );

      final encoded = codec.safeEncode(const _Dog('beagle'));
      expect(encoded.getOrThrow(), {'type': 'dog', 'breed': 'beagle'});
    });
  });

  group('buildDiscriminatorInjectingCodec', () {
    test('rejects input schemas that declare the discriminator field', () {
      expect(
        () => buildDiscriminatorInjectingCodec<_Dog>(
          type: 'dog',
          input: Ack.object({
            'type': Ack.literal('spoofed'),
            'breed': Ack.string(),
          }),
          decode: (data) => _Dog(data['breed']! as String),
          encode: (value) => {'breed': value.breed},
        ),
        throwsArgumentError,
      );
    });

    test('user encode cannot override the injected discriminator', () {
      final codec = Ack.discriminated<Object>(
        discriminatorKey: 'type',
        schemas: {
          'dog': buildDiscriminatorInjectingCodec<_Dog>(
            type: 'dog',
            input: Ack.object({'breed': Ack.string()}),
            decode: (data) => _Dog(data['breed']! as String),
            encode: (value) => {'type': 'spoofed', 'breed': value.breed},
          ),
        },
      );

      final encoded = codec.safeEncode(const _Dog('beagle'));
      expect(encoded.getOrThrow(), {'type': 'dog', 'breed': 'beagle'});
    });
  });

  group('standaloneBranchCodec', () {
    test('rejects input schemas that declare the discriminator field', () {
      expect(
        () => standaloneBranchCodec<_Animal, _Dog>(
          type: 'dog',
          input: Ack.object({
            'type': Ack.literal('spoofed'),
            'breed': Ack.string(),
          }),
          decode: (data) => _Dog(data['breed']! as String),
          encode: (value) => {'breed': value.breed},
        ),
        throwsArgumentError,
      );
    });

    test('rejects payloads whose discriminator does not match the branch', () {
      final codec = standaloneBranchCodec<_Animal, _Dog>(
        type: 'dog',
        input: Ack.object({'breed': Ack.string()}),
        decode: (data) => _Dog(data['breed']! as String),
        encode: (value) => {'breed': value.breed},
      );

      final result = codec.safeParse({'type': 'cat', 'breed': 'beagle'});

      expect(result.isFail, isTrue);
    });

    test('unsupported runtime subtype encodes as unsupported_encode_value', () {
      final codec = standaloneBranchCodec<_Animal, _Dog>(
        type: 'dog',
        input: Ack.object({'breed': Ack.string()}),
        decode: (data) => _Dog(data['breed']! as String),
        encode: (value) => {'breed': value.breed},
      );

      final result = codec.safeEncode(const _Bird('sparrow'));
      expect(result.isFail, isTrue);

      const mapper = SchemaErrorMapper();
      final mapped = mapper.mapEncode(result.getError());

      expect(mapped, hasLength(1));
      expect(mapped.single.code, MixSchemaErrorCode.unsupportedEncodeValue);
    });

    test('custom outputRefinementMessage is still mapped via sentinel', () {
      final codec = standaloneBranchCodec<_Animal, _Dog>(
        type: 'dog',
        input: Ack.object({'breed': Ack.string()}),
        decode: (data) => _Dog(data['breed']! as String),
        encode: (value) => {'breed': value.breed},
        outputRefinement: (value) => value is _Dog,
        outputRefinementMessage: 'Custom message without sentinel.',
      );

      final result = codec.safeEncode(const _Bird('sparrow'));
      expect(result.isFail, isTrue);

      const mapper = SchemaErrorMapper();
      final mapped = mapper.mapEncode(result.getError());

      expect(mapped, hasLength(1));
      expect(mapped.single.code, MixSchemaErrorCode.unsupportedEncodeValue);
      expect(mapped.single.message, contains('Unsupported encode subtype'));
      expect(
        mapped.single.message,
        contains('Custom message without sentinel.'),
      );
    });

    test('user encode cannot override the injected discriminator', () {
      final codec = standaloneBranchCodec<_Animal, _Dog>(
        type: 'dog',
        input: Ack.object({'breed': Ack.string()}),
        decode: (data) => _Dog(data['breed']! as String),
        encode: (value) => {'type': 'spoofed', 'breed': value.breed},
      );

      final encoded = codec.safeEncode(const _Dog('beagle'));
      expect(encoded.getOrThrow(), {'type': 'dog', 'breed': 'beagle'});
    });
  });
}

abstract class _Animal {
  const _Animal();
}

class _Dog extends _Animal {
  final String breed;
  const _Dog(this.breed);
}

class _Cat extends _Animal {
  final String name;
  const _Cat(this.name);
}

class _Bird extends _Animal {
  final String species;
  const _Bird(this.species);
}
