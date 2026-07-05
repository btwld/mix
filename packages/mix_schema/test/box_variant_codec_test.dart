import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('R-11 box variants survive decode then encode', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final decoded = contract.decode<BoxStyler>({
      'type': 'box',
      'variants': [
        {
          'kind': 'context_not_widget_state',
          'state': 'pressed',
          'style': {
            'type': 'box',
            'decoration': {'color': '#112233FF'},
          },
        },
      ],
    });

    final style = switch (decoded) {
      MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final encoded = contract.encode(style);

    final payload = switch (encoded) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'type': 'box',
      'variants': [
        {
          'kind': 'context_not_widget_state',
          'state': 'pressed',
          'style': {
            'type': 'box',
            'decoration': {'color': '#112233FF'},
          },
        },
      ],
    });
  });
}
