import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/validate/structural_rules.dart';

void main() {
  const rules = StructuralRules();

  group('StructuralRules', () {
    test('valid box node passes', () {
      const node = BoxNode(
        nodeId: 'box1',
        child: TextNode(nodeId: 'text1', content: DirectValue('hello')),
      );

      final diags = rules.validate(node);
      expect(diags, isEmpty);
    });

    test('text node with null content fails', () {
      const node = TextNode(
        nodeId: 'text1',
        content: DirectValue(null),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.code, DiagnosticCode.missingRequiredField);
      expect(diags.first.nodeId, 'text1');
    });

    test('icon node with null icon fails', () {
      const node = IconNode(
        nodeId: 'icon1',
        icon: DirectValue(null),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.code, DiagnosticCode.missingRequiredField);
    });

    test('image node with null src fails', () {
      const node = ImageNode(
        nodeId: 'img1',
        src: DirectValue(null),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.code, DiagnosticCode.missingRequiredField);
    });

    test('valid flex node passes', () {
      const node = FlexNode(
        nodeId: 'flex1',
        children: [
          TextNode(nodeId: 't1', content: DirectValue('A')),
          TextNode(nodeId: 't2', content: DirectValue('B')),
        ],
      );

      final diags = rules.validate(node);
      expect(diags, isEmpty);
    });

    test('recursively validates children in flex', () {
      const node = FlexNode(
        nodeId: 'flex1',
        children: [
          TextNode(nodeId: 't1', content: DirectValue('ok')),
          TextNode(nodeId: 't2', content: DirectValue(null)),
        ],
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.nodeId, 't2');
    });

    test('recursively validates children in stack', () {
      const node = StackNode(
        nodeId: 'stack1',
        children: [
          ImageNode(nodeId: 'img1', src: DirectValue(null)),
        ],
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
    });

    test('recursively validates scrollable child', () {
      const node = ScrollableNode(
        nodeId: 'scroll1',
        child: TextNode(nodeId: 't1', content: DirectValue(null)),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
    });

    test('recursively validates wrap children', () {
      const node = WrapNode(
        nodeId: 'wrap1',
        children: [
          IconNode(nodeId: 'i1', icon: DirectValue(null)),
        ],
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
    });

    test('recursively validates pressable child', () {
      const node = PressableNode(
        nodeId: 'press1',
        child: TextNode(nodeId: 't1', content: DirectValue(null)),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
    });

    test('input node with unknown type warns', () {
      const node = InputNode(
        nodeId: 'input1',
        inputType: 'color_picker',
        fieldId: 'color',
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.severity, DiagnosticSeverity.warning);
      expect(diags.first.code, DiagnosticCode.invalidValueType);
    });

    test('input node with valid types passes', () {
      for (final type in ['text', 'toggle', 'slider', 'select', 'date']) {
        final node = InputNode(
          nodeId: 'input_$type',
          inputType: type,
          fieldId: 'field',
        );

        final diags = rules.validate(node);
        expect(diags, isEmpty, reason: '$type should be valid');
      }
    });

    test('repeat node with string items warns', () {
      const node = RepeatNode(
        nodeId: 'repeat1',
        items: DirectValue('not_a_binding'),
        template: TextNode(nodeId: 't1', content: DirectValue('ok')),
      );

      final diags = rules.validate(node);
      expect(diags.length, 1);
      expect(diags.first.severity, DiagnosticSeverity.warning);
    });

    test('repeat node with binding items passes', () {
      const node = RepeatNode(
        nodeId: 'repeat1',
        items: BindingValue('items'),
        template: TextNode(nodeId: 't1', content: DirectValue('ok')),
      );

      final diags = rules.validate(node);
      expect(diags, isEmpty);
    });

    test('deeply nested valid tree passes', () {
      const node = BoxNode(
        nodeId: 'b1',
        child: FlexNode(
          nodeId: 'f1',
          children: [
            StackNode(
              nodeId: 's1',
              children: [
                TextNode(nodeId: 't1', content: DirectValue('deep')),
              ],
            ),
          ],
        ),
      );

      final diags = rules.validate(node);
      expect(diags, isEmpty);
    });
  });
}
