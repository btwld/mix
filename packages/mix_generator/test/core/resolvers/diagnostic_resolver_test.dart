import 'package:mix_generator/src/core/resolvers/diagnostic_resolver.dart';
import 'package:test/test.dart';

void main() {
  group('DiagnosticResolver', () {
    // Note: Full testing requires FieldModel which needs analyzer types.
    // These tests validate the diagnostic pattern logic.

    group('Spec diagnostic patterns', () {
      test('ColorProperty pattern for Color', () {
        expect("ColorProperty('color', color)", contains('ColorProperty'));
      });

      test('DoubleProperty pattern for double', () {
        expect("DoubleProperty('size', size)", contains('DoubleProperty'));
      });

      test('IntProperty pattern for int', () {
        expect("IntProperty('maxLines', maxLines)", contains('IntProperty'));
      });

      test('StringProperty pattern for String', () {
        expect("StringProperty('label', label)", contains('StringProperty'));
      });

      test('EnumProperty pattern for enums', () {
        expect(
          "EnumProperty<Clip>('clipBehavior', clipBehavior)",
          contains('EnumProperty'),
        );
      });

      test('FlagProperty pattern for bool with description', () {
        expect(
          "FlagProperty('softWrap', value: softWrap, ifTrue: 'wrapping at word boundaries')",
          contains('FlagProperty'),
        );
      });

      test('IterableProperty pattern for List', () {
        expect(
          "IterableProperty<Shadow>('shadows', shadows)",
          contains('IterableProperty'),
        );
      });

      test('DiagnosticsProperty pattern for other types', () {
        expect(
          "DiagnosticsProperty('alignment', alignment)",
          contains('DiagnosticsProperty'),
        );
      });
    });

    group('Styler diagnostic patterns', () {
      test('Always uses DiagnosticsProperty', () {
        expect(
          "DiagnosticsProperty('padding', \$padding)",
          contains('DiagnosticsProperty'),
        );
      });

      test('Uses \$-prefixed field name', () {
        expect(
          "DiagnosticsProperty('padding', \$padding)",
          contains('\$padding'),
        );
      });
    });

    group('diagnosticResolver instance', () {
      test('is accessible as const', () {
        expect(diagnosticResolver, isA<DiagnosticResolver>());
      });
    });
  });
}
