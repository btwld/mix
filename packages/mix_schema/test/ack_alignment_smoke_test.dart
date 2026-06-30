import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Smoke {
  const _Smoke(this.value);

  final String value;
}

void main() {
  test('Ack typed codec API supports mix_schema composition primitives', () {
    late AckSchema<JsonMap, _Smoke> lazy;
    final branch = Ack.object({'value': Ack.string()}).codec<_Smoke>(
      decode: (data) => _Smoke(data['value']! as String),
      encode: (value) => {'value': value.value},
    );

    lazy = Ack.lazy<JsonMap, _Smoke>('smoke', () {
      return Ack.discriminated<_Smoke>(
        discriminatorKey: 'type',
        schemas: {'smoke': branch},
      );
    });

    final parsed = lazy.safeParse({'type': 'smoke', 'value': 'ok'});
    expect(parsed.isOk, isTrue);
    expect(parsed.getOrNull(), isA<_Smoke>());

    final encoded = lazy.safeEncode(const _Smoke('ok'));
    expect(encoded.getOrThrow(), {'type': 'smoke', 'value': 'ok'});

    final failed = Ack.string().transform<int>(int.parse).safeEncode(1);
    expect(failed.getError(), isA<SchemaEncodeError>());
  });
}
