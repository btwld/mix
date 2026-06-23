import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
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
