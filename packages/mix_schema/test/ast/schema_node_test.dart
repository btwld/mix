import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('SchemaNode', () {
    test('BoxNode stores child and style', () {
      const node = BoxNode(
        nodeId: 'box1',
        style: {'color': DirectValue('#FF0000')},
        child: TextNode(nodeId: 'text1', content: DirectValue('hello')),
      );

      expect(node.nodeId, 'box1');
      expect(node.child, isA<TextNode>());
      expect(node.style!['color'], const DirectValue('#FF0000'));
    });

    test('TextNode requires content', () {
      const node = TextNode(
        nodeId: 'text1',
        content: DirectValue('Hello World'),
      );

      expect(node.nodeId, 'text1');
      expect(node.content, const DirectValue('Hello World'));
    });

    test('IconNode stores icon value', () {
      const node = IconNode(
        nodeId: 'icon1',
        icon: DirectValue('star'),
      );

      expect(node.nodeId, 'icon1');
      expect(node.icon, const DirectValue('star'));
    });

    test('ImageNode stores src and alt', () {
      const node = ImageNode(
        nodeId: 'img1',
        src: DirectValue('https://example.com/img.png'),
        alt: 'Example image',
      );

      expect(node.nodeId, 'img1');
      expect(node.src, const DirectValue('https://example.com/img.png'));
      expect(node.alt, 'Example image');
    });

    test('FlexNode stores children and layout props', () {
      const node = FlexNode(
        nodeId: 'flex1',
        children: [
          TextNode(nodeId: 't1', content: DirectValue('A')),
          TextNode(nodeId: 't2', content: DirectValue('B')),
        ],
        direction: DirectValue('column'),
        spacing: DirectValue(8.0),
      );

      expect(node.children.length, 2);
      expect(node.direction, const DirectValue('column'));
      expect(node.spacing, const DirectValue(8.0));
    });

    test('StackNode stores children and alignment', () {
      const node = StackNode(
        nodeId: 'stack1',
        children: [
          BoxNode(nodeId: 'b1'),
          BoxNode(nodeId: 'b2'),
        ],
        alignment: DirectValue('center'),
      );

      expect(node.children.length, 2);
      expect(node.alignment, const DirectValue('center'));
    });

    test('ScrollableNode stores child and direction', () {
      const node = ScrollableNode(
        nodeId: 'scroll1',
        child: FlexNode(nodeId: 'flex1', children: []),
        direction: DirectValue('vertical'),
      );

      expect(node.child, isA<FlexNode>());
      expect(node.direction, const DirectValue('vertical'));
    });

    test('WrapNode stores children and spacing', () {
      const node = WrapNode(
        nodeId: 'wrap1',
        children: [
          TextNode(nodeId: 't1', content: DirectValue('A')),
        ],
        spacing: DirectValue(4.0),
        runSpacing: DirectValue(8.0),
      );

      expect(node.children.length, 1);
      expect(node.spacing, const DirectValue(4.0));
      expect(node.runSpacing, const DirectValue(8.0));
    });

    test('PressableNode stores child and actionId', () {
      const node = PressableNode(
        nodeId: 'press1',
        child: TextNode(nodeId: 't1', content: DirectValue('Click')),
        actionId: 'submit',
      );

      expect(node.child, isA<TextNode>());
      expect(node.actionId, 'submit');
    });

    test('InputNode stores input type and field props', () {
      const node = InputNode(
        nodeId: 'input1',
        inputType: 'text',
        fieldId: 'email',
        label: DirectValue('Email'),
        hint: DirectValue('Enter email'),
      );

      expect(node.inputType, 'text');
      expect(node.fieldId, 'email');
      expect(node.label, const DirectValue('Email'));
      expect(node.hint, const DirectValue('Enter email'));
    });

    test('RepeatNode stores items, template, and alias', () {
      const node = RepeatNode(
        nodeId: 'repeat1',
        items: BindingValue('items'),
        template: TextNode(
          nodeId: 'tmpl',
          content: BindingValue('item.name'),
        ),
        itemAlias: 'item',
      );

      expect(node.items, const BindingValue('items'));
      expect(node.template, isA<TextNode>());
      expect(node.itemAlias, 'item');
    });

    test('SchemaAnimation stores duration, curve, delay', () {
      const anim = SchemaAnimation(
        durationMs: 300,
        curve: 'easeOut',
        delayMs: 50,
      );

      expect(anim.durationMs, 300);
      expect(anim.curve, 'easeOut');
      expect(anim.delayMs, 50);
    });

    test('SchemaAnimation equality', () {
      const a = SchemaAnimation(durationMs: 300, curve: 'easeOut');
      const b = SchemaAnimation(durationMs: 300, curve: 'easeOut');
      const c = SchemaAnimation(durationMs: 200, curve: 'easeOut');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });

    test('all node types are subtypes of SchemaNode', () {
      const nodes = <SchemaNode>[
        BoxNode(nodeId: 'b'),
        TextNode(nodeId: 't', content: DirectValue('x')),
        IconNode(nodeId: 'i', icon: DirectValue('star')),
        ImageNode(nodeId: 'im', src: DirectValue('url')),
        FlexNode(nodeId: 'f', children: []),
        StackNode(nodeId: 's', children: []),
        ScrollableNode(
          nodeId: 'sc',
          child: BoxNode(nodeId: 'scb'),
        ),
        WrapNode(nodeId: 'w', children: []),
        PressableNode(
          nodeId: 'p',
          child: BoxNode(nodeId: 'pb'),
        ),
        InputNode(nodeId: 'in', inputType: 'text', fieldId: 'f'),
        RepeatNode(
          nodeId: 'r',
          items: BindingValue('items'),
          template: BoxNode(nodeId: 'rt'),
        ),
      ];

      // All 11 node types
      expect(nodes.length, 11);
      for (final node in nodes) {
        expect(node, isA<SchemaNode>());
        expect(node.nodeId, isNotEmpty);
      }
    });

    test('node stores semantics', () {
      const node = BoxNode(
        nodeId: 'box1',
        semantics: SchemaSemantics(role: 'region', label: 'Content'),
      );

      expect(node.semantics?.role, 'region');
      expect(node.semantics?.label, 'Content');
    });

    test('node stores animation', () {
      const node = BoxNode(
        nodeId: 'box1',
        animation: SchemaAnimation(durationMs: 300, curve: 'easeOut'),
      );

      expect(node.animation?.durationMs, 300);
      expect(node.animation?.curve, 'easeOut');
    });

    test('node stores variants', () {
      const node = BoxNode(
        nodeId: 'box1',
        variants: {'hovered': DirectValue('true')},
      );

      expect(node.variants?['hovered'], const DirectValue('true'));
    });
  });

  group('SchemaSemantics', () {
    test('stores all base fields', () {
      const sem = SchemaSemantics(
        role: 'button',
        label: 'Submit',
        hint: 'Tap to submit',
        value: '0',
        enabled: true,
      );

      expect(sem.role, 'button');
      expect(sem.label, 'Submit');
      expect(sem.hint, 'Tap to submit');
      expect(sem.value, '0');
      expect(sem.enabled, true);
    });

    test('stores interactive fields', () {
      const sem = SchemaSemantics(
        selected: true,
        checked: false,
        expanded: true,
      );

      expect(sem.selected, true);
      expect(sem.checked, false);
      expect(sem.expanded, true);
    });

    test('stores ordering fields', () {
      const sem = SchemaSemantics(
        focusOrder: 1,
        labelledBy: 'label_node',
        describedBy: 'desc_node',
      );

      expect(sem.focusOrder, 1);
      expect(sem.labelledBy, 'label_node');
      expect(sem.describedBy, 'desc_node');
    });

    test('stores live region fields', () {
      const sem = SchemaSemantics(
        liveRegionMode: 'polite',
        liveRegionAtomic: true,
        liveRegionRelevant: 'additions',
        liveRegionBusy: false,
      );

      expect(sem.liveRegionMode, 'polite');
      expect(sem.liveRegionAtomic, true);
      expect(sem.liveRegionRelevant, 'additions');
      expect(sem.liveRegionBusy, false);
    });

    test('equality works correctly', () {
      const a = SchemaSemantics(role: 'button', label: 'Submit');
      const b = SchemaSemantics(role: 'button', label: 'Submit');
      const c = SchemaSemantics(role: 'heading', label: 'Title');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });
  });
}
