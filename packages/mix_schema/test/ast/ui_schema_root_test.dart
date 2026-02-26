import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('UiSchemaRoot', () {
    test('stores all fields', () {
      const root = UiSchemaRoot(
        id: 'test-schema',
        schemaVersion: '0.1',
        root: BoxNode(nodeId: 'root_box'),
        trust: SchemaTrust.standard,
      );

      expect(root.id, 'test-schema');
      expect(root.schemaVersion, '0.1');
      expect(root.root, isA<BoxNode>());
      expect(root.trust, SchemaTrust.standard);
      expect(root.environment, isNull);
    });

    test('stores environment', () {
      const root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: BoxNode(nodeId: 'box'),
        trust: SchemaTrust.standard,
        environment: SchemaEnvironment(
          data: {'key': 'value'},
        ),
      );

      expect(root.environment?.data?['key'], 'value');
    });
  });

  group('SchemaEnvironment', () {
    test('all fields optional', () {
      const env = SchemaEnvironment();
      expect(env.data, isNull);
    });

    test('stores data', () {
      const env = SchemaEnvironment(
        data: {'user': 'John'},
      );
      expect(env.data?['user'], 'John');
    });
  });
}
