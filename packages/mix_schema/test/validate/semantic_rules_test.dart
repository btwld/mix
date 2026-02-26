import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/validate/semantic_rules.dart';

void main() {
  const rules = SemanticRules();

  group('SemanticRules', () {
    test('pressable without role warns', () {
      const node = PressableNode(
        nodeId: 'press1',
        child: TextNode(nodeId: 't1', content: DirectValue('Click')),
      );

      final diags = rules.validate(node);
      final roleWarnings = diags.where(
        (d) => d.code == DiagnosticCode.interactiveNodeMissingRole,
      );
      expect(roleWarnings, isNotEmpty);
    });

    test('pressable without label warns', () {
      const node = PressableNode(
        nodeId: 'press1',
        child: TextNode(nodeId: 't1', content: DirectValue('Click')),
      );

      final diags = rules.validate(node);
      final labelWarnings = diags.where(
        (d) => d.code == DiagnosticCode.pressableMissingLabel,
      );
      expect(labelWarnings, isNotEmpty);
    });

    test('pressable with semantics passes', () {
      const node = PressableNode(
        nodeId: 'press1',
        semantics: SchemaSemantics(role: 'button', label: 'Submit'),
        child: TextNode(nodeId: 't1', content: DirectValue('Submit')),
      );

      final diags = rules.validate(node);
      final pressWarnings = diags.where(
        (d) =>
            d.code == DiagnosticCode.interactiveNodeMissingRole ||
            d.code == DiagnosticCode.pressableMissingLabel,
      );
      expect(pressWarnings, isEmpty);
    });

    test('input without role warns', () {
      const node = InputNode(
        nodeId: 'input1',
        inputType: 'text',
        fieldId: 'name',
      );

      final diags = rules.validate(node);
      final roleWarnings = diags.where(
        (d) => d.code == DiagnosticCode.interactiveNodeMissingRole,
      );
      expect(roleWarnings, isNotEmpty);
    });

    test('input with role passes', () {
      const node = InputNode(
        nodeId: 'input1',
        inputType: 'text',
        fieldId: 'name',
        semantics: SchemaSemantics(role: 'textField'),
      );

      final diags = rules.validate(node);
      final roleWarnings = diags.where(
        (d) => d.code == DiagnosticCode.interactiveNodeMissingRole,
      );
      expect(roleWarnings, isEmpty);
    });

    test('image without alt or label warns', () {
      const node = ImageNode(
        nodeId: 'img1',
        src: DirectValue('https://example.com/img.png'),
      );

      final diags = rules.validate(node);
      final altWarnings = diags.where(
        (d) => d.code == DiagnosticCode.imageMissingAlt,
      );
      expect(altWarnings, isNotEmpty);
    });

    test('image with alt passes', () {
      const node = ImageNode(
        nodeId: 'img1',
        src: DirectValue('https://example.com/img.png'),
        alt: 'An example image',
      );

      final diags = rules.validate(node);
      final altWarnings = diags.where(
        (d) => d.code == DiagnosticCode.imageMissingAlt,
      );
      expect(altWarnings, isEmpty);
    });

    test('image with semantic label passes', () {
      const node = ImageNode(
        nodeId: 'img1',
        src: DirectValue('https://example.com/img.png'),
        semantics: SchemaSemantics(label: 'Example'),
      );

      final diags = rules.validate(node);
      final altWarnings = diags.where(
        (d) => d.code == DiagnosticCode.imageMissingAlt,
      );
      expect(altWarnings, isEmpty);
    });

    test('live region properties without mode warns', () {
      const node = BoxNode(
        nodeId: 'box1',
        semantics: SchemaSemantics(
          liveRegionAtomic: true,
          liveRegionRelevant: 'additions',
        ),
      );

      final diags = rules.validate(node);
      final modeWarnings = diags.where(
        (d) => d.code == DiagnosticCode.liveRegionMissingMode,
      );
      expect(modeWarnings, isNotEmpty);
    });

    test('live region with mode passes', () {
      const node = BoxNode(
        nodeId: 'box1',
        semantics: SchemaSemantics(
          liveRegionMode: 'polite',
          liveRegionAtomic: true,
        ),
      );

      final diags = rules.validate(node);
      final modeWarnings = diags.where(
        (d) => d.code == DiagnosticCode.liveRegionMissingMode,
      );
      expect(modeWarnings, isEmpty);
    });

    test('recursively validates nested nodes', () {
      const node = FlexNode(
        nodeId: 'flex1',
        children: [
          PressableNode(
            nodeId: 'press1',
            child: TextNode(nodeId: 't1', content: DirectValue('Click')),
          ),
          ImageNode(
            nodeId: 'img1',
            src: DirectValue('https://example.com'),
          ),
        ],
      );

      final diags = rules.validate(node);
      // Should have warnings for both pressable (role, label) and image (alt)
      expect(diags.length, greaterThanOrEqualTo(3));
    });

    test('text and icon nodes have no semantic rules', () {
      const node = FlexNode(
        nodeId: 'flex1',
        children: [
          TextNode(nodeId: 't1', content: DirectValue('hello')),
          IconNode(nodeId: 'i1', icon: DirectValue('star')),
        ],
      );

      final diags = rules.validate(node);
      expect(diags, isEmpty);
    });
  });
}
