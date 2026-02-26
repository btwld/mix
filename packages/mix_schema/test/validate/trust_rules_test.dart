import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

import '../fixtures/invalid/invalid_payloads.dart';

void main() {
  const rules = TrustRules();

  group('TrustRules', () {
    test('shallow tree passes minimal trust', () {
      const node = BoxNode(
        nodeId: 'root',
        child: TextNode(nodeId: 'text', content: DirectValue('hello')),
      );

      final diags = rules.validate(node, SchemaTrust.minimal);
      expect(diags, isEmpty);
    });

    test('deep tree fails minimal trust (depth > 5)', () {
      // Build a tree 7 levels deep
      final payload = buildDeepTree(7);
      final adapter = const A2uiV09Adapter();
      final result = adapter.adapt(
        payload,
        const AdaptContext(trust: SchemaTrust.minimal),
      );

      // Even if adaptation succeeds, trust validation should fail
      if (result.root != null) {
        final diags = rules.validate(result.root!.root, SchemaTrust.minimal);
        final depthErrors = diags.where(
          (d) => d.code == DiagnosticCode.depthLimitExceeded,
        );
        expect(depthErrors, isNotEmpty);
      }
    });

    test('wide tree fails minimal trust (nodes > 50)', () {
      final payload = buildWideTree(55);
      final adapter = const A2uiV09Adapter();
      final result = adapter.adapt(
        payload,
        const AdaptContext(trust: SchemaTrust.minimal),
      );

      if (result.root != null) {
        final diags = rules.validate(result.root!.root, SchemaTrust.minimal);
        final countErrors = diags.where(
          (d) => d.code == DiagnosticCode.nodeCountExceeded,
        );
        expect(countErrors, isNotEmpty);
      }
    });

    test('animated nodes within limit pass', () {
      const node = FlexNode(
        nodeId: 'flex',
        children: [
          BoxNode(
            nodeId: 'b1',
            animation: SchemaAnimation(durationMs: 300),
          ),
          BoxNode(
            nodeId: 'b2',
            animation: SchemaAnimation(durationMs: 200),
          ),
        ],
      );

      final diags = rules.validate(node, SchemaTrust.minimal);
      final animErrors = diags.where(
        (d) => d.code == DiagnosticCode.animationComplexityExceeded,
      );
      expect(animErrors, isEmpty);
    });

    test('too many animated nodes warns', () {
      // Minimal trust allows 5 animated nodes
      final children = <SchemaNode>[];
      for (var i = 0; i < 7; i++) {
        children.add(BoxNode(
          nodeId: 'b_$i',
          animation: const SchemaAnimation(durationMs: 300),
        ));
      }

      final node = FlexNode(nodeId: 'flex', children: children);
      final diags = rules.validate(node, SchemaTrust.minimal);
      final animWarnings = diags.where(
        (d) => d.code == DiagnosticCode.animationComplexityExceeded,
      );
      expect(animWarnings, isNotEmpty);
    });

    test('standard trust allows deeper trees', () {
      // Standard trust allows depth 10
      const node = BoxNode(
        nodeId: 'b1',
        child: BoxNode(
          nodeId: 'b2',
          child: BoxNode(
            nodeId: 'b3',
            child: BoxNode(
              nodeId: 'b4',
              child: BoxNode(
                nodeId: 'b5',
                child: BoxNode(
                  nodeId: 'b6',
                  child: BoxNode(
                    nodeId: 'b7',
                    child: TextNode(
                      nodeId: 'leaf',
                      content: DirectValue('deep'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final diags = rules.validate(node, SchemaTrust.standard);
      final depthErrors = diags.where(
        (d) => d.code == DiagnosticCode.depthLimitExceeded,
      );
      expect(depthErrors, isEmpty);
    });

    test('maxDepthOverride takes precedence', () {
      const node = BoxNode(
        nodeId: 'b1',
        child: BoxNode(
          nodeId: 'b2',
          child: BoxNode(
            nodeId: 'b3',
            child: TextNode(nodeId: 'leaf', content: DirectValue('deep')),
          ),
        ),
      );

      // Override to allow only depth 2
      final diags = rules.validate(
        node,
        SchemaTrust.elevated,
        maxDepthOverride: 2,
      );
      final depthErrors = diags.where(
        (d) => d.code == DiagnosticCode.depthLimitExceeded,
      );
      expect(depthErrors, isNotEmpty);
    });

    test('maxNodeCountOverride takes precedence', () {
      final children = <SchemaNode>[];
      for (var i = 0; i < 5; i++) {
        children.add(TextNode(
          nodeId: 'text_$i',
          content: const DirectValue('text'),
        ));
      }

      final node = FlexNode(nodeId: 'flex', children: children);

      // Override to allow only 3 nodes
      final diags = rules.validate(
        node,
        SchemaTrust.elevated,
        maxNodeCountOverride: 3,
      );
      final countErrors = diags.where(
        (d) => d.code == DiagnosticCode.nodeCountExceeded,
      );
      expect(countErrors, isNotEmpty);
    });
  });
}
