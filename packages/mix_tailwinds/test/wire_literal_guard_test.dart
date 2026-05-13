import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tw_parser does not depend on schema wire enums', () {
    final source = File('lib/src/tw_parser.dart').readAsStringSync();

    expect(source, isNot(contains('schema_wire_types.dart')));
    expect(source, isNot(contains('SchemaStyler')));
    expect(source, isNot(contains('SchemaVariant')));
    expect(source, isNot(contains('SchemaModifier')));
    expect(source, isNot(contains('SchemaDecoration')));
  });

  test('tw_parser uses MixSchemaContract as the decode and encode seams', () {
    final source = File('lib/src/tw_parser.dart').readAsStringSync();

    expect(source, contains('MixSchemaContract'));
    expect(source, contains('.decode(payload)'));
    expect(source, contains('.encode(value)'));
  });
}
