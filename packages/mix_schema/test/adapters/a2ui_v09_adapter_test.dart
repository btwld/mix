import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

import '../fixtures/valid/simple_box.dart';
import '../fixtures/invalid/invalid_payloads.dart';

void main() {
  late A2uiV09Adapter adapter;

  setUp(() {
    adapter = const A2uiV09Adapter();
  });

  group('A2uiV09Adapter', () {
    test('id and supportedVersions', () {
      expect(adapter.id, 'a2ui_v0_9_draft_latest');
      expect(adapter.supportedVersions, ['0.9']);
    });

    group('adapt', () {
      test('simple box payload succeeds', () {
        final result = adapter.adapt(
          simpleBoxPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        expect(result.hasErrors, false);
        expect(result.root!.id, 'test_simple_box');
        expect(result.root!.trust, SchemaTrust.standard);

        final rootNode = result.root!.root;
        expect(rootNode, isA<BoxNode>());
        final box = rootNode as BoxNode;
        expect(box.nodeId, 'root_box');
        expect(box.child, isA<TextNode>());
      });

      test('card layout payload succeeds', () {
        final result = adapter.adapt(
          cardLayoutPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        expect(result.hasErrors, false);

        final box = result.root!.root as BoxNode;
        final flex = box.child as FlexNode;
        expect(flex.children.length, 3);
        expect(flex.children[0], isA<TextNode>());
        expect(flex.children[1], isA<TextNode>());
        expect(flex.children[2], isA<PressableNode>());
      });

      test('parses token references from shorthand', () {
        final result = adapter.adapt(
          tokenRefPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final box = result.root!.root as BoxNode;
        expect(box.style!['color'], isA<TokenRef>());
        final colorToken = box.style!['color'] as TokenRef;
        expect(colorToken.type, 'color');
        expect(colorToken.name, 'primary');
      });

      test('parses adaptive values', () {
        final result = adapter.adapt(
          adaptivePayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final box = result.root!.root as BoxNode;
        expect(box.style!['color'], isA<AdaptiveValue>());
        final adaptive = box.style!['color'] as AdaptiveValue;
        expect(adaptive.light, const DirectValue('#FFFFFF'));
        expect(adaptive.dark, const DirectValue('#000000'));
      });

      test('parses responsive values', () {
        final result = adapter.adapt(
          responsivePayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final flex = result.root!.root as FlexNode;
        expect(flex.direction, isA<ResponsiveValue>());
        final rv = flex.direction as ResponsiveValue;
        expect(rv.breakpoints['mobile'], const DirectValue('column'));
        expect(rv.breakpoints['desktop'], const DirectValue('row'));
      });

      test('parses binding values', () {
        final result = adapter.adapt(
          bindingPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final flex = result.root!.root as FlexNode;
        final textNode = flex.children[0] as TextNode;
        expect(textNode.content, isA<BindingValue>());
        expect((textNode.content as BindingValue).path, 'user.name');
      });

      test('parses repeat node', () {
        final result = adapter.adapt(
          repeatPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final flex = result.root!.root as FlexNode;
        expect(flex.children[0], isA<RepeatNode>());
        final repeat = flex.children[0] as RepeatNode;
        expect(repeat.items, isA<BindingValue>());
        expect(repeat.template, isA<TextNode>());
      });

      test('parses animation', () {
        final result = adapter.adapt(
          animatedPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final box = result.root!.root as BoxNode;
        expect(box.animation, isNotNull);
        expect(box.animation!.durationMs, 300);
        expect(box.animation!.curve, 'easeOut');
      });

      test('parses all 11 node types', () {
        final result = adapter.adapt(
          allNodeTypesPayload,
          const AdaptContext(trust: SchemaTrust.elevated),
        );

        expect(result.root, isNotNull);
        expect(result.hasErrors, false);
        expect(result.root!.root, isA<ScrollableNode>());
      });

      test('parses environment data', () {
        final result = adapter.adapt(
          bindingPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root?.environment, isNotNull);
        expect(result.root?.environment?.data?['user'], isNotNull);
      });

      test('parses semantics', () {
        final result = adapter.adapt(
          cardLayoutPayload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        final box = result.root!.root as BoxNode;
        final flex = box.child as FlexNode;
        final pressable = flex.children[2] as PressableNode;
        expect(pressable.semantics?.role, 'button');
        expect(pressable.semantics?.label, 'Submit');
      });

      test('rejects non-map payload', () {
        final result = adapter.adapt(
          invalidNotAMap,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(result.hasErrors, true);
        expect(result.diagnostics.first.code, DiagnosticCode.invalidValueType);
      });

      test('rejects payload missing root', () {
        final result = adapter.adapt(
          invalidMissingRoot,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(result.hasErrors, true);
        expect(
            result.diagnostics.first.code, DiagnosticCode.missingRequiredField);
      });

      test('reports unknown node type', () {
        final result = adapter.adapt(
          invalidUnknownNodeType,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(result.diagnostics.any(
          (d) => d.code == DiagnosticCode.unknownNodeType,
        ), true);
      });

      test('reports missing type field', () {
        final result = adapter.adapt(
          invalidMissingType,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(result.diagnostics.any(
          (d) => d.code == DiagnosticCode.missingRequiredField,
        ), true);
      });

      test('warns on wrong wire version', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.7',
          'trust': 'standard',
          'root': {
            'type': 'text',
            'nodeId': 'text1',
            'content': 'hello',
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(
          result.diagnostics.any(
            (d) => d.code == DiagnosticCode.unsupportedWireVersion,
          ),
          true,
        );
      });

      test('reports missing child for scrollable', () {
        final result = adapter.adapt(
          invalidScrollableNoChild,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
      });
    });

    group('lossy adaptation diagnostics', () {
      test('emits unsupportedWireVersion for non-0.9 version', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '1.0',
          'trust': 'standard',
          'root': {
            'type': 'text',
            'nodeId': 'text1',
            'content': 'hello',
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        expect(
          result.diagnostics.any(
            (d) =>
                d.code == DiagnosticCode.unsupportedWireVersion &&
                d.severity == DiagnosticSeverity.warning,
          ),
          true,
        );
      });

      test('generates auto nodeId when missing', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'text',
            // no nodeId — should auto-generate
            'content': 'hello',
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        expect(result.root!.root.nodeId, 'root_auto');
      });

      test('handles repeat node missing template gracefully', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'repeat',
            'nodeId': 'rep1',
            'items': ['a', 'b'],
            // missing template
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(
          result.diagnostics.any(
            (d) => d.code == DiagnosticCode.missingRequiredField,
          ),
          true,
        );
      });

      test('handles pressable without child', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'pressable',
            'nodeId': 'btn1',
            // missing child
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNull);
        expect(
          result.diagnostics.any(
            (d) => d.code == DiagnosticCode.missingRequiredField,
          ),
          true,
        );
      });

      test('parses variants block correctly', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'box',
            'nodeId': 'box1',
            'style': {'color': '#FF0000'},
            'variants': {
              'dark': {'color': '#0000FF'},
              'hovered': {'color': '#00FF00'},
            },
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final box = result.root!.root as BoxNode;
        expect(box.variants, isNotNull);
        expect(box.variants!.containsKey('dark'), true);
        expect(box.variants!.containsKey('hovered'), true);
      });

      test('parses transform value', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'text',
            'nodeId': 't1',
            'content': {'bind': 'price', 'transform': 'currency'},
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final text = result.root!.root as TextNode;
        expect(text.content, isA<TransformValue>());
        final tv = text.content as TransformValue;
        expect(tv.path, 'price');
        expect(tv.transformKey, 'currency');
      });

      test('handles multiple semantic fields', () {
        final payload = <String, dynamic>{
          'id': 'test',
          'version': '0.9',
          'trust': 'standard',
          'root': {
            'type': 'pressable',
            'nodeId': 'btn1',
            'child': {
              'type': 'text',
              'nodeId': 't1',
              'content': 'Click',
            },
            'semantics': {
              'role': 'button',
              'label': 'Submit',
              'hint': 'Double tap to submit',
              'enabled': true,
              'selected': false,
              'expanded': true,
              'focusOrder': 1,
              'liveRegionMode': 'polite',
              'liveRegionAtomic': true,
            },
          },
        };

        final result = adapter.adapt(
          payload,
          const AdaptContext(trust: SchemaTrust.standard),
        );

        expect(result.root, isNotNull);
        final pressable = result.root!.root as PressableNode;
        final sem = pressable.semantics!;
        expect(sem.role, 'button');
        expect(sem.label, 'Submit');
        expect(sem.hint, 'Double tap to submit');
        expect(sem.enabled, true);
        expect(sem.selected, false);
        expect(sem.expanded, true);
        expect(sem.focusOrder, 1);
        expect(sem.liveRegionMode, 'polite');
        expect(sem.liveRegionAtomic, true);
      });
    });
  });

  group('normalizeValue', () {
    test('null becomes DirectValue(null)', () {
      expect(normalizeValue(null), const DirectValue(null));
    });

    test('number becomes DirectValue', () {
      final intResult = normalizeValue(42);
      expect(intResult, isA<DirectValue<num>>());
      expect((intResult as DirectValue<num>).value, 42);

      final doubleResult = normalizeValue(3.14);
      expect(doubleResult, isA<DirectValue<num>>());
      expect((doubleResult as DirectValue<num>).value, 3.14);
    });

    test('bool becomes DirectValue', () {
      expect(normalizeValue(true), const DirectValue(true));
    });

    test('plain string becomes DirectValue', () {
      expect(normalizeValue('hello'), const DirectValue('hello'));
    });

    test('token shorthand becomes TokenRef', () {
      final result = normalizeValue('color.primary');
      expect(result, isA<TokenRef>());
      final ref = result as TokenRef;
      expect(ref.type, 'color');
      expect(ref.name, 'primary');
    });

    test('known token types are detected', () {
      final types = [
        'color',
        'space',
        'radius',
        'textStyle',
        'borderSide',
        'shadow',
        'boxShadow',
        'fontWeight',
        'duration',
        'breakpoint',
        'double',
      ];

      for (final type in types) {
        final result = normalizeValue('$type.test');
        expect(result, isA<TokenRef>(),
            reason: '$type should produce TokenRef');
      }
    });

    test('non-token dotted string stays DirectValue', () {
      final result = normalizeValue('user.name');
      expect(result, const DirectValue('user.name'));
    });

    test('explicit token object becomes TokenRef', () {
      final result = normalizeValue({
        'token': {'type': 'color', 'name': 'primary'},
      });
      expect(result, const TokenRef(type: 'color', name: 'primary'));
    });

    test('adaptive map becomes AdaptiveValue', () {
      final result = normalizeValue({
        'adaptive': {'light': '#000', 'dark': '#FFF'},
      });
      expect(result, isA<AdaptiveValue>());
    });

    test('responsive map becomes ResponsiveValue', () {
      final result = normalizeValue({
        'responsive': {'mobile': 8, 'desktop': 24},
      });
      expect(result, isA<ResponsiveValue>());
    });

    test('bind becomes BindingValue', () {
      final result = normalizeValue({'bind': 'user.name'});
      expect(result, const BindingValue('user.name'));
    });

    test('bind + transform becomes TransformValue', () {
      final result = normalizeValue({
        'bind': 'price',
        'transform': 'currency',
      });
      expect(result, isA<TransformValue>());
      final tv = result as TransformValue;
      expect(tv.path, 'price');
      expect(tv.transformKey, 'currency');
    });
  });
}
