import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart' as encode_compat;
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/testing.dart' as schema_testing;

final class _ApiStyle {
  const _ApiStyle(this.value);

  final String value;
}

void main() {
  test(
    'public API exposes contract, vocabulary, JsonMap, and sealed results',
    () {
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
      expect(SchemaStyler.box.wireValue, 'box');
      expect(SchemaModifier.opacity.wireValue, 'opacity');
      expect(SchemaVariant.widgetState.wireValue, 'widget_state');
      expect(builtInMixSchemaContract.registeredTypes, contains('box'));
      expect(
        schema_testing.payloadStyler(schema_testing.SchemaStyler.box)['type'],
        'box',
      );
      expect(
        encode_compat.payloadModifier(encode_compat.SchemaModifier.opacity, {
          'opacity': 0.5,
        })['type'],
        'opacity',
      );

      final result = contract.decode<_ApiStyle>(payload);
      final value = switch (result) {
        MixSchemaDecodeSuccess<_ApiStyle>(:final value) => value.value,
        MixSchemaDecodeFailure<_ApiStyle>() => fail('expected success'),
      };
      expect(value, 'ok');
    },
  );
}
