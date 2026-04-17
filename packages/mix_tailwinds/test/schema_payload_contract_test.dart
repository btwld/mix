import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  group('schema payload contract', () {
    test('box utilities emit CSS-color payloads and decode successfully', () {
      final result = TwParser().parseBoxResult('bg-blue-500 p-4 rounded-md');

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.diagnostics, isEmpty);
      expect(result.payload, {
        'type': 'box',
        'padding': {'top': 16.0, 'right': 16.0, 'bottom': 16.0, 'left': 16.0},
        'decoration': {
          'type': 'box_decoration',
          'color': '#3B82F6FF',
          'borderRadius': {
            'type': 'border_radius',
            'topLeft': {'x': 6.0},
            'topRight': {'x': 6.0},
            'bottomLeft': {'x': 6.0},
            'bottomRight': {'x': 6.0},
          },
        },
      });
      expect(result.styler, isNotNull);
    });

    test('text utilities include textAlign in the schema payload', () {
      final result = TwParser().parseTextResult(
        'text-white font-bold text-center',
      );

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
      expect(result.diagnostics, isEmpty);
      expect(result.payload, {
        'type': 'text',
        'style': {'color': '#FFFFFFFF', 'fontWeight': 'w700', 'height': 1.5},
        'textAlign': 'center',
      });
      expect(result.styler, isNotNull);
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
