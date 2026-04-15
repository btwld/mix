import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/resolvers/diagnostic_resolver.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  group('DiagnosticResolver', () {
    group('generateSpecDiagnosticCode', () {
      test('generates ColorProperty for color fields', () {
        final field = createTestFieldModel(
          name: 'color',
          typeName: 'Color',
          diagnosticKind: DiagnosticKind.color,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("ColorProperty('color', color)"),
        );
      });

      test('generates DoubleProperty for double fields', () {
        final field = createTestFieldModel(
          name: 'size',
          typeName: 'double',
          diagnosticKind: DiagnosticKind.doubleProperty,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("DoubleProperty('size', size)"),
        );
      });

      test('generates IntProperty for int fields', () {
        final field = createTestFieldModel(
          name: 'maxLines',
          typeName: 'int',
          diagnosticKind: DiagnosticKind.intProperty,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("IntProperty('maxLines', maxLines)"),
        );
      });

      test('generates StringProperty for string fields', () {
        final field = createTestFieldModel(
          name: 'label',
          typeName: 'String',
          diagnosticKind: DiagnosticKind.stringProperty,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("StringProperty('label', label)"),
        );
      });

      test('generates EnumProperty for enum fields', () {
        final field = createTestFieldModel(
          name: 'clipBehavior',
          typeName: 'Clip',
          diagnosticKind: DiagnosticKind.enumProperty,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("EnumProperty<Clip>('clipBehavior', clipBehavior)"),
        );
      });

      test('generates FlagProperty when a flag description is available', () {
        final field = createTestFieldModel(
          name: 'softWrap',
          typeName: 'bool',
          diagnosticKind: DiagnosticKind.flagProperty,
          flagDescription: 'wrapping at word boundaries',
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals(
            "FlagProperty('softWrap', value: softWrap, ifTrue: 'wrapping at word boundaries')",
          ),
        );
      });

      test(
        'falls back to DiagnosticsProperty when a flag description is absent',
        () {
          final field = createTestFieldModel(
            name: 'softWrap',
            typeName: 'bool',
            diagnosticKind: DiagnosticKind.flagProperty,
          );

          expect(
            diagnosticResolver.generateSpecDiagnosticCode(field),
            equals("DiagnosticsProperty('softWrap', softWrap)"),
          );
        },
      );

      test('generates IterableProperty with the list element type', () {
        final field = createTestFieldModel(
          name: 'shadows',
          typeName: 'List<Shadow>',
          isList: true,
          listElementType: 'Shadow',
          diagnosticKind: DiagnosticKind.iterableProperty,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("IterableProperty<Shadow>('shadows', shadows)"),
        );
      });

      test('uses diagnosticLabel as the display name when provided', () {
        final field = createTestFieldModel(
          name: 'textDirectives',
          typeName: 'List<String>',
          isList: true,
          listElementType: 'String',
          diagnosticKind: DiagnosticKind.iterableProperty,
          diagnosticLabel: 'directives',
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("IterableProperty<String>('directives', textDirectives)"),
        );
      });

      test(
        'falls back to IterableProperty<Object> when element type is absent',
        () {
          final field = createTestFieldModel(
            name: 'items',
            typeName: 'List<Object>',
            isList: true,
            diagnosticKind: DiagnosticKind.iterableProperty,
          );

          expect(
            diagnosticResolver.generateSpecDiagnosticCode(field),
            equals("IterableProperty<Object>('items', items)"),
          );
        },
      );

      test('generates DiagnosticsProperty for unhandled diagnostic kinds', () {
        final field = createTestFieldModel(
          name: 'alignment',
          typeName: 'AlignmentGeometry',
          diagnosticKind: DiagnosticKind.diagnostics,
        );

        expect(
          diagnosticResolver.generateSpecDiagnosticCode(field),
          equals("DiagnosticsProperty('alignment', alignment)"),
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
