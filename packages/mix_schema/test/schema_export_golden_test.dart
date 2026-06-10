import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('R-2 schema export fingerprint contains box discriminator shape', () {
    final schema = MixSchemaContractBuilder()
        .builtIn()
        .freeze()
        .exportJsonSchema();
    final encoded = jsonEncode(schema);

    expect(schema['x-mix-schema-contract'], 'mix_schema');
    expect(encoded, contains('"type"'));
    expect(encoded, contains('"box"'));
    expect(encoded, contains('"text"'));
    expect(encoded, contains('"padding"'));
    expect(encoded, contains('"decoration"'));
    expect(encoded, contains('"clipBehavior"'));
    expect(encoded, contains('"modifiers"'));
    expect(encoded, contains('"animation"'));
    expect(encoded, isNot(contains('x-ack-codec')));
    expect(encoded.length, lessThan(150000));
  });
}
