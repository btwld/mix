import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  const validator = DefaultSchemaValidator();

  group('DefaultSchemaValidator', () {
    test('valid simple schema passes all layers', () {
      const root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: BoxNode(
          nodeId: 'box',
          child: TextNode(nodeId: 'text', content: DirectValue('hello')),
        ),
        trust: SchemaTrust.standard,
      );

      final result = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.standard),
      );

      expect(result.isValid, true);
      expect(result.diagnostics, isEmpty);
    });

    test('structural error makes result invalid', () {
      const root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: TextNode(nodeId: 'text', content: DirectValue(null)),
        trust: SchemaTrust.standard,
      );

      final result = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.standard),
      );

      expect(result.isValid, false);
      expect(result.diagnostics.any(
        (d) => d.code == DiagnosticCode.missingRequiredField,
      ), true);
    });

    test('semantic warnings do not make result invalid', () {
      const root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: PressableNode(
          nodeId: 'press',
          child: TextNode(nodeId: 'text', content: DirectValue('Click')),
        ),
        trust: SchemaTrust.standard,
      );

      final result = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.standard),
      );

      // Warnings from semantic rules but no errors
      expect(result.isValid, true);
      expect(result.diagnostics, isNotEmpty);
      expect(
        result.diagnostics.every(
          (d) => d.severity != DiagnosticSeverity.error,
        ),
        true,
      );
    });

    test('combines diagnostics from all layers', () {
      // Build tree with both structural and semantic issues
      const root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: FlexNode(
          nodeId: 'flex',
          children: [
            TextNode(nodeId: 'text', content: DirectValue(null)), // structural
            PressableNode(
              // semantic
              nodeId: 'press',
              child: TextNode(nodeId: 'inner', content: DirectValue('ok')),
            ),
          ],
        ),
        trust: SchemaTrust.standard,
      );

      final result = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.standard),
      );

      expect(result.isValid, false); // due to structural error
      expect(result.diagnostics.length, greaterThan(1));
    });

    test('uses trust from context', () {
      // Build a tree that's fine for standard but not for minimal
      final children = <SchemaNode>[];
      for (var i = 0; i < 55; i++) {
        children.add(TextNode(
          nodeId: 'text_$i',
          content: const DirectValue('text'),
        ));
      }

      final root = UiSchemaRoot(
        id: 'test',
        schemaVersion: '0.1',
        root: FlexNode(nodeId: 'flex', children: children),
        trust: SchemaTrust.minimal,
      );

      final minimalResult = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.minimal),
      );

      final standardResult = validator.validate(
        root,
        const ValidationContext(trust: SchemaTrust.standard),
      );

      // Minimal should fail (>50 nodes), standard should pass (<200)
      expect(minimalResult.isValid, false);
      expect(standardResult.isValid, true);
    });
  });
}
