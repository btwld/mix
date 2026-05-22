import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'tw_parser only imports schema wire enums through the public surface',
    () {
      final source = File('lib/src/tw_parser.dart').readAsStringSync();

      // Must not reach into internal implementation files.
      expect(source, isNot(contains('schema_wire_types.dart')));
      expect(source, isNot(contains('package:mix_schema/src/')));
    },
  );

  test(
    'tw_parser does not hardcode wire-name string literals for branch types',
    () {
      final source = File('lib/src/tw_parser.dart').readAsStringSync();

      // Old form was a list of `const _boxType = 'box';` style constants. After
      // D3, the only wire-value source must be SchemaX.Y.wireValue references.
      expect(source, isNot(contains("const _boxType = '")));
      expect(source, isNot(contains("const _flexBoxType = '")));
      expect(source, isNot(contains("const _boxDecorationType = '")));
    },
  );

  test('tw_parser uses MixSchemaContract as the decode and encode seams', () {
    final source = File('lib/src/tw_parser.dart').readAsStringSync();

    expect(source, contains('MixSchemaContract'));
    expect(source, contains('.decode(payload)'));
    expect(source, contains('.encode(value)'));
  });
}
