import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

import '../fixtures/valid/simple_box.dart';
import '../fixtures/invalid/invalid_payloads.dart';

void main() {
  late SchemaEngine engine;

  setUp(() {
    engine = SchemaEngine();
  });

  group('SchemaEngine', () {
    group('adapt', () {
      test('adapts v0.9 payload successfully', () {
        final result = engine.adapt(
          simpleBoxPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(result.root, isNotNull);
        expect(result.hasErrors, false);
      });

      test('throws for unknown adapter', () {
        expect(
          () => engine.adapt(simpleBoxPayload, adapterId: 'unknown'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles invalid payload', () {
        final result = engine.adapt(
          invalidNotAMap,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(result.root, isNull);
        expect(result.hasErrors, true);
      });

      test('respects trust parameter', () {
        final result = engine.adapt(
          simpleBoxPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
          trust: SchemaTrust.minimal,
        );

        expect(result.root, isNotNull);
      });
    });

    group('validate', () {
      test('valid schema passes validation', () {
        final adaptResult = engine.adapt(
          simpleBoxPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        final validResult = engine.validate(adaptResult.root!);
        expect(validResult.isValid, true);
      });

      test('schema with warnings is still valid', () {
        // Pressable without semantics generates warnings
        final adaptResult = engine.adapt(
          invalidPressableNoSemantics,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        final validResult = engine.validate(adaptResult.root!);
        expect(validResult.isValid, true);
        expect(validResult.diagnostics, isNotEmpty);
      });

      test('custom trust override', () {
        // Build a wide tree that fails minimal but passes standard
        final payload = buildWideTree(55);
        final adaptResult = engine.adapt(
          payload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        if (adaptResult.root != null) {
          final minResult = engine.validate(
            adaptResult.root!,
            trust: SchemaTrust.minimal,
          );
          // Should fail minimal due to node count
          expect(minResult.isValid, false);
        }
      });
    });

    group('end-to-end pipeline', () {
      test('adapt → validate → succeed for valid schema', () {
        final adaptResult = engine.adapt(
          cardLayoutPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(adaptResult.root, isNotNull);
        expect(adaptResult.hasErrors, false);

        final validResult = engine.validate(adaptResult.root!);
        expect(validResult.isValid, true);
      });

      test('adapt → validate for token-ref schema', () {
        final adaptResult = engine.adapt(
          tokenRefPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(adaptResult.root, isNotNull);
        final validResult = engine.validate(adaptResult.root!);
        expect(validResult.isValid, true);
      });

      test('adapt → validate for adaptive schema', () {
        final adaptResult = engine.adapt(
          adaptivePayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(adaptResult.root, isNotNull);
        final validResult = engine.validate(adaptResult.root!);
        expect(validResult.isValid, true);
      });

      test('adapt → validate for all-node-types schema', () {
        final adaptResult = engine.adapt(
          allNodeTypesPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );

        expect(adaptResult.root, isNotNull);
        expect(adaptResult.hasErrors, false);

        final validResult = engine.validate(adaptResult.root!);
        // May have semantic warnings (image alt, etc.) but no errors
        final errors = validResult.diagnostics.where(
          (d) => d.severity == DiagnosticSeverity.error,
        );
        expect(errors, isEmpty);
      });

    });

    group('custom configuration', () {
      test('custom adapters', () {
        final customEngine = SchemaEngine(
          adapters: [const A2uiV09Adapter()],
        );

        // v0.9 works
        final result = customEngine.adapt(
          simpleBoxPayload,
          adapterId: 'a2ui_v0_9_draft_latest',
        );
        expect(result.root, isNotNull);

        // unknown adapter throws
        expect(
          () => customEngine.adapt(
            simpleBoxPayload,
            adapterId: 'unknown',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
