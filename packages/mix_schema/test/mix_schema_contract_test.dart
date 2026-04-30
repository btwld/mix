import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('MixSchemaContract', () {
    test('builder can extend the built-in styler set before freeze', () {
      final builder = MixSchemaContractBuilder.builtIn()
        ..register(
          'demo',
          Ack.object({
            'value': Ack.integer(),
          }).transform<Object>((data) => data['value'] as int),
          fields: const ['value'],
        );

      expect(builder.registeredTypes, containsAll(const ['box', 'demo']));

      final contract = builder.freeze();
      final result = contract.decode({'type': 'demo', 'value': 42});
      final metadata = contract.exportMetadata();

      expect(result.ok, isTrue);
      expect(result.value, 42);
      expect(metadata.stylerTypes, contains('demo'));
      expect(metadata.stylerFields['demo'], const ['value']);
    });

    test('exports supported built-in styler types through metadata', () {
      final contract = MixSchemaContract.builtIn();
      final metadata = contract.exportMetadata();

      expect(metadata.stylerTypes, const [
        'box',
        'text',
        'flex',
        'icon',
        'image',
        'stack',
        'flex_box',
        'stack_box',
      ]);
    });

    test('exposes the frozen root Ack schema', () {
      final contract = MixSchemaContract.builtIn();

      expect(contract.rootSchema, isA<AckSchema<Object>>());

      final result = contract.rootSchema.safeParse({'type': 'box'});
      expect(result.isOk, isTrue);
    });

    test('validates valid payloads without errors', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({'type': 'box'});

      expect(result.ok, isTrue);
      expect(result.errors, isEmpty);
    });

    test('returns mapped validation errors for invalid payloads', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({'type': 'missing'});

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.unknownType);
      expect(result.errors.single.path, '#/type');
    });

    test('aggregates mixed invalid compound condition errors', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'named', 'name': 'primary'},
              {'type': 'context_brightness', 'brightness': 'missing'},
              {'type': 'context_variant_builder', 'id': 'builder'},
            ],
            'style': {
              'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
            },
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(
        result.errors.map((error) => (error.code, error.path)).toList(),
        containsAll(<(MixSchemaErrorCode, String)>[
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/0/type'),
          (
            MixSchemaErrorCode.invalidEnum,
            '#/variants/0/conditions/1/brightness',
          ),
          (MixSchemaErrorCode.unknownType, '#/variants/0/conditions/2/type'),
        ]),
      );
    });

    test(
      'preserves nested error paths for invalid compound condition fields',
      () {
        final contract = MixSchemaContract.builtIn();

        final result = contract.validate({
          'type': 'box',
          'variants': [
            {
              'type': 'context_all_of',
              'conditions': [
                {'type': 'context_brightness', 'brightness': 'missing'},
                {'type': 'widget_state', 'state': 'hovered'},
              ],
              'style': {
                'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
              },
            },
          ],
        });

        expect(result.ok, isFalse);
        expect(result.errors.single.code, MixSchemaErrorCode.invalidEnum);
        expect(
          result.errors.single.path,
          '#/variants/0/conditions/0/brightness',
        );
      },
    );

    test('validates compound variants require at least two conditions', () {
      final contract = MixSchemaContract.builtIn();

      final result = contract.validate({
        'type': 'box',
        'variants': [
          {
            'type': 'context_all_of',
            'conditions': [
              {'type': 'widget_state', 'state': 'hovered'},
            ],
            'style': {
              'constraints': {'minWidth': 200.0, 'maxWidth': 200.0},
            },
          },
        ],
      });

      expect(result.ok, isFalse);
      expect(result.errors.single.code, MixSchemaErrorCode.validationFailed);
      expect(result.errors.single.path, '#/variants/0/conditions');
    });

    test('exports metadata for producers and tooling', () {
      final contract = MixSchemaContract.builtIn();
      final metadata = contract.exportMetadata();

      expect(metadata.stylerTypes, const [
        'box',
        'text',
        'flex',
        'icon',
        'image',
        'stack',
        'flex_box',
        'stack_box',
      ]);
      expect(metadata.modifierTypes, const [
        'reset',
        'blur',
        'opacity',
        'visibility',
        'align',
        'padding',
        'scale',
        'rotate',
        'default_text_style',
      ]);
      expect(metadata.variantTypes, const [
        'named',
        'widget_state',
        'enabled',
        'context_brightness',
        'context_breakpoint',
        'context_all_of',
        'context_not_widget_state',
        'context_variant_builder',
      ]);
      expect(metadata.contextConditionTypes, const [
        'widget_state',
        'enabled',
        'context_brightness',
        'context_breakpoint',
        'context_not_widget_state',
        'context_all_of',
      ]);
      expect(metadata.topLevelMetadataFields, const [
        'animation',
        'modifiers',
        'modifierOrder',
        'variants',
      ]);
      expect(metadata.variantStyleMetadataFields, const [
        'modifiers',
        'modifierOrder',
      ]);
      expect(metadata.stylerFields['box'], const [
        'alignment',
        'padding',
        'margin',
        'constraints',
        'decoration',
        'foregroundDecoration',
        'transform',
        'transformAlignment',
        'clipBehavior',
      ]);
      expect(
        metadata.stylerFields['text'],
        containsAll(['style', 'textAlign']),
      );
      expect(metadata.unsupportedFields, {
        'icon': ['icon'],
      });
      expect(metadata.builtInScopes, isNotEmpty);
      expect(
        metadata.toJson(),
        containsPair('stylerTypes', metadata.stylerTypes),
      );
    });
  });
}
