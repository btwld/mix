import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('ComponentRegistry', () {
    late ComponentRegistry registry;

    setUp(() {
      registry = ComponentRegistry.defaults();
    });

    test('defaults has 5 registered components', () {
      final types = ['Card', 'Button', 'TextInput', 'Table', 'ActionGroup'];
      for (final type in types) {
        final result = registry.expand(type, {}, 'test');
        expect(result, isNotNull, reason: '$type should be registered');
      }
    });

    test('unknown component returns null', () {
      final result = registry.expand('Carousel', {}, 'test');
      expect(result, isNull);
    });

    group('Card expansion', () {
      test('expands to box with flex child', () {
        final node = registry.expand('Card', {
          'title': 'My Card',
          'subtitle': 'A subtitle',
        }, 'card1');

        expect(node, isA<BoxNode>());
        final box = node as BoxNode;
        expect(box.child, isA<FlexNode>());
      });

      test('card without subtitle omits subtitle text', () {
        final node = registry.expand('Card', {
          'title': 'My Card',
        }, 'card1');

        final box = node as BoxNode;
        final flex = box.child as FlexNode;
        // Only title + no subtitle = 1 child (title)
        expect(flex.children.length, 1);
      });

      test('card with children includes them', () {
        final node = registry.expand('Card', {
          'title': 'My Card',
          'children': <SchemaNode>[
            const TextNode(nodeId: 'extra', content: DirectValue('Extra')),
          ],
        }, 'card1');

        final box = node as BoxNode;
        final flex = box.child as FlexNode;
        // title + extra child = 2
        expect(flex.children.length, 2);
      });
    });

    group('Button expansion', () {
      test('expands to pressable with text', () {
        final node = registry.expand('Button', {
          'label': 'Click Me',
          'actionId': 'submit',
        }, 'btn1');

        expect(node, isA<PressableNode>());
        final pressable = node as PressableNode;
        expect(pressable.actionId, 'submit');
        expect(pressable.child, isA<BoxNode>());
      });
    });

    group('TextInput expansion', () {
      test('expands to InputNode', () {
        final node = registry.expand('TextInput', {
          'id': 'email_field',
          'label': 'Email',
          'hint': 'Enter email',
        }, 'input1');

        expect(node, isA<InputNode>());
        final input = node as InputNode;
        expect(input.inputType, 'text');
        expect(input.fieldId, 'email_field');
      });
    });

    group('Table expansion', () {
      test('expands to flex with header and repeat', () {
        final node = registry.expand('Table', {
          'columns': ['Name', 'Age'],
          'rows': 'users',
        }, 'table1');

        expect(node, isA<FlexNode>());
        final flex = node as FlexNode;
        expect(flex.children.length, 2); // header + rows
        expect(flex.children[0], isA<FlexNode>()); // header row
        expect(flex.children[1], isA<RepeatNode>()); // data rows
      });
    });

    group('ActionGroup expansion', () {
      test('expands to flex row', () {
        final node = registry.expand('ActionGroup', {
          'children': <SchemaNode>[
            const TextNode(nodeId: 'a1', content: DirectValue('Cancel')),
            const TextNode(nodeId: 'a2', content: DirectValue('OK')),
          ],
          'alignment': 'end',
        }, 'ag1');

        expect(node, isA<FlexNode>());
        final flex = node as FlexNode;
        expect(flex.children.length, 2);
      });
    });

    test('custom registry', () {
      final custom = ComponentRegistry({
        'MyWidget': (props, nodeId) => BoxNode(nodeId: '${nodeId}_custom'),
      });

      final result = custom.expand('MyWidget', {}, 'test');
      expect(result, isA<BoxNode>());
      expect((result as BoxNode).nodeId, 'test_custom');

      // Default components not available
      expect(custom.expand('Card', {}, 'test'), isNull);
    });
  });
}
