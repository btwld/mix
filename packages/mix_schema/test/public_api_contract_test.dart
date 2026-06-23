import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

final class _ApiStyle {
  const _ApiStyle(this.value);

  final String value;
}

void main() {
  test('public API exposes contract, JsonMap, and sealed results', () {
    final branch = Ack.object({'value': Ack.string()}).codec<_ApiStyle>(
      decode: (data) => _ApiStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
    );
    final contract = MixSchemaContractBuilder()
        .addStyler('api', branch)
        .freeze();

    final JsonMap payload = {'type': 'api', 'value': 'ok'};

    expect(contract.registeredTypes, ['api']);
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());

    final result = contract.decode<_ApiStyle>(payload);
    final value = switch (result) {
      MixSchemaDecodeSuccess<_ApiStyle>(:final value) => value.value,
      MixSchemaDecodeFailure<_ApiStyle>() => fail('expected success'),
    };
    expect(value, 'ok');
  });
}
