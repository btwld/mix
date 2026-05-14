import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  group('schema payload contract', () {
    test('JSON Schema covers the fields the parser emits', () {
      final schema = MixSchemaContract.builtIn().exportJsonSchema();
      final boxProperties = _branchProperties(schema, 'box');
      final textProperties = _branchProperties(schema, 'text');

      expect(boxProperties, contains('padding'));
      expect(boxProperties, contains('decoration'));
      expect(boxProperties, contains('variants'));
      expect(boxProperties, contains('modifiers'));
      expect(boxProperties, contains('modifierOrder'));
      expect(textProperties, contains('style'));
      expect(textProperties, contains('textAlign'));
    });

    test('box utilities emit CSS-color payloads and decode successfully', () {
      final result = TwParser().parseBoxResult('bg-blue-500 p-4 rounded-md');

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.diagnostics, isEmpty);
      expect(result.styler, isNotNull);

      expect(result.payload['type'], 'box');
      expect(result.payload['padding'], {
        'top': 16.0,
        'right': 16.0,
        'bottom': 16.0,
        'left': 16.0,
      });

      final decoration = result.payload['decoration'] as Map<Object?, Object?>;
      expect(decoration['type'], 'box_decoration');
      expect(decoration['color'], '#3B82F6FF');

      final radius = decoration['borderRadius'] as Map<Object?, Object?>;
      expect(radius['type'], 'border_radius');
      expect(radius['topLeft'], {'x': 6.0});
    });

    test('text utilities include textAlign in the schema payload', () {
      final result = TwParser().parseTextResult(
        'text-white font-bold text-center',
      );

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.diagnostics, isEmpty);
      expect(result.styler, isNotNull);

      expect(result.payload['type'], 'text');
      expect(result.payload['textAlign'], 'center');

      final style = result.payload['style'] as Map<Object?, Object?>;
      expect(style['color'], '#FFFFFFFF');
      expect(style['fontWeight'], 'w700');
      expect(style['height'], 1.5);
    });

    test('Tailwind gradient directions map to neutral schema values', () {
      final result = TwParser().parseBoxResult(
        'bg-gradient-to-br from-slate-900 to-white',
      );

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);

      final decoration = result.payload['decoration'] as Map<Object?, Object?>;
      final gradient = decoration['gradient'] as Map<Object?, Object?>;
      final transform = gradient['transform'] as Map<Object?, Object?>;

      expect(transform['type'], 'css_linear_keyword_transform');
      expect(transform['direction'], 'to_bottom_right');
    });

    test('unknown variants are diagnostics and do not emit global styles', () {
      final result = TwParser().parseBoxResult('foo:bg-blue-500');

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.payload, {'type': 'box'});
      expect(result.diagnostics, hasLength(1));
      expect(result.diagnostics.single.code, TwDiagnosticCode.unknownVariant);
      expect(result.diagnostics.single.token, 'foo:bg-blue-500');
    });

    test('unknown tokens are diagnostics, not exceptions', () {
      final result = TwParser().parseBoxResult('bg-blu-500');

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.payload, {'type': 'box'});
      expect(result.diagnostics, hasLength(1));
      expect(result.diagnostics.single.code, TwDiagnosticCode.unknownToken);
      expect(result.diagnostics.single.token, 'bg-blu-500');
    });
  });
}

Map<Object?, Object?> _branchProperties(
  Map<String, Object?> schema,
  String type,
) {
  final branches = schema['anyOf'] as List<Object?>;
  final branch = branches.cast<Map<Object?, Object?>>().singleWhere((branch) {
    final properties = branch['properties']! as Map<Object?, Object?>;
    final typeProperty = properties['type']! as Map<Object?, Object?>;

    return typeProperty['const'] == type;
  });

  return branch['properties']! as Map<Object?, Object?>;
}
