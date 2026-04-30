import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('Public API contract', () {
    test('exports the intended core contract types', () {
      final builder = MixSchemaContractBuilder.builtIn();
      final contract = MixSchemaContract.builtIn();
      final frozenRegistry = FrozenRegistry<Object>(scope: 'demo', values: {});
      final validation = MixSchemaValidationResult.success();

      expect(builder, isA<MixSchemaContractBuilder>());
      expect(contract, isA<MixSchemaContract>());
      expect(frozenRegistry, isA<FrozenRegistry<Object>>());
      expect(validation, isA<MixSchemaValidationResult>());
      expect(
        RegistryBuilder<Object>(scope: 'custom'),
        isA<RegistryBuilder<Object>>(),
      );
    });

    test('exposes stable built-in registry scopes', () {
      expect(
        MixSchemaScope.values.map((scope) => scope.wireValue).toList(),
        const [
          'animation_on_end',
          'image_provider',
          'modifier_shader',
          'modifier_clipper',
          'context_variant_builder',
        ],
      );
    });

    test('exports stable built-in styler types through the contract', () {
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

    test('exports minimal metadata for producers and tooling', () {
      final contract = MixSchemaContract.builtIn();
      final metadata = contract.exportMetadata();

      expect(metadata, isA<MixSchemaExportMetadata>());
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
      expect(metadata.stylerFields['flex'], const [
        'direction',
        'mainAxisAlignment',
        'crossAxisAlignment',
        'mainAxisSize',
        'verticalDirection',
        'textDirection',
        'textBaseline',
        'clipBehavior',
        'spacing',
      ]);
      expect(metadata.stylerFields['stack'], const [
        'alignment',
        'fit',
        'textDirection',
        'clipBehavior',
      ]);
      expect(metadata.stylerFields['flex_box'], const [
        'decoration',
        'foregroundDecoration',
        'padding',
        'margin',
        'alignment',
        'constraints',
        'transform',
        'transformAlignment',
        'clipBehavior',
        'direction',
        'mainAxisAlignment',
        'crossAxisAlignment',
        'mainAxisSize',
        'verticalDirection',
        'textDirection',
        'textBaseline',
        'flexClipBehavior',
        'spacing',
      ]);
      expect(metadata.stylerFields['stack_box'], const [
        'decoration',
        'foregroundDecoration',
        'padding',
        'margin',
        'alignment',
        'constraints',
        'transform',
        'transformAlignment',
        'clipBehavior',
        'stackAlignment',
        'fit',
        'textDirection',
        'stackClipBehavior',
      ]);
      expect(metadata.unsupportedFields, {
        'icon': ['icon'],
      });
      expect(
        metadata.builtInScopes,
        MixSchemaScope.values.map((scope) => scope.wireValue).toList(),
      );
      expect(metadata.toJson(), {
        'stylerTypes': metadata.stylerTypes,
        'modifierTypes': metadata.modifierTypes,
        'variantTypes': metadata.variantTypes,
        'contextConditionTypes': metadata.contextConditionTypes,
        'topLevelMetadataFields': metadata.topLevelMetadataFields,
        'variantStyleMetadataFields': metadata.variantStyleMetadataFields,
        'stylerFields': metadata.stylerFields,
        'unsupportedFields': metadata.unsupportedFields,
        'builtInScopes': MixSchemaScope.values
            .map((scope) => scope.wireValue)
            .toList(),
      });
    });

    test('keeps the stable public error vocabulary', () {
      expect(MixSchemaErrorCode.values.map((code) => code.wireValue).toSet(), {
        'type_mismatch',
        'required_field',
        'unknown_field',
        'invalid_enum',
        'constraint_violation',
        'validation_failed',
        'transform_failed',
        'unknown_type',
        'unknown_registry_id',
        'unsupported_value_type',
      });
    });

    test('keeps wire-type identifiers off the root contract surface', () {
      final source = File('lib/mix_schema.dart').readAsStringSync();

      expect(source, isNot(contains('schema_wire_types.dart')));
    });

    test('keeps wire-type identifiers on the producer surface', () {
      final source = File('lib/encode.dart').readAsStringSync();

      expect(source, contains('schema_wire_types.dart'));
    });

    test('keeps styler registry construction off the contract-facing APIs', () {
      final contractSource = File(
        'lib/src/contract/mix_schema_contract.dart',
      ).readAsStringSync();

      expect(
        contractSource,
        isNot(
          contains(
            'MixSchemaContract({required StylerRegistry stylerRegistry})',
          ),
        ),
      );
      expect(contractSource, contains('MixSchemaContractBuilder'));
    });

    test('keeps StylerRegistry off the root contract surface', () {
      final source = File('lib/mix_schema.dart').readAsStringSync();

      expect(source, isNot(contains('styler_registry.dart')));
    });
  });
}
