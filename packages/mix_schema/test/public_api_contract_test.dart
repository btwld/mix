import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

final class _ApiStyle {
  const _ApiStyle(this.value);

  final String value;
}

void main() {
  test('public API exposes contract, JsonMap, and sealed results', () {
    final branch = MixSchemaBranch<_ApiStyle>.json(
      decode: (data) => _ApiStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
      validate: (data) => data['value'] is String,
      validationMessage: 'API test branch requires a string value.',
    );
    final contract = MixSchemaContractBuilder()
        .addStyler('api', branch)
        .freeze();

    final JsonMap payload = {'type': 'api', 'value': 'ok'};

    expect(contract.registeredTypes, ['api']);
    expect(contract.rootSchema, isA<MixSchemaRootSchema>());
    expect(contract.rootSchema.toJsonSchema(), isA<JsonMap>());
    expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());

    final result = contract.decode<_ApiStyle>(payload);
    final value = switch (result) {
      MixSchemaDecodeSuccess<_ApiStyle>(:final value) => value.value,
      MixSchemaDecodeFailure<_ApiStyle>() => fail('expected success'),
    };
    expect(value, 'ok');
  });
}
