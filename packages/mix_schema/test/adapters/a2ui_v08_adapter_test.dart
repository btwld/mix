import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

import '../fixtures/lossy/v08_payload.dart';

void main() {
  late A2uiV08Adapter adapter;

  setUp(() {
    adapter = const A2uiV08Adapter();
  });

  group('A2uiV08Adapter', () {
    test('id and supportedVersions', () {
      expect(adapter.id, 'a2ui_v0_8_stable');
      expect(adapter.supportedVersions, ['0.8']);
    });

    test('adapts v0.8 payload with deprecated field names', () {
      final result = adapter.adapt(
        v08Payload,
        const AdaptContext(trust: SchemaTrust.standard),
      );

      expect(result.root, isNotNull);
      expect(result.root!.id, 'test_v08');
      expect(result.root!.trust, SchemaTrust.standard);

      final box = result.root!.root as BoxNode;
      expect(box.nodeId, 'v08_box');
      expect(box.style, isNotNull);
      expect(box.semantics?.role, 'region');
      expect(box.semantics?.label, 'Main content');

      final text = box.child as TextNode;
      expect(text.nodeId, 'v08_text');
    });

    test('emits lossy adaptation diagnostics', () {
      final result = adapter.adapt(
        v08Payload,
        const AdaptContext(trust: SchemaTrust.standard),
      );

      final lossyDiags = result.diagnostics.where(
        (d) => d.code == DiagnosticCode.lossyAdaptation,
      );

      // Should have diagnostics for: schema_version→version,
      // ui→root, trust_level→trust, styles→style, a11y→semantics
      expect(lossyDiags.length, greaterThanOrEqualTo(3));
    });

    test('normalizes nested v0.8 nodes', () {
      final result = adapter.adapt(
        v08NestedPayload,
        const AdaptContext(trust: SchemaTrust.standard),
      );

      expect(result.root, isNotNull);
      final flex = result.root!.root as FlexNode;
      expect(flex.nodeId, 'v08_flex');
      expect(flex.children.length, 2);

      final child1 = flex.children[0] as TextNode;
      expect(child1.nodeId, 'v08_child_1');
    });

    test('rejects non-map payload', () {
      final result = adapter.adapt(
        'not a map',
        const AdaptContext(trust: SchemaTrust.standard),
      );

      expect(result.root, isNull);
      expect(result.hasErrors, true);
    });
  });
}
