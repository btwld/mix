import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
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

  test('contract builder cannot be mutated or frozen twice after freeze', () {
    final branch = Ack.object({'value': Ack.string()}).codec<_LimitStyle>(
      decode: (data) => _LimitStyle(data['value']! as String),
      encode: (value) => {'value': value.value},
    );
    final builder = MixSchemaContractBuilder().addStyler('limit', branch);
    final contract = builder.freeze();

    expect(contract.registeredTypes, ['limit']);
    expect(() => contract.registeredTypes.add('other'), throwsUnsupportedError);
    expect(
      () => builder.withLimits(const MixSchemaLimits(maxDepth: 8)),
      throwsStateError,
    );
    expect(() => builder.addStyler('other', branch), throwsStateError);
    expect(builder.builtIn, throwsStateError);
    expect(builder.freeze, throwsStateError);
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
}
