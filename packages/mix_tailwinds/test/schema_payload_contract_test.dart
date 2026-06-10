import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  test('schema-representable box parser output encodes through mix_schema', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final style = TwParser().parseBox('bg-blue-500 p-4');

    _expectSchemaEncodes(contract, style);
  });

  test('unsupported Tailwind tokens stay parser diagnostics', () {
    final unsupported = <String>[];
    final style = TwParser(
      onUnsupported: unsupported.add,
    ).parseBox('unknown-token');

    expect(style, isA<BoxStyler>());
    expect(unsupported, contains('unknown-token'));
  });
}

void _expectSchemaEncodes(MixSchemaContract contract, Object style) {
  final result = contract.encode(style);
  if (result case MixSchemaEncodeFailure(:final errors)) {
    fail('$errors');
  }
  expect(result, isA<MixSchemaEncodeSuccess>());
}
