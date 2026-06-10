import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

final class _LimitStyle {
  const _LimitStyle(this.value);

  final String value;
}

void main() {
  MixSchemaContract newContract({MixSchemaLimits? limits}) {
    final branch = Ack.object({'value': Ack.string()}).codec<_LimitStyle>(
      decode: (data) => _LimitStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
    );

    return MixSchemaContractBuilder(
      limits: limits ?? const MixSchemaLimits(),
    ).addStyler('limit', branch).freeze();
  }

  test('R-8 validates payload limits before Ack decode', () {
    final contract = newContract(
      limits: const MixSchemaLimits(maxStringLength: 10),
    );

    final result = contract.decode<_LimitStyle>({
      'type': 'limit',
      'value': 'too long payload',
    });

    final errors = switch (result) {
      MixSchemaDecodeFailure<_LimitStyle>(:final errors) => errors,
      MixSchemaDecodeSuccess<_LimitStyle>() => fail('expected limit failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.payloadLimitExceeded);
    expect(errors.single.path, '/value');
  });

  test('exportJsonSchema adds mix_schema metadata', () {
    final schema = newContract().exportJsonSchema();

    expect(schema[r'$schema'], contains('draft-07'));
    expect(schema['x-mix-schema-contract'], 'mix_schema');
    expect(schema['x-mix-schema-version'], isA<String>());
    expect(schema['x-mix-schema-limits'], isA<Map<String, Object?>>());
  });
}
